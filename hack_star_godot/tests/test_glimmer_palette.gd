extends GutTest
## Glimmer Isles in the author's palette pack (spec 09, P1–P6, D44–D46, D55): the pack's paths,
## every surface of the world in a palette or pack-material colour, Original pinned to the look
## before, the same places and colliders in both variations, the lagoon and the waterfalls in the
## pack's water colours, and the pack's unused files out of the web export.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const PACK_DIR: String = "res://scenes/glimmer_isles/"
const LIGHTING_SCENE: String = "res://scenes/glimmer_isles/glimmer_isles_lighting.tscn"
## The path the pack's README and lighting scene used before (written in two parts, so this file
## does not name it).
const OLD_PATH: String = "res:/" + "/glimmer_isles/"
const WATER_SHADER: Shader = preload("res://scenes/toon/flowing_water.gdshader")
## The look of Glimmer Isles before the palette (spec 09 Step 38's notes), role by role.
const BEFORE: Dictionary[String, Array] = {
	"ground": [Color("74bccb")],
	"ground_alt": [Color("a294dc")],
	"path": [Color("c8fbff"), Color("5fe8ff"), 0.6],
	"rim": [Color("4aa892")],
	"underside": [Color("6446c4")],
	"border": [Color("7b56dc")],
	"border_top": [Color("5434b0")],
	"plinth": [Color("5434b0")],
	"fern_ground": [Color("2c9c78")],
	"crystal_cluster/Rock": [Color("5434b0")],
	"crystal_cluster/Spike": [Color("4feaff"), Color("1fc2ff"), 0.5],
	"crystal_cluster/SpikeLeft": [Color("ff5cd6"), Color("ff2fbe"), 0.5],
	"crystal_cluster/SpikeRight": [Color("4feaff"), Color("1fc2ff"), 0.5],
	"glow_fern/Frond": [Color("1fcf80")],
	"glow_fern/FrondLeft": [Color("4ff2a4")],
	"glow_fern/FrondRight": [Color("1fcf80")],
	"glow_fern/FrondBack": [Color("4ff2a4")],
	"glow_fern/TipLeft": [Color("d4ff4f"), Color("d4ff4f"), 0.8],
	"glow_fern/TipBack": [Color("d4ff4f"), Color("d4ff4f"), 0.8],
	"small_mushroom/Stem": [Color("fbecc6")],
	"small_mushroom/Cap": [Color("c444ff"), Color("9b2dff"), 0.35],
	"giant_mushroom/Stem": [Color("fbecc6")],
	"giant_mushroom/Gills": [Color("ffc8e8")],
	"giant_mushroom/Cap": [Color("ff55a8"), Color("ff2f8f"), 0.3],
	"island_chunk/Grass": [Color("55e0a6")],
	"island_chunk/Rock": [Color("7b56dc")],
	"island_chunk/RootLeft": [Color("3d2a8c")],
	"island_chunk/RootRight": [Color("3d2a8c")],
	"firefly": [Color("e6ff6a")],
	"waterfall": [Color(0.45, 0.9, 1.0, 0.85)],
	"waterfall_light": [Color("f0ffff")],
	"sky_top": [Color("1b1446")],
	"sky_horizon": [Color("c77ad6")],
	"void_deep": [Color("140f38")],
	"void_horizon": [Color("6a4fb8")],
	"ambient": [Color("b8a8ff")],
	"sun": [Color("fff0ff")],
}


func after_each() -> void:
	GameState.reset()
	ArenaLayout.use(Worlds.CANYON)


# Every colour the pack allows: the 66 palette colours and the materials' colours and glows.
func _pack_colors() -> Array[Color]:
	var colors: Array[Color] = []
	colors.assign(GlimmerPalette.ALL.values())
	for file: String in DirAccess.get_files_at(PACK_DIR + "materials"):
		if file.ends_with(".tres"):
			var material: BaseMaterial3D = load(PACK_DIR + "materials/" + file)
			colors.append(material.albedo_color)
			if material.emission_enabled:
				colors.append(material.emission)
	return colors


func _in_pack(color: Color) -> bool:
	for allowed: Color in _pack_colors():
		if Color(color, 1.0).is_equal_approx(Color(allowed, 1.0)):
			return true
	return false


