class_name GlimmerIsles
extends Node3D
## Glimmer Isles (spec 09, W1, W3, W5, D12, D13): floating islands with glowing crystals and
## giant mushrooms, an original fantasy place. Built at `_ready` from the active `ArenaLayout`
## (`GlimmerIslesLayout`): the tiled ground with a glowing path and its collision (into
## `floor_body`), one `StaticBody3D` per wall (into `walls`: a violet rock border and low rock
## plinths under the crystal ridges), the fern-patch ground, the island's rim and underside, the
## starry gradient sky, and the props baked from ProtonScatter (`baked.tscn`, see
## `tools/bake_world.gd`): no addon code and no thread while the game runs. Collisions and hiding
## come from the layout, as in the canyon; the same wall heights as `Canyon`, so the camera frames
## both the same way.

const BAKED: PackedScene = preload("res://scenes/worlds/glimmer_isles/baked.tscn")

const WALL_HEIGHT: float = Canyon.WALL_HEIGHT
const CAMERA_SIDE_WALL_HEIGHT: float = Canyon.CAMERA_SIDE_WALL_HEIGHT
const CRYSTAL_HEIGHT: float = Canyon.ROCK_HEIGHT
const FLOOR_THICKNESS: float = Canyon.FLOOR_THICKNESS
## The crystal clusters stand on rock plinths this high (where the scatter puts them).
const PLINTH_HEIGHT: float = 0.25
const TILE_SIZE: float = 2.0
const PATH_STEP: float = 1.1
## The same island every time.
const LOOK_SEED: int = 9

const GROUND: Color = Color("86a3b4")
const GROUND_LAVENDER: Color = Color("9a95c4")
const PATH: Color = Color("bff6ff")
const PATH_GLOW: Color = Color("6fe3ff")
const RIM: Color = Color("5c9a8c")
const UNDERSIDE: Color = Color("5a4aa0")
const BORDER: Color = Color("6c5bb0")
const BORDER_TOP: Color = Color("4a3d8a")
const PLINTH: Color = Color("4a3d8a")
const FERN_GROUND: Color = Color("3f7f6a")
const SKY_TOP: Color = Color("1b1446")
const SKY_HORIZON: Color = Color("c77ad6")
const VOID_DEEP: Color = Color("140f38")
const VOID_HORIZON: Color = Color("6a4fb8")
const AMBIENT: Color = Color("b8a8ff")
const SUN: Color = Color("fff0ff")

@export var floor_body: StaticBody3D
@export var walls: Node3D

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.seed = LOOK_SEED
	_build_sky()
	_build_floor()
	_build_island()
	_build_walls()
	_build_cover()
	_build_path()
	add_child(load_baked())


## Height of a wall of `ArenaLayout.walls()` (by index), as in the canyon.
static func wall_height(index: int) -> float:
	if index >= ArenaLayout.border_count():
		return CRYSTAL_HEIGHT
	if ArenaLayout.walls()[index].end.y >= ArenaLayout.SIZE.y / 2.0:
		return CAMERA_SIDE_WALL_HEIGHT
	return WALL_HEIGHT


## The baked props (`baked.tscn`) ready to show: every MultiMesh filled from its `transforms`
## and every part on the shared toon material of its colours.
static func load_baked() -> Node3D:
	var baked: Node3D = BAKED.instantiate()
	baked.name = "Baked"
	for child: Node in baked.get_children():
		var instances: MultiMeshInstance3D = child
		var transforms: Array = instances.get_meta("transforms")
		var multimesh: MultiMesh = instances.multimesh.duplicate()
		multimesh.instance_count = transforms.size()
		for index: int in transforms.size():
			multimesh.set_instance_transform(index, transforms[index])
		instances.multimesh = multimesh
		instances.material_override = ToonMaterials.toon(
			instances.get_meta("albedo"),
			instances.get_meta("glow"),
			instances.get_meta("glow_strength"),
			instances.get_meta("outlined")
		)
	return baked


