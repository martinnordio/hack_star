@tool
class_name GlimmerProp
extends Node3D
## One Glimmer Isles prop (spec 09, W3, D13), own art: built from Godot's primitive meshes with
## the shared cel-shaded, outlined materials (`ToonMaterials`) as soon as its `kind` is set, so a
## prop scene (`props/<kind>.tscn`) has its parts right after `instantiate()` — which is what
## ProtonScatter reads (`ScatterItem`) — also in the editor. Every part is a direct
## `MeshInstance3D` child, centred on its own origin and placed without scale, so the bake
## (`tools/bake_world.gd`) can give each part its own MultiMesh with a correct outline.

const KINDS: Array[String] = [
	"crystal_cluster", "glow_fern", "small_mushroom", "giant_mushroom", "island_chunk"
]

const ROCK: Color = Color("5434b0")
const CRYSTAL: Color = Color("4feaff")
const CRYSTAL_GLOW: Color = Color("1fc2ff")
const CRYSTAL_PINK: Color = Color("ff5cd6")
const CRYSTAL_PINK_GLOW: Color = Color("ff2fbe")
const FERN: Color = Color("1fcf80")
const FERN_LIGHT: Color = Color("4ff2a4")
const FERN_TIP: Color = Color("d4ff4f")
const STEM: Color = Color("fbecc6")
const CAP: Color = Color("c444ff")
const CAP_GLOW: Color = Color("9b2dff")
const GIANT_CAP: Color = Color("ff55a8")
const GIANT_CAP_GLOW: Color = Color("ff2f8f")
const GILLS: Color = Color("ffc8e8")
const GRASS: Color = Color("55e0a6")
const ISLAND_ROCK: Color = Color("7b56dc")
const ROOT: Color = Color("3d2a8c")

## Which prop this is (one of `KINDS`); setting it builds the parts.
@export var kind: String = "":
	set(value):
		kind = value
		_build()


func _build() -> void:
	for child: Node in get_children():
		remove_child(child)
		child.free()
	match kind:
		"crystal_cluster":
			_crystal_cluster()
		"glow_fern":
			_glow_fern()
		"small_mushroom":
			_small_mushroom()
		"giant_mushroom":
			_giant_mushroom()
		"island_chunk":
			_island_chunk()


## The parts of the prop (every `MeshInstance3D` child).
func parts() -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	for child: Node in get_children():
		if child is MeshInstance3D:
			result.append(child)
	return result


# A rock with three glowing crystal spikes (walls, border and decoration): about 0.9 m wide and
# 1.5 m tall.
func _crystal_cluster() -> void:
	_part("Rock", _rock(0.45, 0.5), ToonMaterials.toon(ROCK), Vector3(0.0, 0.15, 0.0))
	var blue: Material = ToonMaterials.toon(CRYSTAL, CRYSTAL_GLOW, 0.5)
	var pink: Material = ToonMaterials.toon(CRYSTAL_PINK, CRYSTAL_PINK_GLOW, 0.5)
	_part("Spike", _spike(0.24, 1.4), blue, Vector3(0.0, 0.8, 0.0), Vector3(0.0, 0.0, 0.08))
	_part("SpikeLeft", _spike(0.17, 0.95), pink, Vector3(-0.25, 0.55, 0.1), Vector3(0.2, 0, 0.45))
	_part("SpikeRight", _spike(0.15, 0.8), blue, Vector3(0.24, 0.48, -0.08), Vector3(-0.3, 0, -0.5))


# Glowing fern fronds (cover): about 1.1 m tall, enough to half-hide a fighter like the
# canyon's cacti.
func _glow_fern() -> void:
	var frond: CapsuleMesh = _capsule(0.09, 1.1)
	var green: Material = ToonMaterials.toon(FERN)
	var light: Material = ToonMaterials.toon(FERN_LIGHT)
	_part("Frond", frond, green, Vector3(0.0, 0.55, 0.0))
	_part("FrondLeft", frond, light, Vector3(-0.2, 0.45, 0.0), Vector3(0.0, 0.0, 0.45))
	_part("FrondRight", frond, green, Vector3(0.18, 0.45, 0.1), Vector3(0.3, 0.0, -0.45))
	_part("FrondBack", frond, light, Vector3(0.0, 0.42, -0.2), Vector3(-0.5, 0.0, 0.0))
	var tip: Material = ToonMaterials.toon(FERN_TIP, FERN_TIP, 0.8)
	_part("TipLeft", _ball(0.09), tip, Vector3(-0.42, 0.93, 0.0))
	_part("TipBack", _ball(0.09), tip, Vector3(0.0, 0.88, -0.45))


