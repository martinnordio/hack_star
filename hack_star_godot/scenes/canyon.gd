class_name Canyon
extends Node3D
## The sunny canyon of the arena, built in code from `ArenaLayout` at `_ready`: the sand floor
## (into `floor_body`), the rock walls (one `StaticBody3D` each, into `walls`), cacti on the
## bush patches and the decoration. Own art from primitive meshes in the outlined cartoon look of
## the fighters (`ToonMaterials`, spec 09 D5/G10): walls, boulders, cacti and props have the dark
## outline, the ground is soft sand without one, less saturated than the fighters. The many small
## pieces (sand tiles, boulders, cacti) are MultiMeshes to keep draw calls low. The newer moving
## decoration (flags, birds, a stream; spec 09 L2) is `CanyonDecor`, a child named `Decor`.

## Wall heights: the border, the border on the camera side (low, never hides the fighter) and
## the rocks inside.
const WALL_HEIGHT: float = 2.2
const CAMERA_SIDE_WALL_HEIGHT: float = 0.7
const ROCK_HEIGHT: float = 1.4
const FLOOR_THICKNESS: float = 0.2
const TILE_SIZE: float = 2.0
const OUTSIDE_SIZE: float = 90.0
const CACTUS_SPACING: float = 0.85
## The same canyon every time; the decoration added in the reopening has its own seed, so the
## older pieces keep their places.
const LOOK_SEED: int = 6
const DECOR_SEED: int = 61

## Brighter and warmer since the reopening (spec 09, L1, D26); the sand stays the least saturated
## surface, so the fighters stand out (G10).
const SAND: Color = Color("d6ad7e")
const SAND_DARK: Color = Color("cb9f6e")
const OUTSIDE: Color = Color("cf7b4c")
const ROCK: Color = Color("e65a2a")
const ROCK_BAND: Color = Color("ff9a4f")
const ROCK_TOP: Color = Color("a83a20")
const BOULDER: Color = Color("bf4f2a")
const BOULDER_LIGHT: Color = Color("ee7c3e")
const BUSH_GROUND: Color = Color("9fc05a")
const CACTUS: Color = Color("3fd35c")
const CACTUS_DARK: Color = Color("1fa848")
const FLOWER: Color = Color("ff4f9e")
## The blossoms on the cactus tops without a flower (L2), in these colours.
const BLOSSOMS: Array[Color] = [Color("ffd23f"), Color("ff8a3d"), Color("ff6fd0")]
const CRATE: Color = Color("d98c35")
const CRATE_EDGE: Color = Color("7a4620")
const BONE: Color = Color("fff6e0")
const EYE: Color = Color("2a1d1d")
const PEBBLE: Color = Color("b98a5e")

@export var floor_body: StaticBody3D
@export var walls: Node3D

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _decor_rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _boulders: Array[Transform3D] = []
var _boulder_colors: Array[Color] = []


func _ready() -> void:
	_rng.seed = LOOK_SEED
	_decor_rng.seed = DECOR_SEED
	_build_floor()
	_build_walls()
	_build_outside_boulders()
	_build_cacti()
	_build_decoration()
	_add_multimesh(
		"Boulders", _low_poly_sphere(0.5), ToonMaterials.instanced(), _boulders, _boulder_colors
	)
	var decor: CanyonDecor = CanyonDecor.new()
	decor.name = "Decor"
	add_child(decor)


## Height of a wall of `ArenaLayout.WALLS` (by index).
static func wall_height(index: int) -> float:
	if index >= ArenaLayout.BORDER_COUNT:
		return ROCK_HEIGHT
	if ArenaLayout.WALLS[index].end.y >= ArenaLayout.SIZE.y / 2.0:
		return CAMERA_SIDE_WALL_HEIGHT
	return WALL_HEIGHT


