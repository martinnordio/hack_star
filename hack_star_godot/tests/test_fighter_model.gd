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
			var a: Color = colors[first]
			var b: Color = colors[second]
			var distance: float = Vector3(a.r - b.r, a.g - b.g, a.b - b.b).length()
			assert_gt(
				distance, 0.1, "%s and %s differ" % [Fighters.ids()[first], Fighters.ids()[second]]
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
