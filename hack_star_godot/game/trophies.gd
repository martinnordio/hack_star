class_name Trophies
extends RefCounted
## The trophies of a match result. A time-up that the settings count as a defeat is already
## `Match.Result.DEFEAT` when it gets here.


## The trophies a result gives: the win number, the defeat number, or 0.
static func change_for(outcome: Match.Result, settings: MatchSettings) -> int:
	match outcome:
		Match.Result.VICTORY:
			return settings.trophies_per_win
		Match.Result.DEFEAT:
			return settings.trophies_per_defeat
	return 0


## What a result does to a fighter with `before` trophies; never below the last Prestige.
static func reward(before: int, outcome: Match.Result, settings: MatchSettings) -> Dictionary:
	var after: int = maxi(before + change_for(outcome, settings), Prestige.floor_of(before))
	return {
		"before": before,
		"after": after,
		"change": after - before,
		"prestige_before": Prestige.level(before),
		"prestige_after": Prestige.level(after),
	}
