class_name FighterModel
extends Node3D
## A fighter's 3D look, built in code from primitive meshes and plain materials (no imported art).
## `setup(fighter_id, skin_id)` builds the fighter; the front faces +Z (towards the stage camera),
## the feet stand on y = 0. The idle animation (breathing, sway, flickering flames and screens)
## runs in `_process` while `idle_enabled` is true; switch it off for still pictures.

const OUTLINE_COLOR: Color = Color(0.086, 0.059, 0.2)
const OUTLINE_GROW: float = 0.022
## Height of the neck: the head turns around this point.
const NECK_Y: float = 1.2
const BREATH_SPEED: float = 2.2
const BREATH_HEIGHT: float = 0.04
const SWAY_SPEED: float = 0.9
const SWAY_ANGLE: float = 0.15
const HEAD_TILT_SPEED: float = 1.3
const HEAD_TILT_ANGLE: float = 0.06
const FLICKER_SPEED: float = 9.0
const FLICKER_AMOUNT: float = 0.07

## Colours of each fighter's look, per skin. `main` is the colour a player sees most.
const LOOKS: Dictionary = {
	"blaze":
	{
		"default":
		{
			"main": Color("e8322b"),
			"legs": Color("3b2a5c"),
			"hair": Color("ff7a1a"),
			"tip": Color("ffd23f"),
			"skin": Color("ffd2a8"),
			"shoes": Color("2a1d1d"),
		},
	},
	"rocko":
	{
		"default":
		{
			"main": Color("8d7f73"),
			"dark": Color("5f544b"),
			"moss": Color("5fae3c"),
			"eyes": Color("ffd23f"),
		},
	},
	"turbo":
	{
		"default":
		{
			"main": Color("2f7bff"),
			"legs": Color("283048"),
			"skin": Color("e9b48a"),
			"shoes": Color("ffffff"),
			"helmet": Color("ffd23f"),
			"visor": Color("1b1446"),
			"stripe": Color("e8322b"),
		},
	},
	"frosty":
	{
		"default":
		{
			"main": Color("ffffff"),
			"face": Color("8fd3ff"),
			"horn": Color("bfe9ff"),
			"nose": Color("3a5a9a"),
		},
	},
	"luna":
	{
		"default":
		{
			"main": Color("7b4dff"),
			"fur": Color("5a5a6e"),
			"inner": Color("ff9ac8"),
			"accent": Color("ffd23f"),
			"metal": Color("c9d1e0"),
		},
	},
	"pixel":
	{
		"default":
		{
			"main": Color("e8edf5"),
			"trim": Color("2f7bff"),
			"screen": Color("0b0d1a"),
			"pixels": Color("39ff88"),
		},
	},
}

## Plays the idle animation every frame; off for still pictures (the fighter list).
@export var idle_enabled: bool = true

var fighter_id: String = ""
var skin_id: String = ""
## The colour a player sees most on this fighter in this skin.
var main_color: Color = Color.WHITE
var time_seconds: float = 0.0

var _rig: Node3D
var _body: Node3D
var _head: Node3D
var _flickers: Array[Node3D] = []
var _flicker_scales: Array[Vector3] = []
var _outline: StandardMaterial3D


func _ready() -> void:
	if _rig == null:
		setup(SampleProgress.SELECTED_FIGHTER)


func _process(delta: float) -> void:
	if idle_enabled and _rig != null:
		time_seconds += delta
		animate(time_seconds)


## Builds the fighter in a skin, replacing what was built before. An unknown fighter shows
## Blaze; an unknown skin shows the Default look.
func setup(new_fighter_id: String, new_skin_id: String = Fighters.DEFAULT_SKIN) -> void:
	fighter_id = new_fighter_id if LOOKS.has(new_fighter_id) else "blaze"
	var looks: Dictionary = LOOKS[fighter_id]
	skin_id = new_skin_id if looks.has(new_skin_id) else Fighters.DEFAULT_SKIN
	var look: Dictionary = looks[skin_id]
	main_color = look["main"]
	_clear()
	match fighter_id:
		"rocko":
			_build_rocko(look)
		"turbo":
			_build_turbo(look)
		"frosty":
			_build_frosty(look)
		"luna":
			_build_luna(look)
		"pixel":
			_build_pixel(look)
		_:
			_build_blaze(look)
	animate(time_seconds)


