class_name QrPage
extends Control
## The QR page: a large QR code for each hack code, to scan from the screen or to save as an
## image (spec 05, S10 and D10). The codes come from the server (`HackServer.list_hacks`).

const MESSAGE_COLOR: Color = Color(0.94, 0.95, 1.0)
const ERROR_COLOR: Color = Color(1.0, 0.55, 0.5)
const QR_DISPLAY_SIZE: float = 320.0
const LOCAL_GAME_ADDRESS: String = "http://localhost:8060/"

## Where **Save image** writes a file outside the web export.
var save_folder: String = "user://"

@onready var _message: Label = $Margin/Column/Scroll/Content/Message
@onready var _rows: HFlowContainer = $Margin/Column/Scroll/Content/Rows


func _ready() -> void:
	_message.text = "Loading…"
	_message.add_theme_color_override("font_color", MESSAGE_COLOR)
	var result: Dictionary = await HackServer.list_hacks()
	if not is_inside_tree():
		return
	if result["status"] != HackServer.STATUS_OK:
		_message.text = "Can't reach the hack server. Try again later."
		_message.add_theme_color_override("font_color", ERROR_COLOR)
		return
	_message.text = (
		"Scan a code with the camera, or save its image. "
		+ "To use it on a phone, open this page at the Wi-Fi address, not localhost."
	)
	var hacks: Array[Dictionary] = []
	hacks.assign(result["hacks"])
	for hack: Dictionary in hacks:
		_rows.add_child(_build_row(hack))


## The address of the game, which a QR code opens (D9 of spec 05).
static func game_address() -> String:
	if OS.has_feature("web"):
		var address: Variant = JavaScriptBridge.eval("location.origin + location.pathname")
		if address is String and not (address as String).is_empty():
			return address
	return LOCAL_GAME_ADDRESS


## Saves the QR image of a hack code: a download in the web export, else a PNG in
## `save_folder`. Returns the path of the file, or an empty string for a download or a failure.
func save_image(code: String) -> String:
	var image: Image = QrImage.image_for(Hacks.link(game_address(), code))
	if image == null:
		return ""
	var png: PackedByteArray = image.save_png_to_buffer()
	var file_name: String = "hack-%s.png" % code.to_lower()
	if OS.has_feature("web"):
		JavaScriptBridge.download_buffer(png, file_name, "image/png")
		return ""
	var path: String = save_folder.path_join(file_name)
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return ""
	file.store_buffer(png)
	file.close()
	return path


func _build_row(hack: Dictionary) -> Control:
	var code: String = hack["code"]
	var row: PanelContainer = PanelContainer.new()
	row.name = code.validate_node_name()
	row.theme_type_variation = &"CardPanel"
	var column: VBoxContainer = VBoxContainer.new()
	column.name = "Column"
	column.add_theme_constant_override("separation", 12)
	row.add_child(column)
	var title: Label = Label.new()
	title.name = "Name"
	title.text = hack["name"]
	title.theme_type_variation = &"SubheadingLabel"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)
	var code_label: Label = Label.new()
	code_label.name = "Code"
	code_label.text = code
	code_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(code_label)
	var picture: TextureRect = TextureRect.new()
	picture.name = "Picture"
	picture.texture = QrImage.texture_for(Hacks.link(game_address(), code))
	picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picture.custom_minimum_size = Vector2(QR_DISPLAY_SIZE, QR_DISPLAY_SIZE)
	column.add_child(picture)
	var save: Button = Button.new()
	save.name = "SaveButton"
	save.text = "Save image"
	save.custom_minimum_size = Vector2(0, 80)
	save.theme_type_variation = &"BlueButton"
	column.add_child(save)
	var saved: Label = Label.new()
	saved.name = "Saved"
	saved.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	saved.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	saved.visible = false
	column.add_child(saved)
	save.pressed.connect(_on_save_pressed.bind(code, saved))
	return row


func _on_save_pressed(code: String, saved: Label) -> void:
	var path: String = save_image(code)
	saved.visible = true
	if QrImage.image_for(Hacks.link(game_address(), code)) == null:
		saved.text = "Could not save the image."
	elif OS.has_feature("web"):
		saved.text = "Image downloaded."
	elif path.is_empty():
		saved.text = "Could not save the image."
	else:
		saved.text = "Saved to %s" % ProjectSettings.globalize_path(path)
