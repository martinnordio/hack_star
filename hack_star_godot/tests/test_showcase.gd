extends GutTest
## The showcase on the pedestal (spec 09, M8, M9, D39, D41): an animated fighter idles, turns
## through its views, walks on the spot and shoots its projectile with sparks in a loop of at most
## 8 s that never stands still, on home, the fighter screen and the result; on the fighter screen a
## drag turns it and a tap shoots, with the mouse and touch, and the showcase starts again 3 s
## after the last one; fighters of shapes keep their idle.

const HOME: PackedScene = preload("res://scenes/home.tscn")
const FIGHTER_SCREEN: PackedScene = preload("res://scenes/fighter_screen.tscn")
const RESULT_SCREEN: PackedScene = preload("res://scenes/result_screen.tscn")
const STAGE_SCENE: PackedScene = preload("res://scenes/ui/fighter_stage.tscn")
const HOME_STAGE: String = "Margin/Column/Body/FighterStage"
const SCREEN_STAGE: String = "Margin/Column/Body/StageFrame/FighterStage"


func before_each() -> void:
	GameState.reset()
	GameState.entrance_played = true


func after_each() -> void:
	GameState.reset()


## A pedestal stage with `fighter_id`, driven by hand (its own and the model's clocks stopped).
func _stage(fighter_id: String, interactive: bool = false) -> FighterStage:
	var stage: FighterStage = STAGE_SCENE.instantiate()
	stage.interactive = interactive
	add_child_autofree(stage)
	stage.size = Vector2(300.0, 400.0)
	stage.show_fighter(fighter_id)
	stage.finish_reveal()
	stage.set_process(false)
	stage.model.set_process(false)
	return stage


func _step(stage: FighterStage, seconds: float) -> void:
	stage.step_showcase(seconds)
	stage.model._process(seconds)


func _animation(stage: FighterStage) -> String:
	return stage.model.cutout_animator().animation()


func _mirrored(stage: FighterStage) -> bool:
	return stage.model.cutout_animator().mirrored


func _mouse(stage: FighterStage, offset: Vector2, pressed: int, device: int = 0) -> void:
	var at: Vector2 = stage.size / 2.0 + offset
	var event: InputEventMouse
	if pressed < 0:
		event = InputEventMouseMotion.new()
		event.button_mask = MOUSE_BUTTON_MASK_LEFT
	else:
		event = InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed == 1
	event.device = device
	event.position = at
	stage._gui_input(event)


func _touch(stage: FighterStage, offset: Vector2, pressed: int) -> void:
	var at: Vector2 = stage.size / 2.0 + offset
	var event: InputEvent
	if pressed < 0:
		event = InputEventScreenDrag.new()
	else:
		event = InputEventScreenTouch.new()
		event.pressed = pressed == 1
	event.position = at
	stage._gui_input(event)


func test_the_loop_idles_turns_walks_shoots_and_idles_within_8_seconds() -> void:
	assert_lte(CutoutShowcase.LOOP_SECONDS, 8.0)
	var rows: Array[Array] = [
		[0.5, "down", false, false, false],
		[1.4, "down", false, false, false],
		[1.8, "side", false, false, false],
		[2.2, "up", false, false, false],
		[2.6, "side", true, false, false],
		[3.0, "down", false, false, false],
		[4.0, "down", false, true, false],
		[5.0, "side", false, false, true],
		[6.5, "down", false, false, false],
		[7.5, "down", false, false, false],
	]
	for row: Array in rows:
		var pose: Dictionary = CutoutShowcase.at(row[0])
		assert_eq(
			[pose["view"], pose["mirrored"], pose["running"], pose["shooting"]],
			row.slice(1),
			"at %.1f s" % row[0]
		)


func test_the_showcase_never_stands_still() -> void:
	var stage: FighterStage = _stage("magmax")
	assert_true(stage.is_showcasing())
	var body: Node3D = stage.model.get_body()
	var shown: Dictionary = {}
	var last: Array = []
	for i: int in int(CutoutShowcase.LOOP_SECONDS / 0.1):
		_step(stage, 0.1)
		var now: Array = [_animation(stage), body.scale, body.position.y]
		shown[now[0]] = true
		assert_ne(now, last, "moves at %.1f s" % stage.showcase_time())
		last = now
	for animation: String in ["idle_down", "idle_side", "idle_up", "walk_down", "shoot_side"]:
		assert_true(shown.has(animation), animation)


func test_the_shot_flies_out_with_its_projectile_and_a_burst_of_sparks() -> void:
	var stage: FighterStage = _stage("echo")
	_step(stage, CutoutShowcase.WALK_END - 0.05)
	_step(stage, 0.1)
	assert_eq(_animation(stage), "shoot_side")
	var shot: MeshInstance3D = stage.get_shot()
	assert_true(shot.visible, "the projectile flies")
	var material: ShaderMaterial = shot.material_override
	assert_eq(material.get_shader_parameter("picture"), CutoutFighters.projectile("echo"))
	var start: float = shot.position.x
	assert_true(stage.get_shot_sparks().emitting, "the sparks burst")
	var sparks: StandardMaterial3D = stage.get_shot_sparks().material_override
	assert_eq(sparks.albedo_color, stage.model.main_color.lightened(0.3))
	_step(stage, CutoutShowcase.SHOT_FLIGHT_SECONDS * 0.8)
	assert_gt(shot.position.x, start + 0.5, "it flies out to the side")
	assert_lt(material.get_shader_parameter("fade"), 1.0, "and fades")
	_step(stage, CutoutShowcase.SHOT_FLIGHT_SECONDS)
	assert_false(shot.visible, "then it is gone")


