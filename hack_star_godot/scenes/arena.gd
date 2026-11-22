class_name Arena
extends Node3D
## The arena: the chosen world (`GameState.world`: the canyon, `Canyon`, or Glimmer Isles,
## `GlimmerIsles`, each built from its `ArenaLayout`), one fighter, a camera above
## and behind it, and the HUD. With `training` (the Training arena) the three target dummies
## stand in it; `MatchArena` (`match.tscn`) inherits the scene for a match.
## Keyboard and touch joystick feed the same movement rule (`game/movement.gd`); Space (the
## `shoot` action, held to keep firing) and the right stick (`AimJoystick`, drag and release or a
## quick tap) fire shots (`Shot`) under the rules of `game/combat.gd`. The mouse does not fire.
## `V` and `1`–`4` switch the camera view (`CameraViews`, spec 09 V1–V6), kept in
## `GameState.camera_view`; `L` switches the lighting preset and `K` the saturation boost
## (`LightPresets`, `WorldLighting`, L3–L6), kept in `GameState`; `HudToast` names them.

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
## The camera-side border wall covers at most this share of the screen height (spec 09, G11):
## the camera never looks farther south than that, so the extra height of a tall screen shows
## the arena ahead instead of the wall and the ground behind it.
const NEAR_WALL_SHARE: float = 0.08
## The near wall's top above its height: the cap `Canyon` puts on every wall.
const WALL_CAP_HEIGHT: float = 0.1
## The FPS label (hidden unless the info screen's play-test switch is on) refreshes this often.
const FPS_LABEL_INTERVAL: float = 0.25
## The controls hint at the start is fully visible for this long, then fades out over the next.
const HINT_SECONDS: float = 5.0
const HINT_FADE_SECONDS: float = 1.0
## With touch controls the hint stands this far above the bottom edge, clear of the sticks.
const HINT_ABOVE_STICKS: float = 288.0
## A switch of the camera view moves the camera over this long (D25).
const VIEW_BLEND_SECONDS: float = 0.3
## Overview keeps this share of the screen free at the sides and the bottom around the arena.
const OVERVIEW_MARGIN: float = 0.02

const DUMMY_SCENE: PackedScene = preload("res://scenes/target_dummy.tscn")
## Dust puffs under a running fighter come this often, in this colour.
const DUST_INTERVAL: float = 0.25
const DUST_COLOR: Color = Color(1.0, 0.98, 0.9, 0.85)
const SPARK_COLOR: Color = Color(1.0, 0.95, 0.7)

## Only the Training arena places the target dummies.
@export var training: bool = true

## When false, the fighter keeps the `input_direction` set from outside (tests).
var read_player_input: bool = true

## Whether the sticks are on screen (a touch screen); tests set it before the arena is ready.
var touch_controls: bool = DisplayServer.is_touchscreen_available()

var _fps_timer: float = 0.0
var _camera_target: Vector3 = Vector3.ZERO
var _camera_distance: float = CAMERA_MIN_DISTANCE
# The southmost the camera target may go (see `NEAR_WALL_SHARE`).
var _camera_max_z: float = INF
var _close_max_z: float = INF
# The fighter's position, followed like `_camera_target` (Close and Behind).
var _follow_point: Vector3 = Vector3.ZERO
var _overview_distance: float = CAMERA_MIN_DISTANCE
var _view: String = CameraViews.CLASSIC
var _blend_from: Transform3D = Transform3D.IDENTITY
var _blend_left: float = 0.0
var _toast: HudToast
var _lighting: WorldLighting
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
@onready var _controls_hint: Control = $Hud/ControlsHint
@onready var _controls_hint_label: Label = $Hud/ControlsHint/Row/Label


func _notification(what: int) -> void:
	# Before any child is ready: the chosen world's layout and scenery (spec 09, D9).
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_use_world()


## Makes the chosen world (`GameState.world`) the active layout and, for Glimmer Isles, puts
## `GlimmerIsles` in place of the scene's `Canyon`, on the same floor and walls.
func _use_world() -> void:
	ArenaLayout.use(GameState.world)
	# An inherited scene (`match.tscn`) gets the notification once per scene level.
	if ArenaLayout.world() == Worlds.CANYON or not has_node("Canyon"):
		return
	var canyon: Node = get_node("Canyon")
	var isles: GlimmerIsles = GlimmerIsles.new()
	isles.name = "GlimmerIsles"
	isles.floor_body = get_node("Floor")
	isles.walls = get_node("Walls")
	add_child(isles)
	move_child(isles, canyon.get_index())
	remove_child(canyon)
	canyon.free()


