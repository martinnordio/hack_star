class_name CameraViews
extends RefCounted
## The camera views of Training and a match (spec 09, V1, D25), in the order `V` goes through
## them. `yaw_degrees` is the camera's turn around the vertical axis (0: it looks north, −z; 90:
## west), as Godot's `rotation.y`. The keys, the joystick and the aim give a direction on the
## screen that `to_world` turns by the camera's yaw, and the animated fighters get their direction
## back on the screen through `to_screen`, so the controls and the facing stay right in a view that
## turns the camera (X3, X4, D50). The `Arena` places the camera from these numbers.

const CLASSIC: String = "classic"
const CLOSE: String = "close"
const BEHIND: String = "behind"
const OVERVIEW: String = "overview"
const LOW: String = "low"
const SIDE: String = "side"
const DIAGONAL: String = "diagonal"
const CINEMATIC: String = "cinematic"
## `pitch_degrees`: how far the camera looks down. Classic fits its distance to the box around
## the fighter (G11); Close is `distance_share` of that, at least `min_distance` metres; Behind
## stands `distance` metres behind the fighter and looks at a point `look_ahead` metres ahead of
## it; Overview fits its distance to the whole arena. The views of X1 (D51): Low stands `height`
## metres high and `distance` behind the fighter and looks at a point `look_height` high and
## `look_ahead` ahead (its pitch is that line's); Side stands `distance` metres from the fighter,
## turned by its yaw; Diagonal is turned by its yaw and fits its distance as Classic; Cinematic
## stands `distance` metres from the fighter, its yaw swinging `swing_degrees` to and fro around
## north every `swing_seconds`.
const LIST: Array[Dictionary] = [
	{"id": CLASSIC, "name": "Classic", "pitch_degrees": 55.0, "yaw_degrees": 0.0},
	{
		"id": CLOSE,
		"name": "Close",
		"pitch_degrees": 55.0,
		"yaw_degrees": 0.0,
		"distance_share": 0.6,
		"min_distance": 6.0,
	},
	{
		"id": BEHIND,
		"name": "Behind",
		"pitch_degrees": 28.0,
		"yaw_degrees": 0.0,
		"distance": 6.0,
		"look_ahead": 4.0,
	},
	{"id": OVERVIEW, "name": "Overview", "pitch_degrees": 78.0, "yaw_degrees": 0.0},
	{
		"id": LOW,
		"name": "Low",
		"pitch_degrees": 5.0,
		"yaw_degrees": 0.0,
		"height": 2.2,
		"distance": 6.5,
		"look_height": 1.0,
		"look_ahead": 8.0,
	},
	{"id": SIDE, "name": "Side", "pitch_degrees": 40.0, "yaw_degrees": 90.0, "distance": 11.0},
	{"id": DIAGONAL, "name": "Diagonal", "pitch_degrees": 58.0, "yaw_degrees": 45.0},
	{
		"id": CINEMATIC,
		"name": "Cinematic",
		"pitch_degrees": 35.0,
		"yaw_degrees": 0.0,
		"distance": 9.0,
		"swing_degrees": 25.0,
		"swing_seconds": 14.0,
	},
]


## The ids of every view, in the order of `LIST` (the keys 1–8 choose them in this order).
static func ids() -> Array[String]:
	var result: Array[String] = []
	for view: Dictionary in LIST:
		result.append(view["id"])
	return result


## The view with this id, or Classic for an unknown id.
static func get_view(view_id: String) -> Dictionary:
	for view: Dictionary in LIST:
		if view["id"] == view_id:
			return view
	return LIST[0]


## The view after this one (`V`), back to the first after the last.
static func next(view_id: String) -> String:
	var all: Array[String] = ids()
	return all[(all.find(view_id) + 1) % all.size()]


## The view's name as the player sees it.
static func view_name(view_id: String) -> String:
	return get_view(view_id)["name"]


## The yaw of the view (degrees) `seconds` after the game started: its `yaw_degrees`, swinging by
## `swing_degrees` to and fro (a sine) every `swing_seconds` in Cinematic.
static func view_yaw_degrees(view_id: String, seconds: float) -> float:
	var view: Dictionary = get_view(view_id)
	var yaw: float = view["yaw_degrees"]
	if view.has("swing_degrees"):
		yaw += float(view["swing_degrees"]) * sin(TAU * seconds / float(view["swing_seconds"]))
	return yaw


## The yaw of a camera at `camera` (radians, as `rotation.y`: 0 looking north), read from its right
## axis, which stays level however far the camera looks down.
static func yaw_of(camera: Transform3D) -> float:
	var right: Vector3 = camera.basis.x
	if Vector2(right.x, right.z).is_zero_approx():
		return 0.0
	return atan2(-right.z, right.x)


## A direction on the screen (x right, y down) as a direction on the ground (x, z) for a camera
## turned by `yaw` (radians): up the screen is away from the camera.
static func to_world(screen_direction: Vector2, yaw: float) -> Vector2:
	return screen_direction.rotated(-yaw)


## A direction on the ground (x, z) as a direction on the screen (x right, y down) for a camera
## turned by `yaw` (radians); the inverse of `to_world`.
static func to_screen(world_direction: Vector2, yaw: float) -> Vector2:
	return world_direction.rotated(yaw)
