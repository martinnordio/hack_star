extends GutTest

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")

var _arena: Node3D
var _effects: ArenaEffects
var _model: FighterModel


func before_each() -> void:
	_arena = ARENA_SCENE.instantiate()
	add_child_autofree(_arena)
	_effects = _arena.get_node("Effects")
	_model = _arena.get_node("Fighter/Model")


func _playing(kind: String) -> int:
	var count: int = 0
	for particles: CPUParticles3D in _effects.pool(kind):
		if particles.emitting:
			count += 1
	return count


func _meshes(node: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	for child: Node in node.get_children():
		if child is MeshInstance3D:
			found.append(child)
		found.append_array(_meshes(child))
	return found


func _is_see_through(mesh: MeshInstance3D) -> bool:
	if not mesh.has_meta(FighterModel.SOLID_META):
		return false
	return mesh.material_override != mesh.get_meta(FighterModel.SOLID_META)


func test_standing_in_a_bush_makes_the_model_see_through_and_leaving_makes_it_solid() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	var meshes: Array[MeshInstance3D] = _meshes(_model)
	assert_gt(meshes.size(), 0, "the model has meshes")
	await wait_physics_frames(2)
	assert_false(_model.see_through, "solid at the start")
	var bush: Rect2 = ArenaLayout.BUSHES[0]
	fighter.position = Vector3(bush.get_center().x, 0.0, bush.get_center().y)
	await wait_physics_frames(2)
	assert_true(_model.see_through, "see-through in the bush")
	for mesh: MeshInstance3D in meshes:
		assert_true(_is_see_through(mesh), "%s is see-through" % mesh.name)
	fighter.position = Vector3(ArenaLayout.START.x, 0.0, ArenaLayout.START.y)
	await wait_physics_frames(2)
	assert_false(_model.see_through, "solid outside")
	for mesh: MeshInstance3D in meshes:
		assert_false(_is_see_through(mesh), "%s is solid" % mesh.name)


func test_a_new_look_in_a_bush_is_see_through_too() -> void:
	_model.set_see_through(true)
	_model.setup("rocko", "crystal")
	for mesh: MeshInstance3D in _meshes(_model):
		assert_true(_is_see_through(mesh), "%s is see-through" % mesh.name)


func test_a_shot_plays_a_flash_and_when_it_ends_sparks() -> void:
	assert_eq(_playing(ArenaEffects.FLASH), 0, "no flash before")
	var fighter: Fighter = _arena.get_node("Fighter")
	fighter.position = Vector3(0.0, 0.0, 3.0)
	assert_true(_arena.fire(Vector2.UP), "fired")
	assert_eq(_playing(ArenaEffects.FLASH), 1, "a flash")
	var flash: CPUParticles3D = _effects.pool(ArenaEffects.FLASH)[0]
	var muzzle: Vector3 = _arena.get_node("Fighter/Muzzle").global_position
	assert_almost_eq(flash.global_position, muzzle, Vector3.ONE * 0.001, "at the muzzle")
	assert_eq(_playing(ArenaEffects.SPARKS), 0, "no sparks while flying")
	await wait_until(func() -> bool: return _playing(ArenaEffects.SPARKS) > 0, 2.0)
	assert_eq(_playing(ArenaEffects.SPARKS), 1, "sparks where the shot ended")


func test_sparks_play_where_a_shot_hits_a_dummy() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	var spot: Vector2 = ArenaLayout.DUMMIES[0]
	fighter.position = Vector3(spot.x, 0.0, 0.0)
	_arena.fire(Vector2.UP)
	await wait_until(func() -> bool: return _playing(ArenaEffects.SPARKS) > 0, 2.0)
	var sparks: CPUParticles3D = _effects.pool(ArenaEffects.SPARKS)[0]
	assert_almost_eq(sparks.global_position.x, spot.x, 0.01)
	assert_lt(sparks.global_position.z, 0.0, "on the dummy's side towards the fighter")
	assert_gt(sparks.global_position.z, spot.y, "in front of the dummy's middle")


func test_running_plays_dust() -> void:
	var fighter: Fighter = _arena.get_node("Fighter")
	_arena.read_player_input = false
	await wait_physics_frames(3)
	assert_eq(_playing(ArenaEffects.DUST), 0, "no dust when standing")
	fighter.input_direction = Vector2.RIGHT
	await wait_physics_frames(6)
	assert_gt(_playing(ArenaEffects.DUST), 0, "dust while running")


func test_the_pools_never_grow() -> void:
	var sizes: Dictionary = {}
	for kind: String in ArenaEffects.POOL_SIZES:
		sizes[kind] = _effects.pool(kind).size()
		assert_eq(sizes[kind], ArenaEffects.POOL_SIZES[kind], "%s pool size" % kind)
	var count: int = _effects.get_child_count()
	for _i: int in 20:
		for kind: String in ArenaEffects.POOL_SIZES:
			_effects.play(kind, Vector3.ZERO, Color.WHITE)
	assert_eq(_effects.get_child_count(), count, "no new nodes")
	for kind: String in ArenaEffects.POOL_SIZES:
		assert_eq(_effects.pool(kind).size(), sizes[kind], "%s pool size" % kind)
