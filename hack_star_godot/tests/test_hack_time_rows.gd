extends GutTest
## The time left of each active hack on the hack screen (spec 16, S18, S23, D5).

const HACK_SCENE: PackedScene = preload("res://scenes/hack_screen.tscn")
const TEST_SAVE: String = "user://test/hack_time_rows.json"
const LIST_PATH: String = "Margin/Column/Scroll/Content/ActiveList"
const START: int = 1_764_000_000
const SIZES: Dictionary = {
	"desktop 1280x720": Vector2i(1280, 720),
	"iPad landscape 1180x820": Vector2i(1180, 820),
	"iPad portrait 820x1180": Vector2i(820, 1180),
	"phone portrait 390x844": Vector2i(390, 844),
	"phone landscape 844x390": Vector2i(844, 390),
}

var _now: int = START
var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()
	_now = START
	GameState.clock = func() -> int: return _now


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


func _activate_all() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	GameState.activate_hack(Hacks.POWER22)


func _show_screen() -> Control:
	var screen: Control = autofree(HACK_SCENE.instantiate())
	add_child(screen)
	return screen


func _listed(screen: Control) -> Array[String]:
	var texts: Array[String] = []
	for row: Label in screen.get_node(LIST_PATH).get_children():
		texts.append(row.text)
	return texts


func test_each_row_says_how_long_the_hack_stays_or_that_it_lasts_for_ever() -> void:
	_activate_all()
	_now += Hacks.DAY_SECONDS + 5 * Hacks.HOUR_SECONDS
	var screen: Control = _show_screen()
	assert_eq(
		_listed(screen),
		[
			"Unlimited credits · 1 day 19 hours left",
			"Unlock everything · 1 day 19 hours left",
			"Power 22 · Lasts for ever",
		]
	)


func test_the_rows_are_refreshed_once_a_minute() -> void:
	_activate_all()
	var screen: Control = _show_screen()
	assert_eq(_listed(screen)[0], "Unlimited credits · 3 days left")
	_now += 2 * Hacks.DAY_SECONDS
	var timer: Timer = screen.get_node("RefreshTimer")
	assert_eq(timer.wait_time, 60.0)
	assert_false(timer.is_stopped())
	timer.timeout.emit()
	assert_eq(_listed(screen)[0], "Unlimited credits · 1 day left")


func test_a_hack_that_turns_off_leaves_the_list_at_once() -> void:
	_activate_all()
	var screen: Control = _show_screen()
	_now += Hacks.TIMED_SECONDS
	GameState.expire_hacks()
	assert_eq(_listed(screen), ["Power 22 · Lasts for ever"])


func test_turning_all_hacks_off_empties_the_list() -> void:
	_activate_all()
	var screen: Control = _show_screen()
	GameState.reset_hacks()
	assert_eq(_listed(screen), ["No hacks active"])


func test_the_hack_screen_with_three_rows_fits_every_size() -> void:
	_activate_all()
	_now += Hacks.DAY_SECONDS + 5 * Hacks.HOUR_SECONDS
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var viewport: SubViewport = SubViewport.new()
		viewport.size = size
		var scale_factor: float = UiScale.total(Vector2(size), _base_size())
		var content_size: Vector2 = Vector2(size) / scale_factor
		viewport.size_2d_override = Vector2i(content_size.round())
		viewport.size_2d_override_stretch = true
		add_child_autofree(viewport)
		var screen: Control = HACK_SCENE.instantiate()
		viewport.add_child(screen)
		await wait_process_frames(2)
		var scroll: ScrollContainer = screen.get_node("Margin/Column/Scroll")
		var visible: Rect2 = Rect2(Vector2.ZERO, content_size)
		var rows: Array[Node] = screen.get_node(LIST_PATH).get_children()
		assert_eq(rows.size(), 3, label)
		for row: Label in rows:
			var rect: Rect2 = row.get_global_rect()
			assert_true(
				visible.grow(0.5).encloses(rect), "%s row %s fits %s" % [label, rect, visible]
			)
			assert_lte(row.get_minimum_size().x, scroll.size.x + 0.5, "%s row text fits" % label)
		for i: int in range(1, rows.size()):
			var upper: Rect2 = (rows[i - 1] as Label).get_global_rect()
			assert_lte(upper.end.y, (rows[i] as Label).get_global_rect().position.y + 0.5, label)


func _base_size() -> Vector2:
	return Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