func _files(path: String) -> Array[String]:
	var found: Array[String] = []
	for file: String in DirAccess.get_files_at(path):
		found.append(path.path_join(file))
	for folder: String in DirAccess.get_directories_at(path):
		if folder != "addons" and not folder.begins_with("."):
			found.append_array(_files(path.path_join(folder)))
	return found


func _glimmer_arena() -> Arena:
	GameState.world = Worlds.GLIMMER_ISLES
	var arena: Arena = ARENA_SCENE.instantiate()
	arena.read_player_input = false
	add_child_autofree(arena)
	await wait_physics_frames(1)
	return arena


# A Glimmer Isles of its own in the colour variation `variation`, on its own floor and walls.
func _isles(variation: String) -> GlimmerIsles:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	var holder: Node3D = Node3D.new()
	var floor_body: StaticBody3D = StaticBody3D.new()
	var walls: Node3D = Node3D.new()
	holder.add_child(floor_body)
	holder.add_child(walls)
	var isles: GlimmerIsles = GlimmerIsles.new()
	isles.floor_body = floor_body
	isles.walls = walls
	isles.variation = variation
	holder.add_child(isles)
	add_child_autofree(holder)
	return isles


func test_no_file_names_the_packs_old_path_and_the_lighting_scene_loads() -> void:
	for file: String in _files("res://"):
		if file.get_extension() in ["gd", "tscn", "tres", "md", "cfg", "godot"]:
			var text: String = FileAccess.get_file_as_string(file)
			assert_false(text.contains(OLD_PATH), "%s names the old path" % file)
	var lighting: Node = autofree((load(LIGHTING_SCENE) as PackedScene).instantiate())
	var holder: WorldEnvironment = lighting.get_node("WorldEnvironment")
	assert_not_null(holder.environment, "the lighting scene has its environment")
	assert_eq(holder.environment.resource_path, PACK_DIR + "glimmer_isles_environment.tres")


func test_the_export_leaves_out_the_packs_unused_files() -> void:
	var presets: ConfigFile = ConfigFile.new()
	assert_eq(presets.load("res://export_presets.cfg"), OK)
	var filter: String = presets.get_value("preset.0", "exclude_filter")
	for unused: String in ["*.png", "*.gpl", "*.hex", "*.json", "README.md"]:
		assert_true(filter.contains("scenes/glimmer_isles/" + unused), unused)
	assert_true(filter.contains("scenes/glimmer_isles/glimmer_isles_ui_theme.tres"), "UI theme")
	assert_false(filter.contains("scenes/glimmer_isles/*,"), "the used files are exported")


func test_original_is_the_look_before_the_palette() -> void:
	assert_eq(GlimmerLooks.roles(GlimmerLooks.ORIGINAL).size(), BEFORE.size())
	for role: String in BEFORE:
		var look: Dictionary = GlimmerLooks.look(role, GlimmerLooks.ORIGINAL)
		var before: Array = BEFORE[role]
		assert_eq(look["albedo"], before[0], role)
		assert_eq(look["glow"], before[1] if before.size() > 1 else Color.BLACK, role)
		assert_eq(look["glow_strength"], before[2] if before.size() > 1 else 0.0, role)
	# The bake stored each part's colours as they were: Original gives back the same materials.
	var baked: Node3D = autofree(GlimmerIsles.load_baked(GlimmerLooks.ORIGINAL))
	for child: Node in baked.get_children():
		var expected: Material = ToonMaterials.toon(
			child.get_meta("albedo"),
			child.get_meta("glow"),
			child.get_meta("glow_strength"),
			child.get_meta("outlined")
		)
		assert_eq((child as MultiMeshInstance3D).material_override, expected, child.name)


func test_every_glimmer_role_has_a_palette_or_pack_material_colour() -> void:
	for role: String in GlimmerLooks.roles(GlimmerLooks.GLIMMER):
		var look: Dictionary = GlimmerLooks.look(role, GlimmerLooks.GLIMMER)
		assert_true(_in_pack(look["albedo"]), "%s %s" % [role, look["albedo"]])
		if look["glow_strength"] > 0.0:
			assert_true(_in_pack(look["glow"]), "%s glow %s" % [role, look["glow"]])
	for kind: String in GlimmerLooks.PARTS:
		for index: int in GlimmerLooks.PARTS[kind].size():
			var role: String = GlimmerLooks.part_role(kind, index)
			assert_true(GlimmerLooks.has_role(role, GlimmerLooks.GLIMMER), role)
			assert_true(GlimmerLooks.has_role(role, GlimmerLooks.ORIGINAL), role)


