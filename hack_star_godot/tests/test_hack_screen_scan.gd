extends GutTest
## The hack screen's Scan QR code button works only where scanning does (spec 16, D10).

const HACK_SCREEN: PackedScene = preload("res://scenes/hack_screen.tscn")
const TEST_SAVE: String = "user://test/hack_screen_scan_save.json"
const SCAN_PATH: String = "Margin/Column/Scroll/Content/ScanButton"
const HINT_PATH: String = "Margin/Column/Scroll/Content/ScanHint"

var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.save_path = TEST_SAVE
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.reset()
	HackServer.fake_responder = func(_method: String, _url: String, _sent: String) -> Dictionary:
		return {"status": 404, "body": '{"detail": "Unknown code"}'}


func after_each() -> void:
	HackServer.fake_responder = Callable()


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path
	GameState.reset()


func _open(can_scan: bool) -> Control:
	var screen: Control = autofree(HACK_SCREEN.instantiate())
	screen.can_scan = can_scan
	add_child(screen)
	return screen


func test_without_a_scanner_the_scan_button_is_off_and_the_hint_shows() -> void:
	var screen: Control = autofree(HACK_SCREEN.instantiate())
	add_child(screen)
	var button: Button = screen.get_node(SCAN_PATH)
	var hint: Label = screen.get_node(HINT_PATH)
	assert_false(screen.can_scan, "the headless run cannot scan")
	assert_true(button.disabled, "disabled after opening")
	assert_true(hint.visible)
	assert_eq(hint.text, "Camera scanning works in the browser version — type the code here")
	await screen.submit("nope")
	assert_true(button.disabled, "still disabled after a code was checked")
	assert_true(hint.visible)


func test_with_a_scanner_the_scan_button_works_and_the_hint_is_hidden() -> void:
	var screen: Control = _open(true)
	var button: Button = screen.get_node(SCAN_PATH)
	assert_false(button.disabled)
	assert_false(screen.get_node(HINT_PATH).visible)
	await screen.submit("nope")
	assert_false(button.disabled, "enabled again after a code was checked")
