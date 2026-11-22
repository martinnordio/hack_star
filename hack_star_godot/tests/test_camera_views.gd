extends GutTest
## The camera views of Training and a match (spec 09, V1–V6, D25, D30): the order of `V`, the
## keys 1–4, the toast, the fighter within the screen in every view at the five screen sizes,
## Overview sees the four border walls, Classic keeps G11, and the view is kept for the next match.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
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


func _show_in_viewport(scene: PackedScene, size: Vector2i = Vector2i(1280, 720)) -> Arena:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = size
	viewport.size_2d_override = Vector2i(_content_size(size).round())
	viewport.size_2d_override_stretch = true
	add_child_autofree(viewport)
	var arena: Arena = scene.instantiate()
	arena.read_player_input = false
	viewport.add_child(arena)
	await wait_process_frames(2)
	return arena


## A key press and release pushed into the arena's viewport.
func _press(arena: Arena, key: Key) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = key
		event.pressed = pressed
		arena.get_viewport().push_input(event)


## Switches the view and waits until the camera has arrived.
func _switch(arena: Arena, view_id: String) -> void:
	arena.set_view(view_id)
	await wait_seconds(Arena.VIEW_BLEND_SECONDS + 0.1)


func test_v_goes_through_the_four_views_in_order() -> void:
	assert_eq(
		CameraViews.ids(),
		[CameraViews.CLASSIC, CameraViews.CLOSE, CameraViews.BEHIND, CameraViews.OVERVIEW]
	)
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	assert_eq(arena.view(), CameraViews.CLASSIC, "Classic is the default")
	var seen: Array[String] = []
	for _press_count: int in 4:
		_press(arena, KEY_V)
		seen.append(arena.view())
	assert_eq(
		seen, [CameraViews.CLOSE, CameraViews.BEHIND, CameraViews.OVERVIEW, CameraViews.CLASSIC]
	)


func test_the_keys_1_to_4_and_the_number_pad_choose_a_view() -> void:
	var arena: Arena = await _show_in_viewport(MATCH_SCENE)
	var keys: Array[Key] = [KEY_1, KEY_2, KEY_3, KEY_4]
	var pad: Array[Key] = [KEY_KP_1, KEY_KP_2, KEY_KP_3, KEY_KP_4]
	for index: int in 4:
		_press(arena, keys[index])
		assert_eq(arena.view(), CameraViews.ids()[index], "key %d" % (index + 1))
		_press(arena, KEY_1)
		_press(arena, pad[index])
		assert_eq(arena.view(), CameraViews.ids()[index], "number pad %d" % (index + 1))
	assert_true(arena.get_node("Hud/MatchHud/CountdownLabel").visible, "during the countdown")


func test_the_view_keys_are_bound_to_nothing_else() -> void:
	var view_keys: Array[int] = [KEY_V, KEY_1, KEY_2, KEY_3, KEY_4, KEY_KP_1, KEY_KP_4]
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("view_") or String(action).begins_with("ui_"):
			continue
		for event: InputEvent in InputMap.action_get_events(action):
			if event is InputEventKey:
				var key: int = (event as InputEventKey).physical_keycode
				assert_false(view_keys.has(key), "%s does not use a view key" % action)


