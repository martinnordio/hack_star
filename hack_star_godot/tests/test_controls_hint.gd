extends GutTest
## The controls hint at the start of Training and of a match (spec 16, D15).

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const SIZES: Dictionary = {
	"desktop 1280x720": Vector2i(1280, 720),
	"iPad landscape 1180x820": Vector2i(1180, 820),
	"iPad portrait 820x1180": Vector2i(820, 1180),
	"phone portrait 390x844": Vector2i(390, 844),
	"phone landscape 844x390": Vector2i(844, 390),
}
## The hint is clear of these HUD controls (paths under `Hud`).
const CLEAR_OF: Array[String] = [
	"BackButton",
	"FpsLabel",
	"MatchHud/CountdownLabel",
	"MatchHud/TimerChip",
	"MatchHud/FightersLeftChip",
]


func before_each() -> void:
	GameState.reset()
	GameState.match_settings.countdown_seconds = 3


func after_each() -> void:
	Input.action_release("shoot")
	GameState.reset()


func _content_size(window_size: Vector2i) -> Vector2:
	var base: Vector2 = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	return Vector2(window_size) / UiScale.total(Vector2(window_size), base)


func _show_in_viewport(scene: PackedScene, size: Vector2i, touch: bool = false) -> Node:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = size
	viewport.size_2d_override = Vector2i(_content_size(size).round())
	viewport.size_2d_override_stretch = true
	add_child_autofree(viewport)
	var root: Node = scene.instantiate()
	root.read_player_input = false
	root.touch_controls = touch
	viewport.add_child(root)
	await wait_process_frames(2)
	return root


## The hint on its dark backing (spec 09, G12).
func _hint(arena: Node) -> Control:
	return arena.get_node("Hud/ControlsHint")


func _hint_text(arena: Node) -> Label:
	return arena.get_node("Hud/ControlsHint/Row/Label")


func test_training_shows_the_keyboard_hint_and_hides_it_after_the_time() -> void:
	var arena: Node = await _show_in_viewport(ARENA_SCENE, Vector2i(1280, 720))
	var hint: Control = _hint(arena)
	assert_true(hint.visible)
	assert_eq(hint.modulate.a, 1.0, "fully visible at first")
	var text: String = _hint_text(arena).text
	assert_true(text.begins_with(ControlsHelp.KEYBOARD_HINT), "the keyboard text")
	assert_true(text.ends_with(ControlsHelp.MORE_IN_INFO), "More in Info")
	assert_eq(hint.theme_type_variation, &"ChipPanel", "on a dark rounded backing")
	assert_not_null(arena.get_node("Hud/ControlsHint/Row/Icon").texture, "with an icon")
	for part: Control in [hint] + hint.find_children("*", "Control", true, false):
		assert_eq(part.mouse_filter, Control.MOUSE_FILTER_IGNORE, "%s ignores input" % part.name)
	await wait_seconds(Arena.HINT_SECONDS + Arena.HINT_FADE_SECONDS + 0.3)
	assert_false(hint.visible, "hidden after the time")


func test_a_match_shows_the_hint_over_the_countdown() -> void:
	var arena: Node = await _show_in_viewport(MATCH_SCENE, Vector2i(1280, 720))
	var hint: Control = _hint(arena)
	assert_true(hint.visible)
	assert_true(_hint_text(arena).text.begins_with(ControlsHelp.KEYBOARD_HINT))
	assert_eq(hint.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_true(arena.get_node("Hud/MatchHud/CountdownLabel").visible, "the countdown runs")


func test_the_hint_is_clear_of_the_other_controls_at_every_size() -> void:
	for touch: bool in [false, true]:
		for scene: PackedScene in [ARENA_SCENE, MATCH_SCENE]:
			for label: String in SIZES:
				var size: Vector2i = SIZES[label]
				var arena: Node = await _show_in_viewport(scene, size, touch)
				var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
				var hint: Control = _hint(arena)
				var hint_rect: Rect2 = hint.get_global_rect()
				var hint_text: Label = _hint_text(arena)
				var where: String = (
					"%s %s%s" % [scene.resource_path.get_file(), label, " (touch)" if touch else ""]
				)
				assert_true(
					visible_rect.encloses(hint_rect), "%s: hint %s fits" % [where, hint_rect]
				)
				var text_height: float = hint_text.get_line_count() * hint_text.get_line_height()
				var text_box: float = hint_text.size.y
				assert_true(text_height <= text_box, "%s: the text fits its box" % where)
				for path: String in CLEAR_OF:
					var other: Control = arena.get_node_or_null("Hud/%s" % path)
					if other != null:
						assert_false(
							hint_rect.intersects(other.get_global_rect()),
							"%s: clear of %s" % [where, path]
						)


func test_touch_shows_only_the_sticks() -> void:
	var arena: Node = await _show_in_viewport(ARENA_SCENE, Vector2i(844, 390), true)
	var text: String = _hint_text(arena).text
	assert_true(text.begins_with(ControlsHelp.TOUCH_HINT), "the sticks")
	assert_false(text.contains("WASD"), "no keyboard text on a touch screen")


func test_space_fires_while_the_hint_shows() -> void:
	var arena: Node = await _show_in_viewport(ARENA_SCENE, Vector2i(1280, 720))
	arena.read_player_input = true
	var shots: Array[Vector3] = []
	arena.get_node("Shots").child_entered_tree.connect(
		func(shot: Node) -> void: shots.append((shot as Shot).direction)
	)
	assert_true(_hint(arena).visible)
	Input.action_press("shoot")
	await wait_process_frames(2)
	assert_eq(shots.size(), 1, "Space fires")
