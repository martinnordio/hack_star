extends GutTest
## The world choice (spec 09, W2, D9, D10): the world button and the choice on home, and the
## chosen world in Training and a match; the canyon is the default and nothing is saved.

const HOME: PackedScene = preload("res://scenes/home.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const WORLD_BUTTON: String = "Margin/Column/TopBar/WorldButton"
const TEST_SAVE: String = "user://test/world_choice.json"

var _player_save_path: String = ""


func before_all() -> void:
	_player_save_path = GameState.save_path


func before_each() -> void:
	GameState.reset()
	GameState.entrance_played = true


func after_each() -> void:
	GameState.reset()
	ArenaLayout.use(Worlds.CANYON)


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)
	GameState.save_path = _player_save_path


func _show_home() -> Control:
	var screen: Control = autofree(HOME.instantiate())
	add_child(screen)
	return screen


func _show(scene: PackedScene) -> Arena:
	var arena: Arena = scene.instantiate()
	arena.read_player_input = false
	add_child_autofree(arena)
	await wait_physics_frames(2)
	return arena


func test_the_canyon_is_the_default_world() -> void:
	assert_eq(GameState.world, Worlds.CANYON)
	var screen: Control = _show_home()
	var button: Button = screen.get_node(WORLD_BUTTON)
	assert_eq(button.text, "Canyon")
	assert_eq(button.icon, Icons.get_icon("world"))
	assert_eq(button.theme_type_variation, &"TealButton")
	assert_false(screen.get_node("WorldChoice").visible, "the choice is closed")


func test_the_world_button_opens_the_choice_with_the_current_world_marked() -> void:
	var screen: Control = _show_home()
	(screen.get_node(WORLD_BUTTON) as Button).pressed.emit()
	var choice: WorldChoice = screen.get_node("WorldChoice")
	assert_true(choice.visible, "the choice is open")
	var canyon: Button = choice.get_node("Panel/Column/Worlds/CanyonButton")
	var isles: Button = choice.get_node("Panel/Column/Worlds/GlimmerIslesButton")
	assert_eq(canyon.text, "Canyon")
	assert_eq(isles.text, "Glimmer Isles")
	assert_eq(canyon.theme_type_variation, &"GreenButton", "the current world is marked")
	assert_eq(canyon.icon, Icons.get_icon("check"))
	assert_eq(isles.theme_type_variation, &"", "the other is not")
	assert_eq(isles.icon, Icons.get_icon("world"))


func test_choosing_glimmer_isles_keeps_it_and_shows_it_on_home() -> void:
	var screen: Control = _show_home()
	var choice: WorldChoice = screen.get_node("WorldChoice")
	choice.open()
	(choice.get_node("Panel/Column/Worlds/GlimmerIslesButton") as Button).pressed.emit()
	assert_eq(GameState.world, Worlds.GLIMMER_ISLES)
	assert_false(choice.visible, "the choice closes")
	assert_eq(screen.get_node(WORLD_BUTTON).text, "Glimmer Isles")
	var again: Control = _show_home()
	assert_eq(again.get_node(WORLD_BUTTON).text, "Glimmer Isles", "kept while the game is open")
	choice.open()
	assert_eq(
		choice.get_node("Panel/Column/Worlds/GlimmerIslesButton").theme_type_variation,
		&"GreenButton"
	)


func test_a_tap_beside_the_choice_closes_it_without_a_change() -> void:
	var screen: Control = _show_home()
	var choice: WorldChoice = screen.get_node("WorldChoice")
	choice.open()
	var touch: InputEventScreenTouch = InputEventScreenTouch.new()
	touch.pressed = true
	(choice.get_node("Dim") as ColorRect).gui_input.emit(touch)
	assert_false(choice.visible)
	assert_eq(GameState.world, Worlds.CANYON)