func _ready() -> void:
	_fighter.position = Vector3(ArenaLayout.start().x, 0.0, ArenaLayout.start().y)
	_fighter.set_look(GameState.selected_fighter, GameState.selected_skin())
	_aim_joystick.released.connect(_on_aim_released)
	_toast = HudToast.new()
	$Hud.add_child(_toast)
	_view = GameState.camera_view
	# The world has built its own light by now (its `_ready` runs first).
	_lighting = WorldLighting.new()
	_lighting.name = "Lighting"
	add_child(_lighting)
	_lighting.setup($WorldEnvironment, $Sun)
	_lighting.apply(GameState.light_preset, GameState.saturation_boost)
	if training:
		for spot: Vector2 in ArenaLayout.dummies():
			var dummy: TargetDummy = DUMMY_SCENE.instantiate()
			dummy.position = Vector3(spot.x, 0.0, spot.y)
			_dummies.add_child(dummy)
	get_viewport().size_changed.connect(_frame_camera)
	_frame_camera()
	_camera_target = _wanted_camera_target()
	_follow_point = _fighter.position
	_place_camera()
	_fps_label.visible = GameState.show_fps
	_update_fps_label()
	_show_controls_hint()


func _show_controls_hint() -> void:
	var lines: Array[String] = []
	if touch_controls:
		# The sticks stand at the bottom corners; the hint goes above their height. Only the
		# sticks are named and the box grows upwards to its text, so the hint stays small
		# enough to clear the countdown.
		lines.append(ControlsHelp.TOUCH_HINT)
		_controls_hint.offset_bottom = -HINT_ABOVE_STICKS
		_controls_hint.offset_top = _controls_hint.offset_bottom
	else:
		lines.append(ControlsHelp.KEYBOARD_HINT)
		lines.append(ControlsHelp.MORE_IN_INFO)
	_controls_hint_label.text = "\n".join(lines)
	($Hud/ControlsHint/Row/Icon as TextureRect).texture = Icons.get_icon("info")
	_controls_hint.modulate.a = 1.0
	_controls_hint.show()
	var fade: Tween = create_tween()
	fade.tween_interval(HINT_SECONDS)
	fade.tween_property(_controls_hint, "modulate:a", 0.0, HINT_FADE_SECONDS)
	fade.tween_callback(_controls_hint.hide)


func _process(delta: float) -> void:
	_camera_target = Movement.follow(
		_camera_target, _wanted_camera_target(), delta, CAMERA_FOLLOW_RATE
	)
	_follow_point = Movement.follow(_follow_point, _fighter.position, delta, CAMERA_FOLLOW_RATE)
	_blend_left = maxf(_blend_left - delta, 0.0)
	_place_camera()
	if read_player_input and Input.is_action_pressed("shoot"):
		fire(_aim_direction())
	_update_aim_line()
	_dust_left -= delta
	if _fighter.model.running and _dust_left <= 0.0:
		_dust_left = DUST_INTERVAL
		_effects.play(ArenaEffects.DUST, _fighter.global_position + Vector3.UP * 0.1, DUST_COLOR)
	_fps_timer += delta
	if _fps_label.visible and _fps_timer >= FPS_LABEL_INTERVAL:
		_fps_timer = 0.0
		_update_fps_label()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("light_next"):
		set_light_preset(LightPresets.next(GameState.light_preset))
		return
	if event.is_action_pressed("saturation_boost"):
		set_saturation_boost(not GameState.saturation_boost)
		return
	if event.is_action_pressed("view_next"):
		set_view(CameraViews.next(_view))
		return
	var all: Array[String] = CameraViews.ids()
	for index: int in all.size():
		if event.is_action_pressed("view_%d" % (index + 1)):
			set_view(all[index])
			return


## The camera view in use (`CameraViews`).
func view() -> String:
	return _view


## Switches to the camera view `view_id`, kept for the next match and Training, names it in the
## toast and moves the camera there over `VIEW_BLEND_SECONDS`.
func set_view(view_id: String) -> void:
	if not CameraViews.ids().has(view_id):
		return
	if view_id != _view:
		_blend_from = _camera.global_transform
		_blend_left = VIEW_BLEND_SECONDS
	_view = view_id
	GameState.camera_view = view_id
	_toast.show_text(CameraViews.view_name(view_id))


## The toast that names the view and the lighting preset.
func toast() -> HudToast:
	return _toast


## The arena's lighting (`WorldLighting`).
func lighting() -> WorldLighting:
	return _lighting


