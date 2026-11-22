extends GutTest
## The trophy part of the result screen (spec 08, S4, S5, S12, D6).

const RESULT_SCENE: PackedScene = preload("res://scenes/result_screen.tscn")
const TROPHIES: String = "Margin/Column/TrophyPanel/Trophies"


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _show_with(outcome: Match.Result, before: int, with_reward: bool = true) -> Control:
	GameState.last_result = {"outcome": outcome, "place": 2, "fighter": "blaze", "skin": "default"}
	if with_reward:
		GameState.last_result["reward"] = Trophies.reward(before, outcome, GameState.match_settings)
	var screen: Control = RESULT_SCENE.instantiate()
	add_child_autofree(screen)
	return screen


func test_a_victory_counts_up_to_ten_trophies_and_the_next_prestige() -> void:
	var screen: Control = _show_with(Match.Result.VICTORY, 1240)
	assert_eq(screen.get_node(TROPHIES + "/ChangeLabel").text, "+0 trophies", "the count starts")
	screen.finish_count()
	assert_eq(screen.get_node(TROPHIES + "/ChangeLabel").text, "+10 trophies")
	assert_eq(screen.get_node(TROPHIES + "/CountLabel").text, "1250 / 2000")
	var bar: ProgressBar = screen.get_node(TROPHIES + "/PrestigeBar")
	assert_eq(bar.min_value, 1000.0)
	assert_eq(bar.max_value, 2000.0)
	assert_eq(bar.value, 1250.0)
	assert_false(bar.show_percentage)


func test_the_count_runs_in_between() -> void:
	var screen: Control = _show_with(Match.Result.VICTORY, 1240)
	await wait_seconds(0.4)
	var count: int = int(screen.get_node(TROPHIES + "/ChangeLabel").text.split(" ")[0])
	assert_between(count, 1, 9, "part of the way")
	await wait_seconds(1.0)
	assert_eq(screen.get_node(TROPHIES + "/ChangeLabel").text, "+10 trophies")


func test_a_defeat_shows_no_change() -> void:
	var screen: Control = _show_with(Match.Result.DEFEAT, 1240)
	screen.finish_count()
	assert_eq(screen.get_node(TROPHIES + "/ChangeLabel").text, "+0 trophies")
	assert_eq(screen.get_node(TROPHIES + "/CountLabel").text, "1240 / 2000")


func test_a_loss_is_shown_with_its_sign() -> void:
	GameState.match_settings.trophies_per_defeat = -20
	var screen: Control = _show_with(Match.Result.DEFEAT, 1240)
	screen.finish_count()
	assert_eq(screen.get_node(TROPHIES + "/ChangeLabel").text, "-20 trophies")


func test_a_win_to_a_new_prestige_is_celebrated() -> void:
	var screen: Control = _show_with(Match.Result.VICTORY, 1990)
	assert_false(screen.get_node(TROPHIES + "/Celebration").visible, "not at the start")
	screen.finish_count()
	var celebration: Control = screen.get_node(TROPHIES + "/Celebration")
	assert_true(celebration.visible)
	assert_eq(celebration.get_node("PrestigeLabel").text, "PRESTIGE 2!")
	var badge: PrestigeBadge = celebration.get_node("PrestigeBadge")
	assert_true(badge.visible)
	assert_eq(badge.get_node("Label").text, "Prestige 2")
	assert_eq(screen.get_node(TROPHIES + "/CountLabel").text, "2000 / 3000")
	await wait_seconds(0.5)
	assert_eq(celebration.scale, Vector2.ONE, "the pop is over")


func test_no_celebration_without_a_new_prestige() -> void:
	var screen: Control = _show_with(Match.Result.VICTORY, 1240)
	screen.finish_count()
	assert_false(screen.get_node(TROPHIES + "/Celebration").visible)


func test_a_result_without_a_reward_hides_the_panel() -> void:
	var screen: Control = _show_with(Match.Result.VICTORY, 1240, false)
	assert_false(screen.get_node("Margin/Column/TrophyPanel").visible)
	screen.finish_count()
