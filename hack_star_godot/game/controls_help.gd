class_name ControlsHelp
extends RefCounted
## The texts that say how to play (spec 16, D13): the start hint of Training and of a match, and
## the "How to play" section of the Info page. The numbers come from the rules, so the texts
## stay true when a rule changes. English only (spec 16, S23).

const KEYBOARD_HINT: String = (
	"Move: WASD or arrow keys\nShoot: Space\n" + "View: V or 1-4, light: L and K"
)
const TOUCH_HINT: String = "Move: left stick\nShoot: drag or tap the right stick"
const MORE_IN_INFO: String = "More in Info"


## The sections of "How to play", each `{"title", "text"}`.
static func how_to_play() -> Array[Dictionary]:
	return [
		{
			"title": "Controls",
			"text":
			(
				(
					"Keyboard: move with WASD or the arrow keys and shoot with Space (hold it to keep "
					+ "firing). Touch: move with the left stick; drag the right stick and let go to "
					+ "shoot that way, or tap it to shoot at the nearest target. Space and a tap fire "
					+ "at the nearest target in range (%d metres), or straight ahead. "
					+ "V switches the camera view, 1 to 4 choose one (%s). "
					+ "L switches the lighting (%s), K a saturation boost. "
					+ "Back goes home."
				)
				% [
					int(Combat.SHOT_RANGE),
					", ".join(_view_names()),
					", ".join(_light_names()),
				]
			),
		},
		{
			"title": "Match",
			"text":
			(
				(
					"You fight %d bots. The last fighter standing wins. When the %d seconds are "
					+ "over with more than one fighter left, it is a draw. Stop shooting and stay "
					+ "unhit for %d seconds and your health comes back."
				)
				% [
					MatchSettings.BOT_COUNT,
					int(MatchSettings.MATCH_SECONDS),
					int(MatchSettings.HEAL_DELAY),
				]
			),
		},
		{
			"title": "Training",
			"text":
			(
				"Practise on %d dummies. A broken dummy comes back after %d seconds."
				% [ArenaLayout.dummies().size(), int(Combat.RESPAWN_SECONDS)]
			),
		},
		{
			"title": "Trophies and Prestige",
			"text":
			(
				(
					"A win gives your fighter +%d trophies. At every %d trophies it reaches a new "
					+ "Prestige."
				)
				% [MatchSettings.TROPHIES_PER_WIN, Prestige.TROPHIES_PER_LEVEL]
			),
		},
		{
			"title": "Hack codes",
			"text":
			(
				"Open Hack on the home screen. Type a code, or scan its QR code in the browser "
				+ "version."
			),
		},
	]


# The camera views' names in the order of the keys 1 to 4.
static func _view_names() -> PackedStringArray:
	var names: PackedStringArray = []
	for view_id: String in CameraViews.ids():
		names.append(CameraViews.view_name(view_id))
	return names


# The lighting presets' names in the order of `L`.
static func _light_names() -> PackedStringArray:
	var names: PackedStringArray = []
	for preset_id: String in LightPresets.ids():
		names.append(LightPresets.preset_name(preset_id))
	return names
