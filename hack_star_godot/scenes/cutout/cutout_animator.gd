class_name CutoutAnimator
extends RefCounted
## Which frame an animated picture fighter shows in play, and its hit flash and knock-out on the
## picture quad's material (spec 09, M3–M5, M7, D37), owned by
## `FighterModel`: the view from the screen direction it moves or shoots in (`view_for`: `side`
## when it goes mostly left or right, mirrored for left; otherwise `up`, its back, when it goes up
## the screen, else `down`, its front), the last view kept while it stands, the front at the start;
## while running the walk loop of that view (walk 1, idle, walk 2, idle) at a pace that fits its
## speed with a small hop on each step; standing the view's idle frame; a shot shows the shoot
## frame of the shot's view for `SHOOT_SECONDS`. The screen direction is the ground's (x right,
## y = +z down the screen): every camera view looks north with a fixed yaw (`CameraViews`), so up
## on the screen is −z in all four views.

const START_VIEW: String = "down"
const SHOOT_SECONDS: float = 0.25
## The walk loop's frames a second at `WALK_SPEED` m/s, scaled with the speed within the limits.
const WALK_FPS: float = 8.0
const WALK_SPEED: float = 5.0
const MIN_FPS: float = 6.0
const MAX_FPS: float = 10.0
const WALK_FRAMES: int = 4
## The hop of each step (metres), highest in the middle of walk 1 and walk 2.
const HOP_HEIGHT: float = 0.05

var fighter_id: String = ""
## The picture quad's material (`cutout.gdshader`): the frame, its mirror, the hit flash and the
## knock-out are set here.
var material: ShaderMaterial
## The view shown: `down` (front), `up` (back) or `side` (looking right, mirrored when `mirrored`).
var view: String = START_VIEW
var mirrored: bool = false
var running: bool = false
## The fighter's speed (m/s), for the walk's pace.
var walk_speed: float = WALK_SPEED
## Seconds left of the shoot pose; 0 when none shows.
var shoot_left: float = 0.0
## Seconds left of the white hit flash.
var flash_left: float = 0.0
var _walk_time: float = 0.0


func _init(new_fighter_id: String, quad_material: ShaderMaterial) -> void:
	fighter_id = new_fighter_id
	material = quad_material


## The view for a direction on the screen (x right, y down); the closer one for a diagonal.
static func view_for(direction: Vector2) -> String:
	if absf(direction.x) > absf(direction.y):
		return "side"
	return "up" if direction.y < 0.0 else "down"


## Turns to `direction` (moving); standing (zero) keeps the last view, and the shoot pose keeps
## the shot's view until it ends.
func face(direction: Vector2) -> void:
	if direction.is_zero_approx() or shoot_left > 0.0:
		return
	view = view_for(direction)
	mirrored = view == "side" and direction.x < 0.0


## The shoot pose of the shot's view, for `SHOOT_SECONDS`.
func play_shoot(direction: Vector2) -> void:
	shoot_left = 0.0
	face(direction)
	shoot_left = SHOOT_SECONDS


func step(delta: float) -> void:
	shoot_left = maxf(shoot_left - delta, 0.0)
	if not running:
		_walk_time = 0.0
	elif shoot_left <= 0.0:
		_walk_time += delta
	if flash_left > 0.0:
		flash_left = maxf(flash_left - delta, 0.0)
		if flash_left <= 0.0:
			material.set_shader_parameter("flash", 0.0)


## Shows the frame of now on the quad, mirrored for the left side.
func apply() -> void:
	material.set_shader_parameter("picture", texture())
	material.set_shader_parameter("flip", mirrored)


## A hit: the picture turns white for `CutoutMotion.FLASH_SECONDS`.
func flash() -> void:
	flash_left = CutoutMotion.FLASH_SECONDS
	material.set_shader_parameter("flash", 1.0)


## The knock-out at `progress` (0 standing, 1 flat and gone): the picture tips over and fades from
## `alpha` (see-through in cover) to nothing.
func knock_out(progress: float, alpha: float) -> void:
	material.set_shader_parameter("tip", progress * CutoutMotion.KNOCK_OUT_TIP)
	material.set_shader_parameter("fade", alpha * (1.0 - progress))


## True while the walk loop plays (running, no shot).
func walking() -> bool:
	return running and shoot_left <= 0.0


## The walk loop's frames a second.
func fps() -> float:
	return clampf(WALK_FPS * walk_speed / WALK_SPEED, MIN_FPS, MAX_FPS)


## The animation of the delivered `SpriteFrames` shown now (`idle_down`, `walk_side`, …).
func animation() -> String:
	if shoot_left > 0.0:
		return "shoot_" + view
	return ("walk_" if walking() else "idle_") + view


func frame_index() -> int:
	if not walking():
		return 0
	return int(_walk_time * fps()) % WALK_FRAMES


func texture() -> Texture2D:
	return CutoutFighters.frame(fighter_id, animation(), frame_index())


## The pose at `time` seconds: walking, the hop of each step and no breathing; otherwise the
## standing pose of `CutoutMotion` (breathing and bob, no sway: the frames lean themselves).
func pose(time: float) -> Dictionary:
	if walking():
		var hop: float = absf(sin((_walk_time * fps() + 0.5) * PI / 2.0))
		return {"lift": hop * HOP_HEIGHT, "scale": Vector3.ONE}
	return CutoutMotion.pose(time)
