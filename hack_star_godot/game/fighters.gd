class_name Fighters
extends RefCounted
## The catalogue: the 6 original fighters of Hack star with their rarity, their skins and who is
## unlocked at the start, then the fighters drawn by children (`"drawn": true`, one Default skin,
## rarity and numbers copied from the fighter they play like, `"plays_like"`; their look is in
## `scenes/drawn/`, spec 09 D14), then the picture fighters (`"cutout": true`, one Default skin,
## the start numbers of the fighter they play like, their own rarity; shown as the author's
## pictures through `scenes/cutout/`, spec 09 D20, D21). Skins of rarity "" are the Default look.

const DEFAULT_SKIN: String = "default"
const LIST: Array[Dictionary] = [
	{
		"id": "blaze",
		"name": "Blaze",
		"rarity": "Rare",
		"idea": "Girl with fire powers",
		"unlocked": true,
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
			{"id": "lava", "name": "Lava", "rarity": "Epic"},
			{"id": "phoenix", "name": "Phoenix", "rarity": "Legendary"},
		],
	},
	{
		"id": "rocko",
		"name": "Rocko",
		"rarity": "Rare",
		"idea": "Friendly rock golem, a tank",
		"unlocked": true,
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
			{"id": "crystal", "name": "Crystal", "rarity": "Epic"},
		],
	},
	{
		"id": "turbo",
		"name": "Turbo",
		"rarity": "Super Rare",
		"idea": "Fast racing kid with a helmet",
		"unlocked": true,
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
			{"id": "neon", "name": "Neon", "rarity": "Mythic"},
		],
	},
	{
		"id": "frosty",
		"name": "Frosty",
		"rarity": "Epic",
		"idea": "Small ice yeti",
		"unlocked": false,
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
			{"id": "snow_king", "name": "Snow King", "rarity": "Legendary"},
		],
	},
	{
		"id": "luna",
		"name": "Luna",
		"rarity": "Mythic",
		"idea": "Space cat with a ray gun",
		"unlocked": false,
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
			{"id": "galaxy", "name": "Galaxy", "rarity": "Mythic"},
			{"id": "supernova", "name": "Supernova", "rarity": "Legendary"},
		],
	},
	{
		"id": "pixel",
		"name": "Pixel",
		"rarity": "Legendary",
		"idea": "Hacker robot, the face of Hack star",
		"unlocked": false,
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
			{"id": "glitch", "name": "Glitch", "rarity": "Legendary"},
		],
	},
	{
		"id": "beatbolt",
		"name": "Beatbolt",
		"rarity": "Mythic",
		"idea": "Mattia's drawing: kid with big headphones and an arm cannon",
		"unlocked": true,
		"drawn": true,
		"plays_like": "luna",
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
		],
	},
	{
		"id": "flarekid",
		"name": "Flarekid",
		"rarity": "Legendary",
		"idea": "The hero upgrade of Blaze: a kid whose hood is a flame",
		"unlocked": true,
		"cutout": true,
		"plays_like": "blaze",
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
		],
	},
	{
		"id": "echo",
		"name": "Echo",
		"rarity": "Mythic",
		"idea": "Mattia's drawing: a sound-powered hero with a sound blaster",
		"unlocked": true,
		"cutout": true,
		"plays_like": "luna",
		"skins":
		[
			{"id": "default", "name": "Default", "rarity": ""},
		],
	},
]


## The ids of all fighters, in catalogue order.
static func ids() -> Array[String]:
	var result: Array[String] = []
	for fighter: Dictionary in LIST:
		result.append(fighter["id"])
	return result


## The fighter with this id, or an empty dictionary for an unknown id.
static func get_fighter(fighter_id: String) -> Dictionary:
	for fighter: Dictionary in LIST:
		if fighter["id"] == fighter_id:
			return fighter
	return {}


## The skin of a fighter, or an empty dictionary when the fighter or the skin is unknown.
static func get_skin(fighter_id: String, skin_id: String) -> Dictionary:
	var skins: Array = get_fighter(fighter_id).get("skins", [])
	for skin: Dictionary in skins:
		if skin["id"] == skin_id:
			return skin
	return {}


static func has_skin(fighter_id: String, skin_id: String) -> bool:
	return not get_skin(fighter_id, skin_id).is_empty()


## The ids of the fighters that are unlocked at the start of the game.
static func start_unlocked() -> Array[String]:
	var result: Array[String] = []
	for fighter: Dictionary in LIST:
		if fighter["unlocked"]:
			result.append(fighter["id"])
	return result
