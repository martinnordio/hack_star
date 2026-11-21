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
| `scenes/autoload/` | The autoloads of `project.godot`: `Screens` (the way from screen to screen) and `GameState` (what the player has and has chosen) |
| `game/` | Game rules: plain scripts without scene access |
| `tests/` | GUT tests, `test_<name>.gd` |
| `tools/` | PowerShell scripts: `check_tools.ps1`, `test.ps1`, `lint.ps1`, `export_web.ps1`, `serve_web.ps1`, `godot.ps1` (finds Godot), the pinned versions in `versions.json` |
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
| `home.tscn` | `home.gd` | The home screen (main scene): total trophies and credits, the title "Hack star", the chosen fighter and skin in a `FighterStage`, its name and Prestige badge (`ui/prestige_badge.tscn`, only from 1000 trophies), **Play** (opens the arena) and **Fighters** (opens `fighter_list.tscn`) and **Info** (opens `info.tscn`). Wide screens put the fighter left and the buttons right; tall screens use one column. At each game start (`GameState.entrance_played`) it first plays the entrance (`ENTRANCE_SECONDS` = 2.4: the fighter drops in with a bounce, a light burst and `CPUParticles3D` sparkles, the title pops in); a click, a touch or a key skips it |
| `arena.tscn` | `arena.gd` | The 3D arena (floor, walls, inner walls), one fighter, the camera and the HUD: **Back** (top-left, returns to the home screen), the touch joystick and the FPS label (top-right) |
| `fighter_list.tscn` | `fighter_list.gd` | The fighter list (**Fighters** on home; Back goes home): a scrolling grid, columns follow the width, of `ui/fighter_card.tscn` cards — picture, name, rarity in its colour, trophies, power level, Prestige badge; locked fighters greyed out with "Locked". A card opens the fighter screen |
| `fighter_screen.tscn` | `fighter_screen.gd` | The fighter screen (opened from a card; the fighter comes from `GameState.viewed_fighter`): the fighter in a `FighterStage`, name, rarity, trophies, power level, Prestige badge and one `ui/skin_button.tscn` per skin (Legendary skins with a gold frame); choosing a skin previews it; **Select** (`GameState.select`) makes the fighter and previewed skin the home fighter and goes home; for a locked fighter it is disabled and reads "Locked". Back goes home |
| `info.tscn` | `info.gd` | The info page (**Info** on home; Back goes home): a title and a scrolling list with one row per word of `Vocabulary`, the word in a bold font and its meaning wrapped |
| `fighter.tscn` | `fighter.gd` (`Fighter`) | A `CharacterBody3D` that walks on the ground plane; the arena sets its `input_direction` every physics frame |
| `touch_joystick.tscn` | `touch_joystick.gd` (`TouchJoystick`) | On-screen joystick, visible only on a touch screen; its `direction` has length ≤ 1 |

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
| `sample_progress.gd` (`SampleProgress`) | The sample progress every game starts with (trophies, power levels, unlocks, 500 credits, the Default skins) until matches exist |
| `vocabulary.gd` (`Vocabulary`) | The 24 words of the info page with their one-sentence meanings (`LIST`); English until spec 15 |

Later specs add their rules here, one script per rule, with a test next to it in `tests/`:
trophies and unlocks (specs 08, 09), hack effects (05), the match (07). The rules of the
Svelte game in `ui/src/lib/game/` are the model, translated to GDScript.

## UI foundation (S12)

Every screen uses the same parts, so a later spec reuses them and does not build its own:

- **Theme:** `scenes/ui/hack_star_theme.tres` is the project's default theme (`gui/theme/custom`
  in `project.godot`). It holds the colours, the font sizes (label 28, subheading 40, heading
  56, button 36), the button styles (rounded, a minimum height for a thumb) and the panel
  styles. The variations are `BigButton` (the **Play** button), `HeadingLabel`,
  `SubheadingLabel`, `BackgroundPanel` and `CardPanel`. Screens set no colours or font sizes of
  their own, except the title's size. Colours that code needs (the rarity colours, Legendary
  gold) are the constants of `Rarity`.
- **Screens:** the autoload `Screens` (`scenes/autoload/screens.gd`) has one constant per screen
  path (`HOME`, `ARENA`, `FIGHTERS`, `FIGHTER`, `INFO`), `go_to(path)` and `go_home()`. There is
  no scene stack: every Back goes home.
- **Back:** `scenes/ui/back_button.tscn` (`BackButton`) is top-left on every screen except home
  and calls `Screens.go_home()`.
- **Session state:** the autoload `GameState` (`scenes/autoload/game_state.gd`) holds trophies,
  power levels, unlocked fighters, credits, the selected fighter and skins, `viewed_fighter`,
  `entrance_played` and the cached `pictures`. It starts from `SampleProgress` at every game
  start and writes no file (see *Saved progress*). `select(fighter_id, skin_id)` refuses a
  locked fighter or an unknown skin.
