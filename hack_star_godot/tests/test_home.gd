extends GutTest

const HOME: PackedScene = preload("res://scenes/home.tscn")
const HomeScript: GDScript = preload("res://scenes/home.gd")
const PLAY_PATH: String = "Margin/Column/Body/Controls/PlayButton"


func before_each() -> void:
	GameState.reset()


func _show_home() -> Control:
	var screen: Control = autofree(HOME.instantiate())
	add_child(screen)
	return screen


func test_shows_title_and_play() -> void:
	var screen: Control = _show_home()
	assert_eq(screen.get_node("Margin/Column/Title").text, "Hack star")
	var button: Button = screen.get_node("Margin/Column/Body/Controls/PlayButton")
	assert_eq(button.text, "Play")
	assert_gte(button.custom_minimum_size.y, 100.0, "big enough for a thumb")


func test_shows_the_values_of_game_state() -> void:
	GameState.credits = 321
	var screen: Control = _show_home()
	var trophies_text: String = screen.get_node("Margin/Column/TopBar/TrophiesLabel").text
	assert_eq(trophies_text, "Trophies: %d" % GameState.total_trophies())
	assert_eq(screen.get_node("Margin/Column/TopBar/CreditsLabel").text, "Credits: 321")
	assert_eq(screen.get_node("Margin/Column/Body/Controls/NameRow/NameLabel").text, "Blaze")


func test_shows_the_selected_fighter_and_skin() -> void:
	GameState.select("rocko", "crystal")
	var screen: Control = _show_home()
	var stage: FighterStage = screen.get_node("Margin/Column/Body/FighterStage")
	assert_eq(stage.model.fighter_id, "rocko")
	assert_eq(stage.model.skin_id, "crystal")
	assert_eq(screen.get_node("Margin/Column/Body/Controls/NameRow/NameLabel").text, "Rocko")


func test_blaze_shows_prestige_1() -> void:
	var screen: Control = _show_home()
	var badge: PrestigeBadge = screen.get_node("Margin/Column/Body/Controls/NameRow/PrestigeBadge")
	assert_true(badge.visible)
	assert_eq(badge.get_node("Label").text, "Prestige 1")


func test_fighter_under_1000_trophies_shows_no_badge() -> void:
	GameState.select("turbo", "default")
	var screen: Control = _show_home()
	assert_false(screen.get_node("Margin/Column/Body/Controls/NameRow/PrestigeBadge").visible)


func test_info_waits_for_its_step() -> void:
	var screen: Control = _show_home()
	assert_true(screen.get_node("Margin/Column/Body/Controls/MoreRow/InfoButton").disabled)


func test_fighters_opens_the_fighter_list() -> void:
	var tree: SceneTree = get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	var screen: Control = HOME.instantiate()
	placeholder.add_child(screen)
	var button: Button = screen.get_node("Margin/Column/Body/Controls/MoreRow/FightersButton")
	assert_false(button.disabled)
	button.pressed.emit()
	await wait_process_frames(2)
	var shown: Node = tree.current_scene
	assert_eq(shown.scene_file_path, Screens.FIGHTERS, "Fighters opens the list")
	shown.queue_free()
	await wait_process_frames(1)
	tree.current_scene = previous


func test_play_opens_the_arena() -> void:
	var tree: SceneTree = get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	var screen: Control = HOME.instantiate()
	placeholder.add_child(screen)
	var button: Button = screen.get_node("Margin/Column/Body/Controls/PlayButton")
	button.pressed.emit()
	await wait_process_frames(2)
	var shown: Node = tree.current_scene
	assert_eq(shown.scene_file_path, Screens.ARENA, "Play opens the arena")
	shown.queue_free()
	await wait_process_frames(1)
	tree.current_scene = previous


# --- Entrance (S2) ----------------------------------------------------------------------------


## The home screen in its own viewport, so input can be pushed to it.
func _show_home_in_viewport() -> Array:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var screen: Control = HOME.instantiate()
	viewport.add_child(screen)
	await wait_process_frames(2)
	return [viewport, screen]


