extends GutTest
## The result screen (`result_screen.tscn`, spec 07 D10).

const RESULT_SCENE: PackedScene = preload("res://scenes/result_screen.tscn")
const HEADING: String = "Margin/Column/Heading"
const LINE: String = "Margin/Column/Line"
const STAGE: String = "Margin/Column/Body/FighterStage"
const PLAY_AGAIN: String = "Margin/Column/Body/Controls/PlayAgainButton"
const HOME_BUTTON: String = "Margin/Column/Body/Controls/HomeButton"


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _set_result(outcome: Match.Result, place: int) -> void:
	GameState.select("rocko", "crystal")
	GameState.last_result = {
		"outcome": outcome,
		"place": place,
		"fighter": GameState.selected_fighter,
		"skin": GameState.selected_skin(),
	}


func _show_screen() -> Control:
	var screen: Control = RESULT_SCENE.instantiate()
	add_child_autofree(screen)
	return screen


func test_victory_shows_its_heading_and_line() -> void:
	_set_result(Match.Result.VICTORY, 1)
	var screen: Control = _show_screen()
	assert_eq(screen.get_node(HEADING).text, "Victory!")
	assert_eq(screen.get_node(LINE).text, "You are the last one standing!")


func test_defeat_shows_the_place() -> void:
	_set_result(Match.Result.DEFEAT, 3)
	var screen: Control = _show_screen()
	assert_eq(screen.get_node(HEADING).text, "Defeat")
	assert_eq(screen.get_node(LINE).text, "You finished 3rd")


func test_time_up_is_a_draw() -> void:
	_set_result(Match.Result.TIME_UP, 0)
	var screen: Control = _show_screen()
	assert_eq(screen.get_node(HEADING).text, "Time's up!")
	assert_eq(screen.get_node(LINE).text, "It's a draw")


func test_the_stage_shows_the_players_fighter_and_skin() -> void:
	_set_result(Match.Result.VICTORY, 1)
	var stage: FighterStage = _show_screen().get_node(STAGE)
	assert_eq(stage.model.fighter_id, "rocko")
	assert_eq(stage.model.skin_id, "crystal")


func test_play_again_opens_the_match_and_home_goes_home() -> void:
	_set_result(Match.Result.VICTORY, 1)
	for target: Array in [[PLAY_AGAIN, Screens.MATCH], [HOME_BUTTON, Screens.HOME]]:
		var opened: Dictionary = await UiInput.open(self, RESULT_SCENE)
		UiInput.click(opened["viewport"], opened["screen"].get_node(target[0]))
		var shown: Node = await UiInput.settle(self, opened)
		assert_eq(shown.scene_file_path, target[1], "%s opens %s" % [target[0], target[1]])
		await UiInput.close(self, shown)


func test_showing_a_result_changes_neither_trophies_nor_credits() -> void:
	_set_result(Match.Result.VICTORY, 1)
	var trophies: int = GameState.total_trophies()
	var credits: int = GameState.credits
	_show_screen()
	assert_eq(GameState.total_trophies(), trophies)
	assert_eq(GameState.credits, credits)


func test_with_no_result_it_goes_home() -> void:
	var opened: Dictionary = await UiInput.open(self, RESULT_SCENE)
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.HOME)
	await UiInput.close(self, shown)
