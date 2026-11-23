extends GutTest
## The colour variations on `C` (spec 09, H1–H3, H5, H6, D48, D55): `C`'s order and wrap, the
## default Glimmer, the toast, Original equal to the look before in both worlds and the same
## after a switch as built, the canyon's 1 and 2 equal, `L` and `K` on top and kept across `C`,
## the view kept, kept for the next match, reset, and `C` bound to no other action.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
## The canyon before this reopening (spec 09 Step 38's notes), role by role.
const CANYON_BEFORE: Dictionary[String, Color] = {
	"sand": Color("d6ad7e"),
	"sand_dark": Color("cb9f6e"),
	"outside": Color("cf7b4c"),
	"rock": Color("e65a2a"),
	"rock_band": Color("ff9a4f"),
	"rock_top": Color("a83a20"),
	"boulder": Color("bf4f2a"),
	"boulder_light": Color("ee7c3e"),
	"bush_ground": Color("9fc05a"),
	"cactus": Color("3fd35c"),
	"cactus_dark": Color("1fa848"),
	"flower": Color("ff4f9e"),
	"blossom_0": Color("ffd23f"),
	"blossom_1": Color("ff8a3d"),
	"blossom_2": Color("ff6fd0"),
	"crate": Color("d98c35"),
	"crate_edge": Color("7a4620"),
	"bone": Color("fff6e0"),
	"eye": Color("2a1d1d"),
	"pebble": Color("b98a5e"),
	"flag_0": Color("ff3b5c"),
	"flag_1": Color("ffd23f"),
	"flag_2": Color("23c9b8"),
	"pole": Color("7a4620"),
	"bird": Color("3b2b3f"),
	"stream": Color("27d3c3"),
	"stream_light": Color("c8fff6"),
}


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


func _close(arena: Arena) -> void:
	arena.get_parent().queue_free()
	await wait_process_frames(1)


func _press(arena: Arena, key: Key) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = key
		event.pressed = pressed
		arena.get_viewport().push_input(event)


func _environment(arena: Arena) -> Environment:
	return (arena.get_node("WorldEnvironment") as WorldEnvironment).environment


# Everything the variation decides in the arena: each mesh's material and colours (per instance
# for MultiMeshes, the shader colours of water and flags), the environment and the sun.
func _look(arena: Arena) -> Array:
	var result: Array = []
	var nodes: Array[Node] = []
	for root: Node in [arena.get_node("Floor"), arena.get_node("Walls"), arena.world()]:
		nodes.append_array(root.find_children("*", "GeometryInstance3D", true, false))
	for node: Node in nodes:
		var entry: Array = [String(arena.get_path_to(node))]
		var material: Material = (node as GeometryInstance3D).material_override
		# The crystals' glow pulses with the time (`GlimmerDecor`), so only their colours count.
		var pulsing: bool = node.get_meta("kind", "") == "crystal_cluster"
		if material is ShaderMaterial:
			for parameter: String in ["albedo", "emission", "emission_energy", "water", "color"]:
				if not (pulsing and parameter == "emission_energy"):
					entry.append((material as ShaderMaterial).get_shader_parameter(parameter))
		if node is MultiMeshInstance3D:
			var multimesh: MultiMesh = (node as MultiMeshInstance3D).multimesh
			if multimesh.use_colors:
				for index: int in multimesh.instance_count:
					entry.append(multimesh.get_instance_color(index))
		if node is CPUParticles3D and (node as CPUParticles3D).color_ramp != null:
			entry.append((node as CPUParticles3D).color_ramp.colors)
		result.append(entry)
	result.sort_custom(func(first: Array, second: Array) -> bool: return first[0] < second[0])
	var environment: Environment = _environment(arena)
	var sky: Array = []
	if environment.sky != null and environment.sky.sky_material is ProceduralSkyMaterial:
		var gradient: ProceduralSkyMaterial = environment.sky.sky_material
		sky = [gradient.sky_top_color, gradient.sky_horizon_color, gradient.ground_bottom_color]
	var sun: DirectionalLight3D = arena.get_node("Sun")
	(
		result
		. append(
			[
				environment.background_mode,
				environment.background_color,
				sky,
				environment.ambient_light_color,
				environment.ambient_light_energy,
				environment.fog_enabled,
				environment.glow_enabled,
				environment.tonemap_mode,
				environment.adjustment_saturation,
				sun.light_color,
				sun.light_energy,
				sun.rotation,
				sun.shadow_opacity,
			]
		)
	)
	return result


