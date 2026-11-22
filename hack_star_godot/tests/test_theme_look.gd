extends GutTest
## The shared theme's look (spec 09, Step 2): the display font, the coloured buttons and their
## press and hover states, the icons and the icon chip.

const THEME: Theme = preload("res://scenes/ui/hack_star_theme.tres")
const DISPLAY_FONT: Font = preload("res://assets/fonts/LilitaOne-Regular.ttf")
const ICON_CHIP: PackedScene = preload("res://scenes/ui/icon_chip.tscn")
const BUTTONS: Array[StringName] = [
	&"Button", &"PlayButton", &"GreenButton", &"BlueButton", &"PinkButton", &"IconButton"
]


func test_display_font_with_outline_on_titles_buttons_and_numbers() -> void:
	var controls: Array[Control] = [Button.new()]
	for type: StringName in [&"HeadingLabel", &"SubheadingLabel", &"HudLabel", &"NumberLabel"]:
		var label: Label = Label.new()
		label.theme_type_variation = type
		controls.append(label)
	for control: Control in controls:
		control.theme = THEME
		add_child_autofree(control)
		var type: String = control.get_class() + ":" + control.theme_type_variation
		assert_eq(control.get_theme_font(&"font"), DISPLAY_FONT, type)
		assert_gt(control.get_theme_constant(&"outline_size"), 0, "%s outline" % type)


func test_body_text_keeps_the_default_font() -> void:
	assert_false(THEME.has_font(&"font", &"Label"), "plain labels stay readable")
	assert_null(THEME.default_font)


func test_every_button_colour_reacts_to_hover_and_press() -> void:
	for type: StringName in BUTTONS:
		var normal: StyleBoxFlat = _style(type, &"normal")
		var hover: StyleBoxFlat = _style(type, &"hover")
		var pressed: StyleBoxFlat = _style(type, &"pressed")
		assert_gt(
			hover.bg_color.get_luminance(), normal.bg_color.get_luminance(), "%s hover" % type
		)
		assert_lt(pressed.bg_color.get_luminance(), normal.bg_color.get_luminance(), type)
		assert_gt(pressed.content_margin_top, normal.content_margin_top, "%s moves down" % type)
		assert_lt(pressed.border_width_bottom, normal.border_width_bottom, "%s edge" % type)
		assert_eq(_style(type, &"hover_pressed"), pressed, "%s pressed under the mouse" % type)


func test_button_colours_differ() -> void:
	var colours: Array[Color] = []
	for type: StringName in [&"PlayButton", &"GreenButton", &"BlueButton", &"PinkButton"]:
		var colour: Color = _style(type, &"normal").bg_color
		assert_false(colours.has(colour), "%s has its own colour" % type)
		colours.append(colour)


func test_focus_is_a_ring_not_a_hover() -> void:
	var focus: StyleBoxFlat = THEME.get_stylebox(&"focus", &"Button")
	assert_false(focus.draw_center)
	assert_ne(focus, THEME.get_stylebox(&"hover", &"Button"))


func test_every_icon_exists() -> void:
	for icon_name: String in Icons.names():
		var icon: Texture2D = Icons.get_icon(icon_name)
		assert_not_null(icon, icon_name)
		if icon != null:
			assert_gte(icon.get_width(), 64, icon_name)
	assert_null(Icons.get_icon("no such icon"))


func test_drawn_icons_have_a_shape() -> void:
	for icon_name: String in Icons.DRAWN:
		var image: Image = Icons.get_icon(icon_name).get_image()
		var opaque: int = 0
		for y: int in range(0, image.get_height(), 4):
			for x: int in range(0, image.get_width(), 4):
				if image.get_pixel(x, y).a > 0.5:
					opaque += 1
		assert_between(opaque, 20, 200, "%s is drawn, not empty or full" % icon_name)


func test_icon_chip_shows_its_icon_and_number() -> void:
	var chip: IconChip = autofree(ICON_CHIP.instantiate())
	chip.icon_name = "coin"
	chip.text = "500"
	add_child(chip)
	var label: Label = chip.get_node("Row/Label")
	var icon: TextureRect = chip.get_node("Row/Icon")
	assert_eq(label.text, "500")
	assert_eq(icon.texture, Icons.get_icon("coin"))
	chip.text = "1755"
	assert_eq(label.text, "1755", "the number updates")
	assert_eq(chip.theme_type_variation, &"ChipPanel")


func _style(type: StringName, state: StringName) -> StyleBoxFlat:
	var button: Button = Button.new()
	button.theme = THEME
	button.theme_type_variation = type
	add_child_autofree(button)
	return button.get_theme_stylebox(state) as StyleBoxFlat
