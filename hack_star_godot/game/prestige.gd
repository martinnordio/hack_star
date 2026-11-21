class_name Prestige
extends RefCounted
## Prestige: a fighter reaches a new level at every 1000 trophies.

const TROPHIES_PER_LEVEL: int = 1000

## 0 below 1000 trophies, 1 at 1000-1999, 2 at 2000-2999, and so on.
@warning_ignore("integer_division")
static func level(trophies: int) -> int:
	return maxi(trophies, 0) / TROPHIES_PER_LEVEL
