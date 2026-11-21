extends GutTest

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
## Inner face of the east wall (x = 8.25 - 0.25) and the north/south walls (z = 6.25 - 0.25).
const EAST_WALL_INNER_X: float = 8.0
const SOUTH_WALL_INNER_Z: float = 6.0

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
	assert_gte(walls.size(), 7, "four border walls and some inner walls")
	for wall: Node in walls:
		assert_true(wall is StaticBody3D, "%s is a StaticBody3D" % wall.name)
	assert_true(_arena.get_node("Floor") is StaticBody3D, "floor is a StaticBody3D")


func test_camera_frames_the_whole_arena() -> void:
	var camera: Camera3D = _arena.get_node("Camera")
	var view: Rect2 = _arena.get_viewport().get_visible_rect()
	for x: float in [-8.5, 8.5]:
		for z: float in [-6.5, 6.5]:
			var corner: Vector3 = Vector3(x, 1.2, z)
			assert_true(view.has_point(camera.unproject_position(corner)), "%s in view" % corner)


func test_arena_has_back_button_and_joystick() -> void:
	var back: Button = _arena.get_node("Hud/BackButton")
	assert_eq(back.text, "Back")
	assert_not_null(_arena.get_node("Hud/TouchJoystick"))


func test_arena_has_fps_label_top_right() -> void:
	var label: Label = _arena.get_node("Hud/FpsLabel")
	assert_true(label.text.begins_with("FPS: "), "label shows the frame rate")
	assert_eq(label.anchor_left, 1.0, "label is anchored to the right")
	assert_eq(label.anchor_top, 0.0, "label is anchored to the top")


func test_fighter_stops_at_east_wall() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	# 150 frames at 60 per second and 5 m/s is 12.5 m, more than the 8 m to the wall.
	await wait_physics_frames(150)
	var position: Vector3 = fighter.global_position
	assert_lt(position.x, EAST_WALL_INNER_X, "fighter stays inside the east wall")
	assert_gt(position.x, EAST_WALL_INNER_X - 1.0, "fighter reached the east wall")
	assert_lt(absf(position.z), SOUTH_WALL_INNER_Z, "fighter stays between north and south")
	assert_almost_eq(position.y, 0.0, 0.01, "fighter stays on the floor")
	assert_gt(fighter.rotation.y, -PI / 2.0 - 0.01, "fighter faces east")
	assert_lt(fighter.rotation.y, -PI / 2.0 + 0.01, "fighter faces east")
