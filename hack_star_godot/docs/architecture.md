# Architecture of the Godot game

> How `hack_star_godot/` is organised: where screens, game rules, 3D models, saved progress,
> rooms, the server connection and tests live, and where the parts that are not built yet go.
> Read it before you work on a spec and keep it up to date in the spec that changes it. Parts
> that later specs build are marked *planned — spec NN* (the numbers of the
> [ordered list](../.specs/features/README.md)). The Python + Svelte game of the rest of the
> repository has [its own document](../../docs/architecture.md) with the same sections.

## Layout

Godot 4.7.2, GDScript only, Compatibility renderer, web export without threads (see the
[README](../README.md)).

| Path | What |
|------|------|
| `project.godot` | The project: main scene `scenes/home.tscn`, 1280×720 base size, stretch mode `canvas_items` with aspect `expand`, the input actions `move_left/right/up/down` (WASD and arrow keys) |
| `scenes/` | Screens and objects: each `.tscn` with the script of the same name |
| `scenes/ui/` | Shared UI parts: the theme (`hack_star_theme.tres`), the Back button, the fighter stage and pictures, the fighter card and skin button, the Prestige badge |
| `scenes/autoload/` | The autoloads of `project.godot`: `Screens` (the way from screen to screen), `GameState` (what the player has and has chosen, with the progress and the active hacks saved), `HackServer` (the calls to the server, see *Server, hack codes and rooms*) and `UiScaler` (the content scale factor of the window, see *Minimum sizes* below) |
| `game/` | Game rules: plain scripts without scene access |
| `tests/` | GUT tests, `test_<name>.gd` |
| `tools/` | PowerShell scripts: `check_tools.ps1`, `test.ps1`, `lint.ps1`, `export_web.ps1`, `serve_web.ps1` (the local setup, with `serve_web.py` and `make_cert.py`), `godot.ps1` (finds Godot), the pinned versions in `versions.json` |
| `web/` | Browser scripts that `export_web.ps1` copies into `build/web/`: `qr_scanner.js` (the camera and the scan, own work), `jsQR.js` (the QR decoder, unmodified) and its `jsQR-LICENSE.txt` |
| `addons/gut/` | GUT 9.7.1, the test tool (excluded from the export) |
| `docs/` | This document |
| `export_presets.cfg` | The web export (single-threaded) |
| `LICENSES.md` | The licence of every asset and third-party part |
| `build/` | The web export, created by the tools, git-ignored |
| `.specs/` | The specs of this game |
| `assets/` | *planned — spec 04*: imported art and music, only with their licence in `LICENSES.md`; music stays git-ignored ([README](../README.md#resources-outside-the-folder)) |

## Screens (`scenes/`)

A screen is a scene with a script of the same name. A screen reads the input and calls the
rules of `game/`; it holds no rules itself. A screen opens the next one with `Screens.go_to(path)`, with the path from the constants of
`Screens` (see *UI foundation*); every Back goes home.

| Scene | Script | What |
|-------|--------|------|
| `home.tscn` | `home.gd` | The home screen (main scene): total trophies and credits, the title "Hack star", the chosen fighter and skin in a `FighterStage`, its name and Prestige badge (`ui/prestige_badge.tscn`, only from 1000 trophies), **Play** (opens the match, `match.tscn`), **Training** (opens the arena, `arena.tscn`), **Fighters** (opens `fighter_list.tscn`), **Info** (opens `info.tscn`) and **Hack** (opens `hack_screen.tscn`). Wide screens put the fighter left and the buttons right; tall screens use one column. At each game start (`GameState.entrance_played`) it first plays the entrance (`ENTRANCE_SECONDS` = 2.4: the fighter drops in with a bounce, a light burst and `CPUParticles3D` sparkles, the title pops in); a click, a touch or a key skips it |
| `arena.tscn` | `arena.gd` (`Arena`) | The 3D arena (**Training**): the canyon (`canyon.gd`, `Canyon`, built in code from `ArenaLayout`), one fighter (`Fighter`, with its `FighterModel`), three target dummies (`@export var training`, true here), the shots, the effects, a following camera and the HUD: **Back** (top-left, returns to the home screen), the touch joystick (left), the aim stick `AimJoystick` (right, drag or tap to fire), the FPS label (top-right) and `ControlsHint` (the start hint from `ControlsHelp`, shown at once and faded out after `HINT_SECONDS` + `HINT_FADE_SECONDS`, `mouse_filter` ignore; above the sticks on a touch screen). Space (`shoot`, held) fires too (see *Input*) |
| `match.tscn` | `match_arena.gd` (`MatchArena`) | The match (**Play**), an inheriting scene of `arena.tscn` with the same canyon, player, camera, sticks, Back and FPS label, `training = false` (no dummies). `MatchArena` adds the bots (one `Fighter` each at the next of `ArenaLayout.STARTS`, driven by a `BotBrain` each), the `Match` flow (countdown lock, fight, knock-outs, the end) and the match HUD: `Hud/MatchHud` with `CountdownLabel` (centre), `TimerLabel` (top-centre, red in the last 10 s, on a dark rounded backing) and `FightersLeftLabel` (top-right, under the FPS label). A tap on the right stick or Space fires at the nearest live bot. The `ControlsHint` sits over the countdown without covering the countdown label, the timer, "Fighters left" or **Back** (checked at the five sizes). When the match is over it makes every fighter invulnerable and stores `GameState.last_result` at once (with the trophies: `GameState.award_trophies(fighter, result)` gives the player's fighter `Trophies.reward` and saves; the reward is kept in `last_result["reward"]`; the fighter and skin are read at the start, `_player_fighter` and `_player_skin`, so a hack turning off during the match changes nothing), and 1.5 s later goes to the result screen |
| `result_screen.tscn` | `result_screen.gd` | The result (after a match; no result → home): the heading "Victory!", "Defeat" or "Time's up!" and its line ("You are the last one standing!", "You finished 3rd", "It's a draw"), the player's fighter and skin in a `FighterStage`, the trophy part (`TrophyPanel`, from `last_result["reward"]`, shown only when there is a reward): the change ("+10 trophies", or "+0 trophies"), the count "trophies / next Prestige" and a bar from the last Prestige to the next one, counting up from the old total over 1 s (`COUNT_SECONDS`; only the tests jump to the end, with `finish_count()`); a new Prestige in the match gives a celebration (`Celebration`: "PRESTIGE n!", the `PrestigeBadge` and a short burst), once the count reaches it. **Play again** (opens `match.tscn`) and **Home**. Wide screens put the fighter left, tall screens use one column |
| `shot.gd` | `shot.gd` (`Shot`) | A shot of the arena: a glowing sphere that flies at `Combat.SHOT_SPEED` and stops at the first wall, rock, fighter or dummy (ray casts, D8, D6: the shooter's own RID is excluded), or after `SHOT_RANGE`; it emits `ended` and frees itself |
| `health_bar.gd` | `health_bar.gd` (`HealthBar`) | The health bar above a fighter or a dummy: two billboard quads; `show_ratio(ratio)` sets the fill and the colour (`Combat.health_color`), or `fixed_color` when set (green for the player and red for bots in a match, D7) |
| `damage_number.gd` | `damage_number.gd` (`DamageNumber`) | The rising damage number, `DamageNumber.spawn(parent, at, amount, color)`; white for hits on bots, red for hits on the player, the dummies' colour in Training (D7) |
| `target_dummy.tscn` | `target_dummy.gd` (`TargetDummy`) | A straw dummy (a `StaticBody3D` on the targets layer): health bar (`HealthBar`), damage number (`DamageNumber`), flash on a hit; it breaks apart at 0 and comes back after `respawn_seconds` |
| `arena_effects.gd` | `arena_effects.gd` (`ArenaEffects`) | Small pools of one-shot `CPUParticles3D` in the arena: dust, muzzle flash, hit sparks and the bigger `KNOCKOUT` puff of a knocked-out fighter, restarted by `play(kind, position, color)` |
| `fighter_model.tscn` | `fighter_model.gd` (`FighterModel`) | The fighter's 3D figure with its skins, the idle, run and attack animations and the see-through in a bush (see *3D models*) |
| `fighter_list.tscn` | `fighter_list.gd` | The fighter list (**Fighters** on home; Back goes home): a scrolling grid, columns follow the width, of `ui/fighter_card.tscn` cards — picture, name, rarity in its colour, trophies, power level, Prestige badge; locked fighters greyed out with "Locked". A card opens the fighter screen |
| `fighter_screen.tscn` | `fighter_screen.gd` | The fighter screen (opened from a card; the fighter comes from `GameState.viewed_fighter`): the fighter in a `FighterStage`, name, rarity, trophies, power level, Prestige badge and one `ui/skin_button.tscn` per skin (Legendary skins with a gold frame); choosing a skin previews it; **Select** (`GameState.select`) makes the fighter and previewed skin the home fighter and goes home; for a locked fighter it is disabled and reads "Locked". Back goes home |
| `info.tscn` | `info.gd` | The info page (**Info** on home; Back goes home): a title and a scrolling list. It starts with the "How to play" heading and one section per entry of `ControlsHelp.how_to_play()` (Controls, Match, Training, Trophies and Prestige, Hack codes; the numbers come from the rules), then one row per word of `Vocabulary`, the word in the `WordLabel` style (bold) and its meaning wrapped |
| `fighter.tscn` | `fighter.gd` (`Fighter`) | A `CharacterBody3D` that walks on the ground plane; the arena sets its `input_direction` every physics frame. It has `max_health` and `health` (`MatchSettings.FIGHTER_HEALTH`, 3200), `hit(amount)` (ignored when knocked out or `invulnerable`, which the match sets on every fighter when it is over; emits `hurt`), `heal_step(now, delta)` (`Combat.heal`), `note_action()` (the last hit or shot, for the healing delay), `knock_out()` (spins and shrinks for 0.5 s, then hidden with its collision off; emits `knocked_out_now`) and its own health bar (`show_health_bar(color)`). Only the match's fighters have health; the player in Training shows no bar |
| `target_dummy.tscn` | `target_dummy.gd` (`TargetDummy`) | A straw dummy (a `StaticBody3D` on the targets layer): health bar (`HealthBar`), damage number (`DamageNumber`), flash on a hit; it breaks apart at 0 and comes back after `respawn_seconds` |
| `touch_joystick.tscn` | `touch_joystick.gd` (`TouchJoystick`) | On-screen joystick, visible only on a touch screen; its `direction` has length ≤ 1 |
| `hack_screen.tscn` | `hack_screen.gd` | The hack screen (**Hack** on home; Back goes home): a code field with **Use code** and **Scan QR code** (`QrScanner`; the button is disabled and `ScanHint` says "Camera scanning works in the browser version — type the code here" where `QrScanner.can_scan()` is false, i.e. outside the web export); the server checks every code through `HackServer`; the messages "<name> unlocked!" (with a short celebration), "Unknown code" and "Can't reach the hack server"; the list of active hacks with the time left of each ("Unlimited credits · 2 days 5 hours left", "Power 22 · Lasts for ever"), or "No hacks active" (the time left is refreshed on `progress_changed` and every 60 s while the screen is open); **Turn all hacks off** (with a confirmation); **QR codes** opens `qr_page.tscn`. A code from a `?hack=` link is redeemed once when the game opens |
| `qr_page.tscn` | `qr_page.gd` (`QrPage`) | The QR codes (**QR codes** on the hack screen; Back goes home): one card per hack code from `GET /api/hacks`, with a large QR code of the game's address and `?hack=<CODE>` (`QrImage`) and **Save image** (a download in the browser, else a PNG in `user://`) |

**Camera and screen sizes (S2, S11, D5).** The arena camera looks down at 55° from behind and
above (3D, seen from above at an angle). It follows the fighter: its look-at point moves towards
the fighter (1 m ahead) with exponential smoothing (`Movement.follow`, rate 6/s), and its
distance is set on every `size_changed` of the viewport so that a box of ±7 m (x) and ±5 m (z)
around the fighter fits the screen, landscape or portrait. There is no clamping at the arena's
edges. The UI uses anchors and containers, not fixed pixel positions, so it fits a desktop, an
iPad and a phone; `tests/test_screen_sizes.gd` checks this in sub-viewports of five sizes
(desktop, iPad and phone, landscape and portrait) with the project's own content scale (`canvas_items`, `expand`), as a player sees it.

**Input (S3, D7).** Keyboard through the input actions of `project.godot`; touch through
`TouchJoystick` (`InputEventScreenTouch` and `InputEventScreenDrag`); buttons work with the
mouse and with a touch (Godot emulates the mouse from touch). Space is the `shoot` action (physical
Space): the arena fires while it is held (`Arena._process`), at `_aim_direction()`, the nearest
target in range (in a match the bots still in the match, in Training the dummies still standing),
else straight ahead; the cool-down of `Combat.COOLDOWN` keeps the normal rate. The mouse does not
shoot (spec 16, D11, D12): there is no `_unhandled_input` for it and no ground-point aim, and a
click on **Back** or a touch on a stick never fires. The right stick is a second `TouchJoystick` (`Hud/AimJoystick`)
whose `released(direction, held_seconds)` goes to `Combat.release_aim`: a drag past the dead
zone fires that way, a quick tap fires at the nearest dummy in range (else straight ahead; in a match, the nearest bot).

## Game rules (`game/`)

Pure scripts: `extends RefCounted`, a `class_name`, static functions, static types, no
`get_node`, no `Input`, no `Engine`. They take values and return values, so a test calls them
without a scene.

| Script | What |
|--------|------|
| `movement.gd` (`Movement`) | Input direction to velocity on the ground plane (`clamp_direction`, `velocity`, `step`), joystick direction (`joystick_direction`), facing (`facing_yaw`), the camera's smoothing towards the fighter (`follow`) |
| `controls_help.gd` (`ControlsHelp`) | The texts that say how to play (spec 16, D13, English only): `KEYBOARD_HINT` and `TOUCH_HINT` (the start hint of Training and a match), `MORE_IN_INFO`, and `how_to_play()` (the sections of the Info page, each `{title, text}`); the numbers (shot range, bots, match length, heal delay, respawn, trophies, Prestige size) come from the rules, so the texts stay true (`tests/test_controls_help.gd`) |
| `combat.gd` (`Combat`) | The combat rules (D3 of specs 06 and 07): the numbers (`SHOT_SPEED` 16 m/s, `SHOT_RANGE` 9 m, `COOLDOWN` 0.35 s, `DAMAGE` 480, `DUMMY_HEALTH` 2400, `RESPAWN_SECONDS` 5, `AIM_DEAD_ZONE` 0.3, `TAP_SECONDS` 0.25), `can_fire(now, last_fire, cooldown)` (bots pass `COOLDOWN × level.cooldown`), `take_damage`, `is_broken`, `health_ratio(health, max_health)` and `health_color` (green, yellow below half, red below a quarter), `heal(health, max_health, quiet_seconds, delta, delay, per_second)` (no healing before the delay, never above full), `release_aim` (a drag or a tap, or no shot) and `nearest_target`; there is no ground-point (mouse) aim any more (spec 16, D12) |
| `arena_layout.gd` (`ArenaLayout`) | The canyon as data (D2): the size 20 × 26 m (`SIZE`), the border and the rock blocks (`WALLS`), the cactus patches (`BUSHES`), the decoration spots without collision (`DECORATION`), the three dummy spots (`DUMMIES`), the start point (`START`, near the camera side) and the nine match start points (`STARTS`: the first is `START`, the others spread over the canyon, free of walls and bushes, at least 4 m apart); `in_bush(point)` and `is_free(point, radius)` (the spots lie clear of walls, `tests/test_arena_layout.gd`) |
| `match_settings.gd` (`MatchSettings`) | The settings of a match in one place (D2 of spec 07): `match_seconds` 120, `bot_count` 3 (1–8, clamped), `bot_level` "easy", `time_up_result` "draw" (or "defeat"), `bots_fight_each_other`, `countdown_seconds` 3, `fighter_health` 3200 (7 hits of 480), `heal_delay` 3 s, `heal_per_second` 0.13, `bush_sight` 2.5 m, `trophies_per_win` 10 and `trophies_per_defeat` 0 (spec 08; the win number is never negative, the defeat number is never above 0, so it may be negative), and `LEVELS` (easy, medium, hard: reaction, aim error, cool-down and speed factors, sight; `level(name)`, an unknown name gives easy). `GameState.match_settings` holds the instance the next match reads at its start; it is not saved |
| `trophies.gd` (`Trophies`) | The trophies of a match result (spec 08, D1): `change_for(outcome, settings)` (`trophies_per_win` for a victory, `trophies_per_defeat` for a defeat, 0 for a time-up that is a draw); `reward(before, outcome, settings)` gives `{before, after, change, prestige_before, prestige_after}`, where `after` is never below the last Prestige floor of `before` (a defeat cannot lose a Prestige) |
| `match.gd` (`Match`) | The match flow (D4 of spec 07), no scene: `Match.new(settings, fighter_count)` (fighter 0 is the player); `advance(delta)`; the phases `COUNTDOWN`, `FIGHT` and `OVER`; `countdown_text()` ("3", "2", "1", then "FIGHT!"), `can_act()`, `seconds_left()`, `timer_text()` and `timer_red()` (last 10 s); `knock_out(index)` (records `knock_out_order`, ends the match on the player or on the last bot); `fighters_left()`, `is_alive(index)`; the `result` (`VICTORY`, `DEFEAT`, `TIME_UP`) and `place` (fighters left + 1 at the player's knock-out, else 1: a victory, or time up); `ordinal(n)` ("3rd") |
| `bot_brain.gd` (`BotBrain`) | One bot's decisions (D5 of spec 07), pure, with a `RandomNumberGenerator` the tests seed: `can_see(from, at, in_bush, sight, bush_sight)` (a fighter in a bush is seen only within 2.5 m; walls do not block sight); `think(now, me, opponents, level)` returns `{move, aim}`: the nearest visible opponent, a reaction delay for a new target, closing in, backing off within 3 m or sidestepping, an aim turned by a random error within `aim_error`, and wandering to a free point of `ArenaLayout` when nobody is seen |

| `fighters.gd` (`Fighters`) | The catalogue: the 6 fighters with id, name, rarity, idea, skins (id, name, rarity) and the start unlocks (`ids`, `get_fighter`, `get_skin`, `start_unlocked`) |
| `rarity.gd` (`Rarity`) | The five rarities in order (`NAMES`), their colours (`COLORS`, Legendary gold `LEGENDARY_GOLD`), `rank` and `color` |
| `prestige.gd` (`Prestige`) | `level(trophies)`: 0 below 1000, then one level per 1000 trophies; `floor_of(trophies)` (the trophies of the last Prestige, 0 below 1000) and `next_at(trophies)` (the trophies of the next one) |
| `sample_progress.gd` (`SampleProgress`) | The sample progress every game starts with (trophies, power levels, 500 credits) until matches exist; the start unlocks are `Fighters.start_unlocked()`, and `GameState.reset()` sets the Default skins |
| `vocabulary.gd` (`Vocabulary`) | The 24 words of the info page with their one-sentence meanings (`LIST`); English until spec 15 |
| `hacks.gd` (`Hacks`) | The hack rules (specs 05 and 16): the ids `infinite_credits`, `unlock_all` and `power22` and their names (`ids`, `is_known`, `display_name`); how long each lasts (`duration_seconds`: `infinite_credits` and `unlock_all` 3 days, `power22` for ever; the same numbers as the server's `duration_seconds`), the end time of a hack entered now (`until_for`, `is_expired`) and the time left text (`time_left_text`: "2 days 5 hours left", "Lasts for ever"); a typed or scanned code (`normalize_code`, `code_from_scan`, `code_from_address`); the QR link of a code (`link`); the effects: `credits_text` and `spend` (unlimited credits), `is_fighter_unlocked` (unlock everything), `max_power` and `power_text` (power 22). A hack changes no trophies, unlocks or power levels |
| `save_data.gd` (`SaveData`) | The save file's JSON, `{"version": 3, "revision": n, "hacks": [{"id", "until"}], "progress": {...}}` (`to_json`, `from_json`; `VERSION` 3; spec 16 D1): a version 2 file gives its progress and its hacks (3 days from now), a version 1 file its hacks and an empty progress, and a for-ever hack has `until` 0; a missing, broken or newer file gives no hacks and an empty progress. Every field is checked and the ones that fail are left out (unknown fighters, hacks and skins, wrong types, numbers out of range), so the game fills them from the sample progress |
| `save_store.gd` (`SaveStore`) | Where the save text lives (spec 16, D6): the file `save_path` on the desktop and in the tests; the page's `localStorage` (key `hack_star_save`) in the web export, shared by the browser's tabs of one address (`read`, `write`; a one-time copy of an old `user://` file on the web) |
| `qr_code.gd` (`QrCode`) | A QR code encoder (ISO/IEC 18004, byte mode, level M, versions 1–10): a text in, a matrix of booleans out; the quiet zone is added by `QrImage` |

Later specs add their rules here, one script per rule, with a test next to it in `tests/`:
unlocks and upgrades (spec 09), the hypercharge and creator codes (12, 17). The rules of the
Svelte game in `ui/src/lib/game/` are the model, translated to GDScript.

## UI foundation (S12)

Every screen uses the same parts, so a later spec reuses them and does not build its own:

- **Theme:** `scenes/ui/hack_star_theme.tres` is the project's default theme (`gui/theme/custom`
  in `project.godot`). It holds the colours, the font sizes (label 28, subheading 40, heading
  56, button 36), the button styles (rounded, a minimum height for a thumb) and the panel
  styles. The variations are `BigButton` (the **Play** button), `HeadingLabel`,
  `SubheadingLabel`, `BackgroundPanel`, `CardPanel`, `BadgePanel`, `BadgeLabel`, `WordLabel`,
  `SkinButton` and `LegendarySkinButton` (the gold frame). Screens set no colours or font sizes of
  their own, except the title's size. Colours that code needs (the rarity colours, Legendary
  gold) are the constants of `Rarity`.
- **Screens:** the autoload `Screens` (`scenes/autoload/screens.gd`) has one constant per screen
  path (`HOME`, `ARENA`, `MATCH`, `RESULT`, `FIGHTERS`, `FIGHTER`, `INFO`, and the hack screens),
  `go_to(path)` and `go_home()`. There is no scene stack: every Back goes home.
- **Back:** `scenes/ui/back_button.tscn` (`BackButton`) is top-left on every screen except home
  and calls `Screens.go_home()`.
- **Session state:** the autoload `GameState` (`scenes/autoload/game_state.gd`) holds trophies,
  power levels, unlocked fighters, credits, the selected fighter and skins, `viewed_fighter`,
  `entrance_played`, the active hacks (`active_hacks`) and when each turns off (`hack_until`: Unix
  seconds, `Hacks.FOREVER` for ever; `clock`, a Callable a test replaces for the time), the save
  `revision` this game last read or wrote, the cached `pictures`, the `start_code`
  of a `?hack=` link, `match_settings` (a `MatchSettings`, session only, read at the start of
  each match) and `last_result` (`{outcome, place, fighter, skin, reward}` of the last match,
  session only, set at its end; `reward` is the `Trophies.reward` dictionary). It starts from `SampleProgress` at every game start; `load_saved()` lays the saved
  progress and hacks over it, and the progress is saved with `save()` (see *Saved progress*).
  `award_trophies(fighter_id, outcome)` gives a fighter the trophies of a match and saves at
  once. `select(fighter_id, skin_id)`
  refuses a locked fighter or an unknown skin. `activate_hack(id)` and `reset_hacks()` save at
  once; `redeem_code(text)` checks a code with `HackServer` and activates the hack, so a code
  accepted after Back still counts. `activate_hack` of a timed hack that is on starts a new 3 days.
  `expire_hacks()` turns off the hacks whose time has passed, `sync_from_store()` reads another
  tab's newer save, and `progress_changed` tells the screens that the hacks, the chosen fighter or
  the progress changed on their own (see *Saved progress*).
- **Server:** the autoload `HackServer` (`scenes/autoload/hack_server.gd`) has `redeem(code)` and
  `list_hacks()`, both `await`-able, on `HTTPRequest` with a timeout of 8 s. Each returns a
  `Dictionary` whose `status` is `ok`, `unknown` or `no_server` (see *Server, hack codes and
  rooms*). Tests replace the transport with `HackServer.fake_responder`.
- **Camera and QR codes:** `scenes/ui/qr_scanner.gd` (`QrScanner`) opens the back camera of the
  browser through `web/qr_scanner.js` and reports `scanned`, or `failed` with `not_web`,
  `no_camera`, `denied`, `needs_https` or `cancelled`; outside the browser it only reports
  `not_web`; `QrScanner.can_scan()` is true only in the web export (`OS.has_feature("web")`), so the
  scan button and its hint follow it. `scenes/ui/qr_image.gd` (`QrImage`) draws a `QrCode` as a black-on-white image with
  a quiet zone of 4 modules, 8 px per module.
- **Fighter in 3D:** `scenes/ui/fighter_stage.tscn` (`FighterStage`) shows one `FighterModel` in
  a sub-viewport with its own camera and lights; it keeps the fighter in view on a wide or a tall
  stage. `scenes/ui/fighter_pictures.gd` (`FighterPictures`) renders each fighter once per game
  start into `GameState.pictures`, for the cards of the list.
- **Small parts:** `scenes/ui/prestige_badge.tscn` (`PrestigeBadge`, hidden below 1000
  trophies), `scenes/ui/fighter_card.tscn` (`FighterCard`), `scenes/ui/skin_button.tscn`
  (`SkinButton`).

Screen sizes: the layouts use anchors and containers; `tests/test_screen_sizes.gd` checks every
screen at the five sizes.

**Minimum sizes (spec 04, D13):** the stretch of the 1280-wide base shrinks the layout to 0.30
on a phone in portrait. `game/ui_scale.gd` (`UiScale`) gives a content scale factor that keeps
the total scale at 0.6 or more, the autoload `UiScaler` sets it on the window when it opens or
is resized, and the layouts fit the smaller content area. On the screen every button is then at
least 44 px tall and every text at least 14 px; `test_screen_sizes.gd` checks both at the five
sizes.

## 3D models

There are no imported models, textures or fonts. The canyon (sand floor, rock walls, cacti,
decoration), the dummies, the shots and the effects are built in code from Godot's primitive
meshes (box, cylinder, sphere, capsule) and plain materials: the canyon by `Canyon` from
`ArenaLayout` at `_ready` (a `MultiMeshInstance3D` for the sand tiles, toon-like materials, a
sun with shadows), the dummies by `TargetDummy`, the shots by `Shot`, the dust, flash and sparks
by `ArenaEffects` (`CPUParticles3D`, no `GPUParticles3D`). The fighter is `fighter.tscn` with its
`FighterModel` on the `Model` node (the same figure as in the fighter screen). Fighters are built the same way by
`FighterModel` (`scenes/fighter_model.tscn` + `.gd`): the six fighters with their own shapes and
idea parts (named nodes, e.g. Luna's `RayGun`), and the 14 skins in `FighterModel.LOOKS`. The four
Legendary skins add a halo and sparkles (`LegendaryGlow`). The idle animation (breathing, sway,
flicker) can be switched off for still pictures. `FighterModel` also has the run and attack
animations (D6): `running` switches the idle to a run (a bounce, a forward lean, a faster head
bob) and `play_attack()` runs a 0.25 s recoil on top of it (`attack_left`). In a bush
(`set_see_through`, D11) the fighter's materials are swapped for alpha copies (alpha 0.45); the
Compatibility renderer does not show `GeometryInstance3D.transparency`, as the screenshots
showed. Like the Svelte game's `ui/src/lib/models/`, but in code.

If a later spec imports art, it goes to `assets/` with its licence written in
[LICENSES.md](../LICENSES.md) (the packs of the Python + Svelte game, Quaternius and Kenney,
are CC0). No Supercell art, names or logos are used (S7).

## Physics layers (D13)

The layers are named in `project.godot`: 1 `world` (floor, walls, rocks), 2 `fighter`, 3
`targets` (the dummies). The fighter is on layer 2 and its mask is world + targets (5), so it
cannot walk through a wall, a rock or a dummy; fighters do not block each other. A shot
(`Shot.COLLISION_MASK`, world + fighter + targets, 7) casts a ray from its last to its next
position every physics frame, so a thin wall is never missed at 16 m/s (D8); it hits fighters
too, and `Shot.launch` takes the shooter, whose RID is excluded from every ray, so a fighter never
hits itself (spec 07, D6). The dummies are on layer 3 and do not look for anything (mask 0).

## Saved progress (*done: specs 05, 08 and 16*)

The save file is one JSON text, `{"version": 3, "revision": n, "hacks": [{"id", "until"}, ...],
"progress": {...}}` (spec 16, D1; version 2 of spec 08 and version 1 of spec 05 are migrated).
`until` is the Unix time in seconds when a hack turns off, `0` (`Hacks.FOREVER`) for a hack that
never does; `revision` counts the saves of all tabs. The progress: `trophies` and `power_levels`
per fighter, `unlocked` fighters, `credits`, `selected_fighter` and `selected_skins` per fighter.
It is read and written by **the autoload `GameState`** only (`save_path`, `load_saved`, `save`,
`sync_from_store`), so no screen touches the store; the format is in `SaveData` and the place is in
`SaveStore`. `SaveStore` (`game/save_store.gd`) has two places. On the desktop and in the tests it
is the file `user://hack_star_save.json` (`save_path`; on Windows it is in
`%APPDATA%\Godot\app_userdata\Hack star\`). In the web export it is the page's `localStorage`
under the key `hack_star_save` (`SaveStore.WEB_KEY`): every tab of the same address reads and
writes the same item, where Godot's `user://` on the web would be a copy made when each tab
started. A web start with no `localStorage` item copies an old `user://` file into it once and
leaves that file. Nothing is shared between devices or browsers, and there is no login.

**Versions:** a version 3 file gives its hacks with their end times; a version 2 file (spec 08)
gives its progress and its hacks, and each of its hacks gets 3 days from the first start of this
version (`until_for`), so codes active when this version first opens get their 3 days from that
moment; a version 1 file gives its hacks the same way and the sample progress. A newer or broken
file gives no hacks and the sample progress rather than a wrong one. Every field is checked when
it is read (known ids, whole numbers, values in range, `until` not further than the duration
from now); a wrong one is left out and the sample progress fills it.

**Across tabs (D6, D7):** `GameState.save()` first reads the store; a stored revision newer than
the one this game last read or wrote is merged in (`_merge`): hacks are the union with the later
end (expired ones left out), `unlocked` is the union, trophies and power levels are the higher per
fighter; credits, the chosen fighter and skins stay this tab's. Then it writes with `revision` + 1
and emits `progress_changed` when a merge happened. `sync_from_store()` lays a newer stored save
over the tab (`_lay_over`), keeps the chosen fighter usable and turns expired hacks off; it runs
when the game gets the focus (`NOTIFICATION_APPLICATION_FOCUS_IN`) and, on the web, when the page
becomes `visible` (`visibilitychange`), so a tab that comes back to the front shows the others'
changes without reloading. Screens that show hacks, the chosen fighter, the trophies or the power
levels connect to `progress_changed`. **Known limitation (spec 16, D9):** because hacks merge as a
union, a hack turned off in one tab can return when another tab that has not synced saves; there
is no per-hack removal marker.

**Hacks turning off:** `expire_hacks()` runs at each load, at every sync and every 30 s
(`EXPIRY_CHECK_SECONDS`, a timer of `GameState`). A hack whose `until` has passed is removed,
the save is written and `progress_changed` is emitted. Only the hacks go: nothing that was gained
or chosen is removed (spec 16, S19). `_keep_usable_selection()` then chooses another unlocked
fighter (the sample fighter, else the first unlocked one) when the chosen one is locked again
(S22); `reset_hacks()` does the same when all hacks are turned off. A running match keeps the
fighter and skin it started with (`MatchArena._player_fighter`), and gives them its trophies.

Credits, unlocks and power upgrades that change with play are saved as fields but not yet changed
by play (spec 09).

## Server, hack codes and rooms (*hack codes: done, spec 05; rooms: planned — spec 14*)

Rooms and hack codes come from the **existing FastAPI server** in `server/` (S15), unchanged
and with no Godot-only endpoint, so the Godot game and the Svelte game share the same codes
and rooms. The Godot game calls it with `HTTPRequest` (`HackServer`) and, for rooms, `WebSocketPeer`:

| Call | What | Spec |
|------|------|------|
| `GET /api/hacks` | The hack codes (for the QR page, `HackServer.list_hacks`) | 05 |
| `POST /api/hacks/redeem` with `{"code": "…"}` | The hack for a code (any case, spaces trimmed), or 404 "Unknown code" (`HackServer.redeem`); a hack id the game does not know (`hypercharge`, `creator`) is "unknown" too | 05 |
| WebSocket `/api/rooms` | Rooms with up to 2 friends: the messages `create`, `join`, `start`, `state`, `lobby` and `input` from the client; `room`, `left`, `closed` and `error` from the server (`server/src/hack_star_server/rooms.py`) | 14 |

**Same address (D3).** The web export reaches the server at `/api` on the address the page came
from, as the Svelte game does through the Vite proxy (`ui/vite.config.ts`: `/api` goes to
`127.0.0.1:8180`, WebSockets included). That needs no CORS settings in the server and works
the same on an iPad over Wi-Fi. The local tool that serves `build/web/` and forwards `/api`
(HTTP and WebSocket) to the server is `tools/serve_web.ps1` (spec 05, D3): it runs
`tools/serve_web.py` on port 8060 with `-ApiUrl` (default `http://127.0.0.1:8180`, where
`cd server; uv run hack-star-server` listens); `-Https` serves a self-signed certificate
(`tools/make_cert.py`, kept in `build/cert/`) for the camera on an iPad. The server runs with
`uv` from the `server/` folder; its tests stay in `server/tests/`.

## Languages (*planned — spec 15*)

The game has no translations yet; all text is in the scenes. Spec 15 adds the languages (as
`ui/src/lib/i18n/` in the Svelte game); until then new visible text is written once, in
English, in the scene.

## Art and licences

Everything in the game is original or has a free licence (S7). Today: own work built in code,
Godot's built-in default font, GUT (test tool, not exported) and jsQR 1.4.0 (Apache-2.0,
`web/jsQR.js`, copied into the web export for the camera scanner). Every asset and
third-party part is listed in [LICENSES.md](../LICENSES.md); add a row there in the same Step
that adds an asset.

## Tests and checks

Tests are GUT 9.7.1 files in `tests/`: `test_movement.gd` checks `game/movement.gd` (also `follow`);
`test_combat.gd` checks the combat rules and `test_arena_layout.gd` the canyon layout (start,
dummies and bushes free of walls, `in_bush`); `test_fighters.gd`, `test_prestige.gd`, `test_rarity.gd`, `test_sample_progress.gd`,
`test_vocabulary.gd` and `test_game_state.gd` check the rules and the session (the active hacks,
saved to a file under `user://test/`); `test_hacks.gd`, `test_save_data.gd` and `test_qr_code.gd`
check the hack rules, the save file and the QR encoder (against `tests/fixtures/`);
`test_hack_server.gd` checks `HackServer` with a fake responder, so no test uses the network;
`test_hack_effects.gd` checks the effects on the screens; `test_fighter_model.gd` checks the 3D
fighters (the run and attack animations); `test_home.gd`, `test_fighter_list.gd`, `test_fighter_screen.gd`, `test_info.gd`,
`test_back_button.gd`, `test_hack_screen.gd` and `test_qr_page.gd` check the scenes, `test_qr_scanner.gd` the camera messages;
`test_arena.gd` checks the arena (the walls from the layout, the selected fighter's model, the
camera following, Space and the aim stick firing, a click firing nothing, Back), `test_arena_dummies.gd` the dummies
in the arena (a shot lowers one, a tap aims at the nearest), `test_target_dummy.gd` a dummy alone,
`test_shot.gd` a shot (it ends at a wall or after its range), `test_arena_effects.gd` the effect
pools and the see-through in a bush, and `test_touch_joystick.gd` the stick and its `released` signal; `test_screens.gd` checks the screen constants and
`go_to`; `test_screen_sizes.gd` checks that every screen fits five screen sizes (the arena with its aim stick) and that Play,
Info, Back, the cards, the skin buttons and Select react to a mouse click and a touch (real input
pushed with `tests/ui_input.gd`); `test_ui_scale.gd` checks the scale factor. The match (spec 07):
`test_match_settings.gd`, `test_match.gd` and `test_bot_brain.gd` check the settings, the match flow
and the bots' brains without a scene; `test_combat.gd` also checks the fighters' health and healing;
`test_fighter_health.gd` checks the hits, the bars, the knock-out and that a shot never hits its
shooter; `test_match_arena.gd` checks the match scene (start points, bots, the countdown lock, a
tap on a bot, the results, Back); `test_match_hud.gd` and `test_result_screen.gd` check the HUD and
the result screen; `test_home.gd` checks **Play** and **Training**; `test_screen_sizes_match.gd`
checks the match HUD and the result screen at the five sizes, with mouse and touch. The trophies
(spec 08): `test_trophies.gd` and `test_prestige.gd` check the rules (the change, the floor of the
last Prestige); `test_match_trophies.gd` checks the award at the end of a match;
`test_result_trophies.gd` the trophy part of the result screen; `test_save_data_v2.gd`,
`test_save_data.gd` and `test_game_state_save.gd` the save file (version 2, the version 1
migration, the progress kept between a restart and the fields checked); `test_save_data_v3.gd` the version 3 file (the end times, the version 2 and 1 migrations with 3 days from now, the checks); `test_hack_times.gd` the durations, the end times and the time left text, `test_hack_expiry.gd` a timed hack turning off (its end time, the chosen fighter, the match keeping its fighter, a for-ever hack); `test_hack_time_rows.gd` the time left on the hack screen; The controls and the help (spec 16): `test_arena_space.gd` checks Space firing at the nearest
target and held fire, `test_controls_help.gd` the help texts (their numbers from the rules),
`test_controls_hint.gd` the start hint (shown, faded, clear of the match HUD, ignores the mouse),
and `test_hack_screen_scan.gd` the scan button and its hint without and with a scanner. `test_mvp_flow.gd` plays
F0–F5 in one run (see *Spec order*). Every test saves to `user://test/run_save.json`, never to the
player's file: the pre-run hook `tests/pre_run_hook.gd` sets `GameState.save_path` and starts from
the sample progress. Only `tools/test.ps1` passes the hook (`-gpre_run_script`): GUT started from
the editor's panel needs the hook set in its settings, or the tests write the player's file. Run
them headless, from the `hack_star_godot` folder:

| Command | What |
|---------|------|
| `.\tools\check_tools.ps1` | The pinned versions of Godot, export templates, gdtoolkit and GUT |
| `.\tools\test.ps1` | All GUT tests; exit code 0 means they pass |
| `.\tools\lint.ps1` | `gdlint` and `gdformat --check` on `game/`, `scenes/`, `tests/` |
| `.\tools\export_web.ps1` | Exports the game to `build\web\` |
| `.\tools\serve_web.ps1` | Serves `build\web\` on port 8060 for a desktop browser or an iPad, and forwards `/api` to the hack server (`-ApiUrl`, `-Https`; see the [README](../README.md#run-the-hack-server-and-the-web-game)) |

The rules for the code are in [.specs/guidelines/gdscript.md](../.specs/guidelines/gdscript.md).
A Step is done when `test.ps1` and `lint.ps1` pass; the last Step of a spec also runs
`export_web.ps1`. When a spec changes `server/`, `cd server; uv run pytest` must pass too.
What a script cannot check — the play-test on a real iPad and phone (touch, at least 30 frames
per second, S1, S3, S6, and the hack codes with the in-game camera over `-Https`, the camera app
and the on-screen keyboard, spec 05 D6) — is done by the author with `export_web.ps1` and
`serve_web.ps1`; the FPS label in the arena shows the frame rate.

## Spec order

The specs are in [.specs/features/README.md](../.specs/features/README.md). The MVP (S8) is
specs 03–08, which bring F0–F5 of the feature list; the later specs follow the feature list
(S10). F0–F5 are built and play together: `tests/test_mvp_flow.gd` goes through home, a hack
code, the fighter list and screen, a match, the result with its trophies and home again, then
loads the progress of a fresh start from the same file. Each spec needs only features of specs
with a lower number. The Godot specs live in
`hack_star_godot/.specs/`, not in the root `.specs/` ([AGENTS.md](../../AGENTS.md)).

## How to…

**Add a screen.** Create `scenes/<name>.tscn` and `scenes/<name>.gd` (same name); build the UI
with anchors and containers and the shared parts of *UI foundation* (the theme, a Back button
from `scenes/ui/back_button.tscn`); add its path as a constant of `Screens`, open it with
`Screens.go_to(...)`; write `tests/test_<name>.gd` that loads the scene and checks its controls,
and add its size checks to `tests/test_screen_sizes.gd`; add a row to *Screens* above.

**Add a game rule.** Create `game/<name>.gd` (`extends RefCounted`, `class_name`, static
functions, typed, no scene access), call it from the scene, and write `tests/test_<name>.gd`
that calls it directly; add a row to *Game rules* above.

**Add a test.** Create `tests/test_<name>.gd` (`extends GutTest`, functions named
`test_…`), run `.\tools\test.ps1`, then `.\tools\lint.ps1`.

**Add an asset.** Put it in `assets/`, add its source and licence to
[LICENSES.md](../LICENSES.md), and name it in this document.
