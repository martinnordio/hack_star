extends Node
## Keeps the window's content scale factor at `UiScale.factor`, so buttons and text are never
## smaller than a thumb and a reader can use (spec 04, D13).


func _ready() -> void:
	var window: Window = get_window()
	window.size_changed.connect(_update)
	_update()


func _update() -> void:
	var window: Window = get_window()
	var base_size: Vector2 = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	window.content_scale_factor = UiScale.factor(Vector2(window.size), base_size)
