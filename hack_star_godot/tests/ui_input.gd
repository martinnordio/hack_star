class_name UiInput
extends RefCounted
## Real input for the screen tests: a mouse click or a touch at the centre of a control, pushed
## into its viewport, so the input handling and the disabled state are part of the test.


## A left mouse click (press and release) on the centre of `control`.
static func click(viewport: Viewport, control: Control) -> void:
	var position: Vector2 = control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event: InputEventMouseButton = InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed else 0
		event.position = position
		event.global_position = position
		viewport.push_input(event, true)


## A touch (`InputEventScreenTouch`, down and up) on the centre of `control`.
static func touch(viewport: Viewport, control: Control) -> void:
	var position: Vector2 = control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event: InputEventScreenTouch = InputEventScreenTouch.new()
		event.index = 0
		event.pressed = pressed
		event.position = position
		viewport.push_input(event, true)


## Shows `scene` under a placeholder current scene of the root window, so that a screen change
## can be observed; input goes to the root (a freed sub-viewport would fail while the event is
## still being pushed). Returns `{previous, viewport, screen}` for `settle`.
static func open(test: GutTest, scene: PackedScene) -> Dictionary:
	var tree: SceneTree = test.get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	var root_size: Vector2i = tree.root.size
	tree.root.size = Vector2i(1280, 720)
	var screen: Control = scene.instantiate()
	placeholder.add_child(screen)
	await test.wait_process_frames(2)
	return {"previous": previous, "viewport": tree.root, "screen": screen, "root_size": root_size}


## Waits for a screen change and returns the current scene (the placeholder when none came);
## the caller frees it with `close`.
static func settle(test: GutTest, opened: Dictionary) -> Node:
	await test.wait_process_frames(2)
	var tree: SceneTree = test.get_tree()
	var shown: Node = tree.current_scene
	tree.current_scene = opened["previous"]
	tree.root.size = opened["root_size"]
	return shown


static func close(test: GutTest, shown: Node) -> void:
	shown.queue_free()
	await test.wait_process_frames(1)
