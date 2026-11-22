extends GutTest


func test_cooldown() -> void:
	assert_false(Combat.can_fire(1.2, 1.0))
	assert_true(Combat.can_fire(1.0 + Combat.COOLDOWN, 1.0))


func test_five_hits_break_a_dummy_and_health_stays_at_zero() -> void:
	var health: int = Combat.DUMMY_HEALTH
	for i: int in 4:
		health = Combat.take_damage(health, Combat.DAMAGE)
		assert_false(Combat.is_broken(health))
	health = Combat.take_damage(health, Combat.DAMAGE)
	assert_true(Combat.is_broken(health))
	assert_eq(Combat.take_damage(health, Combat.DAMAGE), 0)


func test_health_ratio_and_color() -> void:
	assert_eq(Combat.health_ratio(Combat.DUMMY_HEALTH), 1.0)
	assert_eq(Combat.health_color(1.0), Combat.COLOR_GREEN)
	assert_eq(Combat.health_color(0.4), Combat.COLOR_YELLOW)
	assert_eq(Combat.health_color(0.2), Combat.COLOR_RED)
	assert_eq(Combat.health_color(0.5), Combat.COLOR_GREEN)
	assert_eq(Combat.health_color(0.25), Combat.COLOR_YELLOW)
	assert_eq(Combat.health_ratio(0), 0.0)


func test_drag_past_dead_zone_fires_that_way() -> void:
	var aim: Vector2 = Combat.release_aim(Vector2(0.0, -0.8), 2.0)
	assert_almost_eq(aim, Vector2(0.0, -1.0), Vector2.ONE * 0.0001)


func test_quick_tap_fires_at_nearest() -> void:
	assert_eq(Combat.release_aim(Vector2.ZERO, 0.1), Vector2.ZERO)


func test_short_drag_held_long_fires_nothing() -> void:
	assert_eq(Combat.release_aim(Vector2(0.1, 0.0), 1.0), Combat.NO_SHOT)


func test_nearest_target() -> void:
	var none: Array[Vector2] = [Vector2(20.0, 0.0)]
	assert_eq(Combat.nearest_target(Vector2.ZERO, none, Combat.SHOT_RANGE), -1)
	var two: Array[Vector2] = [Vector2(6.0, 0.0), Vector2(0.0, -3.0)]
	assert_eq(Combat.nearest_target(Vector2.ZERO, two, Combat.SHOT_RANGE), 1)
	assert_eq(Combat.nearest_target(Vector2.ZERO, [] as Array[Vector2], 9.0), -1)


func test_fighter_health_ratio() -> void:
	var full: int = MatchSettings.FIGHTER_HEALTH
	assert_eq(Combat.health_ratio(full, full), 1.0)
	assert_eq(Combat.health_ratio(full - Combat.DAMAGE * 7, full), 0.0)
	assert_almost_eq(Combat.health_ratio(1600, full), 0.5, 0.0001)


func test_no_healing_before_three_seconds_then_13_percent_a_second() -> void:
	var full: float = MatchSettings.FIGHTER_HEALTH
	var delay: float = MatchSettings.HEAL_DELAY
	var rate: float = MatchSettings.HEAL_PER_SECOND
	assert_eq(Combat.heal(1000.0, full, 2.9, 1.0, delay, rate), 1000.0)
	assert_almost_eq(Combat.heal(1000.0, full, 3.0, 1.0, delay, rate), 1416.0, 0.001)


func test_healing_never_goes_above_full_health() -> void:
	var full: float = MatchSettings.FIGHTER_HEALTH
	assert_eq(Combat.heal(3150.0, full, 9.0, 1.0, 3.0, 0.13), full)


func test_a_longer_cooldown_fires_later() -> void:
	var slow: float = Combat.COOLDOWN * MatchSettings.level("easy")["cooldown"]
	assert_false(Combat.can_fire(1.0 + Combat.COOLDOWN, 1.0, slow))
	assert_true(Combat.can_fire(1.0 + slow + 0.01, 1.0, slow))
