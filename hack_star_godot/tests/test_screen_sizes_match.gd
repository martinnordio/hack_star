extends GutTest
## The match screens fit desktop, iPad and phone sizes (spec 07, D9, D13).

const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const SIZES: Dictionary = {
	"desktop 1280x720": Vector2i(1280, 720),
	"iPad landscape 1180x820": Vector2i(1180, 820),
	"iPad portrait 820x1180": Vector2i(820, 1180),
	"phone portrait 390x844": Vector2i(390, 844),
	"phone landscape 844x390": Vector2i(844, 390),
}


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _content_size(window_size: Vector2i) -> Vector2:
	var base: Vector2 = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	return Vector2(window_size) / UiScale.total(Vector2(window_size), base)


func _show_in_viewport(scene: PackedScene, size: Vector2i) -> Array:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = size
	viewport.size_2d_override = Vector2i(_content_size(size).round())
	viewport.size_2d_override_stretch = true
	add_child_autofree(viewport)
	var root: Node = scene.instantiate()
	viewport.add_child(root)
	await wait_process_frames(2)
	return [viewport, root]


func _assert_inside(control: Control, visible_rect: Rect2, label: String) -> void:
	var rect: Rect2 = control.get_global_rect()
	assert_true(visible_rect.encloses(rect), "%s %s is inside %s" % [label, rect, visible_rect])


func test_the_match_hud_fits_every_size() -> void:
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var shown: Array = await _show_in_viewport(MATCH_SCENE, size)
		var arena: MatchArena = shown[1]
		var visible_rect: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		var countdown: Control = arena.get_node("Hud/MatchHud/CountdownLabel")
		var timer: Control = arena.get_node("Hud/MatchHud/TimerLabel")
		var left: Control = arena.get_node("Hud/MatchHud/FightersLeftLabel")
		var back: Control = arena.get_node("Hud/BackButton")
		var fps: Control = arena.get_node("Hud/FpsLabel")
		var sticks: Array[Control] = [
			arena.get_node("Hud/TouchJoystick"), arena.get_node("Hud/AimJoystick")
		]
		for control: Control in [countdown, timer, left, back, fps] + sticks:
			_assert_inside(control, visible_rect, "%s %s" % [label, control.name])
		for pair: Array in [[timer, back], [timer, fps], [timer, left], [left, fps], [left, back]]:
			var first: Rect2 = pair[0].get_global_rect()
			var second: Rect2 = pair[1].get_global_rect()
			var names: String = "%s %s and %s" % [label, pair[0].name, pair[1].name]
			assert_false(first.intersects(second), "%s apart" % names)
		for stick: Control in sticks:
			var stick_rect: Rect2 = stick.get_global_rect()
			for hud_label: Control in [countdown, timer, left]:
				var clear: bool = not stick_rect.intersects(hud_label.get_global_rect())
				assert_true(clear, "%s %s clear of a stick" % [label, hud_label.name])
		shown[0].queue_free()
