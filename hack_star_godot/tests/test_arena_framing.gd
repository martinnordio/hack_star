extends GutTest
## At the start of Training and of a match the camera-side wall covers at most 10 % of the screen
## height at the five screen sizes, in every world (spec 09, G11), measured with
## `Camera3D.unproject_position`.

const ARENA_SCENE: PackedScene = preload("res://scenes/arena.tscn")
const MATCH_SCENE: PackedScene = preload("res://scenes/match.tscn")
const MAX_SHARE: float = 0.10
const SIZES: Dictionary = {
	"desktop 1280x720": Vector2i(1280, 720),
	"iPad landscape 1180x820": Vector2i(1180, 820),
	"iPad portrait 820x1180": Vector2i(820, 1180),
	"phone portrait 390x844": Vector2i(390, 844),
	"phone landscape 844x390": Vector2i(844, 390),
}


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	GameState.reset()


func _content_size(window_size: Vector2i) -> Vector2:
	var base: Vector2 = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	return Vector2(window_size) / UiScale.total(Vector2(window_size), base)


func _show_in_viewport(scene: PackedScene, size: Vector2i) -> Arena:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = size
	viewport.size_2d_override = Vector2i(_content_size(size).round())
	viewport.size_2d_override_stretch = true
	add_child_autofree(viewport)
	var arena: Arena = scene.instantiate()
	arena.read_player_input = false
	viewport.add_child(arena)
	await wait_process_frames(2)
	return arena


## The share of the screen height from the top edge of the camera-side border wall (with its
## cap) down to the bottom of the screen: the wall and the ground behind it, which hide the arena.
func _near_wall_share(arena: Arena, view: Vector2) -> float:
	var camera: Camera3D = arena.get_node("Camera")
	var height: float = Canyon.CAMERA_SIDE_WALL_HEIGHT
	if ArenaLayout.world() == Worlds.GLIMMER_ISLES:
		height = GlimmerIsles.CAMERA_SIDE_WALL_HEIGHT
	var top: float = INF
	for x: float in [-ArenaLayout.SIZE.x / 2.0, 0.0, ArenaLayout.SIZE.x / 2.0]:
		var edge: Vector3 = Vector3(x, height + Arena.WALL_CAP_HEIGHT, Arena.near_wall_z())
		top = minf(top, camera.unproject_position(edge).y)
	return (view.y - clampf(top, 0.0, view.y)) / view.y


func test_the_near_wall_covers_at_most_a_tenth_of_the_screen_at_the_start() -> void:
	for world_id: String in Worlds.ids():
		GameState.world = world_id
		for scene: PackedScene in [ARENA_SCENE, MATCH_SCENE]:
			for label: String in SIZES:
				var size: Vector2i = SIZES[label]
				var arena: Arena = await _show_in_viewport(scene, size)
				assert_eq(ArenaLayout.world(), world_id, "the arena uses the chosen world")
				var share: float = _near_wall_share(arena, _content_size(size))
				var where: String = "%s %s %s" % [world_id, scene.resource_path.get_file(), label]
				assert_lte(share, MAX_SHARE, "%s: near wall covers %.1f %%" % [where, share * 100])
				arena.get_parent().queue_free()


func test_the_player_is_in_view_and_above_the_near_wall_at_the_start() -> void:
	for world_id: String in Worlds.ids():
		GameState.world = world_id
		for label: String in SIZES:
			var size: Vector2i = SIZES[label]
			var arena: Arena = await _show_in_viewport(MATCH_SCENE, size)
			var view: Vector2 = _content_size(size)
			var camera: Camera3D = arena.get_node("Camera")
			var fighter: Fighter = arena.get_node("Fighter")
			var feet: Vector2 = camera.unproject_position(fighter.global_position)
			var where: String = "%s %s" % [world_id, label]
			assert_true(Rect2(Vector2.ZERO, view).has_point(feet), "%s feet %s" % [where, feet])
			assert_lt(feet.y, view.y * (1.0 - MAX_SHARE), "%s above the near wall" % where)
			arena.get_parent().queue_free()
