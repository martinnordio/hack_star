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

## How many blossom and flag colours there are (`blossom_<n>`, `flag_<n>`).
const BLOSSOM_COUNT: int = 3
const FLAG_COUNT: int = 3


## The variations that have a table here (the others look like Original).
static func variations() -> Array[String]:
	return [ColourVariations.ORIGINAL]


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


# The table of a variation; Glimmer and the variations without a table look like Original.
static func _table(_variation: String) -> Dictionary[String, Dictionary]:
	return ORIGINAL_LOOKS
