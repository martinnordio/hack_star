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


func test_ground_point_of_a_ray_looking_down() -> void:
	var angle: float = deg_to_rad(55.0)
	var direction: Vector3 = Vector3(0.0, -sin(angle), -cos(angle))
	var point: Vector3 = Combat.ground_point(Vector3(0.0, 10.0, 0.0), direction, 0.0)
	assert_almost_eq(point.y, 0.0, 0.0001)
	assert_almost_eq(point.z, -10.0 / tan(angle), 0.0001)
	var raised: Vector3 = Combat.ground_point(Vector3(0.0, 10.0, 0.0), direction, 0.9)
	assert_almost_eq(raised.y, 0.9, 0.0001)


func test_ground_point_of_a_ray_looking_up_is_infinite() -> void:
	assert_eq(Combat.ground_point(Vector3(0.0, 10.0, 0.0), Vector3.UP, 0.0), Vector3.INF)
