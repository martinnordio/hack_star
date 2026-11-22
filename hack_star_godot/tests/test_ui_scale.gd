extends GutTest

const BASE: Vector2 = Vector2(1280, 720)


func test_desktop_and_wide_windows_are_not_scaled_up() -> void:
	assert_eq(UiScale.factor(Vector2(1280, 720), BASE), 1.0)
	assert_eq(UiScale.factor(Vector2(1920, 1080), BASE), 1.0)
	assert_eq(UiScale.factor(Vector2(820, 1180), BASE), 1.0, "iPad portrait is above the minimum")


func test_a_phone_in_portrait_is_scaled_up_to_the_minimum() -> void:
	var window: Vector2 = Vector2(390, 844)
	assert_gt(UiScale.factor(window, BASE), 1.0)
	assert_almost_eq(UiScale.total(window, BASE), UiScale.MIN_STRETCH, 0.0001)


func test_every_size_gets_at_least_the_minimum_scale() -> void:
	var windows: Array[Vector2] = [
		Vector2(320, 568), Vector2(390, 844), Vector2(844, 390), Vector2(600, 300)
	]
	for window: Vector2 in windows:
		assert_gte(UiScale.total(window, BASE), UiScale.MIN_STRETCH - 0.0001, str(window))
