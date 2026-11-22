class_name CutoutFighters
extends RefCounted
## The picture fighters (spec 09, part C, D21): fighters shown as the author's pictures instead of
## shapes. One row per fighter: its full-body picture (`hero`), its card picture (`card`, shown
## on its fighter card and skin button as it is), its height in metres, the feet point of the
## picture (UV, feet at the bottom), its main colour, which way the picture looks (`faces_left`)
## and where its shot leaves the picture (`muzzle`, UV: the fireball, the blaster's tip).
## `FighterModel.setup` asks here after
## `DrawnFighters` and builds one outlined, camera-facing quad (`cutout.gdshader`) into the
## model's body, so the idle, run and recoil code moves it like the other fighters, plus a soft
## round shadow. Adding one = its folder in `characters/`, its row here, its entry in
## `Fighters.LIST` and its `SampleProgress` numbers.

const SHADER: Shader = preload("res://scenes/toon/cutout.gdshader")
const FIGHTERS: Dictionary[String, Dictionary] = {
	"flarekid":
	{
		"hero": preload("res://characters/blaze2/blaze_hero.png"),
		"card": preload("res://characters/blaze2/blaze_card.png"),
		"height": 2.7,
		"feet": Vector2(0.5, 0.99),
		"main": Color("ff7a1a"),
		"faces_left": false,
		"muzzle": Vector2(0.83, 0.53),
	},
	"echo":
	{
		"hero": preload("res://characters/echo/echo_hero.png"),
		"card": preload("res://characters/echo/echo_card.png"),
		"height": 2.5,
		"feet": Vector2(0.56, 0.97),
		"main": Color("2ee6e6"),
		"faces_left": true,
		"muzzle": Vector2(0.08, 0.82),
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


static func has(fighter_id: String) -> bool:
	return FIGHTERS.has(fighter_id)


## The looks of a picture fighter per skin id (only the Default), like `FighterModel.LOOKS`.
static func looks(fighter_id: String) -> Dictionary:
	return {Fighters.DEFAULT_SKIN: {"main": FIGHTERS[fighter_id]["main"]}}


## The card picture, shown as it is on the fighter card and the skin button.
static func card(fighter_id: String) -> Texture2D:
	return FIGHTERS[fighter_id]["card"]


## True when the picture as delivered looks to the left (it is mirrored to look right).
static func faces_left(fighter_id: String) -> bool:
	return FIGHTERS[fighter_id]["faces_left"]


## Where the shot leaves the unmirrored picture, in metres from the feet (x right, y up), before
## the camera's foreshortening.
static func muzzle_offset(fighter_id: String) -> Vector2:
	var row: Dictionary = FIGHTERS[fighter_id]
	var hero: Texture2D = row["hero"]
	var height: float = row["height"]
	var width: float = height * hero.get_width() / hero.get_height()
	var feet: Vector2 = row["feet"]
	var muzzle: Vector2 = row["muzzle"]
	return Vector2((muzzle.x - feet.x) * width, (feet.y - muzzle.y) * height)


## How high over the feet (metres, straight up) a point shows on screen level with the top of
## the picture, seen by a camera at `camera` from feet at `feet` (world): the picture stands
## parallel to the screen and shrinks by part of the foreshortening; a point straight up also
## comes nearer to a camera that looks down, so near the camera it climbs the screen faster.
static func top_height(fighter_id: String, camera: Transform3D, feet: Vector3) -> float:
	var up_y: float = clampf(camera.basis.y.y, 0.1, 1.0)
	var height: float = FIGHTERS[fighter_id]["height"]
	var picture: float = height * lerpf(1.0, up_y, FORESHORTEN)
	var seen: Vector3 = camera.affine_inverse() * feet
	if seen.z > -0.1:
		return picture / up_y
	# The top's screen slope (up over depth); a point `h` straight up has the same slope when
	# `h` = picture / (up_y + slope · forward_y).
	var slope: float = (seen.y + picture) / -seen.z
	return picture / maxf(up_y + slope * camera.basis.z.y, 0.1)


## Builds the picture quad into `model`'s body (the model is already cleared by
## `FighterModel.setup`) and makes its ground shadow soft. Returns the quad.
static func build(fighter_id: String, model: FighterModel) -> MeshInstance3D:
	var row: Dictionary = FIGHTERS[fighter_id]
	var hero: Texture2D = row["hero"]
	var height: float = row["height"]
	var width: float = height * hero.get_width() / hero.get_height()
	var feet: Vector2 = row["feet"]
	var grown: float = 1.0 + 2.0 * PAD
	var quad: QuadMesh = QuadMesh.new()
	quad.size = Vector2(width, height) * grown
	var feet_on_quad: Vector2 = (feet + Vector2(PAD, PAD)) / grown
	quad.center_offset = Vector3(
		(0.5 - feet_on_quad.x) * quad.size.x, (feet_on_quad.y - 0.5) * quad.size.y, 0.0
	)
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = SHADER
	material.set_shader_parameter("picture", hero)
	material.set_shader_parameter("outline_color", ToonMaterials.OUTLINE_COLOR)
	material.set_shader_parameter("width_px", ToonMaterials.OUTLINE_PIXELS)
	var grow: float = ToonMaterials.OUTLINE_GROW
	material.set_shader_parameter("grow_uv", Vector2(grow / width, grow / height))
	material.set_shader_parameter("pad", PAD)
	material.set_shader_parameter("feet_x", feet.x)
	material.set_shader_parameter("width_m", width)
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
