class_name Fighter
extends CharacterBody3D
## A fighter that walks on the ground plane. The arena sets `input_direction` every physics
## frame from the keyboard and the touch joystick; tests may set it directly.
## A fighter can be hit: `hit(amount)` lowers `health` (a damage number rises, the health bar,
## when `show_health_bar` was called, follows), it heals after a quiet time (`heal_step`) and
## at 0 health it is knocked out: it spins and shrinks (a picture fighter tips over and fades),
## then is hidden with its collision off. A hit flashes a picture fighter white, and the input turns
## it to its back, front or side view (`face`).

signal hurt(amount: int)
signal knocked_out_now

const BAR_Y: float = 2.3
const NUMBER_Y: float = 2.6
## Over a picture fighter the bar sits this much over the top of its picture (metres).
const PICTURE_BAR_GAP: float = 0.3
const KNOCK_OUT_SECONDS: float = 0.5
const KNOCK_OUT_SPINS: float = 2.0

@export var speed_per_second: float = 5.0
## The fighter counts as running above this speed (m/s).
@export var running_speed: float = 0.1
@export var max_health: float = MatchSettings.FIGHTER_HEALTH

## Direction from the keyboard or the joystick, length at most 1.
var input_direction: Vector2 = Vector2.ZERO
var health: float = MatchSettings.FIGHTER_HEALTH
var knocked_out: bool = false
## Set when the match is over: the result is final, so hits do nothing any more.
var invulnerable: bool = false
## When the fighter was last hit or fired (seconds of the game clock); healing waits for it.
var last_action_seconds: float = 0.0
## When the fighter last fired (the arena's cool-down).
var last_fire_seconds: float = -INF
## The colour of the damage numbers over this fighter.
var number_color: Color = Color.WHITE

var _health_bar: HealthBar
var _knock_out_left: float = 0.0

@onready var model: FighterModel = $Model
@onready var muzzle: Marker3D = $Muzzle
@onready var _collision: CollisionShape3D = $Collision


## Shows a fighter in a skin (the arena calls this with the player's choice).
func set_look(fighter_id: String, skin_id: String) -> void:
	model.setup(fighter_id, skin_id)


## Shows a health bar over the fighter in `color`.
func show_health_bar(color: Color) -> void:
	if _health_bar == null:
		_health_bar = HealthBar.new()
		_health_bar.name = "HealthBar"
		_health_bar.position = _bar_offset()
		add_child(_health_bar)
	_health_bar.fixed_color = color
	_health_bar.show_ratio(Combat.health_ratio(health, max_health))


func health_bar() -> HealthBar:
	return _health_bar


func _physics_process(_delta: float) -> void:
	if knocked_out:
		return
	velocity = Movement.velocity(input_direction, speed_per_second)
	move_and_slide()
	model.running = velocity.length() > running_speed
	if model.cutout_animator() != null:
		model.cutout_animator().walk_speed = velocity.length()
	if not input_direction.is_zero_approx():
		rotation.y = Movement.facing_yaw(input_direction)
		face(screen_direction(input_direction))


## Turns a picture fighter to the view of `direction` (input or aim on the screen: x is the
## screen's right, y its down): its back going up the screen, its front going down, its side going
## left or right (`CutoutAnimator`).
func face(direction: Vector2) -> void:
	model.face(direction)


## A direction on the ground (x, z) as the camera in use shows it on the screen (D50); as it is
## without a camera.
func screen_direction(world_direction: Vector2) -> Vector2:
	var camera: Camera3D = get_viewport().get_camera_3d() if is_inside_tree() else null
	if camera == null:
		return world_direction
	return CameraViews.to_screen(world_direction, CameraViews.yaw_of(camera.global_transform))


func _process(delta: float) -> void:
	if _health_bar != null and model.get_cutout() != null:
		_health_bar.position = _bar_offset()
	if _knock_out_left <= 0.0:
		return
	_knock_out_left = maxf(_knock_out_left - delta, 0.0)
	var progress: float = 1.0 - _knock_out_left / KNOCK_OUT_SECONDS
	if not model.knock_out_pose(progress):
		model.rotation.y += TAU * KNOCK_OUT_SPINS * delta / KNOCK_OUT_SECONDS
		model.scale = Vector3.ONE * (1.0 - progress)
	if _knock_out_left <= 0.0:
		visible = false


## Where the health bar sits (local to the fighter): `BAR_Y` over the feet, or over the top of a
## picture fighter's picture as the camera sees it (the picture turns to the camera, D21) — along
## the camera's up, so it stays over the picture in every view and anywhere on the screen.
func _bar_offset() -> Vector3:
	if model.get_cutout() == null:
		return Vector3(0.0, BAR_Y, 0.0)
	var camera: Transform3D = _camera_transform()
	return _local(model.picture_top(camera) + camera.basis.y.normalized() * PICTURE_BAR_GAP)


## The direction a damage number rises (local): up, or the camera's up over a picture fighter.
func _number_rise() -> Vector3:
	if model.get_cutout() == null:
		return Vector3.UP
	return _local(_camera_transform().basis.y.normalized())


func _camera_transform() -> Transform3D:
	var camera: Camera3D = get_viewport().get_camera_3d() if is_inside_tree() else null
	return camera.global_transform if camera != null else Transform3D.IDENTITY


## A world direction turned into the fighter's own frame (the fighter turns to its input).
func _local(direction: Vector3) -> Vector3:
	var turned: Basis = global_basis if is_inside_tree() else basis
	return turned.inverse() * direction


## Takes `amount` damage; ignored once knocked out or invulnerable. At 0 health the fighter is
## knocked out.
func hit(amount: int) -> void:
	if knocked_out or invulnerable:
		return
	health = maxf(health - amount, 0.0)
	last_action_seconds = _now()
	_show_health()
	model.flash()
	var rise: Vector3 = _number_rise()
	var number_at: Vector3 = _bar_offset() + rise * (NUMBER_Y - BAR_Y)
	DamageNumber.spawn(self, number_at, amount, number_color, rise)
	hurt.emit(amount)
	if health <= 0.0:
		knock_out()


## Marks the moment of a shot, so healing waits for a quiet time after it.
func note_action() -> void:
	last_action_seconds = _now()


## Heals for `delta` seconds once the fighter was quiet for `delay` (see `Combat.heal`).
func heal_step(
	now: float,
	delta: float,
	delay: float = MatchSettings.HEAL_DELAY,
	per_second: float = MatchSettings.HEAL_PER_SECOND
) -> void:
	if knocked_out or health >= max_health:
		return
	health = Combat.heal(health, max_health, now - last_action_seconds, delta, delay, per_second)
	_show_health()


func knock_out() -> void:
	if knocked_out:
		return
	knocked_out = true
	health = 0.0
	_show_health()
	_collision.disabled = true
	velocity = Vector3.ZERO
	model.running = false
	if _health_bar != null:
		_health_bar.visible = false
	_knock_out_left = KNOCK_OUT_SECONDS
	knocked_out_now.emit()


func _show_health() -> void:
	if _health_bar != null:
		_health_bar.show_ratio(Combat.health_ratio(health, max_health))


static func _now() -> float:
	return Time.get_ticks_msec() / 1000.0
