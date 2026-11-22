class_name CutoutFighters
extends RefCounted
## The picture fighters (spec 09, parts C and M, D21, D36): fighters shown as the author's
## pictures instead of shapes, animated with the delivered frames. One row per fighter: its card
## picture (`card`, shown on its fighter card and skin button as it is, preloaded), the paths of
## its full-body picture (`hero`), of its delivered `SpriteFrames` (`frames`: `idle_`, `walk_`,
## `shoot_` × `down` (front), `up` (back), `side` (looking right)) and of its shot's picture
## (`projectile`) — loaded on first use and kept, so only the fighters in use are in memory —,
## the figure's height in metres (`figure_height`, the idle frames' figure), the feet point of the
## frames (`feet`, UV, bottom centre) and the figure's top in the idle frames (`top`, UV y), its
## main colour, and per view where its shot leaves the shoot frame (`muzzle`, UV: the fist, the
## blaster, the fireball). All frames of a fighter have one size.
## `FighterModel.setup` asks here after
## `DrawnFighters` and builds one outlined, camera-facing quad (`cutout.gdshader`) into the
## model's body, so the idle, run and recoil code moves it like the other fighters, plus a soft
## round shadow. Adding one = its folder in `characters/`, its row here, its entry in
## `Fighters.LIST` and its `SampleProgress` numbers.

const SHADER: Shader = preload("res://scenes/toon/cutout.gdshader")
## The views of the frames: the front, the back and the side (looking right; mirrored for left).
const VIEWS: Array[String] = ["down", "up", "side"]
const FIGHTERS: Dictionary[String, Dictionary] = {
	"flarekid":
	{
		"card": preload("res://characters/blaze2/blaze_card.png"),
		"hero": "res://characters/blaze2/blaze_hero.png",
		"frames": "res://characters/blaze2/gameplay/blaze_frames.tres",
		"projectile": "res://characters/blaze2/gameplay/blaze_projectile.png",
		"figure_height": 2.7,
		"feet": Vector2(0.5, 0.993),
		"top": 0.03,
		"main": Color("ff7a1a"),
		"muzzle":
		{"down": Vector2(0.66, 0.48), "up": Vector2(0.7, 0.32), "side": Vector2(0.9, 0.56)},
	},
	"echo":
	{
		"card": preload("res://characters/echo/echo_card.png"),
		"hero": "res://characters/echo/echo_hero.png",
		"frames": "res://characters/echo/gameplay/echo_frames.tres",
		"projectile": "res://characters/echo/gameplay/echo_projectile.png",
		"figure_height": 2.5,
		"feet": Vector2(0.5, 0.993),
		"top": 0.038,
		"main": Color("2ee6e6"),
		"muzzle":
		{"down": Vector2(0.29, 0.53), "up": Vector2(0.65, 0.44), "side": Vector2(0.77, 0.54)},
	},
	"magmax":
	{
		"card": preload("res://characters/magmax2/magmax_card.png"),
		"hero": "res://characters/magmax2/magmax_hero.png",
		"frames": "res://characters/magmax2/gameplay/magmax_frames.tres",
		"projectile": "res://characters/magmax2/gameplay/magmax_projectile.png",
		"figure_height": 2.5,
		"feet": Vector2(0.5, 0.993),
		"top": 0.035,
		"main": Color("ff4500"),
		"muzzle":
		{"down": Vector2(0.3, 0.5), "up": Vector2(0.67, 0.43), "side": Vector2(0.75, 0.46)},
	},
}
## The quad is this much larger than the picture on each side (picture UV), room for the outline.
const PAD: float = 0.05
## The soft shadow on the ground: width and depth in metres, darkness in its middle.
const SHADOW_SIZE: Vector2 = Vector2(1.7, 1.1)
const SHADOW_ALPHA: float = 0.4
## Above the floor, so the flat shadow does not flicker with it from the arena camera.
const SHADOW_LIFT: float = 0.03
const QUAD_NAME: String = "Cutout"
## How much of the camera's foreshortening the picture takes (the shader's `foreshorten`).
const FORESHORTEN: float = 0.4

static var _shadow_material: StandardMaterial3D
# What was loaded on first use, per fighter id and kind ("frames", "hero", "projectile").
static var _loaded: Dictionary[String, Resource] = {}


static func has(fighter_id: String) -> bool:
	return FIGHTERS.has(fighter_id)


## The looks of a picture fighter per skin id (only the Default), like `FighterModel.LOOKS`.
static func looks(fighter_id: String) -> Dictionary:
	return {Fighters.DEFAULT_SKIN: {"main": FIGHTERS[fighter_id]["main"]}}


## The card picture, shown as it is on the fighter card and the skin button.
static func card(fighter_id: String) -> Texture2D:
	return FIGHTERS[fighter_id]["card"]


## The delivered `SpriteFrames`, loaded on first use.
static func sprite_frames(fighter_id: String) -> SpriteFrames:
	return _load(fighter_id, "frames")


## Frame `index` of `animation` (`idle_down`, `walk_side`, `shoot_up`, …).
static func frame(fighter_id: String, animation: String, index: int = 0) -> Texture2D:
	return sprite_frames(fighter_id).get_frame_texture(animation, index)


