class_name ArenaLayout
extends RefCounted
## The canyon arena on the ground plane (x right, z towards the camera, as `Movement`): the
## border and the rock blocks, the cactus patches (bushes), the decoration, the dummy spots
## and the start point. Pure data and rules; `Canyon` builds the scenery from it.

## Width (x) and depth (z) of the arena in metres, centred on the origin.
const SIZE: Vector2 = Vector2(20.0, 26.0)
## Solid blocks: the four border walls first, then the rocks inside.
const WALLS: Array[Rect2] = [
	Rect2(-10.0, -13.0, 20.0, 1.0),
	Rect2(-10.0, 12.0, 20.0, 1.0),
	Rect2(-10.0, -12.0, 1.0, 24.0),
	Rect2(9.0, -12.0, 1.0, 24.0),
	Rect2(-6.5, 5.0, 3.0, 1.5),
	Rect2(3.5, 5.0, 3.0, 1.5),
	Rect2(-1.5, -0.75, 3.0, 1.5),
	Rect2(-9.0, -5.0, 2.5, 2.0),
	Rect2(6.5, -5.0, 2.5, 2.0),
	Rect2(-5.0, -9.5, 3.0, 1.5),
	Rect2(2.0, -9.5, 3.0, 1.5),
]
## How many of `WALLS` are the border (the rest are rocks).
const BORDER_COUNT: int = 4
## Cactus patches: the fighter can walk in, and is partly hidden there.
const BUSHES: Array[Rect2] = [
	Rect2(-8.5, 1.5, 3.0, 2.5),
	Rect2(5.5, 1.5, 3.0, 2.5),
	Rect2(-1.5, -7.0, 3.0, 2.0),
	Rect2(-8.5, 8.5, 2.5, 3.0),
]
## Things to look at, without collision: `kind` is crate, skull, rock or bones.
const DECORATION: Array[Dictionary] = [
	{"kind": "crate", "at": Vector2(7.5, 10.5)},
	{"kind": "crate", "at": Vector2(8.0, 9.2)},
	{"kind": "skull", "at": Vector2(-3.0, 8.0)},
	{"kind": "bones", "at": Vector2(2.5, 8.5)},
	{"kind": "rock", "at": Vector2(1.2, 3.0)},
	{"kind": "skull", "at": Vector2(-8.0, 0.0)},
	{"kind": "bones", "at": Vector2(7.8, 0.0)},
	{"kind": "bones", "at": Vector2(-2.6, -5.5)},
	{"kind": "rock", "at": Vector2(-8.0, -8.0)},
	{"kind": "rock", "at": Vector2(8.0, -8.5)},
	{"kind": "skull", "at": Vector2(6.5, -10.8)},
	{"kind": "crate", "at": Vector2(-7.5, -10.8)},
]
## Where the three target dummies stand.
const DUMMIES: Array[Vector2] = [Vector2(-4.0, -2.5), Vector2(4.0, -2.5), Vector2(0.0, -9.0)]
## Where the fighter starts, near the camera side.
const START: Vector2 = Vector2(0.0, 9.5)
## The start points of a match: the player's (`START`) first, then one per bot, spread over
## the canyon, free of rocks and bushes, at least 4 m apart.
const STARTS: Array[Vector2] = [
	START,
	Vector2(0.0, -10.5),
	Vector2(-7.5, -1.0),
	Vector2(7.5, -1.0),
	Vector2(-4.0, -5.5),
	Vector2(4.0, -5.5),
	Vector2(6.5, 9.5),
	Vector2(-3.5, 2.5),
	Vector2(3.5, 2.5),
]


## The arena's whole area, border walls included.
static func bounds() -> Rect2:
	return Rect2(-SIZE / 2.0, SIZE)


## True when the point lies in a cactus patch.
static func in_bush(point: Vector2) -> bool:
	for bush: Rect2 in BUSHES:
		if bush.has_point(point):
			return true
	return false


## True when a circle of `radius` around the point is inside the arena and touches no wall.
static func is_free(point: Vector2, radius: float) -> bool:
	if not bounds().grow(-radius).has_point(point):
		return false
	for wall: Rect2 in WALLS:
		if wall.grow(radius).has_point(point):
			return false
	return true
