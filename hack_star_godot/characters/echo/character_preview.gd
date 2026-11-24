# Attach to the Node3D that sits on top of the podium in your character-select scene.
# Call show_character(scene) when the player picks a character or skin.
extends Node3D

@export var spin_speed := 0.0          # set > 0 for a slow turntable spin (works best with billboard = 0)
@export var bob_height := 0.04         # gentle idle float
@export var bob_speed := 2.0

var _current: Node3D
var _t := 0.0

func show_character(scene: PackedScene) -> void:
	if _current:
		_current.queue_free()
	_current = scene.instantiate()
	add_child(_current)
	# little "pop-in" when a new character is selected
	_current.scale = Vector3.ONE * 0.6
	create_tween().tween_property(_current, "scale", Vector3.ONE, 0.25) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	if not _current:
		return
	_t += delta
	_current.position.y = sin(_t * bob_speed) * bob_height
	if spin_speed > 0.0:
		_current.rotate_y(spin_speed * delta)