func test_the_part_names_follow_the_props() -> void:
	for kind: String in GlimmerProp.KINDS:
		var prop: GlimmerProp = autofree(GlimmerProp.new())
		prop.kind = kind
		var names: Array = []
		for part: MeshInstance3D in prop.parts():
			names.append(String(part.name))
		assert_eq(names, GlimmerLooks.PARTS[kind], kind)


func test_only_glowing_parts_glow_in_glow_colours() -> void:
	var glowing: Array[Color] = []
	for colour: String in ["glow_deep", "glow_violet", "glow_lilac", "glow_cyan", "glow_lime"]:
		glowing.append(GlimmerPalette.ALL[colour])
	for colour: String in ["glow_core", "amber_dark", "amber", "gold", "sunbeam", "sparkle"]:
		glowing.append(GlimmerPalette.ALL[colour])
	glowing.append(GlimmerPalette.STAR_WHITE)
	for role: String in GlimmerLooks.roles(GlimmerLooks.GLIMMER):
		var look: Dictionary = GlimmerLooks.look(role, GlimmerLooks.GLIMMER)
		if look["glow_strength"] > 0.0 and not role.begins_with("waterfall"):
			assert_true(
				glowing.any(func(c: Color) -> bool: return c.is_equal_approx(look["glow"])),
				"%s glows in a Glow Mushrooms or Glimmer Gold colour" % role
			)


func test_every_surface_in_the_game_has_a_pack_colour() -> void:
	var arena: Arena = await _glimmer_arena()
	var nodes: Array[Node] = []
	for holder: String in ["GlimmerIsles", "Walls", "Floor"]:
		nodes.append_array(
			arena.get_node(holder).find_children("*", "GeometryInstance3D", true, false)
		)
	var checked: int = 0
	for node: Node in nodes:
		var material: Material = (node as GeometryInstance3D).material_override
		if not ToonMaterials.is_toon(material):
			continue
		var toon: ShaderMaterial = material
		var albedo: Color = toon.get_shader_parameter("albedo")
		if toon.get_shader_parameter("use_instance_color"):
			# The tiles take the ground roles' colours as they are (a headless run keeps no
			# MultiMesh data to read back).
			for role: String in ["ground", "ground_alt"]:
				assert_eq(GlimmerLooks.look(role)["jitter"], 0.0, "%s tiles not lightened" % role)
		else:
			assert_true(_in_pack(albedo), "%s %s" % [node.name, albedo])
		if float(toon.get_shader_parameter("emission_energy")) > 0.0:
			var glow: Color = toon.get_shader_parameter("emission")
			assert_true(_in_pack(glow), "%s glow %s" % [node.name, glow])
		checked += 1
	assert_gt(checked, 30, "the ground, walls, plinths, cover, rim, underside and every prop")


func test_the_lagoon_and_the_waterfalls_take_the_packs_water_colours() -> void:
	var arena: Arena = await _glimmer_arena()
	var lagoon: MeshInstance3D = arena.get_node("GlimmerIsles/Lagoon")
	var water: BaseMaterial3D = GlimmerLooks.pack_material("water")
	var shader: ShaderMaterial = lagoon.material_override
	assert_eq(shader.shader, WATER_SHADER, "the lagoon flows")
	assert_eq(shader.get_shader_parameter("water"), water.albedo_color, "water colour and alpha")
	assert_lt(lagoon.global_position.y, -10.0, "far below the floor")
	assert_eq(lagoon.find_children("*", "CollisionObject3D", true, false), [], "no collider")
	var waterfall: BaseMaterial3D = GlimmerLooks.pack_material("waterfall")
	var falls: Node = arena.get_node("GlimmerIsles/Decor/Waterfalls")
	assert_gt(falls.get_child_count(), 0)
	for fall: MeshInstance3D in falls.get_children():
		var material: ShaderMaterial = fall.material_override
		assert_eq(material.get_shader_parameter("water"), waterfall.albedo_color, fall.name)
	assert_null(_isles(GlimmerLooks.ORIGINAL).get_node_or_null("Lagoon"), "Original has none")