## Puts the idle animation at a moment in time (seconds).
func animate(time: float) -> void:
	if _rig == null:
		return
	_body.position.y = sin(time * BREATH_SPEED) * BREATH_HEIGHT
	_body.rotation.y = sin(time * SWAY_SPEED) * SWAY_ANGLE
	_head.rotation.z = sin(time * HEAD_TILT_SPEED) * HEAD_TILT_ANGLE
	for index: int in _flickers.size():
		var wave: float = 1.0 + sin(time * FLICKER_SPEED + index * 1.7) * FLICKER_AMOUNT
		_flickers[index].scale = _flicker_scales[index] * wave


func _clear() -> void:
	if _rig != null:
		remove_child(_rig)
		_rig.free()
	_flickers.clear()
	_flicker_scales.clear()
	_rig = Node3D.new()
	_rig.name = "Rig"
	add_child(_rig)
	_body = _group(_rig, "Body")
	_head = _group(_body, "Head", Vector3(0.0, NECK_Y, 0.0))
	var shadow: MeshInstance3D = _part(
		_rig, _cylinder(0.75, 0.75, 0.01), _shadow_material(), Vector3(0.0, 0.006, 0.0)
	)
	shadow.name = "Shadow"
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


# --- The six fighters -------------------------------------------------------------------------


func _build_blaze(look: Dictionary) -> void:
	_human(look["skin"], look["main"], look["legs"], look["shoes"])
	var flame: StandardMaterial3D = _toon(look["hair"], look["hair"], 0.6)
	var tip: StandardMaterial3D = _toon(look["tip"], look["tip"], 0.9)
	var hair: Node3D = _group(_head, "FlameHair")
	_part(
		hair, _sphere(0.52), flame, Vector3(0.0, 1.86, -0.16), Vector3.ZERO, Vector3(1.02, 0.7, 1)
	)
	for side: float in [-1.0, 1.0]:
		var lock_turn: Vector3 = Vector3(0.0, 0.0, side * 0.12)
		_part(hair, _capsule(0.15, 0.75), flame, Vector3(side * 0.42, 1.55, -0.12), lock_turn)
	var ponytail_turn: Vector3 = Vector3(-2.4, 0.0, 0.0)
	_flicker(_part(hair, _cone(0.2, 0.7), flame, Vector3(0.0, 1.7, -0.62), ponytail_turn))
	for index: int in 7:
		var angle: float = -1.3 + index / 6.0 * 2.6
		var position_on_head: Vector3 = Vector3(sin(angle) * 0.38, 2.1, -0.1 - cos(angle) * 0.18)
		var cone: MeshInstance3D = _part(
			hair, _cone(0.2, 0.75), flame, position_on_head, Vector3(-0.35, 0.0, -angle * 0.55)
		)
		_flicker(cone)
	_flicker(_part(hair, _cone(0.18, 0.6), tip, Vector3(0.0, 2.5, -0.12), Vector3(-0.3, 0.0, 0.0)))
	var ball: MeshInstance3D = _part(
		_body,
		_sphere(0.2),
		_toon(Color("ffcf33"), Color("ff7a00"), 1.2, false),
		Vector3(0.62, 0.78, 0.25)
	)
	ball.name = "Fireball"
	_flicker(ball)
	var skirt: StandardMaterial3D = _toon(look["legs"])
	_part(_body, _cylinder(0.3, 0.46, 0.28), skirt, Vector3(0.0, 0.45, 0.0))


