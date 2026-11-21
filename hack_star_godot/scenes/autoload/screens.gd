extends Node
## The one way from screen to screen: every screen has a constant here and every Back goes home.
## A later spec adds its screen as one more constant.

const HOME: String = "res://scenes/home.tscn"
const ARENA: String = "res://scenes/arena.tscn"
const FIGHTERS: String = "res://scenes/fighter_list.tscn"


func go_to(path: String) -> Error:
	return get_tree().change_scene_to_file(path)


func go_home() -> Error:
	return go_to(HOME)
