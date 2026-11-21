class_name Hacks
extends RefCounted
## The hack rules: what each hack changes, computed from the list of active hack ids. Pure, so
## a test can call it without a scene. A hack never changes trophies, unlocks or power levels;
## turning all hacks off brings the normal rules back.

const INFINITE_CREDITS: String = "infinite_credits"
const UNLOCK_ALL: String = "unlock_all"
const POWER22: String = "power22"

const NORMAL_MAX_POWER: int = 11
const HACKED_MAX_POWER: int = 22
const UNLIMITED_TEXT: String = "∞"
const CODE_PARAMETER: String = "hack"


## The ids of the hacks the game knows.
static func ids() -> Array[String]:
	return [INFINITE_CREDITS, UNLOCK_ALL, POWER22]


static func is_known(hack_id: String) -> bool:
	return hack_id in ids()


## The name shown in the list of active hacks; the same names the server gives, kept here so
## the list also works without the server.
static func display_name(hack_id: String) -> String:
	match hack_id:
		INFINITE_CREDITS:
			return "Unlimited credits"
		UNLOCK_ALL:
			return "Unlock everything"
		POWER22:
			return "Power 22"
	return hack_id


## A typed code as the server expects it: no surrounding spaces, upper case.
static func normalize_code(text: String) -> String:
	return text.strip_edges().to_upper()


## The code inside a scanned text: a plain code, or a link with `?hack=<CODE>`.
static func code_from_scan(text: String) -> String:
	var scanned: String = text.strip_edges()
	var query_start: int = scanned.find("?")
	if query_start < 0:
		return normalize_code(scanned)
	var query: String = scanned.substr(query_start + 1)
	var fragment_start: int = query.find("#")
	if fragment_start >= 0:
		query = query.substr(0, fragment_start)
	for pair: String in query.split("&"):
		var parts: PackedStringArray = pair.split("=", true, 1)
		if parts.size() == 2 and parts[0] == CODE_PARAMETER:
			return normalize_code(parts[1].uri_decode())
	return ""


## The code in the game's own address (`?hack=<CODE>`), or an empty string.
static func code_from_address(address: String) -> String:
	if address.find("?") < 0:
		return ""
	return code_from_scan(address)


## The text of a hack's QR code: the game's address with the code (D9 of spec 05).
static func link(game_address: String, code: String) -> String:
	return "%s?%s=%s" % [game_address, CODE_PARAMETER, normalize_code(code).uri_encode()]


## "Credits: 321", or the unlimited sign with the hack.
static func credits_text(credits: int, hacks: Array[String]) -> String:
	return "Credits: %s" % (UNLIMITED_TEXT if INFINITE_CREDITS in hacks else str(credits))


## The credits after paying a price: unchanged with the unlimited-credits hack.
static func spend(credits: int, price: int, hacks: Array[String]) -> int:
	if INFINITE_CREDITS in hacks:
		return credits
	return credits - price


static func is_fighter_unlocked(
	fighter_id: String, unlocked: Array[String], hacks: Array[String]
) -> bool:
	return UNLOCK_ALL in hacks or fighter_id in unlocked


## Skins have no locks before the skins shop (spec 10), so every skin is available.
static func is_skin_unlocked(_fighter_id: String, _skin_id: String, _hacks: Array[String]) -> bool:
	return true


static func max_power(hacks: Array[String]) -> int:
	return HACKED_MAX_POWER if POWER22 in hacks else NORMAL_MAX_POWER


## "Power 7 / 11", or "Power 7 / 22" with the 22-levels hack.
static func power_text(level: int, hacks: Array[String]) -> String:
	return "Power %d / %d" % [level, max_power(hacks)]
