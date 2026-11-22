extends GutTest
## Living cards on the fighter list (spec 09, M10, D40, D41): the cards of the animated fighters
## show their figure idling and walking and a light sweep in the rarity's colour, only while they
## are in the visible part of the list; a locked card stays grey and still; the figure stays on
## its card at the five screen sizes.

const LIST: PackedScene = preload("res://scenes/fighter_list.tscn")
const GRID_PATH: String = "Margin/Column/Scroll/Grid"
const SIZES: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1180, 820),
	Vector2i(820, 1180),
	Vector2i(390, 844),
	Vector2i(844, 390)
]

var _root_size: Vector2i


func before_each() -> void:
	GameState.reset()
	_root_size = get_tree().root.size
	get_tree().root.size = Vector2i(1280, 720)


func after_each() -> void:
	get_tree().root.size = _root_size
	GameState.reset()


func _show_list() -> Control:
	var screen: Control = autofree(LIST.instantiate())
	add_child(screen)
	await wait_process_frames(2)
	return screen


func _card(screen: Control, fighter_id: String) -> FighterCard:
	var card: FighterCard = screen.get_node(GRID_PATH).get_node(fighter_id.capitalize())
	return card


func _scroll_to_end(screen: Control) -> void:
	(screen.get_node("Margin/Column/Scroll") as ScrollContainer).scroll_vertical = 100000
	await wait_process_frames(2)


func _progress(card: FighterCard) -> float:
	return (card.get_sweep().material as ShaderMaterial).get_shader_parameter("progress")


func test_only_the_animated_fighters_cards_live() -> void:
	var screen: Control = await _show_list()
	for card: FighterCard in screen.get_node(GRID_PATH).get_children():
		var animated: bool = CutoutFighters.has(card.fighter_id)
		assert_eq(card.is_living(), animated, card.fighter_id)
		assert_eq(card.get_figure() != null, animated, "%s: a figure" % card.fighter_id)


func test_the_figure_idles_then_walks_on_the_card() -> void:
	var screen: Control = await _show_list()
	await _scroll_to_end(screen)
	var card: FighterCard = _card(screen, "magmax")
	card.set_process(false)
	var figure: TextureRect = card.get_figure()
	assert_eq(figure.texture, CutoutFighters.frame("magmax", "idle_down"), "the front idle")
	var backdrop: Control = card.get_node("Column/Backdrop")
	assert_almost_eq(
		figure.size.y, backdrop.custom_minimum_size.y * FighterCard.FIGURE_SHARE, 0.5, "60 %"
	)
	var scales: Array[float] = []
	for i: int in 10:
		card._process(0.1)
		scales.append(figure.scale.y)
		assert_eq(figure.texture, CutoutFighters.frame("magmax", "idle_down"))
	assert_gt(scales.max() - scales.min(), 0.01, "it breathes")
	card._process(FighterCard.FIGURE_IDLE_SECONDS - 1.0 + 0.01)
	var walk: Array[Texture2D] = []
	var hops: Array[float] = []
	for i: int in 4:
		walk.append(figure.texture)
		hops.append(figure.position.y)
		card._process(1.0 / FighterCard.FIGURE_WALK_FPS)
	for index: int in 4:
		assert_eq(
			walk[index], CutoutFighters.frame("magmax", "walk_down", index), "walk %d" % index
		)
	assert_lt(hops.min(), -1.0, "it hops")
	card._process(FighterCard.FIGURE_WALK_SECONDS)
	assert_eq(figure.texture, CutoutFighters.frame("magmax", "idle_down"), "then idles again")


