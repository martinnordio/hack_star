extends GutTest

const LIST: PackedScene = preload("res://scenes/fighter_list.tscn")
const GRID_PATH: String = "Margin/Column/Scroll/Grid"


func before_each() -> void:
	GameState.reset()


func _show_list() -> Control:
	var screen: Control = autofree(LIST.instantiate())
	add_child(screen)
	return screen


func _card(screen: Control, fighter_id: String) -> FighterCard:
	return screen.get_node(GRID_PATH).get_node(fighter_id.capitalize())


func test_has_six_cards_in_catalogue_order() -> void:
	var screen: Control = _show_list()
	var ids: Array[String] = []
	for card: FighterCard in screen.get_node(GRID_PATH).get_children():
		ids.append(card.fighter_id)
	assert_eq(ids, Fighters.ids())
	assert_eq(ids.size(), 6)


func test_card_shows_name_rarity_trophies_and_power() -> void:
	var card: FighterCard = _card(_show_list(), "blaze")
	assert_eq(card.get_node("Column/NameLabel").text, "Blaze")
	assert_eq(card.get_node("Column/RarityLabel").text, "Rare")
	assert_eq(card.get_node("Column/TrophiesLabel").text, "Trophies: 1240")
	assert_eq(card.get_node("Column/PowerLabel").text, "Power 7 / 11")


func test_rarity_is_shown_in_its_colour() -> void:
	var label: Label = _card(_show_list(), "pixel").get_node("Column/RarityLabel")
	assert_eq(label.get_theme_color("font_color"), Rarity.color("Legendary"))


func test_blaze_shows_prestige_1_and_the_others_no_badge() -> void:
	var screen: Control = _show_list()
	var badge: PrestigeBadge = _card(screen, "blaze").get_node("Column/PrestigeBadge")
	assert_true(badge.visible)
	assert_eq(badge.get_node("Label").text, "Prestige 1")
	for fighter_id: String in ["rocko", "turbo", "frosty", "luna", "pixel"]:
		var other: PrestigeBadge = _card(screen, fighter_id).get_node("Column/PrestigeBadge")
		assert_false(other.visible, "%s has no badge" % fighter_id)


func test_locked_fighters_are_greyed_out_with_a_lock() -> void:
	var screen: Control = _show_list()
	for fighter_id: String in ["frosty", "luna", "pixel"]:
		var card: FighterCard = _card(screen, fighter_id)
		assert_true(card.get_node("Column/LockLabel").visible, "%s shows the lock" % fighter_id)
		assert_lt(card.modulate.r, 1.0, "%s is greyed out" % fighter_id)
	for fighter_id: String in ["blaze", "rocko", "turbo"]:
		var card: FighterCard = _card(screen, fighter_id)
		assert_false(card.get_node("Column/LockLabel").visible, "%s has no lock" % fighter_id)
		assert_eq(card.modulate, Color.WHITE)


func test_cached_pictures_are_used_without_rendering_again() -> void:
	var texture: ImageTexture = ImageTexture.create_from_image(
		Image.create(4, 4, false, Image.FORMAT_RGBA8)
	)
	for fighter_id: String in Fighters.ids():
		GameState.pictures[FighterPictures.key(fighter_id, "default")] = texture
	var screen: Control = _show_list()
	assert_eq(_card(screen, "luna").get_node("Column/Picture").texture, texture)
	assert_eq(screen.get_children().size(), 2, "no off-screen stage was added")


func test_columns_follow_the_width() -> void:
	var holder: Control = autofree(Control.new())
	add_child(holder)
	var screen: Control = LIST.instantiate()
	holder.add_child(screen)
	var grid: GridContainer = screen.get_node(GRID_PATH)
	holder.size = Vector2(1280, 720)
	await wait_process_frames(2)
	assert_eq(grid.columns, 4)
	holder.size = Vector2(500, 900)
	await wait_process_frames(2)
	assert_eq(grid.columns, 1)


## The card's button, with the list scrolled so that the whole card is in view.
func _scrolled_to(screen: Control, fighter_id: String) -> Control:
	var card: FighterCard = _card(screen, fighter_id)
	(screen.get_node("Margin/Column/Scroll") as ScrollContainer).ensure_control_visible(card)
	await wait_process_frames(2)
	return card.get_node("OpenButton")


func test_back_goes_home_by_click_and_by_touch() -> void:
	for use_touch: bool in [false, true]:
		var opened: Dictionary = await UiInput.open(self, LIST)
		var back: Control = opened["screen"].get_node("Margin/Column/Header/BackButton")
		if use_touch:
			UiInput.touch(opened["viewport"], back)
		else:
			UiInput.click(opened["viewport"], back)
		var shown: Node = await UiInput.settle(self, opened)
		assert_eq(shown.scene_file_path, Screens.HOME, "Back opens home (touch: %s)" % use_touch)
		await UiInput.close(self, shown)


func test_clicking_a_card_opens_its_fighter_screen() -> void:
	var opened: Dictionary = await UiInput.open(self, LIST)
	var card_button: Control = await _scrolled_to(opened["screen"], "turbo")
	UiInput.click(opened["viewport"], card_button)
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.FIGHTER)
	assert_eq(GameState.viewed_fighter, "turbo")
	await UiInput.close(self, shown)


func test_touching_a_locked_card_opens_its_fighter_screen_too() -> void:
	var opened: Dictionary = await UiInput.open(self, LIST)
	var card_button: Control = await _scrolled_to(opened["screen"], "pixel")
	UiInput.touch(opened["viewport"], card_button)
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.FIGHTER, "a locked card can be opened too")
	assert_eq(GameState.viewed_fighter, "pixel")
	await UiInput.close(self, shown)