func test_c_goes_through_the_four_variations_in_order_and_names_them() -> void:
	assert_eq(
		ColourVariations.ids(),
		[
			ColourVariations.ORIGINAL,
			ColourVariations.GLIMMER,
			ColourVariations.LAGOON,
			ColourVariations.GLOW_NIGHT,
		]
	)
	assert_eq(ColourVariations.DEFAULT, ColourVariations.GLIMMER, "a game starts in Glimmer")
	var arena: Arena = await _show(ARENA_SCENE)
	assert_eq(GameState.colour_variation, ColourVariations.GLIMMER)
	var seen: Array[String] = []
	var names: Array[String] = []
	for _press_count: int in 4:
		_press(arena, KEY_C)
		seen.append(GameState.colour_variation)
		names.append(arena.toast().text())
	assert_eq(
		seen,
		[
			ColourVariations.LAGOON,
			ColourVariations.GLOW_NIGHT,
			ColourVariations.ORIGINAL,
			ColourVariations.GLIMMER,
		],
		"back to the first after the last"
	)
	assert_eq(
		names,
		["Colours 3: Lagoon", "Colours 4: Glow night", "Colours 1: Original", "Colours 2: Glimmer"]
	)
	assert_true(arena.toast().visible, "the name shows (H5)")


func test_c_works_during_the_countdown_of_a_match() -> void:
	var arena: Arena = await _show(MATCH_SCENE, Worlds.GLIMMER_ISLES)
	assert_true(arena.get_node("Hud/MatchHud/CountdownLabel").visible, "during the countdown")
	_press(arena, KEY_C)
	assert_eq(GameState.colour_variation, ColourVariations.LAGOON)
	assert_eq(arena.toast().text(), "Colours 3: Lagoon")


func test_original_is_the_look_before_in_both_worlds() -> void:
	for role: String in CANYON_BEFORE:
		assert_eq(CanyonLooks.color(role, ColourVariations.ORIGINAL), CANYON_BEFORE[role], role)
		assert_eq(CanyonLooks.look(role, ColourVariations.ORIGINAL)["glow_strength"], 0.0, role)
	assert_eq(CanyonLooks.roles(ColourVariations.ORIGINAL).size(), CANYON_BEFORE.size())
	# Glimmer Isles' Original is pinned in `test_glimmer_palette.gd`; here: the canyon in the arena
	# with the scene's own light, as before.
	GameState.colour_variation = ColourVariations.ORIGINAL
	GameState.light_preset = LightPresets.CLASSIC
	var arena: Arena = await _show(ARENA_SCENE)
	var fresh: Node = ARENA_SCENE.instantiate()
	var scene_light: Environment = (
		(fresh.get_node("WorldEnvironment") as WorldEnvironment).environment
	)
	assert_eq(_environment(arena).background_color, scene_light.background_color)
	assert_eq(_environment(arena).ambient_light_color, scene_light.ambient_light_color)
	assert_eq(
		(arena.get_node("Sun") as DirectionalLight3D).light_color,
		(fresh.get_node("Sun") as DirectionalLight3D).light_color
	)
	fresh.free()


func test_the_canyon_looks_the_same_in_original_and_glimmer() -> void:
	for role: String in CanyonLooks.roles(ColourVariations.ORIGINAL):
		assert_eq(
			CanyonLooks.look(role, ColourVariations.GLIMMER),
			CanyonLooks.look(role, ColourVariations.ORIGINAL),
			role
		)
	GameState.colour_variation = ColourVariations.ORIGINAL
	var original: Arena = await _show(ARENA_SCENE)
	var original_look: Array = _look(original)
	await _close(original)
	GameState.colour_variation = ColourVariations.GLIMMER
	var glimmer: Arena = await _show(ARENA_SCENE)
	assert_eq(_look(glimmer), original_look, "H3: the canyon's 1 and 2 are the same")


func test_a_switch_gives_the_same_look_as_a_world_built_in_that_variation() -> void:
	for world: String in Worlds.ids():
		for variation: String in [ColourVariations.ORIGINAL, ColourVariations.GLIMMER]:
			for preset_id: String in [LightPresets.CLASSIC, LightPresets.NEON_NIGHT]:
				GameState.light_preset = preset_id
				GameState.colour_variation = variation
				var built: Arena = await _show(ARENA_SCENE, world)
				var expected: Array = _look(built)
				await _close(built)
				GameState.colour_variation = ColourVariations.next(variation)
				var switched: Arena = await _show(ARENA_SCENE, world)
				# Through every other variation and back.
				for _press_count: int in ColourVariations.ids().size() - 1:
					_press(switched, KEY_C)
				assert_eq(GameState.colour_variation, variation)
				assert_eq(_look(switched), expected, "%s, %s, %s" % [world, variation, preset_id])
				await _close(switched)


