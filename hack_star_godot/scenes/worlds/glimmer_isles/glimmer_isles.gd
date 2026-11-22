class_name GlimmerIsles
extends Node3D
## Glimmer Isles (spec 09, W1, W3, D13): floating islands with glowing crystals and giant
## mushrooms, built at `_ready` from the active `ArenaLayout` (`GlimmerIslesLayout`): the
## ground and its collision (into `floor_body`), one `StaticBody3D` per wall (into `walls`) and
## the glow-fern patches. Collisions and hiding come from the layout, as in the canyon; the
## same wall heights as `Canyon`, so the camera frames both the same way.

const WALL_HEIGHT: float = Canyon.WALL_HEIGHT
const CAMERA_SIDE_WALL_HEIGHT: float = Canyon.CAMERA_SIDE_WALL_HEIGHT
const CRYSTAL_HEIGHT: float = Canyon.ROCK_HEIGHT
const FLOOR_THICKNESS: float = Canyon.FLOOR_THICKNESS
const OUTSIDE_SIZE: float = 90.0

const GROUND: Color = Color("8fb8b4")
const OUTSIDE: Color = Color("2c2456")
const BORDER: Color = Color("6c5bb0")
const BORDER_TOP: Color = Color("4a3d8a")
const CRYSTAL: Color = Color("6fe3ff")
const CRYSTAL_GLOW: Color = Color("3fb8ff")
const FERN_GROUND: Color = Color("4f8a6e")
const SKY: Color = Color("3a2f78")
const AMBIENT: Color = Color("b8a8ff")

@export var floor_body: StaticBody3D
@export var walls: Node3D


func _ready() -> void:
	_build_sky()
	_build_floor()
	_build_walls()
	_build_cover()


## Height of a wall of `ArenaLayout.walls()` (by index), as in the canyon.
static func wall_height(index: int) -> float:
	if index >= ArenaLayout.border_count():
		return CRYSTAL_HEIGHT
	if ArenaLayout.walls()[index].end.y >= ArenaLayout.SIZE.y / 2.0:
		return CAMERA_SIDE_WALL_HEIGHT
	return WALL_HEIGHT


func _build_sky() -> void:
	var holder: WorldEnvironment = get_parent().get_node_or_null("WorldEnvironment")
	if holder == null or holder.environment == null:
		return
	var environment: Environment = holder.environment.duplicate()
	environment.background_color = SKY
	environment.ambient_light_color = AMBIENT
	holder.environment = environment


func _build_floor() -> void:
	var size: Vector2 = ArenaLayout.SIZE
	floor_body.position = Vector3(0.0, -FLOOR_THICKNESS / 2.0, 0.0)
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = "Collision"
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(size.x, FLOOR_THICKNESS, size.y)
	shape.shape = box
	floor_body.add_child(shape)
	_mesh(floor_body, "Mesh", _box(box.size), GROUND, Vector3.ZERO, false)
	var outside: PlaneMesh = PlaneMesh.new()
	outside.size = Vector2(OUTSIDE_SIZE, OUTSIDE_SIZE)
	_mesh(self, "Outside", outside, OUTSIDE, Vector3(0.0, -3.0, 0.0), false)


func _build_walls() -> void:
	var layout: Array[Rect2] = ArenaLayout.walls()
	for index: int in layout.size():
		var rect: Rect2 = layout[index]
		var height: float = wall_height(index)
		var body: StaticBody3D = StaticBody3D.new()
		var border: bool = index < ArenaLayout.border_count()
		body.name = "Border%d" % index if border else "Crystal%d" % index
		var center: Vector2 = rect.get_center()
		body.position = Vector3(center.x, height / 2.0, center.y)
		var shape: CollisionShape3D = CollisionShape3D.new()
		shape.name = "Collision"
		var box: BoxShape3D = BoxShape3D.new()
		box.size = Vector3(rect.size.x, height, rect.size.y)
		shape.shape = box
		body.add_child(shape)
		if border:
			_mesh(body, "Mesh", _box(box.size), BORDER, Vector3.ZERO)
			var cap: Vector3 = Vector3(rect.size.x + 0.14, 0.2, rect.size.y + 0.14)
			_mesh(body, "Top", _box(cap), BORDER_TOP, Vector3(0.0, height / 2.0, 0.0))
		else:
			var crystal: MeshInstance3D = _mesh(body, "Mesh", _box(box.size), CRYSTAL, Vector3.ZERO)
			crystal.material_override = ToonMaterials.toon(CRYSTAL, CRYSTAL_GLOW, 0.6)
		walls.add_child(body)


func _build_cover() -> void:
	for bush: Rect2 in ArenaLayout.bushes():
		var patch: PlaneMesh = PlaneMesh.new()
		patch.size = bush.size + Vector2(0.4, 0.4)
		var at: Vector2 = bush.get_center()
		var ground: MeshInstance3D = _mesh(
			self, "FernGround", patch, FERN_GROUND, Vector3(at.x, 0.02, at.y), false
		)
		ground.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _mesh(
	parent: Node, node_name: String, mesh: Mesh, color: Color, at: Vector3, outlined: bool = true
) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.material_override = ToonMaterials.toon(color, Color.BLACK, 0.0, outlined)
	instance.position = at
	parent.add_child(instance, true)
	return instance


static func _box(size: Vector3) -> BoxMesh:
	var box: BoxMesh = BoxMesh.new()
	box.size = size
	return box
