extends GutTest
## The match arena (`scenes/match.tscn`, `MatchArena`, spec 07 D8).

const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const SEED: int = 7

var _previous: Node
var _root_size: Vector2i


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	Input.action_release("move_right")
	Input.action_release("shoot")
	var tree: SceneTree = get_tree()
	var shown: Node = tree.current_scene
	tree.current_scene = _previous
	tree.root.size = _root_size
	if is_instance_valid(shown) and shown != _previous:
		shown.queue_free()
	await wait_process_frames(1)
	GameState.reset()


## Opens a match as the current scene of a 1280×720 root (so input reaches it and a screen
## change can be seen), with `bot_count` bots and a countdown of `countdown` seconds.
func _open(bot_count: int = MatchSettings.BOT_COUNT, countdown: int = 3) -> MatchArena:
	GameState.match_settings.bot_count = bot_count
	GameState.match_settings.countdown_seconds = countdown
	var tree: SceneTree = get_tree()
	_previous = tree.current_scene
	_root_size = tree.root.size
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	tree.root.size = Vector2i(1280, 720)
	var arena: MatchArena = MATCH_SCENE.instantiate()
	arena.rng.seed = SEED
	arena.read_player_input = countdown > 0
	placeholder.add_child(arena)
	await wait_process_frames(2)
	return arena


func _player(arena: MatchArena) -> Fighter:
	return arena.get_node("Fighter")


func _place(fighter: Fighter, at: Vector2) -> void:
	fighter.position = Vector3(at.x, 0.0, at.y)


func _mouse_button(position: Vector2, pressed: bool) -> InputEventMouseButton:
	var event: InputEventMouseButton = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = pressed
	event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed else 0
	event.position = position
	event.global_position = position
	return event


func _screen_touch(position: Vector2, pressed: bool) -> InputEventScreenTouch:
	var event: InputEventScreenTouch = InputEventScreenTouch.new()
	event.index = 0
	event.pressed = pressed
	event.position = position
	return event


## Records the direction of every shot fired in the arena.
func _record_shots(arena: MatchArena) -> Array[Vector3]:
	var directions: Array[Vector3] = []
	arena.get_node("Shots").child_entered_tree.connect(
		func(shot: Node) -> void: directions.append((shot as Shot).direction)
	)
	return directions


func test_three_bots_by_default_at_their_own_starts_without_dummies() -> void:
	GameState.select("rocko", "crystal")
	var arena: MatchArena = await _open()
	var bots: Array[Fighter] = arena.bots()
	assert_eq(bots.size(), 3, "three bots")
	var player: Fighter = _player(arena)
	assert_eq(Vector2(player.position.x, player.position.z), ArenaLayout.STARTS[0])
	assert_eq(player.health_bar().fixed_color, Combat.COLOR_GREEN, "the player's bar is green")
	for i: int in bots.size():
		var bot: Fighter = bots[i]
		assert_ne(bot.model.fighter_id, "rocko", "%s is not the player's fighter" % bot.name)
		assert_eq(bot.model.skin_id, Fighters.DEFAULT_SKIN)
		assert_eq(Vector2(bot.position.x, bot.position.z), ArenaLayout.STARTS[i + 1])
		assert_eq(bot.health_bar().fixed_color, Combat.COLOR_RED, "a bot's bar is red")
		assert_eq(bot.max_health, float(MatchSettings.FIGHTER_HEALTH))
	assert_eq(arena.get_node("Dummies").get_child_count(), 0, "no dummies")
	assert_false(arena.training)


func test_nobody_moves_or_fires_during_the_countdown() -> void:
	var arena: MatchArena = await _open()
	var player: Fighter = _player(arena)
	var starts: Array[Vector3] = [player.position]
	for bot: Fighter in arena.bots():
		starts.append(bot.position)
	var camera: Camera3D = arena.get_node("Camera")
	var east: Vector2 = camera.unproject_position(player.global_position + Vector3(3, 0, 0))
	Input.action_press("move_right")
	Input.action_press("shoot")
	get_tree().root.push_input(_mouse_button(east, true), true)
	get_tree().root.push_input(_mouse_button(east, false), true)
	await wait_seconds(0.5)
	assert_false(arena.match_state.can_act(), "still the countdown")
	assert_eq(arena.get_node("Shots").get_child_count(), 0, "no shot")
	var now: Array[Vector3] = [player.position]
	for bot: Fighter in arena.bots():
		now.append(bot.position)
	assert_almost_eq(now[0], starts[0], Vector3.ONE * 0.001, "the player stands still")
	for i: int in range(1, now.size()):
		assert_almost_eq(now[i], starts[i], Vector3.ONE * 0.001, "bot %d stands still" % i)


func test_after_the_countdown_a_bot_moves_and_fires_at_the_player() -> void:
	var arena: MatchArena = await _open(1, 0)
	var bot: Fighter = arena.bots()[0]
	var at: Vector2 = ArenaLayout.START + Vector2(0.0, -5.0)
	_place(bot, at)
	var shots: Array[Vector3] = _record_shots(arena)
	await wait_until(func() -> bool: return not shots.is_empty(), 2.0)
	assert_eq(shots.size(), 1, "the bot fired")
	var to_player: Vector3 = Vector3.BACK
	var level: Dictionary = MatchSettings.level(MatchSettings.BOT_LEVEL)
	assert_lt(shots[0].angle_to(to_player), level["aim_error"] + 0.15, "at the player")
	await wait_seconds(0.3)
	var moved: float = Vector2(bot.position.x, bot.position.z).distance_to(at)
	assert_gt(moved, 0.05, "the bot moved")


