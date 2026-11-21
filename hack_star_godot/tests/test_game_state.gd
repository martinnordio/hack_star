extends GutTest

const TEST_SAVE: String = "user://test/game_state_save.json"

var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


func test_starts_from_the_sample_progress() -> void:
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skin(), Fighters.DEFAULT_SKIN)
	assert_eq(GameState.credits, SampleProgress.CREDITS)
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_eq(GameState.power_levels["rocko"], 4)
	assert_eq(GameState.unlocked, ["blaze", "rocko", "turbo"])
	assert_false(GameState.entrance_played)


func test_total_trophies_adds_every_fighter() -> void:
	assert_eq(GameState.total_trophies(), 1240 + 420 + 85)
	GameState.trophies["pixel"] = 100
	assert_eq(GameState.total_trophies(), 1240 + 420 + 85 + 100)


func test_select_an_unlocked_fighter_and_skin() -> void:
	assert_true(GameState.select("rocko", "crystal"))
	assert_eq(GameState.selected_fighter, "rocko")
	assert_eq(GameState.selected_skin(), "crystal")


func test_the_choice_of_a_skin_is_kept_per_fighter() -> void:
	GameState.select("blaze", "lava")
	GameState.select("rocko", "default")
	GameState.select("blaze", "lava")
	assert_eq(GameState.selected_skins["rocko"], "default")
	assert_eq(GameState.selected_skin(), "lava")


func test_a_locked_fighter_is_refused() -> void:
	assert_false(GameState.select("pixel", "default"))
	assert_eq(GameState.selected_fighter, "blaze", "the choice is unchanged")
	assert_eq(GameState.selected_skins["pixel"], Fighters.DEFAULT_SKIN)


func test_an_unknown_skin_or_fighter_is_refused() -> void:
	assert_false(GameState.select("blaze", "crystal"))
	assert_false(GameState.select("nobody", "default"))
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skin(), Fighters.DEFAULT_SKIN)


func test_reset_forgets_the_choices() -> void:
	GameState.select("turbo", "neon")
	GameState.entrance_played = true
	GameState.reset()
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skins["turbo"], Fighters.DEFAULT_SKIN)
	assert_false(GameState.entrance_played)


func test_activate_a_hack_saves_it_and_a_new_start_loads_it() -> void:
	assert_true(GameState.activate_hack(Hacks.POWER22))
	assert_true(GameState.has_hack(Hacks.POWER22))
	assert_true(FileAccess.file_exists(TEST_SAVE))
	GameState.reset()
	assert_eq(GameState.active_hacks, [], "reset does not read the file")
	GameState.active_hacks = GameState._load_hacks()
	assert_eq(GameState.active_hacks, [Hacks.POWER22])


func test_unknown_or_active_hacks_are_ignored() -> void:
	assert_false(GameState.activate_hack("hypercharge"))
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	assert_false(GameState.activate_hack(Hacks.UNLOCK_ALL))
	assert_eq(GameState.active_hacks, [Hacks.UNLOCK_ALL])


func test_unlock_all_makes_a_locked_fighter_selectable_and_reset_brings_the_rules_back() -> void:
	assert_false(GameState.select("luna", "default"))
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	assert_true(GameState.is_unlocked("luna"))
	assert_true(GameState.select("luna", "galaxy"))
	GameState.reset_hacks()
	assert_eq(GameState.active_hacks, [])
	assert_false(GameState.is_unlocked("pixel"))
	assert_false(GameState.select("pixel", "default"))
	assert_eq(GameState._load_hacks(), [], "the cleared list is saved")


func test_reset_empties_the_hacks_in_memory_without_saving() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.reset()
	assert_eq(GameState.active_hacks, [])
	assert_eq(GameState._load_hacks(), [Hacks.INFINITE_CREDITS])
