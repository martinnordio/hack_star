extends Node
## What the player has and has chosen while the game is open: trophies, power levels, unlocked
## fighters, credits, the chosen fighter and skin, and whether the entrance has played.
## It starts from `SampleProgress` and lays the saved progress over it (`load_saved`); the whole
## progress and the active hacks are saved in one file (`SaveData`).

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
	if not FileAccess.file_exists(save_path):
		return
	var saved: Dictionary = SaveData.from_json(FileAccess.get_file_as_string(save_path), now())
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
		selected_fighter = chosen
		viewed_fighter = chosen
	expire_hacks()


## Writes the hacks and the progress to `save_path`.
func save() -> void:
	DirAccess.make_dir_recursive_absolute(save_path.get_base_dir())
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save %s (error %d)" % [save_path, FileAccess.get_open_error()])
		return
	var progress: Dictionary = {
		"trophies": trophies,
		"power_levels": power_levels,
		"unlocked": unlocked,
		"credits": credits,
		"selected_fighter": selected_fighter,
		"selected_skins": selected_skins,
	}
	_revision += 1
	file.store_string(SaveData.to_json(hack_until, progress, _revision))


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
