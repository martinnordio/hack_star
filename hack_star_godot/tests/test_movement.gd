extends GutTest

const SPEED: float = 5.0


func test_straight_right_moves_along_x_at_speed() -> void:
	var velocity: Vector3 = Movement.velocity(Vector2.RIGHT, SPEED)
	assert_almost_eq(velocity, Vector3(SPEED, 0.0, 0.0), Vector3.ONE * 0.0001)


func test_up_moves_away_from_camera() -> void:
	var velocity: Vector3 = Movement.velocity(Vector2.UP, SPEED)
	assert_almost_eq(velocity, Vector3(0.0, 0.0, -SPEED), Vector3.ONE * 0.0001)


func test_diagonal_is_not_faster() -> void:
	var velocity: Vector3 = Movement.velocity(Vector2(1.0, 1.0), SPEED)
	assert_almost_eq(velocity.length(), SPEED, 0.0001)
	assert_almost_eq(velocity.y, 0.0, 0.0001)


func test_no_input_stops() -> void:
	assert_eq(Movement.velocity(Vector2.ZERO, SPEED), Vector3.ZERO)


func test_step_scales_with_delta() -> void:
	var moved: Vector3 = Movement.step(Vector2.LEFT, SPEED, 0.5)
	assert_almost_eq(moved, Vector3(-SPEED * 0.5, 0.0, 0.0), Vector3.ONE * 0.0001)


func test_joystick_length_is_clamped() -> void:
	var far: Vector2 = Movement.joystick_direction(Vector2(300.0, 400.0), 100.0)
	assert_almost_eq(far.length(), 1.0, 0.0001)
	assert_almost_eq(far, Vector2(0.6, 0.8), Vector2.ONE * 0.0001)


func test_joystick_inside_keeps_partial_length() -> void:
	var half: Vector2 = Movement.joystick_direction(Vector2(0.0, -50.0), 100.0)
	assert_almost_eq(half, Vector2(0.0, -0.5), Vector2.ONE * 0.0001)


func test_facing_yaw_turns_forward_towards_direction() -> void:
	var direction: Vector2 = Vector2(1.0, 0.0)
	var forward: Vector3 = Basis(Vector3.UP, Movement.facing_yaw(direction)) * Vector3.FORWARD
	assert_almost_eq(forward, Vector3(1.0, 0.0, 0.0), Vector3.ONE * 0.0001)
