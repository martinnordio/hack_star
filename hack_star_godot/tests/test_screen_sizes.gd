extends GutTest
## Every screen fits desktop, iPad and phone sizes in landscape and portrait (spec 03, D5),
## and Play and Back react to a mouse click and to a touch; buttons and text keep a minimum
## size on the screen (spec 04, D13).

const HOME_SCENE: PackedScene = preload("res://scenes/home.tscn")
const LIST_SCENE: PackedScene = preload("res://scenes/fighter_list.tscn")
const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter_screen.tscn")
const INFO_SCENE: PackedScene = preload("res://scenes/info.tscn")
const HACK_SCENE: PackedScene = preload("res://scenes/hack_screen.tscn")
const QR_SCENE: PackedScene = preload("res://scenes/qr_page.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MIN_BUTTON_HEIGHT: float = 44.0
const MIN_TEXT_SIZE: float = 14.0
const SIZES: Dictionary = {
	"desktop 1280x720": Vector2i(1280, 720),
	"iPad landscape 1180x820": Vector2i(1180, 820),
	"iPad portrait 820x1180": Vector2i(820, 1180),
	"phone portrait 390x844": Vector2i(390, 844),
	"phone landscape 844x390": Vector2i(844, 390),
}


func after_each() -> void:
	HackServer.fake_responder = Callable()


## The window's content scale as the project sets it (`canvas_items`, `expand`, and the content
## scale factor of `UiScale`): the scene is laid out in a rectangle of the base aspect or
## wider/taller, then scaled to the window.
func _content_size(window_size: Vector2i) -> Vector2:
	assert_eq(ProjectSettings.get_setting("display/window/stretch/mode"), "canvas_items")
	assert_eq(ProjectSettings.get_setting("display/window/stretch/aspect"), "expand")
	return Vector2(window_size) / UiScale.total(Vector2(window_size), _base_size())


func _base_size() -> Vector2:
	return Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)


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
		"Margin/Column/Body/Controls/MoreRow/HackButton",
		"SkipHint",
	]
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		GameState.entrance_played = false
		var shown: Array = await _show_in_viewport(HOME_SCENE, size)
		var screen: Control = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		for path: String in paths:
			_assert_inside(screen.get_node(path), visible_rect, "%s %s" % [label, path])
		shown[0].queue_free()


func test_fighter_list_fits_every_size() -> void:
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(LIST_SCENE, size)
		var screen: Control = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		_assert_inside(screen.get_node("Margin/Column/Header/BackButton"), visible_rect, label)
		_assert_inside(screen.get_node("Margin/Column/Header/Title"), visible_rect, label)
		var scroll: ScrollContainer = screen.get_node("Margin/Column/Scroll")
		_assert_inside(scroll, visible_rect, "%s scroll" % label)
		var grid: GridContainer = scroll.get_node("Grid")
		assert_lte(grid.size.x, scroll.size.x + 0.5, "%s grid is not wider than the screen" % label)
		var first: Control = grid.get_child(0)
		_assert_inside(first, visible_rect, "%s first card" % label)
		shown[0].queue_free()


func test_fighter_screen_fits_every_size() -> void:
	var paths: Array[String] = [
		"Margin/Column/Header/BackButton",
		"Margin/Column/Header/Title",
		"Margin/Column/Body/FighterStage",
		"Margin/Column/Body/Details/RarityLabel",
		"Margin/Column/Body/Details/TrophiesLabel",
		"Margin/Column/Body/Details/PowerLabel",
		"Margin/Column/Body/Details/PrestigeBadge",
		"Margin/Column/Body/Details/SkinRow/Default",
		"Margin/Column/Body/Details/SkinRow/Lava",
		"Margin/Column/Body/Details/SkinRow/Phoenix",
		"Margin/Column/Body/Details/SelectButton",
	]
	GameState.viewed_fighter = "blaze"
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(FIGHTER_SCENE, size)
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		for path: String in paths:
			_assert_inside(shown[1].get_node(path), visible_rect, "%s %s" % [label, path])
		shown[0].queue_free()


func test_back_on_the_list_reacts_to_mouse_click_and_touch() -> void:
	var shown: Array = await _show_in_viewport(LIST_SCENE, Vector2i(844, 390))
	var button: Button = shown[1].get_node("Margin/Column/Header/BackButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Back")
	UiInput.touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 2, "a touch presses Back")


func test_info_fits_every_size_and_scrolls() -> void:
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(INFO_SCENE, size)
		var screen: Control = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		_assert_inside(screen.get_node("Margin/Column/Header/BackButton"), visible_rect, label)
		_assert_inside(screen.get_node("Margin/Column/Header/Title"), visible_rect, label)
		var scroll: ScrollContainer = screen.get_node("Margin/Column/Scroll")
		_assert_inside(scroll, visible_rect, "%s scroll" % label)
		var rows: Control = scroll.get_node("Rows")
		assert_lte(
			rows.size.x, scroll.size.x + 0.5, "%s rows are not wider than the screen" % label
		)
		_assert_inside(rows.get_child(0), visible_rect, "%s first row" % label)
		shown[0].queue_free()


