extends Node
## What the player has and has chosen while the game is open: trophies, power levels, unlocked
## fighters, credits, the chosen fighter and skin, and whether the entrance has played.
## It starts from `SampleProgress` at every game start and saves nothing (spec 05 or 08 does).

var trophies: Dictionary[String, int] = {}
var power_levels: Dictionary[String, int] = {}
var unlocked: Array[String] = []
var credits: int = 0
var selected_fighter: String = ""
var selected_skins: Dictionary[String, String] = {}
## The fighter the fighter screen shows (set by the list before it opens the screen).
var viewed_fighter: String = ""
var entrance_played: bool = false
## The fighter pictures of the list, rendered once per game start (see `FighterPictures`).
var pictures: Dictionary[String, Texture2D] = {}


func _ready() -> void:
	reset()


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


func is_unlocked(fighter_id: String) -> bool:
	return fighter_id in unlocked


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
