extends Node
## What the player has and has chosen while the game is open: trophies, power levels, unlocked
## fighters, credits, the chosen fighter and skin, and whether the entrance has played.
## It starts from `SampleProgress` and lays the saved progress over it (`load_saved`); the whole
## progress and the active hacks are saved together (`SaveData`) in one store (`SaveStore`), which
## the browser's tabs share; a newer save of another tab is merged on write and read when the
## game comes to the front (spec 16, D7).

## Emitted when the hacks or the chosen fighter changed on their own (a hack turned off).
signal progress_changed

## How often the game checks whether a hack has turned off.
const EXPIRY_CHECK_SECONDS: float = 30.0

var trophies: Dictionary[String, int] = {}
var power_levels: Dictionary[String, int] = {}
var unlocked: Array[String] = []
var credits: int = 0
var selected_fighter: String = ""
var selected_skins: Dictionary[String, String] = {}
## The fighter the fighter screen shows (set by the list before it opens the screen).
var viewed_fighter: String = ""
var entrance_played: bool = false
## The arena's FPS label is shown (the info screen's play-test switch, spec 09 D8); kept while
## the game is open, not saved.
var show_fps: bool = false
## The ids of the hacks that are on (see `Hacks`); kept in the save file.
var active_hacks: Array[String] = []
## When each active hack turns off: Unix time in seconds, `Hacks.FOREVER` for never.
var hack_until: Dictionary[String, int] = {}
## The Unix time in seconds (a test sets a fake clock).
var clock: Callable = Time.get_unix_time_from_system
## Where the progress and the hacks are saved; a test points it to a file under `user://test/`.
var save_path: String = "user://hack_star_save.json"
## The fighter pictures of the list, rendered once per game start (see `FighterPictures`).
var pictures: Dictionary[String, Texture2D] = {}
## The code of a QR link the web game was opened with (`?hack=`, D9 of spec 05); the hack
## screen redeems it once and empties it.
var start_code: String = ""
## The numbers the next match reads at its start; session only, not saved.
var match_settings: MatchSettings = MatchSettings.new()
## The end of the last match, `{outcome (Match.Result), place, fighter, skin}`, or empty;
## session only, not saved.
var last_result: Dictionary = {}
# The revision of the save file this game last read or wrote.
var _revision: int = 0
# Keeps the page's `visibilitychange` callback alive (web only).
var _visibility_callback: JavaScriptObject = null


func _ready() -> void:
	reset()
	load_saved()
	var expiry_timer: Timer = Timer.new()
	expiry_timer.name = "ExpiryTimer"
	expiry_timer.wait_time = EXPIRY_CHECK_SECONDS
	expiry_timer.timeout.connect(expire_hacks)
	add_child(expiry_timer)
	expiry_timer.start()
	if OS.has_feature("web"):
		start_code = _take_start_code()
		_watch_page_visibility()


## Back to the sample progress of a fresh game start.
func reset() -> void:
	trophies = SampleProgress.TROPHIES.duplicate()
	power_levels = SampleProgress.POWER_LEVELS.duplicate()
	unlocked = Fighters.start_unlocked()
	credits = SampleProgress.CREDITS
	selected_fighter = SampleProgress.SELECTED_FIGHTER
	viewed_fighter = selected_fighter
	selected_skins = {}
	for fighter_id: String in Fighters.ids():
		selected_skins[fighter_id] = Fighters.DEFAULT_SKIN
	entrance_played = false
	show_fps = false
	pictures = {}
	match_settings = MatchSettings.new()
	last_result = {}
	# In memory only, so a developer's own save file never changes what a test sees.
	active_hacks = []
	hack_until = {}
	_revision = 0
	clock = Time.get_unix_time_from_system


func is_unlocked(fighter_id: String) -> bool:
	return Hacks.is_fighter_unlocked(fighter_id, unlocked, active_hacks)


## The skin chosen for the selected fighter.
func selected_skin() -> String:
	return selected_skins[selected_fighter]


## Chooses a fighter and one of its skins; false (nothing changes) for a locked fighter or a
## skin that fighter does not have.
func select(fighter_id: String, skin_id: String) -> bool:
	if not is_unlocked(fighter_id) or not Fighters.has_skin(fighter_id, skin_id):
		return false
	selected_fighter = fighter_id
	selected_skins[fighter_id] = skin_id
	save()
	return true


