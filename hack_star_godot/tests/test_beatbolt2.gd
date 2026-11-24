extends GutTest
## Beatbolt2, a 3D Echo built from shapes (spec 09, part E, D53, D55): his data, unlocked from
## the start and in old saves, his row in `DrawnFighters`, the parts that make Echo recognisable,
## only shapes with the toon look and the outline, his rendered picture on the cards, and he plays
## in Training and a match.

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const LOOK_FILE: GDScript = preload("res://scenes/drawn/beatbolt2_model.gd")
const LIST: PackedScene = preload("res://scenes/fighter_list.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TEST_SAVE: String = "user://test/beatbolt2_save.json"
const ID: String = "beatbolt2"

var _previous: Node
var _placeholder: Node


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	if _placeholder != null:
		get_tree().current_scene = _previous
		_placeholder.queue_free()
		_placeholder = null
		_previous = null
		await wait_process_frames(1)
	GameState.reset()


func _model() -> FighterModel:
	var model: FighterModel = MODEL_SCENE.instantiate()
	add_child_autofree(model)
	model.setup(ID)
	return model


func _meshes(model: FighterModel) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	for node: Node in model.find_children("*", "MeshInstance3D", true, false):
		if node.name != "Shadow":
			found.append(node)
	return found


func test_beatbolt2_is_an_unlocked_mythic_fighter_after_magmax_playing_like_luna() -> void:
	var fighter: Dictionary = Fighters.get_fighter(ID)
	assert_eq(
		[fighter["name"], fighter["rarity"], fighter["plays_like"]], ["Beatbolt2", "Mythic", "luna"]
	)
	assert_true(fighter["unlocked"] and fighter["drawn"])
	assert_false(fighter.get("cutout", false), "built from shapes, not a picture")
	assert_eq(fighter["skins"], [{"id": "default", "name": "Default", "rarity": ""}])
	assert_eq(Fighters.ids()[Fighters.ids().find("magmax") + 1], ID, "after MagMax")
	assert_true(GameState.is_unlocked(ID))
	assert_eq(SampleProgress.TROPHIES[ID], 0)
	assert_eq(SampleProgress.POWER_LEVELS[ID], 1)


func test_an_old_save_gets_beatbolt2_unlocked() -> void:
	var player_save: String = GameState.save_path
	GameState.save_path = TEST_SAVE
	var progress: Dictionary = {"unlocked": ["blaze", "rocko"], "credits": 9}
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string(JSON.stringify({"version": 2, "hacks": [], "progress": progress}))
	file.close()
	GameState.load_saved()
	GameState.save_path = player_save
	DirAccess.remove_absolute(TEST_SAVE)
	assert_eq(GameState.credits, 9, "the old save is read")
	assert_true(GameState.is_unlocked(ID))


func test_his_look_is_its_own_file_and_beatbolt_keeps_his() -> void:
	assert_true(DrawnFighters.has(ID))
	assert_eq(DrawnFighters.MODELS[ID], LOOK_FILE)
	assert_eq(DrawnFighters.MODELS["beatbolt"], load("res://scenes/drawn/beatbolt_model.gd"))
	assert_eq(DrawnFighters.looks(ID)["default"]["main"], Color("07f6f8"), "Echo's glowing teal")
	assert_eq(
		DrawnFighters.idea_parts(ID),
		["SpikyHair", "MagentaLock", "Headphones", "ShoulderPads", "ArmCannon", "NeonSoles"]
	)


func test_he_is_built_with_the_parts_of_echo() -> void:
	var model: FighterModel = _model()
	assert_eq(model.fighter_id, ID, "not the Blaze fallback")
	for part_name: String in DrawnFighters.idea_parts(ID):
		var part: Node = model.find_child(part_name, true, false)
		assert_not_null(part, "has %s" % part_name)
		if part != null:
			assert_gt(part.find_children("*", "MeshInstance3D", true, false).size(), 0, part_name)
	var meshes: Array[MeshInstance3D] = _meshes(model)
	assert_between(
		meshes.size(), 30, 50, "his shapes drawn as one mesh per material and group (E7)"
	)
	for mesh: MeshInstance3D in meshes:
		var material: ShaderMaterial = mesh.material_override as ShaderMaterial
		var glows: bool = (
			material != null and material.get_shader_parameter("emission_energy") > 0.0
		)
		if material == null or material.next_pass == null or glows:
			assert_eq(
				mesh.cast_shadow,
				GeometryInstance3D.SHADOW_CASTING_SETTING_OFF,
				"%s: flat details and lights cast no shadow" % mesh.name
			)


func test_he_is_only_shapes_in_the_toon_look_with_the_outline() -> void:
	var outlined: int = 0
	for mesh: MeshInstance3D in _meshes(_model()):
		var shapes: bool = mesh.mesh is PrimitiveMesh or mesh.mesh is ArrayMesh
		assert_true(shapes, "%s is a shape or shapes joined in code" % mesh.name)
		var material: Material = mesh.material_override
		if material is StandardMaterial3D:
			var shine: StandardMaterial3D = material
			assert_eq(shine.shading_mode, BaseMaterial3D.SHADING_MODE_UNSHADED, "an eye's shine")
			assert_null(shine.albedo_texture, "%s has no picture" % mesh.name)
			continue
		assert_true(ToonMaterials.is_toon(material), "%s is cel-shaded" % mesh.name)
		if material is ShaderMaterial:
			var shader: ShaderMaterial = material
			for uniform: Dictionary in shader.shader.get_shader_uniform_list():
				var value: Variant = shader.get_shader_parameter(uniform["name"])
				assert_false(value is Texture2D, "%s has no picture" % mesh.name)
			if shader.next_pass != null:
				assert_eq(shader.next_pass, ToonMaterials.outline(), mesh.name)
				outlined += 1
	assert_gte(outlined, 20, "the body, the hair and the headphones are outlined")


func test_his_rendered_picture_is_on_his_card() -> void:
	assert_false(CutoutFighters.has(ID), "no card picture of Echo: rendered like a shape fighter")
	var texture: ImageTexture = ImageTexture.create_from_image(
		Image.create(4, 4, false, Image.FORMAT_RGBA8)
	)
	GameState.pictures[FighterPictures.key(ID, Fighters.DEFAULT_SKIN)] = texture
	assert_eq(FighterPictures.cached(ID), texture)
	var screen: Control = autofree(LIST.instantiate())
	add_child(screen)
	var found: FighterCard = null
	for card: Node in screen.get_node("Margin/Column/Scroll/Grid").get_children():
		if card is FighterCard and (card as FighterCard).fighter_id == ID:
			found = card
	assert_not_null(found, "his card is on the list")
	if found != null:
		assert_eq(found.get_node("Column/Backdrop/Picture").texture, texture)
		assert_eq(found.get_node("Column/NameLabel").text, "Beatbolt2")


func test_beatbolt2_plays_in_training() -> void:
	assert_true(GameState.select(ID, Fighters.DEFAULT_SKIN))
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var fighter: Fighter = arena.get_node("Fighter")
	assert_eq(fighter.model.fighter_id, ID)
	assert_null(fighter.model.get_cutout(), "a fighter of shapes")
	arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	var start: Vector3 = fighter.global_position
	await wait_physics_frames(5)
	assert_gt(fighter.global_position.x, start.x, "moves")
	assert_true(fighter.model.running, "runs")
	assert_true(arena.fire(Vector2.UP), "shoots")


func test_beatbolt2_plays_in_a_match() -> void:
	GameState.select(ID, Fighters.DEFAULT_SKIN)
	GameState.match_settings.countdown_seconds = 0
	_previous = get_tree().current_scene
	_placeholder = Node.new()
	get_tree().root.add_child(_placeholder)
	get_tree().current_scene = _placeholder
	var arena: MatchArena = MATCH_SCENE.instantiate()
	arena.read_player_input = false
	_placeholder.add_child(arena)
	await wait_process_frames(2)
	var player: Fighter = arena.get_node("Fighter")
	assert_eq(player.model.fighter_id, ID)
	assert_eq(arena.fighters.size(), MatchSettings.BOT_COUNT + 1, "against the bots")
	assert_true(arena.fire(Vector2.UP), "shoots")


func _muzzle_at(model: FighterModel) -> Vector3:
	var muzzle: Node3D = model.find_child("Muzzle", true, false)
	return model.to_local(muzzle.global_position)


func test_a_shot_raises_the_arm_cannon_forwards_and_lowers_it_again() -> void:
	var model: FighterModel = _model()
	model.idle_enabled = false
	model.animate(0.0)
	var resting: Vector3 = _muzzle_at(model)
	assert_lt(resting.y, 0.5, "the cannon hangs down beside him")
	model.play_attack()
	model._process(FighterModel.ATTACK_SECONDS / 2.0)
	model.animate(0.0)
	var raised: Vector3 = _muzzle_at(model)
	assert_gt(raised.z, resting.z + 0.5, "it points forwards, where he faces")
	assert_gt(raised.y, 0.9, "at the shoulder's height")
	var left_leg: Node3D = model.find_child("LeftLeg", true, false)
	var right_leg: Node3D = model.find_child("RightLeg", true, false)
	assert_lt(left_leg.rotation.x, -0.2, "a wide stance: the left foot forwards")
	assert_gt(right_leg.rotation.x, 0.2, "the right foot back")
	model._process(FighterModel.ATTACK_SECONDS)
	model.animate(0.0)
	assert_almost_eq(_muzzle_at(model), resting, Vector3.ONE * 0.01, "and down again")
	assert_almost_eq(left_leg.rotation.x, 0.0, 0.001)


func test_walking_he_strides_upright_with_the_arms_swinging() -> void:
	var model: FighterModel = _model()
	model.idle_enabled = false
	model.running = true
	var left_leg: Node3D = model.find_child("LeftLeg", true, false)
	var right_leg: Node3D = model.find_child("RightLeg", true, false)
	var glove_arm: Node3D = model.find_child("GloveArm", true, false)
	var quarter: float = PI / 2.0 / LOOK_FILE.STRIDE_SPEED
	for step: float in [1.0, -1.0]:
		model.animate(quarter * (2.0 - step))
		assert_almost_eq(left_leg.rotation.x, step * LOOK_FILE.STRIDE_ANGLE, 0.01, "left leg")
		assert_almost_eq(right_leg.rotation.x, -step * LOOK_FILE.STRIDE_ANGLE, 0.01, "right leg")
		assert_lt(glove_arm.rotation.x * step, -0.2, "the free arm swings against the left leg")
	assert_lt(model.get_rig().rotation.x, 0.1, "upright, as Echo walks")
	model.running = false
	model.animate(0.0)
	assert_eq(left_leg.rotation, Vector3.ZERO, "standing: the legs together")


func test_in_play_he_turns_see_through_is_hit_and_knocked_out_as_a_fighter_of_shapes() -> void:
	assert_true(GameState.select(ID, Fighters.DEFAULT_SKIN))
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	arena.read_player_input = false
	var fighter: Fighter = arena.get_node("Fighter")
	fighter.model.set_see_through(true)
	for mesh: MeshInstance3D in _meshes(fighter.model):
		var material: Material = mesh.material_override
		assert_true(material is BaseMaterial3D, "%s is see-through" % mesh.name)
		if material is BaseMaterial3D:
			assert_eq((material as BaseMaterial3D).transparency, BaseMaterial3D.TRANSPARENCY_ALPHA)
	fighter.model.set_see_through(false)
	var health: float = fighter.health
	fighter.hit(10)
	assert_eq(fighter.health, health - 10.0, "hit")
	fighter.hit(int(fighter.health))
	assert_true(fighter.knocked_out)
	assert_false(fighter.model.knock_out_pose(0.5), "spins and shrinks as a fighter of shapes")
	await wait_seconds(Fighter.KNOCK_OUT_SECONDS + 0.2)
	assert_lt(fighter.model.scale.x, 0.2, "shrunk")
	assert_false(fighter.visible, "gone")
