class_name WorldLighting
extends Node
## Applies a lighting preset (`LightPresets`, spec 09 L3–L6, D27) to the arena: the sun's colour,
## energy and height, the ambient light, the sky and the colour balance (brightness, contrast,
## saturation, with `K`'s boost), and glow where the preset has it. It keeps the world's own
## light as it was built (`setup`), so **Classic** brings it back and every other preset keeps
## `LightPresets.WORLD_SHARE` of the world's colours: the canyon stays warm, Glimmer Isles violet.

## Glow of the presets that have it: only the brightest parts (shots, crystals, flashes) bloom.
const GLOW_INTENSITY: float = 1.2
const GLOW_STRENGTH: float = 1.0
const GLOW_BLOOM: float = 0.0
const GLOW_HDR_THRESHOLD: float = 0.5
## What a world may change on the arena's sun (`remember`, `restore`).
const SUN_PROPERTIES: Array[String] = ["light_color", "light_energy", "rotation", "shadow_opacity"]

var _holder: WorldEnvironment
var _sun: DirectionalLight3D
var _base: Environment
var _sun_color: Color
var _sun_energy: float
var _sun_rotation: Vector3
# The world's own sky colours: top, horizon, ground below and ground at the horizon.
var _sky: Array[Color] = []
var _preset: String = LightPresets.CLASSIC
var _boost: bool = false


## Remembers the world's own light (the environment and the sun as the world built them).
func setup(holder: WorldEnvironment, sun: DirectionalLight3D) -> void:
	_holder = holder
	_sun = sun
	_base = holder.environment.duplicate()
	_sun_color = sun.light_color
	_sun_energy = sun.light_energy
	_sun_rotation = sun.rotation
	var gradient: ProceduralSkyMaterial = null
	if _base.background_mode == Environment.BG_SKY and _base.sky != null:
		gradient = _base.sky.sky_material as ProceduralSkyMaterial
	if gradient != null:
		_sky = [
			gradient.sky_top_color,
			gradient.sky_horizon_color,
			gradient.ground_bottom_color,
			gradient.ground_horizon_color,
		]
	else:
		var color: Color = _base.background_color
		_sky = [color, color, color, color]


## Lights the arena with the preset `preset_id`, with or without the saturation boost.
func apply(preset_id: String, boost: bool) -> void:
	_preset = LightPresets.get_preset(preset_id)["id"]
	_boost = boost
	var preset: Dictionary = LightPresets.get_preset(_preset)
	var environment: Environment = _base.duplicate()
	if LightPresets.is_world_own(_preset):
		_sun.light_color = _sun_color
		_sun.light_energy = _sun_energy
		_sun.rotation = _sun_rotation
	else:
		_sun.light_color = _tint(preset["sun_color"], _sun_color)
		_sun.light_energy = preset["sun_energy"]
		_sun.rotation = Vector3(
			-deg_to_rad(preset["sun_pitch_degrees"]), _sun_rotation.y, _sun_rotation.z
		)
		environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		environment.ambient_light_color = _tint(preset["ambient_color"], _base.ambient_light_color)
		environment.ambient_light_energy = preset["ambient_energy"]
		environment.background_mode = Environment.BG_SKY
		environment.sky = _preset_sky(preset)
	var balance: Vector3 = Vector3(
		preset["brightness"], preset["contrast"], LightPresets.saturation(_preset, boost)
	)
	var world_own: bool = LightPresets.is_world_own(_preset)
	if world_own and _base.adjustment_enabled:
		# A world with its own colour balance (the pack's) keeps it in Classic; `K` on top.
		balance = Vector3(
			_base.adjustment_brightness,
			_base.adjustment_contrast,
			_base.adjustment_saturation * LightPresets.saturation(_preset, boost)
		)
	environment.adjustment_enabled = not balance.is_equal_approx(Vector3.ONE)
	environment.adjustment_brightness = balance.x
	environment.adjustment_contrast = balance.y
	environment.adjustment_saturation = balance.z
	if world_own:
		# Classic shows the world's own environment as it was built: its glow, fog and tone map.
		_holder.environment = environment
		return
	environment.fog_enabled = false
	environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	environment.tonemap_white = 1.0
	environment.glow_enabled = preset["glow"]
	environment.glow_intensity = GLOW_INTENSITY
	environment.glow_strength = GLOW_STRENGTH
	environment.glow_bloom = GLOW_BLOOM
	environment.glow_hdr_threshold = GLOW_HDR_THRESHOLD
	_holder.environment = environment


## The preset in use.
func preset() -> String:
	return _preset


## The arena's environment and sun as a world finds them before it lights them, so a switch of
## the colour variation can start again from them (`restore`).
static func remember(holder: WorldEnvironment, sun: DirectionalLight3D) -> Dictionary:
	var saved: Dictionary = {}
	if holder != null:
		saved["environment"] = holder.environment
	if sun != null:
		for property: String in SUN_PROPERTIES:
			saved[property] = sun.get(property)
	return saved


## Puts back what `remember` saved.
static func restore(holder: WorldEnvironment, sun: DirectionalLight3D, saved: Dictionary) -> void:
	if holder != null and saved.has("environment"):
		holder.environment = saved["environment"]
	if sun != null:
		for property: String in SUN_PROPERTIES:
			if saved.has(property):
				sun.set(property, saved[property])


## Whether the saturation boost is on.
func boost() -> bool:
	return _boost


# The preset's sky gradient with the world's share of its own colours; no sun disc.
func _preset_sky(preset: Dictionary) -> Sky:
	var gradient: ProceduralSkyMaterial = ProceduralSkyMaterial.new()
	gradient.sky_top_color = _tint(preset["sky_top"], _sky[0])
	gradient.sky_horizon_color = _tint(preset["sky_horizon"], _sky[1])
	gradient.ground_bottom_color = _tint(preset["sky_ground"], _sky[2])
	gradient.ground_horizon_color = _tint(preset["sky_horizon"], _sky[3])
	gradient.sun_angle_max = 0.0
	var sky: Sky = Sky.new()
	sky.sky_material = gradient
	return sky


static func _tint(preset_color: Color, world_color: Color) -> Color:
	return preset_color.lerp(world_color, LightPresets.WORLD_SHARE)
