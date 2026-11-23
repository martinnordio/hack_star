class_name CanyonDecor
extends Node3D
## The canyon's newer decoration (spec 09, L2, D26), built in code at `_ready`: flags that wave
## on the border walls, birds that circle high over the canyon and a turquoise stream outside the
## east wall with flowing highlights (`Canyon` adds the blossoms on the cactus tops). Nothing here
## has a collider or stands in the arena, so walls, cover, start points and collisions stay as they
## are (W4, W7, S2). The flags and the water move in their shaders, the birds in `_process`.

## The kinds this node adds, each a child of that name.
const KINDS: Array[String] = ["Flags", "Birds", "Stream"]
const FLAG_SHADER: Shader = preload("res://scenes/toon/flag.gdshader")
const WATER_SHADER: Shader = preload("res://scenes/toon/flowing_water.gdshader")

const POLE_HEIGHT: float = 1.5
const FLAG_SIZE: Vector2 = Vector2(0.9, 0.55)
## Where along a high border wall the flags stand (shares of its length).
const FLAG_PLACES: Array[float] = [0.12, 0.5, 0.88]

const BIRD_COUNT: int = 5
## The birds circle this point, this far out and this high (metres), this fast (radians/second).
const BIRD_CENTER: Vector3 = Vector3(0.0, 0.0, -3.0)
const BIRD_RADIUS: Vector2 = Vector2(12.0, 17.0)
const BIRD_HEIGHT: Vector2 = Vector2(6.5, 9.0)
const BIRD_SPEED: Vector2 = Vector2(0.25, 0.45)
const FLAP_SPEED: float = 9.0

const STREAM_SIZE: Vector2 = Vector2(3.2, 70.0)
## How far outside the east border wall the stream runs (metres), among the outside boulders.
const STREAM_BEYOND: float = 3.4

## The colour variation of the canyon (`CanyonLooks`), set before `_ready`.
var variation: String = ColourVariations.DEFAULT

var _time: float = 0.0
var _birds: Array[Node3D] = []
## Per bird: radius, height, speed (signed: the way round) and the start angle.
var _bird_paths: Array[Vector4] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _poles: Array[MeshInstance3D] = []
var _cloths: Array[ShaderMaterial] = []
var _bird_parts: Array[MeshInstance3D] = []
var _stream: ShaderMaterial


func _ready() -> void:
	_rng.seed = Canyon.DECOR_SEED
	_build_flags()
	_build_birds()
	_build_stream()
	_place_birds()


func _process(delta: float) -> void:
	_time += delta
	_place_birds()


## Recolours the flags, the birds and the stream for the colour variation `variation_id`.
func apply_variation(variation_id: String) -> void:
	variation = variation_id
	for pole: MeshInstance3D in _poles:
		pole.material_override = CanyonLooks.material("pole", variation)
	for index: int in _cloths.size():
		_cloths[index].set_shader_parameter("color", _flag_color(index))
	var bird: Material = CanyonLooks.material("bird", variation, false)
	for part: MeshInstance3D in _bird_parts:
		part.material_override = bird
	_paint_stream()


## The birds (for tests).
func birds() -> Array[Node3D]:
	return _birds


func _build_flags() -> void:
	var holder: Node3D = _holder("Flags")
	var pole: CylinderMesh = CylinderMesh.new()
	pole.top_radius = 0.04
	pole.bottom_radius = 0.05
	pole.height = POLE_HEIGHT
	pole.radial_segments = 6
	pole.rings = 1
	var cloth: PlaneMesh = PlaneMesh.new()
	cloth.size = FLAG_SIZE
	cloth.orientation = PlaneMesh.FACE_Z
	cloth.subdivide_width = 8
	# The pole is at x = 0, the cloth's free end at its length (the shader's `length`).
	cloth.center_offset = Vector3(FLAG_SIZE.x / 2.0, 0.0, 0.0)
	var count: int = 0
	for index: int in ArenaLayout.border_count():
		var height: float = Canyon.wall_height(index)
		if height <= Canyon.CAMERA_SIDE_WALL_HEIGHT:
			continue
		var rect: Rect2 = ArenaLayout.walls()[index]
		for share: float in FLAG_PLACES:
			var at: Vector2 = rect.get_center()
			if rect.size.x >= rect.size.y:
				at.x = rect.position.x + rect.size.x * share
			else:
				at.y = rect.position.y + rect.size.y * share
			var flag: Node3D = Node3D.new()
			flag.name = "Flag%d" % count
			flag.position = Vector3(at.x, height + 0.1, at.y)
			holder.add_child(flag)
			var stick: MeshInstance3D = _instance(
				"Pole", pole, CanyonLooks.material("pole", variation)
			)
			stick.position.y = POLE_HEIGHT / 2.0
			flag.add_child(stick)
			_poles.append(stick)
			var material: ShaderMaterial = ShaderMaterial.new()
			material.shader = FLAG_SHADER
			material.set_shader_parameter("color", _flag_color(count))
			material.set_shader_parameter("length", FLAG_SIZE.x)
			_cloths.append(material)
			var banner: MeshInstance3D = _instance("Cloth", cloth, material)
			banner.position.y = POLE_HEIGHT - FLAG_SIZE.y / 2.0
			flag.add_child(banner)
			count += 1


