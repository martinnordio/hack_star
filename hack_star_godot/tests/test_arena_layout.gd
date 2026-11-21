extends GutTest
## The canyon layout (`game/arena_layout.gd`, spec 06 D2).

const FIGHTER_RADIUS: float = 0.4
const DUMMY_RADIUS: float = 0.6


func test_every_wall_is_inside_the_arena() -> void:
	for wall: Rect2 in ArenaLayout.WALLS:
		assert_true(ArenaLayout.bounds().encloses(wall), "%s inside the arena" % wall)


func test_start_is_free_and_on_the_camera_side() -> void:
	assert_true(ArenaLayout.is_free(ArenaLayout.START, FIGHTER_RADIUS), "start is free")
	assert_gt(ArenaLayout.START.y, 0.0, "start is towards the camera")
	assert_false(ArenaLayout.in_bush(ArenaLayout.START), "start is not in a bush")


func test_dummy_spots_are_free() -> void:
	assert_eq(ArenaLayout.DUMMIES.size(), 3)
	for spot: Vector2 in ArenaLayout.DUMMIES:
		assert_true(ArenaLayout.is_free(spot, DUMMY_RADIUS), "dummy at %s is free" % spot)


func test_bushes_do_not_overlap_walls() -> void:
	for bush: Rect2 in ArenaLayout.BUSHES:
		assert_true(ArenaLayout.bounds().encloses(bush), "%s inside the arena" % bush)
		for wall: Rect2 in ArenaLayout.WALLS:
			assert_false(bush.intersects(wall), "%s does not overlap %s" % [bush, wall])


func test_decoration_stands_in_free_spots() -> void:
	for spot: Dictionary in ArenaLayout.DECORATION:
		assert_has(["crate", "skull", "rock", "bones"], spot["kind"])
		assert_true(ArenaLayout.is_free(spot["at"], 0.5), "%s is free" % spot)
		assert_false(ArenaLayout.in_bush(spot["at"]), "%s is not in a bush" % spot)


func test_in_bush_inside_and_outside_a_patch() -> void:
	var bush: Rect2 = ArenaLayout.BUSHES[0]
	assert_true(ArenaLayout.in_bush(bush.get_center()), "the centre of a patch is in a bush")
	assert_false(ArenaLayout.in_bush(bush.end + Vector2(0.5, 0.5)), "next to it is not")


func test_is_free_near_a_wall_and_outside() -> void:
	var rock: Rect2 = ArenaLayout.WALLS[ArenaLayout.BORDER_COUNT]
	assert_false(ArenaLayout.is_free(rock.get_center(), 0.1), "inside a rock")
	var beside: Vector2 = Vector2(rock.end.x + 0.3, rock.get_center().y)
	assert_false(ArenaLayout.is_free(beside, FIGHTER_RADIUS), "too close to a rock")
	assert_false(ArenaLayout.is_free(ArenaLayout.SIZE, 0.1), "outside the arena")
