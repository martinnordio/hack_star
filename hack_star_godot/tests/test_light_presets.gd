extends GutTest
## The lighting presets and the saturation boost of Training and a match (spec 09, L3–L6, D27,
## D30): the order of `L`, `K` on and off on top of any preset, the default preset, every preset
## changes the sun, the sky and the colour balance in both worlds, Classic brings back the world's
## own light, glow only where the preset has it, and the choice is kept for the next match.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _show(scene: PackedScene, world: String = Worlds.CANYON) -> Arena:
	GameState.world = world
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	add_child_autofree(viewport)
	var arena: Arena = scene.instantiate()
	arena.read_player_input = false
	viewport.add_child(arena)
	await wait_process_frames(2)
	return arena


func _press(arena: Arena, key: Key) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = key
		event.pressed = pressed
		arena.get_viewport().push_input(event)


func _environment(arena: Arena) -> Environment:
	return (arena.get_node("WorldEnvironment") as WorldEnvironment).environment


func _sun(arena: Arena) -> DirectionalLight3D:
	return arena.get_node("Sun")


# What a preset sets: the sun, the ambient light, the sky and the colour balance.
func _look(arena: Arena) -> Dictionary:
	var environment: Environment = _environment(arena)
	var sky_colors: Array[Color] = [environment.background_color]
	if environment.background_mode == Environment.BG_SKY:
		var gradient: ProceduralSkyMaterial = environment.sky.sky_material
		sky_colors = [gradient.sky_top_color, gradient.ground_bottom_color]
	return {
		"sun": [_sun(arena).light_color, _sun(arena).light_energy, _sun(arena).rotation],
		"ambient": [environment.ambient_light_color, environment.ambient_light_energy],
		"sky": sky_colors,
		"balance":
		[
			environment.adjustment_enabled,
			environment.adjustment_brightness,
			environment.adjustment_contrast,
			environment.adjustment_saturation,
		],
	}


func test_l_goes_through_the_presets_in_order_and_names_them() -> void:
	assert_eq(
		LightPresets.ids(),
		[
			LightPresets.BRIGHT_DAY,
			LightPresets.GOLDEN_SUNSET,
			LightPresets.NEON_NIGHT,
			LightPresets.CANDY_POP,
			LightPresets.CLASSIC,
		]
	)
	var arena: Arena = await _show(ARENA_SCENE)
	assert_eq(arena.lighting().preset(), LightPresets.DEFAULT, "starts with the default")
	var seen: Array[String] = []
	var names: Array[String] = []
	for _press_count: int in LightPresets.ids().size():
		_press(arena, KEY_L)
		seen.append(arena.lighting().preset())
		names.append(arena.toast().text())
	var expected: Array[String] = []
	var expected_names: Array[String] = []
	var preset_id: String = LightPresets.DEFAULT
	for _step: int in LightPresets.ids().size():
		preset_id = LightPresets.next(preset_id)
		expected.append(preset_id)
		expected_names.append(LightPresets.preset_name(preset_id))
	assert_eq(seen, expected)
	assert_eq(names, expected_names, "the toast names each preset (L5)")
	assert_eq(seen.back(), LightPresets.DEFAULT, "back to the first after the last")
	assert_true(arena.toast().visible)


func test_k_switches_the_boost_on_and_off_on_top_of_any_preset() -> void:
	var arena: Arena = await _show(MATCH_SCENE)
	for preset_id: String in LightPresets.ids():
		arena.set_light_preset(preset_id)
		var plain: float = LightPresets.get_preset(preset_id)["saturation"]
		assert_almost_eq(_environment(arena).adjustment_saturation, plain, 0.001, preset_id)
		_press(arena, KEY_K)
		assert_true(GameState.saturation_boost)
		assert_eq(arena.toast().text(), "Saturation boost on")
		assert_true(_environment(arena).adjustment_enabled, preset_id)
		assert_almost_eq(
			_environment(arena).adjustment_saturation,
			plain * LightPresets.BOOST_SATURATION,
			0.001,
			"%s with the boost" % preset_id
		)
		_press(arena, KEY_K)
		assert_false(GameState.saturation_boost)
		assert_eq(arena.toast().text(), "Saturation boost off")
		assert_almost_eq(_environment(arena).adjustment_saturation, plain, 0.001, preset_id)


