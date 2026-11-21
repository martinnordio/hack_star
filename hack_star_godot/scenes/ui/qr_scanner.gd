class_name QrScanner
extends Node
## Scans a QR code with the camera in the web export, through `web/qr_scanner.js` (spec 05, D8):
## the browser shows the camera over the game and reports the text or why it could not scan.
## Outside the web export it fails at once with `not_web`.

signal scanned(text: String)
signal failed(reason: String)

const NOT_WEB: String = "not_web"
const NO_CAMERA: String = "no_camera"
const DENIED: String = "denied"
const NEEDS_HTTPS: String = "needs_https"
const CANCELLED: String = "cancelled"

## True while the camera is open.
var scanning: bool = false

# Kept so the browser can call back into the game while the camera is open.
var _callback: JavaScriptObject


func start() -> void:
	if scanning:
		return
	if not OS.has_feature("web"):
		failed.emit(NOT_WEB)
		return
	var scanner: JavaScriptObject = JavaScriptBridge.get_interface("hackStarQr")
	if scanner == null:
		failed.emit(NO_CAMERA)
		return
	scanning = true
	_callback = JavaScriptBridge.create_callback(_on_browser_report)
	scanner.start(_callback)


func _exit_tree() -> void:
	if scanning:
		scanning = false
		var scanner: JavaScriptObject = JavaScriptBridge.get_interface("hackStarQr")
		if scanner != null:
			scanner.cancel()


func _on_browser_report(arguments: Array) -> void:
	scanning = false
	var kind: String = str(arguments[0]) if arguments.size() > 0 else "failed"
	var value: String = str(arguments[1]) if arguments.size() > 1 else NO_CAMERA
	# Deferred: the browser calls in between two frames of the game.
	if kind == "scanned":
		scanned.emit.call_deferred(value)
	else:
		failed.emit.call_deferred(value)
