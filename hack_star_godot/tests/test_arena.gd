extends GutTest

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
## Inner face of the east border wall.
const EAST_WALL_INNER_X: float = 9.0
## The fighter's collision capsule.
const FIGHTER_RADIUS: float = 0.4

var _arena: Node3D


func before_each() -> void:
	_arena = ARENA_SCENE.instantiate()
	add_child_autofree(_arena)


func test_arena_has_fighter_camera_and_walls() -> void:
	var fighter: Node = _arena.get_node("Fighter")
	assert_true(fighter is CharacterBody3D, "fighter is a CharacterBody3D")
	var camera: Camera3D = _arena.get_node("Camera")
	assert_true(camera.current, "camera is the current camera")
	var forward: Vector3 = -camera.global_basis.z
	assert_gt(camera.global_position.y, 0.0, "camera is above the floor")
	assert_lt(forward.y, 0.0, "camera looks down")
	assert_lt(forward.z, 0.0, "camera looks from behind, at an angle")
	var walls: Array[Node] = _arena.get_node("Walls").get_children()
	assert_eq(walls.size(), ArenaLayout.WALLS.size(), "one wall per block of the layout")
	for wall: Node in walls:
		assert_true(wall is StaticBody3D, "%s is a StaticBody3D" % wall.name)
	assert_true(_arena.get_node("Floor") is StaticBody3D, "floor is a StaticBody3D")


func test_walls_are_built_from_the_layout() -> void:
	var walls: Array[Node] = _arena.get_node("Walls").get_children()
	for index: int in ArenaLayout.WALLS.size():
		var rect: Rect2 = ArenaLayout.WALLS[index]
		var body: StaticBody3D = walls[index]
		var box: BoxShape3D = body.get_node("Collision").shape
		assert_almost_eq(box.size.x, rect.size.x, 0.001, "%s width" % body.name)
		assert_almost_eq(box.size.z, rect.size.y, 0.001, "%s depth" % body.name)
		var center: Vector2 = Vector2(body.global_position.x, body.global_position.z)
		assert_almost_eq(center, rect.get_center(), Vector2.ONE * 0.001, "%s place" % body.name)
		assert_almost_eq(body.global_position.y, box.size.y / 2.0, 0.001, "on the floor")


func test_the_selected_fighter_stands_in_the_arena() -> void:
	GameState.select("rocko", "crystal")
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var model: FighterModel = arena.get_node("Fighter/Model")
	assert_eq(model.fighter_id, "rocko")
	assert_eq(model.skin_id, "crystal")
	assert_not_null(arena.get_node("Fighter/Muzzle"), "the fighter has a muzzle")


func test_the_model_faces_the_walking_direction() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	await wait_physics_frames(10)
	var model: Node3D = fighter.get_node("Model")
	assert_almost_eq(model.global_basis.z, Vector3.RIGHT, Vector3.ONE * 0.01, "front points east")


func test_the_camera_follows_the_fighter() -> void:
	var camera: Camera3D = _arena.get_node("Camera")
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	var before: Vector3 = _camera_look_at(camera)
	fighter.input_direction = Vector2.RIGHT
	await wait_seconds(1.0)
	var after: Vector3 = _camera_look_at(camera)
	assert_gt(after.x, before.x + 2.0, "the look-at point moved east")
	assert_lt(after.x, fighter.global_position.x + 0.01, "the camera is not ahead of the fighter")
	assert_almost_eq(after.z, before.z, 0.1, "no sideways drift north or south")


func test_walking_sets_running_and_standing_clears_it() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	var model: FighterModel = fighter.get_node("Model")
	_arena.read_player_input = false
	await wait_physics_frames(3)
	assert_false(model.running, "standing still")
	fighter.input_direction = Vector2.RIGHT
	await wait_physics_frames(3)
	assert_true(model.running, "walking")
	fighter.input_direction = Vector2.ZERO
	await wait_physics_frames(3)
	assert_false(model.running, "stopped")


## Where the camera's centre ray meets the ground (y = 0).
func _camera_look_at(camera: Camera3D) -> Vector3:
	var forward: Vector3 = -camera.global_basis.z
	return camera.global_position + forward * (camera.global_position.y / -forward.y)


## An arena in its own 1280×720 viewport, so input can be pushed into it.
func _arena_in_viewport() -> Array:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var arena: Node3D = ARENA_SCENE.instantiate()
	viewport.add_child(arena)
	await wait_process_frames(2)
	return [viewport, arena]


func _screen_touch(position: Vector2, pressed: bool) -> InputEventScreenTouch:
	var event: InputEventScreenTouch = InputEventScreenTouch.new()
	event.index = 0
	event.pressed = pressed
	event.position = position
	return event


func test_a_click_on_back_does_not_fire() -> void:
	var shown: Array = await _arena_in_viewport()
	var back: Button = shown[1].get_node("Hud/BackButton")
	for connection: Dictionary in back.pressed.get_connections():
		back.pressed.disconnect(connection["callable"])
	watch_signals(back)
	UiInput.click(shown[0], back)
	await wait_process_frames(2)
	assert_signal_emit_count(back, "pressed", 1, "Back was pressed")
	assert_eq(shown[1].get_node("Shots").get_child_count(), 0, "no shot")


