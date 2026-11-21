extends Node3D
## The arena: the canyon (`Canyon`, built from `ArenaLayout`), one fighter, a camera above
## and behind it, and the HUD.
## Keyboard and touch joystick feed the same movement rule (`game/movement.gd`); the mouse
## (aim and click) and the right stick (`AimJoystick`, drag and release or a quick tap) fire
## shots (`Shot`) under the rules of `game/combat.gd`.

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

const DUMMY_SCENE: PackedScene = preload("res://scenes/target_dummy.tscn")
## Dust puffs under a running fighter come this often, in this colour.
const DUST_INTERVAL: float = 0.25
const DUST_COLOR: Color = Color(1.0, 0.98, 0.9, 0.85)
const SPARK_COLOR: Color = Color(1.0, 0.95, 0.7)

## When false, the fighter keeps the `input_direction` set from outside (tests).
var read_player_input: bool = true

var _fps_timer: float = 0.0
var _camera_target: Vector3 = Vector3.ZERO
var _camera_distance: float = CAMERA_MIN_DISTANCE
var _mouse_held: bool = false
var _mouse_position: Vector2 = Vector2.ZERO
var _dust_left: float = 0.0

@onready var _fighter: Fighter = $Fighter
@onready var _camera: Camera3D = $Camera
@onready var _joystick: TouchJoystick = $Hud/TouchJoystick
@onready var _aim_joystick: TouchJoystick = $Hud/AimJoystick
@onready var _aim_line: MeshInstance3D = $AimLine
@onready var _shots: Node3D = $Shots
@onready var _dummies: Node3D = $Dummies
@onready var _effects: ArenaEffects = $Effects
@onready var _fps_label: Label = $Hud/FpsLabel


func _ready() -> void:
	_fighter.position = Vector3(ArenaLayout.START.x, 0.0, ArenaLayout.START.y)
	_fighter.set_look(GameState.selected_fighter, GameState.selected_skin())
	_aim_joystick.released.connect(_on_aim_released)
	for spot: Vector2 in ArenaLayout.DUMMIES:
		var dummy: TargetDummy = DUMMY_SCENE.instantiate()
		dummy.position = Vector3(spot.x, 0.0, spot.y)
		_dummies.add_child(dummy)
	_camera_target = _wanted_camera_target()
	get_viewport().size_changed.connect(_frame_camera)
	_frame_camera()
	_update_fps_label()


func _process(delta: float) -> void:
	_camera_target = Movement.follow(
		_camera_target, _wanted_camera_target(), delta, CAMERA_FOLLOW_RATE
	)
	_place_camera()
	if _mouse_held:
		_fire_at_mouse()
	_update_aim_line()
	_dust_left -= delta
	if _fighter.model.running and _dust_left <= 0.0:
		_dust_left = DUST_INTERVAL
		_effects.play(ArenaEffects.DUST, _fighter.global_position + Vector3.UP * 0.1, DUST_COLOR)
	_fps_timer += delta
	if _fps_timer >= FPS_LABEL_INTERVAL:
		_fps_timer = 0.0
		_update_fps_label()


func _physics_process(_delta: float) -> void:
	_fighter.model.set_see_through(
		ArenaLayout.in_bush(Vector2(_fighter.position.x, _fighter.position.z))
	)
	if not read_player_input:
		return
	var keys: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_fighter.input_direction = Movement.clamp_direction(keys + _joystick.direction)


## The mouse aims and fires; GUI controls (Back) take their clicks before this, and mouse
## events made from touches are ignored, so a touch never fires twice.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse and event.device == InputEvent.DEVICE_ID_EMULATION:
		return
	if event is InputEventMouseMotion:
		_mouse_position = (event as InputEventMouseMotion).position
	elif event is InputEventMouseButton:
		var button: InputEventMouseButton = event
		if button.button_index != MOUSE_BUTTON_LEFT:
			return
		_mouse_held = button.pressed
		_mouse_position = button.position
		if button.pressed:
			_fire_at_mouse()