func test_knocking_out_the_last_bot_is_a_victory_then_the_match_leaves() -> void:
	var arena: MatchArena = await _open(1, 0)
	var bot: Fighter = arena.bots()[0]
	_place(bot, ArenaLayout.START + Vector2(3.0, 0.0))
	await wait_physics_frames(2)
	assert_true(arena.fire(Vector2.RIGHT), "the player fires")
	await wait_until(func() -> bool: return bot.health < bot.max_health, 1.0)
	assert_eq(bot.health, bot.max_health - Combat.DAMAGE, "the player's shot hit the bot")
	bot.hit(int(bot.health))
	assert_eq(GameState.last_result["outcome"], Match.Result.VICTORY)
	assert_eq(GameState.last_result["place"], 1)
	assert_eq(GameState.last_result["fighter"], GameState.selected_fighter)
	assert_eq(GameState.last_result["skin"], GameState.selected_skin())
	assert_false(arena.player_can_act(), "nobody acts after the end")
	_player(arena).hit(int(_player(arena).max_health))
	assert_false(_player(arena).knocked_out, "the result is final: no more hits")
	assert_eq(GameState.last_result["outcome"], Match.Result.VICTORY)
	await wait_seconds(MatchArena.END_WAIT_SECONDS + 0.3)
	assert_eq(get_tree().current_scene.scene_file_path, Screens.RESULT, "then the result screen")


func test_the_player_out_with_two_bots_left_is_a_defeat_in_third_place() -> void:
	var arena: MatchArena = await _open(3, 0)
	arena.bots()[0].knock_out()
	assert_true(GameState.last_result.is_empty(), "the match goes on")
	_player(arena).hit(int(_player(arena).max_health))
	assert_eq(GameState.last_result["outcome"], Match.Result.DEFEAT)
	assert_eq(GameState.last_result["place"], 3)
	assert_eq(Match.ordinal(GameState.last_result["place"]), "3rd")


func test_time_up_with_a_bot_left_is_a_draw() -> void:
	GameState.match_settings.match_seconds = 3.0
	var arena: MatchArena = await _open(1, 0)
	var bush: Vector2 = ArenaLayout.BUSHES[3].get_center()
	_place(_player(arena), bush)
	await wait_until(func() -> bool: return not GameState.last_result.is_empty(), 5.0)
	assert_eq(GameState.last_result.get("outcome"), Match.Result.TIME_UP)
	assert_true(_player(arena).model.see_through, "the player in the bush is see-through")


func test_a_tap_on_the_aim_stick_fires_at_the_nearest_bot() -> void:
	var arena: MatchArena = await _open(2, 0)
	_place(arena.bots()[0], ArenaLayout.START + Vector2(-5.0, 0.0))
	_place(arena.bots()[1], ArenaLayout.START + Vector2(3.0, 0.0))
	await wait_physics_frames(2)
	var shots: Array[Vector3] = _record_shots(arena)
	var stick: TouchJoystick = arena.get_node("Hud/AimJoystick")
	stick.visible = true
	var centre: Vector2 = stick.get_global_rect().get_center()
	get_tree().root.push_input(_screen_touch(centre, true), true)
	get_tree().root.push_input(_screen_touch(centre, false), true)
	assert_eq(shots.size(), 1, "a tap fires")
	assert_almost_eq(shots[0], Vector3.RIGHT, Vector3.ONE * 0.05, "at the nearer bot, east")


func test_space_fires_at_the_nearest_bot_and_nothing_after_the_end() -> void:
	var arena: MatchArena = await _open(2, 0)
	_place(arena.bots()[0], ArenaLayout.START + Vector2(-5.0, 0.0))
	_place(arena.bots()[1], ArenaLayout.START + Vector2(3.0, 0.0))
	await wait_physics_frames(2)
	var shots: Array[Vector3] = _record_shots(arena)
	arena.read_player_input = true
	Input.action_press("shoot")
	await wait_process_frames(2)
	assert_eq(shots.size(), 1, "Space fires")
	assert_almost_eq(shots[0], Vector3.RIGHT, Vector3.ONE * 0.05, "at the nearer bot, east")
	Input.action_release("shoot")
	for bot: Fighter in arena.bots():
		bot.knock_out()
	assert_false(arena.player_can_act(), "the match is over")
	await wait_seconds(Combat.COOLDOWN + 0.1)
	Input.action_press("shoot")
	await wait_process_frames(2)
	assert_eq(shots.size(), 1, "nothing after the end")


func test_a_bot_in_a_bush_is_see_through() -> void:
	var arena: MatchArena = await _open(1)
	var bot: Fighter = arena.bots()[0]
	assert_false(bot.model.see_through, "not at its start")
	_place(bot, ArenaLayout.BUSHES[0].get_center())
	await wait_physics_frames(2)
	assert_true(bot.model.see_through, "in the bush")


func test_back_goes_home_without_a_result() -> void:
	var arena: MatchArena = await _open()
	(arena.get_node("Hud/BackButton") as Button).pressed.emit()
	await wait_process_frames(2)
	assert_eq(get_tree().current_scene.scene_file_path, Screens.HOME, "home")
	assert_true(GameState.last_result.is_empty(), "no result")
