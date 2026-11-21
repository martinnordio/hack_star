class_name SkinButton
extends Button
## One skin on the fighter screen: its name and rarity (in the rarity's colour); choosing it
## previews it. Legendary skins have a gold frame.

const BACKGROUND: Color = Color(0.15, 0.17, 0.26)
const BACKGROUND_HOVER: Color = Color(0.22, 0.25, 0.37)
const BACKGROUND_CHOSEN: Color = Color(0.42, 0.27, 0.85)
const BORDER: Color = Color(0.3, 0.34, 0.5)
const BORDER_WIDTH: int = 3
const FRAME_WIDTH: int = 6

var skin_id: String = ""


## Fills the button from a skin of the catalogue; the buttons of one `group` choose one skin.
func setup(skin: Dictionary, group: ButtonGroup) -> void:
	skin_id = skin["id"]
	var rarity: String = skin["rarity"]
	text = skin["name"] if rarity.is_empty() else "%s\n%s" % [skin["name"], rarity]
	toggle_mode = true
	button_group = group
	add_theme_font_size_override("font_size", 28)
	if not rarity.is_empty():
		for color_name: String in ["font_color", "font_hover_color", "font_pressed_color"]:
			add_theme_color_override(color_name, Rarity.color(rarity))
		add_theme_color_override("font_hover_pressed_color", Rarity.color(rarity))
	var legendary: bool = rarity == "Legendary"
	var border: Color = Rarity.LEGENDARY_GOLD if legendary else BORDER
	var width: int = FRAME_WIDTH if legendary else BORDER_WIDTH
	add_theme_stylebox_override("normal", _style(BACKGROUND, border, width))
	add_theme_stylebox_override("hover", _style(BACKGROUND_HOVER, border, width))
	add_theme_stylebox_override("focus", _style(BACKGROUND_HOVER, border, width))
	add_theme_stylebox_override("pressed", _style(BACKGROUND_CHOSEN, border, width))
	add_theme_stylebox_override("hover_pressed", _style(BACKGROUND_CHOSEN, border, width))


static func _style(background: Color, border: Color, width: int) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(20)
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0
	return style
