class_name HealthBar
extends Node3D
## A health bar above a body: a dark back and a fill that grows from the left, both billboard
## quads. The fill has `fixed_color` when it is set (alpha above 0), else the colour of
## `Combat.health_color`.

const WIDTH: float = 1.1
const HEIGHT: float = 0.14
const BACK_COLOR: Color = Color("2a1d1d")

static var _materials: Dictionary = {}

## Leave transparent to colour the fill by the health share.
var fixed_color: Color = Color.TRANSPARENT

var _fill: MeshInstance3D


func _ready() -> void:
	var back: MeshInstance3D = MeshInstance3D.new()
	back.name = "Back"
	var back_mesh: QuadMesh = QuadMesh.new()
	back_mesh.size = Vector2(WIDTH + 0.08, HEIGHT + 0.08)
	back.mesh = back_mesh
	back.material_override = _material(BACK_COLOR)
	back.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(back)
	_fill = MeshInstance3D.new()
	_fill.name = "Fill"
	_fill.mesh = QuadMesh.new()
	_fill.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_fill)
	show_ratio(1.0)


## The fill is as long as `ratio` (0 to 1) of the bar and shows its colour.
func show_ratio(ratio: float) -> void:
	var quad: QuadMesh = _fill.mesh
	quad.size = Vector2(maxf(WIDTH * ratio, 0.001), HEIGHT)
	quad.center_offset = Vector3(-WIDTH / 2.0 + quad.size.x / 2.0, 0.0, 0.01)
	var color: Color = Combat.health_color(ratio) if fixed_color.a <= 0.0 else fixed_color
	_fill.material_override = _material(color)


static func _material(color: Color) -> StandardMaterial3D:
	var key: String = color.to_html()
	if not _materials.has(key):
		var material: StandardMaterial3D = StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
		material.albedo_color = color
		_materials[key] = material
	return _materials[key]
