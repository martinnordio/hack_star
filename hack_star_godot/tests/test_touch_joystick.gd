extends GutTest

const JOYSTICK_SCENE: PackedScene = preload("res://scenes/touch_joystick.tscn")

var _joystick: TouchJoystick


func before_each() -> void:
	_joystick = JOYSTICK_SCENE.instantiate()
	add_child_autofree(_joystick)
	# The joystick hides itself without a touch screen, which is the case in headless runs.
	_joystick.visible = true


func _touch(index: int, position: Vector2, pressed: bool) -> InputEventScreenTouch:
	var event: InputEventScreenTouch = InputEventScreenTouch.new()
	event.index = index
	event.position = position
	event.pressed = pressed
	return event


func _drag(index: int, position: Vector2) -> InputEventScreenDrag:
	var event: InputEventScreenDrag = InputEventScreenDrag.new()
	event.index = index
	event.position = position
	return event


func test_touch_inside_gives_direction_of_at_most_length_one() -> void:
	var centre: Vector2 = _joystick.get_global_rect().get_center()
	_joystick._input(_touch(0, centre + Vector2(_joystick.radius / 2.0, 0.0), true))
	assert_almost_eq(_joystick.direction.x, 0.5, 0.01, "half way right")
	assert_almost_eq(_joystick.direction.y, 0.0, 0.01, "no vertical part")


func test_drag_far_outside_the_circle_is_clamped_to_length_one() -> void:
	var centre: Vector2 = _joystick.get_global_rect().get_center()
	_joystick._input(_touch(0, centre, true))
	_joystick._input(_drag(0, centre + Vector2(1000.0, 1000.0)))
	assert_almost_eq(_joystick.direction.length(), 1.0, 0.001, "clamped to the unit circle")
	assert_gt(_joystick.direction.x, 0.0, "right")
	assert_gt(_joystick.direction.y, 0.0, "down")


func test_release_resets_direction_to_zero() -> void:
	var centre: Vector2 = _joystick.get_global_rect().get_center()
	_joystick._input(_touch(0, centre + Vector2(_joystick.radius, 0.0), true))
	assert_ne(_joystick.direction, Vector2.ZERO, "pushed")
	_joystick._input(_touch(0, centre, false))
	assert_eq(_joystick.direction, Vector2.ZERO, "released")


func test_touch_outside_the_joystick_and_other_fingers_are_ignored() -> void:
	var centre: Vector2 = _joystick.get_global_rect().get_center()
	_joystick._input(_touch(0, Vector2(5000.0, 5000.0), true))
	assert_eq(_joystick.direction, Vector2.ZERO, "touch outside does nothing")
	_joystick._input(_touch(1, centre + Vector2(_joystick.radius, 0.0), true))
	_joystick._input(_drag(2, centre - Vector2(_joystick.radius, 0.0)))
	_joystick._input(_touch(2, centre, false))
	assert_gt(_joystick.direction.x, 0.0, "only the first finger steers")


func test_hidden_joystick_ignores_touches() -> void:
	_joystick.visible = false
	var centre: Vector2 = _joystick.get_global_rect().get_center()
	_joystick._input(_touch(0, centre + Vector2(_joystick.radius, 0.0), true))
	assert_eq(_joystick.direction, Vector2.ZERO, "hidden joystick does not react")
