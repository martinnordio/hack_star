class_name TargetDummy
extends StaticBody3D
## A still straw target dummy built from primitive meshes. A shot calls `hit(amount)`: the
## dummy flashes white, shows the damage as a number that rises and fades, and its health bar
## (two billboard quads) shrinks and turns yellow, then red. At 0 health it breaks apart (the
## parts fly out and fall, collision off) and after `respawn_seconds` it is back with full
## health. It is in the group `targets`, so a quick tap of the aim stick can aim at it.

signal broken
signal respawned

const BAR_WIDTH: float = 1.1
const BAR_HEIGHT: float = 0.14
const BAR_Y: float = 2.3
const FLASH_SECONDS: float = 0.1
const NUMBER_SECONDS: float = 0.8
const NUMBER_RISE: float = 0.8
const DEBRIS_GRAVITY: float = 14.0
const DEBRIS_SECONDS: float = 1.5
const POP_SECONDS: float = 0.2

const STRAW: Color = Color("e0b84a")
const STRAW_DARK: Color = Color("b98a2e")
const WOOD: Color = Color("7a4a26")
const TARGET_RED: Color = Color("e63b2e")
const TARGET_WHITE: Color = Color("fff4e0")
const BAR_BACK: Color = Color("2a1d1d")

## Only the materials are shared by all dummies (per colour); every dummy builds its own meshes.
static var _materials: Dictionary = {}

@export var respawn_seconds: float = Combat.RESPAWN_SECONDS

var health: int = Combat.DUMMY_HEALTH

var _flash_left: float = 0.0
var _respawn_left: float = 0.0
var _debris_left: float = 0.0
var _pop_left: float = 0.0
var _home: Array[Transform3D] = []
var _velocity: Array[Vector3] = []
var _spin: Array[Vector3] = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var _collision: CollisionShape3D = $Collision
@onready var _parts: Node3D = $Parts
@onready var _bar: Node3D = $Bar
@onready var _bar_fill: MeshInstance3D = $Bar/Fill


func _ready() -> void:
	_build_parts()
	_build_bar()
	for part: Node in _parts.get_children():
		_home.append((part as Node3D).transform)
	_show_health()


func _process(delta: float) -> void:
	if _flash_left > 0.0:
		_flash_left -= delta
		if _flash_left <= 0.0:
			_set_flash(false)
	if _debris_left > 0.0:
		_debris_left -= delta
		_move_debris(delta)
	if _pop_left > 0.0:
		_pop_left = maxf(_pop_left - delta, 0.0)
		scale = Vector3.ONE * lerpf(1.0, 0.6, _pop_left / POP_SECONDS)
	if _respawn_left > 0.0:
		_respawn_left -= delta
		if _respawn_left <= 0.0:
			_respawn()


func is_broken() -> bool:
	return Combat.is_broken(health)


## Takes `amount` damage: flash, damage number, a shorter bar; at 0 health it breaks apart.
func hit(amount: int) -> void:
	if is_broken():
		return
	health = Combat.take_damage(health, amount)
	_show_health()
	_show_number(amount)
	if is_broken():
		_break()
	else:
		_set_flash(true)
		_flash_left = FLASH_SECONDS


func _break() -> void:
	_collision.disabled = true
	_bar.visible = false
	_set_flash(false)
	_flash_left = 0.0
	_velocity.clear()
	_spin.clear()
	for index: int in _parts.get_child_count():
		var outward: Vector3 = Vector3(_home[index].origin.x, 0.0, _home[index].origin.z)
		if outward.is_zero_approx():
			outward = Vector3(_rng.randf_range(-1.0, 1.0), 0.0, _rng.randf_range(-1.0, 1.0))
		outward = outward.normalized() + Vector3(_rng.randf_range(-0.6, 0.6), 0.0, 0.0)
		_velocity.append(outward * _rng.randf_range(1.5, 3.5) + Vector3.UP * _rng.randf_range(3, 6))
		_spin.append(
			Vector3(_rng.randf_range(-6, 6), _rng.randf_range(-6, 6), _rng.randf_range(-6, 6))
		)
	_debris_left = DEBRIS_SECONDS
	_respawn_left = respawn_seconds
	broken.emit()


func _move_debris(delta: float) -> void:
	for index: int in _parts.get_child_count():
		var part: Node3D = _parts.get_child(index)
		if part.position.y <= 0.08 and _velocity[index].y < 0.0:
			_velocity[index] = Vector3.ZERO
			continue
		_velocity[index].y -= DEBRIS_GRAVITY * delta
		part.position += _velocity[index] * delta
		part.position.y = maxf(part.position.y, 0.08)
		part.rotation += _spin[index] * delta


