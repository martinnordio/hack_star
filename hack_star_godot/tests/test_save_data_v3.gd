extends GutTest
## The save file version 3: each hack with its end time, and a revision (spec 16, S16, S25, D2).

const NOW: int = 1_764_000_000
const LATER: int = NOW + 3600
const PROGRESS: Dictionary = {"credits": 500, "selected_fighter": "luna", "unlocked": ["luna"]}


func test_the_file_has_version_3_with_each_hack_its_until_and_the_revision() -> void:
	var hacks: Dictionary[String, int] = {"infinite_credits": LATER, "power22": 0}
	var data: Dictionary = JSON.parse_string(SaveData.to_json(hacks, PROGRESS, 7))
	assert_eq(data["version"], 3.0)
	assert_eq(data["revision"], 7.0)
	assert_eq_deep(
		data["hacks"],
		[{"id": "infinite_credits", "until": float(LATER)}, {"id": "power22", "until": 0.0}]
	)


func test_round_trip_keeps_the_hacks_their_until_the_progress_and_the_revision() -> void:
	var hacks: Dictionary[String, int] = {"unlock_all": LATER, "power22": 0}
	var loaded: Dictionary = SaveData.from_json(SaveData.to_json(hacks, PROGRESS, 12), NOW)
	assert_eq_deep(loaded["hacks"], hacks)
	assert_eq_deep(loaded["progress"], PROGRESS)
	assert_eq(loaded["revision"], 12)


func test_versions_1_and_2_give_each_hack_3_days_from_now_or_for_ever() -> void:
	var expected: Dictionary[String, int] = {
		"unlock_all": NOW + Hacks.TIMED_SECONDS,
		"power22": 0,
		"infinite_credits": NOW + Hacks.TIMED_SECONDS
	}
	for version: int in [1, 2]:
		var text: String = JSON.stringify(
			{"version": version, "hacks": ["unlock_all", "power22", "infinite_credits"]}
		)
		var loaded: Dictionary = SaveData.from_json(text, NOW)
		assert_eq_deep(loaded["hacks"], expected)
		assert_eq(loaded["revision"], 0)


func test_a_version_2_file_of_spec_08_keeps_its_progress() -> void:
	var text: String = JSON.stringify({"version": 2, "hacks": ["power22"], "progress": PROGRESS})
	assert_eq_deep(SaveData.from_json(text, NOW)["progress"], PROGRESS)


func test_a_for_ever_hack_gets_0_whatever_was_saved() -> void:
	var text: String = _file([{"id": "power22", "until": LATER}])
	assert_eq_deep(SaveData.from_json(text, NOW)["hacks"], {"power22": 0})


func test_an_until_too_far_ahead_is_cut_to_now_plus_3_days() -> void:
	var far: int = NOW + 10 * Hacks.DAY_SECONDS
	var text: String = _file([{"id": "unlock_all", "until": far}])
	var expected: Dictionary = {"unlock_all": NOW + Hacks.TIMED_SECONDS}
	assert_eq_deep(SaveData.from_json(text, NOW)["hacks"], expected)


func test_an_expired_hack_is_kept_for_the_game_to_turn_off() -> void:
	var text: String = _file([{"id": "infinite_credits", "until": NOW - 5}])
	assert_eq_deep(SaveData.from_json(text, NOW)["hacks"], {"infinite_credits": NOW - 5})


func test_unknown_ids_doubles_and_wrong_types_are_dropped() -> void:
	var entries: Array = [
		{"id": "unlock_all", "until": LATER},
		{"id": "unlock_all", "until": LATER + 9},
		{"id": "nope", "until": LATER},
		{"id": 3, "until": LATER},
		{"id": "infinite_credits", "until": 0},
		{"id": "infinite_credits", "until": 1.5},
		{"id": "infinite_credits", "until": "soon"},
		{"until": LATER},
		"power22",
		7,
	]
	assert_eq_deep(SaveData.from_json(_file(entries), NOW)["hacks"], {"unlock_all": LATER})
	assert_eq_deep(SaveData.from_json('{"version": 3, "hacks": "power22"}', NOW)["hacks"], {})


func test_a_wrong_revision_is_0() -> void:
	for revision: Variant in [-1, 1.5, "4", null]:
		var text: String = JSON.stringify({"version": 3, "revision": revision, "hacks": []})
		assert_eq(SaveData.from_json(text, NOW)["revision"], 0, str(revision))


func test_a_newer_or_broken_file_gives_nothing() -> void:
	for text: String in ['{"version": 4, "revision": 3, "hacks": []}', "{not json", "[]"]:
		var loaded: Dictionary = SaveData.from_json(text, NOW)
		assert_eq_deep(loaded["hacks"], {})
		assert_eq_deep(loaded["progress"], {})
		assert_eq(loaded["revision"], 0)


func _file(hacks: Array) -> String:
	return JSON.stringify({"version": 3, "revision": 1, "hacks": hacks})
