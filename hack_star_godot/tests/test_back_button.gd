extends GutTest

const BACK_BUTTON: PackedScene = preload("res://scenes/ui/back_button.tscn")


func test_back_button_says_back_and_is_big_enough_for_a_thumb() -> void:
	var button: BackButton = autofree(BACK_BUTTON.instantiate())
	add_child(button)
	assert_eq(button.text, "Back")
	assert_gte(button.custom_minimum_size.y, 80.0)


func test_pressed_goes_home() -> void:
	var tree: SceneTree = get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	var button: BackButton = BACK_BUTTON.instantiate()
	placeholder.add_child(button)
	button.pressed.emit()
	await wait_process_frames(2)
	var shown: Node = tree.current_scene
	assert_eq(shown.scene_file_path, Screens.HOME, "Back opens the home screen")
	shown.queue_free()
	await wait_process_frames(1)
	tree.current_scene = previous
