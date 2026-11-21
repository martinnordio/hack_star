extends GutTest

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const ArenaScript: GDScript = preload("res://scenes/arena.gd")
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


func test_camera_frames_the_whole_arena() -> void:
	var camera: Camera3D = _arena.get_node("Camera")
	var view: Rect2 = _arena.get_viewport().get_visible_rect()
	for corner: Vector3 in ArenaScript.ARENA_CORNERS:
		assert_true(view.has_point(camera.unproject_position(corner)), "%s in view" % corner)
	for corner: Vector3 in ArenaScript.ARENA_CORNERS:
		assert_almost_eq(absf(corner.x), ArenaLayout.SIZE.x / 2.0, 0.001, "corner x")
		assert_almost_eq(absf(corner.z), ArenaLayout.SIZE.y / 2.0, 0.001, "corner z")


func test_arena_has_back_button_and_joystick() -> void:
	var back: Button = _arena.get_node("Hud/BackButton")
	assert_eq(back.text, "Back")
	assert_not_null(_arena.get_node("Hud/TouchJoystick"))


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
