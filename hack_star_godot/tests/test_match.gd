extends GutTest

var _settings: MatchSettings


func before_each() -> void:
	_settings = MatchSettings.new()


func _fighting(fighter_count: int = 4) -> Match:
	var match_state: Match = Match.new(_settings, fighter_count)
	match_state.advance(_settings.countdown_seconds)
	return match_state


func test_countdown_texts_then_fight() -> void:
	var match_state: Match = Match.new(_settings, 4)
	assert_eq(match_state.countdown_text(), "3")
	match_state.advance(1.0)
	assert_eq(match_state.countdown_text(), "2")
	match_state.advance(1.0)
	assert_eq(match_state.countdown_text(), "1")
	match_state.advance(1.0)
	assert_eq(match_state.countdown_text(), "FIGHT!")
	match_state.advance(0.7)
	assert_eq(match_state.countdown_text(), "")


func test_nobody_acts_during_the_countdown() -> void:
	var match_state: Match = Match.new(_settings, 4)
	assert_false(match_state.can_act())
	match_state.advance(2.9)
	assert_false(match_state.can_act())
	match_state.advance(0.2)
	assert_true(match_state.can_act())


func test_timer_text_and_red_in_the_last_ten_seconds() -> void:
	var match_state: Match = Match.new(_settings, 4)
	assert_eq(match_state.timer_text(), "2:00")
	match_state.advance(3.0 + 1.0)
	assert_eq(match_state.timer_text(), "1:59")
	assert_false(match_state.timer_red())
	match_state.advance(109.0)
	assert_eq(match_state.timer_text(), "0:10")
	assert_true(match_state.timer_red())


func test_knocking_out_all_bots_is_a_victory_with_place_1() -> void:
	var match_state: Match = _fighting()
	match_state.knock_out(1)
	match_state.knock_out(2)
	assert_eq(match_state.phase, Match.Phase.FIGHT)
	match_state.knock_out(3)
	assert_eq(match_state.phase, Match.Phase.OVER)
	assert_eq(match_state.result, Match.Result.VICTORY)
	assert_eq(match_state.place, 1)


func test_the_player_out_with_two_bots_left_is_place_3() -> void:
	var match_state: Match = _fighting()
	match_state.knock_out(3)
	match_state.knock_out(0)
	assert_eq(match_state.result, Match.Result.DEFEAT)
	assert_eq(match_state.place, 3)
	assert_eq(Match.ordinal(match_state.place), "3rd")


func test_time_up_with_bots_left_is_a_draw() -> void:
	var match_state: Match = _fighting()
	match_state.advance(120.0)
	assert_eq(match_state.result, Match.Result.TIME_UP)
	assert_eq(match_state.timer_text(), "0:00")


func test_time_up_can_be_a_defeat_with_a_place() -> void:
	_settings.time_up_result = MatchSettings.TIME_UP_DEFEAT
	var match_state: Match = _fighting()
	match_state.knock_out(2)
	match_state.advance(120.0)
	assert_eq(match_state.result, Match.Result.DEFEAT)
	assert_eq(match_state.place, 3)


func test_fighters_left_and_a_second_knock_out_counts_once() -> void:
	var match_state: Match = _fighting()
	assert_eq(match_state.fighters_left(), 4)
	match_state.knock_out(2)
	match_state.knock_out(2)
	assert_eq(match_state.fighters_left(), 3)
	assert_eq(match_state.knock_out_order, [2] as Array[int])


func test_nothing_changes_after_the_match_is_over() -> void:
	var match_state: Match = _fighting()
	match_state.knock_out(0)
	match_state.advance(500.0)
	match_state.knock_out(1)
	assert_eq(match_state.result, Match.Result.DEFEAT)
	assert_eq(match_state.fighters_left(), 3)


func test_ordinals() -> void:
	var expected: Dictionary = {
		1: "1st",
		2: "2nd",
		3: "3rd",
		4: "4th",
		11: "11th",
		12: "12th",
		13: "13th",
		21: "21st",
		22: "22nd",
	}
	for n: int in expected:
		assert_eq(Match.ordinal(n), expected[n])
