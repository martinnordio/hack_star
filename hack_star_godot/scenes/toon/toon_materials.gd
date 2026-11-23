@tool
class_name ToonMaterials
extends RefCounted
## The shared cartoon materials (spec 09, D5): one cel-shaded material per colour, glow and
## outline choice, with the one dark outline pass (`outline.gdshader`) as its `next_pass`; and
## their see-through copies for a fighter in a bush. Sharing keeps the draw state small on an
## iPad; fighters, the arena and world props all take their materials from here (`@tool`, so the
## Glimmer Isles props also build in the editor's scatter source scene).

const TOON_SHADER: Shader = preload("res://scenes/toon/toon.gdshader")
const OUTLINE_SHADER: Shader = preload("res://scenes/toon/outline.gdshader")
const OUTLINE_COLOR: Color = Color(0.086, 0.059, 0.2)
## Width of the outline on screen at 720 px height (it grows on taller screens).
const OUTLINE_PIXELS: float = 3.0
## Extra outline in metres, so close-ups (home, cards) get the thick hull of the Svelte game.
const OUTLINE_GROW: float = 0.012
## How opaque a see-through copy is (1 solid, 0 invisible).
const SEE_THROUGH_ALPHA: float = 0.45
## The see-through outline's grow in metres (the shader outline needs an opaque pass).
const SEE_THROUGH_OUTLINE_GROW: float = 0.022
## The share of a pack material's glow energy the toon shader uses: the pack's energies are made
## for the standard shader under its own tone mapping; in full they wash a glowing part to white.
const PACK_GLOW_SHARE: float = 0.25

static var _toons: Dictionary[String, ShaderMaterial] = {}
static var _outline: ShaderMaterial
static var _see_through: Dictionary[Material, Material] = {}


## The cel-shaded material of a colour, with an optional glow and the dark outline.
static func toon(
	color: Color, glow: Color = Color.BLACK, glow_strength: float = 0.0, outlined: bool = true
) -> ShaderMaterial:
	if glow == Color.BLACK:
		glow_strength = 0.0
	var key: String = "%s/%s/%s/%s" % [color.to_html(), glow.to_html(), glow_strength, outlined]
	if not _toons.has(key):
		var material: ShaderMaterial = ShaderMaterial.new()
		material.shader = TOON_SHADER
		material.set_shader_parameter("albedo", color)
		material.set_shader_parameter("emission", glow)
		material.set_shader_parameter("emission_energy", glow_strength)
		if outlined:
			material.next_pass = outline()
		_toons[key] = material
	return _toons[key]


## The cel-shaded material of a pack material (spec 09, P3, D46): its colour and its glow
## (emission, its energy times `PACK_GLOW_SHARE`) in the toon look with the outline; roughness,
## metallic and rim are left to the toon shader's own bands and rim, and the toon shader draws it
## opaque. Shared like `toon`.
static func from_material(material: BaseMaterial3D, outlined: bool = true) -> ShaderMaterial:
	if material.emission_enabled:
		var energy: float = material.emission_energy_multiplier * PACK_GLOW_SHARE
		return toon(material.albedo_color, material.emission, energy, outlined)
	return toon(material.albedo_color, Color.BLACK, 0.0, outlined)


## The cel-shaded material of MultiMesh props, coloured per instance (`set_instance_color`).
static func instanced(outlined: bool = true) -> ShaderMaterial:
	var key: String = "instanced/%s" % outlined
	if not _toons.has(key):
		var material: ShaderMaterial = toon(Color.WHITE, Color.BLACK, 0.0, outlined).duplicate()
		material.set_shader_parameter("use_instance_color", true)
		_toons[key] = material
	return _toons[key]


## The one dark outline pass shared by every outlined material.
static func outline() -> ShaderMaterial:
	if _outline == null:
		_outline = ShaderMaterial.new()
		_outline.shader = OUTLINE_SHADER
		_outline.set_shader_parameter("outline_color", OUTLINE_COLOR)
		_outline.set_shader_parameter("width_px", OUTLINE_PIXELS)
		_outline.set_shader_parameter("grow", OUTLINE_GROW)
	return _outline


## True for a material made by `toon` (cel shading).
static func is_toon(material: Material) -> bool:
	return material is ShaderMaterial and (material as ShaderMaterial).shader == TOON_SHADER


## A see-through copy of a material for a fighter in a bush. Writing ALPHA in the toon shader
## would make every part transparent all the time (sorting, cost), so the copy is a plain
## transparent toon `StandardMaterial3D` with a faded outline. Other materials are faded too.
static func see_through(material: Material) -> Material:
	if material == null:
		return null
	if not _see_through.has(material):
		_see_through[material] = _faded(material)
	return _see_through[material]


static func _faded(material: Material) -> Material:
	if is_toon(material):
		var source: ShaderMaterial = material
		var copy: StandardMaterial3D = StandardMaterial3D.new()
		var color: Color = source.get_shader_parameter("albedo")
		copy.albedo_color = Color(color, SEE_THROUGH_ALPHA)
		copy.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
		copy.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
		copy.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var energy: float = source.get_shader_parameter("emission_energy")
		if energy > 0.0:
			copy.emission_enabled = true
			copy.emission = source.get_shader_parameter("emission")
			copy.emission_energy_multiplier = energy
		if source.next_pass != null:
			copy.next_pass = see_through(source.next_pass)
		return copy
	if material == _outline:
		var faded_outline: StandardMaterial3D = StandardMaterial3D.new()
		faded_outline.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		faded_outline.albedo_color = Color(OUTLINE_COLOR, SEE_THROUGH_ALPHA)
		faded_outline.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		faded_outline.cull_mode = BaseMaterial3D.CULL_FRONT
		faded_outline.grow = true
		faded_outline.grow_amount = SEE_THROUGH_OUTLINE_GROW
		return faded_outline
	if material is StandardMaterial3D:
		var plain: StandardMaterial3D = material.duplicate() as StandardMaterial3D
		plain.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		plain.albedo_color.a *= SEE_THROUGH_ALPHA
		return plain
	return material
