class_name Movement
extends RefCounted
## Pure movement rule: input direction on the screen to velocity on the ground plane.
## Screen x maps to world x, screen y (down) maps to world z (towards the camera).


## Limits a direction to length 1 so a diagonal is never faster than a straight line.
static func clamp_direction(direction: Vector2) -> Vector2:
	return direction.limit_length(1.0)


## Velocity on the ground plane (y = 0); no input gives zero velocity (the fighter stops).
static func velocity(direction: Vector2, speed_per_second: float) -> Vector3:
	var clamped: Vector2 = clamp_direction(direction)
	return Vector3(clamped.x, 0.0, clamped.y) * speed_per_second


## Distance moved in one frame of `delta` seconds.
static func step(direction: Vector2, speed_per_second: float, delta: float) -> Vector3:
	return velocity(direction, speed_per_second) * delta


## Joystick direction from the finger's offset to the joystick centre, length at most 1.
static func joystick_direction(offset: Vector2, radius: float) -> Vector2:
	if radius <= 0.0:
		return Vector2.ZERO
	return clamp_direction(offset / radius)


## Exponential smoothing of `current` towards `target` (rate per second); frame-rate
## independent and never overshoots.
static func follow(current: Vector3, target: Vector3, delta: float, rate: float) -> Vector3:
	return current.lerp(target, 1.0 - exp(-rate * maxf(delta, 0.0)))


## Rotation around y that turns a node's forward (-z) towards the direction.
static func facing_yaw(direction: Vector2) -> float:
	return atan2(-direction.x, -direction.y)
