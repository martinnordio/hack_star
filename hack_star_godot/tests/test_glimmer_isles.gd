extends GutTest
## Glimmer Isles baked and playable (spec 09, W3, W4, W5, D12): the baked props need no addon,
## stand in every crystal ridge and fern patch, keep the start points free, and fill the world
## in the game with the shared toon materials.

const BAKED_PATH: String = "res://scenes/worlds/glimmer_isles/baked.tscn"
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
## No prop stands this close (metres) to a start point.
const START_CLEARANCE: float = 0.75

var _places: Dictionary[String, Array] = {}


func before_all() -> void:
	var baked: Node = (load(BAKED_PATH) as PackedScene).instantiate()
	for child: Node in baked.get_children():
		if int(child.get_meta("part_index")) != 0:
			continue
		# The first part of every prop stands on the prop's own axis: its origin is the place.
		var places: Array[Vector2] = []
		for place: Transform3D in child.get_meta("transforms"):
			places.append(Vector2(place.origin.x, place.origin.z))
		_places[String(child.get_meta("kind"))] = places
	baked.free()


func after_each() -> void:
	GameState.reset()
	ArenaLayout.use(Worlds.CANYON)


func _count_inside(kinds: Array[String], rect: Rect2) -> int:
	var count: int = 0
	for kind: String in kinds:
		for at: Vector2 in _places.get(kind, []):
			if rect.has_point(at):
				count += 1
	return count


func test_the_baked_scene_needs_no_addon() -> void:
	var text: String = FileAccess.get_file_as_string(BAKED_PATH)
	assert_false(text.is_empty(), "baked.tscn exists")
	assert_false(text.contains("addons/"), "no addon path")
	assert_false(text.contains("proton_scatter"), "no ProtonScatter reference")
	var baked: Node = autofree((load(BAKED_PATH) as PackedScene).instantiate())
	assert_gt(baked.get_child_count(), 0)
	for child: Node in baked.get_children():
		assert_true(child is MultiMeshInstance3D, "%s is a plain MultiMeshInstance3D" % child.name)
		assert_null(child.get_script(), "%s has no script" % child.name)
		assert_gt((child.get_meta("transforms") as Array).size(), 0, "%s has places" % child.name)
	assert_eq(_places.keys().size(), GlimmerProp.KINDS.size(), "every prop kind is placed")


func test_crystals_in_every_ridge_and_plants_in_every_fern_patch() -> void:
	var walls: Array[Rect2] = GlimmerIslesLayout.WALLS
	for index: int in range(GlimmerIslesLayout.BORDER_COUNT, walls.size()):
		var crystals: int = _count_inside(["crystal_cluster"], walls[index])
		assert_gt(crystals, 0, "crystals in the ridge %s" % walls[index])
	for patch: Rect2 in GlimmerIslesLayout.BUSHES:
		var plants: int = _count_inside(["glow_fern", "small_mushroom"], patch)
		assert_gte(plants, 6, "plants fill the patch %s" % patch)
	for spot: Dictionary in GlimmerIslesLayout.DECORATION:
		var kind: String = "crystal_cluster" if spot["kind"] == "crystal" else "small_mushroom"
		var near: Rect2 = Rect2(spot["at"] - Vector2(0.05, 0.05), Vector2(0.1, 0.1))
		assert_eq(_count_inside([kind], near), 1, "a %s at %s" % [kind, spot["at"]])


func test_no_prop_on_a_start_point() -> void:
	for kind: String in _places:
		for at: Vector2 in _places[kind]:
			for start: Vector2 in GlimmerIslesLayout.STARTS:
				var apart: float = at.distance_to(start)
				assert_gt(
					apart, START_CLEARANCE, "%s at %s is off the start %s" % [kind, at, start]
				)


func test_the_world_in_the_game_shows_the_baked_props_on_toon_materials() -> void:
	GameState.world = Worlds.GLIMMER_ISLES
	var arena: Arena = ARENA_SCENE.instantiate()
	arena.read_player_input = false
	add_child_autofree(arena)
	await wait_physics_frames(1)
	var baked: Node3D = arena.get_node("GlimmerIsles/Baked")
	for child: Node in baked.get_children():
		var instances: MultiMeshInstance3D = child
		var count: int = (instances.get_meta("transforms") as Array).size()
		assert_eq(instances.multimesh.instance_count, count, "%s is filled" % child.name)
		assert_true(
			ToonMaterials.is_toon(instances.material_override), "%s is cel-shaded" % child.name
		)
		var outlined: bool = instances.material_override.next_pass != null
		assert_eq(outlined, bool(instances.get_meta("outlined")), "%s outline" % child.name)
	var addon_nodes: Array[Node] = []
	for node: Node in arena.find_children("*", "", true, false):
		var script: Script = node.get_script()
		if script != null and script.resource_path.begins_with("res://addons/"):
			addon_nodes.append(node)
	assert_eq(addon_nodes, [], "no addon code in the running world")
