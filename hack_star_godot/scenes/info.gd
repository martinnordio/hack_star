extends Control
## The info page: "How to play" (`ControlsHelp`, spec 16 S30), then every word of the vocabulary
## with its meaning, in a scrolling list (spec S9).

@onready var _rows: VBoxContainer = $Margin/Column/Scroll/Rows


func _ready() -> void:
	_rows.add_child(_heading("HowToPlayHeading", "How to play"))
	for section: Dictionary in ControlsHelp.how_to_play():
		_rows.add_child(_row(section["title"], section["text"]))
	_rows.add_child(_heading("WordsHeading", "Words"))
	for entry: Dictionary in Vocabulary.LIST:
		_rows.add_child(_row(entry["word"], entry["meaning"]))


static func _heading(node_name: String, text: String) -> Label:
	var heading: Label = Label.new()
	heading.name = node_name
	heading.text = text
	heading.theme_type_variation = &"SubheadingLabel"
	return heading


static func _row(title: String, text: String) -> VBoxContainer:
	var row: VBoxContainer = VBoxContainer.new()
	row.name = title.validate_node_name()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var word: Label = Label.new()
	word.name = "Word"
	word.text = title
	word.theme_type_variation = &"WordLabel"
	var meaning: Label = Label.new()
	meaning.name = "Meaning"
	meaning.text = text
	meaning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	meaning.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(word)
	row.add_child(meaning)
	return row
