extends GutHookScript
## Runs once before all tests: they save to their own file, never the player's, and start from
## the sample progress.

const RUN_SAVE: String = "user://test/run_save.json"


func run() -> void:
	GameState.save_path = RUN_SAVE
	DirAccess.make_dir_recursive_absolute(RUN_SAVE.get_base_dir())
	DirAccess.remove_absolute(RUN_SAVE)
	GameState.reset()
