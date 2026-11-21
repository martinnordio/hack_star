class_name Combat
extends RefCounted
## Pure rules of shooting and targets. Positions on the ground plane are Vector2 (x, z),
## as in `Movement`.

const SHOT_SPEED: float = 16.0
const SHOT_RANGE: float = 9.0
const COOLDOWN: float = 0.35
const DAMAGE: int = 480
const DUMMY_HEALTH: int = 2400
const RESPAWN_SECONDS: float = 5.0
const AIM_DEAD_ZONE: float = 0.3
const TAP_SECONDS: float = 0.25

const COLOR_GREEN: Color = Color(0.3, 0.8, 0.3)
const COLOR_YELLOW: Color = Color(0.95, 0.8, 0.2)
const COLOR_RED: Color = Color(0.9, 0.2, 0.2)

## Result of `release_aim` when the release fires nothing.
const NO_SHOT: Vector2 = Vector2.INF


## True when the cool-down since the last shot is over (bots pass a longer `cooldown`).
static func can_fire(now: float, last_fire: float, cooldown: float = COOLDOWN) -> bool:
	return now - last_fire >= cooldown


## Health after a hit; never below 0.
static func take_damage(health: int, amount: int) -> int:
	return maxi(health - amount, 0)


static func is_broken(health: int) -> bool:
	return health <= 0


## Health as a share of `max_health` (a dummy's by default), from 0 to 1.
static func health_ratio(health: float, max_health: float = DUMMY_HEALTH) -> float:
	return clampf(health / max_health, 0.0, 1.0)


## Health after `delta` seconds of healing: nothing before `quiet_seconds` (since the last hit
## or shot) reaches `delay`, then `per_second` of `max_health` a second, never above it.
static func heal(
	health: float,
	max_health: float,
	quiet_seconds: float,
	delta: float,
	delay: float,
	per_second: float
) -> float:
	if quiet_seconds < delay:
		return health
	return minf(health + max_health * per_second * delta, max_health)


## Green, yellow below 0.5, red below 0.25.
static func health_color(ratio: float) -> Color:
	if ratio < 0.25:
		return COLOR_RED
	if ratio < 0.5:
		return COLOR_YELLOW
	return COLOR_GREEN


## What releasing the aim stick does: a drag past the dead zone fires that way (unit
## direction); a quick tap gives `Vector2.ZERO` (fire at the nearest target); anything else
## is `NO_SHOT`.
static func release_aim(direction: Vector2, held_seconds: float) -> Vector2:
	if direction.length() >= AIM_DEAD_ZONE:
		return direction.normalized()
	if held_seconds < TAP_SECONDS:
		return Vector2.ZERO
	return NO_SHOT


## Index of the target nearest to `from` within `max_range`, or -1.
static func nearest_target(from: Vector2, targets: Array[Vector2], max_range: float) -> int:
	var best: int = -1
	var best_distance: float = max_range
	for i: int in targets.size():
		var distance: float = from.distance_to(targets[i])
		if distance <= best_distance:
			best = i
			best_distance = distance
	return best


## Where a ray meets the plane y = `height`; `Vector3.INF` when it never does.
static func ground_point(ray_origin: Vector3, ray_direction: Vector3, height: float) -> Vector3:
	if is_zero_approx(ray_direction.y):
		return Vector3.INF
	var t: float = (height - ray_origin.y) / ray_direction.y
	if t < 0.0:
		return Vector3.INF
	return ray_origin + ray_direction * t
