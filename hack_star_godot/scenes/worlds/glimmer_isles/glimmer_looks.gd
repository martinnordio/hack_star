@tool
class_name GlimmerLooks
extends RefCounted
## Glimmer Isles' colours by colour variation (spec 09, P2, P3, P5, H2, D45): per variation a
## table **role → look**. A role is a surface of the world (`ground`, `path`, `rim`, …), a prop
## part as `<kind>/<part name>` (`crystal_cluster/Spike`, the names of `GlimmerProp`) or a piece
## of decoration (`firefly`, `waterfall`). A look is `{albedo, glow, glow_strength}` or a pack
## material (`{material: "<name>"}`, `scenes/glimmer_isles/materials/<name>.tres`, made toon by
## `ToonMaterials.from_material`). **Original** is the look before the palette, value for value;
## **Glimmer** uses only `GlimmerPalette` colours and the pack's materials.

const ORIGINAL: String = ColourVariations.ORIGINAL
const GLIMMER: String = ColourVariations.GLIMMER
## The variation a game starts with (spec 09 H1).
const DEFAULT: String = ColourVariations.DEFAULT
const MATERIALS_DIR: String = "res://scenes/glimmer_isles/materials/"
## The variations lit by the pack's lighting scene (its sky, environment and sun).
const PACK_LIGHTING: Array[String] = [GLIMMER]

## The parts of each prop kind in the order `GlimmerProp` builds them (the bake's `part_index`).
const PARTS: Dictionary[String, Array] = {
	"crystal_cluster": ["Rock", "Spike", "SpikeLeft", "SpikeRight"],
	"glow_fern": ["Frond", "FrondLeft", "FrondRight", "FrondBack", "TipLeft", "TipBack"],
	"small_mushroom": ["Stem", "Cap"],
	"giant_mushroom": ["Stem", "Gills", "Cap"],
	"island_chunk": ["Grass", "Rock", "RootLeft", "RootRight"],
}

## The look before this palette (spec 09 Steps 13 and 26), pinned by a test. `jitter`: how much a
## ground tile may be lightened at random.
const ORIGINAL_LOOKS: Dictionary[String, Dictionary] = {
	"ground": {"albedo": Color("74bccb"), "jitter": 0.05},
	"ground_alt": {"albedo": Color("a294dc"), "jitter": 0.05},
	"path": {"albedo": Color("c8fbff"), "glow": Color("5fe8ff"), "glow_strength": 0.6},
	"rim": {"albedo": Color("4aa892")},
	"underside": {"albedo": Color("6446c4")},
	"border": {"albedo": Color("7b56dc")},
	"border_top": {"albedo": Color("5434b0")},
	"plinth": {"albedo": Color("5434b0")},
	"fern_ground": {"albedo": Color("2c9c78")},
	"crystal_cluster/Rock": {"albedo": Color("5434b0")},
	"crystal_cluster/Spike":
	{"albedo": Color("4feaff"), "glow": Color("1fc2ff"), "glow_strength": 0.5},
	"crystal_cluster/SpikeLeft":
	{"albedo": Color("ff5cd6"), "glow": Color("ff2fbe"), "glow_strength": 0.5},
	"crystal_cluster/SpikeRight":
	{"albedo": Color("4feaff"), "glow": Color("1fc2ff"), "glow_strength": 0.5},
	"glow_fern/Frond": {"albedo": Color("1fcf80")},
	"glow_fern/FrondLeft": {"albedo": Color("4ff2a4")},
	"glow_fern/FrondRight": {"albedo": Color("1fcf80")},
	"glow_fern/FrondBack": {"albedo": Color("4ff2a4")},
	"glow_fern/TipLeft": {"albedo": Color("d4ff4f"), "glow": Color("d4ff4f"), "glow_strength": 0.8},
	"glow_fern/TipBack": {"albedo": Color("d4ff4f"), "glow": Color("d4ff4f"), "glow_strength": 0.8},
	"small_mushroom/Stem": {"albedo": Color("fbecc6")},
	"small_mushroom/Cap":
	{"albedo": Color("c444ff"), "glow": Color("9b2dff"), "glow_strength": 0.35},
	"giant_mushroom/Stem": {"albedo": Color("fbecc6")},
	"giant_mushroom/Gills": {"albedo": Color("ffc8e8")},
	"giant_mushroom/Cap":
	{"albedo": Color("ff55a8"), "glow": Color("ff2f8f"), "glow_strength": 0.3},
	"island_chunk/Grass": {"albedo": Color("55e0a6")},
	"island_chunk/Rock": {"albedo": Color("7b56dc")},
	"island_chunk/RootLeft": {"albedo": Color("3d2a8c")},
	"island_chunk/RootRight": {"albedo": Color("3d2a8c")},
	"firefly": {"albedo": Color("e6ff6a")},
	"waterfall": {"albedo": Color(0.45, 0.9, 1.0, 0.85)},
	"waterfall_light": {"albedo": Color("f0ffff")},
	"sky_top": {"albedo": Color("1b1446")},
	"sky_horizon": {"albedo": Color("c77ad6")},
	"void_deep": {"albedo": Color("140f38")},
	"void_horizon": {"albedo": Color("6a4fb8")},
	"ambient": {"albedo": Color("b8a8ff")},
	"sun": {"albedo": Color("fff0ff")},
}

