extends GutTest

const EXPECTED: Array[Array] = [
	["blaze", "Blaze", "Rare"],
	["rocko", "Rocko", "Rare"],
	["turbo", "Turbo", "Super Rare"],
	["frosty", "Frosty", "Epic"],
	["luna", "Luna", "Mythic"],
	["pixel", "Pixel", "Legendary"],
	["beatbolt", "Beatbolt", "Mythic"],
]


func test_six_fighters_and_the_drawn_one_with_names_and_rarities() -> void:
	assert_eq(Fighters.LIST.size(), 7)
	for index: int in EXPECTED.size():
		var fighter: Dictionary = Fighters.LIST[index]
		assert_eq(fighter["id"], EXPECTED[index][0])
		assert_eq(fighter["name"], EXPECTED[index][1])
		assert_eq(fighter["rarity"], EXPECTED[index][2])
		assert_gte(Rarity.rank(fighter["rarity"]), 0, "%s has a known rarity" % fighter["name"])


func test_each_fighter_has_two_or_three_skins_with_one_default() -> void:
	var total: int = 0
	for fighter: Dictionary in Fighters.LIST:
		var skins: Array = fighter["skins"]
		if fighter.get("drawn", false):
			assert_eq(skins.size(), 1, "%s (drawn) has only its Default skin" % fighter["name"])
		else:
			assert_between(skins.size(), 2, 3, "%s has 2-3 skins" % fighter["name"])
		total += skins.size()
		var defaults: int = 0
		for skin: Dictionary in skins:
			if skin["id"] == Fighters.DEFAULT_SKIN:
				defaults += 1
			else:
				assert_gte(Rarity.rank(skin["rarity"]), 0, "%s has a rarity" % skin["name"])
		assert_eq(defaults, 1, "%s has one Default skin" % fighter["name"])
	assert_eq(total, 15, "14 skins of the 6 fighters and Beatbolt's Default")


func test_skin_names_and_rarities_of_the_spec() -> void:
	assert_eq(Fighters.get_skin("blaze", "lava")["rarity"], "Epic")
	assert_eq(Fighters.get_skin("blaze", "phoenix")["rarity"], "Legendary")
	assert_eq(Fighters.get_skin("turbo", "neon")["rarity"], "Mythic")
	assert_eq(Fighters.get_skin("frosty", "snow_king")["name"], "Snow King")
	assert_eq(Fighters.get_skin("pixel", "glitch")["rarity"], "Legendary")


func test_blaze_rocko_turbo_and_beatbolt_are_unlocked_at_the_start() -> void:
	assert_eq(Fighters.start_unlocked(), ["blaze", "rocko", "turbo", "beatbolt"])


func test_lookups_of_unknown_ids_are_empty() -> void:
	assert_eq(Fighters.ids(), ["blaze", "rocko", "turbo", "frosty", "luna", "pixel", "beatbolt"])
	assert_true(Fighters.get_fighter("nobody").is_empty())
	assert_false(Fighters.has_skin("blaze", "crystal"), "Crystal is Rocko's skin")
	assert_false(Fighters.has_skin("nobody", "default"))
