extends GutTest
## The match HUD (`Hud/MatchHud` of `match.tscn`, spec 07 D9): countdown, timer, fighters left;
## the timer and fighters left as icon chips and the FPS label hidden for players (spec 09, G12).

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


func _chip(chip_name: String) -> IconChip:
	return _arena.get_node("Hud/MatchHud/%s" % chip_name)


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
	var timer: IconChip = _chip("TimerChip")
	assert_eq(timer.text, "0:12")
	assert_eq(timer.text_color, Color.WHITE, "not red at first")
	await wait_seconds(3.5)
	assert_eq(timer.text, "0:09")
	assert_eq(timer.text_color, Combat.COLOR_RED, "red in the last 10 s")
	assert_eq(timer.get_node("Row/Label").get_theme_color("font_color"), Combat.COLOR_RED)


func test_a_full_match_starts_at_two_minutes() -> void:
	await _open(3, 3, 120.0)
	assert_eq(_chip("TimerChip").text, "2:00")


func test_fighters_left_drops_after_a_knock_out() -> void:
	await _open(3, 0, 120.0)
	assert_eq(_chip("FightersLeftChip").text, "4")
	_arena.bots()[0].knock_out()
	assert_eq(_chip("FightersLeftChip").text, "3")


func test_timer_and_fighters_left_have_their_icons() -> void:
	await _open(1, 0, 120.0)
	assert_eq(_chip("TimerChip").get_node("Row/Icon").texture, Icons.get_icon("clock"))
	assert_eq(_chip("FightersLeftChip").get_node("Row/Icon").texture, Icons.get_icon("fighters"))


func test_the_fps_label_is_hidden_unless_switched_on() -> void:
	await _open(1, 0, 120.0)
	assert_false(_arena.get_node("Hud/FpsLabel").visible, "hidden for players")
	_arena.queue_free()
	await wait_process_frames(1)
	GameState.show_fps = true
	await _open(1, 0, 120.0)
	assert_true(_arena.get_node("Hud/FpsLabel").visible, "shown for the play-test")
