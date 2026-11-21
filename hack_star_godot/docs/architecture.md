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
| `scenes/autoload/` | The autoloads of `project.godot`: `Screens` (the way from screen to screen), `GameState` (what the player has and has chosen, with the active hacks saved), `HackServer` (the calls to the server, see *Server, hack codes and rooms*) and `UiScaler` (the content scale factor of the window, see *Minimum sizes* below) |
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
| `home.tscn` | `home.gd` | The home screen (main scene): total trophies and credits, the title "Hack star", the chosen fighter and skin in a `FighterStage`, its name and Prestige badge (`ui/prestige_badge.tscn`, only from 1000 trophies), **Play** (opens the arena) and **Fighters** (opens `fighter_list.tscn`) and **Info** (opens `info.tscn`) and **Hack** (opens `hack_screen.tscn`). Wide screens put the fighter left and the buttons right; tall screens use one column. At each game start (`GameState.entrance_played`) it first plays the entrance (`ENTRANCE_SECONDS` = 2.4: the fighter drops in with a bounce, a light burst and `CPUParticles3D` sparkles, the title pops in); a click, a touch or a key skips it |
| `arena.tscn` | `arena.gd` | The 3D arena (floor, walls, inner walls), one fighter, the camera and the HUD: **Back** (top-left, returns to the home screen), the touch joystick and the FPS label (top-right) |
| `fighter_list.tscn` | `fighter_list.gd` | The fighter list (**Fighters** on home; Back goes home): a scrolling grid, columns follow the width, of `ui/fighter_card.tscn` cards — picture, name, rarity in its colour, trophies, power level, Prestige badge; locked fighters greyed out with "Locked". A card opens the fighter screen |
| `fighter_screen.tscn` | `fighter_screen.gd` | The fighter screen (opened from a card; the fighter comes from `GameState.viewed_fighter`): the fighter in a `FighterStage`, name, rarity, trophies, power level, Prestige badge and one `ui/skin_button.tscn` per skin (Legendary skins with a gold frame); choosing a skin previews it; **Select** (`GameState.select`) makes the fighter and previewed skin the home fighter and goes home; for a locked fighter it is disabled and reads "Locked". Back goes home |
| `info.tscn` | `info.gd` | The info page (**Info** on home; Back goes home): a title and a scrolling list with one row per word of `Vocabulary`, the word in the `WordLabel` style (bold) and its meaning wrapped |
| `fighter.tscn` | `fighter.gd` (`Fighter`) | A `CharacterBody3D` that walks on the ground plane; the arena sets its `input_direction` every physics frame |
| `touch_joystick.tscn` | `touch_joystick.gd` (`TouchJoystick`) | On-screen joystick, visible only on a touch screen; its `direction` has length ≤ 1 |
| `hack_screen.tscn` | `hack_screen.gd` (`HackScreen`) | The hack screen (**Hack** on home; Back goes home): a code field with **Use** and **Scan QR code** (`QrScanner`); the server checks every code through `HackServer`; the messages "<name> unlocked!" (with a short celebration), "Unknown code" and "Can't reach the hack server"; the list of active hacks or "No hacks active"; **Turn all hacks off** (with a confirmation); **QR codes** opens `qr_page.tscn`. A code from a `?hack=` link is redeemed once when the game opens |
| `qr_page.tscn` | `qr_page.gd` (`QrPage`) | The QR codes (**QR codes** on the hack screen; Back goes home): one card per hack code from `GET /api/hacks`, with a large QR code of the game's address and `?hack=<CODE>` (`QrImage`) and **Save image** (a download in the browser, else a PNG in `user://`) |

**Camera and screen sizes (S2, S11).** The arena camera looks down at 55° from behind and above
(3D, seen from above at an angle) and moves back until the four top corners of the walls are
inside the screen with a margin, so the arena fits landscape and portrait. It does this again
on every `size_changed` of the viewport. The UI uses anchors and containers, not fixed pixel
positions, so it fits a desktop, an iPad and a phone; `tests/test_screen_sizes.gd` checks this in sub-viewports
of five sizes (desktop, iPad and phone, landscape and portrait) with the project's own content scale (`canvas_items`, `expand`), as a player sees it.

