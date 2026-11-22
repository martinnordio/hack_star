class_name PrestigeBadge
extends PanelContainer
## The Prestige badge of a fighter with 1000 trophies or more; it hides itself below that.

@onready var _label: Label = $Label


## Shows the badge for the Prestige level of `trophies`, or hides it when the level is 0.
func show_for_trophies(trophies: int) -> void:
	var level: int = Prestige.level(trophies)
	visible = level >= 1
	_label.text = "Prestige %d" % level
