class_name BotBrain
extends RefCounted
## What one bot does each frame, without a scene: whom it sees, where it walks and where it
## shoots. Positions on the ground plane are Vector2 (x, z), as in `Movement` and `Combat`.

## Farther than this share of `Combat.SHOT_RANGE` the bot closes in.
const CHASE_SHARE: float = 0.65
## Closer than this (metres) the bot backs off.
const BACK_OFF_DISTANCE: float = 3.0
## How fast the bot sidesteps at a good distance (share of a full step).
const SIDESTEP: float = 0.5
## A wander point counts as reached within this distance (metres).
const REACHED_DISTANCE: float = 0.5
## A new wander point after this many seconds.
const WANDER_SECONDS: float = 4.0
## A new wander point after this many seconds without getting closer (stuck at a rock).
const STUCK_SECONDS: float = 1.0
## Getting closer by less than this (metres) is no progress.
const PROGRESS_DISTANCE: float = 0.1
## A wander point keeps this distance (metres) from walls.
const WANDER_CLEARANCE: float = 0.6
const WANDER_TRIES: int = 50

## How close a fighter in a bush must be to be seen.
var bush_sight: float = MatchSettings.BUSH_SIGHT
## Where the bot walks when it sees nobody; `Vector2.INF` until it picks one.
var wander_point: Vector2 = Vector2.INF

var _rng: RandomNumberGenerator
var _target_id: Variant = null
var _react_at: float = 0.0
var _side: float = 1.0
var _wander_since: float = 0.0
var _best_distance: float = INF
var _progress_at: float = 0.0


## `rng` lets tests (and the match) choose the random numbers; a new one otherwise.
func _init(rng: RandomNumberGenerator = null) -> void:
	_rng = rng if rng != null else RandomNumberGenerator.new()


## True when a fighter at `at` is seen from `from`: within `sight`, and within `bush_sight`
## when it stands in a bush. Walls do not block sight.
static func can_see(
	from: Vector2, at: Vector2, in_bush: bool, sight: float, bush_sight_distance: float
) -> bool:
	var distance: float = from.distance_to(at)
	if distance > sight:
		return false
	return not in_bush or distance <= bush_sight_distance


## The bot's choice at time `now` (seconds) standing at `me`: `move` (input direction, length
## at most 1) and `aim` (unit direction to fire, or `Combat.NO_SHOT`). `opponents` are the live
## fighters it may attack as `{at, in_bush}` with an optional `id` (the index otherwise);
## `level` is one of `MatchSettings.LEVELS`.
func think(now: float, me: Vector2, opponents: Array[Dictionary], level: Dictionary) -> Dictionary:
	var target: int = _nearest_visible(me, opponents, level["sight"])
	if target < 0:
		_target_id = null
		return {"move": _wander(now, me), "aim": Combat.NO_SHOT}
	var opponent: Dictionary = opponents[target]
	var target_id: Variant = opponent.get("id", target)
	if target_id != _target_id:
		_target_id = target_id
		_react_at = now + float(level["reaction"])
		_side = 1.0 if _rng.randf() < 0.5 else -1.0
		wander_point = Vector2.INF
	if now < _react_at:
		return {"move": Vector2.ZERO, "aim": Combat.NO_SHOT}
	var offset: Vector2 = opponent["at"] - me
	var distance: float = offset.length()
	var direction: Vector2 = offset.normalized() if distance > 0.0 else Vector2.UP
	return {
		"move": _fight_move(direction, distance),
		"aim": _aim(direction, distance, level["aim_error"]),
	}


func _nearest_visible(me: Vector2, opponents: Array[Dictionary], sight: float) -> int:
	var best: int = -1
	var best_distance: float = INF
	for i: int in opponents.size():
		var at: Vector2 = opponents[i]["at"]
		if not can_see(me, at, opponents[i].get("in_bush", false), sight, bush_sight):
			continue
		var distance: float = me.distance_to(at)
		if distance < best_distance:
			best = i
			best_distance = distance
	return best


func _fight_move(direction: Vector2, distance: float) -> Vector2:
	if distance > CHASE_SHARE * Combat.SHOT_RANGE:
		return direction
	if distance < BACK_OFF_DISTANCE:
		return -direction
	return direction.orthogonal() * _side * SIDESTEP


func _aim(direction: Vector2, distance: float, aim_error: float) -> Vector2:
	if distance > Combat.SHOT_RANGE:
		return Combat.NO_SHOT
	return direction.rotated(_rng.randf_range(-aim_error, aim_error))


func _wander(now: float, me: Vector2) -> Vector2:
	var distance: float = me.distance_to(wander_point) if wander_point != Vector2.INF else INF
	if distance < _best_distance - PROGRESS_DISTANCE:
		_best_distance = distance
		_progress_at = now
	if (
		wander_point == Vector2.INF
		or distance <= REACHED_DISTANCE
		or now - _wander_since >= WANDER_SECONDS
		or now - _progress_at >= STUCK_SECONDS
	):
		wander_point = _free_point()
		_wander_since = now
		_progress_at = now
		distance = me.distance_to(wander_point)
		_best_distance = distance
	if distance <= 0.0:
		return Vector2.ZERO
	return (wander_point - me) / distance


func _free_point() -> Vector2:
	var area: Rect2 = ArenaLayout.bounds().grow(-WANDER_CLEARANCE)
	for i: int in WANDER_TRIES:
		var point: Vector2 = Vector2(
			_rng.randf_range(area.position.x, area.end.x),
			_rng.randf_range(area.position.y, area.end.y)
		)
		if ArenaLayout.is_free(point, WANDER_CLEARANCE):
			return point
	return ArenaLayout.START
