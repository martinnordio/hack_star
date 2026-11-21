extends GutTest


func test_round_trip() -> void:
	var hacks: Array[String] = ["power22", "unlock_all"]
	assert_eq(SaveData.from_json(SaveData.to_json(hacks)), hacks)


func test_an_empty_text_or_broken_file_gives_no_hacks() -> void:
	assert_eq(SaveData.from_json(""), [])
	assert_eq(SaveData.from_json("{not json"), [])
	assert_eq(SaveData.from_json("[1, 2]"), [])
	assert_eq(SaveData.from_json('{"version": 1}'), [])
	assert_eq(SaveData.from_json('{"version": 1, "hacks": "power22"}'), [])


func test_a_newer_file_gives_no_hacks() -> void:
	assert_eq(SaveData.from_json('{"version": 2, "hacks": ["power22"]}'), [])


func test_unknown_ids_and_duplicates_are_dropped() -> void:
	var text: String = '{"version": 1, "hacks": ["power22", "nope", 3, "power22", "creator"]}'
	assert_eq(SaveData.from_json(text), ["power22"])
