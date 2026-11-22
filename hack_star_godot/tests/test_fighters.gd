extends GutTest
## The catalogue of the 6 original fighters; the drawn fighters after them are checked in
## `test_drawn_fighter.gd` and the picture fighters in `test_cutout_fighters.gd`, so adding or
## removing one changes nothing here (spec 09, A9, D30).

const EXPECTED: Array[Array] = [
	["blaze", "Blaze", "Rare"],
	["rocko", "Rocko", "Rare"],
	["turbo", "Turbo", "Super Rare"],
	["frosty", "Frosty", "Epic"],
	["luna", "Luna", "Mythic"],
	["pixel", "Pixel", "Legendary"],
]


## The fighters that are neither drawn by a child nor pictures, in catalogue order.
func _originals() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for fighter: Dictionary in Fighters.LIST:
		if not fighter.get("drawn", false) and not fighter.get("cutout", false):
			result.append(fighter)
	return result


func test_six_fighters_with_names_and_rarities() -> void:
	var originals: Array[Dictionary] = _originals()
	assert_eq(originals.size(), 6)
	for index: int in EXPECTED.size():
		var fighter: Dictionary = Fighters.LIST[index]
		assert_eq(fighter["id"], EXPECTED[index][0], "the six come first")
		assert_eq(fighter["name"], EXPECTED[index][1])
		assert_eq(fighter["rarity"], EXPECTED[index][2])
	for fighter: Dictionary in Fighters.LIST:
		assert_gte(Rarity.rank(fighter["rarity"]), 0, "%s has a known rarity" % fighter["name"])


func test_each_fighter_has_two_or_three_skins_with_one_default() -> void:
	var total: int = 0
	for fighter: Dictionary in _originals():
		var skins: Array = fighter["skins"]
		assert_between(skins.size(), 2, 3, "%s has 2-3 skins" % fighter["name"])
		total += skins.size()
		var defaults: int = 0
		for skin: Dictionary in skins:
			if skin["id"] == Fighters.DEFAULT_SKIN:
				defaults += 1
			else:
				assert_gte(Rarity.rank(skin["rarity"]), 0, "%s has a rarity" % skin["name"])
		assert_eq(defaults, 1, "%s has one Default skin" % fighter["name"])
	assert_eq(total, 14, "14 skins in all")


func test_skin_names_and_rarities_of_the_spec() -> void:
	assert_eq(Fighters.get_skin("blaze", "lava")["rarity"], "Epic")
	assert_eq(Fighters.get_skin("blaze", "phoenix")["rarity"], "Legendary")
	assert_eq(Fighters.get_skin("turbo", "neon")["rarity"], "Mythic")
	assert_eq(Fighters.get_skin("frosty", "snow_king")["name"], "Snow King")
	assert_eq(Fighters.get_skin("pixel", "glitch")["rarity"], "Legendary")


func test_blaze_rocko_and_turbo_are_unlocked_at_the_start() -> void:
	var originals: Array[String] = []
	for fighter_id: String in Fighters.start_unlocked():
		var fighter: Dictionary = Fighters.get_fighter(fighter_id)
		if not fighter.get("drawn", false) and not fighter.get("cutout", false):
			originals.append(fighter_id)
	assert_eq(originals, ["blaze", "rocko", "turbo"])


func test_lookups_of_unknown_ids_are_empty() -> void:
	assert_eq(Fighters.ids().slice(0, 6), ["blaze", "rocko", "turbo", "frosty", "luna", "pixel"])
	assert_true(Fighters.get_fighter("nobody").is_empty())
	assert_false(Fighters.has_skin("blaze", "crystal"), "Crystal is Rocko's skin")
	assert_false(Fighters.has_skin("nobody", "default"))