func test_back_on_the_info_page_reacts_to_mouse_click_and_touch() -> void:
	var shown: Array = await _show_in_viewport(INFO_SCENE, Vector2i(390, 844))
	var button: Button = shown[1].get_node("Margin/Column/Header/BackButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Back")
	UiInput.touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 2, "a touch presses Back")


func test_hack_screen_fits_every_size() -> void:
	var paths: Array[String] = [
		"Margin/Column/Header/BackButton",
		"Margin/Column/Header/Title",
		"Margin/Column/Scroll/Content/CodeRow/CodeEdit",
		"Margin/Column/Scroll/Content/CodeRow/UseButton",
		"Margin/Column/Scroll/Content/Message",
		"Margin/Column/Scroll/Content/ActiveTitle",
		"Margin/Column/Scroll/Content/ActiveList",
		"Margin/Column/Scroll/Content/ResetButton",
		"Margin/Column/Scroll/Content/QrButton",
	]
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(HACK_SCENE, size)
		var screen: Control = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		var scroll: ScrollContainer = screen.get_node("Margin/Column/Scroll")
		_assert_inside(scroll, visible_rect, "%s scroll" % label)
		var content: Control = scroll.get_node("Content")
		assert_lte(content.size.x, scroll.size.x + 0.5, "%s content fits the width" % label)
		for path: String in paths:
			var control: Control = screen.get_node(path)
			var rect: Rect2 = control.get_global_rect()
			var in_width: bool = rect.position.x >= -0.5 and rect.end.x <= visible_rect.end.x + 0.5
			assert_true(in_width, "%s %s %s fits the width" % [label, path, rect])
		shown[0].queue_free()


func test_back_and_use_code_on_the_hack_screen_react_to_mouse_click_and_touch() -> void:
	var shown: Array = await _show_in_viewport(HACK_SCENE, Vector2i(390, 844))
	var back: Button = shown[1].get_node("Margin/Column/Header/BackButton")
	var use: Button = shown[1].get_node("Margin/Column/Scroll/Content/CodeRow/UseButton")
	_drop_handlers(back)
	_drop_handlers(use)
	for button: Button in [back, use]:
		watch_signals(button)
		UiInput.click(shown[0], button)
		assert_signal_emit_count(button, "pressed", 1, "a click presses %s" % button.text)
		UiInput.touch(shown[0], button)
		assert_signal_emit_count(button, "pressed", 2, "a touch presses %s" % button.text)


func test_qr_page_fits_every_size() -> void:
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {
			"status": 200,
			"body":
			(
				'[{"id": "infinite_credits", "code": "INFINITY", "name": "Unlimited credits"},'
				+ '{"id": "power22", "code": "POWER22", "name": "Power 22"}]'
			)
		}
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(QR_SCENE, size)
		var screen: Control = shown[1]
		await wait_process_frames(2)
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		_assert_inside(screen.get_node("Margin/Column/Header/BackButton"), visible_rect, label)
		var scroll: ScrollContainer = screen.get_node("Margin/Column/Scroll")
		_assert_inside(scroll, visible_rect, "%s scroll" % label)
		var content: Control = scroll.get_node("Content")
		assert_lte(content.size.x, scroll.size.x + 0.5, "%s content fits the width" % label)
		var first: Control = content.get_node("Rows").get_child(0)
		var rect: Rect2 = first.get_global_rect()
		assert_true(
			rect.position.x >= -0.5 and rect.end.x <= visible_rect.end.x + 0.5,
			"%s first QR code %s fits the width" % [label, rect]
		)
		shown[0].queue_free()


func test_back_on_the_qr_page_reacts_to_mouse_click_and_touch() -> void:
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {"status": 0, "body": ""}
	var shown: Array = await _show_in_viewport(QR_SCENE, Vector2i(390, 844))
	var button: Button = shown[1].get_node("Margin/Column/Header/BackButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Back")
	UiInput.touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 2, "a touch presses Back")


