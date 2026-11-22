class_name Shot
extends Node3D
## A shot: a glowing ball that flies straight at `Combat.SHOT_SPEED`. Every physics frame it
## casts a ray from where it is to where it will be, so it never misses a thin wall; it stops
## at the first wall, rock or target, or after `Combat.SHOT_RANGE`. A target with `hit` takes
## `Combat.DAMAGE`. Then it emits `ended` and frees itself.

signal ended(end_position: Vector3, hit_something: bool)

## Physics layers the shot stops at: world (1), fighters (2) and targets (3).
const COLLISION_MASK: int = 0b111
const RADIUS: float = 0.22
const CORE_RADIUS: float = 0.12
const HALO_RADIUS: float = 0.36
const TAIL_LENGTH: float = 1.1

## Meshes and materials are shared by all shots (per colour), so firing creates no new ones.
static var _meshes: Dictionary = {}
static var _materials: Dictionary = {}

## Unit direction on the ground plane (y = 0).
var direction: Vector3 = Vector3.FORWARD
var travelled: float = 0.0
var _done: bool = false
## Where the first ray starts: behind the muzzle, so a wall or target the muzzle is already
## inside of is still hit (a ray does not report a shape it starts in).
var _ray_from: Vector3 = Vector3.ZERO
## The body that fired the shot: its rays never hit it.
var _exclude: Array[RID] = []


## Sets where the shot starts, where it flies and its colour; call before adding it to a scene.
## `cast_from` (default `from`) is where the first ray starts, e.g. the fighter's centre.
## The `shooter` is never hit by its own shot.
func launch(
	from: Vector3,
	toward: Vector3,
	color: Color,
	cast_from: Vector3 = Vector3.INF,
	shooter: CollisionObject3D = null
) -> void:
	position = from
	_ray_from = from if cast_from == Vector3.INF else cast_from
	if shooter != null:
		_exclude = [shooter.get_rid()]
	direction = Vector3(toward.x, 0.0, toward.z).normalized()
	_build(color)


func _physics_process(delta: float) -> void:
	if _done:
		return
	var step: float = minf(Combat.SHOT_SPEED * delta, Combat.SHOT_RANGE - travelled)
	var to: Vector3 = global_position + direction * step
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		_ray_from, to, COLLISION_MASK
	)
	query.exclude = _exclude
	var hit: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		global_position = hit["position"]
		var collider: Object = hit["collider"]
		if collider.has_method("hit"):
			collider.call("hit", Combat.DAMAGE)
		_end(true)
		return
	global_position = to
	_ray_from = to
	travelled += step
	if travelled >= Combat.SHOT_RANGE - 0.001:
		_end(false)


func _end(hit_something: bool) -> void:
	_done = true
	ended.emit(global_position, hit_something)
	queue_free()


## A white-hot core in a ball of the fighter's colour, a see-through halo and a tail behind.
func _build(color: Color) -> void:
	var glow: Color = color.lightened(0.1)
	_part("Halo", _sphere(HALO_RADIUS), _material(glow, 0.4))
	_part("Ball", _sphere(RADIUS), _material(glow, 1.0))
	_part("Core", _sphere(CORE_RADIUS), _material(Color(1.0, 1.0, 0.92), 1.0))
	var tail: MeshInstance3D = _part("Tail", _tail(), _material(glow, 0.55))
	# The cone's tip points backwards, away from the flight direction.
	tail.basis = Basis.looking_at(direction) * Basis(Vector3.RIGHT, PI / 2.0)
	tail.position = -direction * TAIL_LENGTH / 2.0


func _part(part_name: String, mesh: Mesh, material: Material) -> MeshInstance3D:
	var part: MeshInstance3D = MeshInstance3D.new()
	part.name = part_name
	part.mesh = mesh
	part.material_override = material
	part.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(part)
	return part


static func _sphere(radius: float) -> SphereMesh:
	var key: String = "sphere %.2f" % radius
	if not _meshes.has(key):
		var sphere: SphereMesh = SphereMesh.new()
		sphere.radius = radius
		sphere.height = radius * 2.0
		sphere.radial_segments = 12
		sphere.rings = 6
		_meshes[key] = sphere
	return _meshes[key]


static func _tail() -> CylinderMesh:
	if not _meshes.has("tail"):
		var cone: CylinderMesh = CylinderMesh.new()
		cone.top_radius = 0.0
		cone.bottom_radius = RADIUS * 0.9
		cone.height = TAIL_LENGTH
		cone.radial_segments = 10
		cone.rings = 1
		_meshes["tail"] = cone
	return _meshes["tail"]


## Unshaded, so it glows in its own colour in sun and shade.
static func _material(color: Color, alpha: float) -> StandardMaterial3D:
	var key: String = "%s %.2f" % [color.to_html(), alpha]
	if not _materials.has(key):
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = Color(color, alpha)
		if alpha < 1.0:
			material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		_materials[key] = material
	return _materials[key]
