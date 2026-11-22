class_name Icons
extends RefCounted
## The game's icons by name (spec 09, D4): white pictures, tinted where they are used (`modulate`,
## `icon_*_color`). Most are Kenney's "Game Icons" (CC0) in `assets/icons/`; the few the pack
## lacks (coin, bolt, clock, world, eye, qr) are drawn here once, as own work.

const FILES: Dictionary[String, Texture2D] = {
	"play": preload("res://assets/icons/right.png"),
	"trophy": preload("res://assets/icons/trophy.png"),
	"fighters": preload("res://assets/icons/multiplayer.png"),
	"info": preload("res://assets/icons/information.png"),
	"hack": preload("res://assets/icons/wrench.png"),
	"back": preload("res://assets/icons/arrowLeft.png"),
	"home": preload("res://assets/icons/home.png"),
	"training": preload("res://assets/icons/target.png"),
	"lock": preload("res://assets/icons/locked.png"),
	"check": preload("res://assets/icons/checkmark.png"),
	"close": preload("res://assets/icons/cross.png"),
}
const DRAWN: Array[String] = ["coin", "bolt", "clock", "world", "eye", "qr"]
const DRAWN_SIZE: int = 64
const SUBSAMPLES: int = 3
const BOLT: PackedVector2Array = [
	Vector2(0.62, 0.02),
	Vector2(0.18, 0.58),
	Vector2(0.46, 0.58),
	Vector2(0.36, 0.98),
	Vector2(0.82, 0.40),
	Vector2(0.54, 0.40),
	Vector2(0.66, 0.02),
]

static var _drawn: Dictionary[String, Texture2D] = {}


## Every icon name `get_icon` knows.
static func names() -> Array[String]:
	var all: Array[String] = []
	all.assign(FILES.keys())
	all.append_array(DRAWN)
	return all


## The icon called `icon_name`, or null for an unknown name.
static func get_icon(icon_name: String) -> Texture2D:
	if FILES.has(icon_name):
		return FILES[icon_name]
	if not DRAWN.has(icon_name):
		return null
	if not _drawn.has(icon_name):
		_drawn[icon_name] = _draw(Callable(Icons, "_inside_" + icon_name))
	return _drawn[icon_name]


# Fills the pixels whose subsamples lie inside the shape (a test on points in 0..1), smoothed.
static func _draw(inside: Callable) -> ImageTexture:
	var image: Image = Image.create_empty(DRAWN_SIZE, DRAWN_SIZE, false, Image.FORMAT_RGBA8)
	var step: float = 1.0 / float(DRAWN_SIZE * SUBSAMPLES)
	var samples: float = float(SUBSAMPLES * SUBSAMPLES)
	for y: int in DRAWN_SIZE:
		for x: int in DRAWN_SIZE:
			var hits: int = 0
			for sy: int in SUBSAMPLES:
				for sx: int in SUBSAMPLES:
					var point: Vector2 = Vector2(
						(x * SUBSAMPLES + sx + 0.5) * step, (y * SUBSAMPLES + sy + 0.5) * step
					)
					if inside.call(point):
						hits += 1
			image.set_pixel(x, y, Color(1, 1, 1, hits / samples))
	return ImageTexture.create_from_image(image)


static func _ring(point: Vector2, outer: float, inner: float) -> bool:
	var distance: float = point.distance_to(Vector2(0.5, 0.5))
	return distance <= outer and distance >= inner


static func _near_segment(point: Vector2, from: Vector2, to: Vector2, width: float) -> bool:
	return Geometry2D.get_closest_point_to_segment(point, from, to).distance_to(point) <= width


static func _inside_coin(point: Vector2) -> bool:
	return _ring(point, 0.48, 0.38) or _ring(point, 0.31, 0.0)


static func _inside_bolt(point: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(point, BOLT)


static func _inside_clock(point: Vector2) -> bool:
	var center: Vector2 = Vector2(0.5, 0.5)
	return (
		_ring(point, 0.48, 0.38)
		or _near_segment(point, center, Vector2(0.5, 0.2), 0.05)
		or _near_segment(point, center, Vector2(0.72, 0.5), 0.05)
	)


static func _inside_world(point: Vector2) -> bool:
	var meridian: float = pow((point.x - 0.5) / 0.2, 2) + pow((point.y - 0.5) / 0.44, 2)
	return (
		_ring(point, 0.48, 0.4)
		or (point.distance_to(Vector2(0.5, 0.5)) < 0.4 and absf(meridian - 1.0) < 0.3)
		or (absf(point.y - 0.5) < 0.04 and absf(point.x - 0.5) < 0.42)
	)


static func _inside_eye(point: Vector2) -> bool:
	var lid: bool = (
		point.distance_to(Vector2(0.5, 1.0)) < 0.75 and point.distance_to(Vector2(0.5, 0.0)) < 0.75
	)
	var iris: float = point.distance_to(Vector2(0.5, 0.5))
	return lid and (iris > 0.22 or iris < 0.12)


# Three finder squares (a ring with a dot) and a few modules, like a QR code.
static func _inside_qr(point: Vector2) -> bool:
	for corner: Vector2 in [Vector2(0.04, 0.04), Vector2(0.6, 0.04), Vector2(0.04, 0.6)]:
		var local: Vector2 = point - corner
		if local.x >= 0.0 and local.y >= 0.0 and local.x <= 0.36 and local.y <= 0.36:
			var ring: bool = local.x < 0.08 or local.y < 0.08 or local.x > 0.28 or local.y > 0.28
			var dot: bool = absf(local.x - 0.18) < 0.07 and absf(local.y - 0.18) < 0.07
			return ring or dot
	var cell: Vector2i = Vector2i(floori(point.x * 8.0), floori(point.y * 8.0))
	return point.x > 0.5 and point.y > 0.5 and (cell.x + cell.y) % 2 == 0
