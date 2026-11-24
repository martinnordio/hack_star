extends GutTest
## The brighter worlds' newer decoration (spec 09, L2, D26, D30): at least three new kinds per
## world, some of them moving, none with a collider and none in the playing area, so the walls,
## cover, start points and collisions stay those of the layout (W4, W7, S2).

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _arena(world_id: String) -> Arena:
	GameState.world = world_id
	var arena: Arena = ARENA_SCENE.instantiate()
	arena.read_player_input = false
	add_child_autofree(arena)
	await wait_process_frames(2)
	return arena


func _world(arena: Arena) -> Node3D:
	if ArenaLayout.world() == Worlds.GLIMMER_ISLES:
		return arena.get_node("GlimmerIsles")
	return arena.get_node("Canyon")


## Every collision body of the world: the floor and one per layout wall, where the layout says.
func _assert_only_layout_collisions(arena: Arena) -> void:
	var walls: Array[Rect2] = ArenaLayout.walls()
	var bodies: Array[Node] = _world(arena).find_children("*", "CollisionObject3D", true, false)
	assert_eq(bodies, [], "%s: the world's own nodes have no collider" % ArenaLayout.world())
	var wall_bodies: Array[Node] = arena.get_node("Walls").get_children()
	assert_eq(wall_bodies.size(), walls.size(), "one body per layout wall")
	for index: int in walls.size():
		var body: Node3D = wall_bodies[index]
		var center: Vector2 = walls[index].get_center()
		assert_almost_eq(Vector2(body.position.x, body.position.z), center, Vector2.ONE * 0.001)
	assert_eq(arena.get_node("Floor").get_child_count(), 2, "the floor: collision and mesh")


func test_the_canyon_has_four_new_kinds_and_no_collider() -> void:
	var arena: Arena = await _arena(Worlds.CANYON)
	var decor: CanyonDecor = arena.get_node("Canyon/Decor")
	for kind: String in CanyonDecor.KINDS:
		assert_gt(decor.get_node(kind).get_child_count(), 0, "%s are there" % kind)
	var blossoms: MultiMeshInstance3D = arena.get_node("Canyon/CactusBlossoms")
	assert_gt(blossoms.multimesh.instance_count, 5, "blossoms on the cactus tops")
	_assert_only_layout_collisions(arena)


func test_the_canyon_decoration_stays_out_of_the_playing_area() -> void:
	var arena: Arena = await _arena(Worlds.CANYON)
	var decor: CanyonDecor = arena.get_node("Canyon/Decor")
	var inside: Rect2 = ArenaLayout.bounds().grow(-1.0)
	for flag: Node3D in decor.get_node("Flags").get_children():
		var at: Vector3 = flag.global_position
		assert_false(inside.has_point(Vector2(at.x, at.z)), "%s on the border" % flag.name)
		assert_gt(at.y, Canyon.CAMERA_SIDE_WALL_HEIGHT, "%s on a high wall" % flag.name)
	var water: Node3D = decor.get_node("Stream/Water")
	assert_gt(water.global_position.x, ArenaLayout.bounds().end.x, "the stream is outside")
	for bird: Node3D in decor.birds():
		assert_gt(bird.global_position.y, 6.0, "%s flies high" % bird.name)


func test_the_canyon_birds_fly_and_flap_and_the_flags_and_the_stream_move() -> void:
	var arena: Arena = await _arena(Worlds.CANYON)
	var decor: CanyonDecor = arena.get_node("Canyon/Decor")
	var bird: Node3D = decor.birds()[0]
	var before: Vector3 = bird.position
	var wing: float = (bird.get_node("WingLeft") as Node3D).rotation.z
	await wait_seconds(0.2)
	assert_gt(bird.position.distance_to(before), 0.1, "the bird flies on")
	assert_ne((bird.get_node("WingLeft") as Node3D).rotation.z, wing, "it flaps")
	var cloth: MeshInstance3D = decor.get_node("Flags/Flag0/Cloth")
	assert_eq((cloth.material_override as ShaderMaterial).shader, CanyonDecor.FLAG_SHADER)
	var water: MeshInstance3D = decor.get_node("Stream/Water")
	assert_eq((water.material_override as ShaderMaterial).shader, CanyonDecor.WATER_SHADER)


func test_glimmer_isles_has_four_new_kinds_and_no_collider() -> void:
	var arena: Arena = await _arena(Worlds.GLIMMER_ISLES)
	var decor: GlimmerDecor = arena.get_node("GlimmerIsles/Decor")
	var flies: CPUParticles3D = decor.get_node("Fireflies")
	assert_true(flies.emitting, "fireflies")
	assert_lte(flies.amount, 64, "at most 64 fireflies (D26)")
	assert_gt(decor.get_node("Waterfalls").get_child_count(), 3, "waterfalls")
	assert_gt(decor.crystals().size(), 0, "glowing crystals")
	assert_gt(decor.islands().size(), 0, "floating islands")
	_assert_only_layout_collisions(arena)


func test_glimmer_isles_waterfalls_are_outside_and_crystals_and_islands_move() -> void:
	var arena: Arena = await _arena(Worlds.GLIMMER_ISLES)
	var decor: GlimmerDecor = arena.get_node("GlimmerIsles/Decor")
	for fall: Node3D in decor.get_node("Waterfalls").get_children():
		var at: Vector3 = fall.global_position
		assert_false(
			ArenaLayout.bounds().has_point(Vector2(at.x, at.z)), "%s is outside" % fall.name
		)
	var crystals: MultiMeshInstance3D = decor.crystals()[0]
	var crystal: ShaderMaterial = crystals.material_override
	var glow: float = crystal.get_shader_parameter("emission_energy")
	var shared: ShaderMaterial = GlimmerLooks.material(
		GlimmerLooks.part_role(crystals.get_meta("kind"), crystals.get_meta("part_index")),
		decor.variation,
		crystals.get_meta("outlined")
	)
	assert_ne(crystal, shared, "the crystals pulse on their own copy of the material")
	var base_glow: float = shared.get_shader_parameter("emission_energy")
	var island: MultiMeshInstance3D = decor.islands()[0]
	var place: Transform3D = decor.island_place(island, 0)
	await wait_seconds(0.3)
	assert_ne(crystal.get_shader_parameter("emission_energy"), glow, "the crystals pulse")
	assert_eq(
		shared.get_shader_parameter("emission_energy"),
		base_glow,
		"the shared material keeps its glow"
	)
	var moved: Transform3D = decor.island_place(island, 0)
	assert_false(moved.is_equal_approx(place), "the islands turn and bob")
	var center: Vector3 = (decor.islands()[0].get_meta("transforms")[0] as Transform3D).origin
	assert_almost_eq(
		Vector2(moved.origin.x, moved.origin.z),
		Vector2(center.x, center.z),
		Vector2.ONE * 0.01,
		"around their own axis"
	)
