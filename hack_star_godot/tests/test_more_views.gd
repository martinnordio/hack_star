extends GutTest
## Controls and facing relative to the camera (spec 09, X3, X4, D50): with a camera turned by a
## yaw, W moves the player up the screen and A to its left, the aim stick fires along the screen,
## and the animated player and a bot show their back moving up the screen, their front moving down
## and their side for left and right (mirrored for left), the shot's view likewise.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TURNS: Array[float] = [90.0, 45.0]
const KEYS: Dictionary = {
	"move_up": [Vector2.UP, "up", false],
	"move_down": [Vector2.DOWN, "down", false],
	"move_right": [Vector2.RIGHT, "side", false],
	"move_left": [Vector2.LEFT, "side", true],
}


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	for action: String in KEYS:
		Input.action_release(action)
	GameState.reset()


## The Training arena with its camera held still and turned by `yaw_degrees` around the player.
func _turned_arena(yaw_degrees: float, fighter_id: String = "echo") -> Arena:
	GameState.select(fighter_id, Fighters.DEFAULT_SKIN)
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var arena: Arena = ARENA_SCENE.instantiate()
	arena.read_player_input = false
	viewport.add_child(arena)
	await wait_process_frames(2)
	arena.set_process(false)
	var camera: Camera3D = arena.get_node("Camera")
	var pivot: Vector3 = (arena.get_node("Fighter") as Fighter).global_position
	var turn: Transform3D = Transform3D(Basis(Vector3.UP, deg_to_rad(yaw_degrees)), pivot)
	camera.global_transform = turn * Transform3D(Basis.IDENTITY, -pivot) * camera.global_transform
	return arena


func _on_screen(arena: Arena, point: Vector3) -> Vector2:
	return (arena.get_node("Camera") as Camera3D).unproject_position(point)


func _picture(fighter: Fighter) -> Texture2D:
	var material: ShaderMaterial = fighter.model.get_cutout().material_override
	return material.get_shader_parameter("picture")


func test_the_camera_yaw_turns_screen_directions_to_the_ground_and_back() -> void:
	for yaw_degrees: float in [0.0, 45.0, 90.0, -120.0]:
		var yaw: float = deg_to_rad(yaw_degrees)
		var camera: Transform3D = Transform3D(Basis(Vector3.UP, yaw) * Basis(Vector3.RIGHT, -1.0))
		assert_almost_eq(CameraViews.yaw_of(camera), yaw, 0.0001, "yaw %s" % yaw_degrees)
		var up: Vector2 = CameraViews.to_world(Vector2.UP, yaw)
		var forward: Vector3 = Basis(Vector3.UP, yaw) * Vector3.FORWARD
		assert_almost_eq(up, Vector2(forward.x, forward.z), Vector2.ONE * 0.0001, "up = away")
		var any: Vector2 = Vector2(0.3, -0.7)
		assert_almost_eq(
			CameraViews.to_screen(CameraViews.to_world(any, yaw), yaw), any, Vector2.ONE * 0.0001
		)
	assert_eq(CameraViews.to_world(Vector2.LEFT, 0.0), Vector2.LEFT, "yaw 0 changes nothing")
	for view_id: String in CameraViews.ids():
		assert_true(CameraViews.get_view(view_id).has("yaw_degrees"), view_id)


func test_w_moves_the_player_up_the_screen_and_a_to_its_left_in_a_turned_camera() -> void:
	for yaw_degrees: float in TURNS:
		var arena: Arena = await _turned_arena(yaw_degrees)
		arena.read_player_input = true
		var fighter: Fighter = arena.get_node("Fighter")
		for action: String in ["move_up", "move_left"]:
			var before: Vector2 = _on_screen(arena, fighter.global_position)
			Input.action_press(action)
			await wait_physics_frames(8)
			Input.action_release(action)
			await wait_physics_frames(1)
			var moved: Vector2 = _on_screen(arena, fighter.global_position) - before
			var wanted: Vector2 = KEYS[action][0]
			var where: String = "%s at yaw %s" % [action, yaw_degrees]
			assert_gt(moved.length(), 2.0, "moved: " + where)
			assert_gt(moved.normalized().dot(wanted), 0.9, "along the screen: " + where)
		arena.get_parent().queue_free()


func test_the_animated_player_faces_by_the_direction_on_the_screen() -> void:
	for yaw_degrees: float in TURNS:
		var arena: Arena = await _turned_arena(yaw_degrees, "magmax")
		arena.read_player_input = true
		var animator: CutoutAnimator = (
			(arena.get_node("Fighter") as Fighter).model.cutout_animator()
		)
		assert_eq(animator.view, "down", "the front at the start")
		for action: String in KEYS:
			Input.action_press(action)
			await wait_physics_frames(2)
			Input.action_release(action)
			var where: String = "%s at yaw %s" % [action, yaw_degrees]
			assert_eq([animator.view, animator.mirrored], KEYS[action].slice(1), where)
		await wait_physics_frames(2)
		assert_eq(animator.view, "side", "standing keeps the last view")
		arena.get_parent().queue_free()