func test_places_colliders_and_layout_are_the_same_in_both_variations() -> void:
	var shapes: Array = []
	for variation: String in [GlimmerLooks.ORIGINAL, GlimmerLooks.GLIMMER]:
		var isles: GlimmerIsles = _isles(variation)
		var found: Array = []
		for body: Node in [isles.floor_body] + isles.walls.get_children():
			var shape: CollisionShape3D = body.get_node("Collision")
			found.append([(body as Node3D).position, (shape.shape as BoxShape3D).size])
		assert_eq(
			isles.find_children("*", "CollisionObject3D", true, false), [], "no collider of its own"
		)
		shapes.append(found)
	assert_eq_deep(shapes[0], shapes[1])
	assert_eq(shapes[1].size(), GlimmerIslesLayout.WALLS.size() + 1, "the floor and every wall")
	var original: Node3D = autofree(GlimmerIsles.load_baked(GlimmerLooks.ORIGINAL))
	var glimmer: Node3D = autofree(GlimmerIsles.load_baked(GlimmerLooks.GLIMMER))
	for index: int in original.get_child_count():
		var before: MultiMesh = (original.get_child(index) as MultiMeshInstance3D).multimesh
		var after: MultiMesh = (glimmer.get_child(index) as MultiMeshInstance3D).multimesh
		assert_eq(after.instance_count, before.instance_count)
		for place: int in before.instance_count:
			assert_eq(after.get_instance_transform(place), before.get_instance_transform(place))
	assert_eq(ArenaLayout.starts(), GlimmerIslesLayout.STARTS, "start points")


func test_the_pack_lights_the_world_through_copies_and_classic_shows_it_as_delivered() -> void:
	var pack: Environment = load(PACK_DIR + "glimmer_isles_environment.tres")
	var lighting: Node = autofree((load(LIGHTING_SCENE) as PackedScene).instantiate())
	var pack_sun: DirectionalLight3D = lighting.get_node("Sun")
	GameState.light_preset = LightPresets.CLASSIC
	var arena: Arena = await _glimmer_arena()
	var environment: Environment = (
		(arena.get_node("WorldEnvironment") as WorldEnvironment).environment
	)
	assert_ne(environment, pack, "a copy of the pack's environment")
	for property: String in [
		"background_mode",
		"ambient_light_energy",
		"tonemap_mode",
		"tonemap_white",
		"glow_enabled",
		"glow_intensity",
		"glow_hdr_threshold",
		"adjustment_enabled",
		"adjustment_saturation",
	]:
		assert_eq(environment.get(property), pack.get(property), "Classic keeps %s" % property)
	assert_false(environment.fog_enabled, "Classic has no fog, the look before the palette (D59)")
	# The fill light's violet is folded into the ambient light, by the two energies (D47).
	var fill: OmniLight3D = lighting.get_node("MagicFill")
	var share: float = fill.light_energy / (fill.light_energy + pack.ambient_light_energy)
	var ambient: Color = pack.ambient_light_color.lerp(GlimmerPalette.GLOW_LILAC, share)
	assert_true(environment.ambient_light_color.is_equal_approx(ambient), "ambient with the fill")
	assert_null(arena.get_node("GlimmerIsles").get_node_or_null("MagicFill"), "no omni light")
	var sky: ProceduralSkyMaterial = environment.sky.sky_material
	var pack_sky: ProceduralSkyMaterial = pack.sky.sky_material
	assert_eq(sky.sky_top_color, pack_sky.sky_top_color, "the pack's violet sky")
	assert_eq(sky.sky_horizon_color, pack_sky.sky_horizon_color, "blush pink at the horizon")
	var sun: DirectionalLight3D = arena.get_node("Sun")
	assert_eq(sun.light_color, pack_sun.light_color, "the pack's warm sun")
	assert_eq(sun.light_energy, pack_sun.light_energy)
	assert_eq(sun.shadow_opacity, pack_sun.shadow_opacity)
	assert_true(sun.rotation.is_equal_approx(pack_sun.rotation), "the pack's sun angle")
	for preset_id: String in LightPresets.ids():
		arena.set_light_preset(preset_id)
	arena.set_saturation_boost(true)
	assert_true(pack.glow_enabled and pack.fog_enabled, "the pack's environment is unchanged")
	assert_almost_eq(pack.adjustment_saturation, 1.18, 0.001)
	assert_eq(pack_sky.sky_top_color, GlimmerPalette.DREAM_VIOLET)


