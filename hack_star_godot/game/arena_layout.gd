class_name ArenaLayout
extends RefCounted
## The arena on the ground plane (x right, z towards the camera, as `Movement`): the border and
## the solid blocks, the patches that hide (bushes), the decoration, the dummy spots and the
## start points. Pure data and rules. The constants below are the canyon's layout (`Canyon`
## builds its scenery from them); Glimmer Isles has its own (`GlimmerIslesLayout`). `use` sets
## the active world (spec 09, D9) and the functions and accessors (`walls()`, `bushes()`,
## `starts()`, ...) read the active layout, so the rules are the same in every world.

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
## Where the fighter starts in the canyon, near the camera side.
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

static var _world: String = Worlds.CANYON
static var _walls: Array[Rect2] = WALLS
static var _border_count: int = BORDER_COUNT
static var _bushes: Array[Rect2] = BUSHES
static var _decoration: Array[Dictionary] = DECORATION
static var _dummies: Array[Vector2] = DUMMIES
static var _starts: Array[Vector2] = STARTS


## Makes the layout of `world_id` the active one; an unknown id gives the canyon.
static func use(world_id: String) -> void:
	if world_id == Worlds.GLIMMER_ISLES:
		_world = world_id
		_walls = GlimmerIslesLayout.WALLS
		_border_count = GlimmerIslesLayout.BORDER_COUNT
		_bushes = GlimmerIslesLayout.BUSHES
		_decoration = GlimmerIslesLayout.DECORATION
		_dummies = GlimmerIslesLayout.DUMMIES
		_starts = GlimmerIslesLayout.STARTS
		return
	_world = Worlds.CANYON
	_walls = WALLS
	_border_count = BORDER_COUNT
	_bushes = BUSHES
	_decoration = DECORATION
	_dummies = DUMMIES
	_starts = STARTS


## The id of the active world.
static func world() -> String:
	return _world


## The solid blocks of the active layout, the border first.
static func walls() -> Array[Rect2]:
	return _walls


## How many of `walls()` are the border.
static func border_count() -> int:
	return _border_count


## The patches that hide a fighter.
static func bushes() -> Array[Rect2]:
	return _bushes


## The decoration spots (`{kind, at}`), without collision.
static func decoration() -> Array[Dictionary]:
	return _decoration


## Where the Training dummies stand.
static func dummies() -> Array[Vector2]:
	return _dummies


## The start points of a match, the player's first.
static func starts() -> Array[Vector2]:
	return _starts


## Where the player's fighter starts.
static func start() -> Vector2:
	return _starts[0]


## The arena's whole area, border walls included.
static func bounds() -> Rect2:
	return Rect2(-SIZE / 2.0, SIZE)


## True when the point lies in a patch that hides (`bushes()`).
static func in_bush(point: Vector2) -> bool:
	for bush: Rect2 in _bushes:
		if bush.has_point(point):
			return true
	return false


## True when a circle of `radius` around the point is inside the arena and touches no wall.
static func is_free(point: Vector2, radius: float) -> bool:
	if not bounds().grow(-radius).has_point(point):
		return false
	for wall: Rect2 in _walls:
		if wall.grow(radius).has_point(point):
			return false
	return true
