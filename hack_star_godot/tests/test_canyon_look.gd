extends GutTest
## The canyon in the outlined cartoon look of the fighters (spec 09, G10): walls, boulders, cacti
## and props are cel-shaded with the dark outline; the ground is cel-shaded without one.

const ARENA: PackedScene = preload("res://scenes/arena.tscn")
const OUTLINED_MULTIMESHES: Array[String] = [
	"Boulders", "CactusTrunks", "CactusArms", "CactusFlowers"
]


func _arena() -> Node3D:
	var arena: Node3D = ARENA.instantiate()
	add_child_autofree(arena)
	return arena


func _assert_outlined(instance: GeometryInstance3D, outlined: bool) -> void:
	var material: Material = instance.material_override
	assert_true(ToonMaterials.is_toon(material), "%s is cel-shaded" % instance.get_path())
	assert_eq(material.next_pass != null, outlined, "%s outline" % instance.get_path())


func test_walls_and_props_are_cel_shaded_with_the_outline() -> void:
	var arena: Node3D = _arena()
	var parts: Array[Node] = arena.get_node("Walls").find_children(
		"*", "MeshInstance3D", true, false
	)
	parts.append_array(
		arena.get_node("Canyon/Decoration").find_children("*", "MeshInstance3D", true, false)
	)
	assert_gt(parts.size(), 40)
	for part: MeshInstance3D in parts:
		_assert_outlined(part, true)
	for multimesh_name: String in OUTLINED_MULTIMESHES:
		_assert_outlined(arena.get_node("Canyon/" + multimesh_name), true)


func test_the_ground_is_cel_shaded_without_an_outline() -> void:
	var arena: Node3D = _arena()
	_assert_outlined(arena.get_node("Floor/Mesh"), false)
	_assert_outlined(arena.get_node("Canyon/SandTiles"), false)
	_assert_outlined(arena.get_node("Canyon/Outside"), false)
	var patches: Array[Node] = arena.get_node("Canyon").find_children(
		"BushGround*", "", false, false
	)
	assert_eq(patches.size(), ArenaLayout.BUSHES.size())
	for patch: MeshInstance3D in patches:
		_assert_outlined(patch, false)
