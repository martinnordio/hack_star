extends GutTest

const EASY: Dictionary = MatchSettings.LEVELS["easy"]
const HARD: Dictionary = MatchSettings.LEVELS["hard"]


func _brain(seed_value: int = 7) -> BotBrain:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = seed_value
	return BotBrain.new(rng)


func _opponent(at: Vector2, in_bush: bool = false, id: Variant = null) -> Dictionary:
	var opponent: Dictionary = {"at": at, "in_bush": in_bush}
	if id != null:
		opponent["id"] = id
	return opponent


## Thinks once to see the target, then again after the reaction time.
func _think_after_reaction(
	brain: BotBrain, me: Vector2, opponents: Array[Dictionary], level: Dictionary
) -> Dictionary:
	brain.think(0.0, me, opponents, level)
	return brain.think(level["reaction"] + 0.01, me, opponents, level)


func test_can_see_within_sight_only() -> void:
	assert_true(BotBrain.can_see(Vector2.ZERO, Vector2(7.0, 0.0), false, 8.0, 2.5))
	assert_false(BotBrain.can_see(Vector2.ZERO, Vector2(9.0, 0.0), false, 8.0, 2.5))


func test_a_fighter_in_a_bush_is_seen_at_2_m_but_not_at_3_m() -> void:
	assert_true(BotBrain.can_see(Vector2.ZERO, Vector2(0.0, 2.0), true, 8.0, 2.5))
	assert_false(BotBrain.can_see(Vector2.ZERO, Vector2(0.0, 3.0), true, 8.0, 2.5))


func test_no_shot_during_the_reaction_time_then_a_shot() -> void:
	var brain: BotBrain = _brain()
	var opponents: Array[Dictionary] = [_opponent(Vector2(5.0, 0.0))]
	var first: Dictionary = brain.think(0.0, Vector2.ZERO, opponents, EASY)
	assert_eq(first["aim"], Combat.NO_SHOT)
	assert_eq(first["move"], Vector2.ZERO)
	var waiting: Dictionary = brain.think(0.5, Vector2.ZERO, opponents, EASY)
	assert_eq(waiting["aim"], Combat.NO_SHOT)
	var ready: Dictionary = brain.think(0.61, Vector2.ZERO, opponents, EASY)
	assert_ne(ready["aim"], Combat.NO_SHOT)


func test_moves_towards_a_visible_opponent_far_away() -> void:
	var opponents: Array[Dictionary] = [_opponent(Vector2(7.0, 0.0))]
	var choice: Dictionary = _think_after_reaction(_brain(), Vector2.ZERO, opponents, EASY)
	assert_almost_eq(choice["move"], Vector2.RIGHT, Vector2(0.001, 0.001))


func test_backs_off_when_closer_than_3_m() -> void:
	var opponents: Array[Dictionary] = [_opponent(Vector2(2.0, 0.0))]
	var choice: Dictionary = _think_after_reaction(_brain(), Vector2.ZERO, opponents, EASY)
	assert_almost_eq(choice["move"], Vector2.LEFT, Vector2(0.001, 0.001))


func test_sidesteps_at_a_good_distance() -> void:
	var opponents: Array[Dictionary] = [_opponent(Vector2(4.0, 0.0))]
	var choice: Dictionary = _think_after_reaction(_brain(), Vector2.ZERO, opponents, EASY)
	var move: Vector2 = choice["move"]
	assert_almost_eq(move.x, 0.0, 0.001)
	assert_almost_eq(absf(move.y), BotBrain.SIDESTEP, 0.001)


func test_does_not_chase_a_fighter_hidden_in_a_far_bush() -> void:
	var brain: BotBrain = _brain()
	var opponents: Array[Dictionary] = [_opponent(Vector2(4.0, 0.0), true)]
	for now: float in [0.0, 1.0, 2.0]:
		var choice: Dictionary = brain.think(now, Vector2.ZERO, opponents, EASY)
		assert_eq(choice["aim"], Combat.NO_SHOT)
	assert_ne(brain.wander_point, Vector2.INF)


func test_picks_the_nearest_of_two_opponents_a_bot_too() -> void:
	var brain: BotBrain = _brain()
	var opponents: Array[Dictionary] = [
		_opponent(Vector2(0.0, 6.0), false, "player"), _opponent(Vector2(4.0, 0.0), false, "bot")
	]
	var choice: Dictionary = _think_after_reaction(brain, Vector2.ZERO, opponents, HARD)
	var aim: Vector2 = choice["aim"]
	assert_lt(absf(aim.angle_to(Vector2.RIGHT)), HARD["aim_error"] + 0.001)