func test_releasing_the_aim_stick_after_a_drag_fires_that_way() -> void:
	var shown: Array = await _arena_in_viewport()
	var stick: TouchJoystick = shown[1].get_node("Hud/AimJoystick")
	stick.visible = true
	var aim_line: MeshInstance3D = shown[1].get_node("AimLine")
	var centre: Vector2 = stick.get_global_rect().get_center()
	shown[0].push_input(_screen_touch(centre, true), true)
	var drag: InputEventScreenDrag = InputEventScreenDrag.new()
	drag.index = 0
	drag.position = centre + Vector2(stick.radius, 0.0)
	shown[0].push_input(drag, true)
	await wait_process_frames(2)
	assert_true(aim_line.visible, "the aim line shows while dragging")
	assert_eq(shown[1].get_node("Shots").get_child_count(), 0, "no shot while aiming")
	shown[0].push_input(_screen_touch(drag.position, false), true)
	var shots: Node3D = shown[1].get_node("Shots")
	assert_eq(shots.get_child_count(), 1, "released: one shot")
	var shot: Shot = shots.get_child(0)
	assert_almost_eq(shot.direction, Vector3.RIGHT, Vector3.ONE * 0.01, "fired east")
	await wait_process_frames(1)
	assert_false(aim_line.visible, "the aim line is gone")


func test_a_quick_tap_on_the_aim_stick_fires_and_stops_at_the_low_wall() -> void:
	var shown: Array = await _arena_in_viewport()
	var stick: TouchJoystick = shown[1].get_node("Hud/AimJoystick")
	stick.visible = true
	var centre: Vector2 = stick.get_global_rect().get_center()
	shown[0].push_input(_screen_touch(centre, true), true)
	shown[0].push_input(_screen_touch(centre, false), true)
	var shots: Node3D = shown[1].get_node("Shots")
	assert_eq(shots.get_child_count(), 1, "a tap fires")
	var shot: Shot = shots.get_child(0)
	# No target yet: straight ahead, towards the camera and the low south wall.
	assert_almost_eq(shot.direction, Vector3.BACK, Vector3.ONE * 0.01, "straight ahead")
	var ends: Array = []
	shot.ended.connect(func(at: Vector3, hit: bool) -> void: ends.append_array([at, hit]))
	await wait_until(func() -> bool: return not ends.is_empty(), 2.0)
	var south_wall: Rect2 = ArenaLayout.WALLS[1]
	assert_true(ends[1], "the shot hit the wall")
	assert_almost_eq(ends[0].z, south_wall.position.y, 0.01, "stopped at the low south wall")


func test_arena_has_back_button_and_joystick() -> void:
	var back: Button = _arena.get_node("Hud/BackButton")
	assert_eq(back.text, "Back")
	assert_not_null(_arena.get_node("Hud/TouchJoystick"))


func test_training_has_three_dummies_and_no_bots() -> void:
	assert_true(_arena.training, "the arena scene is the Training arena")
	assert_eq(_arena.get_node("Dummies").get_child_count(), 3, "three dummies")
	assert_false(_arena.has_node("Bots"), "no bots")
	var fighters: int = 0
	for child: Node in _arena.get_children():
		if child is Fighter:
			fighters += 1
	assert_eq(fighters, 1, "only the player")


func test_arena_has_fps_label_top_right() -> void:
	var label: Label = _arena.get_node("Hud/FpsLabel")
	assert_true(label.text.begins_with("FPS: "), "label shows the frame rate")
	assert_eq(label.anchor_left, 1.0, "label is anchored to the right")
	assert_eq(label.anchor_top, 0.0, "label is anchored to the top")


func test_fighter_starts_at_the_layout_start() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	var start: Vector3 = Vector3(ArenaLayout.START.x, 0.0, ArenaLayout.START.y)
	assert_almost_eq(fighter.global_position, start, Vector3.ONE * 0.001)


func test_fighter_stops_at_east_wall() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	# 150 frames at 60 per second and 5 m/s is 12.5 m, more than the 9 m to the wall.
	await wait_physics_frames(150)
	var position: Vector3 = fighter.global_position
	assert_lt(position.x, EAST_WALL_INNER_X, "fighter stays inside the east wall")
	assert_gt(position.x, EAST_WALL_INNER_X - 1.0, "fighter reached the east wall")
	assert_almost_eq(position.z, ArenaLayout.START.y, 0.05, "fighter walked straight east")
	assert_almost_eq(position.y, 0.0, 0.01, "fighter stays on the floor")
	assert_gt(fighter.rotation.y, -PI / 2.0 - 0.01, "fighter faces east")
	assert_lt(fighter.rotation.y, -PI / 2.0 + 0.01, "fighter faces east")


func test_fighter_stops_at_a_rock() -> void:
	# The centre rock lies straight north of the start.
	var rock: Rect2 = ArenaLayout.WALLS[6]
	assert_true(rock.has_point(Vector2(ArenaLayout.START.x, 0.0)), "the rock is on the way")
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	fighter.input_direction = Vector2.UP
	# 150 frames at 5 m/s is 12.5 m, more than the 8.75 m to the rock.
	await wait_physics_frames(150)
	var position: Vector3 = fighter.global_position
	assert_gt(position.z, rock.end.y, "fighter stays south of the rock")
	assert_lt(position.z, rock.end.y + FIGHTER_RADIUS + 0.2, "fighter reached the rock")
	assert_almost_eq(position.x, ArenaLayout.START.x, 0.05, "fighter walked straight north")
