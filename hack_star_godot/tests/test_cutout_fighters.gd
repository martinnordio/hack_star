extends GutTest
## The picture fighters Flarekid and Echo (spec 09, part C, D20, D21, D30): their data, their card
## picture, the outlined cut-out model and its see-through in cover; both can be chosen and
## played; in play they look where they run, hop, flash at a shot and a hit, and tip over at a
## knock-out (C5, D24). The reveal and the idle are in `test_fighter_reveal.gd`.

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter.tscn")
const HOME: PackedScene = preload("res://scenes/home.tscn")
const LIST: PackedScene = preload("res://scenes/fighter_list.tscn")
const FIGHTER_SCREEN: PackedScene = preload("res://scenes/fighter_screen.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TEST_SAVE: String = "user://test/cutout_fighter_save.json"
## id, name, rarity, plays like, the delivered card picture (D20, C2).
const EXPECTED: Array[Array] = [
	["flarekid", "Flarekid", "Legendary", "blaze", "res://characters/blaze2/blaze_card.png"],
	["echo", "Echo", "Mythic", "luna", "res://characters/echo/echo_card.png"],
]

var _previous: Node
## The node that holds the match while it is the current scene; freed after the test.
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


func _model(fighter_id: String) -> FighterModel:
	var model: FighterModel = MODEL_SCENE.instantiate()
	add_child_autofree(model)
	model.setup(fighter_id)
	return model


func _material(model: FighterModel) -> ShaderMaterial:
	return model.get_cutout().material_override as ShaderMaterial


func test_both_are_unlocked_fighters_with_one_default_skin() -> void:
	for expected: Array in EXPECTED:
		var fighter: Dictionary = Fighters.get_fighter(expected[0])
		assert_eq(
			[fighter["name"], fighter["rarity"], fighter["plays_like"]],
			[expected[1], expected[2], expected[3]]
		)
		assert_true(fighter["unlocked"] and fighter["cutout"], expected[0])
		assert_false(fighter.get("drawn", false), "a picture, not a drawn fighter")
		assert_eq(fighter["skins"], [{"id": "default", "name": "Default", "rarity": ""}])
		assert_true(GameState.is_unlocked(expected[0]))
		assert_eq(SampleProgress.TROPHIES[expected[0]], 0, "a new fighter starts at 0")
		assert_eq(SampleProgress.POWER_LEVELS[expected[0]], 1)
		assert_true(CutoutFighters.has(expected[0]))
		assert_false(FighterModel.LOOKS.has(expected[0]) or DrawnFighters.has(expected[0]))
	for fighter_id: String in CutoutFighters.FIGHTERS:
		assert_true(Fighters.get_fighter(fighter_id).get("cutout", false), fighter_id)


func test_an_old_save_gets_them_unlocked() -> void:
	var player_save: String = GameState.save_path
	GameState.save_path = TEST_SAVE
	var progress: Dictionary = {"unlocked": ["blaze", "rocko", "turbo"], "credits": 10}
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string(JSON.stringify({"version": 2, "hacks": [], "progress": progress}))
	file.close()
	GameState.load_saved()
	GameState.save_path = player_save
	DirAccess.remove_absolute(TEST_SAVE)
	assert_eq(GameState.credits, 10, "the old save is read")
	for expected: Array in EXPECTED:
		assert_true(GameState.is_unlocked(expected[0]), expected[0])


func test_the_card_picture_is_the_delivered_card_on_the_card_and_the_skin_button() -> void:
	for expected: Array in EXPECTED:
		var card: Texture2D = load(expected[4])
		assert_eq(FighterPictures.cached_skin(expected[0], Fighters.DEFAULT_SKIN), card)
		assert_eq(FighterPictures.cached(expected[0]), card)
	var screen: Control = autofree(LIST.instantiate())
	add_child(screen)
	var fighter_card: FighterCard = screen.get_node("Margin/Column/Scroll/Grid/Echo")
	assert_eq(fighter_card.get_node("Column/Backdrop/Picture").texture, load(EXPECTED[1][4]))
	GameState.viewed_fighter = "flarekid"
	var fighter_screen: Control = autofree(FIGHTER_SCREEN.instantiate())
	add_child(fighter_screen)
	var skin_row: Node = fighter_screen.get_node("Margin/Column/Body/Details/SkinRow")
	assert_eq(skin_row.get_child_count(), 1, "one Default skin")
	assert_eq((skin_row.get_child(0) as SkinButton).icon, load(EXPECTED[0][4]))


func test_the_model_is_one_outlined_picture_quad_standing_on_its_feet() -> void:
	for expected: Array in EXPECTED:
		var model: FighterModel = _model(expected[0])
		assert_eq(model.fighter_id, expected[0], "not the Blaze fallback")
		var quad: MeshInstance3D = model.get_cutout()
		assert_not_null(quad, expected[0])
		assert_eq(quad.get_parent(), model.get_body(), "moves with the body")
		var material: ShaderMaterial = _material(model)
		assert_eq(material.shader, CutoutFighters.SHADER)
		var hero: Texture2D = CutoutFighters.FIGHTERS[expected[0]]["hero"]
		assert_eq(material.get_shader_parameter("picture"), hero)
		assert_eq(material.get_shader_parameter("width_px"), ToonMaterials.OUTLINE_PIXELS)
		assert_eq(material.get_shader_parameter("outline_color"), ToonMaterials.OUTLINE_COLOR)
		var box: AABB = quad.get_aabb()
		var height: float = CutoutFighters.FIGHTERS[expected[0]]["height"]
		var feet_y: float = CutoutFighters.FIGHTERS[expected[0]]["feet"].y
		var below_feet: float = (1.0 + CutoutFighters.PAD - feet_y) * height
		assert_almost_eq(box.position.y, -below_feet, 0.001, "%s: the feet at 0" % expected[0])
		assert_lt(below_feet, 0.3, "%s: only the outline's room under the feet" % expected[0])
		assert_between(box.end.y, height, height + 0.2, "%s: as tall as planned" % expected[0])
		assert_eq(quad.cast_shadow, GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)
		var shadow: MeshInstance3D = model.get_rig().get_node("Shadow")
		assert_true(shadow.mesh is PlaneMesh, "a soft shadow on the ground")
		var shadow_material: StandardMaterial3D = shadow.material_override
		assert_true(shadow_material.albedo_texture is GradientTexture2D)
	assert_null(_model("blaze").get_cutout(), "shape fighters have no picture quad")


func test_each_picture_fighter_has_its_own_material_and_main_colour() -> void:
	var flarekid: FighterModel = _model("flarekid")
	var second: FighterModel = _model("flarekid")
	assert_ne(_material(flarekid), _material(second), "flash and fade per fighter")
	assert_ne(flarekid.main_color, _model("echo").main_color)


func test_in_cover_the_picture_fades_and_comes_back() -> void:
	for expected: Array in EXPECTED:
		var model: FighterModel = _model(expected[0])
		var material: ShaderMaterial = _material(model)
		assert_eq(material.get_shader_parameter("fade"), 1.0)
		model.set_see_through(true)
		assert_eq(_material(model), material, "the same material, faded")
		assert_eq(material.get_shader_parameter("fade"), FighterModel.SEE_THROUGH_ALPHA)
		var shadow: MeshInstance3D = model.get_rig().get_node("Shadow")
		var faded: StandardMaterial3D = shadow.material_override
		assert_eq(faded.transparency, BaseMaterial3D.TRANSPARENCY_ALPHA)
		model.set_see_through(false)
		assert_eq(material.get_shader_parameter("fade"), 1.0)


func test_both_can_be_chosen_and_stand_on_home() -> void:
	for expected: Array in EXPECTED:
		assert_true(GameState.select(expected[0], Fighters.DEFAULT_SKIN))
		var screen: Control = autofree(HOME.instantiate())
		add_child(screen)
		var model: FighterModel = screen.get_node("Margin/Column/Body/FighterStage").model
		assert_eq(model.fighter_id, expected[0])
		assert_not_null(model.get_cutout())
		var name_label: Label = screen.get_node("Margin/Column/Body/Controls/NameRow/NameLabel")
		assert_eq(name_label.text, expected[1])
		screen.free()


func test_both_play_in_training() -> void:
	for expected: Array in EXPECTED:
		GameState.select(expected[0], Fighters.DEFAULT_SKIN)
		var arena: Node3D = ARENA_SCENE.instantiate()
		add_child_autofree(arena)
		var fighter: Fighter = arena.get_node("Fighter")
		var model: FighterModel = fighter.get_node("Model")
		assert_eq(model.fighter_id, expected[0])
		arena.read_player_input = false
		fighter.input_direction = Vector2.RIGHT
		var start: Vector3 = fighter.global_position
		await wait_physics_frames(5)
		assert_true(model.running, "%s runs" % expected[0])
		assert_gt(fighter.global_position.x, start.x, "%s moves" % expected[0])
		assert_true(arena.fire(Vector2.UP), "%s shoots" % expected[0])
		arena.free()


func test_echo_plays_in_a_match_with_the_health_bar_over_the_picture() -> void:
	GameState.select("echo", Fighters.DEFAULT_SKIN)
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
	assert_eq((player.get_node("Model") as FighterModel).fighter_id, "echo")
	assert_eq(arena.fighters.size(), MatchSettings.BOT_COUNT + 1, "against the bots")
	var camera: Transform3D = player.get_viewport().get_camera_3d().global_transform
	var picture_top: float = player.model.picture_top(camera)
	assert_gt(picture_top, CutoutFighters.FIGHTERS["echo"]["height"], "the camera looks down")
	assert_gt(player.health_bar().position.y, picture_top, "the bar over the picture")


func _fighter(fighter_id: String) -> Fighter:
	var fighter: Fighter = FIGHTER_SCENE.instantiate()
	add_child_autofree(fighter)
	fighter.set_look(fighter_id, Fighters.DEFAULT_SKIN)
	return fighter


func test_the_picture_looks_where_it_runs_and_keeps_it_going_up_or_down() -> void:
	# Flarekid is drawn looking right, Echo looking left: mirrored only when looking the other way.
	for row: Array in [["flarekid", false], ["echo", true]]:
		var fighter: Fighter = _fighter(row[0])
		var material: ShaderMaterial = _material(fighter.model)
		for step: Array in [[Vector2.LEFT, true], [Vector2.UP, true], [Vector2.RIGHT, false]]:
			fighter.input_direction = step[0]
			await wait_physics_frames(2)
			assert_eq(fighter.model.facing_left, step[1], "%s %s" % [row[0], step[0]])
			var mirrored: bool = step[1] != row[1]
			assert_eq(material.get_shader_parameter("flip"), mirrored, "%s flip" % row[0])
		fighter.input_direction = Vector2(-0.05, 1.0)
		await wait_physics_frames(2)
		assert_false(fighter.model.facing_left, "%s: almost straight down keeps it" % row[0])
		fighter.model.setup(row[0])
		assert_eq(material.get_shader_parameter("flip"), row[1], "kept after a rebuild")


func test_running_hops_squashes_on_landing_and_leans_where_it_looks() -> void:
	var model: FighterModel = _model("echo")
	model.idle_enabled = false
	model.running = true
	var material: ShaderMaterial = _material(model)
	var heights: Array[float] = []
	for step: int in 60:
		model.animate(step * 0.013)
		heights.append(model.get_body().position.y)
	assert_almost_eq(heights.min(), 0.0, 0.01, "lands on its feet")
	assert_almost_eq(heights.max(), CutoutMotion.HOP_HEIGHT, 0.01, "hops")
	model.animate(0.0)
	assert_almost_eq(model.get_body().scale.y, CutoutMotion.LAND_SQUASH.y, 0.001)
	assert_almost_eq(model.get_body().scale.x, CutoutMotion.LAND_SQUASH.x, 0.001)
	model.animate(PI / 2.0 / CutoutMotion.HOP_SPEED)
	assert_eq(model.get_body().scale, Vector3.ONE, "stretched back in the air")
	assert_almost_eq(material.get_shader_parameter("tilt"), -CutoutMotion.LEAN_ANGLE, 0.001)
	model.facing_left = true
	model.animate(0.1)
	assert_almost_eq(material.get_shader_parameter("tilt"), CutoutMotion.LEAN_ANGLE, 0.001)


func test_a_hit_flashes_the_picture_white_for_a_moment() -> void:
	var fighter: Fighter = _fighter("flarekid")
	var material: ShaderMaterial = _material(fighter.model)
	assert_true(material.get_shader_parameter("flash") in [null, 0.0], "not white yet")
	fighter.hit(10)
	assert_eq(material.get_shader_parameter("flash"), 1.0, "white")
	assert_lte(CutoutMotion.FLASH_SECONDS, 0.2, "short")
	await wait_seconds(CutoutMotion.FLASH_SECONDS + 0.1)
	assert_eq(material.get_shader_parameter("flash"), 0.0, "back to its colours")
	var shapes: Fighter = _fighter("blaze")
	shapes.hit(10)
	assert_null(shapes.model.get_cutout(), "fighters of shapes keep their look")


func test_a_shot_shows_a_star_at_the_muzzle_on_the_side_it_looks() -> void:
	GameState.select("flarekid", Fighters.DEFAULT_SKIN)
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	arena.read_player_input = false
	await wait_process_frames(2)
	var fighter: Fighter = arena.get_node("Fighter")
	var camera: Camera3D = fighter.get_viewport().get_camera_3d()
	for aim: Vector2 in [Vector2.RIGHT, Vector2.LEFT]:
		fighter.last_fire_seconds = -INF
		assert_true(arena.fire(aim))
		var star: MeshInstance3D = fighter.model.get_muzzle_flash()
		assert_not_null(star)
		assert_true(star.visible, "a star at the shot")
		var star_x: float = camera.unproject_position(star.global_position).x
		var fighter_x: float = camera.unproject_position(fighter.global_position).x
		if aim == Vector2.RIGHT:
			assert_gt(star_x, fighter_x, "on the right of the picture")
		else:
			assert_lt(star_x, fighter_x, "mirrored: on the left")
		await wait_seconds(CutoutMotion.MUZZLE_FLASH_SECONDS + 0.1)
		assert_false(star.visible, "only a moment")
	var shapes: FighterModel = _model("blaze")
	shapes.muzzle_flash()
	assert_null(shapes.get_muzzle_flash(), "fighters of shapes have the arena's flash only")


func test_a_knock_out_tips_the_picture_over_and_fades_it() -> void:
	var fighter: Fighter = _fighter("echo")
	var material: ShaderMaterial = _material(fighter.model)
	var turn: float = fighter.model.rotation.y
	fighter.knock_out()
	await wait_seconds(Fighter.KNOCK_OUT_SECONDS / 2.0)
	var tip: float = material.get_shader_parameter("tip")
	var fade: float = material.get_shader_parameter("fade")
	assert_between(tip, 0.2, CutoutMotion.KNOCK_OUT_TIP, "tipping over")
	assert_between(fade, 0.05, 0.8, "fading")
	assert_eq(fighter.model.scale, Vector3.ONE, "no shrink")
	assert_eq(fighter.model.rotation.y, turn, "no spin")
	await wait_seconds(Fighter.KNOCK_OUT_SECONDS / 2.0 + 0.1)
	assert_almost_eq(material.get_shader_parameter("tip"), CutoutMotion.KNOCK_OUT_TIP, 0.001)
	assert_almost_eq(material.get_shader_parameter("fade"), 0.0, 0.001, "gone")
	assert_false(fighter.visible, "hidden as the others")
