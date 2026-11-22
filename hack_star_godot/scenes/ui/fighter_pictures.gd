class_name FighterPictures
extends RefCounted
## The pictures of the fighter list: each fighter in its chosen skin is rendered once by an
## off-screen `FighterStage` into an `ImageTexture` and cached in `GameState.pictures` (a live 3D
## view per card would cost six renders per frame on a phone).

const STAGE: PackedScene = preload("res://scenes/ui/fighter_stage.tscn")
const PICTURE_SIZE: Vector2 = Vector2(256.0, 320.0)
const FAR_AWAY: Vector2 = Vector2(-10000.0, -10000.0)
const RENDER_FRAMES: int = 3


static func key(fighter_id: String, skin_id: String) -> String:
	return "%s/%s" % [fighter_id, skin_id]


## The cached picture of a fighter in its chosen skin, or null while it is not rendered.
static func cached(fighter_id: String) -> Texture2D:
	return GameState.pictures.get(key(fighter_id, GameState.selected_skins[fighter_id]))


## Renders the pictures that are not cached yet. A run without a renderer (headless) has nothing
## to draw and caches nothing.
static func ensure(host: Node) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var stages: Dictionary[String, FighterStage] = {}
	for fighter_id: String in Fighters.ids():
		var skin_id: String = GameState.selected_skins[fighter_id]
		var picture_key: String = key(fighter_id, skin_id)
		if GameState.pictures.has(picture_key):
			continue
		var stage: FighterStage = STAGE.instantiate()
		stage.position = FAR_AWAY
		host.add_child(stage)
		stage.size = PICTURE_SIZE
		stage.model.idle_enabled = false
		stage.show_fighter(fighter_id, skin_id)
		stages[picture_key] = stage
	if stages.is_empty():
		return
	var tree: SceneTree = host.get_tree()
	for frame: int in RENDER_FRAMES:
		await tree.process_frame
	for picture_key: String in stages:
		var stage: FighterStage = stages[picture_key]
		if not is_instance_valid(stage):
			continue
		var image: Image = stage.get_node("Viewport").get_texture().get_image()
		if image != null and not image.is_empty():
			GameState.pictures[picture_key] = ImageTexture.create_from_image(image)
		stage.queue_free()
