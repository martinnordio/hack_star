extends Node3D
## The arena: the canyon (`Canyon`, built from `ArenaLayout`), one fighter, a camera above
## and behind it, and the HUD.
## Keyboard and touch joystick feed the same movement rule (`game/movement.gd`).

## The camera looks at the fighter from above and behind (towards +z), at this angle down.
const CAMERA_PITCH_DEGREES: float = 55.0
const CAMERA_MIN_DISTANCE: float = 8.0
const CAMERA_MAX_DISTANCE: float = 120.0
const CAMERA_DISTANCE_STEP: float = 0.25
## The camera looks this far ahead of the fighter (towards -z) and follows with this rate.
const CAMERA_LOOK_AHEAD: float = 1.0
const CAMERA_FOLLOW_RATE: float = 6.0
## Half the size of the box around the fighter (x, z in metres) that always fits the screen,
## and the fighter's height.
const VIEW_HALF_SIZE: Vector2 = Vector2(7.0, 5.0)
const FIGHTER_HEIGHT: float = 1.9
## Free border around that box as a share of the screen; more at the top for the Back button.
const FRAME_MARGIN: float = 0.03
const FRAME_TOP_MARGIN: float = 0.12
## The FPS label (only while the first game is being checked) refreshes this often.
const FPS_LABEL_INTERVAL: float = 0.25

## When false, the fighter keeps the `input_direction` set from outside (tests).
var read_player_input: bool = true

var _fps_timer: float = 0.0
var _camera_target: Vector3 = Vector3.ZERO
var _camera_distance: float = CAMERA_MIN_DISTANCE

@onready var _fighter: Fighter = $Fighter
@onready var _camera: Camera3D = $Camera
@onready var _joystick: TouchJoystick = $Hud/TouchJoystick
@onready var _fps_label: Label = $Hud/FpsLabel


func _ready() -> void:
	_fighter.position = Vector3(ArenaLayout.START.x, 0.0, ArenaLayout.START.y)
	_fighter.set_look(GameState.selected_fighter, GameState.selected_skin())
	_camera_target = _wanted_camera_target()
	get_viewport().size_changed.connect(_frame_camera)
	_frame_camera()
	_update_fps_label()


func _process(delta: float) -> void:
	_camera_target = Movement.follow(
		_camera_target, _wanted_camera_target(), delta, CAMERA_FOLLOW_RATE
	)
	_place_camera()
	_fps_timer += delta
	if _fps_timer >= FPS_LABEL_INTERVAL:
		_fps_timer = 0.0
		_update_fps_label()


func _physics_process(_delta: float) -> void:
	if not read_player_input:
		return
	var keys: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_fighter.input_direction = Movement.clamp_direction(keys + _joystick.direction)


func _wanted_camera_target() -> Vector3:
	return _fighter.position + Vector3(0.0, 0.0, -CAMERA_LOOK_AHEAD)


func _place_camera() -> void:
	var pitch: float = deg_to_rad(CAMERA_PITCH_DEGREES)
	var backwards: Vector3 = Vector3(0.0, sin(pitch), cos(pitch))
	_camera.look_at_from_position(_camera_target + backwards * _camera_distance, _camera_target)


## Moves the camera back until the box around the fighter fits the screen, so it works in
## landscape and portrait.
func _frame_camera() -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var allowed: Rect2 = Rect2(
		view_size * Vector2(FRAME_MARGIN, FRAME_TOP_MARGIN),
		view_size * Vector2(1.0 - 2.0 * FRAME_MARGIN, 1.0 - FRAME_TOP_MARGIN - FRAME_MARGIN)
	)
	_camera_distance = CAMERA_MIN_DISTANCE
	while _camera_distance < CAMERA_MAX_DISTANCE:
		_place_camera()
		if _box_inside(allowed):
			return
		_camera_distance += CAMERA_DISTANCE_STEP


func _box_inside(allowed: Rect2) -> bool:
	var heights: Array[float] = [0.0, FIGHTER_HEIGHT]
	for sign_x: float in [-1.0, 1.0]:
		for sign_z: float in [-1.0, 1.0]:
			for height: float in heights:
				var corner: Vector3 = (
					_camera_target
					+ Vector3(sign_x * VIEW_HALF_SIZE.x, height, sign_z * VIEW_HALF_SIZE.y)
				)
				if not allowed.has_point(_camera.unproject_position(corner)):
					return false
	return true


func _update_fps_label() -> void:
	_fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
