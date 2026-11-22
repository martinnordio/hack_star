extends GutTest
## The fighter drawn by a child (spec 09, part A, D14): Beatbolt, from Mattia's drawing.

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const HOME: PackedScene = preload("res://scenes/home.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const DRAWN: String = "beatbolt"
## The fighter whose attack and numbers Beatbolt copies (spec 09, Step 14).
const PLAYS_LIKE: String = "luna"
const OLD_SAVE: String = "user://test/drawn_fighter_old_save.json"

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


func _model() -> FighterModel:
	var model: FighterModel = MODEL_SCENE.instantiate()
	add_child_autofree(model)
	model.setup(DRAWN)
	return model


func test_beatbolt_is_a_drawn_fighter_unlocked_with_one_default_skin() -> void:
	var fighter: Dictionary = Fighters.get_fighter(DRAWN)
	assert_eq(fighter["name"], "Beatbolt")
	assert_true(fighter["drawn"])
	assert_true(fighter["unlocked"])
	assert_between(fighter["name"].length(), 1, 12, "a name of 1-12 letters (A6)")
	assert_eq(fighter["skins"], [{"id": "default", "name": "Default", "rarity": ""}])
	assert_true(DRAWN in Fighters.start_unlocked())
	assert_true(GameState.is_unlocked(DRAWN), "unlocked for every player")


func test_beatbolt_copies_the_rarity_and_numbers_of_luna() -> void:
	var luna: Dictionary = Fighters.get_fighter(PLAYS_LIKE)
	assert_eq(Fighters.get_fighter(DRAWN)["rarity"], luna["rarity"])
	assert_eq(SampleProgress.TROPHIES[DRAWN], SampleProgress.TROPHIES[PLAYS_LIKE])
	assert_eq(SampleProgress.POWER_LEVELS[DRAWN], SampleProgress.POWER_LEVELS[PLAYS_LIKE])


func test_every_drawn_fighter_has_one_look_and_every_look_a_drawn_fighter() -> void:
	for fighter: Dictionary in Fighters.LIST:
		var drawn: bool = fighter.get("drawn", false)
		assert_eq(
			DrawnFighters.has(fighter["id"]),
			drawn,
			"%s: a look file only when drawn" % fighter["id"]
		)
		assert_eq(FighterModel.LOOKS.has(fighter["id"]), not drawn, fighter["id"])
	for fighter_id: String in DrawnFighters.MODELS:
		assert_true(Fighters.get_fighter(fighter_id).get("drawn", false), fighter_id)
		assert_true(DrawnFighters.looks(fighter_id).has(Fighters.DEFAULT_SKIN), fighter_id)


func test_an_old_save_without_beatbolt_gets_him_unlocked() -> void:
	var player_save: String = GameState.save_path
	GameState.save_path = OLD_SAVE
	var file: FileAccess = FileAccess.open(OLD_SAVE, FileAccess.WRITE)
	var progress: Dictionary = {"unlocked": ["blaze", "rocko", "turbo"], "credits": 10}
	file.store_string(JSON.stringify({"version": 2, "hacks": [], "progress": progress}))
	file.close()
	GameState.load_saved()
	GameState.save_path = player_save
	DirAccess.remove_absolute(OLD_SAVE)
	assert_eq(GameState.credits, 10, "the old save is read")
	assert_true(GameState.is_unlocked(DRAWN))


func test_beatbolt_can_be_chosen_and_stands_on_home() -> void:
	assert_true(GameState.select(DRAWN, Fighters.DEFAULT_SKIN))
	var screen: Control = autofree(HOME.instantiate())
	add_child(screen)
	var model: FighterModel = screen.get_node("Margin/Column/Body/FighterStage").model
	assert_eq(model.fighter_id, DRAWN)
	var name_label: Label = screen.get_node("Margin/Column/Body/Controls/NameRow/NameLabel")
	assert_eq(name_label.text, "Beatbolt")


func test_beatbolt_plays_in_training() -> void:
	GameState.select(DRAWN, Fighters.DEFAULT_SKIN)
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var fighter: Fighter = arena.get_node("Fighter")
	var model: FighterModel = fighter.get_node("Model")
	assert_eq(model.fighter_id, DRAWN)
	assert_not_null(model.find_child("ArmCannon", true, false))
	arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	await wait_physics_frames(5)
	assert_true(model.running, "he runs")


func test_beatbolt_plays_in_a_match() -> void:
	GameState.select(DRAWN, Fighters.DEFAULT_SKIN)
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
	assert_eq((player.get_node("Model") as FighterModel).fighter_id, DRAWN)
	assert_eq(arena.fighters.size(), MatchSettings.BOT_COUNT + 1, "he plays against the bots")


func test_beatbolt_has_the_idle_run_and_attack_animations() -> void:
	var model: FighterModel = _model()
	model.idle_enabled = false
	var rig: Node3D = model.get_rig()
	var body: Node3D = model.get_body()
	model.animate(0.0)
	var resting: Transform3D = body.transform
	model.animate(0.7)
	assert_ne(body.transform, resting, "idle: he breathes and sways")
	model.running = true
	model.animate(0.1)
	assert_gt(rig.rotation.x, 0.1, "running: he leans forward")
	model.running = false
	model.play_attack()
	model._process(FighterModel.ATTACK_SECONDS / 2.0)
	model.animate(0.0)
	assert_lt(body.position.z, -0.05, "attack: the recoil")


func test_beatbolt_turns_see_through_in_a_bush_and_back() -> void:
	var model: FighterModel = _model()
	var meshes: Array[Node] = model.find_children("*", "MeshInstance3D", true, false)
	var solid: Dictionary = {}
	for mesh: MeshInstance3D in meshes:
		solid[mesh] = mesh.material_override
	model.set_see_through(true)
	for mesh: MeshInstance3D in meshes:
		if mesh.name == "Shadow":
			continue
		var material: Material = mesh.material_override
		assert_true(material is BaseMaterial3D, "%s is see-through" % mesh.name)
		if material is BaseMaterial3D:
			assert_eq((material as BaseMaterial3D).transparency, BaseMaterial3D.TRANSPARENCY_ALPHA)
	model.set_see_through(false)
	for mesh: MeshInstance3D in meshes:
		assert_eq(mesh.material_override, solid[mesh], "%s is solid again" % mesh.name)
