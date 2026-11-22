class_name CutoutShowcase
extends RefCounted
## The showcase of an animated picture fighter on a pedestal (spec 09, M8, M9, D39): a timeline
## of `LOOP_SECONDS` that never stands still — idle facing the viewer, a turn through the views
## (front, side, back, the other side, front), the front walk loop on the spot, the side shoot
## pose with the projectile flying out, then idle again. `FighterStage` plays it after the reveal
## and lets the fighter screen turn the figure through `RING` and shoot.

const LOOP_SECONDS: float = 7.0
const IDLE_END: float = 1.2
const TURN_STEP: float = 0.4
const TURN_END: float = 3.2
const WALK_END: float = 4.8
const SHOOT_END: float = 5.4
## How long the shoot frame shows on the pedestal.
const SHOOT_SECONDS: float = SHOOT_END - WALK_END
## The turn's views in order: the front, the side (looking right), the back, the other side.
const RING: Array[Dictionary] = [
	{"view": "down", "mirrored": false},
	{"view": "side", "mirrored": false},
	{"view": "up", "mirrored": false},
	{"view": "side", "mirrored": true},
]
## The projectile flies this far (metres) in `SHOT_FLIGHT_SECONDS`, fading over its second half.
const SHOT_DISTANCE: float = 1.5
const SHOT_FLIGHT_SECONDS: float = 0.45


## The pose at `time` seconds into the loop: `view`, `mirrored`, `running` (the walk loop) and
## `shooting` (the shoot frame).
static func at(time: float) -> Dictionary:
	var t: float = fposmod(time, LOOP_SECONDS)
	var pose: Dictionary = {"view": "down", "mirrored": false, "running": false, "shooting": false}
	if t >= IDLE_END and t < TURN_END:
		pose.merge(ring(int((t - IDLE_END) / TURN_STEP)), true)
	elif t >= TURN_END and t < WALK_END:
		pose["running"] = true
	elif t >= WALK_END and t < SHOOT_END:
		pose.merge(RING[1], true)
		pose["shooting"] = true
	return pose


## The view `index` steps around the ring from the front (any whole number).
static func ring(index: int) -> Dictionary:
	return RING[posmod(index, RING.size())]


## Where `view` (mirrored or not) stands in the ring.
static func ring_index(view: String, mirrored: bool) -> int:
	for index: int in RING.size():
		if RING[index]["view"] == view and RING[index]["mirrored"] == (view == "side" and mirrored):
			return index
	return 0


## The direction on the screen (x right, y down) a shot of `view` flies: the front towards the
## viewer, the back away, the side to its side.
static func shot_direction(view: String, mirrored: bool) -> Vector2:
	match view:
		"up":
			return Vector2.UP
		"side":
			return Vector2.LEFT if mirrored else Vector2.RIGHT
	return Vector2.DOWN
