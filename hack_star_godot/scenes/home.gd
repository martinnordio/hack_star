extends Control
## The home screen: the chosen fighter and skin, the player's trophies and credits, the
## fighter's Prestige and **Play**. Fighters and Info open with Steps 7 and 9.

@onready var _trophies_label: Label = $Margin/Column/TopBar/TrophiesLabel
@onready var _credits_label: Label = $Margin/Column/TopBar/CreditsLabel
@onready var _stage: FighterStage = $Margin/Column/Body/FighterStage
@onready var _name_label: Label = $Margin/Column/Body/Controls/NameRow/NameLabel
@onready var _badge: PrestigeBadge = $Margin/Column/Body/Controls/NameRow/PrestigeBadge
@onready var _body: BoxContainer = $Margin/Column/Body
@onready var _controls: Control = $Margin/Column/Body/Controls
@onready var _play_button: Button = $Margin/Column/Body/Controls/PlayButton


func _ready() -> void:
	_play_button.pressed.connect(_on_play_pressed)
	resized.connect(_arrange)
	_arrange()
	_refresh()


# Wide: the fighter on the left, the buttons on the right. Tall: one column.
func _arrange() -> void:
	var wide: bool = size.x > size.y
	_body.vertical = not wide
	_controls.size_flags_vertical = Control.SIZE_EXPAND_FILL if wide else Control.SIZE_FILL


func _refresh() -> void:
	var fighter_id: String = GameState.selected_fighter
	_trophies_label.text = "Trophies: %d" % GameState.total_trophies()
	_credits_label.text = "Credits: %d" % GameState.credits
	_name_label.text = Fighters.get_fighter(fighter_id)["name"]
	_badge.show_for_trophies(GameState.trophies[fighter_id])
	_stage.show_fighter(fighter_id, GameState.selected_skin())


func _on_play_pressed() -> void:
	Screens.go_to(Screens.ARENA)