func _build_rocko(look: Dictionary) -> void:
	var rock: StandardMaterial3D = _toon(look["main"])
	var dark: StandardMaterial3D = _toon(look["dark"])
	var moss: StandardMaterial3D = _toon(look["moss"])
	var blocks: Node3D = _group(_body, "RockBlocks")
	for side: float in [-1.0, 1.0]:
		_part(_rig, _box(0.42, 0.4, 0.46), dark, Vector3(side * 0.3, 0.2, 0.0), Vector3(0, 0.3, 0))
		_part(
			blocks,
			_box(0.5, 0.48, 0.5),
			rock,
			Vector3(side * 0.8, 1.0, 0.05),
			Vector3(0.4, side * 0.6, side * 0.2)
		)
		_part(
			blocks, _box(0.4, 0.4, 0.4), dark, Vector3(side * 0.86, 0.55, 0.2), Vector3(0.3, 0.5, 0)
		)
	_part(blocks, _box(1.1, 1.0, 0.8), rock, Vector3(0.0, 0.95, 0.0), Vector3(0.0, 0.0, 0.04))
	_part(blocks, _box(0.55, 0.45, 0.1), dark, Vector3(0.0, 0.85, 0.42), Vector3(0.0, 0.0, 0.1))
	var moss_at: Vector3 = Vector3(0.05, 2.02, 0.0)
	_part(_head, _sphere(0.24), moss, moss_at, Vector3.ZERO, Vector3(1.3, 0.4, 1.1))
	_part(_head, _box(0.7, 0.55, 0.6), rock, Vector3(0.0, 1.74, 0.0), Vector3(0.0, 0.0, -0.04))
	_part(_head, _box(0.6, 0.1, 0.12), dark, Vector3(0.0, 1.88, 0.3), Vector3(0.0, 0.0, 0.08))
	_part(_head, _box(0.22, 0.05, 0.04), _toon(look["dark"]), Vector3(0.0, 1.57, 0.31))
	_eyes(_head, 1.7, 0.36, look["eyes"], 0.38)


func _build_turbo(look: Dictionary) -> void:
	_human(look["skin"], look["main"], look["legs"], look["shoes"])
	var helmet_shell: SphereMesh = _sphere(0.56)
	helmet_shell.is_hemisphere = true
	helmet_shell.height = 0.56
	var helmet: MeshInstance3D = _part(
		_head, helmet_shell, _toon(look["helmet"]), Vector3(0.0, 1.76, -0.02)
	)
	helmet.name = "Helmet"
	var visor: MeshInstance3D = _part(
		_head,
		_box(0.72, 0.2, 0.12),
		_toon(look["visor"], Color("2244aa"), 0.3),
		Vector3(0.0, 1.92, 0.5),
		Vector3(-0.35, 0.0, 0.0)
	)
	visor.name = "Visor"
	var stripe: StandardMaterial3D = _toon(look["stripe"], Color.BLACK, 0.0, false)
	_part(_head, _box(0.14, 0.05, 1.0), stripe, Vector3(0.0, 2.31, -0.02), Vector3(0.2, 0, 0))
	var scarf: StandardMaterial3D = _toon(look["stripe"])
	_part(_body, _torus(0.22, 0.4), scarf, Vector3(0.0, 1.2, 0.0))
	_flicker(
		_part(
			_body, _box(0.16, 0.5, 0.06), scarf, Vector3(0.15, 1.05, -0.38), Vector3(0.5, 0.0, 0.3)
		)
	)


