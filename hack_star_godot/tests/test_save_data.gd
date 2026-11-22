extends GutTest
## The save file of spec 05 (version 1) and the checks every version shares.

const NOW: int = 1_764_000_000


func test_round_trip() -> void:
	var hacks: Dictionary[String, int] = {"power22": 0, "unlock_all": NOW + 60}
	assert_eq_deep(SaveData.from_json(SaveData.to_json(hacks, {}, 1), NOW)["hacks"], hacks)


func test_an_empty_text_or_broken_file_gives_no_hacks() -> void:
	for text: String in [
		"", "{not json", "[1, 2]", '{"version": 1}', '{"version": 1, "hacks": "power22"}'
	]:
		assert_eq_deep(SaveData.from_json(text, NOW)["hacks"], {})


func test_a_newer_file_gives_no_hacks() -> void:
	var text: String = '{"version": 4, "hacks": [{"id": "power22", "until": 0}]}'
	assert_eq_deep(SaveData.from_json(text, NOW)["hacks"], {})


func test_unknown_ids_and_duplicates_are_dropped() -> void:
	var text: String = '{"version": 1, "hacks": ["power22", "nope", 3, "power22", "creator"]}'
	assert_eq(SaveData.from_json(text, NOW)["hacks"].keys(), ["power22"])
