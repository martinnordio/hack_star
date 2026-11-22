class_name FighterCard
extends PanelContainer
## One fighter in the list (spec 09, G7): its picture on a backdrop in the rarity's colour, name,
## rarity, Prestige badge, and trophies and power as icon chips. A locked fighter has a grey
## backdrop, a grey picture with a lock icon and a lock chip. Pressing the card emits `opened`
## (a button over the card, so a drag that scrolls the list does not open it).

signal opened(fighter_id: String)

const LOCKED_BACKDROP: Color = Color(0.36, 0.36, 0.42)
const CHIP_FONT_SIZE: int = 26
const CHIP_ICON_SIZE: float = 30.0

var fighter_id: String = ""

@onready var _backdrop: PanelContainer = $Column/Backdrop
@onready var _picture: TextureRect = $Column/Backdrop/Picture
@onready var _lock_icon: TextureRect = $Column/Backdrop/LockIcon
@onready var _name_label: Label = $Column/NameLabel
@onready var _badge: PrestigeBadge = $Column/PrestigeBadge
@onready var _rarity_label: Label = $Column/RarityLabel
@onready var _trophies_chip: IconChip = $Column/Stats/TrophiesChip
@onready var _power_chip: IconChip = $Column/Stats/PowerChip
@onready var _lock_chip: IconChip = $Column/LockChip
@onready var _open_button: Button = $OpenButton


func _ready() -> void:
	_open_button.pressed.connect(func() -> void: opened.emit(fighter_id))
	_lock_icon.texture = Icons.get_icon("lock")
	_lock_icon.modulate = _lock_chip.icon_color
	for chip: IconChip in [_trophies_chip, _power_chip, _lock_chip]:
		chip.get_node("Row/Label").add_theme_font_size_override("font_size", CHIP_FONT_SIZE)
		chip.get_node("Row/Icon").custom_minimum_size = Vector2.ONE * CHIP_ICON_SIZE


## Fills the card from the catalogue and `GameState`.
func setup(new_fighter_id: String) -> void:
	fighter_id = new_fighter_id
	var fighter: Dictionary = Fighters.get_fighter(fighter_id)
	_name_label.text = fighter["name"]
	_rarity_label.text = fighter["rarity"]
	_rarity_label.add_theme_color_override("font_color", Rarity.color(fighter["rarity"]))
	_trophies_chip.text = str(GameState.trophies[fighter_id])
	_power_chip.text = Hacks.power_amount(
		GameState.power_levels[fighter_id], GameState.active_hacks
	)
	_badge.show_for_trophies(GameState.trophies[fighter_id])
	var unlocked: bool = GameState.is_unlocked(fighter_id)
	_lock_icon.visible = not unlocked
	_lock_chip.visible = not unlocked
	var backdrop: StyleBoxFlat = _backdrop.get_theme_stylebox("panel")
	backdrop.bg_color = Rarity.color(fighter["rarity"]) if unlocked else LOCKED_BACKDROP
	(_picture.material as ShaderMaterial).set_shader_parameter("grey", not unlocked)
	set_picture(FighterPictures.cached(fighter_id))


## The colour behind the picture: the rarity's colour, or grey while the fighter is locked.
func backdrop_color() -> Color:
	return (_backdrop.get_theme_stylebox("panel") as StyleBoxFlat).bg_color


## True while the picture is drawn in grey (a locked fighter).
func is_picture_grey() -> bool:
	return (_picture.material as ShaderMaterial).get_shader_parameter("grey")


func set_picture(texture: Texture2D) -> void:
	_picture.texture = texture