## Lights the arena with the preset `preset_id`, kept for the next match and Training, and names
## it in the toast.
func set_light_preset(preset_id: String) -> void:
	_lighting.apply(preset_id, GameState.saturation_boost)
	GameState.light_preset = _lighting.preset()
	_toast.show_text(LightPresets.preset_name(_lighting.preset()))


## Switches the saturation boost on or off, kept for the next match and Training, and says so.
func set_saturation_boost(boost: bool) -> void:
	_lighting.apply(GameState.light_preset, boost)
	GameState.saturation_boost = boost
	_toast.show_text(LightPresets.boost_text(boost))


func _physics_process(_delta: float) -> void:
	_fighter.model.set_see_through(
		ArenaLayout.in_bush(Vector2(_fighter.position.x, _fighter.position.z))
	)
	if not player_can_act():
		_fighter.input_direction = Vector2.ZERO
		return
	if not read_player_input:
		return
	var keys: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_fighter.input_direction = Movement.clamp_direction(keys + _joystick.direction)


## Fires a shot along `direction` (ground plane, x and z) when the cool-down is over: the
## fighter turns that way and recoils, the shot leaves the muzzle. True when it fired.
func fire(direction: Vector2) -> bool:
	if not player_can_act():
		return false
	return fire_from(_fighter, direction, Combat.COOLDOWN)


## Whether the player may move and fire now; always in Training, a match locks it outside the
## fight.
func player_can_act() -> bool:
	return true


## Where a quick tap of the aim stick may aim: the dummies still standing.
func tap_targets() -> Array[Vector2]:
	var targets: Array[Vector2] = []
	for target: Node in get_tree().get_nodes_in_group("targets"):
		if target.has_method("is_broken") and target.call("is_broken"):
			continue
		var at: Vector3 = (target as Node3D).global_position
		targets.append(Vector2(at.x, at.z))
	return targets


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
	fighter.face(direction)
	fighter.model.play_attack()
	fighter.model.muzzle_flash()
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


func _on_aim_released(direction: Vector2, held_seconds: float) -> void:
	var aim: Vector2 = Combat.release_aim(direction, held_seconds)
	if aim == Combat.NO_SHOT:
		return
	if aim == Vector2.ZERO:
		aim = _aim_direction()
	fire(aim)


## A quick tap and Space fire at the nearest of `tap_targets` in range, else straight ahead.
func _aim_direction() -> Vector2:
	var from: Vector2 = Vector2(_fighter.position.x, _fighter.position.z)
	var targets: Array[Vector2] = tap_targets()
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
	var target: Vector3 = _fighter.position + Vector3(0.0, 0.0, -CAMERA_LOOK_AHEAD)
	target.z = minf(target.z, _camera_max_z)
	return target


## Places the camera for the view in use, part of the way there during a switch.
func _place_camera() -> void:
	var pose: Transform3D = view_pose(_view)
	if _blend_left > 0.0:
		var share: float = smoothstep(0.0, 1.0, 1.0 - _blend_left / VIEW_BLEND_SECONDS)
		pose = _blend_from.interpolate_with(pose, share)
	_camera.global_transform = pose


## Where the camera stands and looks in the view `view_id` (D25); it always looks north.
func view_pose(view_id: String) -> Transform3D:
	var view_data: Dictionary = CameraViews.get_view(view_id)
	var pitch: float = view_data["pitch_degrees"]
	match view_id:
		CameraViews.CLOSE:
			var target: Vector3 = _follow_point + Vector3(0.0, 0.0, -CAMERA_LOOK_AHEAD)
			# Like Classic, it does not look so far south that the near wall fills the screen.
			target.z = minf(target.z, _close_max_z)
			return _orbit_pose(target, pitch, _close_distance())
		CameraViews.BEHIND:
			# `distance` behind the fighter, as high as the pitch towards the look-ahead point.
			var ahead: float = view_data["look_ahead"]
			var behind: float = view_data["distance"]
			var height: float = (ahead + behind) * tan(deg_to_rad(pitch))
			var eye: Vector3 = _follow_point + Vector3(0.0, height, behind)
			var ahead_point: Vector3 = _follow_point + Vector3(0.0, 0.0, -ahead)
			return Transform3D(Basis.looking_at(ahead_point - eye, Vector3.UP), eye)
		CameraViews.OVERVIEW:
			var center: Vector2 = ArenaLayout.bounds().get_center()
			return _orbit_pose(Vector3(center.x, 0.0, center.y), pitch, _overview_distance)
	return _orbit_pose(_camera_target, CAMERA_PITCH_DEGREES, _camera_distance)


