extends Node
## The one place that talks to the hack server (`server/`, spec 05 D1-D3): `redeem` checks a
## code, `list_hacks` lists the hacks the game knows. Both can be awaited and answer with a
## dictionary whose `status` is `ok`, `unknown` (the server does not know the code, or the game
## does not know the hack) or `no_server` (no connection, timeout, any other answer).

const STATUS_OK: String = "ok"
const STATUS_UNKNOWN: String = "unknown"
const STATUS_NO_SERVER: String = "no_server"

const LOCAL_BASE_URL: String = "http://127.0.0.1:8180/api"
const TIMEOUT_SECONDS: float = 8.0

## A test sets it to answer instead of the network: `func(method: String, url: String,
## body: String) -> Dictionary` with `status` (an int; 0 for no connection) and `body`.
var fake_responder: Callable = Callable()


## The server's address: `/api` on the address the page came from in the web export, else the
## local server.
func base_url() -> String:
	if OS.has_feature("web"):
		var origin: Variant = JavaScriptBridge.eval("location.origin")
		if origin is String and not (origin as String).is_empty():
			return "%s/api" % origin
	return LOCAL_BASE_URL


## Checks a code. `ok` has `id`, `name` and `code` of the hack.
func redeem(code: String) -> Dictionary:
	var body: String = JSON.stringify({"code": Hacks.normalize_code(code)})
	var answer: Dictionary = await _request(HTTPClient.METHOD_POST, "/hacks/redeem", body)
	var status: int = answer["status"]
	if status == 404:
		return {"status": STATUS_UNKNOWN}
	if status != 200:
		return {"status": STATUS_NO_SERVER}
	var parsed: Variant = _parse(answer["body"])
	if not parsed is Dictionary:
		return {"status": STATUS_NO_SERVER}
	var hack: Dictionary = _known_hack(parsed)
	if hack.is_empty():
		return {"status": STATUS_UNKNOWN}
	hack["status"] = STATUS_OK
	return hack


## The hacks of the server that the game knows, in the server's order, as `hacks` (each with
## `id`, `name` and `code`).
func list_hacks() -> Dictionary:
	var answer: Dictionary = await _request(HTTPClient.METHOD_GET, "/hacks", "")
	if answer["status"] != 200:
		return {"status": STATUS_NO_SERVER}
	var parsed: Variant = _parse(answer["body"])
	if not parsed is Array:
		return {"status": STATUS_NO_SERVER}
	var hacks: Array[Dictionary] = []
	for entry: Variant in parsed:
		var hack: Dictionary = _known_hack(entry)
		if not hack.is_empty():
			hacks.append(hack)
	return {"status": STATUS_OK, "hacks": hacks}


# The hack of a server answer when it is one of the three the game knows, else empty.
static func _known_hack(entry: Variant) -> Dictionary:
	if not entry is Dictionary:
		return {}
	var id: Variant = entry.get("id")
	var hack_name: Variant = entry.get("name")
	var code: Variant = entry.get("code")
	if not (id is String and hack_name is String and code is String):
		return {}
	if not Hacks.is_known(id):
		return {}
	return {"id": id, "name": hack_name, "code": code}


static func _parse(text: String) -> Variant:
	var json: JSON = JSON.new()
	if json.parse(text) != OK:
		return null
	return json.data


# The answer as `{"status": int, "body": String}`; status 0 when nothing came back.
func _request(method: HTTPClient.Method, path: String, body: String) -> Dictionary:
	var url: String = base_url() + path
	if fake_responder.is_valid():
		var method_name: String = "POST" if method == HTTPClient.METHOD_POST else "GET"
		var fake: Dictionary = await fake_responder.call(method_name, url, body)
		return fake
	var http: HTTPRequest = HTTPRequest.new()
	http.timeout = TIMEOUT_SECONDS
	add_child(http)
	var headers: PackedStringArray = ["Content-Type: application/json"]
	if http.request(url, headers, method, body) != OK:
		http.queue_free()
		return {"status": 0, "body": ""}
	var response: Array = await http.request_completed
	http.queue_free()
	if response[0] != HTTPRequest.RESULT_SUCCESS:
		return {"status": 0, "body": ""}
	return {"status": response[1], "body": (response[3] as PackedByteArray).get_string_from_utf8()}
