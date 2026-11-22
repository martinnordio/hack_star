extends GutTest


func test_defaults() -> void:
	var settings: MatchSettings = MatchSettings.new()
	assert_eq(settings.match_seconds, 120.0)
	assert_eq(settings.bot_count, 3)
	assert_eq(settings.bot_level, "easy")
	assert_eq(settings.time_up_result, "draw")
	assert_true(settings.bots_fight_each_other)
	assert_eq(settings.fighter_health, 3200)
	assert_eq(settings.bush_sight, 2.5)


func test_bot_count_is_clamped_to_1_to_8() -> void:
	var settings: MatchSettings = MatchSettings.new()
	settings.bot_count = 0
	assert_eq(settings.bot_count, 1)
	settings.bot_count = 20
	assert_eq(settings.bot_count, 8)
	settings.bot_count = 5
	assert_eq(settings.bot_count, 5)


func test_easy_is_slower_and_worse_than_hard() -> void:
	var easy: Dictionary = MatchSettings.level("easy")
	var hard: Dictionary = MatchSettings.level("hard")
	assert_gt(easy["reaction"], hard["reaction"])
	assert_gt(easy["aim_error"], hard["aim_error"])
	assert_gt(easy["cooldown"], hard["cooldown"])
	assert_lt(easy["speed"], hard["speed"])


func test_an_unknown_level_gives_easy() -> void:
	assert_eq(MatchSettings.level("impossible"), MatchSettings.level("easy"))


func test_game_state_holds_new_settings_after_reset() -> void:
	GameState.match_settings.bot_count = 6
	GameState.reset()
	assert_eq(GameState.match_settings.bot_count, MatchSettings.BOT_COUNT)


func test_trophy_settings_are_clamped() -> void:
	var settings: MatchSettings = MatchSettings.new()
	assert_eq(settings.trophies_per_win, 10)
	assert_eq(settings.trophies_per_defeat, 0)
	settings.trophies_per_win = -4
	assert_eq(settings.trophies_per_win, 0)
	settings.trophies_per_defeat = 7
	assert_eq(settings.trophies_per_defeat, 0)
	settings.trophies_per_defeat = -7
	assert_eq(settings.trophies_per_defeat, -7)