func _build_floor() -> void:
	var size: Vector2 = ArenaLayout.SIZE
	floor_body.position = Vector3(0.0, -FLOOR_THICKNESS / 2.0, 0.0)
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = "Collision"
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(size.x, FLOOR_THICKNESS, size.y)
	shape.shape = box
	floor_body.add_child(shape)
	_mesh(floor_body, "Mesh", _box(box.size), SAND, Vector3.ZERO, false)
	var outside: PlaneMesh = PlaneMesh.new()
	outside.size = Vector2(OUTSIDE_SIZE, OUTSIDE_SIZE)
	_mesh(self, "Outside", outside, OUTSIDE, Vector3(0.0, -0.15, 0.0), false)
	_build_sand_tiles(size)
	for bush: Rect2 in ArenaLayout.BUSHES:
		var patch: PlaneMesh = PlaneMesh.new()
		patch.size = bush.size + Vector2(0.4, 0.4)
		var at: Vector2 = bush.get_center()
		var ground: MeshInstance3D = _mesh(
			self, "BushGround", patch, BUSH_GROUND, Vector3(at.x, 0.02, at.y), false
		)
		ground.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


## A checkerboard of sand tiles in two shades, each a little different.
func _build_sand_tiles(size: Vector2) -> void:
	var tile: PlaneMesh = PlaneMesh.new()
	tile.size = Vector2.ONE * TILE_SIZE * 0.94
	var transforms: Array[Transform3D] = []
	var colors: Array[Color] = []
	var columns: int = int(size.x / TILE_SIZE)
	var rows: int = int(size.y / TILE_SIZE)
	for column: int in columns:
		for row: int in rows:
			var x: float = -size.x / 2.0 + (column + 0.5) * TILE_SIZE
			var z: float = -size.y / 2.0 + (row + 0.5) * TILE_SIZE
			transforms.append(Transform3D(Basis.IDENTITY, Vector3(x, 0.01, z)))
			var shade: Color = SAND if (column + row) % 2 == 0 else SAND_DARK
			colors.append(shade.lightened(_rng.randf_range(0.0, 0.06)))
	var tiles: MultiMeshInstance3D = _add_multimesh(
		"SandTiles", tile, ToonMaterials.instanced(false), transforms, colors
	)
	tiles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _build_walls() -> void:
	for index: int in ArenaLayout.WALLS.size():
		var rect: Rect2 = ArenaLayout.WALLS[index]
		var height: float = wall_height(index)
		var body: StaticBody3D = StaticBody3D.new()
		body.name = "Border%d" % index if index < ArenaLayout.BORDER_COUNT else "Rock%d" % index
		var center: Vector2 = rect.get_center()
		body.position = Vector3(center.x, height / 2.0, center.y)
		var shape: CollisionShape3D = CollisionShape3D.new()
		shape.name = "Collision"
		var box: BoxShape3D = BoxShape3D.new()
		box.size = Vector3(rect.size.x, height, rect.size.y)
		shape.shape = box
		body.add_child(shape)
		_mesh(body, "Mesh", _box(box.size), ROCK, Vector3.ZERO)
		var band: Vector3 = box.size + Vector3(0.08, 0.0, 0.08)
		band.y = height * 0.16
		_mesh(body, "Band", _box(band), ROCK_BAND, Vector3(0.0, -height * 0.12, 0.0))
		var cap: Vector3 = Vector3(rect.size.x + 0.14, 0.2, rect.size.y + 0.14)
		_mesh(body, "Top", _box(cap), ROCK_TOP, Vector3(0.0, height / 2.0, 0.0))
		walls.add_child(body)
		if height > CAMERA_SIDE_WALL_HEIGHT:
			_stack_boulders(rect, height)


## A few boulders on top of a wall, so it reads as rock and not as a box.
func _stack_boulders(rect: Rect2, height: float) -> void:
	var count: int = maxi(1, int(maxf(rect.size.x, rect.size.y) / 1.7))
	for step: int in count:
		var share: float = (step + 0.5) / count
		var at: Vector2 = rect.position + rect.size * Vector2(share, share)
		if rect.size.x >= rect.size.y:
			at.y = rect.get_center().y + _rng.randf_range(-0.15, 0.15) * rect.size.y
		else:
			at.x = rect.get_center().x + _rng.randf_range(-0.15, 0.15) * rect.size.x
		var radius: float = minf(rect.size.x, rect.size.y) * _rng.randf_range(0.45, 0.6)
		_add_boulder(Vector3(at.x, height + 0.05, at.y), radius)