func _build_frosty(look: Dictionary) -> void:
	var fur: StandardMaterial3D = _toon(look["main"])
	var face: StandardMaterial3D = _toon(look["face"])
	var horn: StandardMaterial3D = _toon(look["horn"], Color("7fd0ff"), 0.5)
	var horns: Node3D = _group(_head, "Horns")
	for side: float in [-1.0, 1.0]:
		_part(
			_rig,
			_sphere(0.24),
			fur,
			Vector3(side * 0.3, 0.2, 0.05),
			Vector3.ZERO,
			Vector3(1, .8, 1.2)
		)
		_part(
			_body,
			_capsule(0.17, 0.79),
			fur,
			Vector3(side * 0.7, 0.85, 0.05),
			Vector3(0.0, 0.0, side * 0.3)
		)
		_part(
			horns, _cone(0.1, 0.4), horn, Vector3(side * 0.44, 2.02, 0), Vector3(0, 0, -side * 0.6)
		)
	var body_fur: MeshInstance3D = _part(
		_body, _sphere(0.72), fur, Vector3(0.0, 0.95, 0.0), Vector3.ZERO, Vector3(1.0, 0.95, 0.9)
	)
	body_fur.name = "Fur"
	_part(_head, _sphere(0.52), fur, Vector3(0.0, 1.72, 0.0))
	for index: int in 3:
		var tuft: Vector3 = Vector3((index - 1) * 0.16, 2.2 - absf(index - 1) * 0.04, 0.02)
		_part(_head, _sphere(0.13), fur, tuft, Vector3.ZERO, Vector3(1.0, 1.3, 1.0))
	var face_patch: Vector3 = Vector3(1.0, 0.85, 0.75)
	_part(_head, _sphere(0.4), face, Vector3(0.0, 1.66, 0.22), Vector3.ZERO, face_patch)
	_eyes(_head, 1.72, 0.55)
	_part(
		_head, _sphere(0.08), _toon(look["nose"], Color.BLACK, 0.0, false), Vector3(0, 1.58, 0.53)
	)


func _build_luna(look: Dictionary) -> void:
	_human(look["fur"], look["main"], look["main"], look["accent"])
	var fur: StandardMaterial3D = _toon(look["fur"])
	var inner: StandardMaterial3D = _toon(look["inner"], Color.BLACK, 0.0, false)
	var whisker: StandardMaterial3D = _toon(Color.WHITE, Color.BLACK, 0.0, false)
	var ears: Node3D = _group(_head, "Ears")
	for side: float in [-1.0, 1.0]:
		var turn: Vector3 = Vector3(0.0, PI / 4.0, side * -0.3)
		_part(ears, _cone(0.2, 0.4, 4), fur, Vector3(side * 0.3, 2.12, 0.0), turn)
		_part(ears, _cone(0.11, 0.24, 4), inner, Vector3(side * 0.3, 2.1, 0.08), turn)
		var whisker_turn: Vector3 = Vector3(0.0, 0.0, side * 0.15)
		_part(
			_head, _box(0.25, 0.02, 0.02), whisker, Vector3(side * 0.42, 1.55, 0.42), whisker_turn
		)
	_part(_head, _sphere(0.06), inner, Vector3(0.0, 1.6, 0.5))
	var tail: Node3D = _group(_body, "Tail")
	for index: int in 8:
		var angle: float = index / 7.0 * PI * 1.3
		var point: Vector3 = Vector3(0.12 * sin(angle * 0.5), 0.5 + sin(angle) * 0.35, -0.45)
		point.z -= (1.0 - cos(angle)) * 0.25
		_part(tail, _sphere(0.08 - index * 0.004), fur, point)
	var gun: Node3D = _group(_body, "RayGun")
	var metal: StandardMaterial3D = _toon(look["metal"])
	var gun_turn: Vector3 = Vector3(0.0, 0.0, PI / 2.0)
	_part(gun, _cylinder(0.07, 0.1, 0.45), metal, Vector3(0.84, 0.74, 0.12), gun_turn)
	_part(gun, _box(0.08, 0.2, 0.1), metal, Vector3(0.66, 0.62, 0.12), Vector3(0.0, 0.0, 0.3))
	_part(gun, _torus(0.09, 0.14), _toon(look["accent"]), Vector3(0.84, 0.74, 0.12), gun_turn)
	var beam: StandardMaterial3D = _toon(look["accent"], look["accent"], 1.2, false)
	_flicker(_part(gun, _sphere(0.1), beam, Vector3(1.08, 0.74, 0.12)))
	var bubble: StandardMaterial3D = StandardMaterial3D.new()
	bubble.albedo_color = Color(0.75, 0.91, 1.0, 0.18)
	bubble.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bubble.roughness = 0.0
	var helmet: MeshInstance3D = _part(_head, _sphere(0.68), bubble, Vector3(0.0, 1.68, 0.0))
	helmet.name = "SpaceHelmet"
	helmet.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _build_pixel(look: Dictionary) -> void:
	var shell: StandardMaterial3D = _toon(look["main"])
	var trim: StandardMaterial3D = _toon(look["trim"])
	var lit: StandardMaterial3D = _toon(look["pixels"], look["pixels"], 1.2, false)
	for side: float in [-1.0, 1.0]:
		_part(_rig, _box(0.22, 0.45, 0.28), trim, Vector3(side * 0.2, 0.23, 0.0))
		_part(
			_body,
			_cylinder(0.08, 0.08, 0.45),
			shell,
			Vector3(side * 0.55, 0.9, 0.0),
			Vector3(0.0, 0.0, side * 0.5)
		)
		_part(_body, _box(0.2, 0.2, 0.2), trim, Vector3(side * 0.68, 0.68, 0.05))
	_part(_body, _box(0.8, 0.7, 0.55), shell, Vector3(0.0, 0.85, 0.0))
	_part(_body, _box(0.3, 0.2, 0.05), trim, Vector3(0.0, 0.9, 0.29))
	_part(_head, _box(1.0, 0.75, 0.75), shell, Vector3(0.0, 1.65, 0.0))
	var face: Node3D = _group(_head, "ScreenFace")
	_part(face, _box(0.82, 0.55, 0.05), _toon(look["screen"]), Vector3(0.0, 1.65, 0.38))
	var dots: Array[Vector2] = [
		Vector2(-0.2, 1.75),
		Vector2(0.2, 1.75),
		Vector2(-0.18, 1.5),
		Vector2(-0.06, 1.46),
		Vector2(0.06, 1.46),
		Vector2(0.18, 1.5),
	]
	for dot: Vector2 in dots:
		_part(face, _box(0.1, 0.1, 0.03), lit, Vector3(dot.x, dot.y, 0.42))
	_flicker(face)
	var antenna: Node3D = _group(_head, "Antenna")
	_part(antenna, _cylinder(0.03, 0.03, 0.35), trim, Vector3(0.0, 2.17, 0.0))
	_flicker(_part(antenna, _sphere(0.09), lit, Vector3(0.0, 2.38, 0.0)))


