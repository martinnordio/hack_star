extends GutTest
## The progress saved between visits (spec 08, S3, S11, D4).

const TEST_SAVE: String = "user://test/game_state_progress.json"

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


# A new game start: the sample progress, then the file.
func _restart() -> void:
	GameState.reset()
	GameState.load_saved()


func test_a_fresh_start_is_the_sample_progress() -> void:
	GameState.load_saved()
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.active_hacks, [])


func test_reset_writes_nothing() -> void:
	GameState.reset()
	assert_false(FileAccess.file_exists(TEST_SAVE))


func test_saved_progress_comes_back_after_a_restart() -> void:
	GameState.trophies["blaze"] = 1300
	GameState.power_levels["rocko"] = 6
	GameState.credits = 321
	GameState.unlocked.append("pixel")
	GameState.save()
	_restart()
	assert_eq(GameState.trophies["blaze"], 1300)
	assert_eq(GameState.trophies["rocko"], 420)
	assert_eq(GameState.power_levels["rocko"], 6)
	assert_eq(GameState.credits, 321)
	assert_true(GameState.unlocked.has("pixel"))
	assert_eq(GameState.unlocked.count("blaze"), 1)


func test_select_saves_the_choice() -> void:
	assert_true(GameState.select("rocko", Fighters.DEFAULT_SKIN))
	_restart()
	assert_eq(GameState.selected_fighter, "rocko")
	assert_eq(GameState.viewed_fighter, "rocko")


func test_the_skin_of_a_fighter_comes_back() -> void:
	var skin: String = Fighters.get_fighter("blaze")["skins"][1]["id"]
	assert_true(GameState.select("blaze", skin))
	_restart()
	assert_eq(GameState.selected_skins["blaze"], skin)


func test_an_active_hack_is_saved_but_not_written_into_the_progress() -> void:
	GameState.activate_hack("unlock_all")
	var text: String = FileAccess.get_file_as_string(TEST_SAVE)
	var saved: Dictionary = SaveData.from_json(text)
	assert_eq(saved["hacks"], ["unlock_all"])
	assert_eq(saved["progress"]["unlocked"], ["blaze", "rocko", "turbo"])
	_restart()
	assert_true(GameState.has_hack("unlock_all"))
	GameState.reset_hacks()
	_restart()
	assert_eq(GameState.active_hacks, [])


func test_a_file_of_spec_05_keeps_its_hacks_and_the_sample_progress() -> void:
	DirAccess.make_dir_recursive_absolute("user://test")
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string('{"version": 1, "hacks": ["power22"]}')
	file.close()
	_restart()
	assert_eq(GameState.active_hacks, ["power22"])
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_eq(GameState.credits, SampleProgress.CREDITS)


func test_a_broken_file_starts_from_the_sample_progress() -> void:
	DirAccess.make_dir_recursive_absolute("user://test")
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string("{not json")
	file.close()
	_restart()
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_eq(GameState.active_hacks, [])


func test_a_saved_fighter_that_is_not_unlocked_is_not_selected() -> void:
	DirAccess.make_dir_recursive_absolute("user://test")
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string('{"version": 2, "hacks": [], "progress": {"selected_fighter": "pixel"}}')
	file.close()
	_restart()
	assert_eq(GameState.selected_fighter, "blaze")


func test_award_trophies_adds_and_saves() -> void:
	var reward: Dictionary = GameState.award_trophies("blaze", Match.Result.VICTORY)
	assert_eq(reward["change"], 10)
	assert_eq(GameState.trophies["blaze"], 1250)
	_restart()
	assert_eq(GameState.trophies["blaze"], 1250)
