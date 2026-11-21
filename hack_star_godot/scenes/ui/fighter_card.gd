class_name FighterCard
extends PanelContainer
## One fighter in the list: picture, name, rarity, trophies, power level and Prestige badge.
## A locked fighter is greyed out and shows a lock label. Pressing the card emits `opened`
## (a button over the card, so a drag that scrolls the list does not open it).

signal opened(fighter_id: String)

const LOCKED_TINT: Color = Color(0.6, 0.6, 0.65)

var fighter_id: String = ""

@onready var _picture: TextureRect = $Column/Picture
@onready var _name_label: Label = $Column/NameLabel
@onready var _badge: PrestigeBadge = $Column/PrestigeBadge
@onready var _rarity_label: Label = $Column/RarityLabel
@onready var _trophies_label: Label = $Column/TrophiesLabel
@onready var _power_label: Label = $Column/PowerLabel
@onready var _lock_label: Label = $Column/LockLabel
@onready var _open_button: Button = $OpenButton


func _ready() -> void:
	_open_button.pressed.connect(func() -> void: opened.emit(fighter_id))


## Fills the card from the catalogue and `GameState`.
func setup(new_fighter_id: String) -> void:
	fighter_id = new_fighter_id
	var fighter: Dictionary = Fighters.get_fighter(fighter_id)
	_name_label.text = fighter["name"]
	_rarity_label.text = fighter["rarity"]
	_rarity_label.add_theme_color_override("font_color", Rarity.color(fighter["rarity"]))
	_trophies_label.text = "Trophies: %d" % GameState.trophies[fighter_id]
	_power_label.text = "Power: %d" % GameState.power_levels[fighter_id]
	_badge.show_for_trophies(GameState.trophies[fighter_id])
	var unlocked: bool = GameState.is_unlocked(fighter_id)
	_lock_label.visible = not unlocked
	modulate = Color.WHITE if unlocked else LOCKED_TINT
	set_picture(FighterPictures.cached(fighter_id))


func set_picture(texture: Texture2D) -> void:
	_picture.texture = texture
