extends Control
## The result screen after a match (spec 07, D10): Victory, Defeat with the place, or Time's up,
## the player's fighter, **Play again** and **Home**. It reads `GameState.last_result`; with no
## result it goes home. The trophy part shows the reward of the match
## (`last_result["reward"]`): the change, the count and the bar count up; a new Prestige is
## celebrated.

## Content height below which the fighter is hidden so the trophy part and the buttons fit.
const SHORT_HEIGHT: float = 700.0
## Seconds the count takes.
const COUNT_SECONDS: float = 1.0

var _reward: Dictionary = {}
var _count_tween: Tween
var _celebrated: bool = false

@onready var _heading: Label = $Margin/Column/Heading
@onready var _line: Label = $Margin/Column/Line
@onready var _body: BoxContainer = $Margin/Column/Body
@onready var _stage: FighterStage = $Margin/Column/Body/FighterStage
@onready var _trophy_panel: Control = $Margin/Column/TrophyPanel
@onready var _change_label: Label = $Margin/Column/TrophyPanel/Trophies/ChangeLabel
@onready var _count_label: Label = $Margin/Column/TrophyPanel/Trophies/CountLabel
@onready var _bar: ProgressBar = $Margin/Column/TrophyPanel/Trophies/PrestigeBar
@onready var _celebration: Control = $Margin/Column/TrophyPanel/Trophies/Celebration
@onready var _prestige_label: Label = $Margin/Column/TrophyPanel/Trophies/Celebration/PrestigeLabel
@onready var _badge: PrestigeBadge = $Margin/Column/TrophyPanel/Trophies/Celebration/PrestigeBadge
@onready var _burst: CPUParticles2D = $Margin/Column/TrophyPanel/Trophies/Celebration/Burst
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
	var short: bool = size.y < SHORT_HEIGHT
	_stage.visible = not short
	_heading.add_theme_font_size_override("font_size", 56 if short else 96)
	_play_again_button.custom_minimum_size.y = 72.0 if short else 120.0
	_home_button.custom_minimum_size.y = 64.0 if short else 80.0


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
	_show_trophies(result.get("reward", {}))


func _show_trophies(reward: Dictionary) -> void:
	_trophy_panel.visible = not reward.is_empty()
	if reward.is_empty():
		return
	_reward = reward
	var after: int = reward["after"]
	_bar.min_value = Prestige.floor_of(after)
	_bar.max_value = Prestige.next_at(after)
	_prestige_label.text = "PRESTIGE %d!" % reward["prestige_after"]
	_badge.show_for_trophies(after)
	_apply_count(0.0)
	_count_tween = create_tween()
	_count_tween.tween_method(_apply_count, 0.0, 1.0, COUNT_SECONDS)


## Jumps the count to its end (the tests, and a player who taps).
func finish_count() -> void:
	if _reward.is_empty():
		return
	if _count_tween != null:
		_count_tween.kill()
	_apply_count(1.0)


# Shows the count at `progress` (0 to 1) between the old and the new trophies.
func _apply_count(progress: float) -> void:
	var before: int = _reward["before"]
	var after: int = _reward["after"]
	var shown: int = roundi(lerpf(before, after, progress))
	_change_label.text = "%+d trophies" % (shown - before)
	_count_label.text = "%d / %d" % [shown, Prestige.next_at(after)]
	_bar.value = shown
	if not _celebrated and _reward["prestige_after"] > _reward["prestige_before"]:
		if shown >= Prestige.floor_of(after):
			_celebrate()


func _celebrate() -> void:
	_celebrated = true
	_celebration.visible = true
	await get_tree().process_frame
	_celebration.pivot_offset = _celebration.size / 2.0
	_celebration.scale = Vector2.ONE * 0.6
	var pop: Tween = create_tween()
	pop.tween_property(_celebration, "scale", Vector2.ONE * 1.1, 0.25)
	pop.tween_property(_celebration, "scale", Vector2.ONE, 0.15)
	_burst.position = _celebration.size / 2.0
	_burst.restart()


func _on_play_again_pressed() -> void:
	Screens.go_to(Screens.MATCH)


func _on_home_pressed() -> void:
	Screens.go_home()
