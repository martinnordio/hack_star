extends GutTest

var _none: Array[String] = []
var _credits: Array[String] = [Hacks.INFINITE_CREDITS]
var _unlock: Array[String] = [Hacks.UNLOCK_ALL]
var _power: Array[String] = [Hacks.POWER22]


func test_a_typed_code_is_trimmed_and_upper_case() -> void:
	assert_eq(Hacks.normalize_code(" infinity "), "INFINITY")
	assert_eq(Hacks.normalize_code("OpenSesame"), "OPENSESAME")


func test_a_scan_is_a_code_or_a_link_with_the_code() -> void:
	assert_eq(Hacks.code_from_scan("power22"), "POWER22")
	assert_eq(Hacks.code_from_scan("http://localhost:8060/?hack=opensesame"), "OPENSESAME")
	assert_eq(Hacks.code_from_scan("https://x.test/game/?a=1&hack=INFINITY#top"), "INFINITY")
	assert_eq(Hacks.code_from_scan("https://x.test/?other=1"), "")


func test_the_game_address_gives_the_code_only_with_hack() -> void:
	assert_eq(Hacks.code_from_address("https://x.test:8060/?hack=opensesame"), "OPENSESAME")
	assert_eq(Hacks.code_from_address("https://x.test:8060/"), "")
	assert_eq(Hacks.code_from_address("https://x.test:8060/?debug=1"), "")


func test_credits_show_the_infinity_sign_only_with_the_hack() -> void:
	assert_eq(Hacks.credits_amount(500, _none), "500")
	assert_eq(Hacks.credits_amount(500, _credits), "∞")
	assert_eq(Hacks.credits_amount(500, _power), "500")


func test_spend_keeps_the_credits_with_the_hack() -> void:
	assert_eq(Hacks.spend(500, 120, _none), 380)
	assert_eq(Hacks.spend(500, 120, _credits), 500)


func test_unlock_all_unlocks_every_fighter() -> void:
	var unlocked: Array[String] = ["blaze"]
	assert_false(Hacks.is_fighter_unlocked("luna", unlocked, _none))
	assert_true(Hacks.is_fighter_unlocked("blaze", unlocked, _none))
	assert_true(Hacks.is_fighter_unlocked("luna", unlocked, _unlock))
	assert_true(Hacks.is_skin_unlocked("luna", "galaxy", _none), "skins have no locks yet")


func test_power_22_raises_the_maximum_and_shows_it() -> void:
	assert_eq(Hacks.max_power(_none), 11)
	assert_eq(Hacks.max_power(_power), 22)
	assert_eq(Hacks.power_amount(7, _none), "7 / 11")
	assert_eq(Hacks.power_amount(7, _power), "7 / 22")


func test_a_qr_link_carries_the_code_and_reads_back_as_the_code() -> void:
	var link: String = Hacks.link("http://localhost:8060/", " power22 ")
	assert_eq(link, "http://localhost:8060/?hack=POWER22")
	assert_eq(Hacks.code_from_scan(link), "POWER22")


func test_known_ids() -> void:
	assert_true(Hacks.is_known("power22"))
	assert_false(Hacks.is_known("hypercharge"))


func test_every_known_hack_has_a_name_for_the_list() -> void:
	assert_eq(Hacks.display_name(Hacks.INFINITE_CREDITS), "Unlimited credits")
	assert_eq(Hacks.display_name(Hacks.UNLOCK_ALL), "Unlock everything")
	assert_eq(Hacks.display_name(Hacks.POWER22), "Power 22")