## Big boulders just outside the arena, so the canyon goes on beyond the walls.
func _build_outside_boulders() -> void:
	var half: Vector2 = ArenaLayout.SIZE / 2.0
	for step: int in 40:
		var side: int = step % 4
		var along: float = _rng.randf_range(-1.0, 1.0)
		var out: float = _rng.randf_range(0.8, 5.0)
		var at: Vector2
		match side:
			0:
				at = Vector2(along * (half.x + 4.0), -half.y - out)
			1:
				at = Vector2(along * (half.x + 4.0), half.y + out + 1.0)
			2:
				at = Vector2(-half.x - out, along * half.y)
			_:
				at = Vector2(half.x + out, along * half.y)
		_add_boulder(Vector3(at.x, 0.0, at.y), _rng.randf_range(0.8, 2.0))


func _add_boulder(at: Vector3, radius: float) -> void:
	var scale: Vector3 = Vector3(1.0, _rng.randf_range(0.55, 0.85), _rng.randf_range(0.8, 1.1))
	var basis: Basis = Basis(Vector3.UP, _rng.randf_range(0.0, TAU)).scaled(scale * radius * 2.0)
	_boulders.append(Transform3D(basis, at))
	_boulder_colors.append(BOULDER.lerp(BOULDER_LIGHT, _rng.randf()))


## Cacti on a jittered grid over every bush patch: trunks, arms and a few flowers.
func _build_cacti() -> void:
	var trunks: Array[Transform3D] = []
	var trunk_colors: Array[Color] = []
	var arms: Array[Transform3D] = []
	var arm_colors: Array[Color] = []
	var flowers: Array[Transform3D] = []
	var flower_colors: Array[Color] = []
	var blossoms: Array[Transform3D] = []
	var blossom_colors: Array[Color] = []
	for bush: Rect2 in ArenaLayout.BUSHES:
		var columns: int = maxi(1, roundi(bush.size.x / CACTUS_SPACING))
		var rows: int = maxi(1, roundi(bush.size.y / CACTUS_SPACING))
		for column: int in columns:
			for row: int in rows:
				var cell: Vector2 = bush.size / Vector2(columns, rows)
				var at: Vector2 = bush.position + cell * Vector2(column + 0.5, row + 0.5)
				at += Vector2(_rng.randf_range(-0.15, 0.15), _rng.randf_range(-0.15, 0.15))
				var tall: float = _rng.randf_range(0.85, 1.15)
				var color: Color = CACTUS.lerp(CACTUS_DARK, _rng.randf())
				var base: Vector3 = Vector3(at.x, 0.0, at.y)
				var turn: Basis = Basis(Vector3.UP, _rng.randf_range(0.0, TAU))
				trunks.append(Transform3D(Basis.IDENTITY.scaled(Vector3(1, tall, 1)), base))
				trunk_colors.append(color)
				for side: float in [-1.0, 1.0]:
					if side > 0.0 and _rng.randf() < 0.4:
						continue
					var arm_y: float = _rng.randf_range(0.45, 0.65) * tall
					arms.append(Transform3D(turn, base + turn * Vector3(side * 0.3, arm_y, 0.0)))
					arm_colors.append(color)
					var reach: Basis = turn * Basis(Vector3.FORWARD, PI / 2.0)
					var middle: Vector3 = Vector3(side * 0.17, arm_y - 0.18, 0.0)
					arms.append(
						Transform3D(reach.scaled(Vector3(1, 0.45, 1)), base + turn * middle)
					)
					arm_colors.append(color)
				if _rng.randf() < 0.5:
					flowers.append(Transform3D(Basis.IDENTITY, base + Vector3(0, 1.1 * tall, 0)))
					flower_colors.append(FLOWER)
				elif _decor_rng.randf() < 0.7:
					var bloom: Basis = Basis(Vector3.UP, _decor_rng.randf_range(0.0, TAU))
					blossoms.append(Transform3D(bloom, base + Vector3(0, 1.08 * tall, 0)))
					blossom_colors.append(BLOSSOMS[_decor_rng.randi() % BLOSSOMS.size()])
	var trunk: ArrayMesh = _shifted(_capsule(0.22, 1.1), 0.55)
	_add_multimesh("CactusTrunks", trunk, ToonMaterials.instanced(), trunks, trunk_colors)
	_add_multimesh("CactusArms", _capsule(0.12, 0.5), ToonMaterials.instanced(), arms, arm_colors)
	var flower: SphereMesh = SphereMesh.new()
	flower.radius = 0.1
	flower.height = 0.2
	flower.radial_segments = 8
	flower.rings = 4
	_add_multimesh("CactusFlowers", flower, ToonMaterials.instanced(), flowers, flower_colors)
	# A five-petal blossom: a flat pentagon with a round middle.
	var petals: CylinderMesh = CylinderMesh.new()
	petals.top_radius = 0.2
	petals.bottom_radius = 0.14
	petals.height = 0.07
	petals.radial_segments = 5
	petals.rings = 1
	_add_multimesh("CactusBlossoms", petals, ToonMaterials.instanced(), blossoms, blossom_colors)


