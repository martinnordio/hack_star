extends GutTest
## How long each hack lasts and the time left (spec 16, S16, S17, S18, D1).

const NOW: int = 1_764_000_000
const HOUR: int = Hacks.HOUR_SECONDS
const DAY: int = Hacks.DAY_SECONDS


func test_infinity_and_opensesame_last_3_days_and_power22_for_ever() -> void:
	assert_eq(Hacks.TIMED_SECONDS, 3 * 86400, "the server's 72 hours")
	assert_eq(Hacks.duration_seconds(Hacks.INFINITE_CREDITS), Hacks.TIMED_SECONDS)
	assert_eq(Hacks.duration_seconds(Hacks.UNLOCK_ALL), Hacks.TIMED_SECONDS)
	assert_eq(Hacks.duration_seconds(Hacks.POWER22), Hacks.FOREVER)
	assert_true(Hacks.is_timed(Hacks.INFINITE_CREDITS))
	assert_true(Hacks.is_timed(Hacks.UNLOCK_ALL))
	assert_false(Hacks.is_timed(Hacks.POWER22))


func test_until_is_now_plus_the_duration_or_for_ever() -> void:
	assert_eq(Hacks.until_for(Hacks.INFINITE_CREDITS, NOW), NOW + 3 * DAY)
	assert_eq(Hacks.until_for(Hacks.UNLOCK_ALL, NOW), NOW + 3 * DAY)
	assert_eq(Hacks.until_for(Hacks.POWER22, NOW), Hacks.FOREVER)


func test_a_hack_is_expired_from_its_until_on_and_never_when_for_ever() -> void:
	assert_false(Hacks.is_expired(NOW + 1, NOW))
	assert_true(Hacks.is_expired(NOW, NOW))
	assert_true(Hacks.is_expired(NOW - 1, NOW))
	assert_false(Hacks.is_expired(Hacks.FOREVER, NOW))


func test_time_left_in_days_and_whole_hours() -> void:
	assert_eq(Hacks.time_left_text(Hacks.FOREVER, NOW), "Lasts for ever")
	assert_eq(Hacks.time_left_text(NOW + 3 * DAY, NOW), "3 days left")
	assert_eq(Hacks.time_left_text(NOW + 2 * DAY + 5 * HOUR + 59, NOW), "2 days 5 hours left")
	assert_eq(Hacks.time_left_text(NOW + DAY + HOUR, NOW), "1 day 1 hour left")
	assert_eq(Hacks.time_left_text(NOW + DAY, NOW), "1 day left")
	assert_eq(Hacks.time_left_text(NOW + DAY - 1, NOW), "23 hours left")
	assert_eq(Hacks.time_left_text(NOW + 5 * HOUR, NOW), "5 hours left")
	assert_eq(Hacks.time_left_text(NOW + HOUR, NOW), "1 hour left")
	assert_eq(Hacks.time_left_text(NOW + HOUR - 1, NOW), "Less than 1 hour left")
	assert_eq(Hacks.time_left_text(NOW - 10, NOW), "Less than 1 hour left")
