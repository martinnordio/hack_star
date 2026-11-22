extends GutTest
## The animated picture fighters in play (spec 09, M3–M5, M7, D37, D41): the view from the
## direction on the screen (back up, front down, side left and right, mirrored left, the closer
## one on a diagonal, the last kept standing, the front at the start), the walk loop and its pace
## and hop, the shoot frame of the shot's view for 0.25 s — for the player and the bots, the same
## in all four camera views —, and the effects kept with the frames.

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const ANIMATED: Array[String] = ["magmax", "echo", "flarekid"]

var _previous: Node
var _placeholder: Node


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	if _placeholder != null:
		get_tree().current_scene = _previous
		_placeholder.queue_free()
		_placeholder = null
		_previous = null
		await wait_process_frames(1)
	GameState.reset()


func _model(fighter_id: String) -> FighterModel:
	var model: FighterModel = MODEL_SCENE.instantiate()
	model.idle_enabled = false
	add_child_autofree(model)
	model.setup(fighter_id)
	return model


func _fighter(fighter_id: String) -> Fighter:
	var fighter: Fighter = FIGHTER_SCENE.instantiate()
	add_child_autofree(fighter)
	fighter.set_look(fighter_id, Fighters.DEFAULT_SKIN)
	return fighter


func _picture(model: FighterModel) -> Texture2D:
	return (model.get_cutout().material_override as ShaderMaterial).get_shader_parameter("picture")


func _flip(model: FighterModel) -> bool:
	return (model.get_cutout().material_override as ShaderMaterial).get_shader_parameter("flip")


func test_the_view_follows_the_direction_on_the_screen() -> void:
	var rows: Array[Array] = [
		[Vector2.UP, "up"],
		[Vector2.DOWN, "down"],
		[Vector2.RIGHT, "side"],
		[Vector2.LEFT, "side"],
		[Vector2(0.6, -0.8), "up"],
		[Vector2(-0.6, 0.8), "down"],
		[Vector2(0.8, -0.6), "side"],
		[Vector2(-0.8, 0.6), "side"],
	]
	for row: Array in rows:
		assert_eq(CutoutAnimator.view_for(row[0]), row[1], str(row[0]))


func test_every_animated_fighter_starts_in_its_front_view() -> void:
	for fighter_id: String in ANIMATED:
		var model: FighterModel = _model(fighter_id)
		assert_not_null(model.cutout_animator(), fighter_id)
		assert_eq(model.cutout_animator().view, "down", fighter_id)
		assert_eq(_picture(model), CutoutFighters.frame(fighter_id, "idle_down"))
		assert_false(_flip(model))
	assert_null(_model("blaze").cutout_animator(), "fighters of shapes have none")


func test_moving_turns_the_figure_and_standing_keeps_the_last_view() -> void:
	var fighter: Fighter = _fighter("magmax")
	var animator: CutoutAnimator = fighter.model.cutout_animator()
	var steps: Array[Array] = [
		[Vector2.LEFT, "side", true],
		[Vector2.ZERO, "side", true],
		[Vector2.UP, "up", false],
		[Vector2.ZERO, "up", false],
		[Vector2.RIGHT, "side", false],
		[Vector2.DOWN, "down", false],
	]
	for step: Array in steps:
		fighter.input_direction = step[0]
		await wait_physics_frames(2)
		assert_eq([animator.view, animator.mirrored], [step[1], step[2]], str(step[0]))
		assert_eq(_flip(fighter.model), step[2], "mirrored only for the left")
	fighter.input_direction = Vector2.ZERO
	await wait_physics_frames(2)
	await wait_process_frames(1)
	assert_eq(animator.animation(), "idle_down", "the view's idle frame at once")
	assert_eq(_picture(fighter.model), CutoutFighters.frame("magmax", "idle_down"))


func test_the_walk_loop_plays_walk_idle_walk_idle_at_its_pace() -> void:
	var model: FighterModel = _model("echo")
	var animator: CutoutAnimator = model.cutout_animator()
	model.face(Vector2.RIGHT)
	model.running = true
	model.animate(0.0)
	var frames: SpriteFrames = CutoutFighters.sprite_frames("echo")
	var expected: Array[Texture2D] = [
		CutoutFighters.frame("echo", "walk_side", 0),
		CutoutFighters.frame("echo", "idle_side"),
		CutoutFighters.frame("echo", "walk_side", 2),
		CutoutFighters.frame("echo", "idle_side"),
	]
	assert_eq(frames.get_frame_texture("walk_side", 1), expected[1], "walk 1, idle, walk 2, idle")
	var seconds: float = 1.0 / animator.fps()
	for index: int in 8:
		model.animate(0.0)
		assert_eq(_picture(model), expected[index % 4], "frame %d" % index)
		animator.step(seconds)
	assert_almost_eq(animator.fps(), CutoutAnimator.WALK_FPS, 0.001, "8 a second at 5 m/s")
	animator.walk_speed = 2.0
	assert_eq(animator.fps(), CutoutAnimator.MIN_FPS, "slower, not below 6")
	animator.walk_speed = 9.0
	assert_eq(animator.fps(), CutoutAnimator.MAX_FPS, "faster, not above 10")


func test_walking_hops_a_little_on_each_step_and_never_slides_still() -> void:
	var model: FighterModel = _model("flarekid")
	var animator: CutoutAnimator = model.cutout_animator()
	model.face(Vector2.DOWN)
	model.running = true
	var lifts: Array[float] = []
	var pictures: Array[Texture2D] = []
	for step: int in 40:
		animator.step(0.02)
		model.animate(step * 0.02)
		lifts.append(model.get_body().position.y)
		if not pictures.has(_picture(model)):
			pictures.append(_picture(model))
	assert_almost_eq(lifts.max(), CutoutAnimator.HOP_HEIGHT, 0.005, "a small hop")
	assert_lt(lifts.min(), 0.01, "lands on its feet")
	assert_eq(pictures.size(), 3, "walk 1, idle and walk 2 take turns")
	assert_eq(model.get_body().scale, Vector3.ONE, "no breathing while walking")
	model.running = false
	animator.step(0.02)
	model.animate(1.0)
	assert_eq(_picture(model), CutoutFighters.frame("flarekid", "idle_down"), "stops at once")


