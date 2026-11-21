class_name ArenaEffects
extends Node3D
## Small one-shot particle effects of the arena: dust under running feet, a flash at the
## muzzle and sparks where a shot ends. A few `CPUParticles3D` per kind are built once and
## reused in turn (`play`), so nothing is created while playing.

const DUST: String = "dust"
const FLASH: String = "flash"
const SPARKS: String = "sparks"
const KNOCKOUT: String = "knockout"
## How many particle nodes each kind owns.
const POOL_SIZES: Dictionary = {DUST: 4, FLASH: 3, SPARKS: 4, KNOCKOUT: 3}

## Shared by all effects: one unshaded material that takes its colour from the particle.
static var _material: StandardMaterial3D
static var _meshes: Dictionary = {}

var _pools: Dictionary = {}
var _next: Dictionary = {}


func _ready() -> void:
	for kind: String in POOL_SIZES:
		var pool: Array[CPUParticles3D] = []
		for index: int in POOL_SIZES[kind]:
			var particles: CPUParticles3D = _make(kind)
			particles.name = "%s%d" % [kind.capitalize(), index]
			add_child(particles)
			pool.append(particles)
		_pools[kind] = pool
		_next[kind] = 0


## All particle nodes of a kind, in the order they are reused.
func pool(kind: String) -> Array[CPUParticles3D]:
	var nodes: Array[CPUParticles3D] = []
	nodes.assign(_pools.get(kind, []))
	return nodes


## Restarts the next particle node of the kind at `at` (world position) in `color`.
func play(kind: String, at: Vector3, color: Color) -> void:
	if not _pools.has(kind):
		return
	var nodes: Array = _pools[kind]
	var particles: CPUParticles3D = nodes[_next[kind]]
	_next[kind] = (_next[kind] + 1) % nodes.size()
	particles.global_position = at
	particles.color = color
	particles.restart()
	particles.emitting = true


func _make(kind: String) -> CPUParticles3D:
	var particles: CPUParticles3D = CPUParticles3D.new()
	particles.emitting = false
	particles.one_shot = true
	particles.local_coords = false
	particles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	particles.material_override = _shared_material()
	particles.direction = Vector3.UP
	var fade: Curve = Curve.new()
	fade.add_point(Vector2(0.0, 1.0))
	fade.add_point(Vector2(1.0, 0.0))
	particles.scale_amount_curve = fade
	match kind:
		DUST:
			particles.amount = 7
			particles.lifetime = 0.5
			particles.explosiveness = 1.0
			particles.spread = 70.0
			particles.gravity = Vector3(0.0, 0.8, 0.0)
			particles.initial_velocity_min = 0.4
			particles.initial_velocity_max = 1.0
			particles.scale_amount_min = 1.0
			particles.scale_amount_max = 1.6
			particles.mesh = _sphere(DUST, 0.14)
		FLASH:
			particles.amount = 6
			particles.lifetime = 0.14
			particles.explosiveness = 1.0
			particles.spread = 180.0
			particles.gravity = Vector3.ZERO
			particles.initial_velocity_min = 1.5
			particles.initial_velocity_max = 3.0
			particles.scale_amount_min = 1.0
			particles.scale_amount_max = 2.0
			particles.mesh = _sphere(FLASH, 0.16)
		KNOCKOUT:
			particles.amount = 18
			particles.lifetime = 0.7
			particles.explosiveness = 1.0
			particles.spread = 180.0
			particles.gravity = Vector3(0.0, 1.5, 0.0)
			particles.initial_velocity_min = 1.5
			particles.initial_velocity_max = 4.5
			particles.scale_amount_min = 1.2
			particles.scale_amount_max = 2.4
			particles.mesh = _sphere(KNOCKOUT, 0.22)
		_:
			particles.amount = 12
			particles.lifetime = 0.4
			particles.explosiveness = 1.0
			particles.spread = 180.0
			particles.gravity = Vector3(0.0, -9.0, 0.0)
			particles.initial_velocity_min = 2.0
			particles.initial_velocity_max = 5.0
			particles.scale_amount_min = 0.8
			particles.scale_amount_max = 1.4
			particles.mesh = _sphere(SPARKS, 0.1)
	return particles


static func _sphere(kind: String, radius: float) -> SphereMesh:
	if not _meshes.has(kind):
		var sphere: SphereMesh = SphereMesh.new()
		sphere.radius = radius
		sphere.height = radius * 2.0
		sphere.radial_segments = 6
		sphere.rings = 3
		_meshes[kind] = sphere
	return _meshes[kind]


static func _shared_material() -> StandardMaterial3D:
	if _material == null:
		_material = StandardMaterial3D.new()
		_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_material.vertex_color_use_as_albedo = true
		_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return _material
