extends GutTest


func test_five_rarities_in_order() -> void:
	assert_eq(Rarity.NAMES, ["Rare", "Super Rare", "Epic", "Mythic", "Legendary"])
	assert_eq(Rarity.COLORS.size(), Rarity.NAMES.size())


func test_rank_follows_the_order() -> void:
	assert_eq(Rarity.rank("Rare"), 0)
	assert_eq(Rarity.rank("Legendary"), 4)
	assert_eq(Rarity.rank("Unknown"), -1)


func test_every_rarity_has_its_own_colour() -> void:
	for index: int in Rarity.NAMES.size():
		assert_eq(Rarity.color(Rarity.NAMES[index]), Rarity.COLORS[index])
	for index: int in range(1, Rarity.COLORS.size()):
		assert_ne(Rarity.COLORS[index], Rarity.COLORS[index - 1])


func test_legendary_is_gold_and_unknown_is_white() -> void:
	assert_eq(Rarity.color("Legendary"), Rarity.LEGENDARY_GOLD)
	assert_eq(Rarity.color("Unknown"), Color.WHITE)
