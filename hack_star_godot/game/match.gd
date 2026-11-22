class_name Match
extends RefCounted
## The flow of one match without a scene: countdown, fight, knock-outs, timer and result.
## Fighter 0 is the player.

enum Phase { COUNTDOWN, FIGHT, OVER }
enum Result { NONE, VICTORY, DEFEAT, TIME_UP }

## How long "FIGHT!" stays on screen after the countdown.
const FIGHT_TEXT_SECONDS: float = 0.7
const RED_TIMER_SECONDS: float = 10.0

var phase: Phase = Phase.COUNTDOWN
var result: Result = Result.NONE
## The player's place: the fighters still in when it is knocked out + 1; 1 when it never was
## (a victory, or time up).
var place: int = 0
## Fighter indices in the order they were knocked out.
var knock_out_order: Array[int] = []

var _settings: MatchSettings
var _alive: Array[bool] = []
var _elapsed: float = 0.0


func _init(settings: MatchSettings, fighter_count: int) -> void:
	_settings = settings
	for i: int in fighter_count:
		_alive.append(true)


func advance(delta: float) -> void:
	if phase == Phase.OVER:
		return
	_elapsed += delta
	if phase == Phase.COUNTDOWN and _elapsed >= _settings.countdown_seconds:
		phase = Phase.FIGHT
	if phase == Phase.FIGHT and _fight_seconds() >= _settings.match_seconds:
		_time_up()


func countdown_text() -> String:
	if phase == Phase.COUNTDOWN:
		return str(ceili(_settings.countdown_seconds - _elapsed))
	if phase == Phase.FIGHT and _fight_seconds() < FIGHT_TEXT_SECONDS:
		return "FIGHT!"
	return ""


## Fighters move and shoot only while the fight is on.
func can_act() -> bool:
	return phase == Phase.FIGHT


func seconds_left() -> float:
	if phase == Phase.COUNTDOWN:
		return _settings.match_seconds
	return maxf(_settings.match_seconds - _fight_seconds(), 0.0)


## Minutes and seconds, rounded up: "2:00", then "1:59".
func timer_text() -> String:
	var seconds: int = ceili(seconds_left())
	return "%d:%02d" % [floori(seconds / 60.0), seconds % 60]


func timer_red() -> bool:
	return phase == Phase.FIGHT and ceilf(seconds_left()) <= RED_TIMER_SECONDS


func is_alive(index: int) -> bool:
	return _alive[index]


func fighters_left() -> int:
	return _alive.count(true)


## Records a knock-out and ends the match when the player is out or only the player is left.
func knock_out(index: int) -> void:
	if phase == Phase.OVER or not _alive[index]:
		return
	_alive[index] = false
	knock_out_order.append(index)
	if index == 0:
		_finish(Result.DEFEAT, fighters_left() + 1)
	elif fighters_left() == 1:
		_finish(Result.VICTORY, 1)


## 1 -> "1st", 2 -> "2nd", 3 -> "3rd", 4 -> "4th", 11 -> "11th", 21 -> "21st".
static func ordinal(n: int) -> String:
	var suffix: String = "th"
	if n % 100 < 11 or n % 100 > 13:
		match n % 10:
			1:
				suffix = "st"
			2:
				suffix = "nd"
			3:
				suffix = "rd"
	return "%d%s" % [n, suffix]


func _fight_seconds() -> float:
	return _elapsed - _settings.countdown_seconds


func _time_up() -> void:
	if _settings.time_up_result == MatchSettings.TIME_UP_DEFEAT:
		_finish(Result.DEFEAT, 1)
	else:
		_finish(Result.TIME_UP, 0)


func _finish(final_result: Result, final_place: int) -> void:
	phase = Phase.OVER
	result = final_result
	place = final_place
