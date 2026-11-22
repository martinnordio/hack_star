extends GutTest

const DUMMY_SCENE: PackedScene = preload("res://scenes/target_dummy.tscn")

var _dummy: TargetDummy


func before_each() -> void:
	_dummy = DUMMY_SCENE.instantiate()
	_dummy.respawn_seconds = 0.3
	add_child_autofree(_dummy)


func _numbers() -> Array[String]:
	var texts: Array[String] = []
	for child: Node in _dummy.get_children():
		if child is Label3D:
			texts.append((child as Label3D).text)
	return texts


func test_a_dummy_is_a_target_on_the_target_layer() -> void:
	assert_true(_dummy.is_in_group("targets"), "in the group targets")
	assert_eq(_dummy.collision_layer, 0b100, "the target layer")
	assert_eq(_dummy.health, Combat.DUMMY_HEALTH, "full health")


func test_a_hit_lowers_health_and_the_bar_and_shows_the_damage() -> void:
	var fill: MeshInstance3D = _dummy.get_node("Bar/Fill")
	var full_width: float = (fill.mesh as QuadMesh).size.x
	_dummy.hit(Combat.DAMAGE)
	assert_eq(_dummy.health, Combat.DUMMY_HEALTH - Combat.DAMAGE)
	assert_almost_eq((fill.mesh as QuadMesh).size.x, full_width * 0.8, 0.001, "the bar is shorter")
	assert_eq(_numbers(), ["480"], "the damage number")
	_dummy.hit(Combat.DAMAGE)
	_dummy.hit(Combat.DAMAGE)
	var material: StandardMaterial3D = fill.material_override
	assert_eq(material.albedo_color, Combat.COLOR_YELLOW, "the bar is yellow below half")


func test_the_damage_number_fades_away() -> void:
	_dummy.hit(Combat.DAMAGE)
	await wait_seconds(TargetDummy.NUMBER_SECONDS + 0.3)
	assert_eq(_numbers(), [], "the number is gone")


func test_five_hits_break_it_and_turn_its_collision_off() -> void:
	watch_signals(_dummy)
	for _i: int in 4:
		_dummy.hit(Combat.DAMAGE)
	assert_false(_dummy.is_broken(), "still standing after four hits")
	assert_false(_dummy.get_node("Collision").disabled, "collision on")
	_dummy.hit(Combat.DAMAGE)
	assert_true(_dummy.is_broken(), "broken after five hits")
	assert_eq(_dummy.health, 0)
	assert_true(_dummy.get_node("Collision").disabled, "collision off")
	assert_false(_dummy.get_node("Bar").visible, "no bar")
	assert_signal_emitted(_dummy, "broken")
	var post: Node3D = _dummy.get_node("Parts/Post")
	var before: Vector3 = post.position
	await wait_seconds(0.2)
	assert_ne(post.position, before, "the parts fly apart")


func test_it_is_back_with_full_health_after_the_respawn_time() -> void:
	watch_signals(_dummy)
	var post: Node3D = _dummy.get_node("Parts/Post")
	var home: Vector3 = post.position
	for _i: int in 5:
		_dummy.hit(Combat.DAMAGE)
	await wait_seconds(_dummy.respawn_seconds + 0.3)
	assert_signal_emitted(_dummy, "respawned")
	assert_eq(_dummy.health, Combat.DUMMY_HEALTH, "full health")
	assert_false(_dummy.get_node("Collision").disabled, "collision on")
	assert_true(_dummy.get_node("Bar").visible, "the bar is back")
	assert_almost_eq(post.position, home, Vector3.ONE * 0.001, "the parts are back")