func test_a_new_nearest_target_waits_the_reaction_again() -> void:
	var brain: BotBrain = _brain()
	var player: Array[Dictionary] = [_opponent(Vector2(5.0, 0.0), false, "player")]
	_think_after_reaction(brain, Vector2.ZERO, player, EASY)
	var both: Array[Dictionary] = [player[0], _opponent(Vector2(0.0, 3.5), false, "bot")]
	assert_eq(brain.think(1.0, Vector2.ZERO, both, EASY)["aim"], Combat.NO_SHOT)
	assert_ne(brain.think(1.7, Vector2.ZERO, both, EASY)["aim"], Combat.NO_SHOT)


func test_easy_aim_spreads_up_to_0_35_rad_hard_up_to_0_08() -> void:
	var opponents: Array[Dictionary] = [_opponent(Vector2(4.0, 0.0))]
	var easy_spread: float = _largest_spread(EASY, opponents)
	var hard_spread: float = _largest_spread(HARD, opponents)
	assert_lte(easy_spread, 0.35 + 0.0001)
	assert_gt(easy_spread, 0.2)
	assert_lte(hard_spread, 0.08 + 0.0001)


func test_no_aim_beyond_shot_range() -> void:
	var opponents: Array[Dictionary] = [_opponent(Vector2(Combat.SHOT_RANGE + 0.5, 0.0))]
	var choice: Dictionary = _think_after_reaction(_brain(), Vector2.ZERO, opponents, HARD)
	assert_eq(choice["aim"], Combat.NO_SHOT)
	assert_almost_eq(choice["move"], Vector2.RIGHT, Vector2(0.001, 0.001))


func test_wanders_towards_its_point_when_it_sees_nobody() -> void:
	var brain: BotBrain = _brain()
	var none: Array[Dictionary] = []
	var choice: Dictionary = brain.think(0.0, ArenaLayout.START, none, EASY)
	var expected: Vector2 = (brain.wander_point - ArenaLayout.START).normalized()
	assert_almost_eq(choice["move"], expected, Vector2(0.001, 0.001))
	assert_eq(choice["aim"], Combat.NO_SHOT)


func test_a_new_wander_point_once_it_is_reached() -> void:
	var brain: BotBrain = _brain()
	var none: Array[Dictionary] = []
	brain.think(0.0, ArenaLayout.START, none, EASY)
	var first: Vector2 = brain.wander_point
	brain.think(0.1, first, none, EASY)
	assert_ne(brain.wander_point, first)


func test_a_new_wander_point_after_1_s_without_progress() -> void:
	var brain: BotBrain = _brain()
	var none: Array[Dictionary] = []
	brain.think(0.0, ArenaLayout.START, none, EASY)
	var first: Vector2 = brain.wander_point
	brain.think(0.9, ArenaLayout.START, none, EASY)
	assert_eq(brain.wander_point, first)
	brain.think(1.0, ArenaLayout.START, none, EASY)
	assert_ne(brain.wander_point, first)


func test_keeps_its_wander_point_while_it_gets_closer_until_4_s() -> void:
	var brain: BotBrain = _brain()
	var none: Array[Dictionary] = []
	var me: Vector2 = ArenaLayout.START
	brain.think(0.0, me, none, EASY)
	var first: Vector2 = brain.wander_point
	var now: float = 0.0
	while now < 3.5:
		now += 0.5
		me = me.move_toward(first, 0.2)
		brain.think(now, me, none, EASY)
		assert_eq(brain.wander_point, first)
	brain.think(BotBrain.WANDER_SECONDS, me.move_toward(first, 0.2), none, EASY)
	assert_ne(brain.wander_point, first)


func test_every_wander_point_is_free() -> void:
	var brain: BotBrain = _brain(42)
	var none: Array[Dictionary] = []
	for i: int in 100:
		brain.think(float(i) * BotBrain.WANDER_SECONDS, ArenaLayout.START, none, EASY)
		assert_true(ArenaLayout.is_free(brain.wander_point, BotBrain.WANDER_CLEARANCE))


func _largest_spread(level: Dictionary, opponents: Array[Dictionary]) -> float:
	var brain: BotBrain = _brain()
	var largest: float = 0.0
	brain.think(0.0, Vector2.ZERO, opponents, level)
	for i: int in 200:
		var aim: Vector2 = brain.think(1.0 + i, Vector2.ZERO, opponents, level)["aim"]
		largest = maxf(largest, absf(aim.angle_to(Vector2.RIGHT)))
	return largest
