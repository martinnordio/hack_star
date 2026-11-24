class_name LightPresets
extends RefCounted
## The lighting presets of Training and a match (spec 09, L3–L6, D27), in the order `L` goes
## through them, and the saturation boost of `K`. `WorldLighting` applies them to the arena; each
## world keeps a share of its own colours (`WORLD_SHARE`). **Classic** is the world's own light
## from before the reopening, to compare.
##
## Per preset: `sun_color`, `sun_energy`, `sun_pitch_degrees` (how high the sun stands);
## `ambient_color`, `ambient_energy`; the sky's `sky_top`, `sky_horizon` and `sky_ground`; the
## colour balance `brightness`, `contrast`, `saturation`; `glow` (bloom of the brightest parts);
## `pack_sky` (only Bright day): over the pack's light as delivered (Glimmer Isles in Glimmer) the
## pack's sky shows instead of the preset's (spec 09 P4, D58).

const BRIGHT_DAY: String = "bright_day"
const GOLDEN_SUNSET: String = "golden_sunset"
const NEON_NIGHT: String = "neon_night"
const CANDY_POP: String = "candy_pop"
const CLASSIC: String = "classic"
## The preset a game starts with (L6), chosen from screenshots in Step 27 (D27).
const DEFAULT: String = BRIGHT_DAY
## `K` multiplies the preset's saturation by this (L4).
const BOOST_SATURATION: float = 1.3
## How much of the world's own sun, ambient and sky colour stays in a preset's colours.
const WORLD_SHARE: float = 0.3
const LIST: Array[Dictionary] = [
	{
		"id": BRIGHT_DAY,
		"name": "Bright day",
		"sun_color": Color("fff4e0"),
		"sun_energy": 0.85,
		"sun_pitch_degrees": 62.0,
		"ambient_color": Color("cfe4ff"),
		"ambient_energy": 0.45,
		"sky_top": Color("3d9bff"),
		"sky_horizon": Color("bfe8ff"),
		"sky_ground": Color("a8d8ff"),
		"brightness": 1.0,
		"contrast": 1.08,
		"saturation": 1.2,
		"glow": false,
		"pack_sky": true,
	},
	{
		"id": GOLDEN_SUNSET,
		"name": "Golden sunset",
		"sun_color": Color("ffae5c"),
		"sun_energy": 1.0,
		"sun_pitch_degrees": 30.0,
		"ambient_color": Color("ff9aa8"),
		"ambient_energy": 0.45,
		"sky_top": Color("4b2c86"),
		"sky_horizon": Color("ff9a52"),
		"sky_ground": Color("c2506a"),
		"brightness": 1.0,
		"contrast": 1.08,
		"saturation": 1.25,
		"glow": false,
	},
	{
		"id": NEON_NIGHT,
		"name": "Neon night",
		"sun_color": Color("6f7dff"),
		"sun_energy": 0.45,
		"sun_pitch_degrees": 50.0,
		"ambient_color": Color("7050e8"),
		"ambient_energy": 0.5,
		"sky_top": Color("070425"),
		"sky_horizon": Color("3b1680"),
		"sky_ground": Color("12063a"),
		"brightness": 0.9,
		"contrast": 1.12,
		"saturation": 1.2,
		"glow": true,
	},
	{
		"id": CANDY_POP,
		"name": "Candy pop",
		"sun_color": Color("ffe8f6"),
		"sun_energy": 0.85,
		"sun_pitch_degrees": 58.0,
		"ambient_color": Color("ffb0e6"),
		"ambient_energy": 0.5,
		"sky_top": Color("ff8fd8"),
		"sky_horizon": Color("aef2ff"),
		"sky_ground": Color("ffd0f0"),
		"brightness": 1.0,
		"contrast": 1.02,
		"saturation": 1.4,
		"glow": false,
	},
	{
		"id": CLASSIC,
		"name": "Classic",
		"brightness": 1.0,
		"contrast": 1.0,
		"saturation": 1.0,
		"glow": false,
	},
]


## The ids of every preset, in the order of `LIST`.
static func ids() -> Array[String]:
	var result: Array[String] = []
	for preset: Dictionary in LIST:
		result.append(preset["id"])
	return result


## The preset with this id, or the default for an unknown id.
static func get_preset(preset_id: String) -> Dictionary:
	for preset: Dictionary in LIST:
		if preset["id"] == preset_id:
			return preset
	return get_preset(DEFAULT)


## The preset after this one (`L`), back to the first after the last.
static func next(preset_id: String) -> String:
	var all: Array[String] = ids()
	return all[(all.find(preset_id) + 1) % all.size()]


## The preset's name as the player sees it.
static func preset_name(preset_id: String) -> String:
	return get_preset(preset_id)["name"]


## Whether the preset keeps the world's own light (Classic).
static func is_world_own(preset_id: String) -> bool:
	return not get_preset(preset_id).has("sun_color")


## The saturation of the colour balance with the preset and the boost.
static func saturation(preset_id: String, boost: bool) -> float:
	var value: float = get_preset(preset_id)["saturation"]
	return value * BOOST_SATURATION if boost else value


## What the toast says after `K`.
static func boost_text(boost: bool) -> String:
	return "Saturation boost on" if boost else "Saturation boost off"
