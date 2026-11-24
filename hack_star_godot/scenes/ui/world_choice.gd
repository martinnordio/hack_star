class_name WorldChoice
extends Control
## The minimal world choice of home (spec 09, W2, D10): a small panel over the screen with one
## button per world (`Worlds.LIST`), the current one marked green with a tick. A choice sets
## `GameState.world` (used by Play and Training, kept while the game is open) and closes the
## panel; a tap beside the panel closes it without a change. Spec 18 replaces it.

signal chosen(world_id: String)

const BUTTON_SIZE: Vector2 = Vector2(400, 84)

@onready var _dim: ColorRect = $Dim
@onready var _list: VBoxContainer = $Panel/Column/Worlds


func _ready() -> void:
	_dim.gui_input.connect(_on_dim_input)
	for world: Dictionary in Worlds.LIST:
		var button: Button = Button.new()
		button.name = button_name(world["id"])
		button.text = world["name"]
		button.custom_minimum_size = BUTTON_SIZE
		button.pressed.connect(choose.bind(world["id"]))
		_list.add_child(button)
	_mark()


## The node name of a world's button (`CanyonButton`, `GlimmerIslesButton`).
static func button_name(world_id: String) -> String:
	return world_id.to_pascal_case() + "Button"


## Shows the panel with the current world marked.
func open() -> void:
	_mark()
	show()


## Makes `world_id` the world of Play and Training and closes the panel.
func choose(world_id: String) -> void:
	if Worlds.is_unlocked(world_id):
		GameState.world = world_id
	hide()
	chosen.emit(GameState.world)


func _mark() -> void:
	for world_id: String in Worlds.ids():
		var button: Button = _list.get_node(button_name(world_id))
		var current: bool = world_id == GameState.world
		button.theme_type_variation = &"GreenButton" if current else &""
		button.icon = Icons.get_icon("check" if current else "world")


func _on_dim_input(event: InputEvent) -> void:
	var press: bool = event is InputEventMouseButton or event is InputEventScreenTouch
	if press and event.is_pressed():
		hide()