## The author's palette pack: the floor in calm mid-tones (the least saturated surface, G10),
## stone walls, glowing crystals and mushrooms, the pack's materials where one matches; only the
## glowing parts glow, in Glow Mushrooms and Glimmer Gold colours. Its sky and light are the
## pack's lighting scene (`PACK_LIGHTING`), so it has no sky roles.
const GLIMMER_LOOKS: Dictionary[String, Dictionary] = {
	"ground": {"albedo": GlimmerPalette.PEBBLE},
	"ground_alt": {"albedo": GlimmerPalette.STONE_LIGHT},
	"path": {"material": "sand"},
	"rim": {"material": "leaf"},
	"underside": {"albedo": GlimmerPalette.CLIFF},
	"border": {"material": "stone"},
	"border_top": {"albedo": GlimmerPalette.STONE_LIGHT},
	"plinth": {"albedo": GlimmerPalette.STONE_SHADOW},
	"fern_ground": {"albedo": GlimmerPalette.FERN},
	"lagoon": {"material": "water"},
	"lagoon_light": {"albedo": GlimmerPalette.TURQUOISE},
	"crystal_cluster/Rock": {"material": "stone"},
	"crystal_cluster/Spike":
	{"albedo": GlimmerPalette.GLOW_CYAN, "glow": GlimmerPalette.GLOW_CYAN, "glow_strength": 0.5},
	"crystal_cluster/SpikeLeft":
	{"albedo": GlimmerPalette.GLOW_LILAC, "glow": GlimmerPalette.GLOW_LILAC, "glow_strength": 0.5},
	"crystal_cluster/SpikeRight": {"material": "crystal_gold"},
	"glow_fern/Frond": {"material": "leaf"},
	"glow_fern/FrondLeft": {"material": "moss"},
	"glow_fern/FrondRight": {"material": "leaf"},
	"glow_fern/FrondBack": {"material": "moss"},
	"glow_fern/TipLeft":
	{"albedo": GlimmerPalette.GLOW_LIME, "glow": GlimmerPalette.GLOW_LIME, "glow_strength": 0.8},
	"glow_fern/TipBack":
	{"albedo": GlimmerPalette.GLOW_LIME, "glow": GlimmerPalette.GLOW_LIME, "glow_strength": 0.8},
	"small_mushroom/Stem": {"material": "mushroom_stem"},
	"small_mushroom/Cap": {"material": "glow_mushroom"},
	"giant_mushroom/Stem": {"material": "mushroom_stem"},
	"giant_mushroom/Gills": {"albedo": GlimmerPalette.PINK_SPOT},
	"giant_mushroom/Cap": {"material": "mushroom_cap"},
	"island_chunk/Grass": {"material": "grass"},
	"island_chunk/Rock": {"material": "stone"},
	"island_chunk/RootLeft": {"albedo": GlimmerPalette.ROOT_DARK},
	"island_chunk/RootRight": {"albedo": GlimmerPalette.ROOT_DARK},
	"firefly": {"albedo": GlimmerPalette.GLOW_LIME},
	"waterfall": {"material": "waterfall"},
	"waterfall_light": {"albedo": GlimmerPalette.FOAM},
}


## The variations that have a table here.
static func variations() -> Array[String]:
	return [ORIGINAL, GLIMMER]


## The roles of a variation's table.
static func roles(variation: String = DEFAULT) -> Array[String]:
	var result: Array[String] = []
	result.assign(_table(variation).keys())
	return result


static func has_role(role: String, variation: String = DEFAULT) -> bool:
	return _table(variation).has(role)


## The role of a baked prop part: its kind and its `part_index`.
static func part_role(kind: String, part_index: int) -> String:
	return "%s/%s" % [kind, PARTS[kind][part_index]]


## The look of a role: `albedo` (alpha included), `glow`, `glow_strength` and `jitter`, taken
## from the pack material when the role names one.
static func look(role: String, variation: String = DEFAULT) -> Dictionary:
	return look_of(_table(variation)[role])


## The look of one table entry (also `CanyonLooks`'): its own colours or its pack material's.
static func look_of(entry: Dictionary) -> Dictionary:
	var result: Dictionary = {
		"albedo": entry.get("albedo", Color.WHITE),
		"glow": entry.get("glow", Color.BLACK),
		"glow_strength": entry.get("glow_strength", 0.0),
		"jitter": entry.get("jitter", 0.0),
	}
	if entry.has("material"):
		var material: BaseMaterial3D = pack_material(entry["material"])
		result["albedo"] = material.albedo_color
		if material.emission_enabled:
			result["glow"] = material.emission
			result["glow_strength"] = (
				material.emission_energy_multiplier * ToonMaterials.PACK_GLOW_SHARE
			)
	return result


## The albedo of a role.
static func color(role: String, variation: String = DEFAULT) -> Color:
	return look(role, variation)["albedo"]


## The shared cel-shaded material of a role (`ToonMaterials`), outlined or not.
static func material(
	role: String, variation: String = DEFAULT, outlined: bool = true
) -> ShaderMaterial:
	return material_of(_table(variation)[role], outlined)


## The shared cel-shaded material of one table entry (also `CanyonLooks`').
static func material_of(entry: Dictionary, outlined: bool = true) -> ShaderMaterial:
	if entry.has("material"):
		return ToonMaterials.from_material(pack_material(entry["material"]), outlined)
	var result: Dictionary = look_of(entry)
	return ToonMaterials.toon(result["albedo"], result["glow"], result["glow_strength"], outlined)


## Whether a variation is lit by the pack's lighting scene (`GlimmerIsles`).
static func uses_pack_lighting(variation: String = DEFAULT) -> bool:
	return variation in PACK_LIGHTING


## One of the pack's materials by name (`water`, `stone`, …).
static func pack_material(material_name: String) -> BaseMaterial3D:
	return load(MATERIALS_DIR + material_name + ".tres")


# The table of a variation; one without a table of its own looks like Original.
static func _table(variation: String) -> Dictionary[String, Dictionary]:
	if variation == GLIMMER:
		return GLIMMER_LOOKS
	return ORIGINAL_LOOKS