func test_training_is_played_in_the_chosen_world() -> void:
	GameState.world = Worlds.GLIMMER_ISLES
	var arena: Arena = await _show(ARENA_SCENE)
	assert_eq(ArenaLayout.world(), Worlds.GLIMMER_ISLES)
	assert_true(arena.has_node("GlimmerIsles"), "Glimmer Isles is built")
	assert_false(arena.has_node("Canyon"), "instead of the canyon")
	var walls: Array[Node] = arena.get_node("Walls").get_children()
	assert_eq(walls.size(), GlimmerIslesLayout.WALLS.size(), "one body per wall of the layout")
	var fighter: Fighter = arena.get_node("Fighter")
	assert_eq(Vector2(fighter.position.x, fighter.position.z), GlimmerIslesLayout.STARTS[0])
	var dummies: Array[Node] = arena.get_node("Dummies").get_children()
	assert_eq(dummies.size(), GlimmerIslesLayout.DUMMIES.size())
	for index: int in dummies.size():
		var at: Vector3 = (dummies[index] as Node3D).position
		assert_eq(Vector2(at.x, at.z), GlimmerIslesLayout.DUMMIES[index])


func test_a_match_is_played_in_the_chosen_world() -> void:
	GameState.world = Worlds.GLIMMER_ISLES
	var arena: MatchArena = await _show(MATCH_SCENE)
	assert_true(arena.has_node("GlimmerIsles"))
	var bots: Array[Fighter] = arena.bots()
	for i: int in bots.size():
		var at: Vector2 = Vector2(bots[i].position.x, bots[i].position.z)
		assert_eq(at, GlimmerIslesLayout.STARTS[i + 1], "%s at its start" % bots[i].name)


func test_the_canyon_stays_the_canyon() -> void:
	GameState.world = Worlds.GLIMMER_ISLES
	await _show(ARENA_SCENE)
	GameState.world = Worlds.CANYON
	var arena: Arena = await _show(ARENA_SCENE)
	assert_eq(ArenaLayout.world(), Worlds.CANYON)
	assert_true(arena.has_node("Canyon"))
	assert_eq(arena.get_node("Walls").get_child_count(), ArenaLayout.WALLS.size())


func test_a_bot_finds_the_player_in_glimmer_isles() -> void:
	GameState.world = Worlds.GLIMMER_ISLES
	GameState.match_settings.bot_count = 1
	GameState.match_settings.countdown_seconds = 0
	var arena: MatchArena = await _show(MATCH_SCENE)
	var bot: Fighter = arena.bots()[0]
	var at: Vector2 = ArenaLayout.start() + Vector2(3.0, -3.0)
	bot.position = Vector3(at.x, 0.0, at.y)
	var shots: Array[Node] = []
	arena.get_node("Shots").child_entered_tree.connect(func(shot: Node) -> void: shots.append(shot))
	await wait_until(func() -> bool: return not shots.is_empty(), 2.0)
	assert_false(shots.is_empty(), "the bot fired at the player")


func test_a_wandering_bot_picks_free_points_of_glimmer_isles() -> void:
	ArenaLayout.use(Worlds.GLIMMER_ISLES)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 3
	var brain: BotBrain = BotBrain.new(rng)
	var level: Dictionary = MatchSettings.level(MatchSettings.BOT_LEVEL)
	var none: Array[Dictionary] = []
	for i: int in 20:
		brain.think(float(i) * BotBrain.WANDER_SECONDS, ArenaLayout.start(), none, level)
		assert_true(ArenaLayout.is_free(brain.wander_point, BotBrain.WANDER_CLEARANCE))


func test_the_world_is_not_saved() -> void:
	GameState.save_path = TEST_SAVE
	GameState.world = Worlds.GLIMMER_ISLES
	GameState.save()
	var text: String = FileAccess.get_file_as_string(TEST_SAVE)
	assert_false(text.is_empty(), "saved")
	assert_false(text.contains("glimmer"), "without the world")
	GameState.reset()
	GameState.load_saved()
	assert_eq(GameState.world, Worlds.CANYON, "the canyon at the next start")