func test_the_boost_stays_on_when_the_preset_changes() -> void:
	var arena: Arena = await _show(ARENA_SCENE)
	arena.set_saturation_boost(true)
	_press(arena, KEY_L)
	var preset_id: String = arena.lighting().preset()
	assert_true(arena.lighting().boost())
	assert_almost_eq(
		_environment(arena).adjustment_saturation, LightPresets.saturation(preset_id, true), 0.001
	)


func test_every_preset_changes_the_sun_the_sky_and_the_colour_balance_in_both_worlds() -> void:
	for world: String in Worlds.ids():
		var arena: Arena = await _show(ARENA_SCENE, world)
		arena.set_light_preset(LightPresets.CLASSIC)
		var classic: Dictionary = _look(arena)
		for preset_id: String in LightPresets.ids():
			if preset_id == LightPresets.CLASSIC:
				continue
			arena.set_light_preset(preset_id)
			var look: Dictionary = _look(arena)
			for part: String in ["sun", "ambient", "sky", "balance"]:
				assert_ne(
					look[part], classic[part], "%s changes the %s in %s" % [preset_id, part, world]
				)
		arena.queue_free()
		await wait_process_frames(1)


func test_classic_brings_back_the_worlds_own_light() -> void:
	for world: String in Worlds.ids():
		GameState.light_preset = LightPresets.CLASSIC
		var arena: Arena = await _show(ARENA_SCENE, world)
		var own: Dictionary = _look(arena)
		# Only a world with its own colour balance (Glimmer Isles in the pack's light) keeps one.
		assert_eq(
			_environment(arena).adjustment_enabled,
			world == Worlds.GLIMMER_ISLES,
			"a colour balance pass in Classic only from the world's own light"
		)
		arena.set_light_preset(LightPresets.NEON_NIGHT)
		arena.set_light_preset(LightPresets.CLASSIC)
		assert_eq(_look(arena), own, world)
		arena.queue_free()
		await wait_process_frames(1)


func test_only_neon_night_glows_and_classic_with_the_worlds_own_glow() -> void:
	var arena: Arena = await _show(ARENA_SCENE, Worlds.GLIMMER_ISLES)
	for preset_id: String in LightPresets.ids():
		arena.set_light_preset(preset_id)
		# Glimmer Isles' own light (the pack's environment) glows, so its Classic does too.
		var glows: bool = preset_id in [LightPresets.NEON_NIGHT, LightPresets.CLASSIC]
		assert_eq(_environment(arena).glow_enabled, glows, preset_id)


func test_the_light_keys_are_bound_to_nothing_else() -> void:
	var light_keys: Array[int] = [KEY_L, KEY_K]
	for action: StringName in InputMap.get_actions():
		if action in [&"light_next", &"saturation_boost"] or String(action).begins_with("ui_"):
			continue
		for event: InputEvent in InputMap.action_get_events(action):
			if event is InputEventKey:
				var key: int = (event as InputEventKey).physical_keycode
				assert_false(light_keys.has(key), "%s does not use a light key" % action)


func test_the_preset_and_the_boost_are_kept_for_the_next_match_and_training() -> void:
	var arena: Arena = await _show(MATCH_SCENE)
	arena.set_light_preset(LightPresets.CANDY_POP)
	arena.set_saturation_boost(true)
	arena.queue_free()
	await wait_process_frames(1)
	for scene: PackedScene in [MATCH_SCENE, ARENA_SCENE]:
		var next: Arena = await _show(scene, Worlds.GLIMMER_ISLES)
		assert_eq(next.lighting().preset(), LightPresets.CANDY_POP)
		assert_true(next.lighting().boost())
		assert_almost_eq(
			_environment(next).adjustment_saturation,
			LightPresets.saturation(LightPresets.CANDY_POP, true),
			0.001
		)
		next.queue_free()
		await wait_process_frames(1)
	GameState.reset()
	assert_eq(GameState.light_preset, LightPresets.DEFAULT, "the default after a fresh start")
	assert_false(GameState.saturation_boost)


func test_the_arena_does_not_change_the_scenes_shared_environment() -> void:
	var arena: Arena = await _show(ARENA_SCENE)
	arena.set_light_preset(LightPresets.NEON_NIGHT)
	var fresh: Node = ARENA_SCENE.instantiate()
	var shared: Environment = (fresh.get_node("WorldEnvironment") as WorldEnvironment).environment
	assert_false(shared.glow_enabled)
	assert_eq(shared.background_mode, Environment.BG_COLOR)
	fresh.free()
