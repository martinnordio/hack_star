extends GutTest
## Space fires in Training and a mouse click does not (spec 16, D11 and D12).

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")

var _arena: Node3D


func before_each() -> void:
	_arena = ARENA_SCENE.instantiate()
	add_child_autofree(_arena)


func after_each() -> void:
	Input.action_release("shoot")


func _space(pressed: bool) -> InputEventKey:
	var event: InputEventKey = InputEventKey.new()
	event.physical_keycode = KEY_SPACE
	event.keycode = KEY_SPACE
	event.pressed = pressed
	return event


func _fighter() -> Fighter:
	return _arena.get_node("Fighter")


func _shots() -> Node3D:
	return _arena.get_node("Shots")


## Records the direction of every shot fired from now on (a shot frees itself when it ends).
func _record_shots() -> Array[Vector3]:
	var directions: Array[Vector3] = []
	_shots().child_entered_tree.connect(
		func(shot: Node) -> void: directions.append((shot as Shot).direction)
	)
	return directions


func test_space_fires_at_the_nearest_dummy_in_range() -> void:
	_fighter().position = Vector3(-3.0, 0.0, -2.5)
	await wait_physics_frames(2)
	var shots: Array[Vector3] = _record_shots()
	Input.action_press("shoot")
	await wait_process_frames(2)
	assert_eq(shots.size(), 1, "one shot")
	assert_almost_eq(shots[0], Vector3.LEFT, Vector3.ONE * 0.05, "at the dummy 1 m west")


func test_space_fires_straight_ahead_when_nothing_is_in_range() -> void:
	var forward: Vector3 = -_fighter().global_basis.z
	var shots: Array[Vector3] = _record_shots()
	Input.action_press("shoot")
	await wait_process_frames(2)
	assert_eq(shots.size(), 1, "one shot")
	assert_almost_eq(shots[0], Vector3(forward.x, 0.0, forward.z), Vector3.ONE * 0.05)


func test_holding_space_fires_again_only_after_the_cool_down() -> void:
	var shots: Array[Vector3] = _record_shots()
	Input.action_press("shoot")
	await wait_seconds(0.15)
	assert_eq(shots.size(), 1, "still one shot during the cool-down")
	await wait_seconds(0.3)
	assert_eq(shots.size(), 2, "a second shot after the cool-down")
	Input.action_release("shoot")
	await wait_seconds(0.5)
	assert_eq(shots.size(), 2, "released: no more shots")


func test_a_pressed_space_key_fires() -> void:
	var shots: Array[Vector3] = _record_shots()
	Input.parse_input_event(_space(true))
	await wait_process_frames(2)
	Input.parse_input_event(_space(false))
	assert_eq(shots.size(), 1, "the key fires")


func test_space_does_not_press_back() -> void:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var arena: Node3D = ARENA_SCENE.instantiate()
	viewport.add_child(arena)
	await wait_process_frames(2)
	var back: Button = arena.get_node("Hud/BackButton")
	for connection: Dictionary in back.pressed.get_connections():
		back.pressed.disconnect(connection["callable"])
	watch_signals(back)
	UiInput.click(viewport, back)
	viewport.push_input(_space(true), true)
	viewport.push_input(_space(false), true)
	await wait_process_frames(2)
	assert_eq(back.focus_mode, Control.FOCUS_NONE, "Back takes no focus")
	assert_signal_emit_count(back, "pressed", 1, "only the click pressed Back")


func test_a_mouse_click_fires_nothing() -> void:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var arena: Node3D = ARENA_SCENE.instantiate()
	viewport.add_child(arena)
	await wait_process_frames(2)
	var at: Vector2 = Vector2(900.0, 300.0)
	for pressed: bool in [true, false]:
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = pressed
		click.position = at
		click.global_position = at
		viewport.push_input(click, true)
	await wait_seconds(0.5)
	assert_eq(arena.get_node("Shots").get_child_count(), 0, "no shot")
