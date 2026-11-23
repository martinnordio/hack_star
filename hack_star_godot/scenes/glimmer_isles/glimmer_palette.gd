## Glimmer Isles world palette. Use: GlimmerPalette.LAGOON, GlimmerPalette.ALL["lagoon"]
class_name GlimmerPalette
extends RefCounted

# --- Lagoon Water
const DEEP_LAGOON := Color(0.0431, 0.2353, 0.3647, 1)  # #0B3C5D
const LAGOON := Color(0.0549, 0.4314, 0.5490, 1)  # #0E6E8C
const SHALLOW_WATER := Color(0.0784, 0.6392, 0.7216, 1)  # #14A3B8
const TURQUOISE := Color(0.2471, 0.8157, 0.8314, 1)  # #3FD0D4
const WATERFALL_LIGHT := Color(0.5451, 0.9373, 0.9020, 1)  # #8BEFE6
const FOAM := Color(0.8784, 1.0000, 0.9843, 1)  # #E0FFFB

# --- Sky & Mist
const NIGHT_SKY := Color(0.1647, 0.1373, 0.3137, 1)  # #2A2350
const TWILIGHT := Color(0.2941, 0.2471, 0.5490, 1)  # #4B3F8C
const DREAM_VIOLET := Color(0.4863, 0.4353, 0.8392, 1)  # #7C6FD6
const DAY_SKY := Color(0.6627, 0.7843, 1.0000, 1)  # #A9C8FF
const BLUSH_CLOUD := Color(1.0000, 0.8392, 0.9098, 1)  # #FFD6E8
const SUN_MIST := Color(1.0000, 0.9569, 0.8392, 1)  # #FFF4D6

# --- Leaves & Grass
const DEEP_JUNGLE := Color(0.0706, 0.2078, 0.1686, 1)  # #12352B
const FOREST := Color(0.1216, 0.3686, 0.2314, 1)  # #1F5E3B
const LEAF := Color(0.1804, 0.5451, 0.2784, 1)  # #2E8B47
const GRASS := Color(0.3608, 0.7569, 0.3098, 1)  # #5CC14F
const SPRING := Color(0.6510, 0.8902, 0.3529, 1)  # #A6E35A
const SUNLIT_LEAF := Color(0.8941, 0.9765, 0.5451, 1)  # #E4F98B

# --- Ferns & Moss
const MOSS_SHADOW := Color(0.0588, 0.2902, 0.2784, 1)  # #0F4A47
const FERN := Color(0.1059, 0.4784, 0.4314, 1)  # #1B7A6E
const JADE := Color(0.1843, 0.7020, 0.6039, 1)  # #2FB39A
const MINT := Color(0.4353, 0.8784, 0.7529, 1)  # #6FE0C0
const DEW := Color(0.7216, 0.9608, 0.8784, 1)  # #B8F5E0
const PALE_MINT := Color(0.9020, 1.0000, 0.9608, 1)  # #E6FFF5

# --- Mushroom Caps
const BERRY_SHADOW := Color(0.3529, 0.0941, 0.2745, 1)  # #5A1846
const PLUM_CAP := Color(0.6078, 0.1765, 0.4353, 1)  # #9B2D6F
const MAGENTA_CAP := Color(0.8392, 0.2706, 0.5608, 1)  # #D6458F
const BUBBLEGUM := Color(1.0000, 0.4667, 0.7176, 1)  # #FF77B7
const PINK_SPOT := Color(1.0000, 0.7020, 0.8510, 1)  # #FFB3D9
const CAP_HIGHLIGHT := Color(1.0000, 0.8902, 0.9451, 1)  # #FFE3F1

# --- Glow Mushrooms
const GLOW_DEEP := Color(0.2314, 0.1176, 0.4667, 1)  # #3B1E77
const GLOW_VIOLET := Color(0.4157, 0.2471, 0.8196, 1)  # #6A3FD1
const GLOW_LILAC := Color(0.6157, 0.4824, 1.0000, 1)  # #9D7BFF
const GLOW_CYAN := Color(0.3098, 0.9490, 0.8902, 1)  # #4FF2E3
const GLOW_LIME := Color(0.7765, 1.0000, 0.4196, 1)  # #C6FF6B
const GLOW_CORE := Color(0.9569, 1.0000, 0.9882, 1)  # #F4FFFC

# --- Stems & Roots
const ROOT_DARK := Color(0.2431, 0.1647, 0.1412, 1)  # #3E2A24
const BARK := Color(0.4196, 0.3059, 0.2392, 1)  # #6B4E3D
const STEM := Color(0.6510, 0.4863, 0.3569, 1)  # #A67C5B
const STEM_LIGHT := Color(0.8510, 0.7059, 0.5608, 1)  # #D9B48F
const CREAM := Color(0.9490, 0.8745, 0.7608, 1)  # #F2DFC2
const IVORY := Color(1.0000, 0.9647, 0.9020, 1)  # #FFF6E6