# --- Shared parts -----------------------------------------------------------------------------


## Chibi kid body: big head, short legs; head centre at y = 1.65.
func _human(skin: Color, top: Color, legs: Color, shoes: Color) -> void:
	var top_material: StandardMaterial3D = _toon(top)
	var legs_material: StandardMaterial3D = _toon(legs)
	var shoes_material: StandardMaterial3D = _toon(shoes)
	var skin_material: StandardMaterial3D = _toon(skin)
	for side: float in [-1.0, 1.0]:
		_part(_rig, _capsule(0.13, 0.51), legs_material, Vector3(side * 0.17, 0.3, 0.0))
		var shoe_scale: Vector3 = Vector3(1.0, 0.7, 1.35)
		var shoe_at: Vector3 = Vector3(side * 0.17, 0.1, 0.05)
		_part(_rig, _sphere(0.15), shoes_material, shoe_at, Vector3.ZERO, shoe_scale)
		var arm_turn: Vector3 = Vector3(0.0, 0.0, side * 0.45)
		_part(_body, _capsule(0.1, 0.5), top_material, Vector3(side * 0.47, 0.92, 0.0), arm_turn)
		_part(_body, _sphere(0.12), skin_material, Vector3(side * 0.58, 0.7, 0.03))
	_part(_body, _capsule(0.36, 1.02), top_material, Vector3(0.0, 0.85, 0.0))
	_part(_head, _sphere(0.5), skin_material, Vector3(0.0, 1.65, 0.0))
	_eyes(_head, 1.65, 0.5)


