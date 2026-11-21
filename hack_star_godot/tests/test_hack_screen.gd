extends GutTest

const HACK_SCREEN: PackedScene = preload("res://scenes/hack_screen.tscn")
const TEST_SAVE: String = "user://test/hack_screen_save.json"
const EDIT_PATH: String = "Margin/Column/Scroll/Content/CodeRow/CodeEdit"
const USE_PATH: String = "Margin/Column/Scroll/Content/CodeRow/UseButton"
const MESSAGE_PATH: String = "Margin/Column/Scroll/Content/Message"
const LIST_PATH: String = "Margin/Column/Scroll/Content/ActiveList"
const RESET_PATH: String = "Margin/Column/Scroll/Content/ResetButton"
const OPEN_BODY: String = '{"id": "unlock_all", "code": "OPENSESAME", "name": "Unlock everything"}'

var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()


func after_each() -> void:
	HackServer.fake_responder = Callable()
	GameState.start_code = ""


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


func _show_screen() -> Control:
	var screen: Control = autofree(HACK_SCREEN.instantiate())
	add_child(screen)
	return screen


func _answer(status: int, body: String) -> void:
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {"status": status, "body": body}


func _listed(screen: Control) -> Array[String]:
	var texts: Array[String] = []
	for row: Label in screen.get_node(LIST_PATH).get_children():
		texts.append(row.text)
	return texts


func test_a_correct_code_unlocks_lists_and_saves_the_hack() -> void:
	_answer(200, OPEN_BODY)
	var screen: Control = _show_screen()
	screen.get_node(EDIT_PATH).text = " opensesame "
	await screen.submit(screen.get_node(EDIT_PATH).text)
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Unlock everything unlocked!")
	assert_true(GameState.has_hack(Hacks.UNLOCK_ALL))
	assert_eq(_listed(screen), ["Unlock everything"])
	assert_eq(screen.get_node(EDIT_PATH).text, "", "the code is cleared")
	assert_eq(GameState._load_hacks(), [Hacks.UNLOCK_ALL], "saved")
	assert_not_null(screen.get_node_or_null("Stars"), "the celebration plays")


func test_an_unknown_code_changes_nothing() -> void:
	_answer(404, '{"detail": "Unknown code"}')
	var screen: Control = _show_screen()
	await screen.submit("NOPE")
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Unknown code")
	assert_eq(GameState.active_hacks, [])
	assert_eq(_listed(screen), ["No hacks active"])
	assert_null(screen.get_node_or_null("Stars"))
	assert_false(FileAccess.file_exists(TEST_SAVE))


func test_without_the_server_nothing_changes_and_it_can_be_tried_again() -> void:
	_answer(0, "")
	var screen: Control = _show_screen()
	await screen.submit("power22")
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Can't reach the hack server. Try again later.")
	assert_eq(GameState.active_hacks, [])
	assert_false(screen.get_node(USE_PATH).disabled, "the code can be tried again")
	_answer(200, '{"id": "power22", "code": "POWER22", "name": "Power 22"}')
	await screen.submit("power22")
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Power 22 unlocked!")
	assert_true(GameState.has_hack(Hacks.POWER22))


func test_a_code_accepted_after_back_was_pressed_is_still_activated() -> void:
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		await get_tree().create_timer(0.2).timeout
		return {"status": 200, "body": OPEN_BODY}
	var screen: Control = HACK_SCREEN.instantiate()
	add_child(screen)
	screen.submit("opensesame")
	await wait_process_frames(2)
	screen.free()
	await wait_seconds(0.4)
	assert_true(GameState.has_hack(Hacks.UNLOCK_ALL))
	assert_eq(GameState._load_hacks(), [Hacks.UNLOCK_ALL], "saved")


func test_enter_and_the_button_submit_the_code() -> void:
	_answer(200, '{"id": "power22", "code": "POWER22", "name": "Power 22"}')
	var screen: Control = _show_screen()
	var edit: LineEdit = screen.get_node(EDIT_PATH)
	edit.text = "power22"
	edit.text_submitted.emit(edit.text)
	await wait_process_frames(2)
	assert_true(GameState.has_hack(Hacks.POWER22), "Enter submits")
	GameState.reset_hacks()
	edit.text = "power22"
	screen.get_node(USE_PATH).pressed.emit()
	await wait_process_frames(2)
	assert_true(GameState.has_hack(Hacks.POWER22), "the button submits")


func test_the_buttons_are_disabled_while_a_code_is_checked() -> void:
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		await get_tree().create_timer(0.2).timeout
		return {"status": 404, "body": ""}
	var screen: Control = _show_screen()
	screen.submit("nope")
	await wait_process_frames(2)
	assert_true(screen.busy)
	assert_true(screen.get_node(USE_PATH).disabled)
	assert_false((screen.get_node(EDIT_PATH) as LineEdit).editable)
	await wait_seconds(0.4)
	assert_false(screen.busy)
	assert_false(screen.get_node(USE_PATH).disabled)
	assert_true((screen.get_node(EDIT_PATH) as LineEdit).editable)


func test_active_hacks_are_listed_when_the_screen_opens() -> void:
	GameState.activate_hack(Hacks.INFINITE_CREDITS)
	GameState.activate_hack(Hacks.POWER22)
	var screen: Control = _show_screen()
	assert_eq(_listed(screen), ["Unlimited credits", "Power 22"])
	assert_false(screen.get_node(RESET_PATH).disabled)


