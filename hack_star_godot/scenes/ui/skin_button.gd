class_name SkinButton
extends Button
## One skin on the fighter screen: its name and rarity (in the rarity's colour); choosing it
## previews it. Legendary skins have a gold frame.

var skin_id: String = ""


## Fills the button from a skin of the catalogue; the buttons of one `group` choose one skin.
## Colours, sizes and the gold frame of a Legendary skin come from the theme.
func setup(skin: Dictionary, group: ButtonGroup) -> void:
	skin_id = skin["id"]
	var rarity: String = skin["rarity"]
	text = skin["name"] if rarity.is_empty() else "%s\n%s" % [skin["name"], rarity]
	toggle_mode = true
	button_group = group
	if not rarity.is_empty():
		for color_name: String in ["font_color", "font_hover_color", "font_pressed_color"]:
			add_theme_color_override(color_name, Rarity.color(rarity))
		add_theme_color_override("font_hover_pressed_color", Rarity.color(rarity))
	theme_type_variation = &"LegendarySkinButton" if rarity == "Legendary" else &"SkinButton"