func _respawn() -> void:
	health = Combat.DUMMY_HEALTH
	_debris_left = 0.0
	for index: int in _parts.get_child_count():
		(_parts.get_child(index) as Node3D).transform = _home[index]
	_collision.disabled = false
	_bar.visible = true
	_show_health()
	_pop_left = POP_SECONDS
	scale = Vector3.ONE * 0.6
	respawned.emit()


## The bar's fill is as long as the health share and has its colour; it grows from the left.
func _show_health() -> void:
	var ratio: float = Combat.health_ratio(health)
	var quad: QuadMesh = _bar_fill.mesh
	quad.size = Vector2(maxf(BAR_WIDTH * ratio, 0.001), BAR_HEIGHT)
	quad.center_offset = Vector3(-BAR_WIDTH / 2.0 + quad.size.x / 2.0, 0.0, 0.01)
	_bar_fill.material_override = _bar_material(Combat.health_color(ratio))


func _show_number(amount: int) -> void:
	var label: Label3D = Label3D.new()
	label.text = str(amount)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	label.shaded = false
	label.pixel_size = 0.008
	label.font_size = 72
	label.outline_size = 18
	label.modulate = Color("ffe14a")
	label.outline_modulate = Color("5a1a10")
	label.position = Vector3(0.0, BAR_Y + 0.3, 0.0)
	add_child(label)
	var tween: Tween = label.create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", BAR_Y + 0.3 + NUMBER_RISE, NUMBER_SECONDS)
	tween.tween_property(label, "modulate:a", 0.0, NUMBER_SECONDS)
	tween.chain().tween_callback(label.queue_free)


func _set_flash(on: bool) -> void:
	for part: Node in _parts.get_children():
		(part as MeshInstance3D).material_overlay = _flash_material() if on else null


## Straw body on a post with a painted target, arms and a round head.
func _build_parts() -> void:
	_part("Post", _cylinder(0.09, 0.09, 1.0), WOOD, Vector3(0.0, 0.5, 0.0))
	_part("Body", _cylinder(0.42, 0.46, 1.0), STRAW, Vector3(0.0, 1.0, 0.0))
	_part("Arms", _box(Vector3(1.3, 0.14, 0.14)), WOOD, Vector3(0.0, 1.35, -0.05))
	_part("Head", _sphere(0.24), STRAW_DARK, Vector3(0.0, 1.78, 0.0))
	var rings: Array[Array] = [[0.36, TARGET_RED], [0.25, TARGET_WHITE], [0.13, TARGET_RED]]
	for index: int in rings.size():
		var ring: MeshInstance3D = _part(
			"Ring%d" % index,
			_cylinder(rings[index][0], rings[index][0], 0.04),
			rings[index][1],
			Vector3(0.0, 1.0, 0.44 + 0.012 * index)
		)
		ring.rotation.x = PI / 2.0


func _build_bar() -> void:
	_bar.position = Vector3(0.0, BAR_Y, 0.0)
	var back: MeshInstance3D = MeshInstance3D.new()
	back.name = "Back"
	var back_mesh: QuadMesh = QuadMesh.new()
	back_mesh.size = Vector2(BAR_WIDTH + 0.08, BAR_HEIGHT + 0.08)
	back.mesh = back_mesh
	back.material_override = _bar_material(BAR_BACK)
	back.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_bar.add_child(back)
	_bar_fill.mesh = QuadMesh.new()
	_bar_fill.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _part(part_name: String, mesh: Mesh, color: Color, at: Vector3) -> MeshInstance3D:
	var part: MeshInstance3D = MeshInstance3D.new()
	part.name = part_name
	part.mesh = mesh
	part.material_override = _material(color)
	part.position = at
	_parts.add_child(part)
	return part


static func _cylinder(top: float, bottom: float, height: float) -> CylinderMesh:
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = top
	mesh.bottom_radius = bottom
	mesh.height = height
	mesh.radial_segments = 14
	mesh.rings = 1
	return mesh


static func _box(size: Vector3) -> BoxMesh:
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	return mesh


static func _sphere(radius: float) -> SphereMesh:
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 12
	mesh.rings = 6
	return mesh


static func _material(color: Color) -> StandardMaterial3D:
	var key: String = "plain %s" % color.to_html()
	if not _materials.has(key):
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.albedo_color = color
		material.roughness = 1.0
		_materials[key] = material
	return _materials[key]


static func _bar_material(color: Color) -> StandardMaterial3D:
	var key: String = "bar %s" % color.to_html()
	if not _materials.has(key):
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
		material.albedo_color = color
		_materials[key] = material
	return _materials[key]


static func _flash_material() -> StandardMaterial3D:
	if not _materials.has("flash"):
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.albedo_color = Color(1.0, 1.0, 1.0, 0.75)
		_materials["flash"] = material
	return _materials["flash"]
