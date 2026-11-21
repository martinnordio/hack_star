class_name Fighter
extends CharacterBody3D
## A fighter that walks on the ground plane. The arena sets `input_direction` every physics
## frame from the keyboard and the touch joystick; tests may set it directly.
## A fighter can be hit: `hit(amount)` lowers `health` (a damage number rises, the health bar,
## when `show_health_bar` was called, follows), it heals after a quiet time (`heal_step`) and
## at 0 health it is knocked out: it spins and shrinks, then is hidden with its collision off.

signal hurt(amount: int)
signal knocked_out_now

const BAR_Y: float = 2.3
const NUMBER_Y: float = 2.6
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
		_health_bar.position = Vector3(0.0, BAR_Y, 0.0)
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
	if not input_direction.is_zero_approx():
		rotation.y = Movement.facing_yaw(input_direction)


func _process(delta: float) -> void:
	if _knock_out_left <= 0.0:
		return
	_knock_out_left = maxf(_knock_out_left - delta, 0.0)
	var progress: float = 1.0 - _knock_out_left / KNOCK_OUT_SECONDS
	model.rotation.y += TAU * KNOCK_OUT_SPINS * delta / KNOCK_OUT_SECONDS
	model.scale = Vector3.ONE * (1.0 - progress)
	if _knock_out_left <= 0.0:
		visible = false


## Takes `amount` damage; ignored once knocked out or invulnerable. At 0 health the fighter is
## knocked out.
func hit(amount: int) -> void:
	if knocked_out or invulnerable:
		return
	health = maxf(health - amount, 0.0)
	last_action_seconds = _now()
	_show_health()
	DamageNumber.spawn(self, Vector3(0.0, NUMBER_Y, 0.0), amount, number_color)
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
