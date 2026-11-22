extends GutTest
## The progress across the browser's tabs (spec 16, S4, D6, D7): two `GameState` objects on one
## test file stand for two tabs; a fake web store checks the move to `localStorage`.

const GAME_STATE: GDScript = preload("res://scenes/autoload/game_state.gd")
const TEST_SAVE: String = "user://test/save_tabs.json"
const START: int = 1_764_000_000
const OLD_FILE: String = '{"version": 2, "hacks": ["power22"], "progress": {}}'


## A web store whose `localStorage` is a dictionary.
class FakeWebStore:
	extends SaveStore

	var items: Dictionary = {}

	func _init(file_path: String) -> void:
		super(file_path, true)

	func _get_item(key: String) -> Variant:
		return items.get(key)

	func _set_item(key: String, text: String) -> bool:
		items[key] = text
		return true


var _now: int = START


func before_each() -> void:
	DirAccess.make_dir_recursive_absolute(TEST_SAVE.get_base_dir())
	DirAccess.remove_absolute(TEST_SAVE)
	_now = START


func after_all() -> void:
	DirAccess.remove_absolute(TEST_SAVE)


# A tab opened now: the sample progress, then the store.
func _open_tab() -> Node:
	var tab: Node = autofree(GAME_STATE.new())
	tab.reset()
	tab.save_path = TEST_SAVE
	tab.clock = func() -> int: return _now
	tab.load_saved()
	return tab


func _stored() -> Dictionary:
	return SaveData.from_json(FileAccess.get_file_as_string(TEST_SAVE), _now)


func test_a_hack_from_one_tab_is_kept_when_the_other_writes() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	assert_true(second.activate_hack("infinite_credits"))
	first.award_trophies("blaze", Match.Result.VICTORY)
	var stored: Dictionary = _stored()
	assert_eq(stored["hacks"].keys(), ["infinite_credits"])
	assert_eq(stored["progress"]["trophies"]["blaze"], 1250)
	assert_true(first.has_hack("infinite_credits"))


func test_the_other_tab_shows_a_new_hack_after_sync_from_store() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	watch_signals(first)
	second.activate_hack("unlock_all")
	assert_false(first.has_hack("unlock_all"))
	assert_true(first.sync_from_store())
	assert_true(first.has_hack("unlock_all"))
	assert_eq(first.hack_until["unlock_all"], START + Hacks.TIMED_SECONDS)
	assert_signal_emitted(first, "progress_changed")


func test_sync_reads_the_trophies_and_choice_of_the_other_tab() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	second.award_trophies("rocko", Match.Result.VICTORY)
	second.select("rocko", Fighters.DEFAULT_SKIN)
	first.sync_from_store()
	assert_eq(first.trophies["rocko"], second.trophies["rocko"])
	assert_ne(first.trophies["rocko"], SampleProgress.TROPHIES["rocko"])
	assert_eq(first.selected_fighter, "rocko")


func test_an_older_or_equal_store_revision_changes_nothing() -> void:
	var first: Node = _open_tab()
	first.activate_hack("power22")
	watch_signals(first)
	assert_false(first.sync_from_store())
	assert_signal_not_emitted(first, "progress_changed")
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string(SaveData.to_json({}, {}, 0))
	file.close()
	assert_false(first.sync_from_store())
	assert_true(first.has_hack("power22"))


func test_merge_keeps_the_later_end_of_a_hack_and_drops_expired_ones() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	first.activate_hack("infinite_credits")
	_now += Hacks.DAY_SECONDS
	second.activate_hack("infinite_credits")
	_now += Hacks.DAY_SECONDS
	first.award_trophies("blaze", Match.Result.VICTORY)
	var expected: int = START + Hacks.DAY_SECONDS + Hacks.TIMED_SECONDS
	assert_eq(first.hack_until["infinite_credits"], expected)
	assert_eq(_stored()["hacks"]["infinite_credits"], expected)
	_now = expected + 1
	var third: Node = _open_tab()
	assert_false(third.has_hack("infinite_credits"))


func test_merge_takes_the_higher_numbers_and_the_union_of_unlocked() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	second.trophies["blaze"] = 2000
	second.power_levels["rocko"] = 9
	second.unlocked.append("pixel")
	second.credits = 5
	second.save()
	first.trophies["turbo"] = 999
	first.credits = 77
	first.save()
	var progress: Dictionary = _stored()["progress"]
	assert_eq(progress["trophies"]["blaze"], 2000)
	assert_eq(progress["trophies"]["turbo"], 999)
	assert_eq(progress["power_levels"]["rocko"], 9)
	assert_true(progress["unlocked"].has("pixel"))
	assert_eq(progress["credits"], 77)


func test_merge_keeps_this_tabs_choice_and_skins() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	var skin: String = Fighters.get_fighter("blaze")["skins"][1]["id"]
	second.select("rocko", Fighters.DEFAULT_SKIN)
	first.select("blaze", skin)
	var progress: Dictionary = _stored()["progress"]
	assert_eq(progress["selected_fighter"], "blaze")
	assert_eq(progress["selected_skins"]["blaze"], skin)


func test_each_save_writes_the_next_revision() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	first.save()
	assert_eq(_stored()["revision"], 1)
	second.save()
	assert_eq(_stored()["revision"], 2)
	first.save()
	assert_eq(_stored()["revision"], 3)


func test_the_web_store_moves_the_old_file_once() -> void:
	var file: FileAccess = FileAccess.open(TEST_SAVE, FileAccess.WRITE)
	file.store_string(OLD_FILE)
	file.close()
	var store: FakeWebStore = FakeWebStore.new(TEST_SAVE)
	assert_eq(store.read(), OLD_FILE)
	assert_eq(store.items[SaveStore.WEB_KEY], OLD_FILE)
	assert_true(store.write("new"))
	assert_eq(store.read(), "new")
	assert_eq(FileAccess.get_file_as_string(TEST_SAVE), OLD_FILE)


func test_the_web_store_without_a_key_or_file_reads_nothing() -> void:
	var store: FakeWebStore = FakeWebStore.new(TEST_SAVE)
	assert_eq(store.read(), "")
	assert_false(store.items.has(SaveStore.WEB_KEY))


func test_the_file_store_reads_what_it_wrote() -> void:
	var store: SaveStore = SaveStore.new(TEST_SAVE)
	assert_eq(store.read(), "")
	assert_true(store.write("text"))
	assert_eq(store.read(), "text")


func test_the_game_coming_to_the_front_syncs_from_the_store() -> void:
	var first: Node = _open_tab()
	var second: Node = _open_tab()
	second.activate_hack("unlock_all")
	first.notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	assert_true(first.has_hack("unlock_all"))


## A game whose page visibility is set by the test.
class PageGameState:
	extends "res://scenes/autoload/game_state.gd"

	var visible: bool = true

	func _page_is_visible() -> bool:
		return visible


func test_the_page_becoming_visible_syncs_but_a_hidden_page_does_not() -> void:
	var first: PageGameState = autofree(PageGameState.new())
	first.reset()
	first.save_path = TEST_SAVE
	first.clock = func() -> int: return _now
	first.load_saved()
	var second: Node = _open_tab()
	second.activate_hack("power22")
	first.visible = false
	first._on_page_visibility([])
	assert_false(first.has_hack("power22"))
	first.visible = true
	first._on_page_visibility([])
	assert_true(first.has_hack("power22"))
