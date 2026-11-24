extends GutTest
## The look of home (spec 09, G2, G4, G5, G18): the gradient background, the logo, coloured
## buttons with icons, a large yellow Play, icon chips and the fighter on a pedestal.

const HOME: PackedScene = preload("res://scenes/home.tscn")
const CONTROLS: String = "Margin/Column/Body/Controls"
const BUTTONS: Array[String] = [
	CONTROLS + "/PlayButton",
	CONTROLS + "/MoreRow/TrainingButton",
	CONTROLS + "/MoreRow/FightersButton",
	CONTROLS + "/MoreRow/InfoButton",
	CONTROLS + "/MoreRow/HackButton",
]


func before_each() -> void:
	GameState.reset()
	GameState.entrance_played = true


func _show_home(size: Vector2i = Vector2i(1280, 720)) -> Control:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = size
	add_child_autofree(viewport)
	var screen: Control = HOME.instantiate()
	viewport.add_child(screen)
	await wait_process_frames(2)
	return screen


func test_every_button_has_an_icon_and_its_own_colour() -> void:
	var screen: Control = await _show_home()
	var colours: Array[Color] = []
	for path: String in BUTTONS:
		var button: Button = screen.get_node(path)
		assert_not_null(button.icon, "%s has an icon" % button.name)
		var normal: StyleBoxFlat = button.get_theme_stylebox("normal") as StyleBoxFlat
		assert_false(colours.has(normal.bg_color), "%s has its own colour" % button.name)
		colours.append(normal.bg_color)


func test_play_is_the_largest_yellow_button() -> void:
	var screen: Control = await _show_home()
	var play: Button = screen.get_node(CONTROLS + "/PlayButton")
	assert_eq(play.theme_type_variation, &"PlayButton")
	var yellow: Color = (play.get_theme_stylebox("normal") as StyleBoxFlat).bg_color
	assert_gt(yellow.r, 0.9, "yellow")
	assert_gt(yellow.g, 0.7, "yellow")
	assert_lt(yellow.b, 0.3, "yellow")
	var play_area: float = play.size.x * play.size.y
	for path: String in BUTTONS.slice(1):
		var button: Button = screen.get_node(path)
		assert_gt(play_area, button.size.x * button.size.y, "Play is larger than %s" % path)


func test_play_sits_in_the_corner_when_wide_and_across_the_bottom_when_tall() -> void:
	var wide: Control = await _show_home(Vector2i(1280, 720))
	var play: Rect2 = wide.get_node(CONTROLS + "/PlayButton").get_global_rect()
	assert_gt(play.end.x, 1280.0 - 64.0, "right edge")
	assert_gt(play.end.y, 720.0 - 64.0, "bottom edge")
	var tall: Control = await _show_home(Vector2i(820, 1180))
	var buttons: Rect2 = tall.get_node(CONTROLS + "/MoreRow").get_global_rect()
	var tall_play: Rect2 = tall.get_node(CONTROLS + "/PlayButton").get_global_rect()
	assert_gt(tall_play.position.y, buttons.end.y, "under the other buttons")
	assert_gt(tall_play.size.x, 820 * 0.6, "across the screen")


func test_trophies_and_credits_are_icon_chips() -> void:
	GameState.credits = 77
	var screen: Control = await _show_home()
	var trophies: IconChip = screen.get_node("Margin/Column/TopBar/TrophiesChip")
	var credits: IconChip = screen.get_node("Margin/Column/TopBar/CreditsChip")
	assert_eq(trophies.get_node("Row/Icon").texture, Icons.get_icon("trophy"))
	assert_eq(credits.get_node("Row/Icon").texture, Icons.get_icon("coin"))
	assert_eq(trophies.text, str(GameState.total_trophies()))
	assert_eq(credits.text, "77")


func test_the_logo_has_two_outlined_colours_in_the_display_font() -> void:
	var screen: Control = await _show_home()
	var hack: Label = screen.get_node("Margin/Column/Title/Hack")
	var star: Label = screen.get_node("Margin/Column/Title/Star")
	assert_ne(hack.get_theme_color("font_color"), star.get_theme_color("font_color"))
	for word: Label in [hack, star]:
		assert_gt(word.get_theme_constant("outline_size"), 0, "%s is outlined" % word.text)
		var font: FontVariation = word.get_theme_font("font") as FontVariation
		assert_not_null(font, "%s uses the slanted logo font" % word.text)
		assert_ne(font.variation_transform.y.x, 0.0, "%s is slanted" % word.text)


func test_background_is_the_gradient_and_the_fighter_stands_on_a_pedestal() -> void:
	var screen: Control = await _show_home()
	var background: ColorRect = screen.get_node("Background")
	assert_true(background.material is ShaderMaterial, "a gradient, not a flat colour")
	assert_eq(background.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	var stage: FighterStage = screen.get_node("Margin/Column/Body/FighterStage")
	var pedestal: Node3D = stage.get_node("Viewport/Pedestal")
	assert_not_null(pedestal)
	for part: MeshInstance3D in pedestal.get_children():
		assert_true(ToonMaterials.is_toon(part.material_override), "%s is cel-shaded" % part.name)
		assert_not_null(part.material_override.next_pass, "%s is outlined" % part.name)