func test_glimmer_isles_changes_between_original_and_glimmer() -> void:
	GameState.colour_variation = ColourVariations.ORIGINAL
	var arena: Arena = await _show(ARENA_SCENE, Worlds.GLIMMER_ISLES)
	var isles: GlimmerIsles = arena.world()
	assert_null(isles.get_node_or_null("Lagoon"), "no lagoon in Original")
	assert_false(_environment(arena).fog_enabled)
	arena.set_colour_variation(ColourVariations.GLIMMER)
	await wait_process_frames(1)
	assert_not_null(isles.get_node_or_null("Lagoon"), "the lagoon in Glimmer")
	var ground: MeshInstance3D = arena.get_node("Floor/Mesh")
	assert_eq(
		(ground.material_override as ShaderMaterial).get_shader_parameter("albedo"),
		GlimmerLooks.color("ground", ColourVariations.GLIMMER)
	)
	arena.set_colour_variation(ColourVariations.ORIGINAL)
	await wait_process_frames(1)
	assert_null(isles.get_node_or_null("Lagoon"), "the lagoon gone again")
	assert_eq(
		(ground.material_override as ShaderMaterial).get_shader_parameter("albedo"),
		GlimmerLooks.color("ground", ColourVariations.ORIGINAL)
	)


func test_a_switch_moves_nothing_and_keeps_the_colliders() -> void:
	var arena: Arena = await _show(MATCH_SCENE, Worlds.GLIMMER_ISLES)
	var bodies: Array[Node] = arena.find_children("*", "CollisionShape3D", true, false)
	var places: Array = []
	for shape: Node in bodies:
		places.append((shape as Node3D).global_transform)
	arena.set_colour_variation(ColourVariations.ORIGINAL)
	var after: Array[Node] = arena.find_children("*", "CollisionShape3D", true, false)
	assert_eq(after, bodies, "the same colliders")
	for index: int in after.size():
		assert_eq((after[index] as Node3D).global_transform, places[index])


func test_l_and_k_work_on_top_and_are_kept_across_c() -> void:
	var arena: Arena = await _show(MATCH_SCENE, Worlds.GLIMMER_ISLES)
	arena.set_light_preset(LightPresets.NEON_NIGHT)
	arena.set_saturation_boost(true)
	for variation: String in ColourVariations.ids():
		arena.set_colour_variation(variation)
		assert_eq(arena.lighting().preset(), LightPresets.NEON_NIGHT, variation)
		assert_true(arena.lighting().boost(), variation)
		assert_true(_environment(arena).glow_enabled, "Neon night's glow in %s" % variation)
		assert_almost_eq(
			_environment(arena).adjustment_saturation,
			LightPresets.saturation(LightPresets.NEON_NIGHT, true),
			0.001,
			variation
		)
		_press(arena, KEY_L)
		assert_eq(arena.lighting().preset(), LightPresets.CANDY_POP, "L in %s" % variation)
		_press(arena, KEY_K)
		assert_false(arena.lighting().boost(), "K in %s" % variation)
		arena.set_light_preset(LightPresets.NEON_NIGHT)
		arena.set_saturation_boost(true)


func test_c_keeps_the_view() -> void:
	var arena: Arena = await _show(ARENA_SCENE)
	arena.set_view(CameraViews.OVERVIEW)
	_press(arena, KEY_C)
	assert_eq(arena.view(), CameraViews.OVERVIEW)
	assert_eq(GameState.camera_view, CameraViews.OVERVIEW)


func test_the_variation_is_kept_for_the_next_match_and_training_and_reset() -> void:
	var arena: Arena = await _show(MATCH_SCENE, Worlds.GLIMMER_ISLES)
	arena.set_colour_variation(ColourVariations.ORIGINAL)
	await _close(arena)
	for scene: PackedScene in [MATCH_SCENE, ARENA_SCENE]:
		var next: Arena = await _show(scene, Worlds.GLIMMER_ISLES)
		assert_eq((next.world() as GlimmerIsles).variation, ColourVariations.ORIGINAL)
		assert_null(next.world().get_node_or_null("Lagoon"))
		await _close(next)
	GameState.reset()
	assert_eq(GameState.colour_variation, ColourVariations.GLIMMER, "the default after a reset")


func test_c_is_bound_to_nothing_else() -> void:
	var events: Array[InputEvent] = InputMap.action_get_events(&"colour_next")
	assert_eq(events.size(), 1)
	assert_eq((events[0] as InputEventKey).physical_keycode, KEY_C)
	for action: StringName in InputMap.get_actions():
		if action == &"colour_next" or String(action).begins_with("ui_"):
			continue
		for event: InputEvent in InputMap.action_get_events(action):
			if event is InputEventKey:
				assert_ne((event as InputEventKey).physical_keycode, KEY_C, String(action))