func test_with_no_hacks_reset_is_disabled() -> void:
	var screen: Control = _show_screen()
	assert_true(screen.get_node(RESET_PATH).disabled)
	assert_eq(_listed(screen), ["No hacks active"])


func test_reset_asks_first_cancel_keeps_the_hacks_and_turn_off_clears_them() -> void:
	GameState.activate_hack(Hacks.UNLOCK_ALL)
	var screen: Control = _show_screen()
	var dialog: ConfirmationDialog = screen.get_node("ConfirmDialog")
	screen.get_node(RESET_PATH).pressed.emit()
	assert_true(dialog.visible, "it asks first")
	assert_eq(dialog.ok_button_text, "Turn off")
	assert_eq(dialog.cancel_button_text, "Cancel")
	assert_true(GameState.has_hack(Hacks.UNLOCK_ALL), "nothing changed yet")
	dialog.get_cancel_button().pressed.emit()
	await wait_process_frames(2)
	assert_false(dialog.visible)
	assert_true(GameState.has_hack(Hacks.UNLOCK_ALL), "Cancel keeps the hacks")
	screen.get_node(RESET_PATH).pressed.emit()
	dialog.get_ok_button().pressed.emit()
	assert_eq(GameState.active_hacks, [])
	assert_eq(_listed(screen), ["No hacks active"])
	assert_true(screen.get_node(RESET_PATH).disabled)
	assert_eq(GameState._load_hacks(), [], "saved")


func test_back_goes_home_by_click_and_by_touch() -> void:
	for use_touch: bool in [false, true]:
		var opened: Dictionary = await UiInput.open(self, HACK_SCREEN)
		var back: Control = opened["screen"].get_node("Margin/Column/Header/BackButton")
		if use_touch:
			UiInput.touch(opened["viewport"], back)
		else:
			UiInput.click(opened["viewport"], back)
		var shown: Node = await UiInput.settle(self, opened)
		assert_eq(shown.scene_file_path, Screens.HOME, "Back opens home (touch: %s)" % use_touch)
		await UiInput.close(self, shown)


func test_scan_qr_code_is_shown_and_qr_codes_opens_the_qr_page() -> void:
	_answer(0, "")
	var opened: Dictionary = await UiInput.open(self, HACK_SCREEN)
	var content: Node = opened["screen"].get_node("Margin/Column/Scroll/Content")
	assert_true(content.get_node("ScanButton").visible)
	var scroll: ScrollContainer = opened["screen"].get_node("Margin/Column/Scroll")
	scroll.ensure_control_visible(content.get_node("QrButton"))
	await wait_process_frames(2)
	UiInput.click(opened["viewport"], content.get_node("QrButton"))
	var shown: Node = await UiInput.settle(self, opened)
	assert_eq(shown.scene_file_path, Screens.QR, "QR codes opens the QR page")
	await UiInput.close(self, shown)


func test_without_a_camera_the_screen_says_why() -> void:
	var screen: Control = _show_screen()
	screen.get_node("Margin/Column/Scroll/Content/ScanButton").pressed.emit()
	assert_eq(
		screen.get_node(MESSAGE_PATH).text,
		"Camera not available — type the code",
		"outside the browser"
	)
	var expected: Dictionary[String, String] = {
		QrScanner.NO_CAMERA: "Camera not available — type the code",
		QrScanner.DENIED: "Camera permission refused — type the code",
		QrScanner.NEEDS_HTTPS: "The camera needs https:// — type the code",
		QrScanner.CANCELLED: "",
	}
	for reason: String in expected:
		screen.scanner.failed.emit(reason)
		assert_eq(screen.get_node(MESSAGE_PATH).text, expected[reason], reason)
	assert_eq(GameState.active_hacks, [])
	assert_true((screen.get_node(EDIT_PATH) as LineEdit).editable, "typing still works")


func test_a_scanned_link_redeems_its_code() -> void:
	var sent: Array[String] = []
	HackServer.fake_responder = func(_method: String, _url: String, body: String) -> Dictionary:
		sent.append(body)
		return {"status": 200, "body": '{"id": "power22", "code": "POWER22", "name": "Power 22"}'}
	var screen: Control = _show_screen()
	screen.scanner.scanned.emit("https://192.168.1.5:8060/?hack=power22")
	await wait_process_frames(2)
	assert_eq(sent.size(), 1)
	assert_eq(JSON.parse_string(sent[0])["code"], "POWER22")
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Power 22 unlocked!")
	assert_true(GameState.has_hack(Hacks.POWER22))


func test_a_scanned_text_without_a_code_is_unknown() -> void:
	var screen: Control = _show_screen()
	screen.scanner.scanned.emit("https://example.com/?page=2")
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Unknown code")
	assert_eq(GameState.active_hacks, [])


func test_the_code_of_a_qr_link_is_redeemed_when_the_screen_opens() -> void:
	_answer(200, OPEN_BODY)
	GameState.start_code = "OPENSESAME"
	var screen: Control = _show_screen()
	await wait_process_frames(2)
	assert_eq(screen.get_node(MESSAGE_PATH).text, "Unlock everything unlocked!")
	assert_true(GameState.has_hack(Hacks.UNLOCK_ALL))
	assert_eq(GameState.start_code, "", "redeemed once")
