extends GutTest

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const STAGE_SCENE: PackedScene = preload("res://scenes/ui/fighter_stage.tscn")
## The parts that make each fighter's idea of S11 recognisable.
const IDEA_PARTS: Dictionary = {
	"blaze": ["FlameHair", "Fireball"],
	"rocko": ["RockBlocks"],
	"turbo": ["Helmet", "Visor"],
	"frosty": ["Fur", "Horns"],
	"luna": ["Ears", "Tail", "RayGun"],
	"pixel": ["ScreenFace", "Antenna"],
}


func _model(fighter_id: String) -> FighterModel:
	var model: FighterModel = MODEL_SCENE.instantiate()
	add_child_autofree(model)
	model.setup(fighter_id)
	return model


func _meshes(node: Node) -> int:
	var count: int = 1 if node is MeshInstance3D else 0
	for child: Node in node.get_children():
		count += _meshes(child)
	return count


func _distance(a: Color, b: Color) -> float:
	return Vector3(a.r - b.r, a.g - b.g, a.b - b.b).length()


func test_every_fighter_and_skin_builds() -> void:
	var built: int = 0
	for fighter: Dictionary in Fighters.LIST:
		for skin: Dictionary in fighter["skins"]:
			var model: FighterModel = _model(fighter["id"])
			model.setup(fighter["id"], skin["id"])
			assert_eq(model.fighter_id, fighter["id"])
			assert_eq(model.skin_id, skin["id"], "%s has its own look" % skin["name"])
			assert_gt(_meshes(model), 10, "%s %s is built" % [fighter["name"], skin["name"]])
			built += 1
	assert_eq(built, 14, "all 14 combinations")


func test_a_skin_changes_the_main_colour() -> void:
	for fighter: Dictionary in Fighters.LIST:
		var default_color: Color = _model(fighter["id"]).main_color
		for skin: Dictionary in fighter["skins"]:
			if skin["id"] == Fighters.DEFAULT_SKIN:
				continue
			var model: FighterModel = _model(fighter["id"])
			model.setup(fighter["id"], skin["id"])
			assert_gt(
				_distance(model.main_color, default_color),
				0.1,
				"%s differs from %s's Default" % [skin["name"], fighter["name"]]
			)


func test_only_legendary_skins_glow() -> void:
	for fighter: Dictionary in Fighters.LIST:
		for skin: Dictionary in fighter["skins"]:
			var model: FighterModel = _model(fighter["id"])
			model.setup(fighter["id"], skin["id"])
			var legendary: bool = skin["rarity"] == "Legendary"
			var halo: Node = model.find_child("LegendaryHalo", true, false)
			var sparkles: Node = model.find_child("Sparkles", true, false)
			var label: String = "%s %s" % [fighter["name"], skin["name"]]
			assert_eq(halo != null, legendary, "%s: halo only when Legendary" % label)
			assert_eq(
				sparkles is CPUParticles3D, legendary, "%s: sparkles only when Legendary" % label
			)
			if legendary:
				assert_true((sparkles as CPUParticles3D).emitting, "%s sparkles" % label)


func test_every_fighter_builds_with_the_parts_of_its_idea() -> void:
	assert_eq(IDEA_PARTS.keys(), Fighters.ids(), "every fighter is checked")
	for fighter_id: String in Fighters.ids():
		var model: FighterModel = _model(fighter_id)
		assert_eq(model.fighter_id, fighter_id)
		assert_eq(model.skin_id, Fighters.DEFAULT_SKIN)
		assert_gt(_meshes(model), 10, "%s is built from many parts" % fighter_id)
		for part_name: String in IDEA_PARTS[fighter_id]:
			var part: Node = model.find_child(part_name, true, false)
			assert_not_null(part, "%s has %s" % [fighter_id, part_name])


