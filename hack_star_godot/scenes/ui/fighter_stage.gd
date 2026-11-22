class_name FighterStage
extends SubViewportContainer
## A live 3D fighter inside a 2D screen: a sub-viewport with its own 3D world, a camera, two
## lights and one `FighterModel`, standing on a round pedestal (spec 09, D6). The camera keeps
## the whole fighter (and the pedestal) in view whether the stage is wide or tall.

const PEDESTAL_SIDE: Color = Color(0.25, 0.27, 0.68)
const PEDESTAL_RIM: Color = Color(0.96, 0.82, 0.52)
const PEDESTAL_TOP: Color = Color(0.5, 0.5, 0.88)
const PEDESTAL_HEIGHT: float = 0.32
## The camera when the pedestal shows: a little farther and higher, so its front edge is in view.
const PEDESTAL_CAMERA_POSITION: Vector3 = Vector3(0.0, 1.75, 7.4)
const PEDESTAL_CAMERA_TILT: float = -0.1

## The fighter stands on a pedestal. Off for the card pictures (set before the stage is added).
@export var pedestal: bool = true

var model: FighterModel:
	get:
		return $Viewport/FighterModel

@onready var camera: Camera3D = $Viewport/Camera


func _ready() -> void:
	if pedestal:
		_build_pedestal()
		camera.position = PEDESTAL_CAMERA_POSITION
		camera.rotation.x = PEDESTAL_CAMERA_TILT
	resized.connect(_fit_camera)
	_fit_camera()


## Shows a fighter in one of its skins.
func show_fighter(fighter_id: String, skin_id: String = Fighters.DEFAULT_SKIN) -> void:
	model.setup(fighter_id, skin_id)


func _fit_camera() -> void:
	# A tall stage keeps the width in view, a wide one the height, so nothing is cut off.
	if size.x < size.y:
		camera.keep_aspect = Camera3D.KEEP_WIDTH
	else:
		camera.keep_aspect = Camera3D.KEEP_HEIGHT


# A cel-shaded, outlined drum: blue sides, a golden rim and a lighter top just under the feet.
func _build_pedestal() -> void:
	var root: Node3D = Node3D.new()
	root.name = "Pedestal"
	$Viewport.add_child(root)
	_drum(root, "Side", 1.2, 1.38, PEDESTAL_HEIGHT, PEDESTAL_SIDE, -PEDESTAL_HEIGHT / 2.0 - 0.06)
	_drum(root, "Rim", 1.24, 1.24, 0.1, PEDESTAL_RIM, -0.05)
	_drum(root, "Top", 1.08, 1.08, 0.02, PEDESTAL_TOP, -0.005)


static func _drum(
	parent: Node3D,
	part_name: String,
	top_radius: float,
	bottom_radius: float,
	height: float,
	color: Color,
	center_y: float
) -> void:
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	mesh.radial_segments = 48
	mesh.rings = 1
	var part: MeshInstance3D = MeshInstance3D.new()
	part.name = part_name
	part.mesh = mesh
	part.material_override = ToonMaterials.toon(color)
	part.position.y = center_y
	part.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(part)