func test_a_shot_shows_the_shoot_frame_of_its_view_for_a_quarter_second() -> void:
	var model: FighterModel = _model("magmax")
	var animator: CutoutAnimator = model.cutout_animator()
	model.face(Vector2.UP)
	model.play_shoot(Vector2.LEFT)
	assert_eq(_picture(model), CutoutFighters.frame("magmax", "shoot_side"))
	assert_true(_flip(model), "shooting left")
	model.face(Vector2.DOWN)
	assert_eq(animator.animation(), "shoot_side", "the shot's view while it shows")
	animator.step(CutoutAnimator.SHOOT_SECONDS - 0.05)
	model.animate(0.0)
	assert_eq(animator.animation(), "shoot_side")
	animator.step(0.1)
	model.animate(0.0)
	assert_eq(animator.animation(), "idle_side", "then idles in the shot's view")
	assert_eq(CutoutAnimator.SHOOT_SECONDS, 0.25)


func test_the_player_shoots_in_the_direction_of_the_shot() -> void:
	GameState.select("echo", Fighters.DEFAULT_SKIN)
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	arena.read_player_input = false
	await wait_process_frames(2)
	var fighter: Fighter = arena.get_node("Fighter")
	for row: Array in [[Vector2.UP, "shoot_up"], [Vector2.DOWN, "shoot_down"]]:
		fighter.last_fire_seconds = -INF
		assert_true(arena.fire(row[0]))
		assert_eq(_picture(fighter.model), CutoutFighters.frame("echo", row[1]))
		assert_true(fighter.model.get_muzzle_flash().visible, "the star at the muzzle")


func test_bots_turn_walk_and_shoot_too() -> void:
	GameState.select("blaze", Fighters.DEFAULT_SKIN)
	# The bots wait for the countdown, so only this test's shot moves them.
	GameState.match_settings.countdown_seconds = 60
	_previous = get_tree().current_scene
	_placeholder = Node.new()
	get_tree().root.add_child(_placeholder)
	get_tree().current_scene = _placeholder
	var arena: MatchArena = MATCH_SCENE.instantiate()
	arena.read_player_input = false
	_placeholder.add_child(arena)
	await wait_process_frames(2)
	var bot: Fighter = arena.fighters[1]
	bot.set_look("flarekid", Fighters.DEFAULT_SKIN)
	assert_eq(bot.model.cutout_animator().view, "down", "the front at the start")
	bot.last_fire_seconds = -INF
	assert_true(arena.fire_from(bot, Vector2.RIGHT, 0.0))
	assert_eq(_picture(bot.model), CutoutFighters.frame("flarekid", "shoot_side"))
	assert_false(_flip(bot.model))
	await wait_seconds(CutoutAnimator.SHOOT_SECONDS + 0.1)
	assert_eq(bot.model.cutout_animator().animation(), "idle_side", "then idles in that view")


func test_up_on_the_screen_shows_the_back_in_all_four_camera_views() -> void:
	GameState.select("magmax", Fighters.DEFAULT_SKIN)
	var arena: Arena = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	arena.read_player_input = false
	var fighter: Fighter = arena.get_node("Fighter")
	for view_id: String in CameraViews.ids():
		arena.set_view(view_id)
		await wait_seconds(Arena.VIEW_BLEND_SECONDS + 0.1)
		var camera: Camera3D = fighter.get_viewport().get_camera_3d()
		var forward: Vector3 = -camera.global_basis.z
		assert_almost_eq(forward.x, 0.0, 0.001, "%s: no yaw" % view_id)
		assert_lt(forward.z, 0.0, "%s: looks north" % view_id)
		var at: Vector3 = fighter.global_position
		var here: Vector2 = camera.unproject_position(at)
		var north: Vector2 = camera.unproject_position(at + Vector3(0.0, 0.0, -1.0))
		assert_lt(north.y, here.y, "%s: -z is up on the screen" % view_id)
		assert_lt(absf(north.x - here.x), here.y - north.y, "%s: mostly straight up" % view_id)
		fighter.input_direction = Vector2.UP
		await wait_physics_frames(2)
		assert_eq(fighter.model.cutout_animator().view, "up", "%s: W shows the back" % view_id)
		fighter.input_direction = Vector2.DOWN
		await wait_physics_frames(2)
		assert_eq(fighter.model.cutout_animator().view, "down", "%s: S the front" % view_id)
		fighter.input_direction = Vector2.ZERO


func test_flash_and_see_through_stay_while_the_frames_change() -> void:
	var fighter: Fighter = _fighter("echo")
	var material: ShaderMaterial = fighter.model.get_cutout().material_override
	fighter.model.set_see_through(true)
	fighter.hit(10)
	fighter.input_direction = Vector2.LEFT
	await wait_physics_frames(3)
	assert_string_contains(_picture(fighter.model).resource_path, "echo_side_", "turned")
	assert_eq(material.get_shader_parameter("flash"), 1.0, "still white")
	assert_eq(material.get_shader_parameter("fade"), FighterModel.SEE_THROUGH_ALPHA)
	fighter.input_direction = Vector2.ZERO
	await wait_seconds(CutoutMotion.FLASH_SECONDS + 0.1)
	assert_eq(material.get_shader_parameter("flash"), 0.0, "back to its colours")
