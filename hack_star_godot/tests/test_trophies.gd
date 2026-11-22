extends GutTest

var _settings: MatchSettings


func before_each() -> void:
	_settings = MatchSettings.new()


func test_a_victory_gives_the_win_trophies() -> void:
	assert_eq(Trophies.change_for(Match.Result.VICTORY, _settings), 10)
	_settings.trophies_per_win = 25
	assert_eq(Trophies.change_for(Match.Result.VICTORY, _settings), 25)


func test_a_defeat_and_a_time_up_give_nothing_by_default() -> void:
	assert_eq(Trophies.change_for(Match.Result.DEFEAT, _settings), 0)
	assert_eq(Trophies.change_for(Match.Result.TIME_UP, _settings), 0)
	assert_eq(Trophies.change_for(Match.Result.NONE, _settings), 0)


func test_a_defeat_takes_trophies_when_the_setting_says_so() -> void:
	_settings.trophies_per_defeat = -5
	assert_eq(Trophies.change_for(Match.Result.DEFEAT, _settings), -5)
	assert_eq(Trophies.change_for(Match.Result.TIME_UP, _settings), 0)


func test_reward_of_a_win() -> void:
	var reward: Dictionary = Trophies.reward(1240, Match.Result.VICTORY, _settings)
	assert_eq(reward["before"], 1240)
	assert_eq(reward["after"], 1250)
	assert_eq(reward["change"], 10)
	assert_eq(reward["prestige_before"], 1)
	assert_eq(reward["prestige_after"], 1)


func test_a_win_can_reach_a_new_prestige() -> void:
	var reward: Dictionary = Trophies.reward(1995, Match.Result.VICTORY, _settings)
	assert_eq(reward["after"], 2005)
	assert_eq(reward["prestige_before"], 1)
	assert_eq(reward["prestige_after"], 2)


func test_trophies_never_drop_below_the_last_prestige() -> void:
	_settings.trophies_per_defeat = -30
	var reward: Dictionary = Trophies.reward(1010, Match.Result.DEFEAT, _settings)
	assert_eq(reward["after"], 1000)
	assert_eq(reward["change"], -10)
	assert_eq(reward["prestige_after"], 1)


func test_trophies_never_drop_below_zero() -> void:
	_settings.trophies_per_defeat = -30
	var reward: Dictionary = Trophies.reward(12, Match.Result.DEFEAT, _settings)
	assert_eq(reward["after"], 0)
	assert_eq(reward["change"], -12)
