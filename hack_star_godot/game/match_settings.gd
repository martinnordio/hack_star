class_name MatchSettings
extends RefCounted
## The numbers of a match, in one place. Every field starts at its constant; a test (or a later
## options screen) changes the instance in `GameState.match_settings` before the match starts.

const MATCH_SECONDS: float = 120.0
const MIN_BOTS: int = 1
const MAX_BOTS: int = 8
const BOT_COUNT: int = 3
const BOT_LEVEL: String = "easy"
const TIME_UP_DRAW: String = "draw"
const TIME_UP_DEFEAT: String = "defeat"
const COUNTDOWN_SECONDS: int = 3
const FIGHTER_HEALTH: int = 3200
const HEAL_DELAY: float = 3.0
const HEAL_PER_SECOND: float = 0.13
const BUSH_SIGHT: float = 2.5

## Per level: `reaction` seconds before a bot answers a new target, `aim_error` radians of
## the aim, `cooldown` and `speed` factors against the player, `sight` in metres.
const LEVELS: Dictionary[String, Dictionary] = {
	"easy": {"reaction": 0.6, "aim_error": 0.35, "cooldown": 2.4, "speed": 0.75, "sight": 8.0},
	"medium": {"reaction": 0.35, "aim_error": 0.2, "cooldown": 1.6, "speed": 0.9, "sight": 10.0},
	"hard": {"reaction": 0.15, "aim_error": 0.08, "cooldown": 1.15, "speed": 1.0, "sight": 12.0},
}

var match_seconds: float = MATCH_SECONDS
var bot_count: int = BOT_COUNT:
	set(value):
		bot_count = clampi(value, MIN_BOTS, MAX_BOTS)
var bot_level: String = BOT_LEVEL
var time_up_result: String = TIME_UP_DRAW
var bots_fight_each_other: bool = true
var countdown_seconds: int = COUNTDOWN_SECONDS
var fighter_health: int = FIGHTER_HEALTH
var heal_delay: float = HEAL_DELAY
var heal_per_second: float = HEAL_PER_SECOND
var bush_sight: float = BUSH_SIGHT


## The numbers of a level; an unknown name gives "easy".
static func level(level_name: String) -> Dictionary:
	return LEVELS.get(level_name, LEVELS[BOT_LEVEL])
