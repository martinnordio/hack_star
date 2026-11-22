extends Node
## The one way from screen to screen: every screen has a constant here and every Back goes home.
## A later spec adds its screen as one more constant.

const HOME: String = "res://scenes/home.tscn"
const ARENA: String = "res://scenes/arena.tscn"
const FIGHTERS: String = "res://scenes/fighter_list.tscn"
const FIGHTER: String = "res://scenes/fighter_screen.tscn"
const INFO: String = "res://scenes/info.tscn"
const HACK: String = "res://scenes/hack_screen.tscn"
const QR: String = "res://scenes/qr_page.tscn"
const MATCH: String = "res://scenes/match.tscn"
const RESULT: String = "res://scenes/result_screen.tscn"


func go_to(path: String) -> Error:
	return get_tree().change_scene_to_file(path)


func go_home() -> Error:
	return go_to(HOME)
