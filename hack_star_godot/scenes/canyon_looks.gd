class_name CanyonLooks
extends RefCounted
## The canyon's colours by colour variation (spec 09, H2, H3, D48), like `GlimmerLooks`: per
## variation a table **role → look** (`{albedo, glow, glow_strength}` or a pack material,
## `{material: "<name>"}`). A role is a surface or prop of the canyon (`sand`, `rock`, `cactus`,
## `blossom_0`, …) or of its decoration (`flag_0`, `bird`, `stream`, …). **Original** is the look
## before this reopening, value for value; **Glimmer** is the same (the palette is Glimmer Isles',
## H3); a variation without a table of its own looks like Original.

## The look before this reopening (spec 09 Step 38's notes), pinned by a test.
const ORIGINAL_LOOKS: Dictionary[String, Dictionary] = {
	"sand": {"albedo": Color("d6ad7e")},
	"sand_dark": {"albedo": Color("cb9f6e")},
	"outside": {"albedo": Color("cf7b4c")},
	"rock": {"albedo": Color("e65a2a")},
	"rock_band": {"albedo": Color("ff9a4f")},
	"rock_top": {"albedo": Color("a83a20")},
	"boulder": {"albedo": Color("bf4f2a")},
	"boulder_light": {"albedo": Color("ee7c3e")},
	"bush_ground": {"albedo": Color("9fc05a")},
	"cactus": {"albedo": Color("3fd35c")},
	"cactus_dark": {"albedo": Color("1fa848")},
	"flower": {"albedo": Color("ff4f9e")},
	"blossom_0": {"albedo": Color("ffd23f")},
	"blossom_1": {"albedo": Color("ff8a3d")},
	"blossom_2": {"albedo": Color("ff6fd0")},
	"crate": {"albedo": Color("d98c35")},
	"crate_edge": {"albedo": Color("7a4620")},
	"bone": {"albedo": Color("fff6e0")},
	"eye": {"albedo": Color("2a1d1d")},
	"pebble": {"albedo": Color("b98a5e")},
	"flag_0": {"albedo": Color("ff3b5c")},
	"flag_1": {"albedo": Color("ffd23f")},
	"flag_2": {"albedo": Color("23c9b8")},
	"pole": {"albedo": Color("7a4620")},
	"bird": {"albedo": Color("3b2b3f")},
	"stream": {"albedo": Color("27d3c3")},
	"stream_light": {"albedo": Color("c8fff6")},
}

## **Lagoon** (spec 09 H4, D49): the canyon as an oasis by a lagoon — a checker of mint grass and
## sand (beach and shell, D49's first choice, washed to white under the bright presets, and sand
## alone looked like Original's floor on Step 42's screenshots), walls of path rock with a
## turquoise band and earth tops, shallow water all around, jade and leaf cacti with bubblegum
## blossoms, the stream in deep lagoon water.
const LAGOON_LOOKS: Dictionary[String, Dictionary] = {
	"sand": {"albedo": GlimmerPalette.MINT},
	"sand_dark": {"albedo": GlimmerPalette.SAND},
	"outside": {"albedo": GlimmerPalette.SHALLOW_WATER},
	"rock": {"albedo": GlimmerPalette.PATH},
	"rock_band": {"albedo": GlimmerPalette.TURQUOISE},
	"rock_top": {"albedo": GlimmerPalette.EARTH},
	"boulder": {"albedo": GlimmerPalette.PATH},
	"boulder_light": {"albedo": GlimmerPalette.SAND},
	"bush_ground": {"albedo": GlimmerPalette.SPRING},
	"cactus": {"albedo": GlimmerPalette.JADE},
	"cactus_dark": {"albedo": GlimmerPalette.LEAF},
	"flower": {"albedo": GlimmerPalette.BUBBLEGUM},
	"blossom_0": {"albedo": GlimmerPalette.BUBBLEGUM},
	"blossom_1": {"albedo": GlimmerPalette.PINK_SPOT},
	"blossom_2": {"albedo": GlimmerPalette.SUNBEAM},
	"crate": {"albedo": GlimmerPalette.STEM},
	"crate_edge": {"albedo": GlimmerPalette.BARK},
	"bone": {"albedo": GlimmerPalette.IVORY},
	"eye": {"albedo": GlimmerPalette.ROOT_DARK},
	"pebble": {"albedo": GlimmerPalette.STEM_LIGHT},
	"flag_0": {"albedo": GlimmerPalette.BUBBLEGUM},
	"flag_1": {"albedo": GlimmerPalette.SUNBEAM},
	"flag_2": {"albedo": GlimmerPalette.TURQUOISE},
	"pole": {"albedo": GlimmerPalette.BARK},
	"bird": {"albedo": GlimmerPalette.DEEP_LAGOON},
	"stream": {"albedo": GlimmerPalette.LAGOON},
	"stream_light": {"albedo": GlimmerPalette.FOAM},
}

