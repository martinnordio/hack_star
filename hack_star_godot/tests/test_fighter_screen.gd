extends GutTest

const SCREEN: PackedScene = preload("res://scenes/fighter_screen.tscn")
const HOME: PackedScene = preload("res://scenes/home.tscn")
const BODY: String = "Margin/Column/Body"
const STAGE: String = BODY + "/StageFrame/FighterStage"
const STATS: String = BODY + "/Details/Stats"


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
	assert_eq(screen.get_node(STATS + "/TrophiesChip").text, "1240")
	assert_eq(screen.get_node(STATS + "/PowerChip").text, "7 / 11")
	assert_true(screen.get_node(STATS + "/PrestigeBadge").visible)
	var stage: FighterStage = screen.get_node(STAGE)
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


func test_every_skin_has_its_picture_in_a_frame_of_its_rarity_colour() -> void:
	for fighter_id: String in ["blaze", "luna"]:
		var textures: Dictionary = {}
		for skin: Dictionary in Fighters.get_fighter(fighter_id)["skins"]:
			var texture: ImageTexture = ImageTexture.create_from_image(
				Image.create(4, 4, false, Image.FORMAT_RGBA8)
			)
			GameState.pictures[FighterPictures.key(fighter_id, skin["id"])] = texture
			textures[skin["id"]] = texture
		var screen: Control = _show(fighter_id)
		for button: SkinButton in screen.get_node(BODY + "/Details/SkinRow").get_children():
			assert_eq(button.icon, textures[button.skin_id], "%s picture" % button.skin_id)
			var rarity: String = Fighters.get_skin(fighter_id, button.skin_id)["rarity"]
			if rarity.is_empty():
				assert_ne(button.frame_color(), Rarity.LEGENDARY_GOLD, "Default: plain frame")
			else:
				assert_eq(button.frame_color(), Rarity.color(rarity), "%s frame" % button.skin_id)


func test_the_screen_is_on_the_gradient_with_the_fighter_framed_on_its_pedestal() -> void:
	var screen: Control = _show("rocko")
	assert_true((screen.get_node("Background") as ColorRect).material is ShaderMaterial)
	var frame: PanelContainer = screen.get_node(BODY + "/StageFrame")
	assert_eq(frame.theme_type_variation, &"StageFramePanel")
	assert_not_null(screen.get_node(STAGE + "/Viewport/Pedestal"))


func test_a_click_or_a_touch_on_a_skin_previews_it() -> void:
	GameState.viewed_fighter = "blaze"
	var opened: Dictionary = await UiInput.open(self, SCREEN)
	var screen: Control = opened["screen"]
	var stage: FighterStage = screen.get_node(STAGE)
	UiInput.click(opened["viewport"], _skin_button(screen, "Lava"))
	assert_eq(stage.model.skin_id, "lava", "a click previews the skin")
	UiInput.touch(opened["viewport"], _skin_button(screen, "Phoenix"))
	assert_eq(stage.model.skin_id, "phoenix", "a touch previews the skin")
	assert_eq(GameState.selected_skins["blaze"], "default", "previewing does not choose")
	await UiInput.close(self, await UiInput.settle(self, opened))


func test_starts_on_the_chosen_skin() -> void:
	GameState.select("rocko", "crystal")
	var screen: Control = _show("rocko")
	assert_true(_skin_button(screen, "Crystal").button_pressed)
	var stage: FighterStage = screen.get_node(STAGE)
	assert_eq(stage.model.skin_id, "crystal")


func test_clicking_crystal_and_select_chooses_rocko_and_goes_home() -> void:
	GameState.viewed_fighter = "rocko"
	var opened: Dictionary = await UiInput.open(self, SCREEN)
	var screen: Control = opened["screen"]
	UiInput.click(opened["viewport"], _skin_button(screen, "Crystal"))
	UiInput.click(opened["viewport"], _select(screen))
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.HOME)
	assert_eq(GameState.selected_fighter, "rocko")
	assert_eq(GameState.selected_skin(), "crystal")
	await UiInput.close(self, shown)
	var home: Control = autofree(HOME.instantiate())
	add_child(home)
	var stage: FighterStage = home.get_node("Margin/Column/Body/FighterStage")
	assert_eq(stage.model.fighter_id, "rocko")
	assert_eq(stage.model.skin_id, "crystal")


func test_touching_select_chooses_the_fighter_and_goes_home() -> void:
	GameState.viewed_fighter = "turbo"
	var opened: Dictionary = await UiInput.open(self, SCREEN)
	var screen: Control = opened["screen"]
	UiInput.touch(opened["viewport"], _skin_button(screen, "Neon"))
	UiInput.touch(opened["viewport"], _select(screen))
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.HOME)
	assert_eq(GameState.selected_fighter, "turbo")
	assert_eq(GameState.selected_skin(), "neon")
	await UiInput.close(self, shown)


func test_a_locked_fighter_cannot_be_selected() -> void:
	GameState.viewed_fighter = "pixel"
	var opened: Dictionary = await UiInput.open(self, SCREEN)
	var screen: Control = opened["screen"]
	var button: Button = _select(screen)
	assert_true(button.disabled)
	assert_eq(button.text, "Locked")
	UiInput.click(opened["viewport"], _skin_button(screen, "Glitch"))
	assert_eq(
		(screen.get_node(STAGE) as FighterStage).model.skin_id,
		"glitch",
		"a locked fighter can be looked at"
	)
	UiInput.click(opened["viewport"], button)
	UiInput.touch(opened["viewport"], button)
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown, screen.get_parent(), "the screen did not change")
	assert_eq(GameState.selected_fighter, "blaze", "the choice did not change")
	await UiInput.close(self, shown)


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


func test_back_goes_home_by_click_and_by_touch() -> void:
	for use_touch: bool in [false, true]:
		var opened: Dictionary = await UiInput.open(self, SCREEN)
		var back: Control = opened["screen"].get_node("Margin/Column/Header/BackButton")
		if use_touch:
			UiInput.touch(opened["viewport"], back)
		else:
			UiInput.click(opened["viewport"], back)
		var shown: Node = await UiInput.settle(self, opened)
		assert_eq(shown.scene_file_path, Screens.HOME, "touch: %s" % use_touch)
		assert_eq(GameState.selected_fighter, "blaze", "Back changes nothing")
		await UiInput.close(self, shown)


func test_trophies_and_prestige_follow_progress_from_another_tab() -> void:
	var screen: Control = _show("turbo")
	var badge: Control = screen.get_node(STATS + "/PrestigeBadge")
	assert_false(badge.visible)
	GameState.trophies["turbo"] = 1005
	GameState.progress_changed.emit()
	assert_eq(screen.get_node(STATS + "/TrophiesChip").text, "1005")
	assert_true(badge.visible)
	assert_eq(badge.get_node("Label").text, "Prestige 1")
