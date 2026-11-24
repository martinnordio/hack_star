extends Control
## The hack screen: type or scan a code, see what it unlocked, the list of active hacks and a way
## to turn them all off (spec 05, D6–D9). The server checks every code (`HackServer`).

const MESSAGE_COLOR: Color = Color(0.94, 0.95, 1.0)
const SUCCESS_COLOR: Color = Color(1.0, 0.85, 0.3)
const ERROR_COLOR: Color = Color(1.0, 0.55, 0.5)
const MAX_CODE_LENGTH: int = 100
## The celebration is over after this many seconds (spec S7 and D7: at most 2).
const CELEBRATION_SECONDS: float = 1.8
const STAR_COUNT: int = 40
## The time left of the active hacks is refreshed this often while the screen is open.
const REFRESH_SECONDS: float = 60.0
const STAR_TEXTURE_SIZE: int = 32
## The camera messages of D8, by the reason `QrScanner` gives.
const CAMERA_MESSAGES: Dictionary[String, String] = {
	QrScanner.NOT_WEB: "Camera not available — type the code",
	QrScanner.NO_CAMERA: "Camera not available — type the code",
	QrScanner.DENIED: "Camera permission refused — type the code",
	QrScanner.NEEDS_HTTPS: "The camera needs https:// — type the code",
}

static var _star_texture: ImageTexture

## True while a code is being checked.
var busy: bool = false
## Opens the camera; a test emits its signals instead.
var scanner: QrScanner
## Whether this build can scan (D10); a test sets it before the screen is added.
var can_scan: bool = QrScanner.can_scan()

var _pop: Tween
var _stars: CPUParticles2D

@onready var _code_edit: LineEdit = $Margin/Column/Scroll/Content/CodeRow/CodeEdit
@onready var _use_button: Button = $Margin/Column/Scroll/Content/CodeRow/UseButton
@onready var _scan_button: Button = $Margin/Column/Scroll/Content/ScanButton
@onready var _scan_hint: Label = $Margin/Column/Scroll/Content/ScanHint
@onready var _message: Label = $Margin/Column/Scroll/Content/Message
@onready var _active_list: VBoxContainer = $Margin/Column/Scroll/Content/ActiveList
@onready var _reset_button: Button = $Margin/Column/Scroll/Content/ResetButton
@onready var _qr_button: Button = $Margin/Column/Scroll/Content/QrButton
@onready var _confirm: ConfirmationDialog = $ConfirmDialog


func _ready() -> void:
	_code_edit.max_length = MAX_CODE_LENGTH
	_code_edit.text_submitted.connect(submit)
	_use_button.pressed.connect(_on_use_pressed)
	_reset_button.pressed.connect(_on_reset_pressed)
	_qr_button.pressed.connect(_on_qr_pressed)
	_scan_button.pressed.connect(_on_scan_pressed)
	_confirm.confirmed.connect(_on_reset_confirmed)
	_message.resized.connect(_center_message_pivot)
	_use_button.icon = Icons.get_icon("check")
	_scan_button.icon = Icons.get_icon("eye")
	_reset_button.icon = Icons.get_icon("close")
	_qr_button.icon = Icons.get_icon("qr")
	scanner = QrScanner.new()
	scanner.name = "QrScanner"
	scanner.scanned.connect(_on_scanned)
	scanner.failed.connect(_on_scan_failed)
	add_child(scanner)
	_scan_hint.visible = not can_scan
	_scan_hint.add_theme_color_override("font_color", MESSAGE_COLOR)
	_scan_button.disabled = not can_scan
	GameState.progress_changed.connect(_refresh)
	var refresh_timer: Timer = Timer.new()
	refresh_timer.name = "RefreshTimer"
	refresh_timer.wait_time = REFRESH_SECONDS
	refresh_timer.timeout.connect(_refresh)
	add_child(refresh_timer)
	refresh_timer.start()
	_refresh()
	# A game opened from a QR link (`?hack=`, D9) redeems its code here.
	if not GameState.start_code.is_empty():
		var code: String = GameState.start_code
		GameState.start_code = ""
		submit(code)


## Checks a typed or scanned code with the server and shows the outcome.
func submit(text: String) -> void:
	if busy or Hacks.normalize_code(text).is_empty():
		return
	_set_busy(true)
	_message.text = "Checking…"
	_message.add_theme_color_override("font_color", MESSAGE_COLOR)
	var result: Dictionary = await GameState.redeem_code(text)
	if not is_inside_tree():
		return
	_set_busy(false)
	match result["status"]:
		HackServer.STATUS_OK:
			_code_edit.text = ""
			_refresh()
			_celebrate("%s unlocked!" % result["name"])
		HackServer.STATUS_UNKNOWN:
			_show_message("Unknown code", ERROR_COLOR)
		_:
			_show_message("Can't reach the hack server. Try again later.", ERROR_COLOR)


func _on_use_pressed() -> void:
	submit(_code_edit.text)


