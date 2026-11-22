extends GutTest
## The worlds and their layouts (spec 09, W1, W4, W7, D9): `Worlds`, `ArenaLayout.use` and the
## Glimmer Isles layout, which keeps the canyon's rules.

const FIGHTER_RADIUS: float = 0.4
const DUMMY_RADIUS: float = 0.6
## The grid step (metres) of the walk from the start to every cover patch.
const WALK_STEP: float = 0.25


func after_each() -> void:
	ArenaLayout.use(Worlds.CANYON)


func test_two_worlds_unlocked_from_the_start_with_the_canyon_first() -> void:
	assert_eq(Worlds.ids(), [Worlds.CANYON, Worlds.GLIMMER_ISLES])
	assert_eq(Worlds.get_world(Worlds.GLIMMER_ISLES)["name"], "Glimmer Isles")
	assert_eq(Worlds.get_world("moon"), {}, "an unknown world")
	for world_id: String in Worlds.ids():
		assert_true(Worlds.is_unlocked(world_id), "%s is unlocked" % world_id)
	assert_false(Worlds.is_unlocked("moon"))


func test_the_canyon_is_the_default_and_its_layout_is_unchanged() -> void:
	assert_eq(ArenaLayout.world(), Worlds.CANYON)
	assert_eq(ArenaLayout.walls(), ArenaLayout.WALLS)
	assert_eq(ArenaLayout.bushes(), ArenaLayout.BUSHES)
	assert_eq(ArenaLayout.starts(), ArenaLayout.STARTS)
	assert_eq(ArenaLayout.start(), ArenaLayout.START)
	assert_eq(ArenaLayout.dummies(), ArenaLayout.DUMMIES)
	assert_eq(ArenaLayout.decoration(), ArenaLayout.DECORATION)
	assert_eq(ArenaLayout.border_count(), ArenaLayout.BORDER_COUNT)
	ArenaLayout.use("moon")
	assert_eq(ArenaLayout.world(), Worlds.CANYON, "an unknown world gives the canyon")


func test_glimmer_isles_becomes_the_active_layout() -> void:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	assert_eq(ArenaLayout.world(), Worlds.GLIMMER_ISLES)
	assert_eq(ArenaLayout.walls(), GlimmerIslesLayout.WALLS)
	assert_eq(ArenaLayout.bushes(), GlimmerIslesLayout.BUSHES)
	assert_eq(ArenaLayout.starts(), GlimmerIslesLayout.STARTS)
	assert_eq(ArenaLayout.dummies(), GlimmerIslesLayout.DUMMIES)
	assert_ne(ArenaLayout.walls(), ArenaLayout.WALLS, "its own walls")
	assert_eq(ArenaLayout.bounds(), Rect2(-ArenaLayout.SIZE / 2.0, ArenaLayout.SIZE), "as big")
	assert_eq(ArenaLayout.border_count(), 4)
	for index: int in ArenaLayout.border_count():
		assert_eq(ArenaLayout.walls()[index], ArenaLayout.WALLS[index], "the same border")


func test_glimmer_isles_walls_cover_and_decoration_fit() -> void:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	var bounds: Rect2 = ArenaLayout.bounds()
	for wall: Rect2 in ArenaLayout.walls():
		assert_true(bounds.encloses(wall), "%s inside the arena" % wall)
	for bush: Rect2 in ArenaLayout.bushes():
		assert_true(bounds.encloses(bush), "%s inside the arena" % bush)
		for wall: Rect2 in ArenaLayout.walls():
			assert_false(bush.intersects(wall), "%s does not touch %s" % [bush, wall])
	for spot: Dictionary in ArenaLayout.decoration():
		assert_true(["crystal", "mushroom", "stone"].has(spot["kind"]), str(spot))
		assert_true(ArenaLayout.is_free(spot["at"], 0.5), "%s is free" % spot)
		assert_false(ArenaLayout.in_bush(spot["at"]), "%s is not in cover" % spot)
	assert_eq(ArenaLayout.dummies().size(), 3)
	for spot: Vector2 in ArenaLayout.dummies():
		assert_true(ArenaLayout.is_free(spot, DUMMY_RADIUS), "dummy at %s is free" % spot)


func test_glimmer_isles_starts_are_free_and_four_metres_apart() -> void:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	var starts: Array[Vector2] = ArenaLayout.starts()
	assert_eq(starts.size(), ArenaLayout.STARTS.size(), "as many as the canyon's")
	assert_gt(ArenaLayout.start().y, 0.0, "the player starts towards the camera")
	for i: int in starts.size():
		assert_true(ArenaLayout.is_free(starts[i], FIGHTER_RADIUS), "start %s is free" % starts[i])
		assert_false(ArenaLayout.in_bush(starts[i]), "start %s is not in cover" % starts[i])
		for j: int in range(i + 1, starts.size()):
			var apart: float = starts[i].distance_to(starts[j])
			assert_gte(apart, 4.0, "%s and %s are 4 m apart" % [starts[i], starts[j]])


func test_every_glimmer_isles_cover_is_reachable_from_the_start() -> void:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	var reached: Dictionary[Vector2i, bool] = _walkable_from(ArenaLayout.start())
	for bush: Rect2 in ArenaLayout.bushes():
		var cell: Vector2i = Vector2i((bush.get_center() / WALK_STEP).round())
		assert_true(reached.has(cell), "%s can be reached on foot" % bush)
	for start: Vector2 in ArenaLayout.starts():
		var cell: Vector2i = Vector2i((start / WALK_STEP).round())
		assert_true(reached.has(cell), "start %s can be reached on foot" % start)


func test_in_bush_reads_the_active_world() -> void:
	var fern: Vector2 = GlimmerIslesLayout.BUSHES[2].get_center()
	assert_false(ArenaLayout.in_bush(fern), "no cactus patch there in the canyon")
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	assert_true(ArenaLayout.in_bush(fern), "a glow-fern patch in Glimmer Isles")
	assert_false(ArenaLayout.in_bush(ArenaLayout.BUSHES[0].get_center()), "the canyon's patch")


# Every grid cell a fighter can reach from `from` without touching a wall.
func _walkable_from(from: Vector2) -> Dictionary[Vector2i, bool]:
	var start: Vector2i = Vector2i((from / WALK_STEP).round())
	var reached: Dictionary[Vector2i, bool] = {start: true}
	var open: Array[Vector2i] = [start]
	var steps: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	while not open.is_empty():
		var cell: Vector2i = open.pop_back()
		for step: Vector2i in steps:
			var next: Vector2i = cell + step
			if (
				reached.has(next)
				or not ArenaLayout.is_free(Vector2(next) * WALK_STEP, FIGHTER_RADIUS)
			):
				continue
			reached[next] = true
			open.append(next)
	return reached
