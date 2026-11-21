extends GutTest


func test_below_1000_is_level_0() -> void:
	assert_eq(Prestige.level(0), 0)
	assert_eq(Prestige.level(999), 0)


func test_every_1000_trophies_is_one_level() -> void:
	assert_eq(Prestige.level(1000), 1)
	assert_eq(Prestige.level(1999), 1)
	assert_eq(Prestige.level(2000), 2)
	assert_eq(Prestige.level(2500), 2)


func test_negative_trophies_are_level_0() -> void:
	assert_eq(Prestige.level(-50), 0)


func test_floor_and_next_prestige() -> void:
	assert_eq(Prestige.floor_of(999), 0)
	assert_eq(Prestige.floor_of(1250), 1000)
	assert_eq(Prestige.next_at(999), 1000)
	assert_eq(Prestige.next_at(1250), 2000)
	assert_eq(Prestige.next_at(2000), 3000)
