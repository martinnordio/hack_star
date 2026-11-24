class_name FighterPictures
extends RefCounted
## The pictures of the fighter list and of the skin buttons: a fighter in one skin is rendered
## once by an off-screen `FighterStage` into an `ImageTexture` and cached in `GameState.pictures`
## (a live 3D view per card or skin would cost a render per picture per frame on a phone).

const STAGE: PackedScene = preload("res://scenes/ui/fighter_stage.tscn")
const PICTURE_SIZE: Vector2 = Vector2(256.0, 320.0)
const FAR_AWAY: Vector2 = Vector2(-10000.0, -10000.0)
const RENDER_FRAMES: int = 3


static func key(fighter_id: String, skin_id: String) -> String:
	return "%s/%s" % [fighter_id, skin_id]


## The cached picture of a fighter in its chosen skin, or null while it is not rendered.
static func cached(fighter_id: String) -> Texture2D:
	return cached_skin(fighter_id, GameState.selected_skins[fighter_id])


## The cached picture of a fighter in one skin, or null while it is not rendered. A picture
## fighter's is its card picture (`CutoutFighters.card`), never rendered.
static func cached_skin(fighter_id: String, skin_id: String) -> Texture2D:
	if CutoutFighters.has(fighter_id):
		return CutoutFighters.card(fighter_id)
	return GameState.pictures.get(key(fighter_id, skin_id))


## Renders the pictures of every fighter in its chosen skin that are not cached yet.
static func ensure(host: Node) -> void:
	var pairs: Array[PackedStringArray] = []
	for fighter_id: String in Fighters.ids():
		pairs.append(PackedStringArray([fighter_id, GameState.selected_skins[fighter_id]]))
	await _render(host, pairs)


## Renders the pictures of one fighter in each of its skins that are not cached yet.
static func ensure_skins(host: Node, fighter_id: String) -> void:
	var pairs: Array[PackedStringArray] = []
	for skin: Dictionary in Fighters.get_fighter(fighter_id).get("skins", []):
		pairs.append(PackedStringArray([fighter_id, skin["id"]]))
	await _render(host, pairs)


# A run without a renderer (headless) has nothing to draw and caches nothing.
static func _render(host: Node, pairs: Array[PackedStringArray]) -> void:
	if DisplayServer.get_name() == "headless":
		return
	var stages: Dictionary[String, FighterStage] = {}
	for pair: PackedStringArray in pairs:
		var picture_key: String = key(pair[0], pair[1])
		if CutoutFighters.has(pair[0]):
			continue
		if GameState.pictures.has(picture_key) or stages.has(picture_key):
			continue
		var stage: FighterStage = STAGE.instantiate()
		stage.position = FAR_AWAY
		stage.pedestal = false
		host.add_child(stage)
		stage.size = PICTURE_SIZE
		stage.model.idle_enabled = false
		stage.show_fighter(pair[0], pair[1])
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
