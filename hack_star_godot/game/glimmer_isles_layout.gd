class_name GlimmerIslesLayout
extends RefCounted
## The layout of Glimmer Isles (spec 09, W1, W4, D9): floating islands with glowing crystals and
## giant mushrooms, as big as the canyon (`ArenaLayout.SIZE`), with the same border, its own
## crystal ridges (walls), glow-fern patches (cover, hiding like the cactus patches), decoration
## spots, dummies and start points. Pure data; `ArenaLayout.use` makes it the active layout.

## Solid blocks: the four border walls (as the canyon's) first, then the crystal ridges.
const WALLS: Array[Rect2] = [
	Rect2(-10.0, -13.0, 20.0, 1.0),
	Rect2(-10.0, 12.0, 20.0, 1.0),
	Rect2(-10.0, -12.0, 1.0, 24.0),
	Rect2(9.0, -12.0, 1.0, 24.0),
	Rect2(-2.0, 4.5, 4.0, 1.5),
	Rect2(-7.0, -1.0, 1.5, 3.5),
	Rect2(5.5, -1.0, 1.5, 3.5),
	Rect2(-4.5, -7.0, 2.5, 1.5),
	Rect2(2.0, -7.0, 2.5, 1.5),
	Rect2(-4.0, 1.0, 1.5, 1.5),
	Rect2(2.5, 1.0, 1.5, 1.5),
]
const BORDER_COUNT: int = 4
## Glow-fern patches: the fighter can walk in, and is partly hidden there.
const BUSHES: Array[Rect2] = [
	Rect2(-8.5, 5.5, 3.0, 3.0),
	Rect2(5.5, 5.5, 3.0, 3.0),
	Rect2(-1.5, -3.0, 3.0, 2.0),
	Rect2(-8.5, -10.5, 2.5, 3.0),
	Rect2(6.0, -10.5, 2.5, 3.0),
]
## Things to look at, without collision: `kind` is crystal, mushroom or stone.
const DECORATION: Array[Dictionary] = [
	{"kind": "mushroom", "at": Vector2(8.0, 11.0)},
	{"kind": "crystal", "at": Vector2(-8.0, 11.0)},
	{"kind": "stone", "at": Vector2(-3.0, 8.0)},
	{"kind": "mushroom", "at": Vector2(3.0, 8.0)},
	{"kind": "stone", "at": Vector2(0.0, 2.0)},
	{"kind": "crystal", "at": Vector2(-8.2, -6.0)},
	{"kind": "mushroom", "at": Vector2(8.2, -6.0)},
	{"kind": "crystal", "at": Vector2(0.0, -6.5)},
	{"kind": "stone", "at": Vector2(-2.0, -11.0)},
	{"kind": "mushroom", "at": Vector2(2.0, -11.0)},
]
const DUMMIES: Array[Vector2] = [Vector2(-4.0, -3.0), Vector2(4.0, -3.0), Vector2(0.0, -9.0)]
## The player's start first (as in the canyon), then one per bot, at least 4 m apart.
const STARTS: Array[Vector2] = [
	Vector2(0.0, 9.5),
	Vector2(0.0, -10.0),
	Vector2(-7.5, -4.0),
	Vector2(7.5, -4.0),
	Vector2(-4.0, -10.0),
	Vector2(4.0, -10.0),
	Vector2(6.5, 10.0),
	Vector2(-4.5, 3.5),
	Vector2(4.5, 3.5),
]
