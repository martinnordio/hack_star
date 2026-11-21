extends GutTest


func before_each() -> void:
	GameState.reset()


func after_all() -> void:
	GameState.reset()


func test_starts_from_the_sample_progress() -> void:
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skin(), Fighters.DEFAULT_SKIN)
	assert_eq(GameState.credits, SampleProgress.CREDITS)
	assert_eq(GameState.trophies["blaze"], 1240)
	assert_eq(GameState.power_levels["rocko"], 4)
	assert_eq(GameState.unlocked, ["blaze", "rocko", "turbo"])
	assert_false(GameState.entrance_played)


func test_total_trophies_adds_every_fighter() -> void:
	assert_eq(GameState.total_trophies(), 1240 + 420 + 85)
	GameState.trophies["pixel"] = 100
	assert_eq(GameState.total_trophies(), 1240 + 420 + 85 + 100)


func test_select_an_unlocked_fighter_and_skin() -> void:
	assert_true(GameState.select("rocko", "crystal"))
	assert_eq(GameState.selected_fighter, "rocko")
	assert_eq(GameState.selected_skin(), "crystal")


func test_the_choice_of_a_skin_is_kept_per_fighter() -> void:
	GameState.select("blaze", "lava")
	GameState.select("rocko", "default")
	GameState.select("blaze", "lava")
	assert_eq(GameState.selected_skins["rocko"], "default")
	assert_eq(GameState.selected_skin(), "lava")


func test_a_locked_fighter_is_refused() -> void:
	assert_false(GameState.select("pixel", "default"))
	assert_eq(GameState.selected_fighter, "blaze", "the choice is unchanged")
	assert_eq(GameState.selected_skins["pixel"], Fighters.DEFAULT_SKIN)


func test_an_unknown_skin_or_fighter_is_refused() -> void:
	assert_false(GameState.select("blaze", "crystal"))
	assert_false(GameState.select("nobody", "default"))
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skin(), Fighters.DEFAULT_SKIN)


func test_reset_forgets_the_choices() -> void:
	GameState.select("turbo", "neon")
	GameState.entrance_played = true
	GameState.reset()
	assert_eq(GameState.selected_fighter, "blaze")
	assert_eq(GameState.selected_skins["turbo"], Fighters.DEFAULT_SKIN)
	assert_false(GameState.entrance_played)
