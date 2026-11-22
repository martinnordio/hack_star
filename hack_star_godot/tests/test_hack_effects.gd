extends GutTest
## What the active hacks change on home, the fighter list and the fighter screen (spec 05, S4-S6,
## S9, S12).

const HOME: PackedScene = preload("res://scenes/home.tscn")
const LIST: PackedScene = preload("res://scenes/fighter_list.tscn")
const FIGHTER: PackedScene = preload("res://scenes/fighter_screen.tscn")
const TEST_SAVE: String = "user://test/hack_effects_save.json"
const CREDITS_PATH: String = "Margin/Column/TopBar/CreditsChip"
const GRID_PATH: String = "Margin/Column/Scroll/Grid"
const DETAILS: String = "Margin/Column/Body/Details"
const LOCK_ICON: String = "Column/Backdrop/LockIcon"
const CARD_POWER: String = "Column/Stats/PowerChip"

var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()
	GameState.entrance_played = true


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


func _show(scene: PackedScene) -> Control:
	var screen: Control = autofree(scene.instantiate())
	add_child(screen)
	return screen


func _card(screen: Control, fighter_id: String) -> FighterCard:
	return screen.get_node(GRID_PATH).get_node(fighter_id.capitalize())


func test_home_shows_infinity_with_unlimited_credits_and_the_number_without() -> void:
	assert_eq(_show(HOME).get_node(CREDITS_PATH).text, "500")
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	assert_eq(_show(HOME).get_node(CREDITS_PATH).text, "∞")
	GameState.reset_hacks()
	assert_eq(_show(HOME).get_node(CREDITS_PATH).text, "500")


func test_unlock_all_unlocks_every_card_and_reset_locks_them_again() -> void:
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	var list: Control = _show(LIST)
	for fighter_id: String in Fighters.ids():
		var card: FighterCard = _card(list, fighter_id)
		assert_false(card.get_node(LOCK_ICON).visible, "%s has no lock" % fighter_id)
		assert_false(card.is_picture_grey(), "%s is not greyed out" % fighter_id)
	GameState.reset_hacks()
	list = _show(LIST)
	for fighter_id: String in ["frosty", "luna", "pixel"]:
		assert_true(_card(list, fighter_id).get_node(LOCK_ICON).visible)


func test_with_unlock_all_select_works_for_luna() -> void:
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.viewed_fighter = "luna"
	var opened: Dictionary = await UiInput.open(self, FIGHTER)
	var button: Button = opened["screen"].get_node(DETAILS + "/SelectButton")
	assert_false(button.disabled)
	assert_eq(button.text, "Select")
	UiInput.click(opened["viewport"], button)
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.HOME)
	assert_eq(GameState.selected_fighter, "luna")
	await UiInput.close(self, shown)


func test_without_the_hack_luna_stays_locked() -> void:
	GameState.viewed_fighter = "luna"
	var screen: Control = _show(FIGHTER)
	assert_true(screen.get_node(DETAILS + "/SelectButton").disabled)


func test_power_shows_its_maximum_with_and_without_power_22() -> void:
	assert_eq(_card(_show(LIST), "blaze").get_node(CARD_POWER).text, "7 / 11")
	GameState.viewed_fighter = "blaze"
	assert_eq(_show(FIGHTER).get_node(DETAILS + "/PowerLabel").text, "Power 7 / 11")
	GameState.activate_hack(Hacks.POWER22)
	assert_eq(_card(_show(LIST), "blaze").get_node(CARD_POWER).text, "7 / 22")
	assert_eq(_show(FIGHTER).get_node(DETAILS + "/PowerLabel").text, "Power 7 / 22")
	GameState.reset_hacks()
	assert_eq(_card(_show(LIST), "blaze").get_node(CARD_POWER).text, "7 / 11")


func test_the_hacks_change_no_trophies_unlocks_or_power_levels() -> void:
	for hack_id: String in Hacks.ids():
		GameState.activate_hack(hack_id)
	assert_eq(GameState.unlocked, ["blaze", "rocko", "turbo"])
	assert_eq(GameState.power_levels["blaze"], 7)
	assert_eq(GameState.credits, 500)
	assert_eq(GameState.total_trophies(), 1240 + 420 + 85)
