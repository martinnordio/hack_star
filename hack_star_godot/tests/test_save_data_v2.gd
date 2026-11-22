extends GutTest

const NOW: int = 1_764_000_000
const PROGRESS: Dictionary = {
	"trophies": {"blaze": 1250, "rocko": 420, "turbo": 85, "frosty": 0, "luna": 0, "pixel": 7},
	"power_levels": {"blaze": 7, "rocko": 4, "turbo": 2, "frosty": 1, "luna": 1, "pixel": 3},
	"unlocked": ["blaze", "rocko", "turbo", "luna"],
	"credits": 500,
	"selected_fighter": "luna",
	"selected_skins": {"blaze": "lava", "luna": "galaxy"},
}


func test_round_trip_keeps_hacks_and_progress() -> void:
	var hacks: Dictionary[String, int] = {"power22": 0}
	var loaded: Dictionary = SaveData.from_json(SaveData.to_json(hacks, PROGRESS, 1), NOW)
	assert_eq_deep(loaded["hacks"], hacks)
	assert_eq_deep(loaded["progress"], PROGRESS)


func test_a_version_2_file_keeps_its_hacks_and_its_progress() -> void:
	var text: String = JSON.stringify({"version": 2, "hacks": ["power22"], "progress": PROGRESS})
	var loaded: Dictionary = SaveData.from_json(text, NOW)
	assert_eq(loaded["hacks"].keys(), ["power22"])
	assert_eq_deep(loaded["progress"], PROGRESS)


func test_a_version_1_file_keeps_its_hacks_with_an_empty_progress() -> void:
	var text: String = '{"version": 1, "hacks": ["power22"], "progress": {"credits": 9}}'
	var loaded: Dictionary = SaveData.from_json(text, NOW)
	assert_eq(loaded["hacks"].keys(), ["power22"])
	assert_eq_deep(loaded["progress"], {})


func test_a_newer_broken_or_non_object_file_gives_nothing() -> void:
	var newer: String = '{"version": 4, "hacks": [], "progress": {"credits": 9}}'
	for text: String in [newer, "", "{not json", "[1, 2]", '"text"', '{"version": "2"}']:
		var loaded: Dictionary = SaveData.from_json(text, NOW)
		assert_eq_deep(loaded["hacks"], {})
		assert_eq_deep(loaded["progress"], {})


func test_a_missing_or_wrong_progress_is_empty() -> void:
	assert_eq_deep(SaveData.from_json('{"version": 2, "hacks": []}', NOW)["progress"], {})
	assert_eq_deep(SaveData.from_json('{"version": 2, "progress": [1]}', NOW)["progress"], {})


func test_unknown_fighters_and_bad_numbers_are_left_out() -> void:
	var text: String = (
		JSON
		. stringify(
			{
				"version": 2,
				"progress":
				{
					"trophies": {"blaze": 10, "rocko": -5, "turbo": 1.5, "luna": "9", "nope": 3},
					"power_levels": {"blaze": 0, "rocko": 4, "nope": 2},
					"credits": -1,
				},
			}
		)
	)
	var progress: Dictionary = SaveData.from_json(text, NOW)["progress"]
	assert_eq_deep(progress["trophies"], {"blaze": 10})
	assert_eq_deep(progress["power_levels"], {"rocko": 4})
	assert_false(progress.has("credits"))


func test_unknown_unlocks_selection_and_skins_are_left_out() -> void:
	var text: String = (
		JSON
		. stringify(
			{
				"version": 2,
				"progress":
				{
					"unlocked": ["luna", "nope", 4, "luna"],
					"selected_fighter": "nope",
					"selected_skins": {"blaze": "galaxy", "luna": "galaxy", "nope": "default"},
					"credits": "lots",
				},
			}
		)
	)
	var progress: Dictionary = SaveData.from_json(text, NOW)["progress"]
	assert_eq(progress["unlocked"], ["luna"])
	assert_false(progress.has("selected_fighter"))
	assert_eq_deep(progress["selected_skins"], {"luna": "galaxy"})
	assert_false(progress.has("credits"))
