extends GutTest
## The help texts of "How to play" and the start hint (spec 16, D13).


func _all_text() -> String:
	var text: String = ""
	for section: Dictionary in ControlsHelp.how_to_play():
		text += "%s %s\n" % [section["title"], section["text"]]
	return text


func test_every_section_has_a_title_and_a_text() -> void:
	var sections: Array[Dictionary] = ControlsHelp.how_to_play()
	assert_eq(sections.size(), 5)
	var titles: Array[String] = []
	for section: Dictionary in sections:
		assert_false(String(section["title"]).is_empty())
		assert_false(String(section["text"]).is_empty(), section["title"])
		assert_false(titles.has(section["title"]), "titles are different")
		titles.append(section["title"])
	assert_eq(titles[0], "Controls", "the controls come first")


func test_the_controls_name_the_keys_and_the_sticks() -> void:
	var controls: String = ControlsHelp.how_to_play()[0]["text"]
	for word: String in ["WASD", "arrow keys", "Space", "left stick", "right stick"]:
		assert_true(controls.contains(word), word)
	for hint: String in [ControlsHelp.KEYBOARD_HINT, ControlsHelp.TOUCH_HINT]:
		assert_false(hint.is_empty())
	assert_true(ControlsHelp.KEYBOARD_HINT.contains("WASD"))
	assert_true(ControlsHelp.KEYBOARD_HINT.contains("Space"))
	assert_true(ControlsHelp.KEYBOARD_HINT.contains("View: V or 1-4"), "the view keys (V7)")
	assert_true(controls.contains("V switches the camera view"), "the view keys (V7)")
	for view_id: String in CameraViews.ids():
		assert_true(controls.contains(CameraViews.view_name(view_id)), view_id)
	assert_true(ControlsHelp.KEYBOARD_HINT.contains("light: L and K"), "the light keys (L3, L4)")
	assert_true(controls.contains("L switches the lighting"), "the light keys (L3)")
	assert_true(controls.contains("K a saturation boost"), "the boost key (L4)")
	for preset_id: String in LightPresets.ids():
		assert_true(controls.contains(LightPresets.preset_name(preset_id)), preset_id)
	assert_true(ControlsHelp.TOUCH_HINT.contains("stick"))


func test_the_numbers_match_the_rules() -> void:
	var text: String = _all_text()
	for number: int in [
		int(Combat.SHOT_RANGE),
		MatchSettings.BOT_COUNT,
		int(MatchSettings.MATCH_SECONDS),
		int(MatchSettings.HEAL_DELAY),
		ArenaLayout.DUMMIES.size(),
		int(Combat.RESPAWN_SECONDS),
		MatchSettings.TROPHIES_PER_WIN,
		Prestige.TROPHIES_PER_LEVEL,
	]:
		assert_true(text.contains(str(number)), "mentions %d" % number)
	assert_true(text.contains("+%d trophies" % MatchSettings.TROPHIES_PER_WIN))
	assert_true(text.contains("every %d trophies" % Prestige.TROPHIES_PER_LEVEL))
