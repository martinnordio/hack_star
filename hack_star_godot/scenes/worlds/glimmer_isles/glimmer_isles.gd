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
## both the same way. The newer decoration (fireflies, pulsing crystals, waterfalls, turning
## islands; spec 09 L2) is `GlimmerDecor`, a child named `Decor`. Every colour comes from
## `GlimmerLooks` for the colour `variation` (spec 09 P2, D45): the author's palette pack by
## default, with a lagoon under the island; places, colliders and layouts are the same in every
## variation (P6).

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

## The world's lagoon: this far below the floor, this big (only in the variations that have one).
const LAGOON_DEPTH: float = 14.0
const LAGOON_SIZE: float = 160.0

@export var floor_body: StaticBody3D
@export var walls: Node3D

## The colour variation the world is built in (`GlimmerLooks`; spec 09 H1).
var variation: String = GlimmerLooks.DEFAULT

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.seed = LOOK_SEED
	_build_sky()
	_build_floor()
	_build_island()
	_build_walls()
	_build_cover()
	_build_path()
	var baked: Node3D = load_baked(variation)
	add_child(baked)
	var decor: GlimmerDecor = GlimmerDecor.new()
	decor.name = "Decor"
	decor.baked = baked
	decor.variation = variation
	add_child(decor)


## Height of a wall of `ArenaLayout.walls()` (by index), as in the canyon.
static func wall_height(index: int) -> float:
	if index >= ArenaLayout.border_count():
		return CRYSTAL_HEIGHT
	if ArenaLayout.walls()[index].end.y >= ArenaLayout.SIZE.y / 2.0:
		return CAMERA_SIDE_WALL_HEIGHT
	return WALL_HEIGHT


## The baked props (`baked.tscn`) ready to show: every MultiMesh filled from its `transforms`
## and every part on the shared toon material of its role in the colour variation (its `kind` and
## `part_index`, `GlimmerLooks.part_role`); the colours the bake stored are not used.
static func load_baked(look_variation: String = GlimmerLooks.DEFAULT) -> Node3D:
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
		var role: String = GlimmerLooks.part_role(
			instances.get_meta("kind"), instances.get_meta("part_index")
		)
		instances.material_override = GlimmerLooks.material(
			role, look_variation, instances.get_meta("outlined")
		)
	return baked


# A starry-violet gradient below and around the floating island (the camera looks down, so the
# lower half of the sky is what shows), a lavender ambient light and a soft pink-white sun.
func _build_sky() -> void:
	var holder: WorldEnvironment = get_parent().get_node_or_null("WorldEnvironment")
	if holder != null and holder.environment != null:
		var environment: Environment = holder.environment.duplicate()
		var gradient: ProceduralSkyMaterial = ProceduralSkyMaterial.new()
		gradient.sky_top_color = _sky_color("sky_top")
		gradient.sky_horizon_color = _sky_color("sky_horizon")
		gradient.ground_bottom_color = _sky_color("void_deep")
		gradient.ground_horizon_color = _sky_color("void_horizon")
		gradient.sun_angle_max = 0.0
		var sky: Sky = Sky.new()
		sky.sky_material = gradient
		environment.background_mode = Environment.BG_SKY
		environment.sky = sky
		environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		environment.ambient_light_color = _sky_color("ambient")
		holder.environment = environment
	var sun: DirectionalLight3D = get_parent().get_node_or_null("Sun")
	if sun != null:
		sun.light_color = _sky_color("sun")


# The sky's colours stay Original's until the pack's lighting is used (spec 09 Step 40).
static func _sky_color(role: String) -> Color:
	return GlimmerLooks.color(role, GlimmerLooks.ORIGINAL)


