extends Node3D
## The arena: floor, walls, one fighter, a camera above and behind it, and the HUD.
## Keyboard and touch joystick feed the same movement rule (`game/movement.gd`).

const START_SCREEN: String = "res://scenes/start_screen.tscn"
## The camera looks at this point from above and behind (towards +z), at this angle down.
const CAMERA_TARGET: Vector3 = Vector3(0.0, 0.0, 0.4)
const CAMERA_PITCH_DEGREES: float = 55.0
const CAMERA_MIN_DISTANCE: float = 8.0
const CAMERA_MAX_DISTANCE: float = 60.0
const CAMERA_DISTANCE_STEP: float = 0.25
## Top corners of the outer walls: the camera moves back until all of them are in view.
const ARENA_CORNERS: Array[Vector3] = [
	Vector3(-8.5, 1.2, -6.5),
	Vector3(8.5, 1.2, -6.5),
	Vector3(-8.5, 1.2, 6.5),
	Vector3(8.5, 1.2, 6.5),
]
## Free border around the arena as a share of the screen; more at the top for the Back button.
const FRAME_MARGIN: float = 0.03
const FRAME_TOP_MARGIN: float = 0.12

## When false, the fighter keeps the `input_direction` set from outside (tests).
var read_player_input: bool = true

@onready var _fighter: Fighter = $Fighter
@onready var _camera: Camera3D = $Camera
@onready var _joystick: TouchJoystick = $Hud/TouchJoystick
@onready var _back_button: Button = $Hud/BackButton


func _ready() -> void:
	_back_button.pressed.connect(_on_back_pressed)
	get_viewport().size_changed.connect(_frame_camera)
	_frame_camera()


func _physics_process(_delta: float) -> void:
	if not read_player_input:
		return
	var keys: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_fighter.input_direction = Movement.clamp_direction(keys + _joystick.direction)


## Places the camera as close as possible while the whole arena fits the screen, so it
## works in landscape and portrait.
func _frame_camera() -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var allowed: Rect2 = Rect2(
		view_size * Vector2(FRAME_MARGIN, FRAME_TOP_MARGIN),
		view_size * Vector2(1.0 - 2.0 * FRAME_MARGIN, 1.0 - FRAME_TOP_MARGIN - FRAME_MARGIN)
	)
	var pitch: float = deg_to_rad(CAMERA_PITCH_DEGREES)
	var backwards: Vector3 = Vector3(0.0, sin(pitch), cos(pitch))
	var distance: float = CAMERA_MIN_DISTANCE
	while distance < CAMERA_MAX_DISTANCE:
		_camera.look_at_from_position(CAMERA_TARGET + backwards * distance, CAMERA_TARGET)
		if _corners_inside(allowed):
			return
		distance += CAMERA_DISTANCE_STEP


func _corners_inside(allowed: Rect2) -> bool:
	for corner: Vector3 in ARENA_CORNERS:
		if not allowed.has_point(_camera.unproject_position(corner)):
			return false
	return true


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(START_SCREEN)
