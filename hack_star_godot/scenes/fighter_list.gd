extends Control
## The fighter list: a scrolling grid with one card per fighter. The pictures come from the
## cache of `GameState` and are rendered once per game start.

const CARD: PackedScene = preload("res://scenes/ui/fighter_card.tscn")
const CARD_WIDTH: float = 300.0

@onready var _scroll: ScrollContainer = $Margin/Column/Scroll
@onready var _grid: GridContainer = $Margin/Column/Scroll/Grid


func _ready() -> void:
	for fighter_id: String in Fighters.ids():
		var card: FighterCard = CARD.instantiate()
		card.name = fighter_id.capitalize()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_grid.add_child(card)
		card.setup(fighter_id)
	_scroll.resized.connect(_update_columns)
	_update_columns()
	await FighterPictures.ensure(self)
	if is_inside_tree():
		for card: FighterCard in _cards():
			card.set_picture(FighterPictures.cached(card.fighter_id))


func _cards() -> Array[FighterCard]:
	var cards: Array[FighterCard] = []
	for child: Node in _grid.get_children():
		cards.append(child as FighterCard)
	return cards


# As many columns as fit the width, at least one.
func _update_columns() -> void:
	_grid.columns = maxi(1, int(_scroll.size.x / CARD_WIDTH))
