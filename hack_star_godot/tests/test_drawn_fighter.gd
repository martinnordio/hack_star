extends GutTest
## The fighters drawn by children (spec 09, part A, D14, A9). Every test runs for every drawn
## fighter in `Fighters.LIST` (the first is Beatbolt, from Mattia's drawing), so adding or removing
## one needs no change here; without any drawn fighter the scene tests pass with a note.

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const HOME: PackedScene = preload("res://scenes/home.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TEST_SAVE: String = "user://test/drawn_fighter_save.json"
## The six original fighters as they were before any drawn fighter: id, name, rarity, skins,
## start trophies, start power level, unlocked at the start.
const ORIGINALS: Array[Array] = [
	["blaze", "Blaze", "Rare", 3, 1240, 7, true],
	["rocko", "Rocko", "Rare", 2, 420, 4, true],
	["turbo", "Turbo", "Super Rare", 2, 85, 2, true],
	["frosty", "Frosty", "Epic", 2, 0, 1, false],
	["luna", "Luna", "Mythic", 3, 0, 1, false],
	["pixel", "Pixel", "Legendary", 2, 0, 1, false],
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


## The drawn fighters' ids; with none, the test passes with a note (nothing to check).
func _drawn_ids() -> Array[String]:
	var result: Array[String] = []
	for fighter: Dictionary in Fighters.LIST:
		if fighter.get("drawn", false):
			result.append(fighter["id"])
	if result.is_empty():
		pass_test("no drawn fighter in the game")
	return result


## The first drawn fighter, or "" (the test passes with a note) when there is none.
func _first_drawn() -> String:
	var drawn: Array[String] = _drawn_ids()
	return "" if drawn.is_empty() else drawn[0]


func _model(fighter_id: String) -> FighterModel:
	var model: FighterModel = MODEL_SCENE.instantiate()
	add_child_autofree(model)
	model.setup(fighter_id)
	return model


## Loads a save file with this content as a new game start would.
func _load_save(data: Dictionary) -> void:
	var player_save: String = GameState.save_path
	GameState.save_path = TEST_SAVE
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	GameState.load_saved()
	GameState.save_path = player_save
	DirAccess.remove_absolute(TEST_SAVE)


func test_every_drawn_fighter_is_unlocked_with_one_default_skin_and_a_short_name() -> void:
	for fighter_id: String in _drawn_ids():
		var fighter: Dictionary = Fighters.get_fighter(fighter_id)
		assert_true(fighter["unlocked"], fighter_id)
		assert_between(fighter["name"].length(), 1, 12, "a name of 1-12 letters (A6)")
		assert_eq(fighter["skins"], [{"id": "default", "name": "Default", "rarity": ""}])
		assert_true(fighter_id in Fighters.start_unlocked())
		assert_true(GameState.is_unlocked(fighter_id), "%s is unlocked for everyone" % fighter_id)


func test_a_drawn_fighter_copies_the_rarity_and_numbers_of_the_one_it_plays_like() -> void:
	for fighter_id: String in _drawn_ids():
		var fighter: Dictionary = Fighters.get_fighter(fighter_id)
		var model: Dictionary = Fighters.get_fighter(fighter.get("plays_like", ""))
		assert_false(model.is_empty(), "%s plays like an existing fighter" % fighter_id)
		assert_false(model.get("drawn", false), "%s copies an original fighter" % fighter_id)
		if model.is_empty():
			continue
		assert_eq(fighter["rarity"], model["rarity"])
		assert_eq(SampleProgress.TROPHIES[fighter_id], SampleProgress.TROPHIES[model["id"]])
		var power: int = SampleProgress.POWER_LEVELS[model["id"]]
		assert_eq(SampleProgress.POWER_LEVELS[fighter_id], power)


func test_every_drawn_fighter_has_one_look_file_and_every_look_file_a_drawn_fighter() -> void:
	for fighter: Dictionary in Fighters.LIST:
		var drawn: bool = fighter.get("drawn", false)
		assert_eq(
			DrawnFighters.has(fighter["id"]), drawn, "%s: a look file if drawn" % fighter["id"]
		)
		var shapes: bool = not drawn and not fighter.get("cutout", false)
		assert_eq(FighterModel.LOOKS.has(fighter["id"]), shapes, fighter["id"])
	for fighter_id: String in DrawnFighters.MODELS:
		assert_true(Fighters.get_fighter(fighter_id).get("drawn", false), fighter_id)
		assert_true(DrawnFighters.looks(fighter_id).has(Fighters.DEFAULT_SKIN), fighter_id)


func test_every_drawn_fighter_builds_with_the_parts_of_its_drawing() -> void:
	for fighter_id: String in _drawn_ids():
		var model: FighterModel = _model(fighter_id)
		assert_eq(model.fighter_id, fighter_id, "not the Blaze fallback")
		assert_gt(model.find_children("*", "MeshInstance3D", true, false).size(), 10)
		assert_false(DrawnFighters.idea_parts(fighter_id).is_empty(), fighter_id)
		for part_name: String in DrawnFighters.idea_parts(fighter_id):
			assert_not_null(
				model.find_child(part_name, true, false), "%s has %s" % [fighter_id, part_name]
			)


func test_an_old_save_without_the_drawn_fighters_gets_them_unlocked() -> void:
	var progress: Dictionary = {"unlocked": ["blaze", "rocko", "turbo"], "credits": 10}
	_load_save({"version": 2, "hacks": [], "progress": progress})
	assert_eq(GameState.credits, 10, "the old save is read")
	for fighter_id: String in _drawn_ids():
		assert_true(GameState.is_unlocked(fighter_id), fighter_id)


func test_a_save_that_chose_a_removed_drawn_fighter_falls_back_to_the_default() -> void:
	var progress: Dictionary = {
		"selected_fighter": "removedbolt",
		"trophies": {"blaze": 1300, "removedbolt": 50},
		"power_levels": {"rocko": 6, "removedbolt": 3},
		"unlocked": ["blaze", "rocko", "turbo", "removedbolt"],
		"credits": 42,
		"selected_skins": {"removedbolt": "default"},
	}
	_load_save({"version": 3, "revision": 1, "hacks": [], "progress": progress})
	assert_eq(GameState.selected_fighter, SampleProgress.SELECTED_FIGHTER, "the default fighter")
	assert_false(GameState.trophies.has("removedbolt"), "the removed fighter is dropped")
	assert_false("removedbolt" in GameState.unlocked)
	assert_false(GameState.selected_skins.has("removedbolt"))
	assert_eq(GameState.trophies["blaze"], 1300, "the rest is kept")
	assert_eq(GameState.power_levels["rocko"], 6)
	assert_eq(GameState.credits, 42)


func test_drawn_fighters_change_no_other_fighter() -> void:
	var originals: Array[Dictionary] = []
	for fighter: Dictionary in Fighters.LIST:
		if not fighter.get("drawn", false) and not fighter.get("cutout", false):
			originals.append(fighter)
	assert_eq(originals.size(), ORIGINALS.size())
	for index: int in ORIGINALS.size():
		var expected: Array = ORIGINALS[index]
		var fighter: Dictionary = Fighters.LIST[index]
		var fighter_id: String = expected[0]
		assert_eq(fighter["id"], fighter_id, "the originals come first, in their order")
		assert_eq(
			[fighter["name"], fighter["rarity"], fighter["skins"].size(), fighter["unlocked"]],
			[expected[1], expected[2], expected[3], expected[6]]
		)
		assert_eq(SampleProgress.TROPHIES[fighter_id], expected[4], fighter_id)
		assert_eq(SampleProgress.POWER_LEVELS[fighter_id], expected[5], fighter_id)
		assert_eq(_model(fighter_id).fighter_id, fighter_id, "built by FighterModel itself")
	assert_eq(FighterModel.LOOKS.size(), ORIGINALS.size(), "no look added to the originals'")


func test_a_drawn_fighter_can_be_chosen_and_stands_on_home() -> void:
	var drawn: String = _first_drawn()
	if drawn.is_empty():
		return
	assert_true(GameState.select(drawn, Fighters.DEFAULT_SKIN))
	var screen: Control = autofree(HOME.instantiate())
	add_child(screen)
	var model: FighterModel = screen.get_node("Margin/Column/Body/FighterStage").model
	assert_eq(model.fighter_id, drawn)
	var name_label: Label = screen.get_node("Margin/Column/Body/Controls/NameRow/NameLabel")
	assert_eq(name_label.text, Fighters.get_fighter(drawn)["name"])


func test_a_drawn_fighter_plays_in_training() -> void:
	var drawn: String = _first_drawn()
	if drawn.is_empty():
		return
	GameState.select(drawn, Fighters.DEFAULT_SKIN)
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var fighter: Fighter = arena.get_node("Fighter")
	var model: FighterModel = fighter.get_node("Model")
	assert_eq(model.fighter_id, drawn)
	arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	await wait_physics_frames(5)
	assert_true(model.running, "it runs")


func test_a_drawn_fighter_plays_in_a_match() -> void:
	var drawn: String = _first_drawn()
	if drawn.is_empty():
		return
	GameState.select(drawn, Fighters.DEFAULT_SKIN)
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
	assert_eq((player.get_node("Model") as FighterModel).fighter_id, drawn)
	assert_eq(arena.fighters.size(), MatchSettings.BOT_COUNT + 1, "against the bots")


func test_a_drawn_fighter_has_the_idle_run_and_attack_animations() -> void:
	var drawn: String = _first_drawn()
	if drawn.is_empty():
		return
	var model: FighterModel = _model(drawn)
	model.idle_enabled = false
	var rig: Node3D = model.get_rig()
	var body: Node3D = model.get_body()
	model.animate(0.0)
	var resting: Transform3D = body.transform
	model.animate(0.7)
	assert_ne(body.transform, resting, "idle: it breathes and sways")
	model.running = true
	model.animate(0.1)
	assert_gt(rig.rotation.x, 0.1, "running: it leans forward")
	model.running = false
	model.play_attack()
	model._process(FighterModel.ATTACK_SECONDS / 2.0)
	model.animate(0.0)
	assert_lt(body.position.z, -0.05, "attack: the recoil")


func test_a_drawn_fighter_turns_see_through_in_a_bush_and_back() -> void:
	var drawn: String = _first_drawn()
	if drawn.is_empty():
		return
	var model: FighterModel = _model(drawn)
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
