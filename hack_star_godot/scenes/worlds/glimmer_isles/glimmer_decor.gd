class_name GlimmerDecor
extends Node3D
## Glimmer Isles' newer decoration (spec 09, L2, D26), built in code at `_ready` over the baked
## props (`baked`): fireflies drifting over the island, the crystals' glow pulsing, waterfalls
## pouring from the floating islands and the islands slowly turning. Nothing here has a collider
## or changes the layout, so walls, cover, start points and collisions stay as they are (W4, W7,
## S2), and the bake keeps its no-thread rule (D12): only the baked islands' transforms move.

## The kinds this node adds (each a child of that name, but the pulse and the turning, which move
## baked props).
const KINDS: Array[String] = ["Fireflies", "CrystalPulse", "Waterfalls", "TurningIslands"]
const WATER_SHADER: Shader = preload("res://scenes/toon/flowing_water.gdshader")

const FIREFLY_COUNT: int = 48
const FIREFLY_LIFETIME: float = 6.0
## The crystals' glow swings by this share of its baked strength, this fast (radians/second).
const PULSE_SHARE: float = 0.6
const PULSE_SPEED: float = 2.2
## The floating islands turn this fast (radians/second) and bob this high (metres).
const ISLAND_TURN_SPEED: float = 0.12
const ISLAND_BOB: float = 0.15
const WATERFALL_LENGTH: float = 7.0
## Every this many-th island has a waterfall, on its side towards the camera.
const WATERFALL_EVERY: int = 2

## The baked props (`GlimmerIsles.load_baked`), set before `_ready`.
var baked: Node3D
## The colour variation of the world (`GlimmerLooks`), set before `_ready`.
var variation: String = GlimmerLooks.DEFAULT

var _time: float = 0.0
var _crystals: Array[MultiMeshInstance3D] = []
# The glow strength of each crystal part's material, which the pulse swings around.
var _crystal_glow: Array[float] = []
var _islands: Array[MultiMeshInstance3D] = []
var _island_centers: Array[Vector3] = []
# Each waterfall and the island it pours from.
var _waterfalls: Array[MeshInstance3D] = []
var _waterfall_islands: Array[int] = []


func _ready() -> void:
	_build_fireflies()
	_find_baked()
	_build_waterfalls()
	_animate()


## Recolours the fireflies and the waterfalls for the colour variation `variation_id` and finds
## the glowing crystals again (their materials were changed with the baked props).
func apply_variation(variation_id: String) -> void:
	variation = variation_id
	var flies: CPUParticles3D = get_node("Fireflies")
	flies.color_ramp = _firefly_fade()
	for fall: MeshInstance3D in _waterfalls:
		_paint_water(fall.material_override)
	_find_crystals()
	_animate()


func _process(delta: float) -> void:
	_time += delta
	_animate()


## The crystal parts whose glow pulses, and the island parts that turn (for tests).
func crystals() -> Array[MultiMeshInstance3D]:
	return _crystals


func islands() -> Array[MultiMeshInstance3D]:
	return _islands


func _build_fireflies() -> void:
	var flies: CPUParticles3D = CPUParticles3D.new()
	flies.name = "Fireflies"
	flies.amount = FIREFLY_COUNT
	flies.lifetime = FIREFLY_LIFETIME
	flies.preprocess = FIREFLY_LIFETIME
	flies.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	var half: Vector2 = ArenaLayout.SIZE / 2.0 + Vector2(2.0, 2.0)
	flies.emission_box_extents = Vector3(half.x, 1.0, half.y)
	flies.position = Vector3(0.0, 1.5, 0.0)
	flies.direction = Vector3.UP
	flies.spread = 180.0
	flies.gravity = Vector3.ZERO
	flies.initial_velocity_min = 0.1
	flies.initial_velocity_max = 0.35
	flies.scale_amount_min = 0.7
	flies.scale_amount_max = 1.4
	flies.color_ramp = _firefly_fade()
	var dot: SphereMesh = SphereMesh.new()
	dot.radius = 0.06
	dot.height = 0.12
	dot.radial_segments = 6
	dot.rings = 3
	var glow: StandardMaterial3D = StandardMaterial3D.new()
	glow.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	glow.vertex_color_use_as_albedo = true
	glow.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dot.material = glow
	flies.mesh = dot
	flies.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(flies)


# The fireflies fade in and out in the variation's firefly colour.
func _firefly_fade() -> Gradient:
	var fade: Gradient = Gradient.new()
	fade.offsets = PackedFloat32Array([0.0, 0.2, 0.8, 1.0])
	var firefly: Color = GlimmerLooks.color("firefly", variation)
	fade.colors = PackedColorArray([Color(firefly, 0.0), firefly, firefly, Color(firefly, 0.0)])
	return fade


