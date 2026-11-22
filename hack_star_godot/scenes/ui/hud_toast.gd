class_name HudToast
extends PanelContainer
## A short message at the top centre of the arena's HUD on a dark backing (spec 09, V3, L5,
## D25): the name of a camera view or a lighting preset, shown for `SHOW_SECONDS`, then faded.

const SHOW_SECONDS: float = 1.5
const FADE_SECONDS: float = 0.3
## Below the match's timer chip.
const TOP: float = 84.0

var _label: Label = Label.new()
var _tween: Tween


func _init() -> void:
	name = "HudToast"
	theme_type_variation = &"ChipPanel"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_CENTER_TOP)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	offset_top = TOP
	_label.name = "Label"
	_label.theme_type_variation = &"HudLabel"
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_label)
	hide()


## Shows `text` again from the start, also while an earlier message is still showing.
func show_text(text: String) -> void:
	_label.text = text
	if _tween != null:
		_tween.kill()
	modulate.a = 1.0
	# Shrunk to nothing: the container grows back to the new text equally on both sides.
	offset_left = 0.0
	offset_right = 0.0
	show()
	_tween = create_tween()
	_tween.tween_interval(SHOW_SECONDS)
	_tween.tween_property(self, "modulate:a", 0.0, FADE_SECONDS)
	_tween.tween_callback(hide)


func text() -> String:
	return _label.text