# A small glowing mushroom (cover and decoration): about 0.5 m tall.
func _small_mushroom() -> void:
	_part("Stem", _cylinder(0.07, 0.09, 0.36), ToonMaterials.toon(STEM), Vector3(0, 0.18, 0))
	var cap: Material = ToonMaterials.toon(CAP, CAP_GLOW, 0.35)
	_part("Cap", _dome(0.28, 0.18), cap, Vector3(0.0, 0.32, 0.0))


# A giant mushroom outside the arena: about 4 m tall.
func _giant_mushroom() -> void:
	var stem: Material = ToonMaterials.toon(STEM)
	_part("Stem", _cylinder(0.32, 0.5, 3.2), stem, Vector3(0.0, 1.6, 0.0))
	_part("Gills", _cylinder(1.5, 1.5, 0.12), ToonMaterials.toon(GILLS), Vector3(0, 3.15, 0))
	var cap: Material = ToonMaterials.toon(GIANT_CAP, GIANT_CAP_GLOW, 0.3)
	_part("Cap", _dome(1.7, 0.9), cap, Vector3(0.0, 3.2, 0.0))


# A floating island chunk with hanging roots, outside and below the arena.
func _island_chunk() -> void:
	_part("Grass", _cylinder(1.6, 1.4, 0.4), ToonMaterials.toon(GRASS), Vector3.ZERO)
	var rock: Material = ToonMaterials.toon(ISLAND_ROCK)
	_part("Rock", _cylinder(1.4, 0.15, 1.8), rock, Vector3(0.0, -1.1, 0.0))
	var root: CapsuleMesh = _capsule(0.06, 1.4)
	var roots: Material = ToonMaterials.toon(ROOT)
	_part("RootLeft", root, roots, Vector3(-0.9, -0.8, 0.3), Vector3(0.0, 0.0, -0.15))
	_part("RootRight", root, roots, Vector3(0.8, -0.9, -0.4), Vector3(0.1, 0.0, 0.2))


func _part(
	part_name: String, mesh: Mesh, material: Material, at: Vector3, turn: Vector3 = Vector3.ZERO
) -> void:
	var part: MeshInstance3D = MeshInstance3D.new()
	part.name = part_name
	part.mesh = mesh
	part.material_override = material
	part.position = at
	part.rotation = turn
	add_child(part)


# A six-sided crystal spike: a hexagonal cone.
static func _spike(radius: float, height: float) -> CylinderMesh:
	var spike: CylinderMesh = _cylinder(0.0, radius, height)
	spike.radial_segments = 6
	return spike


static func _cylinder(top: float, bottom: float, height: float) -> CylinderMesh:
	var cylinder: CylinderMesh = CylinderMesh.new()
	cylinder.top_radius = top
	cylinder.bottom_radius = bottom
	cylinder.height = height
	cylinder.radial_segments = 10
	cylinder.rings = 1
	return cylinder


static func _capsule(radius: float, height: float) -> CapsuleMesh:
	var capsule: CapsuleMesh = CapsuleMesh.new()
	capsule.radius = radius
	capsule.height = height
	capsule.radial_segments = 8
	capsule.rings = 2
	return capsule


static func _ball(radius: float) -> SphereMesh:
	var ball: SphereMesh = SphereMesh.new()
	ball.radius = radius
	ball.height = radius * 2.0
	ball.radial_segments = 8
	ball.rings = 4
	return ball


# Few faces on purpose: with the toon light it reads as a chiselled rock (as the canyon's).
static func _rock(radius: float, height: float) -> SphereMesh:
	var rock: SphereMesh = SphereMesh.new()
	rock.radius = radius
	rock.height = height
	rock.radial_segments = 7
	rock.rings = 3
	return rock


# A dome `height` tall on its flat side (a round one when `height` equals `radius`).
static func _dome(radius: float, height: float) -> SphereMesh:
	var dome: SphereMesh = SphereMesh.new()
	dome.radius = radius
	dome.height = height
	dome.is_hemisphere = true
	dome.radial_segments = 12
	dome.rings = 4
	return dome
