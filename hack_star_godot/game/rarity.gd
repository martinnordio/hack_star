class_name Rarity
extends RefCounted
## The five rarities of fighters and skins, from the most common to the rarest, and their colours.

const NAMES: Array[String] = ["Rare", "Super Rare", "Epic", "Mythic", "Legendary"]
const LEGENDARY_GOLD: Color = Color(1.0, 0.82, 0.2)
const COLORS: Array[Color] = [
	Color(0.35, 0.8, 0.4),
	Color(0.3, 0.6, 1.0),
	Color(0.7, 0.4, 0.95),
	Color(0.95, 0.3, 0.35),
	LEGENDARY_GOLD,
]


## The position of a rarity in `NAMES` (0 = Rare), or -1 for an unknown name.
static func rank(rarity: String) -> int:
	return NAMES.find(rarity)


## The colour of a rarity; white for an unknown name.
static func color(rarity: String) -> Color:
	var index: int = rank(rarity)
	return Color.WHITE if index < 0 else COLORS[index]