func test_no_two_fighters_share_a_main_colour() -> void:
	var colors: Array[Color] = []
	for fighter_id: String in Fighters.ids():
		colors.append(_model(fighter_id).main_color)
	for first: int in colors.size():
		for second: int in range(first + 1, colors.size()):
			assert_gt(
				_distance(colors[first], colors[second]),
				0.1,
				"%s and %s differ" % [Fighters.ids()[first], Fighters.ids()[second]]
			)


func test_setup_again_replaces_the_fighter() -> void:
	var model: FighterModel = _model("pixel")
	model.setup("luna")
	assert_not_null(model.find_child("RayGun", true, false))
	assert_null(model.find_child("Antenna", true, false), "Pixel's parts are gone")
	assert_eq(model.get_children().size(), 1, "one rig")


func test_unknown_ids_fall_back_to_blaze_and_default() -> void:
	var model: FighterModel = _model("nobody")
	assert_eq(model.fighter_id, "blaze")
	model.setup("rocko", "no_such_skin")
	assert_eq(model.skin_id, Fighters.DEFAULT_SKIN)


func test_idle_animation_moves_the_model() -> void:
	var model: FighterModel = _model("blaze")
	var body: Node3D = model.find_child("Body", true, false)
	var before: Transform3D = body.transform
	await wait_process_frames(10)
	assert_ne(body.transform, before, "the body breathes and sways")


func test_idle_animation_can_be_switched_off_for_pictures() -> void:
	var model: FighterModel = _model("blaze")
	model.idle_enabled = false
	var body: Node3D = model.find_child("Body", true, false)
	var before: Transform3D = body.transform
	await wait_process_frames(10)
	assert_eq(body.transform, before, "the body stays still")


func test_running_leans_the_rig_forward_and_bounces_the_body() -> void:
	var model: FighterModel = _model("blaze")
	model.idle_enabled = false
	var rig: Node3D = model.get_node("Rig")
	var body: Node3D = model.find_child("Body", true, false)
	model.animate(0.1)
	assert_eq(rig.rotation.x, 0.0, "idle leaves the rig straight")
	model.running = true
	var heights: Array[float] = []
	for step: int in 8:
		model.animate(step * 0.05)
		heights.append(body.position.y)
		assert_gt(rig.rotation.x, 0.1, "the rig leans forward (+z is the front)")
		assert_gte(body.position.y, 0.0, "the body only bounces up")
	assert_gt(heights.max(), 0.05, "the body bounces")
	assert_gt(heights.max() - heights.min(), 0.05, "the height changes with the steps")
	model.running = false
	model.animate(0.1)
	assert_eq(rig.rotation.x, 0.0, "stopping straightens the rig")


func test_play_attack_kicks_the_body_back_and_ends_after_a_quarter_second() -> void:
	var model: FighterModel = _model("frosty")
	model.idle_enabled = false
	var body: Node3D = model.find_child("Body", true, false)
	assert_eq(model.attack_left, 0.0)
	model.play_attack()
	assert_almost_eq(model.attack_left, FighterModel.ATTACK_SECONDS, 0.001)
	model._process(FighterModel.ATTACK_SECONDS / 2.0)
	model.animate(0.0)
	assert_lt(body.position.z, -0.05, "the body kicks back at the middle")
	assert_lt(body.scale.y, 0.95, "and squashes")
	model._process(0.3)
	model.animate(0.0)
	assert_eq(model.attack_left, 0.0, "the recoil is over after 0.3 s")
	assert_eq(body.position.z, 0.0, "the body is back")
	assert_eq(body.scale, Vector3.ONE, "and its shape too")


func test_stage_shows_the_fighter_and_keeps_it_in_view() -> void:
	var stage: FighterStage = STAGE_SCENE.instantiate()
	stage.size = Vector2(300, 600)
	add_child_autofree(stage)
	stage.show_fighter("frosty")
	assert_eq(stage.model.fighter_id, "frosty")
	assert_eq(stage.camera.keep_aspect, Camera3D.KEEP_WIDTH, "a tall stage keeps the width")
	stage.size = Vector2(600, 300)
	await wait_process_frames(1)
	assert_eq(stage.camera.keep_aspect, Camera3D.KEEP_HEIGHT, "a wide stage keeps the height")
	for point: Vector3 in [Vector3(-1.2, 0.0, 0.0), Vector3(1.2, 2.8, 0.0)]:
		assert_false(stage.camera.is_position_behind(point))
		var on_screen: Vector2 = stage.camera.unproject_position(point)
		var view: Rect2 = Rect2(Vector2.ZERO, Vector2(stage.get_node("Viewport").size))
		assert_true(view.has_point(on_screen), "%s is in view" % point)