func _build_floor() -> void:
	var size: Vector2 = ArenaLayout.SIZE
	floor_body.position = Vector3(0.0, -FLOOR_THICKNESS / 2.0, 0.0)
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = "Collision"
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(size.x, FLOOR_THICKNESS, size.y)
	shape.shape = box
	floor_body.add_child(shape)
	_mesh(floor_body, "Mesh", _box(box.size), "ground", Vector3.ZERO, false)
	var tile: PlaneMesh = PlaneMesh.new()
	tile.size = Vector2.ONE * TILE_SIZE * 0.94
	var transforms: Array[Transform3D] = []
	var colors: Array[Color] = []
	for column: int in int(size.x / TILE_SIZE):
		for row: int in int(size.y / TILE_SIZE):
			var x: float = -size.x / 2.0 + (column + 0.5) * TILE_SIZE
			var z: float = -size.y / 2.0 + (row + 0.5) * TILE_SIZE
			transforms.append(Transform3D(Basis.IDENTITY, Vector3(x, 0.01, z)))
			var role: String = "ground" if (column + row) % 2 == 0 else "ground_alt"
			var shade: Dictionary = GlimmerLooks.look(role, variation)
			# Drawn every time, so the path's random places stay the same in every variation.
			var lift: float = _rng.randf_range(0.0, 0.05)
			colors.append(
				(shade["albedo"] as Color).lightened(lift if shade["jitter"] > 0 else 0.0)
			)
	var tiles: MultiMeshInstance3D = _multimesh(
		"Tiles", tile, ToonMaterials.instanced(false), transforms, colors
	)
	tiles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


# The island around the arena (the rim the giant mushrooms stand on), its rocky underside and,
# where the variation has one, the lagoon far below that the waterfalls pour into.
func _build_island() -> void:
	var rim: MeshInstance3D = _mesh(
		self, "Rim", _box(Vector3(28.0, 0.6, 31.0)), "rim", Vector3(0.0, -0.34, -2.0), false
	)
	rim.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var underside: CylinderMesh = CylinderMesh.new()
	underside.top_radius = 17.0
	underside.bottom_radius = 2.0
	underside.height = 12.0
	underside.radial_segments = 9
	underside.rings = 1
	_mesh(self, "Underside", underside, "underside", Vector3(0.0, -6.64, -2.0))
	if GlimmerLooks.has_role("lagoon", variation):
		_build_lagoon()


# One large plane of flowing water under the island (spec 09 P3, D46): no collider.
func _build_lagoon() -> void:
	var plane: PlaneMesh = PlaneMesh.new()
	plane.size = Vector2.ONE * LAGOON_SIZE
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = GlimmerDecor.WATER_SHADER
	material.set_shader_parameter("water", GlimmerLooks.color("lagoon", variation))
	material.set_shader_parameter("highlight", GlimmerLooks.color("lagoon_light", variation))
	material.set_shader_parameter("flow", Vector2(0.12, 0.05))
	material.set_shader_parameter("bands", Vector2(16.0, 16.0))
	var lagoon: MeshInstance3D = MeshInstance3D.new()
	lagoon.name = "Lagoon"
	lagoon.mesh = plane
	lagoon.material_override = material
	lagoon.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	lagoon.position = Vector3(0.0, -LAGOON_DEPTH, -2.0)
	add_child(lagoon)


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
			_mesh(body, "Mesh", _box(box.size), "border", Vector3.ZERO)
			var cap: Vector3 = Vector3(rect.size.x + 0.14, 0.2, rect.size.y + 0.14)
			_mesh(body, "Top", _box(cap), "border_top", Vector3(0.0, height / 2.0, 0.0))
		else:
			# The crystal clusters of the bake stand on this plinth and fill the wall.
			var plinth: Vector3 = Vector3(rect.size.x, PLINTH_HEIGHT, rect.size.y)
			var at: Vector3 = Vector3(0.0, (PLINTH_HEIGHT - height) / 2.0, 0.0)
			_mesh(body, "Mesh", _box(plinth), "plinth", at)
		walls.add_child(body)


func _build_cover() -> void:
	for bush: Rect2 in ArenaLayout.bushes():
		var patch: PlaneMesh = PlaneMesh.new()
		patch.size = bush.size + Vector2(0.4, 0.4)
		var at: Vector2 = bush.get_center()
		var ground: MeshInstance3D = _mesh(
			self, "FernGround", patch, "fern_ground", Vector3(at.x, 0.02, at.y), false
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
	var material: Material = GlimmerLooks.material("path", variation, false)
	var path: MultiMeshInstance3D = _multimesh("Path", stone, material, transforms, colors)
	path.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _mesh(
	parent: Node, node_name: String, mesh: Mesh, role: String, at: Vector3, outlined: bool = true
) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.material_override = GlimmerLooks.material(role, variation, outlined)
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
