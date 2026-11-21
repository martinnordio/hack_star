extends GutTest

const SCREEN: PackedScene = preload("res://scenes/fighter_screen.tscn")
const HOME: PackedScene = preload("res://scenes/home.tscn")
const BODY: String = "Margin/Column/Body"


func before_each() -> void:
	GameState.reset()
	GameState.entrance_played = true


func _show(fighter_id: String) -> Control:
	GameState.viewed_fighter = fighter_id
	var screen: Control = autofree(SCREEN.instantiate())
	add_child(screen)
	return screen


func _skin_button(screen: Control, skin_name: String) -> SkinButton:
	return screen.get_node(BODY + "/Details/SkinRow").get_node(skin_name)


func _select(screen: Control) -> Button:
	return screen.get_node(BODY + "/Details/SelectButton")


## Runs `action` with a placeholder as the current scene and returns the scene it changed to.
func _scene_after(action: Callable) -> Node:
	var tree: SceneTree = get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	action.call(placeholder)
	await wait_process_frames(2)
	var shown: Node = tree.current_scene
	tree.current_scene = previous
	return shown


func test_shows_the_fighter_and_its_values() -> void:
	var screen: Control = _show("blaze")
	assert_eq(screen.get_node("Margin/Column/Header/Title").text, "Blaze")
	assert_eq(screen.get_node(BODY + "/Details/RarityLabel").text, "Rare")
	assert_eq(screen.get_node(BODY + "/Details/TrophiesLabel").text, "Trophies: 1240")
	assert_eq(screen.get_node(BODY + "/Details/PowerLabel").text, "Power: 7")
	assert_true(screen.get_node(BODY + "/Details/PrestigeBadge").visible)
	var stage: FighterStage = screen.get_node(BODY + "/FighterStage")
	assert_eq(stage.model.fighter_id, "blaze")
	assert_eq(stage.model.skin_id, "default")


func test_one_button_per_skin_with_its_rarity() -> void:
	var screen: Control = _show("blaze")
	var row: Node = screen.get_node(BODY + "/Details/SkinRow")
	assert_eq(row.get_child_count(), 3)
	assert_eq(_skin_button(screen, "Default").text, "Default")
	assert_eq(_skin_button(screen, "Lava").text, "Lava\nEpic")
	assert_eq(_skin_button(screen, "Phoenix").text, "Phoenix\nLegendary")


func test_only_the_legendary_skin_has_the_gold_frame() -> void:
	var screen: Control = _show("blaze")
	var gold: StyleBoxFlat = _skin_button(screen, "Phoenix").get_theme_stylebox("normal")
	assert_eq(gold.border_color, Rarity.LEGENDARY_GOLD)
	var plain: StyleBoxFlat = _skin_button(screen, "Lava").get_theme_stylebox("normal")
	assert_ne(plain.border_color, Rarity.LEGENDARY_GOLD)
	assert_gt(gold.border_width_left, plain.border_width_left)


func test_choosing_a_skin_previews_it() -> void:
	var screen: Control = _show("blaze")
	_skin_button(screen, "Lava").pressed.emit()
	var stage: FighterStage = screen.get_node(BODY + "/FighterStage")
	assert_eq(stage.model.skin_id, "lava")
	assert_eq(GameState.selected_skins["blaze"], "default", "previewing does not choose")


func test_starts_on_the_chosen_skin() -> void:
	GameState.select("rocko", "crystal")
	var screen: Control = _show("rocko")
	assert_true(_skin_button(screen, "Crystal").button_pressed)
	var stage: FighterStage = screen.get_node(BODY + "/FighterStage")
	assert_eq(stage.model.skin_id, "crystal")


func test_select_chooses_rocko_with_crystal_and_goes_home() -> void:
	var screen: Control = HOME.instantiate()
	var shown: Node = await _scene_after(
		func(placeholder: Node) -> void:
			GameState.viewed_fighter = "rocko"
			var fighter_screen: Control = SCREEN.instantiate()
			placeholder.add_child(fighter_screen)
			_skin_button(fighter_screen, "Crystal").pressed.emit()
			_select(fighter_screen).pressed.emit()
	)
	assert_eq(shown.scene_file_path, Screens.HOME)
	assert_eq(GameState.selected_fighter, "rocko")
	assert_eq(GameState.selected_skin(), "crystal")
	shown.queue_free()
	await wait_process_frames(1)
	add_child(screen)
	var stage: FighterStage = screen.get_node("Margin/Column/Body/FighterStage")
	assert_eq(stage.model.fighter_id, "rocko")
	assert_eq(stage.model.skin_id, "crystal")
	screen.queue_free()


func test_a_locked_fighter_cannot_be_selected() -> void:
	var screen: Control = _show("pixel")
	var button: Button = _select(screen)
	assert_true(button.disabled)
	assert_eq(button.text, "Locked")
	_skin_button(screen, "Glitch").pressed.emit()
	assert_eq(
		(screen.get_node(BODY + "/FighterStage") as FighterStage).model.skin_id,
		"glitch",
		"a locked fighter can be looked at"
	)
	button.pressed.emit()
	assert_eq(GameState.selected_fighter, "blaze", "the choice did not change")


func test_the_choice_stays_after_the_arena_and_back() -> void:
	GameState.select("turbo", "neon")
	var shown: Node = await _scene_after(
		func(_placeholder: Node) -> void: Screens.go_to(Screens.ARENA)
	)
	assert_eq(shown.scene_file_path, Screens.ARENA)
	shown.queue_free()
	shown = await _scene_after(func(_placeholder: Node) -> void: Screens.go_home())
	assert_eq(shown.scene_file_path, Screens.HOME)
	assert_eq(GameState.selected_fighter, "turbo")
	assert_eq(GameState.selected_skin(), "neon")
	shown.queue_free()
	await wait_process_frames(1)


func test_back_goes_home() -> void:
	var shown: Node = await _scene_after(
		func(placeholder: Node) -> void:
			var fighter_screen: Control = SCREEN.instantiate()
			placeholder.add_child(fighter_screen)
			fighter_screen.get_node("Margin/Column/Header/BackButton").pressed.emit()
	)
	assert_eq(shown.scene_file_path, Screens.HOME)
	assert_eq(GameState.selected_fighter, "blaze", "Back changes nothing")
	shown.queue_free()
	await wait_process_frames(1)
