extends Control
## The fighter screen: the fighter in 3D on its pedestal in a frame, its rarity, trophies, power
## level and Prestige, and one button per skin with the fighter's picture in that skin that
## previews it. **Select** makes an unlocked fighter and the previewed skin the home fighter; for
## a locked fighter it is disabled. The fighter comes from `GameState.viewed_fighter`. An animated
## picture fighter turns with a drag over it and shoots with a tap (spec 09, M9).

const SKIN_BUTTON: PackedScene = preload("res://scenes/ui/skin_button.tscn")

var _fighter_id: String = ""
var _skin_id: String = ""

@onready var _title: Label = $Margin/Column/Header/Title
@onready var _body: BoxContainer = $Margin/Column/Body
@onready var _stage: FighterStage = $Margin/Column/Body/StageFrame/FighterStage
@onready var _details: Control = $Margin/Column/Body/Details
@onready var _rarity_label: Label = $Margin/Column/Body/Details/RarityLabel
@onready var _trophies_chip: IconChip = $Margin/Column/Body/Details/Stats/TrophiesChip
@onready var _power_chip: IconChip = $Margin/Column/Body/Details/Stats/PowerChip
@onready var _badge: PrestigeBadge = $Margin/Column/Body/Details/Stats/PrestigeBadge
@onready var _skin_row: Container = $Margin/Column/Body/Details/SkinRow
@onready var _select_button: Button = $Margin/Column/Body/Details/SelectButton


func _ready() -> void:
	_fighter_id = GameState.viewed_fighter
	_skin_id = GameState.selected_skins[_fighter_id]
	var fighter: Dictionary = Fighters.get_fighter(_fighter_id)
	_title.text = fighter["name"]
	_rarity_label.text = fighter["rarity"]
	_rarity_label.add_theme_color_override("font_color", Rarity.color(fighter["rarity"]))
	_build_skin_buttons(fighter["skins"])
	_stage.interactive = true
	_stage.show_fighter(_fighter_id, _skin_id)
	_select_button.pressed.connect(_on_select_pressed)
	GameState.progress_changed.connect(_refresh_hack_state)
	_refresh_hack_state()
	resized.connect(_arrange)
	_arrange()
	_show_skin_pictures()
	await FighterPictures.ensure_skins(self, _fighter_id)
	if is_inside_tree():
		_show_skin_pictures()


# What changes while the screen is open (a hack, or progress from another tab): the trophies and
# Prestige badge, the power maximum and whether the fighter can be selected.
func _refresh_hack_state() -> void:
	_trophies_chip.text = str(GameState.trophies[_fighter_id])
	_badge.show_for_trophies(GameState.trophies[_fighter_id])
	_power_chip.text = Hacks.power_amount(
		GameState.power_levels[_fighter_id], GameState.active_hacks
	)
	var unlocked: bool = GameState.is_unlocked(_fighter_id)
	_select_button.disabled = not unlocked
	_select_button.text = "Select" if unlocked else "Locked"
	_select_button.icon = Icons.get_icon("check" if unlocked else "lock")


# Wide: the fighter on the left, the details on the right. Tall: one column.
func _arrange() -> void:
	_body.vertical = size.x <= size.y


func _build_skin_buttons(skins: Array) -> void:
	var group: ButtonGroup = ButtonGroup.new()
	for skin: Dictionary in skins:
		var button: SkinButton = SKIN_BUTTON.instantiate()
		button.name = String(skin["id"]).capitalize().replace(" ", "")
		_skin_row.add_child(button)
		button.setup(skin, group)
		button.button_pressed = skin["id"] == _skin_id
		button.pressed.connect(_on_skin_pressed.bind(skin["id"]))


func _show_skin_pictures() -> void:
	for button: SkinButton in _skin_row.get_children():
		button.set_picture(FighterPictures.cached_skin(_fighter_id, button.skin_id))


func _on_skin_pressed(skin_id: String) -> void:
	_skin_id = skin_id
	_stage.show_fighter(_fighter_id, _skin_id)


func _on_select_pressed() -> void:
	if GameState.select(_fighter_id, _skin_id):
		Screens.go_home()