func test_a_bot_faces_and_shoots_by_the_direction_on_the_screen() -> void:
	for yaw_degrees: float in TURNS:
		var arena: Arena = await _turned_arena(yaw_degrees, "blaze")
		var bot: Fighter = FIGHTER_SCENE.instantiate()
		arena.add_child(bot)
		bot.position = (arena.get_node("Fighter") as Fighter).position + Vector3(3.0, 0.0, 0.0)
		bot.set_look("flarekid", Fighters.DEFAULT_SKIN)
		var animator: CutoutAnimator = bot.model.cutout_animator()
		for action: String in KEYS:
			var where: String = "%s at yaw %s" % [action, yaw_degrees]
			# The bot's brain moves it on the ground; the screen direction is the camera's.
			bot.input_direction = arena.to_world(KEYS[action][0])
			await wait_physics_frames(2)
			assert_eq([animator.view, animator.mirrored], KEYS[action].slice(1), "walks " + where)
			bot.input_direction = Vector2.ZERO
			bot.last_fire_seconds = -INF
			assert_true(arena.fire_from(bot, arena.to_world(KEYS[action][0]), 0.0))
			var shoot: String = "shoot_" + str(KEYS[action][1])
			assert_eq(_picture(bot), CutoutFighters.frame("flarekid", shoot), "shoots " + where)
			assert_eq(animator.mirrored, KEYS[action][2], "the mirror " + where)
			animator.shoot_left = 0.0
		arena.get_parent().queue_free()


func test_the_aim_stick_fires_along_the_screen_in_a_turned_camera() -> void:
	for yaw_degrees: float in TURNS:
		var arena: Arena = await _turned_arena(yaw_degrees, "echo")
		var fighter: Fighter = arena.get_node("Fighter")
		var aim: TouchJoystick = arena.get_node("Hud/AimJoystick")
		aim.released.emit(Vector2.RIGHT, 0.5)
		var animator: CutoutAnimator = fighter.model.cutout_animator()
		var where: String = "yaw %s" % yaw_degrees
		assert_eq(_picture(fighter), CutoutFighters.frame("echo", "shoot_side"), where)
		assert_false(animator.mirrored, "to the right: " + where)
		var shot: Shot = arena.get_node("Shots").get_child(0)
		var from: Vector2 = _on_screen(arena, shot.global_position)
		var to: Vector2 = _on_screen(arena, shot.global_position + shot.direction)
		assert_gt((to - from).normalized().dot(Vector2.RIGHT), 0.9, "flies right: " + where)
		arena.get_parent().queue_free()


func _show_in_viewport(scene: PackedScene, fighter_id: String = "echo") -> Arena:
	GameState.select(fighter_id, Fighters.DEFAULT_SKIN)
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var arena: Arena = scene.instantiate()
	arena.read_player_input = false
	viewport.add_child(arena)
	await wait_process_frames(2)
	return arena


func _press(arena: Arena, key: Key) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = key
		event.pressed = pressed
		arena.get_viewport().push_input(event)


func test_v_goes_through_the_eight_views_in_order() -> void:
	assert_eq(
		CameraViews.ids(),
		[
			CameraViews.CLASSIC,
			CameraViews.CLOSE,
			CameraViews.BEHIND,
			CameraViews.OVERVIEW,
			CameraViews.LOW,
			CameraViews.SIDE,
			CameraViews.DIAGONAL,
			CameraViews.CINEMATIC,
		]
	)
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	var seen: Array[String] = []
	for _press_count: int in 8:
		_press(arena, KEY_V)
		seen.append(arena.view())
	assert_eq(seen, CameraViews.ids().slice(1) + [CameraViews.CLASSIC], "and back to Classic")
	_press(arena, KEY_V)
	await wait_process_frames(1)
	assert_eq(arena.toast().text(), "Close", "the toast names each view")


func test_the_keys_5_to_8_and_the_number_pad_choose_the_new_views() -> void:
	var arena: Arena = await _show_in_viewport(MATCH_SCENE)
	var keys: Array[Key] = [KEY_5, KEY_6, KEY_7, KEY_8]
	var pad: Array[Key] = [KEY_KP_5, KEY_KP_6, KEY_KP_7, KEY_KP_8]
	var names: Array[String] = ["Low", "Side", "Diagonal", "Cinematic"]
	for index: int in 4:
		_press(arena, keys[index])
		assert_eq(arena.view(), CameraViews.ids()[index + 4], "key %d" % (index + 5))
		assert_eq(arena.toast().text(), names[index])
		_press(arena, KEY_1)
		_press(arena, pad[index])
		assert_eq(arena.view(), CameraViews.ids()[index + 4], "number pad %d" % (index + 5))
	assert_true(arena.get_node("Hud/MatchHud/CountdownLabel").visible, "during the countdown")


