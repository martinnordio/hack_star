extends GutTest
## Hacks that turn off by themselves (spec 16, S16, S17, S19, S22, D3, D4), with a fake clock.

const HOME: PackedScene = preload("res://scenes/home.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TEST_SAVE: String = "user://test/hack_expiry.json"
const START: int = 1_764_000_000

var _now: int = START
var _previous: Node
var _scene_shown: bool = false
var _root_size: Vector2i
var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()
	_now = START
	GameState.clock = func() -> int: return _now


func after_each() -> void:
	var tree: SceneTree = get_tree()
	var shown: Node = tree.current_scene
	if _scene_shown:
		tree.current_scene = _previous
		tree.root.size = _root_size
		if is_instance_valid(shown) and shown != _previous:
			shown.queue_free()
		await wait_process_frames(1)
		_scene_shown = false
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


func _locked_fighter() -> String:
	for fighter_id: String in Fighters.ids():
		if not fighter_id in Fighters.start_unlocked():
			return fighter_id
	return ""


func _second_skin(fighter_id: String) -> String:
	return Fighters.get_fighter(fighter_id)["skins"][1]["id"]


func _saved_hacks() -> Dictionary:
	return SaveData.from_json(FileAccess.get_file_as_string(TEST_SAVE), _now)["hacks"]


func _show(scene: PackedScene) -> Node:
	var tree: SceneTree = get_tree()
	_scene_shown = true
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


func test_a_hack_gets_its_end_time_from_the_clock() -> void:
	assert_true(GameState.activate_hack(Hacks.INFINITE_CREDITS))
	assert_true(GameState.activate_hack(Hacks.POWER22))
	assert_eq(GameState.hack_until[Hacks.INFINITE_CREDITS], START + Hacks.TIMED_SECONDS)
	assert_eq(GameState.hack_until[Hacks.POWER22], Hacks.FOREVER)


func test_a_timed_hack_turns_off_after_three_days_and_a_for_ever_hack_stays() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.activate_hack(Hacks.POWER22)
	_now = START + Hacks.TIMED_SECONDS - 1
	assert_false(GameState.expire_hacks())
	assert_true(GameState.has_hack(Hacks.INFINITE_CREDITS))
	_now = START + Hacks.TIMED_SECONDS
	assert_true(GameState.expire_hacks())
	assert_false(GameState.has_hack(Hacks.INFINITE_CREDITS))
	assert_true(GameState.has_hack(Hacks.POWER22))
	_now = START + 365 * Hacks.DAY_SECONDS
	assert_false(GameState.expire_hacks())
	assert_true(GameState.has_hack(Hacks.POWER22))


func test_turning_off_is_saved_and_announced() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	watch_signals(GameState)
	_now += Hacks.TIMED_SECONDS
	GameState.expire_hacks()
	assert_signal_emitted(GameState, "progress_changed")
	assert_eq_deep(_saved_hacks(), {} as Dictionary[String, int])


func test_nothing_is_announced_while_no_hack_ends() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	watch_signals(GameState)
	GameState.expire_hacks()
	assert_signal_not_emitted(GameState, "progress_changed")


func test_entering_a_timed_code_again_starts_new_three_days() -> void:
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	_now += 2 * Hacks.DAY_SECONDS
	assert_true(GameState.activate_hack(Hacks.UNLOCK_ALL))
	assert_eq(GameState.hack_until[Hacks.UNLOCK_ALL], _now + Hacks.TIMED_SECONDS)
	assert_eq(GameState.active_hacks.count(Hacks.UNLOCK_ALL), 1)
	_now += 2 * Hacks.DAY_SECONDS
	GameState.expire_hacks()
	assert_true(GameState.has_hack(Hacks.UNLOCK_ALL))


func test_a_for_ever_code_entered_again_changes_nothing() -> void:
	GameState.activate_hack(Hacks.POWER22)
	assert_false(GameState.activate_hack(Hacks.POWER22))
	assert_eq(GameState.hack_until[Hacks.POWER22], Hacks.FOREVER)


func test_a_hack_that_ended_while_the_game_was_closed_is_off_at_the_start() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.activate_hack(Hacks.POWER22)
	GameState.reset()
	GameState.clock = func() -> int: return _now
	_now = START + Hacks.TIMED_SECONDS + 60
	GameState.load_saved()
	assert_eq(GameState.active_hacks, [Hacks.POWER22] as Array[String])


func test_what_was_gained_stays_when_a_hack_turns_off() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.trophies["rocko"] = 999
	GameState.power_levels["rocko"] = 9
	GameState.credits = 77
	GameState.select("rocko", _second_skin("rocko"))
	_now += Hacks.TIMED_SECONDS
	GameState.expire_hacks()
	assert_eq(GameState.trophies["rocko"], 999)
	assert_eq(GameState.power_levels["rocko"], 9)
	assert_eq(GameState.credits, 77)
	assert_eq(GameState.unlocked, Fighters.start_unlocked())
	assert_eq(GameState.selected_skins["rocko"], _second_skin("rocko"))


func test_a_locked_again_fighter_is_no_longer_the_chosen_one() -> void:
	var locked: String = _locked_fighter()
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.select(locked, Fighters.DEFAULT_SKIN)
	GameState.viewed_fighter = locked
	_now += Hacks.TIMED_SECONDS
	GameState.expire_hacks()
	assert_eq(GameState.selected_fighter, SampleProgress.SELECTED_FIGHTER)
	assert_eq(GameState.viewed_fighter, SampleProgress.SELECTED_FIGHTER)
	assert_true(GameState.is_unlocked(GameState.selected_fighter))


func test_turn_all_hacks_off_also_replaces_a_locked_chosen_fighter() -> void:
	var locked: String = _locked_fighter()
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.select(locked, Fighters.DEFAULT_SKIN)
	watch_signals(GameState)
	GameState.reset_hacks()
	assert_eq(GameState.selected_fighter, SampleProgress.SELECTED_FIGHTER)
	assert_signal_emitted(GameState, "progress_changed")


func test_the_first_unlocked_fighter_is_taken_when_the_sample_one_is_locked() -> void:
	GameState.unlocked = ["rocko"]
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.select("luna", Fighters.DEFAULT_SKIN)
	GameState.reset_hacks()
	assert_eq(GameState.selected_fighter, "rocko")


func test_home_shows_the_real_credits_and_a_usable_fighter_after_three_days() -> void:
	var locked: String = _locked_fighter()
	GameState.credits = 321
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.select(locked, Fighters.DEFAULT_SKIN)
	var home: Control = await _show(HOME)
	var credits: Label = home.get_node("Margin/Column/TopBar/CreditsLabel")
	assert_eq(credits.text, "Credits: ∞")
	_now += Hacks.TIMED_SECONDS
	GameState.expire_hacks()
	assert_eq(credits.text, "Credits: 321")
	var name_label: Label = home.get_node("Margin/Column/Body/Controls/NameRow/NameLabel")
	assert_eq(name_label.text, Fighters.get_fighter(GameState.selected_fighter)["name"])
	assert_true(GameState.is_unlocked(GameState.selected_fighter))


func test_a_match_keeps_its_fighter_when_a_hack_turns_off() -> void:
	var locked: String = _locked_fighter()
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.select(locked, Fighters.DEFAULT_SKIN)
	GameState.match_settings.bot_count = 1
	GameState.match_settings.countdown_seconds = 0
	var arena: MatchArena = await _show(MATCH_SCENE)
	_now += Hacks.TIMED_SECONDS
	GameState.expire_hacks()
	assert_ne(GameState.selected_fighter, locked)
	var before: int = GameState.trophies[locked]
	arena.bots()[0].knock_out()
	assert_eq(GameState.last_result["fighter"], locked)
	assert_eq(GameState.trophies[locked], before + 10)