func test_lagoon_and_glow_night_differ_from_the_others_in_both_worlds() -> void:
	for world: String in Worlds.ids():
		var looks: Dictionary = {}
		for variation: String in ColourVariations.ids():
			GameState.colour_variation = variation
			var arena: Arena = await _show(ARENA_SCENE, world)
			looks[variation] = _look(arena)
			await _close(arena)
		for variation: String in [ColourVariations.LAGOON, ColourVariations.GLOW_NIGHT]:
			for other: String in ColourVariations.ids():
				if other != variation:
					assert_ne(
						looks[variation], looks[other], "%s: %s, %s" % [world, variation, other]
					)
	# The main surfaces too, not only a detail.
	for variation: String in [ColourVariations.LAGOON, ColourVariations.GLOW_NIGHT]:
		for role: String in ["ground", "border", "crystal_cluster/Spike", "glow_fern/Frond"]:
			assert_ne(
				GlimmerLooks.color(role, variation),
				GlimmerLooks.color(role, ColourVariations.ORIGINAL),
				"%s %s" % [variation, role]
			)
		for role: String in ["sand", "rock", "cactus", "outside"]:
			assert_ne(
				CanyonLooks.color(role, variation),
				CanyonLooks.color(role, ColourVariations.ORIGINAL),
				"%s %s" % [variation, role]
			)


func test_every_colour_of_the_new_variations_is_from_the_pack() -> void:
	var allowed: Array[Color] = []
	allowed.assign(GlimmerPalette.ALL.values())
	for file: String in DirAccess.get_files_at(GlimmerLooks.MATERIALS_DIR):
		if file.ends_with(".tres"):
			var material: BaseMaterial3D = load(GlimmerLooks.MATERIALS_DIR + file)
			allowed.append(material.albedo_color)
			if material.emission_enabled:
				allowed.append(material.emission)
	var in_pack: Callable = func(color: Color) -> bool:
		for pack_color: Color in allowed:
			if Color(color, 1.0).is_equal_approx(Color(pack_color, 1.0)):
				return true
		return false
	for variation: String in [ColourVariations.LAGOON, ColourVariations.GLOW_NIGHT]:
		for role: String in GlimmerLooks.roles(variation):
			var look: Dictionary = GlimmerLooks.look(role, variation)
			assert_true(in_pack.call(look["albedo"]), "Glimmer Isles %s %s" % [variation, role])
			if look["glow_strength"] > 0.0:
				assert_true(
					in_pack.call(look["glow"]), "Glimmer Isles %s %s glow" % [variation, role]
				)
		for role: String in CanyonLooks.roles(variation):
			var look: Dictionary = CanyonLooks.look(role, variation)
			assert_true(in_pack.call(look["albedo"]), "canyon %s %s" % [variation, role])
			if look["glow_strength"] > 0.0:
				assert_true(in_pack.call(look["glow"]), "canyon %s %s glow" % [variation, role])
		for light: Dictionary in [GlimmerLooks.light(variation), CanyonLooks.light(variation)]:
			assert_false(light.is_empty(), "%s has its own light" % variation)
			var colors: Array = light["sky"] + [light["ambient"], light["sun"]]
			for color: Color in colors:
				assert_true(in_pack.call(color), "%s light %s" % [variation, color])
	assert_eq(
		CanyonLooks.roles(ColourVariations.LAGOON), CanyonLooks.roles(ColourVariations.ORIGINAL)
	)
	assert_eq(
		GlimmerLooks.roles(ColourVariations.GLOW_NIGHT),
		GlimmerLooks.roles(ColourVariations.GLIMMER)
	)


func test_lagoon_and_glow_night_have_their_own_sky_and_glow_night_glows() -> void:
	GameState.light_preset = LightPresets.CLASSIC
	for world: String in Worlds.ids():
		for variation: String in [ColourVariations.LAGOON, ColourVariations.GLOW_NIGHT]:
			GameState.colour_variation = variation
			var arena: Arena = await _show(ARENA_SCENE, world)
			var environment: Environment = _environment(arena)
			var gradient: ProceduralSkyMaterial = environment.sky.sky_material
			assert_eq(gradient.sky_top_color, GlimmerLooks.light(variation)["sky"][0], world)
			assert_false(environment.fog_enabled, "no fog in %s" % variation)
			assert_eq(
				environment.glow_enabled,
				variation == ColourVariations.GLOW_NIGHT,
				"%s %s" % [world, variation]
			)
			assert_eq(
				(arena.get_node("Sun") as DirectionalLight3D).light_color,
				GlimmerLooks.light(variation)["sun"]
			)
			await _close(arena)