func _build_birds() -> void:
	var holder: Node3D = _holder("Birds")
	var wing: BoxMesh = BoxMesh.new()
	wing.size = Vector3(0.7, 0.04, 0.28)
	var body: CapsuleMesh = CapsuleMesh.new()
	body.radius = 0.09
	body.height = 0.55
	body.radial_segments = 6
	body.rings = 1
	var material: Material = CanyonLooks.material("bird", variation, false)
	for index: int in BIRD_COUNT:
		var bird: Node3D = Node3D.new()
		bird.name = "Bird%d" % index
		var trunk: MeshInstance3D = _instance("Body", body, material)
		trunk.rotation.x = PI / 2.0
		bird.add_child(trunk)
		_bird_parts.append(trunk)
		for side: float in [-1.0, 1.0]:
			var feather: MeshInstance3D = _instance(
				"WingLeft" if side < 0.0 else "WingRight", wing, material
			)
			feather.position.x = side * 0.38
			bird.add_child(feather)
			_bird_parts.append(feather)
		holder.add_child(bird)
		_birds.append(bird)
		var way: float = 1.0 if index % 2 == 0 else -1.0
		_bird_paths.append(
			Vector4(
				_rng.randf_range(BIRD_RADIUS.x, BIRD_RADIUS.y),
				_rng.randf_range(BIRD_HEIGHT.x, BIRD_HEIGHT.y),
				way * _rng.randf_range(BIRD_SPEED.x, BIRD_SPEED.y),
				_rng.randf_range(0.0, TAU)
			)
		)


# Each bird on its circle, facing along it, its wings flapping.
func _place_birds() -> void:
	for index: int in _birds.size():
		var path: Vector4 = _bird_paths[index]
		var angle: float = path.w + path.z * _time
		var bird: Node3D = _birds[index]
		bird.position = BIRD_CENTER + Vector3(cos(angle) * path.x, path.y, sin(angle) * path.x)
		# The way it flies: along the circle's tangent.
		var ahead: Vector3 = Vector3(-sin(angle), 0.0, cos(angle)) * signf(path.z)
		bird.rotation.y = atan2(-ahead.x, -ahead.z)
		var flap: float = sin(_time * FLAP_SPEED + index) * 0.5
		(bird.get_node("WingLeft") as Node3D).rotation.z = flap
		(bird.get_node("WingRight") as Node3D).rotation.z = -flap


func _build_stream() -> void:
	var holder: Node3D = _holder("Stream")
	var water: PlaneMesh = PlaneMesh.new()
	water.size = STREAM_SIZE
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = WATER_SHADER
	_stream = material
	_paint_stream()
	material.set_shader_parameter("flow", Vector2(0.0, 0.6))
	material.set_shader_parameter("bands", Vector2(2.0, STREAM_SIZE.y / 2.5))
	var stream: MeshInstance3D = _instance("Water", water, material)
	stream.position = Vector3(ArenaLayout.SIZE.x / 2.0 + STREAM_BEYOND, -0.11, 0.0)
	holder.add_child(stream)


func _paint_stream() -> void:
	_stream.set_shader_parameter("water", CanyonLooks.color("stream", variation))
	_stream.set_shader_parameter("highlight", CanyonLooks.color("stream_light", variation))


func _flag_color(index: int) -> Color:
	return CanyonLooks.color("flag_%d" % (index % CanyonLooks.FLAG_COUNT), variation)


func _holder(holder_name: String) -> Node3D:
	var holder: Node3D = Node3D.new()
	holder.name = holder_name
	add_child(holder)
	return holder


static func _instance(node_name: String, mesh: Mesh, material: Material) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.material_override = material
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return instance