func _all_meshes(node: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	for child: Node in node.get_children():
		if child is MeshInstance3D:
			found.append(child)
		found.append_array(_all_meshes(child))
	return found


func test_every_fighter_and_skin_is_cel_shaded_with_the_shared_outline() -> void:
	for fighter: Dictionary in Fighters.LIST:
		for skin: Dictionary in fighter["skins"]:
			var model: FighterModel = _model(fighter["id"])
			model.setup(fighter["id"], skin["id"])
			var label: String = "%s %s" % [fighter["name"], skin["name"]]
			var outlined: int = 0
			for mesh: MeshInstance3D in _all_meshes(model):
				var material: Material = mesh.material_override
				if material is StandardMaterial3D:
					assert_ne(
						(material as StandardMaterial3D).diffuse_mode,
						BaseMaterial3D.DIFFUSE_TOON,
						"%s %s: toon parts use the toon shader" % [label, mesh.name]
					)
				elif ToonMaterials.is_toon(material) and material.next_pass != null:
					assert_eq(material.next_pass, ToonMaterials.outline(), label)
					outlined += 1
			assert_gte(outlined, 8, "%s: the body parts are outlined" % label)


func test_fighters_share_their_materials() -> void:
	var first: FighterModel = _model("blaze")
	var second: FighterModel = _model("blaze")
	var first_parts: Array[MeshInstance3D] = _all_meshes(first)
	var second_parts: Array[MeshInstance3D] = _all_meshes(second)
	assert_eq(first_parts.size(), second_parts.size())
	var shared: int = 0
	for index: int in first_parts.size():
		if first_parts[index].material_override == second_parts[index].material_override:
			shared += 1
	assert_gte(shared, 8, "one material per colour, not per fighter")


func test_dark_eyes_have_a_white_large_enough_for_a_card() -> void:
	for fighter_id: String in ["blaze", "turbo", "frosty", "luna"]:
		var model: FighterModel = _model(fighter_id)
		var whites: Array[Node] = model.find_children("*EyeWhite", "MeshInstance3D", true, false)
		var pupils: Array[Node] = model.find_children("*Pupil", "MeshInstance3D", true, false)
		assert_eq(whites.size(), 2, "%s has two eye whites" % fighter_id)
		assert_eq(pupils.size(), 2, "%s has two pupils" % fighter_id)
		if whites.size() == 2 and pupils.size() == 2:
			var white: MeshInstance3D = whites[0]
			var pupil: MeshInstance3D = pupils[0]
			assert_gt(white.get_aabb().size.x, pupil.get_aabb().size.x, "the white shows around")
			assert_gt(pupil.position.z, white.position.z, "the pupil is in front")
	var glowing: FighterModel = _model("rocko")
	assert_null(glowing.find_child("*EyeWhite", true, false), "Rocko's yellow eyes glow alone")


func test_see_through_copies_are_transparent_and_keep_a_faded_outline() -> void:
	var toon: ShaderMaterial = ToonMaterials.toon(Color("e8322b"))
	var faded: StandardMaterial3D = ToonMaterials.see_through(toon)
	assert_eq(faded.transparency, BaseMaterial3D.TRANSPARENCY_ALPHA)
	assert_almost_eq(faded.albedo_color.a, FighterModel.SEE_THROUGH_ALPHA, 0.001)
	assert_not_null(faded.next_pass, "the outline fades too")
	assert_eq(ToonMaterials.see_through(toon), faded, "one copy per material")
