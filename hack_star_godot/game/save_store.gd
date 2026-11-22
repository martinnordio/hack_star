class_name SaveStore
extends RefCounted
## Where the save file's text lives (spec 16, D6). On the desktop and in the tests: the file at
## `path`. In the web game: the page's `localStorage` (key `WEB_KEY`), which every tab of the
## same address reads and writes at once; `user://` on the web is a copy made at each tab's
## start, so a tab would never see another tab's later saves. A web start with no key copies the
## old `path` file to the key once and leaves the file as it is.

const WEB_KEY: String = "hack_star_save"

var path: String
var web: bool


func _init(file_path: String, in_browser: bool = false) -> void:
	path = file_path
	web = in_browser


## The store of this platform: the web store in the web export, else the file store.
static func for_this_platform(file_path: String) -> SaveStore:
	return SaveStore.new(file_path, OS.has_feature("web"))


## The saved text, or "" when nothing is saved.
func read() -> String:
	if not web:
		return _read_file()
	var stored: Variant = _get_item(WEB_KEY)
	if stored is String:
		return stored
	var old: String = _read_file()
	if not old.is_empty():
		_set_item(WEB_KEY, old)
	return old


## Writes the text; false when it could not be written.
func write(text: String) -> bool:
	if web:
		return _set_item(WEB_KEY, text)
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save %s (error %d)" % [path, FileAccess.get_open_error()])
		return false
	file.store_string(text)
	return true


func _read_file() -> String:
	if not FileAccess.file_exists(path):
		return ""
	return FileAccess.get_file_as_string(path)


# The `localStorage` item, or null when it is missing (a test overrides this).
func _get_item(key: String) -> Variant:
	var storage: JavaScriptObject = JavaScriptBridge.get_interface("localStorage")
	if storage == null:
		return null
	return storage.getItem(key)


# Writes the `localStorage` item (a test overrides this).
func _set_item(key: String, text: String) -> bool:
	var storage: JavaScriptObject = JavaScriptBridge.get_interface("localStorage")
	if storage == null:
		push_warning("Could not save: no localStorage")
		return false
	storage.setItem(key, text)
	return true
