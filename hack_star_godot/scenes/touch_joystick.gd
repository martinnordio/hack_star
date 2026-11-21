class_name TouchJoystick
extends Control
## On-screen joystick, shown only on touch screens. `direction` has length at most 1:
## right is +x, down is +y, like the keyboard's `Input.get_vector`.

@export var radius: float = 90.0
@export var knob_radius: float = 40.0

var direction: Vector2 = Vector2.ZERO
var _touch_index: int = -1


func _ready() -> void:
	visible = DisplayServer.is_touchscreen_available()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		if touch.pressed and _touch_index == -1 and get_global_rect().has_point(touch.position):
			_touch_index = touch.index
			_follow(touch.position)
			get_viewport().set_input_as_handled()
		elif not touch.pressed and touch.index == _touch_index:
			_release()
	elif event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event
		if drag.index == _touch_index:
			_follow(drag.position)
			get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and not visible:
		_release()


func _draw() -> void:
	var centre: Vector2 = size / 2.0
	draw_circle(centre, radius, Color(1, 1, 1, 0.15))
	draw_arc(centre, radius, 0.0, TAU, 64, Color(1, 1, 1, 0.5), 3.0, true)
	draw_circle(centre + direction * radius, knob_radius, Color(1, 1, 1, 0.6))


func _follow(screen_position: Vector2) -> void:
	var offset: Vector2 = screen_position - get_global_rect().get_center()
	direction = Movement.joystick_direction(offset, radius)
	queue_redraw()


func _release() -> void:
	_touch_index = -1
	direction = Vector2.ZERO
	queue_redraw()