## Two big shiny cartoon eyes on the front of a head of radius `radius` centred at `y`.
func _eyes(
	parent: Node3D, y: float, radius: float, color: Color = OUTLINE_COLOR, spread: float = 0.34
) -> void:
	var eye: StandardMaterial3D = _toon(color, Color.BLACK, 0.0, false)
	var shine: StandardMaterial3D = StandardMaterial3D.new()
	shine.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	for side: float in [-1.0, 1.0]:
		var x: float = side * radius * spread
		var z: float = sqrt(maxf(0.0, radius * radius - x * x)) * 0.92
		var eye_at: Vector3 = Vector3(x, y + radius * 0.05, z)
		var eye_scale: Vector3 = Vector3(1.0, 1.35, 0.6)
		_part(parent, _sphere(radius * 0.16), eye, eye_at, Vector3.ZERO, eye_scale)
		var shine_at: Vector3 = Vector3(x + radius * 0.05, y + radius * 0.13, z + radius * 0.08)
		_part(parent, _sphere(radius * 0.055), shine, shine_at)


# --- Building blocks --------------------------------------------------------------------------


func _group(parent: Node3D, group_name: String, at: Vector3 = Vector3.ZERO) -> Node3D:
	var group: Node3D = Node3D.new()
	group.name = group_name
	parent.add_child(group)
	group.position = at - _model_offset(parent)
	return group


## Adds a mesh; `at` is in model space (feet at the origin), whatever the parent.
func _part(
	parent: Node3D,
	mesh: Mesh,
	material: Material,
	at: Vector3,
	turn: Vector3 = Vector3.ZERO,
	stretch: Vector3 = Vector3.ONE
) -> MeshInstance3D:
	var part: MeshInstance3D = MeshInstance3D.new()
	part.mesh = mesh
	part.material_override = material
	parent.add_child(part)
	part.position = at - _model_offset(parent)
	part.rotation = turn
	part.scale = stretch
	return part


## Where a node of the rig sits in model space (the rig has no rotation while it is built).
func _model_offset(node: Node3D) -> Vector3:
	var offset: Vector3 = Vector3.ZERO
	var current: Node = node
	while current != self and current is Node3D:
		offset += (current as Node3D).position
		current = current.get_parent()
	return offset


func _flicker(node: Node3D) -> void:
	_flickers.append(node)
	_flicker_scales.append(node.scale)


## Cartoon material: toon light, an optional glow and a dark outline (inverted hull).
func _toon(
	color: Color, glow: Color = Color.BLACK, glow_strength: float = 0.0, outlined: bool = true
) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	material.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
	material.specular_mode = BaseMaterial3D.SPECULAR_TOON
	material.roughness = 0.8
	if glow_strength > 0.0:
		material.emission_enabled = true
		material.emission = glow
		material.emission_energy_multiplier = glow_strength
	if outlined:
		material.next_pass = _outline_material()
	return material


func _outline_material() -> StandardMaterial3D:
	if _outline == null:
		_outline = StandardMaterial3D.new()
		_outline.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_outline.albedo_color = OUTLINE_COLOR
		_outline.cull_mode = BaseMaterial3D.CULL_FRONT
		_outline.grow = true
		_outline.grow_amount = OUTLINE_GROW
	return _outline


func _shadow_material() -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(0.0, 0.0, 0.0, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material


static func _sphere(radius: float) -> SphereMesh:
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 24
	mesh.rings = 12
	return mesh


## A capsule `height` tall in all (Godot counts the round ends in the height).
static func _capsule(radius: float, height: float) -> CapsuleMesh:
	var mesh: CapsuleMesh = CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	return mesh


static func _cone(radius: float, height: float, sides: int = 14) -> CylinderMesh:
	var mesh: CylinderMesh = _cylinder(0.0, radius, height)
	mesh.radial_segments = sides
	return mesh


static func _cylinder(top_radius: float, bottom_radius: float, height: float) -> CylinderMesh:
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	mesh.radial_segments = 16
	mesh.rings = 1
	return mesh


static func _box(width: float, height: float, depth: float) -> BoxMesh:
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(width, height, depth)
	return mesh


## A ring lying flat (around the y axis).
static func _torus(inner_radius: float, outer_radius: float) -> TorusMesh:
	var mesh: TorusMesh = TorusMesh.new()
	mesh.inner_radius = inner_radius
	mesh.outer_radius = outer_radius
	return mesh
