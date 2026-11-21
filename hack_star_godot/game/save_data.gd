class_name SaveData
extends RefCounted
## The save file: `{"version": 2, "hacks": [...], "progress": {...}}`. The progress holds
## `trophies` and `power_levels` per fighter, `unlocked`, `credits`, `selected_fighter` and
## `selected_skins` per fighter. A version 1 file (spec 05) gives its hacks and an empty
## progress. A missing, broken or newer file gives no hacks and an empty progress. Every field
## is checked: unknown fighters, hacks and skins, wrong types and numbers out of range are
## left out, so the game fills them from the sample progress.

const VERSION: int = 2


static func to_json(hacks: Array[String], progress: Dictionary) -> String:
	return JSON.stringify({"version": VERSION, "hacks": hacks, "progress": progress})


## `{"hacks": Array[String], "progress": Dictionary}`; the progress has only the fields that
## passed the checks.
static func from_json(text: String) -> Dictionary:
	var hacks: Array[String] = []
	var result: Dictionary = {"hacks": hacks, "progress": {}}
	var json: JSON = JSON.new()
	if json.parse(text) != OK:
		return result
	var data: Variant = json.data
	if not data is Dictionary:
		return result
	var version: int = _whole_number(data.get("version"), 1)
	if version < 1 or version > VERSION:
		return result
	result["hacks"] = _read_hacks(data.get("hacks"))
	if version >= 2:
		result["progress"] = _read_progress(data.get("progress"))
	return result


static func _read_hacks(saved: Variant) -> Array[String]:
	var result: Array[String] = []
	if not saved is Array:
		return result
	for hack_id: Variant in saved:
		if hack_id is String and Hacks.is_known(hack_id) and not hack_id in result:
			result.append(hack_id)
	return result


static func _read_progress(saved: Variant) -> Dictionary:
	var result: Dictionary = {}
	if not saved is Dictionary:
		return result
	if saved.get("trophies") is Dictionary:
		result["trophies"] = _read_numbers(saved["trophies"], 0)
	if saved.get("power_levels") is Dictionary:
		result["power_levels"] = _read_numbers(saved["power_levels"], 1)
	if saved.get("unlocked") is Array:
		result["unlocked"] = _read_unlocked(saved["unlocked"])
	var credits: int = _whole_number(saved.get("credits"), 0)
	if credits >= 0:
		result["credits"] = credits
	var selected: Variant = saved.get("selected_fighter")
	if selected is String and Fighters.ids().has(selected):
		result["selected_fighter"] = selected
	if saved.get("selected_skins") is Dictionary:
		result["selected_skins"] = _read_skins(saved["selected_skins"])
	return result


# The whole numbers of known fighters that are at least `minimum`.
static func _read_numbers(saved: Dictionary, minimum: int) -> Dictionary[String, int]:
	var result: Dictionary[String, int] = {}
	for fighter_id: String in Fighters.ids():
		var value: int = _whole_number(saved.get(fighter_id), minimum)
		if value >= minimum:
			result[fighter_id] = value
	return result


static func _read_unlocked(saved: Array) -> Array[String]:
	var result: Array[String] = []
	for fighter_id: Variant in saved:
		if fighter_id is String and Fighters.ids().has(fighter_id) and not fighter_id in result:
			result.append(fighter_id)
	return result


static func _read_skins(saved: Dictionary) -> Dictionary[String, String]:
	var result: Dictionary[String, String] = {}
	for fighter_id: String in Fighters.ids():
		var skin_id: Variant = saved.get(fighter_id)
		if skin_id is String and Fighters.has_skin(fighter_id, skin_id):
			result[fighter_id] = skin_id
	return result


# A JSON number without a fraction as an int; anything else gives `minimum - 1` (not valid).
static func _whole_number(value: Variant, minimum: int) -> int:
	if value is int:
		return value
	if value is float and is_finite(value) and value == floorf(value) and absf(value) < 1e15:
		return int(value)
	return minimum - 1
