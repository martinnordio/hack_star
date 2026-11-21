extends GutTest

const START_SCREEN: PackedScene = preload("res://scenes/start_screen.tscn")


func test_scene_loads_and_shows_title() -> void:
	var screen: Control = autofree(START_SCREEN.instantiate())
	add_child(screen)
	var title: Label = screen.get_node("Center/Column/Title")
	assert_eq(title.text, "Hack star")


func test_scene_has_play_button() -> void:
	var screen: Control = autofree(START_SCREEN.instantiate())
	add_child(screen)
	var button: Button = screen.get_node("Center/Column/PlayButton")
	assert_eq(button.text, "Play")
	assert_gte(button.custom_minimum_size.y, 100.0, "big enough for a thumb")