func _build_decoration() -> void:
	var holder: Node3D = Node3D.new()
	holder.name = "Decoration"
	add_child(holder)
	for index: int in ArenaLayout.DECORATION.size():
		var spot: Dictionary = ArenaLayout.DECORATION[index]
		var at: Vector2 = spot["at"]
		var item: Node3D = Node3D.new()
		item.name = "%s%d" % [String(spot["kind"]).capitalize(), index]
		item.position = Vector3(at.x, 0.0, at.y)
		item.rotation.y = index * 1.3
		holder.add_child(item)
		match spot["kind"]:
			"crate":
				_mesh(item, "Box", _box(Vector3(0.9, 0.9, 0.9)), CRATE, Vector3(0, 0.45, 0))
				for y: float in [0.06, 0.84]:
					var rim: BoxMesh = _box(Vector3(0.96, 0.12, 0.96))
					_mesh(item, "Rim", rim, CRATE_EDGE, Vector3(0, y, 0))
			"skull":
				item.rotation.y = 0.3 * (index % 3 - 1)
				var head: SphereMesh = SphereMesh.new()
				head.radius = 0.36
				head.height = 0.62
				_mesh(item, "Head", head, BONE, Vector3(0, 0.31, 0))
				_mesh(item, "Jaw", _box(Vector3(0.32, 0.14, 0.24)), BONE, Vector3(0, 0.1, 0.2))
				for x: float in [-0.13, 0.13]:
					var eye: SphereMesh = SphereMesh.new()
					eye.radius = 0.1
					eye.height = 0.2
					_mesh(item, "Eye", eye, EYE, Vector3(x, 0.36, 0.28))
			"rock":
				_mesh(item, "Big", _low_poly_sphere(0.45), PEBBLE, Vector3(0, 0.2, 0))
				_mesh(item, "Small", _low_poly_sphere(0.25), BOULDER, Vector3(0.45, 0.1, 0.2))
			"bones":
				for turn: float in [0.6, -0.6]:
					var bone: Node3D = _mesh(item, "Bone", _capsule(0.1, 1.0), BONE, Vector3.ZERO)
					bone.rotation = Vector3(PI / 2.0, 0.0, 0.0)
					bone.rotate_y(turn)
					bone.position.y = 0.1


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


func _add_multimesh(
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


## A mesh moved up so its bottom stands on y = 0 (for MultiMesh instances placed at the feet).
static func _shifted(mesh: PrimitiveMesh, up: float) -> ArrayMesh:
	var arrays: Array = mesh.get_mesh_arrays()
	var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	for index: int in vertices.size():
		vertices[index].y += up
	arrays[Mesh.ARRAY_VERTEX] = vertices
	var shifted: ArrayMesh = ArrayMesh.new()
	shifted.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return shifted


static func _box(size: Vector3) -> BoxMesh:
	var box: BoxMesh = BoxMesh.new()
	box.size = size
	return box


static func _capsule(radius: float, height: float) -> CapsuleMesh:
	var capsule: CapsuleMesh = CapsuleMesh.new()
	capsule.radius = radius
	capsule.height = height
	capsule.radial_segments = 10
	capsule.rings = 3
	return capsule


## Few faces on purpose: with the toon light it looks like a chiselled rock.
static func _low_poly_sphere(radius: float) -> SphereMesh:
	var sphere: SphereMesh = SphereMesh.new()
	sphere.radius = radius
	sphere.height = radius * 2.0
	sphere.radial_segments = 7
	sphere.rings = 3
	return sphere