func total_trophies() -> int:
	var total: int = 0
	for fighter_trophies: int in trophies.values():
		total += fighter_trophies
	return total


## The clock's time as whole Unix seconds.
func now() -> int:
	return int(clock.call())


func has_hack(hack_id: String) -> bool:
	return hack_id in active_hacks


## Turns a hack on and saves; false (nothing changes) for an unknown id or a for-ever hack that
## is already on. A timed hack that is already on starts a new 3 days.
func activate_hack(hack_id: String) -> bool:
	if not Hacks.is_known(hack_id) or (has_hack(hack_id) and not Hacks.is_timed(hack_id)):
		return false
	if not has_hack(hack_id):
		active_hacks.append(hack_id)
	hack_until[hack_id] = Hacks.until_for(hack_id, now())
	save()
	return true


## Turns off every hack whose time has passed, keeps the chosen fighter usable, saves and emits
## `progress_changed`. Returns true when a hack turned off.
func expire_hacks() -> bool:
	var current: int = now()
	var expired: Array[String] = []
	for hack_id: String in active_hacks:
		if Hacks.is_expired(hack_until.get(hack_id, Hacks.FOREVER), current):
			expired.append(hack_id)
	if expired.is_empty():
		return false
	for hack_id: String in expired:
		active_hacks.erase(hack_id)
		hack_until.erase(hack_id)
	_keep_usable_selection()
	save()
	progress_changed.emit()
	return true


## Checks a code with the server and, when it is right, turns its hack on. This lives here, not
## in a screen, so a code accepted while the screen is closed (Back) still counts.
func redeem_code(text: String) -> Dictionary:
	var result: Dictionary = await HackServer.redeem(text)
	if result["status"] == HackServer.STATUS_OK:
		activate_hack(result["id"])
	return result


## Turns all hacks off and saves; the normal rules are back.
func reset_hacks() -> void:
	active_hacks = []
	hack_until = {}
	_keep_usable_selection()
	save()
	progress_changed.emit()


# A fighter that is locked again is never the chosen one: the sample fighter when it is
# unlocked, else the first unlocked fighter; the viewed fighter follows.
func _keep_usable_selection() -> void:
	if is_unlocked(selected_fighter):
		return
	var replacement: String = ""
	if is_unlocked(SampleProgress.SELECTED_FIGHTER):
		replacement = SampleProgress.SELECTED_FIGHTER
	else:
		for fighter_id: String in Fighters.ids():
			if is_unlocked(fighter_id):
				replacement = fighter_id
				break
	if replacement.is_empty():
		return
	if viewed_fighter == selected_fighter:
		viewed_fighter = replacement
	selected_fighter = replacement


## Lays the saved file over the sample progress: the hacks and the saved trophies, power levels,
## skins, unlocked fighters, credits and chosen fighter. A missing, broken or newer file leaves
## the sample progress without hacks.
func load_saved() -> void:
	var text: String = _store().read()
	if text.is_empty():
		return
	_lay_over(SaveData.from_json(text, now()))
	expire_hacks()


## Reads the store again when another tab saved since this game last read or wrote it (spec 16,
## D7): the stored hacks replace this game's, the stored progress is laid over it, expired hacks
## turn off and `progress_changed` is emitted. Returns true when something was read.
func sync_from_store() -> bool:
	var saved: Dictionary = SaveData.from_json(_store().read(), now())
	if saved["revision"] <= _revision:
		return false
	_lay_over(saved)
	_keep_usable_selection()
	if not expire_hacks():
		progress_changed.emit()
	return true


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		sync_from_store()


# Calls `sync_from_store` when the page becomes visible again (another tab was in front).
func _watch_page_visibility() -> void:
	_visibility_callback = JavaScriptBridge.create_callback(_on_page_visibility)
	var page: JavaScriptObject = JavaScriptBridge.get_interface("document")
	if page != null:
		page.addEventListener("visibilitychange", _visibility_callback)


func _on_page_visibility(_args: Array) -> void:
	if _page_is_visible():
		sync_from_store()


