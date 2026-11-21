extends Control

const ARENA_SCENE: String = "res://scenes/arena.tscn"

@onready var _play_button: Button = $Center/Column/PlayButton


func _ready() -> void:
	_play_button.pressed.connect(_on_play_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(ARENA_SCENE)
