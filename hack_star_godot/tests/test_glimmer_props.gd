extends GutTest
## The Glimmer Isles props (spec 09, W3, D13): own art from primitive meshes in the outlined
## cartoon look, ready right after `instantiate()` (what ProtonScatter and the bake read).

const PROPS: String = "res://scenes/worlds/glimmer_isles/props/"


func test_every_prop_scene_has_outlined_toon_parts_without_scale() -> void:
	for kind: String in GlimmerProp.KINDS:
		var prop: GlimmerProp = autofree(
			(load(PROPS + kind + ".tscn") as PackedScene).instantiate()
		)
		assert_eq(prop.kind, kind)
		var parts: Array[MeshInstance3D] = prop.parts()
		assert_gte(parts.size(), 2, "%s has parts before it enters the tree" % kind)
		assert_eq(parts.size(), prop.get_child_count(), "%s: only parts, all direct" % kind)
		for part: MeshInstance3D in parts:
			var label: String = "%s/%s" % [kind, part.name]
			assert_true(part.mesh is PrimitiveMesh, "%s is a primitive mesh" % label)
			assert_true(ToonMaterials.is_toon(part.material_override), "%s is cel-shaded" % label)
			assert_not_null(part.material_override.next_pass, "%s is outlined" % label)
			assert_eq(part.scale, Vector3.ONE, "%s is placed without scale" % label)


func test_changing_the_kind_rebuilds_the_parts() -> void:
	var prop: GlimmerProp = autofree(GlimmerProp.new())
	prop.kind = "small_mushroom"
	assert_eq(prop.parts().size(), 2)
	prop.kind = "glow_fern"
	assert_eq(prop.get_child_count(), prop.parts().size())
	assert_true(prop.has_node("Frond"), "the fern's parts")
	assert_false(prop.has_node("Cap"), "the mushroom's are gone")