func test_a_drag_turns_the_figure_through_its_views() -> void:
	var stage: FighterStage = _stage("flarekid", true)
	_mouse(stage, Vector2.ZERO, 1)
	var rows: Array[Array] = [
		[5.0, "idle_down", false],
		[90.0, "idle_side", false],
		[170.0, "idle_up", false],
		[250.0, "idle_side", true],
		[330.0, "idle_down", false],
		[-90.0, "idle_side", true],
	]
	for row: Array in rows:
		_mouse(stage, Vector2(row[0], 0.0), -1)
		_step(stage, 0.05)
		assert_eq([_animation(stage), _mirrored(stage)], row.slice(1), "dragged %d px" % row[0])
	assert_true(stage.is_holding(), "the showcase waits")
	_mouse(stage, Vector2(-90.0, 0.0), 0)
	assert_eq(_animation(stage), "idle_side", "a drag's release does not shoot")


func test_a_tap_shoots_in_the_shown_view_with_mouse_and_touch() -> void:
	var stage: FighterStage = _stage("magmax", true)
	_mouse(stage, Vector2.ZERO, 1)
	_mouse(stage, Vector2(3.0, 0.0), 0)
	assert_eq(_animation(stage), "shoot_down", "a click shoots towards the viewer")
	assert_true(stage.get_shot().visible)
	_step(stage, CutoutShowcase.SHOOT_SECONDS + CutoutShowcase.SHOT_FLIGHT_SECONDS)
	_touch(stage, Vector2.ZERO, 1)
	_touch(stage, Vector2(100.0, 0.0), -1)
	_touch(stage, Vector2(100.0, 0.0), 0)
	assert_eq(_animation(stage), "idle_side", "a touch drag turns")
	_touch(stage, Vector2.ZERO, 1)
	_touch(stage, Vector2.ZERO, 0)
	assert_eq(_animation(stage), "shoot_side", "a touch tap shoots")


func test_a_touch_counts_once_without_its_emulated_mouse() -> void:
	var stage: FighterStage = _stage("echo", true)
	_mouse(stage, Vector2.ZERO, 1, InputEvent.DEVICE_ID_EMULATION)
	_mouse(stage, Vector2.ZERO, 0, InputEvent.DEVICE_ID_EMULATION)
	assert_eq(_animation(stage), "idle_down", "the emulated mouse is ignored")
	assert_false(stage.is_holding())


func test_the_showcase_starts_again_3_seconds_after_the_last_input() -> void:
	var stage: FighterStage = _stage("echo", true)
	_step(stage, 0.5)
	_mouse(stage, Vector2.ZERO, 1)
	_mouse(stage, Vector2(170.0, 0.0), -1)
	_mouse(stage, Vector2(170.0, 0.0), 0)
	var time: float = stage.showcase_time()
	_step(stage, FighterStage.RESUME_SECONDS - 0.2)
	assert_eq(_animation(stage), "idle_up", "held")
	assert_eq(stage.showcase_time(), time, "paused")
	_step(stage, 0.3)
	assert_false(stage.is_holding())
	assert_eq(_animation(stage), "idle_down", "from the start of the loop")
	_step(stage, 0.5)
	assert_almost_eq(stage.showcase_time(), 0.5, 0.001)


func test_only_the_fighter_screen_turns_and_shoots() -> void:
	var stage: FighterStage = _stage("echo")
	_mouse(stage, Vector2.ZERO, 1)
	_mouse(stage, Vector2(170.0, 0.0), -1)
	_mouse(stage, Vector2(170.0, 0.0), 0)
	assert_false(stage.is_holding(), "home and the result do not react")
	GameState.viewed_fighter = "echo"
	var screen: Control = autofree(FIGHTER_SCREEN.instantiate())
	add_child(screen)
	assert_true((screen.get_node(SCREEN_STAGE) as FighterStage).interactive)


func test_home_the_fighter_screen_and_the_result_play_the_showcase() -> void:
	GameState.select("magmax", Fighters.DEFAULT_SKIN)
	GameState.viewed_fighter = "flarekid"
	GameState.last_result = {
		"outcome": Match.Result.VICTORY, "place": 1, "fighter": "echo", "skin": "default"
	}
	var screens: Array[Array] = [
		[HOME, HOME_STAGE], [FIGHTER_SCREEN, SCREEN_STAGE], [RESULT_SCREEN, HOME_STAGE]
	]
	for row: Array in screens:
		var screen: Control = autofree((row[0] as PackedScene).instantiate())
		add_child(screen)
		var stage: FighterStage = screen.get_node(row[1])
		assert_true(stage.is_showcasing(), stage.model.fighter_id)
		assert_true(stage.is_revealing(), "%s: the reveal first" % stage.model.fighter_id)


func test_fighters_of_shapes_keep_their_idle() -> void:
	var stage: FighterStage = _stage("rocko", true)
	assert_false(stage.is_showcasing())
	assert_null(stage.model.cutout_animator())
	_mouse(stage, Vector2.ZERO, 1)
	_mouse(stage, Vector2.ZERO, 0)
	_step(stage, 5.0)
	assert_null(stage.get_shot(), "no shot")
