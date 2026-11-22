extends GutTest
## The reveal on the pedestal and the picture fighters' idle (spec 09, C3, C4, D23, D30): every
## fighter shown on home or the fighter screen pops in with sparks and a halo in its rarity
## colour; the off-screen pictures do not; the picture fighters breathe, bob and sway.

const HOME: PackedScene = preload("res://scenes/home.tscn")
const HomeScript: GDScript = preload("res://scenes/home.gd")
const FIGHTER_SCREEN: PackedScene = preload("res://scenes/fighter_screen.tscn")
const STAGE_SCENE: PackedScene = preload("res://scenes/ui/fighter_stage.tscn")
const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const HOME_STAGE: String = "Margin/Column/Body/FighterStage"
const SCREEN_STAGE: String = "Margin/Column/Body/StageFrame/FighterStage"
## Fighter, its rarity's colour.
const RARITIES: Array[Array] = [
	["flarekid", Rarity.LEGENDARY_GOLD],
	["echo", Color(0.95, 0.3, 0.35)],
	["rocko", Color(0.35, 0.8, 0.4)],
]


func before_each() -> void:
	GameState.reset()
	GameState.entrance_played = true


func after_each() -> void:
	GameState.reset()


func _home(fighter_id: String) -> FighterStage:
	GameState.select(fighter_id, Fighters.DEFAULT_SKIN)
	var screen: Control = autofree(HOME.instantiate())
	add_child(screen)
	return screen.get_node(HOME_STAGE)


func _assert_revealing(stage: FighterStage, color: Color, label: String) -> void:
	assert_lt(stage.model.get_rig().scale.x, 0.5, "%s: starts small" % label)
	assert_true(stage.get_sparks().emitting, "%s: the sparks burst" % label)
	assert_eq(stage.get_sparks().amount, FighterStage.REVEAL_SPARKS)
	var halo: StandardMaterial3D = stage.get_halo().material_override
	assert_eq(Color(halo.albedo_color, 1.0), color, "%s: the halo in the rarity colour" % label)
	var sparks: StandardMaterial3D = stage.get_sparks().material_override
	assert_eq(sparks.albedo_color, color.lightened(0.35), "%s: sparks too" % label)


func _assert_settled(stage: FighterStage, label: String) -> void:
	assert_almost_eq(stage.model.get_rig().scale, Vector3.ONE, Vector3.ONE * 0.01, label)
	assert_almost_eq(stage.get_halo().scale, Vector3.ONE, Vector3.ONE * 0.01, label)
	var halo: StandardMaterial3D = stage.get_halo().material_override
	assert_true(halo.billboard_keep_scale, "the halo's scale shows on screen")
	assert_almost_eq(halo.albedo_color.a, FighterStage.HALO_ALPHA, 0.01, "%s: halo stays" % label)


func test_the_reveal_is_short_and_pops_with_an_overshoot() -> void:
	assert_lte(FighterStage.REVEAL_SECONDS, 0.5, "C3: within 0.5 s")
	var stage: FighterStage = _home("rocko")
	var largest: float = 0.0
	for frame: int in 40:
		await wait_process_frames(1)
		largest = maxf(largest, stage.model.get_rig().scale.x)
	assert_gt(largest, 1.03, "grows past its size")
	assert_lt(largest, 1.15, "a short overshoot")


func test_home_reveals_every_fighter_in_its_rarity_colour() -> void:
	for row: Array in RARITIES:
		var stage: FighterStage = _home(row[0])
		_assert_revealing(stage, row[1], row[0])
		await wait_until(func() -> bool: return not stage.is_revealing(), 2.0)
		_assert_settled(stage, row[0])
		stage.get_parent().get_parent().get_parent().get_parent().free()


