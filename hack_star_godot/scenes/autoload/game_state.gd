extends Node
## What the player has and has chosen while the game is open: trophies, power levels, unlocked
## fighters, credits, the chosen fighter and skin, and whether the entrance has played.
## It starts from `SampleProgress` at every game start. Only the active hacks are saved
## (`SaveData`); spec 08 saves the rest.

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
## Where the active hacks are saved; a test points it to a file under `user://test/`.
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


func _ready() -> void:
	reset()
	active_hacks = _load_hacks()
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
	return true


func total_trophies() -> int:
	var total: int = 0
	for fighter_trophies: int in trophies.values():
		total += fighter_trophies
	return total


func has_hack(hack_id: String) -> bool:
	return hack_id in active_hacks


## Turns a hack on and saves; false (nothing changes) for an unknown or an active id.
func activate_hack(hack_id: String) -> bool:
	if not Hacks.is_known(hack_id) or has_hack(hack_id):
		return false
	active_hacks.append(hack_id)
	_save_hacks()
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
	_save_hacks()


func _load_hacks() -> Array[String]:
	if not FileAccess.file_exists(save_path):
		return []
	return SaveData.from_json(FileAccess.get_file_as_string(save_path))


func _save_hacks() -> void:
	DirAccess.make_dir_recursive_absolute(save_path.get_base_dir())
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save %s (error %d)" % [save_path, FileAccess.get_open_error()])
		return
	file.store_string(SaveData.to_json(active_hacks))


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