func _press_at(viewport: SubViewport, event: InputEvent) -> void:
	viewport.push_input(event, true)
	var release: InputEvent = event.duplicate()
	release.set("pressed", false)
	viewport.push_input(release, true)


func _click(position: Vector2) -> InputEventMouseButton:
	var event: InputEventMouseButton = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.button_mask = MOUSE_BUTTON_MASK_LEFT
	event.position = position
	event.global_position = position
	return event


func _touch(position: Vector2) -> InputEventScreenTouch:
	var event: InputEventScreenTouch = InputEventScreenTouch.new()
	event.index = 0
	event.pressed = true
	event.position = position
	return event


func _key() -> InputEventKey:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = KEY_SPACE
	event.physical_keycode = KEY_SPACE
	event.pressed = true
	return event


func _assert_end_state(screen: Control) -> void:
	assert_false(screen.entrance_playing, "the entrance is over")
	var model: FighterModel = screen.get_node("Margin/Column/Body/FighterStage").model
	assert_eq(model.position, Vector3.ZERO, "the fighter stands on the ground")
	assert_eq(model.scale, Vector3.ONE)
	assert_eq(screen.get_node("Margin/Column/Title").scale, Vector2.ONE, "the title is shown")
	assert_eq(screen.get_node("Margin/Column/Body/Controls").modulate.a, 1.0)
	assert_false(screen.get_node("SkipHint").visible, "no skip hint")
	assert_false(screen.get_node("Flash").visible)


func test_entrance_lasts_at_most_3_seconds() -> void:
	assert_gt(HomeScript.ENTRANCE_SECONDS, 0.0)
	assert_lte(HomeScript.ENTRANCE_SECONDS, 3.0)


func test_first_home_plays_the_entrance_and_a_second_does_not() -> void:
	assert_false(GameState.entrance_played)
	var first: Control = _show_home()
	await wait_process_frames(2)
	assert_true(first.entrance_playing, "the first home plays it")
	assert_true(GameState.entrance_played)
	assert_true(first.get_node("SkipHint").visible, "with the skip hint")
	var model: FighterModel = first.get_node("Margin/Column/Body/FighterStage").model
	assert_gt(model.position.y, 0.0, "the fighter starts above the ground")
	first.queue_free()
	var second: Control = _show_home()
	await wait_process_frames(2)
	_assert_end_state(second)


func test_entrance_ends_by_itself() -> void:
	var screen: Control = _show_home()
	await wait_seconds(HomeScript.ENTRANCE_SECONDS + 0.3)
	_assert_end_state(screen)
	await wait_process_frames(1)
	var viewport: SubViewport = screen.get_node("Margin/Column/Body/FighterStage/Viewport")
	assert_null(viewport.get_node_or_null("Entrance"), "the effects are gone")


func test_a_click_skips_the_entrance() -> void:
	var shown: Array = await _show_home_in_viewport()
	assert_true(shown[1].entrance_playing)
	_press_at(shown[0], _click(Vector2(100, 600)))
	_assert_end_state(shown[1])


func test_a_touch_skips_the_entrance() -> void:
	var shown: Array = await _show_home_in_viewport()
	_press_at(shown[0], _touch(Vector2(100, 600)))
	_assert_end_state(shown[1])


func test_a_key_skips_the_entrance() -> void:
	var shown: Array = await _show_home_in_viewport()
	_press_at(shown[0], _key())
	_assert_end_state(shown[1])


func test_play_works_after_a_skip() -> void:
	var shown: Array = await _show_home_in_viewport()
	var button: Button = shown[1].get_node(PLAY_PATH)
	for connection: Dictionary in button.pressed.get_connections():
		button.pressed.disconnect(connection["callable"])
	watch_signals(button)
	var on_play: Vector2 = button.get_global_rect().get_center()
	_press_at(shown[0], _click(on_play))
	assert_false(shown[1].entrance_playing)
	assert_signal_emit_count(button, "pressed", 0, "the tap that skips does not press Play")
	_press_at(shown[0], _click(on_play))
	assert_signal_emit_count(button, "pressed", 1, "Play works after the skip")
