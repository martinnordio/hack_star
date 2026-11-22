extends GutTest

const QR_PAGE: PackedScene = preload("res://scenes/qr_page.tscn")
const SAVE_FOLDER: String = "user://test"
const ROWS_PATH: String = "Margin/Column/Scroll/Content/Rows"
const MESSAGE_PATH: String = "Margin/Column/Scroll/Content/Message"
const LIST_BODY: String = (
	'[{"id": "infinite_credits", "code": "INFINITY", "name": "Unlimited credits"},'
	+ '{"id": "hypercharge", "code": "HYPERCHARGE", "name": "Hypercharge"},'
	+ '{"id": "unlock_all", "code": "OPENSESAME", "name": "Unlock everything"},'
	+ '{"id": "power22", "code": "POWER22", "name": "Power 22"}]'
)


func after_each() -> void:
	HackServer.fake_responder = Callable()
	DirAccess.remove_absolute(SAVE_FOLDER.path_join("hack-infinity.png"))


func _answer(status: int, body: String) -> void:
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {"status": status, "body": body}


func _show_page() -> Control:
	var page: Control = autofree(QR_PAGE.instantiate())
	page.save_folder = SAVE_FOLDER
	add_child(page)
	await wait_process_frames(2)
	return page


func test_each_known_hack_has_a_row_with_name_code_and_a_big_picture() -> void:
	_answer(200, LIST_BODY)
	var page: Control = await _show_page()
	var rows: Node = page.get_node(ROWS_PATH)
	assert_eq(rows.get_child_count(), 3, "hypercharge from the server is not shown")
	assert_null(rows.get_node_or_null("HYPERCHARGE"))
	var expected: Dictionary = {
		"INFINITY": "Unlimited credits", "OPENSESAME": "Unlock everything", "POWER22": "Power 22"
	}
	for code: String in expected:
		var row: Node = rows.get_node(code)
		assert_eq(row.get_node("Column/Name").text, expected[code])
		assert_eq(row.get_node("Column/Code").text, code)
		var picture: TextureRect = row.get_node("Column/Picture")
		var link: String = Hacks.link(QrPage.game_address(), code)
		var side: int = (QrCode.size_for_version(QrCode.version_for(link)) + 8) * 8
		assert_eq(picture.texture.get_size(), Vector2(side, side))
		assert_gte(picture.custom_minimum_size.x, 300.0, "large enough to scan")


func test_without_the_server_the_page_says_so() -> void:
	_answer(0, "")
	var page: Control = await _show_page()
	assert_eq(page.get_node(MESSAGE_PATH).text, "Can't reach the hack server. Try again later.")
	assert_eq(page.get_node(ROWS_PATH).get_child_count(), 0)


func test_a_link_too_long_for_a_qr_code_is_not_saved() -> void:
	_answer(200, LIST_BODY)
	var page: Control = await _show_page()
	assert_eq(page.save_image("X".repeat(300)), "")
	page._on_save_pressed("X".repeat(300), page.get_node(MESSAGE_PATH))
	assert_eq(page.get_node(MESSAGE_PATH).text, "Could not save the image.")


func test_save_image_writes_a_png_that_is_the_qr_code_of_the_link() -> void:
	_answer(200, LIST_BODY)
	var page: Control = await _show_page()
	var save: Button = page.get_node(ROWS_PATH + "/INFINITY/Column/SaveButton")
	save.pressed.emit()
	var path: String = SAVE_FOLDER.path_join("hack-infinity.png")
	assert_true(FileAccess.file_exists(path), "the PNG is written")
	var saved: Image = Image.load_from_file(path)
	var expected: Image = QrImage.image_for(Hacks.link(QrPage.game_address(), "INFINITY"))
	assert_eq(saved.get_size(), expected.get_size())
	assert_eq(saved.get_data(), expected.get_data())
	var note: Label = page.get_node(ROWS_PATH + "/INFINITY/Column/Saved")
	assert_true(note.visible)
	assert_string_contains(note.text, "hack-infinity.png")
