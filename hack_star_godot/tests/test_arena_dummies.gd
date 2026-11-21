extends GutTest

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
## The fighter's collision capsule.
const FIGHTER_RADIUS: float = 0.4

var _arena: Node3D


func before_each() -> void:
	_arena = ARENA_SCENE.instantiate()
	add_child_autofree(_arena)


func _dummies() -> Array[Node]:
	return _arena.get_node("Dummies").get_children()


func test_three_dummies_stand_at_the_layout_spots() -> void:
	var dummies: Array[Node] = _dummies()
	assert_eq(dummies.size(), 3, "three dummies")
	for index: int in dummies.size():
		var dummy: TargetDummy = dummies[index]
		var spot: Vector2 = ArenaLayout.DUMMIES[index]
		var at: Vector2 = Vector2(dummy.global_position.x, dummy.global_position.z)
		assert_almost_eq(at, spot, Vector2.ONE * 0.001, "dummy %d place" % index)
		assert_true(dummy.is_in_group("targets"), "dummy %d is a target" % index)


func test_a_shot_at_a_dummy_lowers_its_health() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	var dummy: TargetDummy = _dummies()[0]
	fighter.position = Vector3(ArenaLayout.DUMMIES[0].x, 0.0, 0.0)
	assert_true(_arena.fire(Vector2.UP), "fired north")
	await wait_until(func() -> bool: return dummy.health < Combat.DUMMY_HEALTH, 2.0)
	assert_eq(dummy.health, Combat.DUMMY_HEALTH - Combat.DAMAGE, "one hit")


func test_the_fighter_stops_at_a_dummy() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	var spot: Vector2 = ArenaLayout.DUMMIES[0]
	fighter.position = Vector3(spot.x, 0.0, 0.0)
	fighter.input_direction = Vector2.UP
	await wait_physics_frames(60)
	assert_gt(fighter.position.z, spot.y + FIGHTER_RADIUS, "stays south of the dummy")
	assert_lt(fighter.position.z, spot.y + FIGHTER_RADIUS + 0.8, "reached the dummy")


func test_a_quick_tap_aims_at_the_nearest_dummy() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	fighter.position = Vector3(3.0, 0.0, 0.0)
	var stick: TouchJoystick = _arena.get_node("Hud/AimJoystick")
	stick.released.emit(Vector2.ZERO, 0.1)
	var shots: Node3D = _arena.get_node("Shots")
	assert_eq(shots.get_child_count(), 1, "a tap fires")
	var wanted: Vector2 = (ArenaLayout.DUMMIES[1] - Vector2(3.0, 0.0)).normalized()
	var shot: Shot = shots.get_child(0)
	assert_almost_eq(Vector2(shot.direction.x, shot.direction.z), wanted, Vector2.ONE * 0.01)