## **Glow night** (spec 09 H4, D49): the canyon at night — cliff and stone-shadow rock, pebble
## and stone sand, fern cacti with glowing lime flowers and lilac, cyan and lime blossoms,
## glowing skull eyes and flags, the stream glowing cyan.
const GLOW_NIGHT_LOOKS: Dictionary[String, Dictionary] = {
	"sand": {"albedo": GlimmerPalette.PEBBLE},
	"sand_dark": {"albedo": GlimmerPalette.STONE},
	"outside": {"albedo": GlimmerPalette.STONE_SHADOW},
	"rock": {"albedo": GlimmerPalette.CLIFF},
	"rock_band": {"albedo": GlimmerPalette.TWILIGHT},
	"rock_top": {"albedo": GlimmerPalette.STONE_SHADOW},
	"boulder": {"albedo": GlimmerPalette.CLIFF},
	"boulder_light": {"albedo": GlimmerPalette.TWILIGHT},
	"bush_ground": {"albedo": GlimmerPalette.MOSS_SHADOW},
	"cactus": {"albedo": GlimmerPalette.FERN},
	"cactus_dark": {"albedo": GlimmerPalette.MOSS_SHADOW},
	"flower":
	{"albedo": GlimmerPalette.GLOW_LIME, "glow": GlimmerPalette.GLOW_LIME, "glow_strength": 0.8},
	"blossom_0":
	{"albedo": GlimmerPalette.GLOW_LILAC, "glow": GlimmerPalette.GLOW_LILAC, "glow_strength": 0.8},
	"blossom_1":
	{"albedo": GlimmerPalette.GLOW_CYAN, "glow": GlimmerPalette.GLOW_CYAN, "glow_strength": 0.8},
	"blossom_2":
	{"albedo": GlimmerPalette.GLOW_LIME, "glow": GlimmerPalette.GLOW_LIME, "glow_strength": 0.8},
	"crate": {"albedo": GlimmerPalette.BARK},
	"crate_edge": {"albedo": GlimmerPalette.EARTH_DARK},
	"bone": {"albedo": GlimmerPalette.STONE_LIGHT},
	"eye":
	{"albedo": GlimmerPalette.GLOW_LIME, "glow": GlimmerPalette.GLOW_LIME, "glow_strength": 0.8},
	"pebble": {"albedo": GlimmerPalette.STONE},
	"flag_0": {"albedo": GlimmerPalette.GLOW_LILAC},
	"flag_1": {"albedo": GlimmerPalette.GOLD},
	"flag_2": {"albedo": GlimmerPalette.GLOW_CYAN},
	"pole": {"albedo": GlimmerPalette.BARK},
	"bird": {"albedo": GlimmerPalette.NIGHT_SKY},
	"stream": {"albedo": GlimmerPalette.DEEP_LAGOON},
	"stream_light": {"albedo": GlimmerPalette.GLOW_CYAN},
}

## The own light of Lagoon and Glow night: the pack's environment and sun with these sky and
## light colours (`WorldLighting.use_pack_light`, as `GlimmerLooks.LIGHTS`); Original and Glimmer
## keep the arena's own warm light.
const LIGHTS: Dictionary[String, Dictionary] = {
	ColourVariations.LAGOON: GlimmerLooks.LIGHTS[ColourVariations.LAGOON],
	ColourVariations.GLOW_NIGHT: GlimmerLooks.LIGHTS[ColourVariations.GLOW_NIGHT],
}

## How many blossom and flag colours there are (`blossom_<n>`, `flag_<n>`).
const BLOSSOM_COUNT: int = 3
const FLAG_COUNT: int = 3


## The variations that have a table of their own here (Glimmer looks like Original, H3).
static func variations() -> Array[String]:
	return [ColourVariations.ORIGINAL, ColourVariations.LAGOON, ColourVariations.GLOW_NIGHT]


## The roles of a variation's table.
static func roles(variation: String = ColourVariations.DEFAULT) -> Array[String]:
	var result: Array[String] = []
	result.assign(_table(variation).keys())
	return result


## The look of a role: `albedo`, `glow`, `glow_strength` (`GlimmerLooks.look_of`).
static func look(role: String, variation: String = ColourVariations.DEFAULT) -> Dictionary:
	return GlimmerLooks.look_of(_table(variation)[role])


## The albedo of a role.
static func color(role: String, variation: String = ColourVariations.DEFAULT) -> Color:
	return look(role, variation)["albedo"]


## The shared cel-shaded material of a role (`ToonMaterials`), outlined or not.
static func material(
	role: String, variation: String = ColourVariations.DEFAULT, outlined: bool = true
) -> ShaderMaterial:
	return GlimmerLooks.material_of(_table(variation)[role], outlined)


## The variation's own sky and light over the pack's light (`LIGHTS`), or none (the arena's own).
static func light(variation: String = ColourVariations.DEFAULT) -> Dictionary:
	return LIGHTS.get(variation, {})


# The table of a variation; Glimmer looks like Original (H3).
static func _table(variation: String) -> Dictionary[String, Dictionary]:
	match variation:
		ColourVariations.LAGOON:
			return LAGOON_LOOKS
		ColourVariations.GLOW_NIGHT:
			return GLOW_NIGHT_LOOKS
	return ORIGINAL_LOOKS