# A starry-violet gradient below and around the floating island (the camera looks down, so the
# lower half of the sky is what shows), a lavender ambient light and a soft pink-white sun.
func _build_sky() -> void:
	var holder: WorldEnvironment = get_parent().get_node_or_null("WorldEnvironment")
	if holder != null and holder.environment != null:
		var environment: Environment = holder.environment.duplicate()
		var gradient: ProceduralSkyMaterial = ProceduralSkyMaterial.new()
		gradient.sky_top_color = SKY_TOP
		gradient.sky_horizon_color = SKY_HORIZON
		gradient.ground_bottom_color = VOID_DEEP
		gradient.ground_horizon_color = VOID_HORIZON
		gradient.sun_angle_max = 0.0
		var sky: Sky = Sky.new()
		sky.sky_material = gradient
		environment.background_mode = Environment.BG_SKY
		environment.sky = sky
		environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		environment.ambient_light_color = AMBIENT
		holder.environment = environment
	var sun: DirectionalLight3D = get_parent().get_node_or_null("Sun")
	if sun != null:
		sun.light_color = SUN


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
	var tile: PlaneMesh = PlaneMesh.new()
	tile.size = Vector2.ONE * TILE_SIZE * 0.94
	var transforms: Array[Transform3D] = []
	var colors: Array[Color] = []
	for column: int in int(size.x / TILE_SIZE):
		for row: int in int(size.y / TILE_SIZE):
			var x: float = -size.x / 2.0 + (column + 0.5) * TILE_SIZE
			var z: float = -size.y / 2.0 + (row + 0.5) * TILE_SIZE
			transforms.append(Transform3D(Basis.IDENTITY, Vector3(x, 0.01, z)))
			var shade: Color = GROUND if (column + row) % 2 == 0 else GROUND_LAVENDER
			colors.append(shade.lightened(_rng.randf_range(0.0, 0.05)))
	var tiles: MultiMeshInstance3D = _multimesh(
		"Tiles", tile, ToonMaterials.instanced(false), transforms, colors
	)
	tiles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


# The island around the arena (the rim the giant mushrooms stand on) and its rocky underside.
func _build_island() -> void:
	var rim: MeshInstance3D = _mesh(
		self, "Rim", _box(Vector3(28.0, 0.6, 31.0)), RIM, Vector3(0.0, -0.34, -2.0), false
	)
	rim.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var underside: CylinderMesh = CylinderMesh.new()
	underside.top_radius = 17.0
	underside.bottom_radius = 2.0
	underside.height = 12.0
	underside.radial_segments = 9
	underside.rings = 1
	_mesh(self, "Underside", underside, UNDERSIDE, Vector3(0.0, -6.64, -2.0))


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
			# The crystal clusters of the bake stand on this plinth and fill the wall.
			var plinth: Vector3 = Vector3(rect.size.x, PLINTH_HEIGHT, rect.size.y)
			var at: Vector3 = Vector3(0.0, (PLINTH_HEIGHT - height) / 2.0, 0.0)
			_mesh(body, "Mesh", _box(plinth), PLINTH, at)
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


# Glowing stepping stones from the player's start up the middle and across, around the walls.
func _build_path() -> void:
	var stone: CylinderMesh = CylinderMesh.new()
	stone.top_radius = 0.3
	stone.bottom_radius = 0.3
	stone.height = 0.04
	stone.radial_segments = 8
	stone.rings = 1
	var transforms: Array[Transform3D] = []
	var half: Vector2 = ArenaLayout.SIZE / 2.0 - Vector2(1.5, 1.5)
	var lines: Array[Array] = [
		[Vector2(0.0, half.y), Vector2(0.0, -half.y)], [Vector2(-half.x, 0.0), Vector2(half.x, 0.0)]
	]
	for line: Array in lines:
		var from: Vector2 = line[0]
		var to: Vector2 = line[1]
		var steps: int = int(from.distance_to(to) / PATH_STEP)
		for step: int in steps + 1:
			var at: Vector2 = from.lerp(to, float(step) / steps)
			at += Vector2(_rng.randf_range(-0.12, 0.12), _rng.randf_range(-0.12, 0.12))
			if not ArenaLayout.is_free(at, 0.4) or ArenaLayout.in_bush(at):
				continue
			transforms.append(
				Transform3D(Basis(Vector3.UP, _rng.randf() * TAU), Vector3(at.x, 0.03, at.y))
			)
	var colors: Array[Color] = []
	colors.resize(transforms.size())
	colors.fill(Color.WHITE)
	var material: Material = ToonMaterials.toon(PATH, PATH_GLOW, 0.6, false)
	var path: MultiMeshInstance3D = _multimesh("Path", stone, material, transforms, colors)
	path.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


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


func _multimesh(
	node_name: String,
	mesh: Mesh,
	material: Material,
	transforms: Array[Transform3D],
	colors: Array[Color]
) -> MultiMeshInstance3D:
	var multimesh: MultiMesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_colors = true
	multimesh.mesh = mesh
	multimesh.instance_count = transforms.size()
	for index: int in transforms.size():
		multimesh.set_instance_transform(index, transforms[index])
		multimesh.set_instance_color(index, colors[index])
	var instance: MultiMeshInstance3D = MultiMeshInstance3D.new()
	instance.name = node_name
	instance.multimesh = multimesh
	instance.material_override = material
	add_child(instance)
	return instance


static func _box(size: Vector3) -> BoxMesh:
	var box: BoxMesh = BoxMesh.new()
	box.size = size
	return box