func test_arena_fits_every_size() -> void:
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(ARENA_SCENE, size)
		var arena: Node3D = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		_assert_inside(arena.get_node("Hud/BackButton"), visible_rect, "%s Back" % label)
		var joystick: TouchJoystick = arena.get_node("Hud/TouchJoystick")
		_assert_inside(joystick, visible_rect, "%s joystick" % label)
		var aim_stick: TouchJoystick = arena.get_node("Hud/AimJoystick")
		_assert_inside(aim_stick, visible_rect, "%s aim stick" % label)
		var aim_rect: Rect2 = aim_stick.get_global_rect()
		assert_false(aim_rect.intersects(joystick.get_global_rect()), "%s sticks apart" % label)
		var back_rect: Rect2 = arena.get_node("Hud/BackButton").get_global_rect()
		assert_false(aim_rect.intersects(back_rect), "%s aim stick clear of Back" % label)
		_assert_inside(arena.get_node("Hud/FpsLabel"), visible_rect, "%s FPS label" % label)
		var fighter: Fighter = arena.get_node("Fighter")
		_assert_fighter_in_view(arena, visible_rect, "%s at the start" % label)
		# Between the rocks, then into the north-east corner; the camera catches up.
		arena.read_player_input = false
		for leg: Array in [[Vector2.RIGHT, 0.5], [Vector2.UP, 3.2], [Vector2.RIGHT, 1.5]]:
			fighter.input_direction = leg[0]
			await wait_seconds(leg[1])
		fighter.input_direction = Vector2.UP
		await wait_seconds(1.5)
		fighter.input_direction = Vector2.ZERO
		await wait_seconds(1.5)
		assert_lt(fighter.position.z, -9.0, "%s the fighter is in the north" % label)
		assert_gt(fighter.position.x, 7.5, "%s the fighter is in the east" % label)
		_assert_fighter_in_view(arena, visible_rect, "%s in the corner" % label)
		shown[0].queue_free()


func _assert_fighter_in_view(arena: Node3D, visible_rect: Rect2, label: String) -> void:
	var camera: Camera3D = arena.get_node("Camera")
	var fighter: Fighter = arena.get_node("Fighter")
	var feet: Vector2 = camera.unproject_position(fighter.global_position)
	var head: Vector2 = camera.unproject_position(fighter.global_position + Vector3(0, 1.9, 0))
	assert_true(visible_rect.has_point(feet), "%s feet %s in view" % [label, feet])
	assert_true(visible_rect.has_point(head), "%s head %s in view" % [label, head])


func test_play_reacts_to_mouse_click() -> void:
	# Played already: the entrance would take the first tap to skip itself.
	GameState.entrance_played = true
	var shown: Array = await _show_in_viewport(HOME_SCENE, Vector2i(1280, 720))
	var button: Button = shown[1].get_node("Margin/Column/Body/Controls/PlayButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Play")


func test_play_reacts_to_touch() -> void:
	# Played already: the entrance would take the first tap to skip itself.
	GameState.entrance_played = true
	var shown: Array = await _show_in_viewport(HOME_SCENE, Vector2i(844, 390))
	var button: Button = shown[1].get_node("Margin/Column/Body/Controls/PlayButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a touch presses Play")


func test_back_reacts_to_mouse_click_and_touch() -> void:
	var shown: Array = await _show_in_viewport(ARENA_SCENE, Vector2i(844, 390))
	var button: Button = shown[1].get_node("Hud/BackButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Back")
	UiInput.touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 2, "a touch presses Back")


func test_back_on_the_fighter_screen_reacts_to_mouse_click_and_touch() -> void:
	GameState.viewed_fighter = "blaze"
	var shown: Array = await _show_in_viewport(FIGHTER_SCENE, Vector2i(390, 844))
	var button: Button = shown[1].get_node("Margin/Column/Header/BackButton")
	_drop_handlers(button)
	watch_signals(button)
	UiInput.click(shown[0], button)
	assert_signal_emit_count(button, "pressed", 1, "a click presses Back")
	UiInput.touch(shown[0], button)
	assert_signal_emit_count(button, "pressed", 2, "a touch presses Back")


## D13: at every size every visible button is at least 44 px tall and every visible text at
## least 14 px, in screen pixels (after the stretch and the content scale factor).
func _assert_minimums(node: Node, scale: float, label: String) -> void:
	for child: Node in node.get_children():
		_assert_minimums(child, scale, label)
	var control: Control = node as Control
	if control == null or not control.is_visible_in_tree():
		return
	if control is Button:
		assert_gte(
			control.size.y * scale,
			MIN_BUTTON_HEIGHT,
			"%s button %s is %.1f px tall" % [label, control.get_path(), control.size.y * scale]
		)
	if control is Button or control is Label:
		var text: String = control.text
		var font_size: int = control.get_theme_font_size("font_size")
		if not text.is_empty():
			assert_gte(
				font_size * scale,
				MIN_TEXT_SIZE,
				"%s text '%s' is %.1f px" % [label, text.left(12), font_size * scale]
			)


func test_buttons_and_text_have_a_minimum_size_at_every_size() -> void:
	GameState.viewed_fighter = "blaze"
	var screens: Dictionary = {
		"home": HOME_SCENE,
		"list": LIST_SCENE,
		"fighter": FIGHTER_SCENE,
		"info": INFO_SCENE,
		"hack": HACK_SCENE,
		"qr": QR_SCENE,
		"arena": ARENA_SCENE,
	}
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var scale: float = UiScale.total(Vector2(size), _base_size())
		for screen_name: String in screens:
			# The entrance is still playing on the first home: its hint is visible too.
			GameState.entrance_played = false
			var shown: Array = await _show_in_viewport(screens[screen_name], size)
			_assert_minimums(shown[1], scale, "%s %s" % [label, screen_name])
			shown[0].queue_free()