- **Fighter in 3D:** `scenes/ui/fighter_stage.tscn` (`FighterStage`) shows one `FighterModel` in
  a sub-viewport with its own camera and lights; it keeps the fighter in view on a wide or a tall
  stage. `scenes/ui/fighter_pictures.gd` (`FighterPictures`) renders each fighter once per game
  start into `GameState.pictures`, for the cards of the list.
- **Small parts:** `scenes/ui/prestige_badge.tscn` (`PrestigeBadge`, hidden below 1000
  trophies), `scenes/ui/fighter_card.tscn` (`FighterCard`), `scenes/ui/skin_button.tscn`
  (`SkinButton`).

Screen sizes: the layouts use anchors and containers; `tests/test_screen_sizes.gd` checks every
screen at the five sizes.

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

Nothing is saved yet. The session is held by `GameState` (see *UI foundation*), which starts from
`SampleProgress` at every game start. The plan (S9): one JSON file in `user://`, with a `version` number for
later migrations, read and written by **one autoload** (a script registered in
`project.godot`), so no screen touches the file. In the browser, Godot keeps `user://` in the
browser's IndexedDB, so progress stays on the same device and in the same browser; there is
no login and nothing is shared between devices. The first spec that saves defines the fields
(trophies, unlocked fighters, active hack codes): spec 05 (hack codes) or spec 08 (trophies).

## Server, hack codes and rooms (*planned — spec 05, spec 14*)

Rooms and hack codes come from the **existing FastAPI server** in `server/` (S15), unchanged
and with no Godot-only endpoint, so the Godot game and the Svelte game share the same codes
and rooms. The Godot game calls it with `HTTPRequest` and `WebSocketPeer`:

| Call | What | Spec |
|------|------|------|
| `GET /api/hacks` | The hack codes (for the printable QR page) | 05 |
| `POST /api/hacks/redeem` with `{"code": "…"}` | The hack for a code (any case, spaces trimmed), or 404 "Unknown code" | 05 |
| WebSocket `/api/rooms` | Rooms with up to 2 friends: the messages `create`, `join`, `start`, `state`, `lobby` and `input` from the client; `room`, `left`, `closed` and `error` from the server (`server/src/hack_star_server/rooms.py`) | 14 |

**Same address (D3).** The web export reaches the server at `/api` on the address the page came
from, as the Svelte game does through the Vite proxy (`ui/vite.config.ts`: `/api` goes to
`127.0.0.1:8180`, WebSockets included). That needs no CORS settings in the server and works
the same on an iPad over Wi-Fi. The local tool that serves `build/web/` and forwards `/api`
(HTTP and WebSocket) to the server is built by spec 05; until then `tools/serve_web.ps1`
only serves the files (port 8060) and the game does not call the server. The server runs with
`uv` from the `server/` folder; its tests stay in `server/tests/`.

## Languages (*planned — spec 15*)

The game has no translations yet; all text is in the scenes. Spec 15 adds the languages (as
`ui/src/lib/i18n/` in the Svelte game); until then new visible text is written once, in
English, in the scene.

## Art and licences

Everything in the game is original or has a free licence (S7). Today: only own work built in
code, Godot's built-in default font and GUT (test tool, not exported). Every asset and
third-party part is listed in [LICENSES.md](../LICENSES.md); add a row there in the same Step
that adds an asset.

## Tests and checks

Tests are GUT 9.7.1 files in `tests/`: `test_movement.gd` checks `game/movement.gd`;
`test_fighters.gd`, `test_prestige.gd`, `test_rarity.gd`, `test_sample_progress.gd`,
`test_vocabulary.gd` and `test_game_state.gd` check the rules and the session;
`test_fighter_model.gd` checks the 3D fighters; `test_home.gd`, `test_fighter_list.gd`,
`test_fighter_screen.gd`, `test_info.gd`, `test_back_button.gd`, `test_arena.gd` and
`test_touch_joystick.gd` check the scenes; `test_screens.gd` checks the screen constants and
`go_to`; `test_screen_sizes.gd` checks that every screen fits five screen sizes and that Play,
Info, Back and the cards react to a mouse click and a touch. Run
them headless, from the `hack_star_godot` folder:

| Command | What |
|---------|------|
| `.\tools\check_tools.ps1` | The pinned versions of Godot, export templates, gdtoolkit and GUT |
| `.\tools\test.ps1` | All GUT tests; exit code 0 means they pass |
| `.\tools\lint.ps1` | `gdlint` and `gdformat --check` on `game/`, `scenes/`, `tests/` |
| `.\tools\export_web.ps1` | Exports the game to `build\web\` |
| `.\tools\serve_web.ps1` | Serves `build\web\` on port 8060 for a desktop browser or an iPad |

The rules for the code are in [.specs/guidelines/gdscript.md](../.specs/guidelines/gdscript.md).
A Step is done when `test.ps1` and `lint.ps1` pass; the last Step of a spec also runs
`export_web.ps1`. When a spec changes `server/`, `cd server; uv run pytest` must pass too.
What a script cannot check — the play-test on a real iPad and phone (touch, at least 30 frames
per second, S1, S3, S6) — is done by the author with `export_web.ps1` and `serve_web.ps1`; the
FPS label in the arena shows the frame rate.

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
