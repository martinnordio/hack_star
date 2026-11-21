extends Control
## The result screen after a match (spec 07, D10): Victory, Defeat with the place, or Time's up,
## the player's fighter, **Play again** and **Home**. It reads `GameState.last_result`; with no
## result it goes home.

@onready var _heading: Label = $Margin/Column/Heading
@onready var _line: Label = $Margin/Column/Line
@onready var _body: BoxContainer = $Margin/Column/Body
@onready var _stage: FighterStage = $Margin/Column/Body/FighterStage
@onready var _controls: Control = $Margin/Column/Body/Controls
@onready var _play_again_button: Button = $Margin/Column/Body/Controls/PlayAgainButton
@onready var _home_button: Button = $Margin/Column/Body/Controls/HomeButton


func _ready() -> void:
	var result: Dictionary = GameState.last_result
	if result.is_empty():
		Screens.go_home.call_deferred()
		return
	_play_again_button.pressed.connect(_on_play_again_pressed)
	_home_button.pressed.connect(_on_home_pressed)
	resized.connect(_arrange)
	_arrange()
	_show_result(result)


# Wide: the fighter on the left, the buttons on the right. Tall: one column.
func _arrange() -> void:
	var wide: bool = size.x > size.y
	_body.vertical = not wide
	_controls.size_flags_vertical = Control.SIZE_EXPAND_FILL if wide else Control.SIZE_FILL


func _show_result(result: Dictionary) -> void:
	match result["outcome"]:
		Match.Result.VICTORY:
			_heading.text = "Victory!"
			_line.text = "You are the last one standing!"
		Match.Result.DEFEAT:
			_heading.text = "Defeat"
			_line.text = "You finished %s" % Match.ordinal(result["place"])
		_:
			_heading.text = "Time's up!"
			_line.text = "It's a draw"
	_stage.show_fighter(result["fighter"], result["skin"])


func _on_play_again_pressed() -> void:
	Screens.go_to(Screens.MATCH)


func _on_home_pressed() -> void:
	Screens.go_home()
