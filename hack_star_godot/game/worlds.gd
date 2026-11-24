class_name Worlds
extends RefCounted
## The worlds a match or Training can be played in (spec 09, W1, W2, D9): the canyon and
## Glimmer Isles, both unlocked for every account from the start, so the save has no field for
## them. World coins, prices, sizes and more worlds are spec 18.

const CANYON: String = "canyon"
const GLIMMER_ISLES: String = "glimmer_isles"
## In the order the world choice shows them; the first is the default.
const LIST: Array[Dictionary] = [
	{"id": CANYON, "name": "Canyon"},
	{"id": GLIMMER_ISLES, "name": "Glimmer Isles"},
]


## The ids of every world, in the order of `LIST`.
static func ids() -> Array[String]:
	var result: Array[String] = []
	for world: Dictionary in LIST:
		result.append(world["id"])
	return result


## The world with this id (`{id, name}`), or an empty dictionary for an unknown id.
static func get_world(world_id: String) -> Dictionary:
	for world: Dictionary in LIST:
		if world["id"] == world_id:
			return world
	return {}


## Every known world is unlocked from the start (W1).
static func is_unlocked(world_id: String) -> bool:
	return not get_world(world_id).is_empty()
