class_name IconChip
extends PanelContainer
## A small chip on a dark rounded backing: an icon and a number or a short word in the display
## font (trophies, credits, power, timer, fighters left; spec 09, D7).

## The icon's name in `Icons`.
@export var icon_name: String = "trophy":
	set(value):
		icon_name = value
		_update()
## The colour the white icon is tinted with.
@export var icon_color: Color = Color(1.0, 0.82, 0.2):
	set(value):
		icon_color = value
		_update()
## The number or word next to the icon.
@export var text: String = "":
	set(value):
		if value != text:
			text = value
			_update()
## The colour of the number (white, or for example red for a timer running out).
@export var text_color: Color = Color.WHITE:
	set(value):
		if value != text_color:
			text_color = value
			_update()


func _ready() -> void:
	_update()


func _update() -> void:
	if not is_node_ready():
		return
	var icon: TextureRect = $Row/Icon
	icon.texture = Icons.get_icon(icon_name)
	icon.modulate = icon_color
	var label: Label = $Row/Label
	label.text = text
	label.add_theme_color_override("font_color", text_color)