# --- Cliffs & Stone
const STONE_SHADOW := Color(0.1373, 0.1373, 0.2275, 1)  # #23233A
const CLIFF := Color(0.2314, 0.2392, 0.3608, 1)  # #3B3D5C
const STONE := Color(0.3608, 0.3804, 0.5216, 1)  # #5C6185
const PEBBLE := Color(0.5294, 0.5647, 0.6902, 1)  # #8790B0
const STONE_LIGHT := Color(0.7255, 0.7608, 0.8510, 1)  # #B9C2D9
const STONE_GLINT := Color(0.8902, 0.9098, 0.9608, 1)  # #E3E8F5

# --- Sand & Paths
const EARTH_DARK := Color(0.2902, 0.1804, 0.1647, 1)  # #4A2E2A
const EARTH := Color(0.4784, 0.2941, 0.2078, 1)  # #7A4B35
const PATH := Color(0.6902, 0.4784, 0.3098, 1)  # #B07A4F
const SAND := Color(0.8667, 0.6824, 0.4549, 1)  # #DDAE74
const BEACH := Color(0.9490, 0.8314, 0.6078, 1)  # #F2D49B
const SHELL := Color(1.0000, 0.9412, 0.7882, 1)  # #FFF0C9

# --- Glimmer Gold
const AMBER_DARK := Color(0.5412, 0.2941, 0.0000, 1)  # #8A4B00
const AMBER := Color(0.8510, 0.5412, 0.0000, 1)  # #D98A00
const GOLD := Color(1.0000, 0.7137, 0.1529, 1)  # #FFB627
const SUNBEAM := Color(1.0000, 0.8510, 0.3529, 1)  # #FFD95A
const SPARKLE := Color(1.0000, 0.9451, 0.6588, 1)  # #FFF1A8
const STAR_WHITE := Color(1.0000, 0.9922, 0.9412, 1)  # #FFFDF0

# --- UI & Gameplay
const UI_OUTLINE := Color(0.0549, 0.0588, 0.1216, 1)  # #0E0F1F
const UI_PANEL := Color(0.1020, 0.1059, 0.2000, 1)  # #1A1B33
const INFO_BLUE := Color(0.2392, 0.6471, 1.0000, 1)  # #3DA5FF
const ENERGY_GREEN := Color(0.1804, 0.9020, 0.6588, 1)  # #2EE6A8
const WARNING_ORANGE := Color(1.0000, 0.5412, 0.2392, 1)  # #FF8A3D
const HEALTH_RED := Color(1.0000, 0.3020, 0.3686, 1)  # #FF4D5E

const ALL := {
	"deep_lagoon": DEEP_LAGOON,
	"lagoon": LAGOON,
	"shallow_water": SHALLOW_WATER,
	"turquoise": TURQUOISE,
	"waterfall_light": WATERFALL_LIGHT,
	"foam": FOAM,
	"night_sky": NIGHT_SKY,
	"twilight": TWILIGHT,
	"dream_violet": DREAM_VIOLET,
	"day_sky": DAY_SKY,
	"blush_cloud": BLUSH_CLOUD,
	"sun_mist": SUN_MIST,
	"deep_jungle": DEEP_JUNGLE,
	"forest": FOREST,
	"leaf": LEAF,
	"grass": GRASS,
	"spring": SPRING,
	"sunlit_leaf": SUNLIT_LEAF,
	"moss_shadow": MOSS_SHADOW,
	"fern": FERN,
	"jade": JADE,
	"mint": MINT,
	"dew": DEW,
	"pale_mint": PALE_MINT,
	"berry_shadow": BERRY_SHADOW,
	"plum_cap": PLUM_CAP,
	"magenta_cap": MAGENTA_CAP,
	"bubblegum": BUBBLEGUM,
	"pink_spot": PINK_SPOT,
	"cap_highlight": CAP_HIGHLIGHT,
	"glow_deep": GLOW_DEEP,
	"glow_violet": GLOW_VIOLET,
	"glow_lilac": GLOW_LILAC,
	"glow_cyan": GLOW_CYAN,
	"glow_lime": GLOW_LIME,
	"glow_core": GLOW_CORE,
	"root_dark": ROOT_DARK,
	"bark": BARK,
	"stem": STEM,
	"stem_light": STEM_LIGHT,
	"cream": CREAM,
	"ivory": IVORY,
	"stone_shadow": STONE_SHADOW,
	"cliff": CLIFF,
	"stone": STONE,
	"pebble": PEBBLE,
	"stone_light": STONE_LIGHT,
	"stone_glint": STONE_GLINT,
	"earth_dark": EARTH_DARK,
	"earth": EARTH,
	"path": PATH,
	"sand": SAND,
	"beach": BEACH,
	"shell": SHELL,
	"amber_dark": AMBER_DARK,
	"amber": AMBER,
	"gold": GOLD,
	"sunbeam": SUNBEAM,
	"sparkle": SPARKLE,
	"star_white": STAR_WHITE,
	"ui_outline": UI_OUTLINE,
	"ui_panel": UI_PANEL,
	"info_blue": INFO_BLUE,
	"energy_green": ENERGY_GREEN,
	"warning_orange": WARNING_ORANGE,
	"health_red": HEALTH_RED,
}
