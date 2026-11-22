# Picks Echo's view (front / back / side) and animation (idle / walk / shoot)
# from how the player moves. Attached to the AnimatedSprite3D in echo_gameplay.tscn.
#
# AUTOMATIC: put echo_gameplay.tscn under your player's CharacterBody3D. The script
# reads the body's velocity every frame and plays the shoot pose when the "shoot"
# input action (or Space, if no such action exists) is pressed.
# MANUAL: call set_motion(velocity) and play_shoot(direction) from your own player script.
extends AnimatedSprite3D

@export var walk_threshold := 0.15     # speed below this counts as standing still
@export var auto_from_parent := true   # read velocity from the nearest CharacterBody3D
@export var auto_shoot_input := true   # listen for the shoot key itself
@export var shoot_hold_time := 0.25    # seconds the shoot pose stays on screen
@export var walk_bounce := 0.03        # small hop while walking (world units)

var _facing := "up"     # "up" = back view (moving away from camera), "down" = front, "side"
var _flip := false
var _moving := false
var _shoot_timer := 0.0
var _t := 0.0
var _body: CharacterBody3D
var _base_y := 0.0

func _ready() -> void:
	_base_y = position.y
	var n := get_parent()
	while n and auto_from_parent:
		if n is CharacterBody3D:
			_body = n
			break
		n = n.get_parent()
	_update_anim()

func _process(delta: float) -> void:
	if _body:
		set_motion(_body.velocity)
	if auto_shoot_input and _shoot_pressed():
		play_shoot()
	if _shoot_timer > 0.0:
		_shoot_timer -= delta
		if _shoot_timer <= 0.0:
			_update_anim()
	# little hop while walking
	if _moving and _shoot_timer <= 0.0:
		_t += delta
		position.y = _base_y + absf(sin(_t * 10.0)) * walk_bounce
	else:
		position.y = _base_y

## Give the current movement velocity (world space). Camera looks toward -Z.
func set_motion(velocity: Vector3) -> void:
	var v := Vector2(velocity.x, velocity.z)
	_moving = v.length() > walk_threshold
	if _moving:
		_set_facing_from(v)
	if _shoot_timer <= 0.0:
		_update_anim()

## Show the shoot pose. Pass the aim direction if it differs from the movement.
func play_shoot(direction: Vector3 = Vector3.ZERO) -> void:
	if direction != Vector3.ZERO:
		_set_facing_from(Vector2(direction.x, direction.z))
	_shoot_timer = shoot_hold_time
	flip_h = _flip
	play("shoot_" + _facing)

func _set_facing_from(v: Vector2) -> void:
	if absf(v.x) > absf(v.y):
		_facing = "side"
		_flip = v.x < 0.0          # side frames face right; mirror for left
	else:
		_facing = "up" if v.y < 0.0 else "down"
		_flip = false

func _update_anim() -> void:
	var anim := ("walk_" if _moving else "idle_") + _facing
	flip_h = _flip
	if animation != anim or not is_playing():
		play(anim)

func _shoot_pressed() -> bool:
	if InputMap.has_action("shoot"):
		return Input.is_action_just_pressed("shoot")
	return Input.is_physical_key_pressed(KEY_SPACE) and _shoot_timer <= 0.0
