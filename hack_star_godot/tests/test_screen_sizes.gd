extends GutTest
## Every screen fits desktop, iPad and phone sizes in landscape and portrait (spec 03, D5),
## and Play and Back react to a mouse click and to a touch.

const HOME_SCENE: PackedScene = preload("res://scenes/home.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const ArenaScript: GDScript = preload("res://scenes/arena.gd")
const SIZES: Dictionary = {
	"desktop 1280x720": Vector2i(1280, 720),
	"iPad landscape 1180x820": Vector2i(1180, 820),
	"iPad portrait 820x1180": Vector2i(820, 1180),
	"phone portrait 390x844": Vector2i(390, 844),
	"phone landscape 844x390": Vector2i(844, 390),
}


## The window's content scale as the project sets it (`canvas_items`, `expand`): the scene is
## laid out in a rectangle of the base aspect or wider/taller, then scaled to the window.
func _content_size(window_size: Vector2i) -> Vector2:
	assert_eq(ProjectSettings.get_setting("display/window/stretch/mode"), "canvas_items")
	assert_eq(ProjectSettings.get_setting("display/window/stretch/aspect"), "expand")
	var base: Vector2 = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	var scale: float = minf(window_size.x / base.x, window_size.y / base.y)
	return Vector2(window_size) / scale


func _show_in_viewport(scene: PackedScene, size: Vector2i) -> Array:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = size
	viewport.size_2d_override = Vector2i(_content_size(size).round())
	viewport.size_2d_override_stretch = true
	add_child_autofree(viewport)
	var root: Node = scene.instantiate()
	viewport.add_child(root)
	await wait_process_frames(2)
	return [viewport, root]


func _assert_inside(control: Control, visible_rect: Rect2, label: String) -> void:
	var rect: Rect2 = control.get_global_rect()
	assert_true(visible_rect.encloses(rect), "%s %s is inside %s" % [label, rect, visible_rect])


func _click(viewport: SubViewport, control: Control) -> void:
	var position: Vector2 = control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event: InputEventMouseButton = InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed else 0
		event.position = position
		event.global_position = position
		viewport.push_input(event, true)


func _touch(viewport: SubViewport, control: Control) -> void:
	var position: Vector2 = control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event: InputEventScreenTouch = InputEventScreenTouch.new()
		event.index = 0
		event.pressed = pressed
		event.position = position
		viewport.push_input(event, true)


## Without leaving the test scene: the screen's own handler would change the scene.
func _drop_handlers(button: Button) -> void:
	for connection: Dictionary in button.pressed.get_connections():
		button.pressed.disconnect(connection["callable"])


func test_home_fits_every_size() -> void:
	var paths: Array[String] = [
		"Margin/Column/TopBar/TrophiesLabel",
		"Margin/Column/TopBar/CreditsLabel",
		"Margin/Column/Title",
		"Margin/Column/Body/FighterStage",
		"Margin/Column/Body/Controls/NameRow/NameLabel",
		"Margin/Column/Body/Controls/NameRow/PrestigeBadge",
		"Margin/Column/Body/Controls/PlayButton",
		"Margin/Column/Body/Controls/MoreRow/FightersButton",
		"Margin/Column/Body/Controls/MoreRow/InfoButton",
	]
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(HOME_SCENE, size)
		var screen: Control = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		for path: String in paths:
			_assert_inside(screen.get_node(path), visible_rect, "%s %s" % [label, path])
		shown[0].queue_free()


func test_arena_fits_every_size() -> void:
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(ARENA_SCENE, size)
		var arena: Node3D = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		_assert_inside(arena.get_node("Hud/BackButton"), visible_rect, "%s Back" % label)
		var joystick: TouchJoystick = arena.get_node("Hud/TouchJoystick")
		_assert_inside(joystick, visible_rect, "%s joystick" % label)
		_assert_inside(arena.get_node("Hud/FpsLabel"), visible_rect, "%s FPS label" % label)
		var camera: Camera3D = arena.get_node("Camera")
		for corner: Vector3 in ArenaScript.ARENA_CORNERS:
			assert_true(
				visible_rect.has_point(camera.unproject_position(corner)),
				"%s corner %s in view" % [label, corner]
			)
		shown[0].queue_free()


func test_play_reacts_to_mouse_click() -> void:
	var shown: Array = await _show_in_viewport(HOME_SCENE, Vector2i(1280, 720))
	var button: Button = shown[1].get_node("Margin/Column/Body/Controls/PlayButton")
	_drop_handlers(button)
	watch_signals(button)
	_click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Play")


func test_play_reacts_to_touch() -> void:
	var shown: Array = await _show_in_viewport(HOME_SCENE, Vector2i(844, 390))
	var button: Button = shown[1].get_node("Margin/Column/Body/Controls/PlayButton")
	_drop_handlers(button)
	watch_signals(button)
	_touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a touch presses Play")


func test_back_reacts_to_mouse_click_and_touch() -> void:
	var shown: Array = await _show_in_viewport(ARENA_SCENE, Vector2i(844, 390))
	var button: Button = shown[1].get_node("Hud/BackButton")
	_drop_handlers(button)
	watch_signals(button)
	_click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Back")
	_touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 2, "a touch presses Back")
