class_name FighterStage
extends SubViewportContainer
## A live 3D fighter inside a 2D screen: a sub-viewport with its own 3D world, a camera, two
## lights and one `FighterModel`. The camera keeps the whole fighter in view whether the stage
## is wide or tall.

var model: FighterModel:
	get:
		return $Viewport/FighterModel

@onready var camera: Camera3D = $Viewport/Camera


func _ready() -> void:
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