func test_the_view_keys_5_to_8_are_bound_to_nothing_else() -> void:
	var view_keys: Array[int] = [KEY_5, KEY_6, KEY_7, KEY_8, KEY_KP_5, KEY_KP_6, KEY_KP_7, KEY_KP_8]
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("view_") or String(action).begins_with("ui_"):
			continue
		for event: InputEvent in InputMap.action_get_events(action):
			if event is InputEventKey:
				var key: int = (event as InputEventKey).physical_keycode
				assert_false(view_keys.has(key), "%s does not use a view key" % action)


func test_each_view_has_its_yaw_and_cinematic_swings_within_25_degrees() -> void:
	var wanted: Dictionary = {
		CameraViews.LOW: 0.0, CameraViews.SIDE: 90.0, CameraViews.DIAGONAL: 45.0
	}
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	for view_id: String in wanted:
		arena.set_view(view_id)
		await wait_seconds(Arena.VIEW_BLEND_SECONDS + 0.1)
		assert_almost_eq(rad_to_deg(arena.camera_yaw()), wanted[view_id], 0.5, view_id)
	var swing: Array[float] = []
	for step: int in 57:
		swing.append(CameraViews.view_yaw_degrees(CameraViews.CINEMATIC, step * 0.25))
	assert_almost_eq(swing.max(), 25.0, 0.5, "swings 25° one way")
	assert_almost_eq(swing.min(), -25.0, 0.5, "and 25° the other, every 14 s")
	arena.set_view(CameraViews.CINEMATIC)
	var seen: Array[float] = []
	for _sample: int in 6:
		await wait_seconds(0.4)
		seen.append(rad_to_deg(arena.camera_yaw()))
	for yaw: float in seen:
		assert_lt(absf(yaw), 25.01, "within ±25° of north")
	assert_gt(absf(seen[-1] - seen[1]), 1.0, "the camera swings while the game runs")


func test_in_every_view_the_keys_move_and_turn_the_fighter_on_the_screen() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE, "magmax")
	arena.read_player_input = true
	var fighter: Fighter = arena.get_node("Fighter")
	var camera: Camera3D = arena.get_node("Camera")
	var animator: CutoutAnimator = fighter.model.cutout_animator()
	var start: Vector3 = fighter.global_position
	for view_id: String in CameraViews.ids():
		arena.set_view(view_id)
		await wait_seconds(Arena.VIEW_BLEND_SECONDS + 0.1)
		for action: String in KEYS:
			fighter.global_position = start
			await wait_physics_frames(1)
			var before: Vector3 = fighter.global_position
			Input.action_press(action)
			await wait_physics_frames(6)
			Input.action_release(action)
			var moved: Vector2 = (
				camera.unproject_position(fighter.global_position)
				- camera.unproject_position(before)
			)
			var where: String = "%s %s" % [view_id, action]
			assert_gt(moved.normalized().dot(KEYS[action][0]), 0.9, "on the screen: " + where)
			assert_eq([animator.view, animator.mirrored], KEYS[action].slice(1), where)


func test_a_new_view_is_kept_for_the_next_match() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE)
	_press(arena, KEY_7)
	assert_eq(GameState.camera_view, CameraViews.DIAGONAL)
	arena.get_parent().queue_free()
	var next_match: Arena = await _show_in_viewport(MATCH_SCENE)
	assert_eq(next_match.view(), CameraViews.DIAGONAL, "the next match starts in it")
	assert_almost_eq(rad_to_deg(next_match.camera_yaw()), 45.0, 0.5, "turned from the start")


func test_the_move_stick_moves_the_player_along_the_screen_in_every_view() -> void:
	var arena: Arena = await _show_in_viewport(ARENA_SCENE, "flarekid")
	arena.read_player_input = true
	var fighter: Fighter = arena.get_node("Fighter")
	var camera: Camera3D = arena.get_node("Camera")
	var stick: TouchJoystick = arena.get_node("Hud/TouchJoystick")
	var animator: CutoutAnimator = fighter.model.cutout_animator()
	var start: Vector3 = fighter.global_position
	for view_id: String in CameraViews.ids():
		arena.set_view(view_id)
		await wait_seconds(Arena.VIEW_BLEND_SECONDS + 0.1)
		for row: Array in [[Vector2.UP, "up"], [Vector2.LEFT, "side"]]:
			fighter.global_position = start
			await wait_physics_frames(1)
			var before: Vector3 = fighter.global_position
			stick.direction = row[0]
			await wait_physics_frames(6)
			stick.direction = Vector2.ZERO
			var moved: Vector2 = (
				camera.unproject_position(fighter.global_position)
				- camera.unproject_position(before)
			)
			var where: String = "%s stick %s" % [view_id, row[0]]
			assert_gt(moved.normalized().dot(row[0]), 0.9, "on the screen: " + where)
			assert_eq(animator.view, row[1], where)
