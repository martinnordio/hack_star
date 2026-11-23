class_name ColourVariations
extends RefCounted
## The colour variations of Training and a match (spec 09, H1–H6, D48), in the order `C` goes
## through them (numbers 1–4). Each world takes its colours for a variation from its own table
## (`GlimmerLooks`, `CanyonLooks`); the lighting presets and the boost apply on top (H6).

const ORIGINAL: String = "original"
const GLIMMER: String = "glimmer"
const LAGOON: String = "lagoon"
const GLOW_NIGHT: String = "glow_night"
## The variation a game starts with (H1).
const DEFAULT: String = GLIMMER
const LIST: Array[Dictionary] = [
	{"id": ORIGINAL, "name": "Original"},
	{"id": GLIMMER, "name": "Glimmer"},
	{"id": LAGOON, "name": "Lagoon"},
	{"id": GLOW_NIGHT, "name": "Glow night"},
]


## The ids of every variation, in `C`'s order.
static func ids() -> Array[String]:
	var result: Array[String] = []
	for variation: Dictionary in LIST:
		result.append(variation["id"])
	return result


## Whether `variation_id` is a variation.
static func has(variation_id: String) -> bool:
	return ids().has(variation_id)


## The variation after this one (`C`), back to the first after the last.
static func next(variation_id: String) -> String:
	var all: Array[String] = ids()
	return all[(all.find(variation_id) + 1) % all.size()]


## The variation's number (1–4).
static func number(variation_id: String) -> int:
	return ids().find(variation_id) + 1


## The variation's name as the player sees it.
static func variation_name(variation_id: String) -> String:
	return LIST[ids().find(variation_id)]["name"]


## What the toast says after `C` (H5): "Colours 2: Glimmer".
static func title(variation_id: String) -> String:
	return "Colours %d: %s" % [number(variation_id), variation_name(variation_id)]
