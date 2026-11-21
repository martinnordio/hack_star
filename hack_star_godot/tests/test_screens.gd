extends GutTest

const THEME_PATH: String = "res://scenes/ui/hack_star_theme.tres"


func test_each_screen_constant_names_an_existing_scene() -> void:
	for path: String in [
		Screens.HOME,
		Screens.ARENA,
		Screens.FIGHTERS,
		Screens.FIGHTER,
		Screens.INFO,
		Screens.HACK,
		Screens.QR,
		Screens.MATCH
	]:
		assert_true(ResourceLoader.exists(path), "%s exists" % path)
		assert_true(load(path) is PackedScene, "%s is a scene" % path)


func test_home_is_the_main_scene() -> void:
	assert_eq(Screens.HOME, ProjectSettings.get_setting("application/run/main_scene"))


func test_go_to_changes_the_scene() -> void:
	var tree: SceneTree = get_tree()
	var previous: Node = tree.current_scene
	var placeholder: Node = Node.new()
	tree.root.add_child(placeholder)
	tree.current_scene = placeholder
	assert_eq(Screens.go_to(Screens.ARENA), OK)
	await wait_process_frames(2)
	var shown: Node = tree.current_scene
	assert_eq(shown.scene_file_path, Screens.ARENA, "the arena is the current scene")
	assert_false(is_instance_valid(placeholder), "the old scene is gone")
	shown.queue_free()
	await wait_process_frames(1)
	tree.current_scene = previous


func test_default_theme_is_the_hack_star_theme() -> void:
	assert_eq(ProjectSettings.get_setting("gui/theme/custom"), THEME_PATH)
	assert_true(load(THEME_PATH) is Theme)
	var button: Button = autofree(Button.new())
	add_child(button)
	assert_eq(button.get_theme_font_size("font_size"), 36, "buttons take the theme's size")