func test_the_fighter_screen_reveals_on_opening_and_on_another_skin() -> void:
	GameState.viewed_fighter = "rocko"
	var screen: Control = autofree(FIGHTER_SCREEN.instantiate())
	add_child(screen)
	var stage: FighterStage = screen.get_node(SCREEN_STAGE)
	_assert_revealing(stage, RARITIES[2][1], "opening")
	await wait_until(func() -> bool: return not stage.is_revealing(), 2.0)
	_assert_settled(stage, "opening")
	var skins: Node = screen.get_node("Margin/Column/Body/Details/SkinRow")
	(skins.get_child(1) as SkinButton).pressed.emit()
	_assert_revealing(stage, RARITIES[2][1], "another skin")


func test_the_off_screen_pictures_have_no_reveal() -> void:
	var stage: FighterStage = STAGE_SCENE.instantiate()
	stage.pedestal = false
	add_child_autofree(stage)
	stage.show_fighter("echo")
	assert_null(stage.get_halo())
	assert_null(stage.get_sparks())
	assert_eq(stage.model.get_rig().scale, Vector3.ONE, "at its size at once")


func test_the_home_entrance_plays_the_halo_at_the_landing_without_a_second_pop() -> void:
	GameState.entrance_played = false
	var stage: FighterStage = _home("echo")
	assert_eq(stage.model.get_rig().scale, Vector3.ONE, "the drop is the pop")
	assert_eq(stage.get_halo().scale, Vector3.ZERO, "no halo while it falls")
	assert_false(stage.get_sparks().visible, "no sparks while it falls")
	await wait_seconds(HomeScript.ENTRANCE_SECONDS + 0.3)
	await wait_until(func() -> bool: return not stage.is_revealing(), 2.0)
	_assert_settled(stage, "after the entrance")


func test_a_refresh_with_the_same_fighter_does_not_reveal_again() -> void:
	var stage: FighterStage = _home("echo")
	await wait_until(func() -> bool: return not stage.is_revealing(), 2.0)
	GameState.progress_changed.emit()
	assert_false(stage.is_revealing(), "the same fighter and skin")
	GameState.select("rocko", Fighters.DEFAULT_SKIN)
	GameState.progress_changed.emit()
	assert_true(stage.is_revealing(), "another fighter")


func test_picture_fighters_breathe_bob_and_sway_when_standing() -> void:
	for fighter_id: String in ["flarekid", "echo"]:
		var model: FighterModel = MODEL_SCENE.instantiate()
		model.idle_enabled = false
		add_child_autofree(model)
		model.setup(fighter_id)
		var material: ShaderMaterial = model.get_cutout().material_override
		var heights: Array[float] = []
		var tilts: Array[float] = []
		var stretches: Array[float] = []
		for step: int in 40:
			model.animate(step * 0.2)
			heights.append(model.get_body().position.y)
			tilts.append(material.get_shader_parameter("tilt"))
			stretches.append(model.get_body().scale.y)
			assert_almost_eq(
				model.get_body().scale.x * model.get_body().scale.y, 1.0, 0.02, "breathing"
			)
		assert_gte(heights.min(), 0.0, "%s: never under the ground" % fighter_id)
		assert_gt(heights.max() - heights.min(), 0.03, "%s: bobs" % fighter_id)
		assert_lte(heights.max(), CutoutMotion.BOB_HEIGHT + 0.001)
		assert_gt(tilts.max(), 0.05, "%s: sways one way" % fighter_id)
		assert_lt(tilts.min(), -0.05, "%s: and the other" % fighter_id)
		assert_lte(absf(tilts.max()), deg_to_rad(4.0) + 0.001, "at most 4 degrees")
		assert_gt(stretches.max(), 1.02, "%s: stretches" % fighter_id)
		assert_lt(stretches.min(), 0.98, "%s: and squashes" % fighter_id)


func test_shape_fighters_keep_their_idle() -> void:
	var model: FighterModel = MODEL_SCENE.instantiate()
	model.idle_enabled = false
	add_child_autofree(model)
	model.setup("blaze")
	model.animate(0.7)
	assert_eq(model.get_body().scale, Vector3.ONE, "no breathing scale")
	assert_ne(model.get_body().rotation.y, 0.0, "the sway of the shapes")
