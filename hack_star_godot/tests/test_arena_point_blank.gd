extends GutTest
## A shot fired while the fighter touches a wall, a rock or a dummy hits it (review finding 1).

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
## The fighter's collision capsule and the dummy's.
const FIGHTER_RADIUS: float = 0.4
const DUMMY_RADIUS: float = 0.5
## Inner face of the east border wall.
const EAST_WALL_INNER_X: float = 9.0

var _arena: Node3D
var _fighter: Fighter


func before_each() -> void:
	_arena = ARENA_SCENE.instantiate()
	add_child_autofree(_arena)
	_fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false


## Fires `direction` and returns the `ended` parameters of the shot.
func _fire_and_wait(direction: Vector2) -> Array:
	assert_true(_arena.fire(direction), "fired")
	var shot: Shot = _arena.get_node("Shots").get_child(0)
	var ends: Array = []
	shot.ended.connect(func(at: Vector3, hit: bool) -> void: ends.append_array([at, hit]))
	await wait_until(func() -> bool: return not ends.is_empty(), 2.0)
	return ends


func test_a_shot_at_the_border_wall_stops_at_it() -> void:
	_fighter.position = Vector3(EAST_WALL_INNER_X - FIGHTER_RADIUS, 0.0, 0.0)
	await wait_physics_frames(2)
	var ends: Array = await _fire_and_wait(Vector2.RIGHT)
	assert_eq(ends.size(), 2, "the shot ended")
	assert_true(ends[1], "hit the wall")
	assert_almost_eq(ends[0].x, EAST_WALL_INNER_X, 0.01, "stopped at the wall's face")


func test_a_shot_at_a_rock_stops_at_it() -> void:
	var rock: Rect2 = ArenaLayout.WALLS[6]
	_fighter.position = Vector3(ArenaLayout.START.x, 0.0, rock.end.y + FIGHTER_RADIUS)
	await wait_physics_frames(2)
	var ends: Array = await _fire_and_wait(Vector2.UP)
	assert_eq(ends.size(), 2, "the shot ended")
	assert_true(ends[1], "hit the rock")
	assert_almost_eq(ends[0].z, rock.end.y, 0.01, "stopped at the rock's face")


func test_a_shot_at_a_dummy_next_to_the_fighter_damages_it() -> void:
	var dummy: TargetDummy = _arena.get_node("Dummies").get_child(0)
	var spot: Vector2 = ArenaLayout.DUMMIES[0]
	_fighter.position = Vector3(spot.x, 0.0, spot.y + DUMMY_RADIUS + FIGHTER_RADIUS)
	await wait_physics_frames(2)
	var ends: Array = await _fire_and_wait(Vector2.UP)
	assert_true(ends[1], "hit the dummy")
	assert_eq(dummy.health, Combat.DUMMY_HEALTH - Combat.DAMAGE, "the dummy took the damage")
