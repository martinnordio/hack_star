class_name SaveData
extends RefCounted
## The save file: `{"version": 1, "hacks": [...]}`. Only the active hacks are saved for now;
## a later spec adds its fields and bumps the version. A missing, broken or newer file gives no
## hacks, and ids the game does not know are dropped.

const VERSION: int = 1


static func to_json(hacks: Array[String]) -> String:
	return JSON.stringify({"version": VERSION, "hacks": hacks})


static func from_json(text: String) -> Array[String]:
	var result: Array[String] = []
	var json: JSON = JSON.new()
	if json.parse(text) != OK:
		return result
	var data: Variant = json.data
	if not data is Dictionary:
		return result
	var version: Variant = data.get("version")
	if not (version is int or version is float) or int(version) > VERSION or int(version) < 1:
		return result
	var saved: Variant = data.get("hacks")
	if not saved is Array:
		return result
	for hack_id: Variant in saved:
		if hack_id is String and Hacks.is_known(hack_id) and not hack_id in result:
			result.append(hack_id)
	return result
