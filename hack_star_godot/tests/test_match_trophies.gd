extends GutTest
## The trophies at the end of a match (spec 08, S1-S3, S7, D5).

const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TRAINING_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const TEST_SAVE: String = "user://test/match_trophies.json"

var _previous: Node
var _root_size: Vector2i
var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()


func after_each() -> void:
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


func _show(scene: PackedScene) -> Node:
	var tree: SceneTree = get_tree()
	_previous = tree.current_scene
	_root_size = tree.root.size
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	tree.root.size = Vector2i(1280, 720)
	var node: Node = scene.instantiate()
	placeholder.add_child(node)
	await wait_process_frames(2)
	return node


func _open_match(bot_count: int = 1) -> MatchArena:
	GameState.match_settings.bot_count = bot_count
	GameState.match_settings.countdown_seconds = 0
	return await _show(MATCH_SCENE)


func _saved_trophies(fighter_id: String) -> int:
	var text: String = FileAccess.get_file_as_string(TEST_SAVE)
	return SaveData.from_json(text)["progress"]["trophies"][fighter_id]


func test_a_victory_gives_ten_trophies_saved_before_the_result_screen() -> void:
	var arena: MatchArena = await _open_match()
	arena.bots()[0].knock_out()
	assert_eq(GameState.trophies["blaze"], 1250)
	assert_eq(_saved_trophies("blaze"), 1250, "saved at once")
	assert_ne(get_tree().current_scene.scene_file_path, Screens.RESULT, "the screen is not open")
	var reward: Dictionary = GameState.last_result["reward"]
	assert_eq(reward["before"], 1240)
	assert_eq(reward["after"], 1250)
	assert_eq(reward["change"], 10)


func test_the_trophies_go_to_the_selected_fighter_only() -> void:
	GameState.select("rocko", Fighters.DEFAULT_SKIN)
	var arena: MatchArena = await _open_match()
	arena.bots()[0].knock_out()
	assert_eq(GameState.trophies["rocko"], 430)
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_eq(GameState.total_trophies(), 1240 + 430 + 85)


func test_a_defeat_changes_no_trophies() -> void:
	var arena: MatchArena = await _open_match(3)
	arena.get_node("Fighter").hit(MatchSettings.FIGHTER_HEALTH)
	assert_eq(GameState.last_result["outcome"], Match.Result.DEFEAT)
	assert_eq(GameState.last_result["reward"]["change"], 0)
	assert_eq(GameState.trophies["blaze"], 1240)


func test_a_time_up_changes_no_trophies_unless_it_counts_as_a_defeat() -> void:
	GameState.match_settings.match_seconds = 1.0
	var arena: MatchArena = await _open_match()
	await wait_until(func() -> bool: return not GameState.last_result.is_empty(), 5.0)
	assert_eq(GameState.last_result["outcome"], Match.Result.TIME_UP)
	assert_eq(GameState.last_result["reward"]["change"], 0)
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_not_null(arena)


func test_a_time_up_counted_as_a_defeat_gets_the_trophies_of_a_defeat() -> void:
	GameState.match_settings.match_seconds = 1.0
	GameState.match_settings.time_up_result = MatchSettings.TIME_UP_DEFEAT
	GameState.match_settings.trophies_per_defeat = -20
	await _open_match()
	await wait_until(func() -> bool: return not GameState.last_result.is_empty(), 5.0)
	assert_eq(GameState.last_result["outcome"], Match.Result.DEFEAT)
	assert_eq(GameState.trophies["blaze"], 1220)


func test_the_prestige_floor_holds_after_a_defeat_with_a_loss() -> void:
	GameState.match_settings.trophies_per_defeat = -20
	GameState.trophies["blaze"] = 1005
	var arena: MatchArena = await _open_match(3)
	arena.get_node("Fighter").hit(MatchSettings.FIGHTER_HEALTH)
	assert_eq(GameState.trophies["blaze"], 1000)


func test_back_before_the_end_changes_nothing() -> void:
	var arena: MatchArena = await _open_match()
	(arena.get_node("Hud/BackButton") as Button).pressed.emit()
	await wait_process_frames(2)
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_false(FileAccess.file_exists(TEST_SAVE), "nothing saved")


func test_back_during_the_wait_keeps_the_saved_trophies() -> void:
	var arena: MatchArena = await _open_match()
	arena.bots()[0].knock_out()
	(arena.get_node("Hud/BackButton") as Button).pressed.emit()
	await wait_process_frames(2)
	assert_eq(GameState.trophies["blaze"], 1250)
	assert_eq(_saved_trophies("blaze"), 1250)


func test_training_changes_no_trophies() -> void:
	await _show(TRAINING_SCENE)
	await wait_seconds(0.3)
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_true(GameState.last_result.is_empty())
	assert_false(FileAccess.file_exists(TEST_SAVE), "nothing saved")


func test_a_hack_changes_no_trophies() -> void:
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	var before: int = GameState.total_trophies()
	var arena: MatchArena = await _open_match()
	arena.bots()[0].knock_out()
	assert_eq(GameState.total_trophies(), before + 10, "only the win counts")
