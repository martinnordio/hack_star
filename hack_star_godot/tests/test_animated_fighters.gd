extends GutTest
## The animated picture fighters (spec 09, part M, D34, D36, D41): MagMax's data, unlocked from the
## start and in old saves; the delivered frames and projectiles of MagMax, Echo and Flarekid load
## from their final folders, 12 frames of one size each, loaded on first use; MagMax's card on
## his card and skin button; MagMax plays in Training and a match.

const MODEL_SCENE: PackedScene = preload("res://scenes/fighter_model.tscn")
const LIST: PackedScene = preload("res://scenes/fighter_list.tscn")
const FIGHTER_SCREEN: PackedScene = preload("res://scenes/fighter_screen.tscn")
const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const TEST_SAVE: String = "user://test/animated_fighter_save.json"
## Fighter id, its final folder (M2).
const FOLDERS: Dictionary[String, String] = {
	"magmax": "res://characters/magmax2/",
	"echo": "res://characters/echo/",
	"flarekid": "res://characters/blaze2/",
}
const ANIMATIONS: Array[String] = ["idle", "walk", "shoot"]

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


func test_magmax_is_an_unlocked_epic_fighter_playing_like_rocko() -> void:
	var fighter: Dictionary = Fighters.get_fighter("magmax")
	assert_eq(
		[fighter["name"], fighter["rarity"], fighter["plays_like"]], ["MagMax", "Epic", "rocko"]
	)
	assert_true(fighter["unlocked"] and fighter["cutout"])
	assert_eq(fighter["skins"], [{"id": "default", "name": "Default", "rarity": ""}])
	assert_eq(Fighters.ids().back(), "magmax", "after Echo")
	assert_true(GameState.is_unlocked("magmax"))
	assert_eq(SampleProgress.TROPHIES["magmax"], 0)
	assert_eq(SampleProgress.POWER_LEVELS["magmax"], 1)
	assert_eq(CutoutFighters.looks("magmax")["default"]["main"], Color("ff4500"), "lava orange-red")


func test_an_old_save_gets_magmax_unlocked() -> void:
	var player_save: String = GameState.save_path
	GameState.save_path = TEST_SAVE
	var progress: Dictionary = {"unlocked": ["blaze", "rocko"], "credits": 7}
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string(JSON.stringify({"version": 2, "hacks": [], "progress": progress}))
	file.close()
	GameState.load_saved()
	GameState.save_path = player_save
	DirAccess.remove_absolute(TEST_SAVE)
	assert_eq(GameState.credits, 7, "the old save is read")
	assert_true(GameState.is_unlocked("magmax"))


func test_every_frame_and_projectile_comes_from_the_final_folder() -> void:
	assert_eq(CutoutFighters.FIGHTERS.keys().size(), FOLDERS.size())
	for fighter_id: String in FOLDERS:
		var folder: String = FOLDERS[fighter_id]
		var row: Dictionary = CutoutFighters.FIGHTERS[fighter_id]
		for kind: String in ["frames", "projectile"]:
			assert_true(
				row[kind] is String, "%s %s: a path, loaded on first use" % [fighter_id, kind]
			)
			assert_true(String(row[kind]).begins_with(folder), "%s %s" % [fighter_id, kind])
		var frames: SpriteFrames = CutoutFighters.sprite_frames(fighter_id)
		assert_true(CutoutFighters.is_loaded(fighter_id, "frames"), "kept once loaded")
		assert_eq(CutoutFighters.sprite_frames(fighter_id), frames, "loaded once")
		var paths: Array[String] = [CutoutFighters.projectile(fighter_id).resource_path]
		for animation: String in frames.get_animation_names():
			for index: int in frames.get_frame_count(animation):
				paths.append(frames.get_frame_texture(animation, index).resource_path)
		for path: String in paths:
			assert_true(path.begins_with(folder), "%s: %s" % [fighter_id, path])
			for old: String in ["characters/blaze/", "characters/magmax/", "_new/"]:
				assert_false(path.contains(old), "%s: %s" % [fighter_id, path])