func test_a_light_sweep_in_the_rarity_colour_crosses_every_few_seconds() -> void:
	var screen: Control = await _show_list()
	await _scroll_to_end(screen)
	var echo: FighterCard = _card(screen, "echo")
	var magmax: FighterCard = _card(screen, "magmax")
	var material: ShaderMaterial = echo.get_sweep().material
	assert_eq(material.shader, FighterCard.SWEEP_SHADER)
	assert_eq(
		material.get_shader_parameter("band_color"),
		Rarity.color(Fighters.get_fighter("echo")["rarity"]).lerp(Color.WHITE, 0.55)
	)
	assert_eq(echo.get_sweep().texture, CutoutFighters.card("echo"), "only over the picture")
	echo.set_process(false)
	magmax.set_process(false)
	var crossed: Array[float] = []
	var both: int = 0
	for i: int in int(FighterCard.SWEEP_PERIOD / 0.05):
		echo._process(0.05)
		magmax._process(0.05)
		if _progress(echo) > -1.0:
			crossed.append(_progress(echo))
			if _progress(magmax) > -1.0:
				both += 1
	assert_gt(crossed.size(), 5, "it crosses once a period")
	assert_lt(crossed.size(), int(FighterCard.SWEEP_SECONDS / 0.05) + 2, "and only once")
	assert_lt(crossed[0], 0.0, "from the top left")
	assert_gt(crossed[-1], 1.0, "to the bottom right")
	assert_lt(both, crossed.size(), "the next card sweeps later")


func test_only_cards_in_the_visible_part_of_the_list_animate() -> void:
	var screen: Control = await _show_list()
	var card: FighterCard = _card(screen, "echo")
	card.set_process(false)
	assert_false(card.is_on_screen(), "below the visible part at the start")
	var scale: Vector2 = card.get_figure().scale
	var progress: float = _progress(card)
	card._process(1.7)
	assert_eq(card.get_figure().scale, scale, "still off screen")
	assert_eq(_progress(card), progress)
	await _scroll_to_end(screen)
	assert_true(card.is_on_screen())
	card._process(FighterCard.FIGURE_IDLE_SECONDS + 0.05)
	assert_ne(card.get_figure().texture, CutoutFighters.frame("echo", "idle_down"), "walks")


func test_a_locked_card_stays_grey_and_still() -> void:
	GameState.unlocked.erase("echo")
	var screen: Control = await _show_list()
	var card: FighterCard = _card(screen, "echo")
	assert_false(card.is_living())
	assert_false(card.is_processing(), "nothing runs")
	assert_true(card.is_picture_grey())
	assert_eq(card.backdrop_color(), FighterCard.LOCKED_BACKDROP)
	GameState.unlocked.append("echo")
	GameState.progress_changed.emit()
	assert_true(card.is_living(), "unlocked, it lives")
	assert_true(card.get_figure().get_parent().visible)
	GameState.unlocked.erase("echo")
	GameState.progress_changed.emit()
	assert_false(card.get_figure().get_parent().visible, "locked again: no figure")
	assert_false(card.get_sweep().visible, "and no sweep")


func test_the_figure_stays_on_its_card_at_every_size() -> void:
	var base: Vector2 = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	for size: Vector2i in SIZES:
		var viewport: SubViewport = SubViewport.new()
		viewport.size = size
		var content: Vector2 = Vector2(size) / UiScale.total(Vector2(size), base)
		viewport.size_2d_override = Vector2i(content.round())
		viewport.size_2d_override_stretch = true
		add_child_autofree(viewport)
		var screen: Control = LIST.instantiate()
		viewport.add_child(screen)
		await wait_process_frames(2)
		var scroll: ScrollContainer = screen.get_node("Margin/Column/Scroll")
		assert_lte(screen.get_node(GRID_PATH).size.x, scroll.size.x + 0.5, "%s fits" % size)
		for fighter_id: String in CutoutFighters.FIGHTERS:
			var card: FighterCard = screen.get_node(GRID_PATH).get_node(fighter_id.capitalize())
			var backdrop: Rect2 = (card.get_node("Column/Backdrop") as Control).get_global_rect()
			var box: Rect2 = card.get_figure().get_parent().get_global_rect()
			assert_true(
				backdrop.grow(0.5).encloses(box),
				"%s %s: %s in %s" % [size, fighter_id, box, backdrop]
			)
		viewport.queue_free()