func _page_is_visible() -> bool:
	return JavaScriptBridge.eval("document.visibilityState") == "visible"


func _store() -> SaveStore:
	return SaveStore.for_this_platform(save_path)


# The saved hacks replace this game's; the saved progress is laid over it.
func _lay_over(saved: Dictionary) -> void:
	hack_until = saved["hacks"]
	active_hacks.assign(hack_until.keys())
	_revision = saved["revision"]
	var progress: Dictionary = saved["progress"]
	trophies.merge(progress.get("trophies", {}), true)
	power_levels.merge(progress.get("power_levels", {}), true)
	selected_skins.merge(progress.get("selected_skins", {}), true)
	for fighter_id: String in progress.get("unlocked", []):
		if not fighter_id in unlocked:
			unlocked.append(fighter_id)
	credits = progress.get("credits", credits)
	var chosen: String = progress.get("selected_fighter", "")
	if is_unlocked(chosen):
		if viewed_fighter == selected_fighter:
			viewed_fighter = chosen
		selected_fighter = chosen


# Another tab's newer save joins this game's (spec 16, D7): hacks a union with the later end,
# `unlocked` a union, trophies and power levels per fighter the higher; credits, the chosen
# fighter and the skins stay this game's. Expired hacks are left out.
func _merge(saved: Dictionary) -> void:
	var current: int = now()
	var stored_hacks: Dictionary = saved["hacks"]
	for hack_id: String in stored_hacks:
		var until: int = stored_hacks[hack_id]
		if Hacks.is_expired(until, current):
			continue
		if not has_hack(hack_id):
			active_hacks.append(hack_id)
			hack_until[hack_id] = until
		elif Hacks.is_timed(hack_id):
			hack_until[hack_id] = maxi(hack_until.get(hack_id, until), until)
	var progress: Dictionary = saved["progress"]
	var stored_trophies: Dictionary = progress.get("trophies", {})
	for fighter_id: String in stored_trophies:
		trophies[fighter_id] = maxi(trophies.get(fighter_id, 0), stored_trophies[fighter_id])
	var stored_levels: Dictionary = progress.get("power_levels", {})
	for fighter_id: String in stored_levels:
		power_levels[fighter_id] = maxi(power_levels.get(fighter_id, 1), stored_levels[fighter_id])
	for fighter_id: String in progress.get("unlocked", []):
		if not fighter_id in unlocked:
			unlocked.append(fighter_id)


## Writes the hacks and the progress to the store; when another tab saved since this game last
## read or wrote it, its save is merged in first (`_merge`) and `progress_changed` is emitted.
func save() -> void:
	var merged: bool = false
	var stored_text: String = _store().read()
	if not stored_text.is_empty():
		var stored: Dictionary = SaveData.from_json(stored_text, now())
		if stored["revision"] > _revision:
			_merge(stored)
			_revision = stored["revision"]
			merged = true
	var progress: Dictionary = {
		"trophies": trophies,
		"power_levels": power_levels,
		"unlocked": unlocked,
		"credits": credits,
		"selected_fighter": selected_fighter,
		"selected_skins": selected_skins,
	}
	_revision += 1
	_store().write(SaveData.to_json(hack_until, progress, _revision))
	if merged:
		progress_changed.emit()


## Gives the fighter the trophies of a match result (`Trophies.reward` with the match
## settings), saves at once and returns the reward.
func award_trophies(fighter_id: String, outcome: Match.Result) -> Dictionary:
	var reward: Dictionary = Trophies.reward(trophies[fighter_id], outcome, match_settings)
	trophies[fighter_id] = reward["after"]
	save()
	return reward


# Reads `?hack=` from the page address and removes it, so a reload does not redeem it again.
func _take_start_code() -> String:
	var address: Variant = JavaScriptBridge.eval("location.href")
	if not address is String:
		return ""
	var code: String = Hacks.code_from_address(address)
	if not code.is_empty():
		JavaScriptBridge.eval(
			(
				"(function () { var u = new URL(location.href); u.searchParams.delete('hack');"
				+ " history.replaceState(null, '', u.pathname + u.search + u.hash); })()"
			)
		)
	return code
