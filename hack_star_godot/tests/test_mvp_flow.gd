extends GutTest
## The first playable version end to end (spec 08, S14, D10): home, hack code, fighter list,
## fighter screen, a match, the result screen, home again, and the progress after a restart.
## Real clicks go through `UiInput`; the screens change as in the game.

const HOME: PackedScene = preload("res://scenes/home.tscn")
const TEST_SAVE: String = "user://test/mvp_flow.json"
const HOME_CONTROLS: String = "Margin/Column/Body/Controls"
const BLAZE_CARD: String = "Margin/Column/Scroll/Grid/Blaze/OpenButton"
const FIGHTER_DETAILS: String = "Margin/Column/Body/Details"
const POWER22_BODY: String = '{"id": "power22", "code": "POWER22", "name": "Power 22"}'

var _previous: Node
var _root_size: Vector2i
var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()
	GameState.entrance_played = true


func after_each() -> void:
	HackServer.fake_responder = Callable()
	var tree: SceneTree = get_tree()
	var shown: Node = tree.current_scene
	tree.current_scene = _previous
	tree.root.size = _root_size
	if is_instance_valid(shown) and shown != _previous:
		shown.queue_free()
	await wait_process_frames(1)
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


# Clicks the control at `path` of the current screen and waits for the screen change.
func _click(path: String) -> Node:
	var tree: SceneTree = get_tree()
	UiInput.click(tree.root, _current().get_node(path))
	await wait_process_frames(3)
	return _current()


# The shown screen; the first one sits under the placeholder of `UiInput.open`.
func _current() -> Node:
	var scene: Node = get_tree().current_scene
	return scene if not scene.scene_file_path.is_empty() else scene.get_child(0)


func test_from_home_to_a_won_match_and_back_with_the_progress_kept() -> void:
	var opened: Dictionary = await UiInput.open(self, HOME)
	_previous = opened["previous"]
	_root_size = opened["root_size"]
	var tree: SceneTree = get_tree()

	var screen: Node = await _click(HOME_CONTROLS + "/MoreRow/HackButton")
	assert_eq(screen.scene_file_path, Screens.HACK, "Hack opens the hack screen")
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {"status": 200, "body": POWER22_BODY}
	await screen.submit("power22")
	assert_true(GameState.has_hack(Hacks.POWER22), "the code turns the hack on")
	screen = await _click("Margin/Column/Header/BackButton")
	assert_eq(screen.scene_file_path, Screens.HOME)

	screen = await _click(HOME_CONTROLS + "/MoreRow/FightersButton")
	assert_eq(screen.scene_file_path, Screens.FIGHTERS)
	screen = await _click(BLAZE_CARD)
	assert_eq(screen.scene_file_path, Screens.FIGHTER)
	await _click(FIGHTER_DETAILS + "/SkinRow/Lava")
	screen = await _click(FIGHTER_DETAILS + "/SelectButton")
	assert_eq(screen.scene_file_path, Screens.HOME, "Select goes home")
	assert_eq(GameState.selected_skin(), "lava")

	GameState.match_settings.bot_count = 1
	GameState.match_settings.countdown_seconds = 0
	var arena: MatchArena = await _click(HOME_CONTROLS + "/PlayButton")
	assert_eq(arena.scene_file_path, Screens.MATCH, "Play opens the match")
	arena.bots()[0].knock_out()
	await wait_seconds(MatchArena.END_WAIT_SECONDS + 0.3)
	var result: Node = tree.current_scene
	assert_eq(result.scene_file_path, Screens.RESULT, "the result screen opens")
	result.finish_count()
	assert_eq(
		result.get_node("Margin/Column/TrophyPanel/Trophies/ChangeLabel").text, "+10 trophies"
	)
	assert_eq(result.get_node("Margin/Column/TrophyPanel/Trophies/CountLabel").text, "1250 / 2000")

	screen = await _click("Margin/Column/Body/Controls/HomeButton")
	assert_eq(screen.scene_file_path, Screens.HOME)
	assert_eq(screen.get_node("Margin/Column/TopBar/TrophiesChip").text, "1755")
	assert_true(screen.get_node(HOME_CONTROLS + "/NameRow/PrestigeBadge").visible, "the badge")

	GameState.reset()
	GameState.load_saved()
	assert_eq(GameState.trophies["blaze"], 1250, "the trophies are kept")
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skin(), "lava", "the choice is kept")
	assert_true(GameState.has_hack(Hacks.POWER22), "the hack is kept")
