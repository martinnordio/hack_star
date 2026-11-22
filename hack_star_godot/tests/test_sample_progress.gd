extends GutTest


func test_every_fighter_has_trophies_and_a_power_level() -> void:
	for fighter_id: String in Fighters.ids():
		assert_true(SampleProgress.TROPHIES.has(fighter_id), "%s has trophies" % fighter_id)
		assert_between(SampleProgress.POWER_LEVELS[fighter_id], 1, 11, "%s power" % fighter_id)
	assert_eq(SampleProgress.TROPHIES.size(), 6)
	assert_eq(SampleProgress.POWER_LEVELS.size(), 6)


func test_values_of_the_svelte_game() -> void:
	assert_eq(SampleProgress.TROPHIES["blaze"], 1240)
	assert_eq(SampleProgress.POWER_LEVELS["blaze"], 7)
	assert_eq(SampleProgress.TROPHIES["rocko"], 420)
	assert_eq(SampleProgress.POWER_LEVELS["rocko"], 4)
	assert_eq(SampleProgress.TROPHIES["turbo"], 85)
	assert_eq(SampleProgress.POWER_LEVELS["turbo"], 2)
	assert_eq(SampleProgress.SELECTED_FIGHTER, "blaze")


func test_one_fighter_has_a_prestige_badge_and_the_player_has_credits() -> void:
	var with_prestige: int = 0
	for fighter_id: String in Fighters.ids():
		if Prestige.level(SampleProgress.TROPHIES[fighter_id]) >= 1:
			with_prestige += 1
	assert_gte(with_prestige, 1)
	assert_gt(SampleProgress.CREDITS, 0)