func test_twelve_frames_of_one_size_in_three_views() -> void:
	for fighter_id: String in FOLDERS:
		var frames: SpriteFrames = CutoutFighters.sprite_frames(fighter_id)
		var textures: Array[Texture2D] = []
		for view: String in CutoutFighters.VIEWS:
			for animation: String in ANIMATIONS:
				var name: String = "%s_%s" % [animation, view]
				assert_true(frames.has_animation(name), "%s %s" % [fighter_id, name])
				for index: int in frames.get_frame_count(name):
					var texture: Texture2D = frames.get_frame_texture(name, index)
					if not textures.has(texture):
						textures.append(texture)
			assert_eq(frames.get_frame_count("walk_" + view), 4, "walk 1, idle, walk 2, idle")
			assert_true(CutoutFighters.FIGHTERS[fighter_id]["muzzle"].has(view))
		assert_eq(textures.size(), 12, fighter_id)
		for texture: Texture2D in textures:
			assert_eq(texture.get_size(), textures[0].get_size(), "%s: no jump" % fighter_id)


func test_the_model_shows_the_front_idle_frame_at_the_planned_height() -> void:
	for fighter_id: String in FOLDERS:
		var model: FighterModel = MODEL_SCENE.instantiate()
		add_child_autofree(model)
		model.setup(fighter_id)
		assert_eq(model.fighter_id, fighter_id, "not the Blaze fallback")
		var material: ShaderMaterial = model.get_cutout().material_override
		assert_eq(
			material.get_shader_parameter("picture"), CutoutFighters.frame(fighter_id, "idle_down")
		)
		var row: Dictionary = CutoutFighters.FIGHTERS[fighter_id]
		var size: Vector2 = CutoutFighters.picture_size(fighter_id)
		var figure: float = (row["feet"].y - row["top"]) * size.y
		assert_almost_eq(figure, row["figure_height"], 0.001, fighter_id)
		assert_between(row["figure_height"], 2.4, 2.8, "%s: as tall as before" % fighter_id)
		var frame: Texture2D = CutoutFighters.frame(fighter_id, "idle_down")
		assert_almost_eq(size.x / size.y, frame.get_size().aspect(), 0.001, "the frame's aspect")


func test_magmax_card_is_on_his_card_and_skin_button() -> void:
	var card: Texture2D = load("res://characters/magmax2/magmax_card.png")
	assert_eq(FighterPictures.cached("magmax"), card)
	var screen: Control = autofree(LIST.instantiate())
	add_child(screen)
	var fighter_card: FighterCard = screen.get_node("Margin/Column/Scroll/Grid/Magmax")
	assert_eq(fighter_card.get_node("Column/Backdrop/Picture").texture, card)
	assert_eq(fighter_card.get_node("Column/NameLabel").text, "MagMax")
	GameState.viewed_fighter = "magmax"
	var fighter_screen: Control = autofree(FIGHTER_SCREEN.instantiate())
	add_child(fighter_screen)
	var skin_row: Node = fighter_screen.get_node("Margin/Column/Body/Details/SkinRow")
	assert_eq(skin_row.get_child_count(), 1, "one Default skin")
	assert_eq((skin_row.get_child(0) as SkinButton).icon, card)


func test_magmax_plays_in_training() -> void:
	assert_true(GameState.select("magmax", Fighters.DEFAULT_SKIN))
	var arena: Node3D = ARENA_SCENE.instantiate()
	add_child_autofree(arena)
	var fighter: Fighter = arena.get_node("Fighter")
	assert_eq(fighter.model.fighter_id, "magmax")
	assert_not_null(fighter.model.get_cutout())
	arena.read_player_input = false
	fighter.input_direction = Vector2.RIGHT
	var start: Vector3 = fighter.global_position
	await wait_physics_frames(5)
	assert_gt(fighter.global_position.x, start.x, "moves")
	assert_true(arena.fire(Vector2.UP), "shoots")


func test_magmax_plays_in_a_match() -> void:
	GameState.select("magmax", Fighters.DEFAULT_SKIN)
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
	assert_eq(player.model.fighter_id, "magmax")
	assert_eq(arena.fighters.size(), MatchSettings.BOT_COUNT + 1, "against the bots")
	assert_true(arena.fire(Vector2.UP), "shoots")
