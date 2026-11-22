class_name BackButton
extends Button
## The Back button of every screen except home: top-left, with the back arrow; returns to the
## home screen.


func _ready() -> void:
	icon = Icons.get_icon("back")
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Screens.go_home()
