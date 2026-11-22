extends GutTest
## The match HUD (`Hud/MatchHud` of `match.tscn`, spec 07 D9): countdown, timer, fighters left.

const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")

var _arena: MatchArena


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _open(bot_count: int, countdown: int, seconds: float) -> void:
	GameState.match_settings.bot_count = bot_count
	GameState.match_settings.countdown_seconds = countdown
	GameState.match_settings.match_seconds = seconds
	_arena = MATCH_SCENE.instantiate()
	_arena.read_player_input = false
	add_child_autofree(_arena)
	await wait_physics_frames(2)


func _label(label_name: String) -> Label:
	return _arena.get_node("Hud/MatchHud/%s" % label_name)


func test_the_countdown_shows_3_then_fight_then_nothing() -> void:
	await _open(1, 3, 120.0)
	assert_eq(_label("CountdownLabel").text, "3")
	assert_true(_label("CountdownLabel").visible)
	await wait_seconds(3.2)
	assert_eq(_label("CountdownLabel").text, "FIGHT!")
	await wait_seconds(Match.FIGHT_TEXT_SECONDS + 0.1)
	assert_eq(_label("CountdownLabel").text, "")
	assert_false(_label("CountdownLabel").visible)


func test_the_timer_counts_down_and_turns_red_in_the_last_ten_seconds() -> void:
	await _open(1, 0, 12.0)
	var timer: Label = _label("TimerLabel")
	assert_eq(timer.text, "0:12")
	assert_false(timer.has_theme_color_override("font_color"), "not red at first")
	await wait_seconds(3.5)
	assert_eq(timer.text, "0:09")
	assert_true(timer.has_theme_color_override("font_color"), "red in the last 10 s")
	assert_eq(timer.get_theme_color("font_color"), Combat.COLOR_RED)


func test_a_full_match_starts_at_two_minutes() -> void:
	await _open(3, 3, 120.0)
	assert_eq(_label("TimerLabel").text, "2:00")


func test_fighters_left_drops_after_a_knock_out() -> void:
	await _open(3, 0, 120.0)
	assert_eq(_label("FightersLeftLabel").text, "Fighters left: 4")
	_arena.bots()[0].knock_out()
	assert_eq(_label("FightersLeftLabel").text, "Fighters left: 3")