func _on_scan_pressed() -> void:
	if not busy:
		_show_message("", MESSAGE_COLOR)
		scanner.start()


## A scanned link or plain code goes the same way as a typed code.
func _on_scanned(text: String) -> void:
	var code: String = Hacks.code_from_scan(text)
	if code.is_empty():
		_show_message("Unknown code", ERROR_COLOR)
		return
	submit(code)


func _on_scan_failed(reason: String) -> void:
	_show_message(CAMERA_MESSAGES.get(reason, ""), ERROR_COLOR)


func _on_qr_pressed() -> void:
	Screens.go_to(Screens.QR)


func _on_reset_pressed() -> void:
	if not GameState.active_hacks.is_empty():
		_confirm.popup_centered()


func _on_reset_confirmed() -> void:
	GameState.reset_hacks()
	_refresh()
	_show_message("All hacks are off.", MESSAGE_COLOR)


func _set_busy(value: bool) -> void:
	busy = value
	_code_edit.editable = not value
	_use_button.disabled = value
	_scan_button.disabled = value or not can_scan
	_qr_button.disabled = value
	_reset_button.disabled = value or GameState.active_hacks.is_empty()


func _refresh() -> void:
	for row: Node in _active_list.get_children():
		_active_list.remove_child(row)
		row.queue_free()
	var current: int = GameState.now()
	for hack_id: String in GameState.active_hacks:
		var until: int = GameState.hack_until.get(hack_id, Hacks.FOREVER)
		_add_row("%s · %s" % [Hacks.display_name(hack_id), Hacks.time_left_text(until, current)])
	if GameState.active_hacks.is_empty():
		_add_row("No hacks active")
	_reset_button.disabled = busy or GameState.active_hacks.is_empty()


func _add_row(text: String) -> void:
	var row: Label = Label.new()
	row.text = text
	row.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_active_list.add_child(row)


func _show_message(text: String, color: Color) -> void:
	_message.text = text
	_message.add_theme_color_override("font_color", color)


func _center_message_pivot() -> void:
	_message.pivot_offset = _message.size / 2.0


# --- Celebration ------------------------------------------------------------------------------


# The message pops and a burst of stars flies out of it; both are over within two seconds.
func _celebrate(text: String) -> void:
	_show_message(text, SUCCESS_COLOR)
	if _pop != null:
		_pop.kill()
	_message.pivot_offset = _message.size / 2.0
	_pop = create_tween()
	(
		_pop
		. tween_property(_message, "scale", Vector2.ONE, 0.5)
		. from(Vector2.ONE * 0.4)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	if _stars != null:
		_stars.queue_free()
	_stars = _build_stars()
	add_child(_stars)
	_stars.global_position = _message.get_global_rect().get_center()
	_stars.restart()


func _build_stars() -> CPUParticles2D:
	var stars: CPUParticles2D = CPUParticles2D.new()
	stars.name = "Stars"
	stars.emitting = false
	stars.one_shot = true
	stars.explosiveness = 1.0
	stars.amount = STAR_COUNT
	stars.lifetime = CELEBRATION_SECONDS
	stars.texture = _make_star_texture()
	stars.direction = Vector2.UP
	stars.spread = 180.0
	stars.initial_velocity_min = 250.0
	stars.initial_velocity_max = 650.0
	stars.gravity = Vector2(0.0, 700.0)
	stars.damping_min = 40.0
	stars.damping_max = 120.0
	stars.angular_velocity_min = -240.0
	stars.angular_velocity_max = 240.0
	stars.scale_amount_min = 0.6
	stars.scale_amount_max = 1.6
	var fade: Curve = Curve.new()
	fade.add_point(Vector2(0.0, 1.0))
	fade.add_point(Vector2(1.0, 0.0))
	stars.scale_amount_curve = fade
	var colors: Gradient = Gradient.new()
	colors.set_color(0, SUCCESS_COLOR)
	colors.set_color(1, Color(1.0, 1.0, 1.0))
	stars.color_initial_ramp = colors
	stars.z_index = 10
	return stars


# A five-pointed star drawn pixel by pixel, once; no asset.
static func _make_star_texture() -> ImageTexture:
	if _star_texture != null:
		return _star_texture
	var outline: PackedVector2Array = PackedVector2Array()
	var middle: float = STAR_TEXTURE_SIZE / 2.0
	for index: int in 10:
		var radius: float = middle if index % 2 == 0 else middle * 0.45
		var angle: float = -PI / 2.0 + index * PI / 5.0
		outline.append(Vector2(middle, middle) + Vector2(cos(angle), sin(angle)) * radius)
	var image: Image = Image.create(STAR_TEXTURE_SIZE, STAR_TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	for y: int in STAR_TEXTURE_SIZE:
		for x: int in STAR_TEXTURE_SIZE:
			if Geometry2D.is_point_in_polygon(Vector2(x + 0.5, y + 0.5), outline):
				image.set_pixel(x, y, Color.WHITE)
	_star_texture = ImageTexture.create_from_image(image)
	return _star_texture
