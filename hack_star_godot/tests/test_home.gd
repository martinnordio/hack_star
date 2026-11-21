extends GutTest

const HOME: PackedScene = preload("res://scenes/home.tscn")


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


func test_fighters_and_info_wait_for_their_steps() -> void:
	var screen: Control = _show_home()
	assert_true(screen.get_node("Margin/Column/Body/Controls/MoreRow/FightersButton").disabled)
	assert_true(screen.get_node("Margin/Column/Body/Controls/MoreRow/InfoButton").disabled)


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
