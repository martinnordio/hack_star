extends GutTest

const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const GREEN: Color = Combat.COLOR_GREEN

var _fighter: Fighter


func before_each() -> void:
	_fighter = _add_fighter(Vector3.ZERO)


func _add_fighter(at: Vector3) -> Fighter:
	var fighter: Fighter = FIGHTER_SCENE.instantiate()
	fighter.position = at
	add_child_autofree(fighter)
	return fighter


func _numbers(fighter: Fighter) -> Array[String]:
	var texts: Array[String] = []
	for child: Node in fighter.get_children():
		if child is Label3D:
			texts.append((child as Label3D).text)
	return texts


func _now() -> float:
	return Time.get_ticks_msec() / 1000.0


## Fires a shot from `shooter`'s muzzle along `toward` and waits until it ends.
func _shoot(shooter: Fighter, toward: Vector3) -> void:
	await wait_physics_frames(2)
	var shot: Shot = Shot.new()
	var muzzle: Vector3 = shooter.muzzle.global_position
	var body: Vector3 = Vector3(shooter.global_position.x, muzzle.y, shooter.global_position.z)
	shot.launch(muzzle, toward, Color.ORANGE, body, shooter)
	var ended: Array[bool] = []
	shot.ended.connect(func(_at: Vector3, _hit: bool) -> void: ended.append(true))
	add_child_autofree(shot)
	await wait_until(func() -> bool: return not ended.is_empty(), 2.0)


func test_a_hit_lowers_health_and_shows_the_damage() -> void:
	watch_signals(_fighter)
	_fighter.hit(Combat.DAMAGE)
	assert_eq(_fighter.health, _fighter.max_health - Combat.DAMAGE)
	assert_eq(_numbers(_fighter), ["480"], "the damage number")
	assert_signal_emitted_with_parameters(_fighter, "hurt", [Combat.DAMAGE])


func test_the_bar_fill_follows_the_health_in_its_fixed_colour() -> void:
	_fighter.show_health_bar(GREEN)
	var fill: MeshInstance3D = _fighter.health_bar().get_node("Fill")
	var full_width: float = (fill.mesh as QuadMesh).size.x
	_fighter.hit(int(_fighter.max_health / 2.0))
	assert_almost_eq((fill.mesh as QuadMesh).size.x, full_width * 0.5, 0.001, "half as long")
	assert_eq((fill.material_override as StandardMaterial3D).albedo_color, GREEN, "stays green")
	_fighter.heal_step(_now() + 100.0, 1.0)
	assert_gt((fill.mesh as QuadMesh).size.x, full_width * 0.5, "grows when healing")


func test_healing_starts_after_the_quiet_time_and_stops_at_full() -> void:
	_fighter.health = 1000.0
	_fighter.last_action_seconds = 10.0
	_fighter.heal_step(11.0, 1.0)
	assert_eq(_fighter.health, 1000.0, "no healing before 3 s")
	_fighter.heal_step(14.0, 1.0)
	assert_almost_eq(_fighter.health, 1000.0 + _fighter.max_health * 0.13, 0.01, "13 % a second")
	_fighter.heal_step(1000.0, 1000.0)
	assert_eq(_fighter.health, _fighter.max_health, "never above full")


func test_a_hit_and_a_shot_reset_the_quiet_time() -> void:
	_fighter.last_action_seconds = 0.0
	_fighter.hit(Combat.DAMAGE)
	assert_almost_eq(_fighter.last_action_seconds, _now(), 0.5, "a hit")
	_fighter.last_action_seconds = 0.0
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var player: Fighter = arena.get_node("Fighter")
	player.last_action_seconds = 0.0
	assert_true(arena.fire_from(player, Vector2.UP, Combat.COOLDOWN), "fired")
	assert_almost_eq(player.last_action_seconds, _now(), 0.5, "a shot")


func test_no_health_knocks_the_fighter_out_and_it_ignores_further_hits() -> void:
	watch_signals(_fighter)
	_fighter.show_health_bar(GREEN)
	_fighter.hit(int(_fighter.max_health))
	assert_true(_fighter.knocked_out)
	assert_signal_emitted(_fighter, "knocked_out_now")
	assert_true(_fighter.get_node("Collision").disabled, "collision off")
	assert_false(_fighter.health_bar().visible, "no bar")
	await wait_seconds(Fighter.KNOCK_OUT_SECONDS + 0.2)
	assert_false(_fighter.visible, "hidden after the effect")
	var numbers: int = _numbers(_fighter).size()
	_fighter.hit(Combat.DAMAGE)
	assert_eq(_fighter.health, 0.0, "stays at 0")
	assert_eq(_numbers(_fighter).size(), numbers, "no new number")
	assert_signal_emit_count(_fighter, "hurt", 1)


func test_a_shot_from_one_fighter_hits_another() -> void:
	var target: Fighter = _add_fighter(Vector3(5.0, 0.0, -0.7))
	await _shoot(_fighter, Vector3.RIGHT)
	assert_eq(target.health, target.max_health - Combat.DAMAGE, "the target was hit")
	assert_eq(_fighter.health, _fighter.max_health, "the shooter was not")


func test_a_shot_never_hits_its_own_shooter_even_point_blank() -> void:
	await _shoot(_fighter, Vector3.BACK)
	assert_eq(_fighter.health, _fighter.max_health, "toward its own body, from the muzzle")


func test_each_fighter_has_its_own_cool_down_and_a_knocked_out_one_cannot_fire() -> void:
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var player: Fighter = arena.get_node("Fighter")
	var other: Fighter = _add_fighter(Vector3(20.0, 0.0, 20.0))
	assert_true(arena.fire_from(player, Vector2.UP, Combat.COOLDOWN), "player fires")
	assert_false(arena.fire_from(player, Vector2.UP, Combat.COOLDOWN), "player cooling down")
	assert_true(arena.fire_from(other, Vector2.UP, Combat.COOLDOWN), "other fires at once")
	other.last_fire_seconds = -INF
	other.knock_out()
	assert_false(arena.fire_from(other, Vector2.UP, Combat.COOLDOWN), "knocked out")
