extends GutTest
## The new look of the result, info, hack and QR screens (spec 09, G2, G13): the gradient
## background, coloured buttons with icons, the trophy icon and the fighter on its pedestal.

const RESULT_SCENE: PackedScene = preload("res://scenes/result_screen.tscn")
const INFO_SCENE: PackedScene = preload("res://scenes/info.tscn")
const HACK_SCENE: PackedScene = preload("res://scenes/hack_screen.tscn")
const QR_SCENE: PackedScene = preload("res://scenes/qr_page.tscn")
const CONTENT: String = "Margin/Column/Scroll/Content"


func before_each() -> void:
	GameState.reset()
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {"status": 200, "body": "[]"}


func after_each() -> void:
	HackServer.fake_responder = Callable()
	GameState.reset()


func _show(scene: PackedScene) -> Control:
	var screen: Control = scene.instantiate()
	add_child_autofree(screen)
	return screen


func _assert_button(button: Button, variation: StringName, icon_name: String) -> void:
	assert_eq(button.theme_type_variation, variation, "%s colour" % button.name)
	assert_eq(button.icon, Icons.get_icon(icon_name), "%s icon" % button.name)


func test_every_screen_has_the_gradient_and_a_back_arrow_or_no_back() -> void:
	GameState.last_result = {
		"outcome": Match.Result.VICTORY, "place": 1, "fighter": "blaze", "skin": "default"
	}
	for scene: PackedScene in [RESULT_SCENE, INFO_SCENE, HACK_SCENE, QR_SCENE]:
		var screen: Control = _show(scene)
		var background: ColorRect = screen.get_node("Background")
		assert_true(background.material is ShaderMaterial, "%s: gradient" % screen.name)
		var back: Button = screen.get_node_or_null("Margin/Column/Header/BackButton")
		if back != null:
			assert_eq(back.icon, Icons.get_icon("back"), "%s: back arrow" % screen.name)
		var scroll: ScrollContainer = screen.get_node_or_null("Margin/Column/Scroll")
		if scroll != null:
			assert_eq(scroll.theme_type_variation, &"ContentScroll", "%s: dark panel" % screen.name)


func test_result_has_a_yellow_play_again_a_trophy_icon_and_the_pedestal() -> void:
	GameState.last_result = {
		"outcome": Match.Result.VICTORY,
		"place": 1,
		"fighter": "blaze",
		"skin": "default",
		"reward": Trophies.reward(1990, Match.Result.VICTORY, GameState.match_settings),
	}
	var screen: Control = _show(RESULT_SCENE)
	_assert_button(
		screen.get_node("Margin/Column/Body/Controls/PlayAgainButton"), &"PlayButton", "play"
	)
	_assert_button(screen.get_node("Margin/Column/Body/Controls/HomeButton"), &"BlueButton", "home")
	var trophy: TextureRect = screen.get_node("Margin/Column/TrophyPanel/TrophyIcon")
	assert_eq(trophy.texture, Icons.get_icon("trophy"))
	var heading: Label = screen.get_node("Margin/Column/Heading")
	assert_eq(heading.get_theme_color("font_color"), screen.VICTORY_COLOR)
	assert_not_null(screen.get_node("Margin/Column/Body/FighterStage/Viewport/Pedestal"))
	screen.finish_count()
	var change: Label = screen.get_node("Margin/Column/TrophyPanel/Trophies/ChangeLabel")
	assert_eq(change.get_theme_color("font_color"), screen.GAIN_COLOR, "a gain is green")


func test_hack_buttons_have_their_colours_and_icons() -> void:
	var screen: Control = _show(HACK_SCENE)
	_assert_button(screen.get_node(CONTENT + "/CodeRow/UseButton"), &"GreenButton", "check")
	_assert_button(screen.get_node(CONTENT + "/ScanButton"), &"BlueButton", "eye")
	_assert_button(screen.get_node(CONTENT + "/ResetButton"), &"PinkButton", "close")
	_assert_button(screen.get_node(CONTENT + "/QrButton"), &"", "qr")
