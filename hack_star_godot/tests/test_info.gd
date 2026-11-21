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
	var word: Label = row.get_node("Word")
	assert_eq(word.theme_type_variation, &"WordLabel")
	assert_gt(word.get_theme_constant("outline_size"), 0, "the theme makes the word bold")
	assert_eq(row.get_node("Meaning").get_theme_constant("outline_size"), 0)
	var meaning: Label = row.get_node("Meaning")
	assert_eq(meaning.autowrap_mode, TextServer.AUTOWRAP_WORD_SMART)
	assert_eq(meaning.autowrap_mode, TextServer.AUTOWRAP_WORD_SMART)


func test_back_goes_home_by_click_and_by_touch() -> void:
	for use_touch: bool in [false, true]:
		var opened: Dictionary = await UiInput.open(self, INFO)
		var back: Control = opened["screen"].get_node("Margin/Column/Header/BackButton")
		if use_touch:
			UiInput.touch(opened["viewport"], back)
		else:
			UiInput.click(opened["viewport"], back)
		var shown: Node = await UiInput.settle(self, opened)
		assert_eq(shown.scene_file_path, Screens.HOME, "Back opens home (touch: %s)" % use_touch)
		await UiInput.close(self, shown)
