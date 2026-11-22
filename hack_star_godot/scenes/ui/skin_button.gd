class_name SkinButton
extends Button
## One skin on the fighter screen (spec 09, G8): a picture of the fighter in that skin, its name
## and rarity (in the rarity's colour), framed in the rarity's colour — Legendary in a thicker
## gold frame; the Default skin keeps the plain frame. Choosing it previews it.

const STYLES: Array[String] = ["normal", "hover", "pressed", "hover_pressed", "focus"]

var skin_id: String = ""


## Fills the button from a skin of the catalogue; the buttons of one `group` choose one skin.
## Sizes and the plain and Legendary frames come from the theme.
func setup(skin: Dictionary, group: ButtonGroup) -> void:
	skin_id = skin["id"]
	var rarity: String = skin["rarity"]
	text = skin["name"] if rarity.is_empty() else "%s\n%s" % [skin["name"], rarity]
	toggle_mode = true
	button_group = group
	theme_type_variation = &"LegendarySkinButton" if rarity == "Legendary" else &"SkinButton"
	if rarity.is_empty():
		return
	var color: Color = Rarity.color(rarity)
	for color_name: String in ["font_color", "font_hover_color", "font_pressed_color"]:
		add_theme_color_override(color_name, color)
	add_theme_color_override("font_hover_pressed_color", color)
	for style_name: String in STYLES:
		var style: StyleBoxFlat = get_theme_stylebox(style_name).duplicate()
		style.border_color = color
		add_theme_stylebox_override(style_name, style)


## The colour of the frame around the picture.
func frame_color() -> Color:
	return (get_theme_stylebox("normal") as StyleBoxFlat).border_color


## Shows the fighter in this skin (null while the picture is not rendered yet).
func set_picture(texture: Texture2D) -> void:
	icon = texture
