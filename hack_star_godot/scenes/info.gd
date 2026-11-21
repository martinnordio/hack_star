extends Control
## The info page: every word of the vocabulary with its meaning, in a scrolling list (spec S9).

@onready var _rows: VBoxContainer = $Margin/Column/Scroll/Rows


func _ready() -> void:
	for entry: Dictionary in Vocabulary.LIST:
		_rows.add_child(_row(entry))


static func _row(entry: Dictionary) -> VBoxContainer:
	var row: VBoxContainer = VBoxContainer.new()
	row.name = String(entry["word"]).validate_node_name()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var word: Label = Label.new()
	word.name = "Word"
	word.text = entry["word"]
	word.theme_type_variation = &"WordLabel"
	var meaning: Label = Label.new()
	meaning.name = "Meaning"
	meaning.text = entry["meaning"]
	meaning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	meaning.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(word)
	row.add_child(meaning)
	return row