# The glowing crystal parts and the parts of the floating islands among the baked props.
func _find_baked() -> void:
	if baked == null:
		return
	_find_crystals()
	for child: Node in baked.get_children():
		var instances: MultiMeshInstance3D = child
		if instances.get_meta("kind") == "island_chunk":
			_islands.append(instances)
			if int(instances.get_meta("part_index")) == 0:
				# The first part stands on the island's own axis (as the bake places it).
				for place: Transform3D in instances.get_meta("transforms"):
					_island_centers.append(place.origin)


# The crystal parts that glow in the variation, each on its own copy of its material: the pulse
# must not change the shared `ToonMaterials` entry.
func _find_crystals() -> void:
	_crystals.clear()
	_crystal_glow.clear()
	if baked == null:
		return
	for child: Node in baked.get_children():
		var instances: MultiMeshInstance3D = child
		var glow: float = (instances.material_override as ShaderMaterial).get_shader_parameter(
			"emission_energy"
		)
		if instances.get_meta("kind") == "crystal_cluster" and glow > 0.0:
			instances.material_override = instances.material_override.duplicate()
			_crystals.append(instances)
			_crystal_glow.append(glow)


func _build_waterfalls() -> void:
	var holder: Node3D = Node3D.new()
	holder.name = "Waterfalls"
	add_child(holder)
	for index: int in range(0, _island_centers.size(), WATERFALL_EVERY):
		var center: Vector3 = _island_centers[index]
		# The island's size: its grass top is 1.5 m wide at scale 1 (`GlimmerProp` island_chunk).
		var size: float = _island_scale(index)
		var sheet: QuadMesh = QuadMesh.new()
		sheet.size = Vector2(0.7 * size, WATERFALL_LENGTH)
		var material: ShaderMaterial = ShaderMaterial.new()
		material.shader = WATER_SHADER
		_paint_water(material)
		material.set_shader_parameter("flow", Vector2(0.0, 1.6))
		material.set_shader_parameter("bands", Vector2(1.5, WATERFALL_LENGTH / 1.2))
		material.set_shader_parameter("foot_fade", 1.0)
		var fall: MeshInstance3D = MeshInstance3D.new()
		fall.name = "Waterfall%d" % index
		fall.mesh = sheet
		fall.material_override = material
		fall.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		# From the rim on the camera's side (south), down past the island's rock.
		var rim: Vector3 = Vector3(0.0, 0.1 * size, 1.45 * size)
		fall.position = center + rim + Vector3(0.0, -WATERFALL_LENGTH / 2.0, 0.0)
		holder.add_child(fall)
		_waterfalls.append(fall)
		_waterfall_islands.append(index)


func _paint_water(material: ShaderMaterial) -> void:
	material.set_shader_parameter("water", GlimmerLooks.color("waterfall", variation))
	material.set_shader_parameter("highlight", GlimmerLooks.color("waterfall_light", variation))


func _island_scale(index: int) -> float:
	for instances: MultiMeshInstance3D in _islands:
		if int(instances.get_meta("part_index")) == 0:
			var place: Transform3D = instances.get_meta("transforms")[index]
			return place.basis.get_scale().x
	return 1.0


# The crystals' glow and the islands' turn and bob at the current time.
func _animate() -> void:
	var pulse: float = 1.0 + PULSE_SHARE * sin(_time * PULSE_SPEED)
	for index: int in _crystals.size():
		var instances: MultiMeshInstance3D = _crystals[index]
		var strength: float = _crystal_glow[index] * pulse
		(instances.material_override as ShaderMaterial).set_shader_parameter(
			"emission_energy", strength
		)
	for instances: MultiMeshInstance3D in _islands:
		var count: int = mini(
			(instances.get_meta("transforms") as Array).size(), _island_centers.size()
		)
		for index: int in count:
			instances.multimesh.set_instance_transform(index, island_place(instances, index))
	for fall_index: int in _waterfalls.size():
		var island: int = _waterfall_islands[fall_index]
		var fall: MeshInstance3D = _waterfalls[fall_index]
		fall.position.y = (
			_island_centers[island].y
			+ 0.1 * _island_scale(island)
			- WATERFALL_LENGTH / 2.0
			+ _bob(island)
		)


## Where the part instances of the island `index` is now: turned around the island's axis and
## lifted by its bob.
func island_place(instances: MultiMeshInstance3D, index: int) -> Transform3D:
	var way: float = 1.0 if index % 2 == 0 else -1.0
	var turn: Basis = Basis(Vector3.UP, way * ISLAND_TURN_SPEED * _time + index)
	var lift: Vector3 = Vector3(0.0, _bob(index), 0.0)
	var center: Vector3 = _island_centers[index]
	var place: Transform3D = instances.get_meta("transforms")[index]
	return Transform3D(turn * place.basis, center + lift + turn * (place.origin - center))


func _bob(index: int) -> float:
	return ISLAND_BOB * sin(_time * 0.6 + index)