**Input (S3).** Keyboard through the input actions of `project.godot`; touch through
`TouchJoystick` (`InputEventScreenTouch` and `InputEventScreenDrag`); buttons work with the
mouse and with a touch (Godot emulates the mouse from touch).

## Game rules (`game/`)

Pure scripts: `extends RefCounted`, a `class_name`, static functions, static types, no
`get_node`, no `Input`, no `Engine`. They take values and return values, so a test calls them
without a scene.

| Script | What |
|--------|------|
| `movement.gd` (`Movement`) | Input direction to velocity on the ground plane (`clamp_direction`, `velocity`, `step`), joystick direction (`joystick_direction`), facing (`facing_yaw`) |
| `fighters.gd` (`Fighters`) | The catalogue: the 6 fighters with id, name, rarity, idea, skins (id, name, rarity) and the start unlocks (`ids`, `get_fighter`, `get_skin`, `start_unlocked`) |
| `rarity.gd` (`Rarity`) | The five rarities in order (`NAMES`), their colours (`COLORS`, Legendary gold `LEGENDARY_GOLD`), `rank` and `color` |
| `prestige.gd` (`Prestige`) | `level(trophies)`: 0 below 1000, then one level per 1000 trophies |
| `sample_progress.gd` (`SampleProgress`) | The sample progress every game starts with (trophies, power levels, 500 credits) until matches exist; the start unlocks are `Fighters.start_unlocked()`, and `GameState.reset()` sets the Default skins |
| `vocabulary.gd` (`Vocabulary`) | The 24 words of the info page with their one-sentence meanings (`LIST`); English until spec 15 |
| `hacks.gd` (`Hacks`) | The hack rules (spec 05): the ids `infinite_credits`, `unlock_all` and `power22` and their names (`ids`, `is_known`, `display_name`); a typed or scanned code (`normalize_code`, `code_from_scan`, `code_from_address`); the QR link of a code (`link`); the effects: `credits_text` and `spend` (unlimited credits), `is_fighter_unlocked` (unlock everything), `max_power` and `power_text` (power 22). A hack changes no trophies, unlocks or power levels |
| `save_data.gd` (`SaveData`) | The save file's JSON, `{"version": 1, "hacks": [...]}` (`to_json`, `from_json`): a missing, broken or newer file gives no hacks, and ids the game does not know are dropped |
| `qr_code.gd` (`QrCode`) | A QR code encoder (ISO/IEC 18004, byte mode, level M, versions 1–10): a text in, a matrix of booleans out; the quiet zone is added by `QrImage` |

Later specs add their rules here, one script per rule, with a test next to it in `tests/`:
trophies and unlocks (specs 08, 09), the match (07), the hypercharge and creator codes (12,
17). The rules of the
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
  path (`HOME`, `ARENA`, `FIGHTERS`, `FIGHTER`, `INFO`), `go_to(path)` and `go_home()`. There is
  no scene stack: every Back goes home.
- **Back:** `scenes/ui/back_button.tscn` (`BackButton`) is top-left on every screen except home
  and calls `Screens.go_home()`.
- **Session state:** the autoload `GameState` (`scenes/autoload/game_state.gd`) holds trophies,
  power levels, unlocked fighters, credits, the selected fighter and skins, `viewed_fighter`,
  `entrance_played`, the active hacks (`active_hacks`), the cached `pictures` and the `start_code`
  of a `?hack=` link. It starts from `SampleProgress` at every game start; the active hacks are
  read from and written to the save file (see *Saved progress*). `select(fighter_id, skin_id)`
  refuses a locked fighter or an unknown skin. `activate_hack(id)` and `reset_hacks()` save at
  once.
