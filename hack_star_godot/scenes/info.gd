extends Control
## The info page: "How to play" (`ControlsHelp`, spec 16 S30), then every word of the vocabulary
## with its meaning, in a scrolling list (spec S9); under it the **Show FPS (play-test)** switch
## for the author's play-test on a device (spec 09, D8).

@onready var _rows: VBoxContainer = $Margin/Column/Scroll/Rows
@onready var _fps_switch: CheckButton = $Margin/Column/FpsSwitch


func _ready() -> void:
	_fps_switch.button_pressed = GameState.show_fps
	_fps_switch.toggled.connect(_on_fps_switch_toggled)
	_rows.add_child(_heading("HowToPlayHeading", "How to play"))
	for section: Dictionary in ControlsHelp.how_to_play():
		_rows.add_child(_row(section["title"], section["text"]))
	_rows.add_child(_heading("WordsHeading", "Words"))
	for entry: Dictionary in Vocabulary.LIST:
		_rows.add_child(_row(entry["word"], entry["meaning"]))


func _on_fps_switch_toggled(on: bool) -> void:
	GameState.show_fps = on


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