func test_the_toast_names_the_view_and_fades() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	var toast: HudToast = arena.toast()
	assert_false(toast.visible, "no toast at the start")
	_press(arena, KEY_4)
	await wait_process_frames(1)
	assert_true(toast.visible)
	assert_eq(toast.text(), "Overview")
	assert_eq(toast.theme_type_variation, &"ChipPanel", "on a dark backing")
	assert_eq(toast.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	var center: float = toast.get_global_rect().get_center().x
	assert_almost_eq(center, _content_size(Vector2i(1280, 720)).x / 2.0, 2.0, "top centre")
	assert_lt(toast.get_global_rect().position.y, 150.0, "at the top")
	await wait_seconds(HudToast.SHOW_SECONDS + HudToast.FADE_SECONDS + 0.2)
	assert_false(toast.visible, "gone after about 1.5 s")


func test_the_player_and_the_bar_are_on_screen_in_every_view_at_every_size() -> void:
	# A picture fighter: the tallest on screen, its bar over the picture (D21).
	GameState.selected_fighter = "flarekid"
	for world_id: String in Worlds.ids():
		GameState.world = world_id
		for label: String in SIZES:
			var size: Vector2i = SIZES[label]
			var arena: Arena = await _show_in_viewport(MATCH_SCENE, size)
			var view: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
			var camera: Camera3D = arena.get_node("Camera")
			var fighter: Fighter = arena.get_node("Fighter")
			for view_id: String in CameraViews.ids():
				await _switch(arena, view_id)
				var bar: float = fighter.health_bar().global_position.y
				for height: float in [0.0, bar]:
					var point: Vector3 = fighter.global_position + Vector3.UP * height
					var where: String = "%s %s %s at %.1f m" % [world_id, label, view_id, height]
					assert_false(camera.is_position_behind(point), where)
					assert_true(view.has_point(camera.unproject_position(point)), where)
			arena.get_parent().queue_free()


func test_the_bar_and_the_numbers_show_over_the_picture_anywhere_in_every_view() -> void:
	# Review 2026-11-22 (reopening) finding 1: in Overview a point straight up from a fighter in
	# the lower half of the screen moves down the screen, so the bar showed under the picture.
	GameState.selected_fighter = "flarekid"
	for world_id: String in Worlds.ids():
		GameState.world = world_id
		for size: Vector2i in [Vector2i(820, 1180), Vector2i(1280, 720)]:
			var arena: Arena = await _show_in_viewport(MATCH_SCENE, size)
			var camera: Camera3D = arena.get_node("Camera")
			var fighter: Fighter = arena.get_node("Fighter")
			fighter.invulnerable = false
			var area: Rect2 = ArenaLayout.bounds().grow(-1.5)
			var spots: Array[Vector2] = [
				area.get_center(),
				Vector2(area.get_center().x, area.end.y),
				Vector2(area.get_center().x, area.position.y),
				area.position,
				area.end,
			]
			var last_start: float = 0.0
			for view_id: String in CameraViews.ids():
				await _switch(arena, view_id)
				for spot: Vector2 in spots:
					fighter.global_position = Vector3(spot.x, 0.0, spot.y)
					await wait_process_frames(1)
					var where: String = "%s %s %s at %s" % [world_id, size, view_id, spot]
					var top: float = _picture_top_on_screen(camera, fighter)
					var bar: Vector2 = camera.unproject_position(
						fighter.health_bar().global_position
					)
					assert_lt(bar.y, top, "bar over the picture: " + where)
					fighter.hit(1)
					var number: Label3D = _newest_number(fighter)
					var start: float = camera.unproject_position(number.global_position).y
					assert_lt(start, top, "damage number over the picture: " + where)
					last_start = start
					fighter.health = fighter.max_health
			await wait_seconds(DamageNumber.SECONDS / 2.0)
			var risen: Label3D = _newest_number(fighter)
			assert_lt(
				camera.unproject_position(risen.global_position).y,
				last_start,
				"%s %s: the number rises up the screen" % [world_id, size]
			)
			arena.get_parent().queue_free()


## The top of the picture on screen as `cutout.gdshader` draws it: the quad turns to the camera
## (its up is the camera's up) and shrinks around the feet by part of the foreshortening.
func _picture_top_on_screen(camera: Camera3D, fighter: Fighter) -> float:
	var up: Vector3 = camera.global_basis.y.normalized()
	var height: float = CutoutFighters.FIGHTERS[fighter.model.fighter_id]["figure_height"]
	var shown: float = height * lerpf(1.0, clampf(up.y, 0.0, 1.0), CutoutFighters.FORESHORTEN)
	return camera.unproject_position(fighter.model.global_position + up * shown).y


func _newest_number(fighter: Fighter) -> Label3D:
	var found: Label3D = null
	for child: Node in fighter.get_children():
		if child is Label3D:
			found = child
	return found


func test_overview_shows_the_four_border_walls() -> void:
	for label: String in SIZES:
		var size: Vector2i = SIZES[label]
		var arena: Arena = await _show_in_viewport(MATCH_SCENE, size)
		await _switch(arena, CameraViews.OVERVIEW)
		var view: Rect2 = Rect2(Vector2.ZERO, _content_size(size))
		var camera: Camera3D = arena.get_node("Camera")
		for index: int in ArenaLayout.border_count():
			var wall: Rect2 = ArenaLayout.walls()[index]
			for corner: Vector2 in [wall.position, wall.end]:
				var point: Vector3 = Vector3(corner.x, Canyon.WALL_HEIGHT, corner.y)
				assert_true(
					view.has_point(camera.unproject_position(point)),
					"%s: border wall %d corner %s" % [label, index, corner]
				)
		arena.get_parent().queue_free()


func test_the_camera_always_looks_north() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	var camera: Camera3D = arena.get_node("Camera")
	for view_id: String in CameraViews.ids():
		await _switch(arena, view_id)
		var forward: Vector3 = -camera.global_basis.z
		assert_almost_eq(forward.x, 0.0, 0.001, "%s: no yaw" % view_id)
		assert_lt(forward.z, 0.0, "%s: looks north" % view_id)
		assert_lt(forward.y, 0.0, "%s: looks down" % view_id)


func test_close_is_nearer_and_overview_higher_than_classic() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	var fighter: Vector3 = arena.get_node("Fighter").global_position
	var camera: Camera3D = arena.get_node("Camera")
	var distances: Dictionary = {}
	var heights: Dictionary = {}
	for view_id: String in CameraViews.ids():
		await _switch(arena, view_id)
		distances[view_id] = camera.global_position.distance_to(fighter)
		heights[view_id] = camera.global_position.y
	assert_lt(distances[CameraViews.CLOSE], distances[CameraViews.CLASSIC], "Close is nearer")
	assert_lt(heights[CameraViews.BEHIND], heights[CameraViews.CLOSE], "Behind is low")
	assert_gt(heights[CameraViews.OVERVIEW], heights[CameraViews.CLASSIC], "Overview is high")


func test_classic_keeps_its_place_after_a_round_of_views() -> void:
	var arena: Arena = await _show_in_viewport(MATCH_SCENE)
	var camera: Camera3D = arena.get_node("Camera")
	var before: Transform3D = camera.global_transform
	for view_id: String in [CameraViews.OVERVIEW, CameraViews.BEHIND, CameraViews.CLASSIC]:
		await _switch(arena, view_id)
	assert_true(camera.global_transform.is_equal_approx(before), "Classic as at the start (G11)")


func test_the_switch_blends_the_camera() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	var camera: Camera3D = arena.get_node("Camera")
	var start: Vector3 = camera.global_position
	var end: Vector3 = arena.view_pose(CameraViews.OVERVIEW).origin
	arena.set_view(CameraViews.OVERVIEW)
	await wait_seconds(Arena.VIEW_BLEND_SECONDS / 2.0)
	var middle: Vector3 = camera.global_position
	assert_gt(middle.distance_to(start), 0.5, "on its way")
	assert_gt(middle.distance_to(end), 0.5, "not there yet")
	await wait_seconds(Arena.VIEW_BLEND_SECONDS)
	assert_almost_eq(camera.global_position.distance_to(end), 0.0, 0.01, "arrived")


func test_the_view_is_kept_for_the_next_match_and_training() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	_press(arena, KEY_3)
	assert_eq(GameState.camera_view, CameraViews.BEHIND, "kept while the game is open")
	arena.get_parent().queue_free()
	var next_match: Arena = await _show_in_viewport(MATCH_SCENE)
	assert_eq(next_match.view(), CameraViews.BEHIND, "the next match starts in it")
	assert_false(next_match.toast().visible, "no toast at the start")
	GameState.reset()
	assert_eq(GameState.camera_view, CameraViews.CLASSIC, "a fresh start is Classic")