- **Server:** the autoload `HackServer` (`scenes/autoload/hack_server.gd`) has `redeem(code)` and
  `list_hacks()`, both `await`-able, on `HTTPRequest` with a timeout of 8 s. Each returns a
  `Dictionary` whose `status` is `ok`, `unknown` or `no_server` (see *Server, hack codes and
  rooms*). Tests replace the transport with `HackServer.fake_responder`.
- **Camera and QR codes:** `scenes/ui/qr_scanner.gd` (`QrScanner`) opens the back camera of the
  browser through `web/qr_scanner.js` and reports `scanned`, or `failed` with `not_web`,
  `no_camera`, `denied`, `needs_https` or `cancelled`; outside the browser it only reports
  `not_web`. `scenes/ui/qr_image.gd` (`QrImage`) draws a `QrCode` as a black-on-white image with
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

There are no imported models, textures or fonts. The arena, walls and fighter are built from
Godot's primitive meshes (box, capsule, sphere) and plain materials, in the scene files (S7,
S11). Fighters are built the same way by `FighterModel` (`scenes/fighter_model.tscn` + `.gd`):
the six fighters with their own shapes and idea parts (named nodes, e.g. Luna's `RayGun`), and
the 14 skins in `FighterModel.LOOKS`. The four Legendary skins add a halo and sparkles
(`LegendaryGlow`). The idle animation (breathing, sway, flicker) can be switched off for still
pictures. Like the Svelte game's `ui/src/lib/models/`, but in code.

If a later spec imports art, it goes to `assets/` with its licence written in
[LICENSES.md](../LICENSES.md) (the packs of the Python + Svelte game, Quaternius and Kenney,
are CC0). No Supercell art, names or logos are used (S7).

## Saved progress (*planned — spec 05 / spec 08*)

The save file is one JSON file, `user://hack_star_save.json` (spec 05, D5), with `{"version": 1,
"hacks": [...]}`: the active hacks, as ids. It is read and written by **the autoload
`GameState`** only (`save_path`, `_load_hacks`, `_save_hacks`), so no screen touches the file;
the rules of the format are in `SaveData`. `version` lets later specs migrate it: a newer file
gives no hacks rather than a wrong one. In the browser, Godot keeps `user://` in the browser's
IndexedDB, so progress stays on the same device and in the same browser; on Windows the desktop
run keeps it in `%APPDATA%\Godot\app_userdata\Hack star\`. There is no login and nothing is
shared between devices. Spec 08 adds trophies, unlocked fighters and the selection (a new
`version` when the fields change); until then only the active hacks are saved (*Deferred Items*
of spec 05).

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

Tests are GUT 9.7.1 files in `tests/`: `test_movement.gd` checks `game/movement.gd`;
`test_fighters.gd`, `test_prestige.gd`, `test_rarity.gd`, `test_sample_progress.gd`,
`test_vocabulary.gd` and `test_game_state.gd` check the rules and the session (the active hacks,
saved to a file under `user://test/`); `test_hacks.gd`, `test_save_data.gd` and `test_qr_code.gd`
check the hack rules, the save file and the QR encoder (against `tests/fixtures/`);
`test_hack_server.gd` checks `HackServer` with a fake responder, so no test uses the network;
`test_hack_effects.gd` checks the effects on the screens; `test_fighter_model.gd` checks the 3D
fighters; `test_home.gd`, `test_fighter_list.gd`, `test_fighter_screen.gd`, `test_info.gd`,
`test_back_button.gd`, `test_arena.gd`, `test_touch_joystick.gd`, `test_hack_screen.gd` and
`test_qr_page.gd` check the scenes, `test_qr_scanner.gd` the camera messages; `test_screens.gd` checks the screen constants and
`go_to`; `test_screen_sizes.gd` checks that every screen fits five screen sizes and that Play,
Info, Back, the cards, the skin buttons and Select react to a mouse click and a touch (real input
pushed with `tests/ui_input.gd`); `test_ui_scale.gd` checks the scale factor. Run
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
(S10). Each spec needs only features of specs with a lower number. The Godot specs live in
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