func test_bright_day_shows_the_packs_sky_only_over_the_packs_light_as_delivered() -> void:
	var pack_sky: Sky = (load(PACK_DIR + "glimmer_isles_environment.tres") as Environment).sky
	var arena: Arena = await _glimmer_arena()
	assert_eq(arena.lighting().preset(), LightPresets.BRIGHT_DAY, "the default preset")
	var environment: Environment = (
		(arena.get_node("WorldEnvironment") as WorldEnvironment).environment
	)
	assert_eq(environment.sky, pack_sky, "Glimmer in Bright day: the pack's sky as delivered (D58)")
	assert_false(environment.fog_enabled, "and no fog")
	for preset_id: String in [LightPresets.GOLDEN_SUNSET, LightPresets.NEON_NIGHT]:
		arena.set_light_preset(preset_id)
		environment = (arena.get_node("WorldEnvironment") as WorldEnvironment).environment
		assert_ne(environment.sky, pack_sky, "%s keeps its own sky" % preset_id)
	arena.set_light_preset(LightPresets.BRIGHT_DAY)
	arena.set_colour_variation(ColourVariations.LAGOON)
	environment = (arena.get_node("WorldEnvironment") as WorldEnvironment).environment
	assert_ne(environment.sky, pack_sky, "Lagoon has its own sky, so Bright day's shows")
	arena.set_colour_variation(GlimmerLooks.GLIMMER)
	environment = (arena.get_node("WorldEnvironment") as WorldEnvironment).environment
	assert_eq(environment.sky, pack_sky, "back to Glimmer: the pack's sky again")


func test_the_light_floor_and_border_tops_cannot_wash_to_white() -> void:
	# Bright day lifts a surface about 1.4 times (PEBBLE 8790b0 came out b8c8ff on the review's
	# screenshot), so a colour whose darkest channel is over 0.6 would turn all white (STONE_LIGHT
	# b9c2d9, SHELL fff0c9 did: the third review's finding 1).
	for variation: String in [GlimmerLooks.GLIMMER, ColourVariations.LAGOON]:
		for role: String in ["ground", "ground_alt", "border_top", "crystal_cluster/Rock"]:
			var albedo: Color = GlimmerLooks.color(role, variation)
			assert_lt(minf(albedo.r, minf(albedo.g, albedo.b)), 0.6, "%s %s" % [variation, role])


func test_the_presets_keep_their_own_look_over_the_packs_light() -> void:
	var arena: Arena = await _glimmer_arena()
	for preset_id: String in LightPresets.ids():
		if preset_id == LightPresets.CLASSIC:
			continue
		arena.set_light_preset(preset_id)
		var environment: Environment = (
			(arena.get_node("WorldEnvironment") as WorldEnvironment).environment
		)
		assert_false(environment.fog_enabled, "%s: no fog" % preset_id)
		assert_eq(environment.tonemap_mode, Environment.TONE_MAPPER_LINEAR, preset_id)
		assert_almost_eq(
			environment.adjustment_saturation,
			LightPresets.saturation(preset_id, false),
			0.001,
			"%s keeps its colour balance" % preset_id
		)


func test_original_keeps_its_own_sky_and_sun() -> void:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	var holder: Node3D = Node3D.new()
	var world_environment: WorldEnvironment = WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	world_environment.environment = Environment.new()
	var sun: DirectionalLight3D = DirectionalLight3D.new()
	sun.name = "Sun"
	holder.add_child(world_environment)
	holder.add_child(sun)
	var floor_body: StaticBody3D = StaticBody3D.new()
	var walls: Node3D = Node3D.new()
	holder.add_child(floor_body)
	holder.add_child(walls)
	var isles: GlimmerIsles = GlimmerIsles.new()
	isles.floor_body = floor_body
	isles.walls = walls
	isles.variation = GlimmerLooks.ORIGINAL
	holder.add_child(isles)
	add_child_autofree(holder)
	var sky: ProceduralSkyMaterial = world_environment.environment.sky.sky_material
	assert_eq(sky.sky_top_color, Color("1b1446"))
	assert_eq(world_environment.environment.ambient_light_color, Color("b8a8ff"))
	assert_false(world_environment.environment.glow_enabled)
	assert_eq(sun.light_color, Color("fff0ff"))
	assert_null(isles.get_node_or_null("MagicFill"), "no fill light in Original")
