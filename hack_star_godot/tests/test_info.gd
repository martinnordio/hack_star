extends GutTest

const INFO: PackedScene = preload("res://scenes/info.tscn")
const ROWS_PATH: String = "Margin/Column/Scroll/Rows"


func _show_info() -> Control:
	var screen: Control = autofree(INFO.instantiate())
	add_child(screen)
	return screen


func test_has_one_row_per_word_in_order() -> void:
	var rows: Node = _show_info().get_node(ROWS_PATH)
	assert_eq(rows.get_child_count(), Vocabulary.LIST.size())
	for index: int in Vocabulary.LIST.size():
		var row: Node = rows.get_child(index)
		var entry: Dictionary = Vocabulary.LIST[index]
		assert_eq(row.get_node("Word").text, entry["word"])
		assert_eq(row.get_node("Meaning").text, entry["meaning"])


func test_words_are_bold_and_meanings_wrap() -> void:
	var row: Node = _show_info().get_node(ROWS_PATH).get_child(0)
	assert_true(row.get_node("Word").get_theme_font("font") is FontVariation)
	var meaning: Label = row.get_node("Meaning")
	assert_eq(meaning.autowrap_mode, TextServer.AUTOWRAP_WORD_SMART)


func test_back_goes_home() -> void:
	var tree: SceneTree = get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	var screen: Control = INFO.instantiate()
	placeholder.add_child(screen)
	screen.get_node("Margin/Column/Header/BackButton").pressed.emit()
	await wait_process_frames(2)
	var shown: Node = tree.current_scene
	assert_eq(shown.scene_file_path, Screens.HOME, "Back opens the home screen")
	shown.queue_free()
	await wait_process_frames(1)
	tree.current_scene = previous