# The camera `distance` metres from `target`, south of it, looking `pitch_degrees` down at it.
static func _orbit_pose(target: Vector3, pitch_degrees: float, distance: float) -> Transform3D:
	var pitch: float = deg_to_rad(pitch_degrees)
	var eye: Vector3 = target + Vector3(0.0, sin(pitch), cos(pitch)) * distance
	return Transform3D(Basis.looking_at(target - eye, Vector3.UP), eye)


# How far the Close camera is from its target: a share of Classic's distance, not too near.
func _close_distance() -> float:
	var close: Dictionary = CameraViews.get_view(CameraViews.CLOSE)
	return maxf(_camera_distance * float(close["distance_share"]), float(close["min_distance"]))


## The z of the camera-side border wall's inner face (the border wall farthest south).
static func near_wall_z() -> float:
	var nearest: float = -INF
	for index: int in ArenaLayout.border_count():
		nearest = maxf(nearest, ArenaLayout.walls()[index].position.y)
	return nearest


## Moves the camera back until the box around the fighter fits the screen, so it works in
## landscape and portrait; then finds how far south the camera may look.
func _frame_camera() -> void:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var allowed: Rect2 = Rect2(
		view_size * Vector2(FRAME_MARGIN, FRAME_TOP_MARGIN),
		view_size * Vector2(1.0 - 2.0 * FRAME_MARGIN, 1.0 - FRAME_TOP_MARGIN - FRAME_MARGIN)
	)
	_camera_distance = CAMERA_MIN_DISTANCE
	while _camera_distance < CAMERA_MAX_DISTANCE:
		_camera.global_transform = view_pose(CameraViews.CLASSIC)
		if _box_inside(allowed):
			break
		_camera_distance += CAMERA_DISTANCE_STEP
	_camera_max_z = (
		near_wall_z() - _near_wall_offset(view_size.y, CAMERA_PITCH_DEGREES, _camera_distance)
	)
	var close: Dictionary = CameraViews.get_view(CameraViews.CLOSE)
	_close_max_z = (
		near_wall_z() - _near_wall_offset(view_size.y, close["pitch_degrees"], _close_distance())
	)
	_frame_overview(view_size)
	_place_camera()


# Moves the Overview camera back until the whole arena, border walls included, fits the screen
# (V5), below the top margin of the Back button and the match's chips.
func _frame_overview(view_size: Vector2) -> void:
	var allowed: Rect2 = Rect2(
		view_size * Vector2(OVERVIEW_MARGIN, FRAME_TOP_MARGIN),
		view_size * Vector2(1.0 - 2.0 * OVERVIEW_MARGIN, 1.0 - FRAME_TOP_MARGIN - OVERVIEW_MARGIN)
	)
	var bounds: Rect2 = ArenaLayout.bounds()
	var corners: Array[Vector3] = []
	for x: float in [bounds.position.x, bounds.end.x]:
		for z: float in [bounds.position.y, bounds.end.y]:
			for height: float in [0.0, Canyon.WALL_HEIGHT + WALL_CAP_HEIGHT]:
				corners.append(Vector3(x, height, z))
	_overview_distance = CAMERA_MIN_DISTANCE
	while _overview_distance < CAMERA_MAX_DISTANCE:
		_camera.global_transform = view_pose(CameraViews.OVERVIEW)
		var inside: bool = true
		for corner: Vector3 in corners:
			inside = inside and allowed.has_point(_camera.unproject_position(corner))
		if inside:
			return
		_overview_distance += CAMERA_DISTANCE_STEP


# How far south of the camera target the near wall's top edge may be, so that the wall covers
# at most `NEAR_WALL_SHARE` of the screen height, for a camera `distance` metres from its target
# at `pitch_degrees`. The camera moves with its target, so the answer does not depend on where
# the target is.
func _near_wall_offset(view_height: float, pitch_degrees: float, distance: float) -> float:
	_camera.global_transform = _orbit_pose(Vector3.ZERO, pitch_degrees, distance)
	var wall_top: float = Canyon.CAMERA_SIDE_WALL_HEIGHT + WALL_CAP_HEIGHT
	var wanted_y: float = view_height * (1.0 - NEAR_WALL_SHARE)
	var near: float = 0.0
	# Not past the camera itself, where a point would be behind it.
	var far: float = distance * cos(deg_to_rad(pitch_degrees))
	for _step: int in 40:
		var offset: float = (near + far) / 2.0
		var edge: Vector3 = Vector3(0.0, wall_top, offset)
		if _camera.unproject_position(edge).y < wanted_y:
			near = offset
		else:
			far = offset
	return near


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
