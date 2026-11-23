extends GutTest
## Controls and facing relative to the camera (spec 09, X3, X4, D50): with a camera turned by a
## yaw, W moves the player up the screen and A to its left, the aim stick fires along the screen,
## and the animated player and a bot show their back moving up the screen, their front moving down
## and their side for left and right (mirrored for left), the shot's view likewise.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter.tscn")
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
