extends GutTest
## Own projectiles (spec 09, M6, D38, D41): MagMax, Echo and Flarekid shoot their projectile
## pictures, turned along the flight; the other fighters keep the ball; speed, range, damage and
## walls are the same for both looks.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const ANIMATED: Array[String] = ["magmax", "echo", "flarekid"]
const WALL_X: float = 3.0


class Target:
	extends StaticBody3D
	var damage: int = 0

	func hit(amount: int) -> void:
		damage += amount


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _launch(toward: Vector3, picture: Texture2D) -> Shot:
	var shot: Shot = Shot.new()
	shot.launch(Vector3(0.0, 0.6, 0.0), toward, Color.ORANGE, Vector3.INF, null, picture)
	add_child_autofree(shot)
	return shot


func _ended(shot: Shot) -> Array:
	var params: Array = []
	shot.ended.connect(func(at: Vector3, hit: bool) -> void: params.append_array([at, hit]))
	await wait_until(func() -> bool: return not params.is_empty(), 2.0)
	return params


func _shot_of(fighter_id: String) -> Shot:
	GameState.select(fighter_id, Fighters.DEFAULT_SKIN)
	var arena: Arena = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	arena.read_player_input = false
	await wait_process_frames(2)
	assert_true(arena.fire(Vector2.RIGHT))
	return arena.get_node("Shots").get_child(0)


func test_the_animated_fighters_shoot_their_own_pictures() -> void:
	for fighter_id: String in ANIMATED:
		var shot: Shot = await _shot_of(fighter_id)
		var part: MeshInstance3D = shot.get_node_or_null("Picture")
		assert_not_null(part, fighter_id)
		var material: ShaderMaterial = part.material_override
		assert_eq(material.shader, Shot.PICTURE_SHADER)
		assert_eq(
			material.get_shader_parameter("picture"),
			CutoutFighters.projectile(fighter_id),
			fighter_id
		)
		assert_null(shot.get_node_or_null("Ball"), "no ball for %s" % fighter_id)


func test_the_other_fighters_keep_the_ball() -> void:
	var shot: Shot = await _shot_of("blaze")
	assert_not_null(shot.get_node_or_null("Ball"))
	assert_not_null(shot.get_node_or_null("Tail"))
	assert_null(shot.get_node_or_null("Picture"))


func test_the_picture_is_turned_along_the_flight_and_a_metre_long() -> void:
	var picture: Texture2D = CutoutFighters.projectile("echo")
	for toward: Vector3 in [Vector3.RIGHT, Vector3.LEFT, Vector3.FORWARD, Vector3(1.0, 0.0, 1.0)]:
		var shot: Shot = _launch(toward, picture)
		var part: MeshInstance3D = shot.get_node("Picture")
		assert_almost_eq(part.basis.x, toward.normalized(), Vector3.ONE * 0.001, str(toward))
		var quad: QuadMesh = part.mesh
		assert_eq(quad.size.x, Shot.PICTURE_LENGTH)
		var aspect: float = float(picture.get_height()) / picture.get_width()
		assert_almost_eq(quad.size.y, Shot.PICTURE_LENGTH * aspect, 0.001)
		assert_eq(part.cast_shadow, GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)


func test_shots_with_one_picture_share_their_mesh_and_material() -> void:
	var picture: Texture2D = CutoutFighters.projectile("magmax")
	var first: MeshInstance3D = _launch(Vector3.RIGHT, picture).get_node("Picture")
	var second: MeshInstance3D = _launch(Vector3.BACK, picture).get_node("Picture")
	assert_same(first.mesh, second.mesh)
	assert_same(first.material_override, second.material_override)


func test_a_picture_shot_flies_as_fast_and_as_far_as_the_ball() -> void:
	var ball: Shot = _launch(Vector3.BACK, null)
	var picture: Shot = _launch(Vector3.BACK, CutoutFighters.projectile("flarekid"))
	await wait_physics_frames(5)
	assert_almost_eq(picture.travelled, ball.travelled, 0.001, "same speed")
	var params: Array = await _ended(picture)
	assert_almost_eq(params[0], Vector3(0.0, 0.6, Combat.SHOT_RANGE), Vector3.ONE * 0.01, "range")
	assert_false(params[1])


func test_a_picture_shot_stops_at_a_wall_and_does_the_same_damage() -> void:
	var target: Target = Target.new()
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(0.5, 2.0, 4.0)
	shape.shape = box
	target.add_child(shape)
	target.position = Vector3(WALL_X + 0.25, 1.0, 0.0)
	add_child_autofree(target)
	await wait_physics_frames(2)
	var shot: Shot = _launch(Vector3.RIGHT, CutoutFighters.projectile("magmax"))
	var params: Array = await _ended(shot)
	assert_almost_eq((params[0] as Vector3).x, WALL_X, 0.01, "stopped at its face")
	assert_true(params[1])
	assert_eq(target.damage, Combat.DAMAGE)
