class_name MatchArena
extends Arena
## A match (`match.tscn`, the canyon of `Arena` without dummies): the player and the bots at
## their start points (`ArenaLayout.STARTS`), each bot driven by a `BotBrain`, the flow of a
## `Match` (countdown, fight, knock-outs, timer, result) under `GameState.match_settings`.
## Nobody moves or fires before the fight or after it ends; then the player's fighter gets its
## trophies (saved at once), the result is stored in `GameState.last_result` and, after
## `END_WAIT_SECONDS`, the game goes on.

## How long the arena stays after the end, so the last knock-out is seen.
const END_WAIT_SECONDS: float = 1.5
const FIGHTER_SCENE: PackedScene = preload("res://scenes/fighter.tscn")

## The random numbers of this match (bot fighters, brains); tests seed it before `_ready`.
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var match_state: Match
## Every fighter of the match; index 0 is the player, as in `Match`.
var fighters: Array[Fighter] = []

var _settings: MatchSettings
var _level: Dictionary
var _brains: Array[BotBrain] = []
var _end_left: float = -1.0

@onready var _bots: Node3D = $Bots
@onready var _countdown_label: Label = $Hud/MatchHud/CountdownLabel
@onready var _timer_label: Label = $Hud/MatchHud/TimerLabel
@onready var _fighters_left_label: Label = $Hud/MatchHud/FightersLeftLabel


func _ready() -> void:
	super._ready()
	_settings = GameState.match_settings
	_level = MatchSettings.level(_settings.bot_level)
	_add_to_match(_fighter, Combat.COLOR_GREEN, Combat.COLOR_RED)
	var bot_ids: Array[String] = _bot_fighter_ids()
	for i: int in bot_ids.size():
		var bot: Fighter = FIGHTER_SCENE.instantiate()
		var start: Vector2 = ArenaLayout.STARTS[i + 1]
		bot.name = "Bot%d" % (i + 1)
		bot.position = Vector3(start.x, 0.0, start.y)
		bot.rotation.y = PI
		_bots.add_child(bot)
		bot.set_look(bot_ids[i], Fighters.DEFAULT_SKIN)
		bot.speed_per_second *= float(_level["speed"])
		_add_to_match(bot, Combat.COLOR_RED, Color.WHITE)
		var brain: BotBrain = BotBrain.new(rng)
		brain.bush_sight = _settings.bush_sight
		_brains.append(brain)
	match_state = Match.new(_settings, fighters.size())
	_update_hud()


## The bots' fighters (not the player's).
func bots() -> Array[Fighter]:
	return fighters.slice(1)


func player_can_act() -> bool:
	return match_state != null and match_state.can_act()


## A quick tap aims at the nearest bot still in the match.
func tap_targets() -> Array[Vector2]:
	var targets: Array[Vector2] = []
	for bot: Fighter in bots():
		if not bot.knocked_out:
			targets.append(Vector2(bot.position.x, bot.position.z))
	return targets


func _physics_process(delta: float) -> void:
	match_state.advance(delta)
	super._physics_process(delta)
	_update_hud()
	var now: float = Time.get_ticks_msec() / 1000.0
	var acting: bool = match_state.can_act()
	for i: int in range(1, fighters.size()):
		_drive_bot(i, now, acting)
	if acting:
		for fighter: Fighter in fighters:
			fighter.heal_step(now, delta, _settings.heal_delay, _settings.heal_per_second)
	if match_state.phase == Match.Phase.OVER:
		_store_result_when_over()
		_wait_for_the_end(delta)


func _update_hud() -> void:
	var countdown: String = match_state.countdown_text()
	_countdown_label.text = countdown
	_countdown_label.visible = not countdown.is_empty()
	_timer_label.text = match_state.timer_text()
	if match_state.timer_red():
		_timer_label.add_theme_color_override("font_color", Combat.COLOR_RED)
	else:
		_timer_label.remove_theme_color_override("font_color")
	_fighters_left_label.text = "Fighters left: %d" % match_state.fighters_left()


func _add_to_match(fighter: Fighter, bar_color: Color, number_color: Color) -> void:
	fighter.max_health = _settings.fighter_health
	fighter.health = fighter.max_health
	fighter.number_color = number_color
	fighter.show_health_bar(bar_color)
	watch_knock_out(fighter)
	fighter.knocked_out_now.connect(_on_knocked_out.bind(fighters.size()))
	fighters.append(fighter)


## The bots' fighters: a shuffle of all fighters but the player's, repeated when there are
## more bots than fighters.
func _bot_fighter_ids() -> Array[String]:
	var pool: Array[String] = Fighters.ids()
	pool.erase(GameState.selected_fighter)
	for i: int in range(pool.size() - 1, 0, -1):
		var j: int = rng.randi_range(0, i)
		var kept: String = pool[i]
		pool[i] = pool[j]
		pool[j] = kept
	var ids: Array[String] = []
	for i: int in _settings.bot_count:
		ids.append(pool[i % pool.size()])
	return ids


func _drive_bot(index: int, now: float, acting: bool) -> void:
	var bot: Fighter = fighters[index]
	var at: Vector2 = Vector2(bot.position.x, bot.position.z)
	bot.model.set_see_through(ArenaLayout.in_bush(at))
	if not acting or bot.knocked_out:
		bot.input_direction = Vector2.ZERO
		return
	var choice: Dictionary = _brains[index - 1].think(now, at, _opponents_of(index), _level)
	bot.input_direction = choice["move"]
	var aim: Vector2 = choice["aim"]
	if aim != Combat.NO_SHOT:
		fire_from(bot, aim, Combat.COOLDOWN * float(_level["cooldown"]))


## The live fighters bot `index` may attack: the player and, when bots fight each other, the
## other bots.
func _opponents_of(index: int) -> Array[Dictionary]:
	var opponents: Array[Dictionary] = []
	for i: int in fighters.size():
		var other: Fighter = fighters[i]
		if i == index or other.knocked_out or (i > 0 and not _settings.bots_fight_each_other):
			continue
		var at: Vector2 = Vector2(other.position.x, other.position.z)
		opponents.append({"id": i, "at": at, "in_bush": ArenaLayout.in_bush(at)})
	return opponents


func _on_knocked_out(index: int) -> void:
	match_state.knock_out(index)
	_update_hud()
	_store_result_when_over()


## Once the match is over: stores the result and starts the wait before leaving.
func _store_result_when_over() -> void:
	if match_state.phase != Match.Phase.OVER or _end_left >= 0.0:
		return
	_end_left = END_WAIT_SECONDS
	for fighter: Fighter in fighters:
		fighter.invulnerable = true
	var fighter_id: String = GameState.selected_fighter
	var reward: Dictionary = GameState.award_trophies(fighter_id, match_state.result)
	GameState.last_result = {
		"outcome": match_state.result,
		"place": match_state.place,
		"fighter": fighter_id,
		"skin": GameState.selected_skin(),
		"reward": reward,
	}


func _wait_for_the_end(delta: float) -> void:
	if _end_left <= 0.0:
		return
	_end_left = maxf(_end_left - delta, 0.0)
	if _end_left == 0.0:
		Screens.go_to(Screens.RESULT)
