extends GutTest

const POWER22_BODY: String = (
	'{"id": "power22", "code": "POWER22", "name": "Power 22",'
	+ ' "description": "x", "duration_seconds": null}'
)


func after_each() -> void:
	HackServer.fake_responder = Callable()


# A responder that answers every request with the same status and body and remembers the last
# request.
func _answer(status: int, body: String) -> Array:
	var seen: Array = []
	HackServer.fake_responder = func(method: String, url: String, sent: String) -> Dictionary:
		seen.assign([method, url, sent])
		return {"status": status, "body": body}
	return seen


func test_the_base_url_outside_the_web_is_the_local_server() -> void:
	assert_eq(HackServer.base_url(), "http://127.0.0.1:8180/api")


func test_a_known_code_is_ok_with_the_name() -> void:
	var seen: Array = _answer(200, POWER22_BODY)
	var result: Dictionary = await HackServer.redeem(" power22 ")
	assert_eq(result["status"], HackServer.STATUS_OK)
	assert_eq(result["id"], "power22")
	assert_eq(result["name"], "Power 22")
	assert_eq(result["code"], "POWER22")
	assert_eq(seen[0], "POST")
	assert_eq(seen[1], "http://127.0.0.1:8180/api/hacks/redeem")
	assert_eq(JSON.parse_string(seen[2]), {"code": "POWER22"}, "the normalized code is sent")


func test_a_hack_the_game_does_not_know_is_unknown() -> void:
	_answer(200, '{"id": "hypercharge", "code": "HYPERCHARGE", "name": "Hypercharge"}')
	var result: Dictionary = await HackServer.redeem("hypercharge")
	assert_eq(result["status"], HackServer.STATUS_UNKNOWN)


func test_404_is_unknown() -> void:
	_answer(404, '{"detail": "Unknown code"}')
	var result: Dictionary = await HackServer.redeem("nope")
	assert_eq(result["status"], HackServer.STATUS_UNKNOWN)


func test_500_broken_json_and_no_connection_are_no_server() -> void:
	_answer(500, "oops")
	var result: Dictionary = await HackServer.redeem("power22")
	assert_eq(result["status"], HackServer.STATUS_NO_SERVER)
	_answer(200, "{not json")
	result = await HackServer.redeem("power22")
	assert_eq(result["status"], HackServer.STATUS_NO_SERVER, "a broken 200 is no answer")
	_answer(0, "")
	result = await HackServer.redeem("power22")
	assert_eq(result["status"], HackServer.STATUS_NO_SERVER)
	_answer(502, "")
	result = await HackServer.redeem("power22")
	assert_eq(result["status"], HackServer.STATUS_NO_SERVER)


func test_the_list_keeps_only_the_known_hacks() -> void:
	var body: String = (
		'[{"id": "infinite_credits", "code": "INFINITY", "name": "Unlimited credits"},'
		+ '{"id": "hypercharge", "code": "HYPERCHARGE", "name": "Hypercharge"},'
		+ '{"id": "power22", "code": "POWER22", "name": "Power 22"}]'
	)
	var seen: Array = _answer(200, body)
	var result: Dictionary = await HackServer.list_hacks()
	assert_eq(result["status"], HackServer.STATUS_OK)
	var ids: Array[String] = []
	for hack: Dictionary in result["hacks"]:
		ids.append(hack["id"])
	assert_eq(ids, ["infinite_credits", "power22"])
	assert_eq(seen[0], "GET")
	assert_eq(seen[1], "http://127.0.0.1:8180/api/hacks")


func test_the_list_without_the_server_is_no_server() -> void:
	_answer(0, "")
	var result: Dictionary = await HackServer.list_hacks()
	assert_eq(result["status"], HackServer.STATUS_NO_SERVER)
	_answer(200, "{}")
	result = await HackServer.list_hacks()
	assert_eq(result["status"], HackServer.STATUS_NO_SERVER)