## Fires a shot along `direction` (ground plane, x and z) when the cool-down is over: the
## fighter turns that way and recoils, the shot leaves the muzzle. True when it fired.
func fire(direction: Vector2) -> bool:
	return fire_from(_fighter, direction, Combat.COOLDOWN)


## Like `fire`, for any fighter with its own `cooldown`; a knocked-out fighter does not fire.
func fire_from(fighter: Fighter, direction: Vector2, cooldown: float) -> bool:
	var now: float = Time.get_ticks_msec() / 1000.0
	if (
		fighter.knocked_out
		or direction.is_zero_approx()
		or not Combat.can_fire(now, fighter.last_fire_seconds, cooldown)
	):
		return false
	fighter.last_fire_seconds = now
	fighter.note_action()
	fighter.rotation.y = Movement.facing_yaw(direction)
	fighter.model.play_attack()
	var shot: Shot = Shot.new()
	var muzzle: Vector3 = fighter.muzzle.global_position
	# The first ray starts at the fighter's body, so a wall or dummy it touches is hit.
	var body: Vector3 = Vector3(fighter.global_position.x, muzzle.y, fighter.global_position.z)
	var color: Color = fighter.model.main_color
	shot.launch(muzzle, Vector3(direction.x, 0.0, direction.y), color, body, fighter)
	_shots.add_child(shot)
	shot.ended.connect(_on_shot_ended.bind(color))
	_effects.play(ArenaEffects.FLASH, muzzle, Color(1.0, 0.95, 0.7))
	return true


func _on_shot_ended(end_position: Vector3, _hit: bool, color: Color) -> void:
	_effects.play(ArenaEffects.SPARKS, end_position, color.lerp(SPARK_COLOR, 0.4))


## Plays the knock-out puff in the fighter's colour when it is knocked out.
func watch_knock_out(fighter: Fighter) -> void:
	fighter.knocked_out_now.connect(
		func() -> void:
			_effects.play(
				ArenaEffects.KNOCKOUT,
				fighter.global_position + Vector3.UP * 0.9,
				fighter.model.main_color
			)
	)


func _fire_at_mouse() -> void:
	var point: Vector3 = Combat.ground_point(
		_camera.project_ray_origin(_mouse_position),
		_camera.project_ray_normal(_mouse_position),
		0.0
	)
	if point == Vector3.INF:
		return
	fire(Vector2(point.x - _fighter.position.x, point.z - _fighter.position.z))


func _on_aim_released(direction: Vector2, held_seconds: float) -> void:
	var aim: Vector2 = Combat.release_aim(direction, held_seconds)
	if aim == Combat.NO_SHOT:
		return
	if aim == Vector2.ZERO:
		aim = _tap_direction()
	fire(aim)


## A quick tap fires at the nearest target (a dummy still standing) in range, else straight
## ahead.
func _tap_direction() -> Vector2:
	var from: Vector2 = Vector2(_fighter.position.x, _fighter.position.z)
	var targets: Array[Vector2] = []
	for target: Node in get_tree().get_nodes_in_group("targets"):
		if target.has_method("is_broken") and target.call("is_broken"):
			continue
		var at: Vector3 = (target as Node3D).global_position
		targets.append(Vector2(at.x, at.z))
	var nearest: int = Combat.nearest_target(from, targets, Combat.SHOT_RANGE)
	if nearest >= 0 and not targets[nearest].is_equal_approx(from):
		return targets[nearest] - from
	var forward: Vector3 = -_fighter.global_basis.z
	return Vector2(forward.x, forward.z)


## A thin line on the ground shows where the right stick aims while it is dragged.
func _update_aim_line() -> void:
	var aim: Vector2 = _aim_joystick.direction
	var aiming: bool = _aim_joystick.is_held() and aim.length() >= Combat.AIM_DEAD_ZONE
	_aim_line.visible = aiming
	if not aiming:
		return
	var unit: Vector2 = aim.normalized()
	var middle: Vector2 = unit * Combat.SHOT_RANGE / 2.0
	_aim_line.position = _fighter.position + Vector3(middle.x, 0.04, middle.y)
	_aim_line.rotation = Vector3(0.0, Movement.facing_yaw(unit), 0.0)


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
