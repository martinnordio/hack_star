extends Control

@onready var _play_button: Button = $Center/Column/PlayButton


func _ready() -> void:
	_play_button.pressed.connect(_on_play_pressed)


func _on_play_pressed() -> void:
	Screens.go_to(Screens.ARENA)
