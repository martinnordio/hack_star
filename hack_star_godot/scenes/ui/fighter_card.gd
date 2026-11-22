class_name FighterCard
extends PanelContainer
## One fighter in the list (spec 09, G7): its picture on a backdrop in the rarity's colour, name,
## rarity, Prestige badge, and trophies and power as icon chips. A locked fighter has a grey
## backdrop, a grey picture with a lock icon and a lock chip. Pressing the card emits `opened`
## (a button over the card, so a drag that scrolls the list does not open it). An unlocked animated
## picture fighter's card lives (M10, D40): its figure idles and walks at the bottom right of its
## picture and a light sweep in the rarity's colour crosses the picture every few seconds — only
## while the card is in the visible part of the list.

signal opened(fighter_id: String)

const LOCKED_BACKDROP: Color = Color(0.36, 0.36, 0.42)
const CHIP_FONT_SIZE: int = 26
const CHIP_ICON_SIZE: float = 30.0
## The figure's height as a share of the picture's, and its room from the card's edges (px).
const FIGURE_SHARE: float = 0.6
const FIGURE_MARGIN: Vector2 = Vector2(8.0, 6.0)
## The figure's loop: the front idle frame, then the front walk loop at its frames a second.
const FIGURE_IDLE_SECONDS: float = 1.2
const FIGURE_WALK_SECONDS: float = 1.6
const FIGURE_WALK_FPS: float = 7.5
## The walk's hop (px) and the idle's breathing (stretch).
const FIGURE_HOP: float = 4.0
const FIGURE_BREATH: float = 0.025
## The sweep crosses in `SWEEP_SECONDS` once every `SWEEP_PERIOD`, each card later than the one
## before it by `SWEEP_STAGGER`.
const SWEEP_PERIOD: float = 4.0
const SWEEP_SECONDS: float = 0.8
const SWEEP_STAGGER: float = 0.6
const SWEEP_SHADER: Shader = preload("res://scenes/ui/card_sweep.gdshader")
const FIGURE_SHADER: Shader = preload("res://scenes/ui/card_figure.gdshader")
## The figure's outline (px) and the soft shadow under its feet (share of its width, px high).
const FIGURE_OUTLINE: float = 2.5
const SHADOW_SHARE: float = 0.55
const SHADOW_HEIGHT: float = 12.0
const SHADOW_COLOR: Color = Color(0.05, 0.03, 0.12, 0.45)

var fighter_id: String = ""
## Seconds the card has lived on screen.
var _time: float = 0.0
var _living: bool = false
var _sweep_offset: float = 0.0
var _figure_box: Control
var _figure: TextureRect
var _sweep: TextureRect

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
	set_process(_living)


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
	_setup_living(CutoutFighters.has(fighter_id) and unlocked, Rarity.color(fighter["rarity"]))


## The colour behind the picture: the rarity's colour, or grey while the fighter is locked.
func backdrop_color() -> Color:
	return (_backdrop.get_theme_stylebox("panel") as StyleBoxFlat).bg_color


## True while the picture is drawn in grey (a locked fighter).
func is_picture_grey() -> bool:
	return (_picture.material as ShaderMaterial).get_shader_parameter("grey")


func set_picture(texture: Texture2D) -> void:
	_picture.texture = texture
	if _sweep != null:
		_sweep.texture = texture


## True when the card lives (an unlocked animated fighter).
func is_living() -> bool:
	return _living


## The figure of a living card (null for the other cards).
func get_figure() -> TextureRect:
	return _figure


## The light sweep over the picture of a living card (null for the other cards).
func get_sweep() -> TextureRect:
	return _sweep


## True when some of the card is inside the visible part of its list (the scroll area around
## it, else the window).
func is_on_screen() -> bool:
	if not is_visible_in_tree():
		return false
	var area: Rect2 = get_viewport_rect()
	var parent: Node = get_parent()
	while parent != null:
		if parent is ScrollContainer:
			area = (parent as ScrollContainer).get_global_rect()
			break
		parent = parent.get_parent()
	return get_global_rect().intersects(area)


func _process(delta: float) -> void:
	if is_on_screen():
		_time += delta
		_animate(_time)