## The full-body picture, loaded on first use.
static func hero(fighter_id: String) -> Texture2D:
	return _load(fighter_id, "hero")


## The picture of the fighter's shot, loaded on first use.
static func projectile(fighter_id: String) -> Texture2D:
	return _load(fighter_id, "projectile")


## True when the kind ("frames", "hero", "projectile") of the fighter is loaded already.
static func is_loaded(fighter_id: String, kind: String) -> bool:
	return _loaded.has("%s/%s" % [fighter_id, kind])


## The frames' size in metres (the picture without the outline's room): the figure of the idle
## frames is `figure_height` tall.
static func picture_size(fighter_id: String) -> Vector2:
	var row: Dictionary = FIGHTERS[fighter_id]
	var idle: Texture2D = frame(fighter_id, "idle_down")
	var feet: Vector2 = row["feet"]
	var top: float = row["top"]
	var height: float = row["figure_height"] / (feet.y - top)
	return Vector2(height * idle.get_width() / idle.get_height(), height)


## Where the shot leaves the unmirrored shoot frame of `view`, in metres from the feet (x right,
## y up), before the camera's foreshortening.
static func muzzle_offset(fighter_id: String, view: String = "down") -> Vector2:
	var row: Dictionary = FIGHTERS[fighter_id]
	var size: Vector2 = picture_size(fighter_id)
	var feet: Vector2 = row["feet"]
	var muzzle: Vector2 = row["muzzle"][view]
	return Vector2((muzzle.x - feet.x) * size.x, (feet.y - muzzle.y) * size.y)


## The top of the figure seen by a camera at `camera`, as an offset from the feet (world,
## metres): the picture stands parallel to the screen (it turns to the camera) and shrinks by
## part of the foreshortening, so its top lies along the camera's up. A point straight up would
## not do: it comes nearer to a camera that looks down, and below the middle of a steep view
## (Overview) it moves down the screen.
static func top_offset(fighter_id: String, camera: Transform3D) -> Vector3:
	var up: Vector3 = camera.basis.y.normalized()
	var height: float = FIGHTERS[fighter_id]["figure_height"]
	return up * height * lerpf(1.0, clampf(up.y, 0.0, 1.0), FORESHORTEN)


## Builds the picture quad into `model`'s body (the model is already cleared by
## `FighterModel.setup`), showing the front idle frame, and makes its ground shadow soft.
## Returns the quad.
static func build(fighter_id: String, model: FighterModel) -> MeshInstance3D:
	var row: Dictionary = FIGHTERS[fighter_id]
	var size: Vector2 = picture_size(fighter_id)
	var feet: Vector2 = row["feet"]
	var grown: float = 1.0 + 2.0 * PAD
	var quad: QuadMesh = QuadMesh.new()
	quad.size = size * grown
	var feet_on_quad: Vector2 = (feet + Vector2(PAD, PAD)) / grown
	quad.center_offset = Vector3(
		(0.5 - feet_on_quad.x) * quad.size.x, (feet_on_quad.y - 0.5) * quad.size.y, 0.0
	)
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = SHADER
	material.set_shader_parameter("picture", frame(fighter_id, "idle_down"))
	material.set_shader_parameter("outline_color", ToonMaterials.OUTLINE_COLOR)
	material.set_shader_parameter("width_px", ToonMaterials.OUTLINE_PIXELS)
	var grow: float = ToonMaterials.OUTLINE_GROW
	material.set_shader_parameter("grow_uv", Vector2(grow / size.x, grow / size.y))
	material.set_shader_parameter("pad", PAD)
	material.set_shader_parameter("feet_x", feet.x)
	material.set_shader_parameter("width_m", size.x)
	material.set_shader_parameter("foreshorten", FORESHORTEN)
	var piece: MeshInstance3D = model.part(model.get_body(), quad, material, Vector3.ZERO)
	piece.name = QUAD_NAME
	piece.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var shadow: MeshInstance3D = model.get_rig().get_node("Shadow")
	var plane: PlaneMesh = PlaneMesh.new()
	plane.size = SHADOW_SIZE
	shadow.mesh = plane
	shadow.position.y = SHADOW_LIFT
	shadow.material_override = _soft_shadow()
	return piece


# Dark in the middle, fading to nothing at the edge.
static func _soft_shadow() -> StandardMaterial3D:
	if _shadow_material == null:
		var gradient: Gradient = Gradient.new()
		gradient.set_color(0, Color(0.0, 0.0, 0.0, SHADOW_ALPHA))
		gradient.set_color(1, Color(0.0, 0.0, 0.0, 0.0))
		var texture: GradientTexture2D = GradientTexture2D.new()
		texture.gradient = gradient
		texture.fill = GradientTexture2D.FILL_RADIAL
		texture.fill_from = Vector2(0.5, 0.5)
		texture.fill_to = Vector2(1.0, 0.5)
		texture.width = 64
		texture.height = 64
		_shadow_material = StandardMaterial3D.new()
		_shadow_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_shadow_material.albedo_texture = texture
		_shadow_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return _shadow_material


static func _load(fighter_id: String, kind: String) -> Resource:
	var key: String = "%s/%s" % [fighter_id, kind]
	if not _loaded.has(key):
		_loaded[key] = load(FIGHTERS[fighter_id][kind])
	return _loaded[key]
