class_name DamageNumber
extends RefCounted
## The damage a hit did, as a number that rises above the body and fades away.

const SECONDS: float = 0.8
const RISE: float = 0.8
const OUTLINE_COLOR: Color = Color("5a1a10")


## Shows `amount` in `color` at `at` (local to `parent`); it frees itself after `SECONDS`.
static func spawn(parent: Node3D, at: Vector3, amount: int, color: Color) -> Label3D:
	var label: Label3D = Label3D.new()
	label.text = str(amount)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	label.shaded = false
	label.pixel_size = 0.008
	label.font_size = 72
	label.outline_size = 18
	label.modulate = color
	label.outline_modulate = OUTLINE_COLOR
	label.position = at
	parent.add_child(label)
	var tween: Tween = label.create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", at.y + RISE, SECONDS)
	tween.tween_property(label, "modulate:a", 0.0, SECONDS)
	tween.chain().tween_callback(label.queue_free)
	return label