func _setup_living(living: bool, rarity_color: Color) -> void:
	if living and _figure == null:
		_build_living()
	_living = living
	set_process(living)
	if _figure == null:
		return
	_figure_box.visible = living
	_sweep.visible = living
	(_sweep.material as ShaderMaterial).set_shader_parameter(
		"band_color", rarity_color.lerp(Color.WHITE, 0.55)
	)
	_sweep_offset = get_index() * SWEEP_STAGGER
	_animate(_time)


# The figure at the picture's bottom right (in a plain box, so the card's layout never resets its
# stretch) and the sweep over the picture, under the lock icon.
func _build_living() -> void:
	var idle: Texture2D = CutoutFighters.frame(fighter_id, "idle_down")
	var height: float = _backdrop.custom_minimum_size.y * FIGURE_SHARE
	var size_px: Vector2 = Vector2(height * idle.get_width() / idle.get_height(), height)
	_sweep = TextureRect.new()
	_sweep.name = "Sweep"
	_sweep.expand_mode = _picture.expand_mode
	_sweep.stretch_mode = _picture.stretch_mode
	_sweep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_sweep.texture = _picture.texture
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = SWEEP_SHADER
	_sweep.material = material
	_backdrop.add_child(_sweep)
	_backdrop.move_child(_sweep, _picture.get_index() + 1)
	_figure_box = Control.new()
	_figure_box.name = "FigureBox"
	_figure_box.custom_minimum_size = size_px + FIGURE_MARGIN
	_figure_box.size_flags_horizontal = Control.SIZE_SHRINK_END
	_figure_box.size_flags_vertical = Control.SIZE_SHRINK_END
	_figure_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_backdrop.add_child(_figure_box)
	_backdrop.move_child(_figure_box, _sweep.get_index() + 1)
	var shadow: Panel = Panel.new()
	shadow.name = "Shadow"
	var oval: StyleBoxFlat = StyleBoxFlat.new()
	oval.bg_color = SHADOW_COLOR
	oval.set_corner_radius_all(int(SHADOW_HEIGHT))
	shadow.add_theme_stylebox_override("panel", oval)
	shadow.size = Vector2(size_px.x * SHADOW_SHARE, SHADOW_HEIGHT)
	shadow.position = Vector2((size_px.x - shadow.size.x) / 2.0, size_px.y - SHADOW_HEIGHT * 0.75)
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_figure_box.add_child(shadow)
	_figure = TextureRect.new()
	_figure.name = "Figure"
	_figure.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_figure.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_figure.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var outline: ShaderMaterial = ShaderMaterial.new()
	outline.shader = FIGURE_SHADER
	outline.set_shader_parameter("radius_uv", Vector2.ONE * FIGURE_OUTLINE / size_px)
	_figure.material = outline
	_figure.size = size_px
	_figure.pivot_offset = Vector2(size_px.x / 2.0, size_px.y)
	_figure_box.add_child(_figure)


# The figure's frame, hop or breathing, and the sweep's place at `time` seconds on screen.
func _animate(time: float) -> void:
	var cycle: float = fposmod(time, FIGURE_IDLE_SECONDS + FIGURE_WALK_SECONDS)
	var walk: float = cycle - FIGURE_IDLE_SECONDS
	if walk >= 0.0:
		var step: float = walk * FIGURE_WALK_FPS
		_figure.texture = CutoutFighters.frame(
			fighter_id, "walk_down", int(step) % CutoutAnimator.WALK_FRAMES
		)
		_figure.position.y = -absf(sin((step + 0.5) * PI / 2.0)) * FIGURE_HOP
		_figure.scale = Vector2.ONE
	else:
		_figure.texture = CutoutFighters.frame(fighter_id, "idle_down")
		_figure.position.y = 0.0
		var breath: float = sin(time * CutoutMotion.BREATH_SPEED) * FIGURE_BREATH
		_figure.scale = Vector2(1.0 - breath * 0.6, 1.0 + breath)
	var sweep: float = fposmod(time - _sweep_offset, SWEEP_PERIOD)
	var progress: float = -1.0
	if sweep < SWEEP_SECONDS:
		progress = lerpf(-0.3, 1.3, sweep / SWEEP_SECONDS)
	(_sweep.material as ShaderMaterial).set_shader_parameter("progress", progress)
