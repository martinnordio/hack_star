extends GutTest

const WALL_X: float = 3.0
const WALL_THICKNESS: float = 0.5


func _launch(toward: Vector3) -> Shot:
	var shot: Shot = Shot.new()
	shot.launch(Vector3(0.0, 0.6, 0.0), toward, Color.ORANGE)
	add_child_autofree(shot)
	return shot


func _add_wall() -> void:
	var wall: StaticBody3D = StaticBody3D.new()
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(WALL_THICKNESS, 2.0, 4.0)
	shape.shape = box
	wall.add_child(shape)
	wall.position = Vector3(WALL_X + WALL_THICKNESS / 2.0, 1.0, 0.0)
	add_child_autofree(wall)


## Waits for `ended` and returns its parameters (the shot frees itself right after).
func _ended(shot: Shot) -> Array:
	var params: Array = []
	shot.ended.connect(func(at: Vector3, hit: bool) -> void: params.append_array([at, hit]))
	await wait_until(func() -> bool: return not params.is_empty(), 2.0)
	return params


func test_a_shot_towards_a_wall_ends_at_the_wall() -> void:
	_add_wall()
	await wait_physics_frames(2)
	var shot: Shot = _launch(Vector3.RIGHT)
	var params: Array = await _ended(shot)
	var end: Vector3 = params[0]
	assert_almost_eq(end.x, WALL_X, 0.01, "stopped at the wall's face")
	assert_true(params[1], "hit something")


func test_a_shot_launched_inside_a_wall_still_hits_it_from_the_cast_start() -> void:
	_add_wall()
	await wait_physics_frames(2)
	var shot: Shot = Shot.new()
	shot.launch(
		Vector3(WALL_X + 0.2, 0.6, 0.0), Vector3.RIGHT, Color.ORANGE, Vector3(2.6, 0.6, 0.0)
	)
	add_child_autofree(shot)
	var params: Array = await _ended(shot)
	var end: Vector3 = params[0]
	assert_almost_eq(end.x, WALL_X, 0.01, "stopped at the wall's face")
	assert_true(params[1], "hit something")


func test_without_a_wall_a_shot_ends_after_its_range() -> void:
	var shot: Shot = _launch(Vector3.BACK)
	var params: Array = await _ended(shot)
	var end: Vector3 = params[0]
	assert_almost_eq(end, Vector3(0.0, 0.6, Combat.SHOT_RANGE), Vector3.ONE * 0.01, "range")
	assert_false(params[1], "hit nothing")
