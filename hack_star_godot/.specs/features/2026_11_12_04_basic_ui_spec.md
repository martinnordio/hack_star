# Basic UI Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-mvp`
> **Issue:** #28
> **Moved from:** [2026_11_12_basic_ui_spec.md](../../../.specs/features/done/2026_11_12_basic_ui_spec.md) (#2)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Opus 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_basic_ui_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S1, S2, S3 (arena instead of "Coming soon"), S4, S5, S7, S8 (sample credits), S10 revised; S13 (choice kept while the game is open) and S14 (English) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #28 created |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 2.32 M (130 k in · 2.16 M cached · 30 k out) | CHF 1.34 (160 credits) | Part 2 written (10 Steps: standard, standard, reasoning, reasoning, standard, reasoning, standard, standard, light, light); also the requirements revision and the issue (`usage.ps1 -Agent subagents` from 16:09) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.97 M (91 k in · 1.86 M cached · 20 k out) | CHF 0.58 (69 credits) | Step 1 done (`usage.ps1 -Agent subagents` 16:14–16:17) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 717 k (15 k in · 692 k cached · 10 k out) | CHF 0.17 (21 credits) | Step 2 done (`usage.ps1 -Agent subagents` 16:17–16:19) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.57 M (135 k in · 3.40 M cached · 38 k out) | CHF 1.78 (213 credits) | Step 3 done (`usage.ps1 -Agent subagents` 16:19–16:26) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 4.36 M (52 k in · 4.28 M cached · 31 k out) | CHF 1.45 (173 credits) | Step 4 done (`usage.ps1 -Agent subagents` 16:27–16:32) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.04 M (93 k in · 1.93 M cached · 19 k out) | CHF 0.52 (62 credits) | Step 5 done (`usage.ps1 -Agent subagents` 16:33–16:38) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.50 M (124 k in · 3.35 M cached · 32 k out) | CHF 1.60 (191 credits) | Step 6 done (`usage.ps1 -Agent subagents` 16:39–16:45) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.69 M (88 k in · 2.57 M cached · 26 k out) | CHF 0.62 (74 credits) | Step 7 done (`usage.ps1 -Agent subagents` 16:46–16:53) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.35 M (34 k in · 2.29 M cached · 22 k out) | CHF 0.45 (54 credits) | Step 8 done (`usage.ps1 -Agent subagents` 16:53–16:57) |

---

# Part 1 · Requirements

## Context

The first screen has to make kids say "wow" and feel like Brawl Stars: a big animated fighter,
trophies, the Prestige badge and cool skins. It also needs an info page explaining the words
kids use, so adults can understand them. This is F1 / Spec 1 in
[overall_req.md](../../../.specs/overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_basic_ui_spec.md) (#2).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — browser, screen sizes,
  input, own art and smooth animation (S1–S3, S6, S7) apply here too; Brawl Stars investigation
  and feature list; the Godot technology, the architecture document
  `hack_star_godot/docs/architecture.md` and how to run the game (S12–S14).
- Spec 01's Godot project
  ([01 Godot Setup and First Game](done/2026_11_21_01_godot_setup_and_first_game_spec.md)):
  a start screen with **Play** that opens a 3D arena seen from above at an angle with one
  fighter, moved with the keyboard or a touch joystick; Godot 4.7.2 with GDScript, the
  Compatibility renderer, a single-threaded web export, GUT tests and the commands in
  `hack_star_godot/tools/` ([hack_star_godot/README.md](../../README.md)).
- Checked 2026-11-21 (S0) in the code: `scenes/start_screen.tscn` (main scene: title
  "Hack star" and **Play**, which opens `scenes/arena.tscn`); the arena's **Back** returns to
  the start screen; one fighter built from primitive meshes in `scenes/fighter.tscn`; screens
  change with `change_scene_to_file`, there is no shared look (each scene sets its own colours
  and font sizes) and no scene manager; nothing is saved, there are no fighters, trophies or
  credits as data, and all text is English in the scenes (languages: spec 15).
  `tests/test_screen_sizes.gd` checks the five screen sizes with the project's stretch
  settings (spec 03, D5, D7). The home screen of this spec takes the place of the start
  screen.

**New:**
- Home screen, fighter screen with skins, info page with vocabulary.
- The UI foundation of the Godot game that later specs reuse (S12).

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–03) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. — checked 2026-11-21: S6, S9, S11, S12
  fit; S1, S2, S3, S4, S5, S7, S8, S10 revised (start screen replaced, the arena of spec 01
  instead of "Coming soon", 6 fighters, sample credits); S13 (choice kept while the game is
  open) and S14 (English) added; no open questions.
- **S1 — Home screen:** Opening the game shows the home screen in place of spec 01's start
  screen: the selected fighter large in the centre with an idle animation, the game name
  "Hack star", a big **Play** button, the player's total trophies and credits. _(revised
  2026-11-21: the Godot game opens on spec 01's start screen, which the home screen replaces.)_
- **S2 — Wow entrance:** Each time the game is started, the home screen plays an entrance
  animation (fighter jumps in, light or particle effects) of at most 3 seconds that can be
  skipped with a tap, a click or a key; coming back to the home screen from another screen
  does not play it again. _(revised 2026-11-21: "the first time" made testable — once per
  game start — and a key added for the desktop.)_
- **S3 — Play button:** Tapping **Play** opens the 3D arena with the fighter of spec 01 (the
  arena that the [graphics demo spec](2026_11_12_06_graphics_demo_spec.md) builds on); its
  **Back** returns to the home screen. _(revised 2026-11-21: the Godot game already has the
  arena of spec 01, so Play keeps opening it instead of showing "Coming soon".)_
- **S4 — Fighter list:** A **Fighters** button opens a list of all 6 fighters (S11), each
  with its picture, name, rarity, trophy count and power level; locked fighters look greyed
  out with a lock. _(revised 2026-11-21: "4–6" fixed to the 6 fighters of S11.)_
- **S5 — Choose fighter:** Choosing an unlocked fighter makes it the fighter shown on the
  home screen; a locked fighter can be looked at but not chosen. _(revised 2026-11-21: what
  happens with a locked fighter added, so it can be tested.)_
- **S6 — Prestige badge:** A fighter with 1000 trophies or more shows a Prestige badge with
  its number (1 at 1000–1999, 2 at 2000–2999, …) on the home screen and in the fighter list.
- **S7 — Skins:** Each fighter has 2–3 skins; opening a fighter from the list shows its
  fighter screen with its skins, each with its rarity (for example Epic, Mythic,
  **Legendary**), and the chosen skin is shown on the home screen. Legendary skins have a
  special frame or glow. _(revised 2026-11-21: says where the fighter screen is opened.)_
- **S8 — Sample progress:** Until matches exist (F4, F5), the fighters start with sample
  trophies and power levels so that at least one fighter shows a Prestige badge, and the
  player starts with sample credits (a number greater than 0). _(revised 2026-11-21: the
  Godot game has no credits yet; S1 shows them.)_
- **S9 — Info page:** An **Info** button opens a page with at least the vocabulary in the
  table below: each word with a one-sentence meaning a parent understands.
- **S10 — Back:** Every screen other than home — the arena, the fighter list, the fighter
  screen and the info page — has a **Back** button that returns to the home screen.
  _(revised 2026-11-21: the arena's Back of spec 01 now leads to the home screen.)_
- **S11 — The fighters:** The game has these 6 original fighters, each in 3D with its own
  shape and colours:

  | Fighter | Rarity | Idea | Skins (rarity) |
  |---------|--------|------|----------------|
  | Blaze | Rare | Girl with fire powers | Default · Lava (Epic) · Phoenix (Legendary) |
  | Rocko | Rare | Friendly rock golem, a tank | Default · Crystal (Epic) |
  | Turbo | Super Rare | Fast racing kid with a helmet | Default · Neon (Mythic) |
  | Frosty | Epic | Small ice yeti | Default · Snow King (Legendary) |
  | Luna | Mythic | Space cat with a ray gun | Default · Galaxy (Mythic) · Supernova (Legendary) |
  | Pixel | Legendary | Hacker robot, the face of Hack star | Default · Glitch (Legendary) |

  At the start Blaze, Rocko and Turbo are unlocked; the others are locked.
- **S12 — UI foundation:** The user interface of the Godot game has one look shared by all
  screens (colours, text styles, buttons, the Back button), one way to go from screen to
  screen that later specs reuse, and layouts that fit desktop, iPad and phone in landscape
  and portrait, with touch and mouse; it is written down in
  `hack_star_godot/docs/architecture.md` ([spec 03](done/2026_11_12_03_mvp_and_architecture_spec.md)).
- **S13 — Choice kept while playing:** The chosen fighter and skin stay chosen while the game
  is open (after the arena, the list or the info page and back); after a reload the game
  starts again from the sample progress (S8). Saving between visits comes with the first spec
  that saves (05 or 08, `docs/architecture.md`). _(added 2026-11-21: the Godot game saves
  nothing yet.)_
- **S14 — Language:** All new text is in English; translations come with
  [spec 15](2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-21: the
  Godot game has no languages yet, `docs/architecture.md`.)_

### Vocabulary for the info page

| Word | Meaning |
|------|---------|
| Brawler / fighter | A character you play with |
| Trophies | Points a fighter wins in matches; they show how good you are with it |
| Prestige | A level a fighter reaches at every 1000 trophies, shown as a badge with a number |
| Power level | How strong a fighter is (1 to 11; up to 22 in Hack star with a hack code) |
| Rarity | How rare a fighter or skin is: Rare, Super Rare, Epic, Mythic, Legendary |
| Skin | A different look (costume) for a fighter; it does not make it stronger |
| Legendary skin | The rarest and most special-looking skins |
| Credits | Money used to unlock new fighters |
| Super | A special attack that charges up by hitting enemies |
| Gadget | A small extra ability you can use a few times per match |
| Star Power | A passive bonus a fighter gets at a high power level |
| Hypercharge | A boosted Super that makes the fighter extra strong for a short time |
| Showdown | Mode where the last fighter standing wins |
| Gem Grab | Team mode: collect and hold 10 gems to win |
| Brawl Ball | Team mode: score two goals, like football |
| Bush | Tall grass where fighters hide |
| Main | The fighter a kid plays the most |
| Push / pushing | Playing a lot to win trophies with one fighter |
| Camping | Hiding (often in a bush) and waiting for others |
| Tank | A fighter with a lot of health |
| Starr Drop | A surprise reward box |
| Brawl Pass | Season pass with rewards for playing |
| GG | "Good game", said at the end of a match |
| Hack code | Hack star only: a secret code (typed or QR) that gives extras |

### Open questions

_None. Answered 2026-11-12: 3D look; the game invents the fighters (S11). Sound is left out
of this spec (see Deferred Items in the plan of the
[original spec](../../../.specs/features/done/2026_11_12_basic_ui_spec.md)). S0 check
2026-11-21: no new question; the revisions above follow the Godot game as built._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | UI foundation: shared theme, screen navigation, Back button | standard (Claude Sonnet 5.5) — a theme, an autoload and a small scene, fixed by D1–D3 | ✅ Done | [→ Step 1](#step-1--ui-foundation-shared-theme-screen-navigation-back-button) |
| **2** | Fighter catalogue, Prestige and sample progress | standard (Claude Sonnet 5.5) — data and pure rules with tests, all values given by S8, S11 and D5 | ✅ Done | [→ Step 2](#step-2--fighter-catalogue-prestige-and-sample-progress) |
| **3** | 3D fighter models with idle animation | reasoning (Claude Opus 5.5) — 3D fighters: six recognisable shapes from primitives | ✅ Done | [→ Step 3](#step-3--3d-fighter-models-with-idle-animation) |
| **4** | Skins and the Legendary glow | reasoning (Claude Opus 5.5) — graphics-heavy: 14 looks, glow and sparkles that stay smooth on the web | ✅ Done | [→ Step 4](#step-4--skins-and-the-legendary-glow) |
| **5** | Home screen | standard (Claude Sonnet 5.5) — replaces the start screen with a layout the plan describes | ✅ Done | [→ Step 5](#step-5--home-screen) |
| **6** | Wow entrance | reasoning (Claude Opus 5.5) — graphics-heavy: timed 3D animation with particles, skippable | ✅ Done | [→ Step 6](#step-6--wow-entrance) |
| **7** | Fighter list | standard (Claude Sonnet 5.5) — a grid of cards with cached 3D pictures (D7) | ✅ Done | [→ Step 7](#step-7--fighter-list) |
| **8** | Fighter screen with skins and Select | standard (Claude Sonnet 5.5) — one screen reusing the model and the state | ✅ Done | [→ Step 8](#step-8--fighter-screen-with-skins-and-select) |
| **9** | Info page | light (Claude Haiku 5.5) — a word list and a scrolling page | ⬜ Not started | [→ Step 9](#step-9--info-page) |
| **10** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks and updating two documents | ⬜ Not started | [→ Step 10](#step-10--final-check-readme-and-architecture) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

> **Godot spec:** this spec lives in `hack_star_godot/.specs/`. Every stage writes its files
> there (`changes/`, `review/`, `costs.md`, `features/done/`), never in the root `.specs/`;
> the checks are `hack_star_godot/tools/check_tools.ps1`, `test.ps1`, `lint.ps1`,
> `export_web.ps1` (all exit 0) and the guideline is
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../AGENTS.md)). Each
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0; nothing in `server/` or `ui/`
> changes.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **One theme for all screens:** `scenes/ui/hack_star_theme.tres`, a Godot `Theme` set as the project's default theme (`gui/theme/custom` in `project.godot`), with the colours, the font sizes (title, heading, body, button), the button styles (normal, hover, pressed, disabled; rounded, a minimum height for a thumb) and the panel style. Colours that code needs (rarity colours, Legendary gold) are constants of `game/rarity.gd` (D5). Screens set no colours or font sizes of their own except the title's size. Godot's default font stays (no font file). | S12: one look, changed in one place; a default theme reaches every Control, also those of later specs, without per-scene work; no asset to license. |
| D2 | **One way between screens:** an autoload `Screens` (`scenes/autoload/screens.gd`, registered in `project.godot`) with one constant per screen path (`HOME`, `ARENA`, `FIGHTERS`, `FIGHTER`, `INFO`) and `go_to(path)` / `go_home()`, which call `get_tree().change_scene_to_file`. No scene stack: every Back goes home (S10). Later specs add their screen as one more constant. | S12 "one way to go from screen to screen that later specs reuse"; keeps the simple `change_scene_to_file` of spec 03 (architecture) and puts the paths in one place. |
| D3 | **One Back button:** `scenes/ui/back_button.tscn` (+ `.gd`), a themed button anchored top-left that calls `Screens.go_home()`; the arena's own **Back** is replaced by it; every new screen adds it. | S10, S12: same place and look on every screen; one test covers all. |
| D4 | **Session state, not saved:** an autoload `GameState` (`scenes/autoload/game_state.gd`) holds trophies and power level per fighter, unlocked fighters, credits, the selected fighter, the selected skin per fighter and whether the entrance has played; it starts from `SampleProgress` (D5) at every game start and writes no file. The save file of the architecture (one JSON in `user://`, one autoload) is added by spec 05 or 08, which can make `GameState` that autoload. | S13: kept while the game is open, sample progress after a reload; nothing is saved before the spec that defines the file (architecture, *Saved progress*). |
| D5 | **Catalogue and rules in `game/` (pure, tested headless):** `game/fighters.gd` (`Fighters`: the 6 fighters of S11 with id, name, rarity, idea, skins with id, name and rarity, and the start unlocks), `game/rarity.gd` (`Rarity`: the five rarities in order and their colours), `game/prestige.gd` (`Prestige.level(trophies)` = `trophies / 1000`, 0 below 1000), `game/sample_progress.gd` (`SampleProgress`): Blaze 1240 trophies / power 7, Rocko 420 / 4, Turbo 85 / 2, the locked fighters 0 / 1; 500 credits; Blaze selected, every fighter on its Default skin — the values of the Svelte game. Not served by the FastAPI server. | S6, S8, S11; same numbers as the Python + Svelte game; the Godot game calls the server only from spec 05 (architecture, D3 of spec 03), and `server/` stays unchanged. |
| D6 | **Fighter looks built in code:** `scenes/fighter_model.tscn` + `.gd` (`FighterModel`, a `Node3D`) with `setup(fighter_id, skin_id)` that builds the fighter from primitive meshes (box, capsule, sphere, cylinder, prism, torus) and `StandardMaterial3D` (per-fighter parts: Blaze flame hair, Rocko rock blocks, Turbo helmet and visor, Frosty fur and horns, Luna ears, tail and ray gun, Pixel screen face and antenna); a skin changes colours and adds details; a Legendary skin adds an emissive halo and `CPUParticles3D` sparkles. Idle animation (breathing, sway) in `_process`, no `AnimationPlayer` files. The arena's `fighter.tscn` is not changed (spec 06 puts the selected fighter into the arena). | S7, S11; no imported art, so `LICENSES.md` stays unchanged (spec 03, S7); `CPUParticles3D` because GPU particles are limited in the Compatibility renderer on WebGL. |
| D7 | **3D inside a 2D screen:** one `scenes/ui/fighter_stage.tscn` (`SubViewportContainer` with `stretch`, a `SubViewport` with `own_world_3d`, a camera, a light and one `FighterModel`) shows the live fighter on home and on the fighter screen. The fighter list does **not** use one live viewport per card: each fighter's picture is rendered once by an off-screen stage into an `ImageTexture` and cached in `GameState` for the session. | S4 with ≥ 30 fps on a phone (spec 03, S6): six live 3D views would cost six renders per frame; the Svelte game made the same choice (its D3). |
| D8 | **Entrance once per game start:** the home screen plays the entrance only while `GameState.entrance_played` is false and then sets it; duration `ENTRANCE_SECONDS` ≤ 3.0 (a `Tween`: the fighter drops in with a bounce, a light burst and `CPUParticles3D` sparkles, the title pops in); any mouse button, touch or key skips to the end state. | S2 testable: the flag and the constant are checked by tests; coming back from another screen does not replay it. |
| D9 | **Home replaces the start screen:** `scenes/start_screen.tscn`/`.gd` are renamed (`git mv`) to `scenes/home.tscn`/`.gd`, the main scene in `project.godot`, and `tests/test_start_screen.gd` to `tests/test_home.gd`; the title "Hack star" and **Play** keep their node names so the size tests of spec 03 keep working. **Play** opens the arena (S3). | S1, S3: one first screen, no dead start screen; the spec 03 tests stay meaningful. |
| D10 | **Size tests for every new screen:** home, fighter list, fighter screen and info page join `tests/test_screen_sizes.gd` (the five sizes and the stretch settings of spec 03, D5 and D7): every button, label and Back lies inside the visible rectangle, and Back reacts to a click and a touch. Visual checks the headless tests cannot do (shapes, glow, entrance) are done on screenshots from a Godot run with a window (not `--headless`), saved outside the repository. | S12 "fit desktop, iPad and phone … with touch and mouse" checked without a device; headless Godot has no renderer, so looks need a windowed run. |
| D11 | **Text in English, in the scenes** (vocabulary in `game/vocabulary.gd`, `Vocabulary.WORDS`, 24 entries of Part 1). | S14; spec 15 adds the languages (architecture, *Languages*). |
| D12 | **Fighter screen Back goes home** (not to the list): Select also returns home, so the new fighter shows at once. | S10 says home; one rule for every Back (D2, D3). |

---

## Step 1 — UI foundation: shared theme, screen navigation, Back button

### Goal
All screens share one theme, go from screen to screen through one autoload and use one Back
button; the start screen and the arena work as before with them (S10, S12).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `scenes/ui/hack_star_theme.tres` after D1, set as `gui/theme/custom` in `project.godot`;
      remove the per-scene colour and font-size overrides of the start screen and the arena
      that the theme now gives (keep the title's 96).
- [x] `game/rarity.gd` (`Rarity`): the five rarities in order with their colours (D1, D5).
- [x] Autoload `Screens` (`scenes/autoload/screens.gd`) after D2; the start screen's **Play**
      and the arena's Back use it.
- [x] `scenes/ui/back_button.tscn` + `.gd` after D3; the arena's **Back** is replaced by it
      (same node path `Hud/BackButton` or the tests updated).
- [x] Tests: `tests/test_screens.gd` (each constant names an existing scene; `go_to` changes
      the scene), `tests/test_back_button.gd` (pressed → home), `tests/test_rarity.gd`; a
      test that the project's default theme is the Hack star theme.
- [x] Check: `tools/test.ps1` (all earlier tests too, including `test_screen_sizes.gd`) and
      `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 16:14
**Done (2026-11-21 · ~3m · Claude Sonnet 5.5)** — Hack star theme (`scenes/ui/hack_star_theme.tres`, default theme, `BigButton`/`HeadingLabel`/`BackgroundPanel` variations), `Rarity`, autoload `Screens` (`HOME`, `ARENA`; the other screens are added by their Steps), `BackButton` scene used by the arena, start screen and arena without their own colours and font sizes (title 96 kept). `tools/test.ps1`: 35 tests passed; `tools/lint.ps1`: exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 1.97 M tokens · CHF 0.58 (69 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 2 — Fighter catalogue, Prestige and sample progress

### Goal
The game knows the 6 fighters, their skins and rarities, the Prestige rule and the sample
progress, and keeps the player's choices for the session (S6, S8, S11, S13).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/fighters.gd`, `game/prestige.gd`, `game/sample_progress.gd` after D5.
- [x] Autoload `GameState` (`scenes/autoload/game_state.gd`) after D4: starts from
      `SampleProgress`; `select(fighter_id, skin_id)` refuses a locked fighter or an unknown
      skin; `total_trophies()`; `entrance_played`.
- [x] Tests: `tests/test_fighters.gd` (6 fighters, names and rarities of S11, 2–3 skins each
      with one Default, 14 skins in all, Blaze/Rocko/Turbo unlocked), `tests/test_prestige.gd`
      (0 → 0, 999 → 0, 1000 → 1, 1999 → 1, 2500 → 2), `tests/test_sample_progress.gd` (at
      least one fighter with Prestige ≥ 1, credits > 0), `tests/test_game_state.gd` (select an
      unlocked fighter and skin; a locked one is refused; total trophies).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 16:17
**Done (2026-11-21 · ~2m · Claude Sonnet 5.5)** — `Fighters` (6 fighters, 14 skins), `Prestige`, `SampleProgress` (with 500 credits) in `game/`, autoload `GameState` (`select` refuses a locked fighter or an unknown skin; `total_trophies`; `entrance_played`; `reset`); 18 new tests. `tools/test.ps1`: 53 tests passed; `tools/lint.ps1`: exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 717 k tokens · CHF 0.17 (21 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 3 — 3D fighter models with idle animation

### Goal
Each of the 6 fighters has its own recognisable 3D shape and colours in its Default skin, with
an idle animation (S1 idle, S11).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `scenes/fighter_model.tscn` + `.gd` (`FighterModel`) after D6, Default skins only;
      idle animation (breathing, sway) that can be switched off for pictures.
- [x] `scenes/ui/fighter_stage.tscn` + `.gd` after D7 (camera, light, one `FighterModel`).
- [x] Tests: `tests/test_fighter_model.gd` — every fighter builds without errors, has at
      least the parts of its idea (e.g. Luna's ray gun, Pixel's screen face) as named nodes,
      and two fighters never have the same main colour; the idle animation moves the model.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of the six fighters
      from a windowed run (D10) look like their ideas in S11.

### Notes
Started: 2026-11-21 16:19
**Done (2026-11-21 · ~7m · Claude Opus 5.5)** — `FighterModel` (`scenes/fighter_model.tscn` + `.gd`): the six fighters in their Default skin built in code from primitive meshes with toon materials and an outline (inverted hull), with named idea parts (Blaze `FlameHair`/`Fireball`, Rocko `RockBlocks`, Turbo `Helmet`/`Visor`, Frosty `Fur`/`Horns`, Luna `Ears`/`Tail`/`RayGun`, Pixel `ScreenFace`/`Antenna`), colours per skin in `LOOKS` (Step 4 adds the skins), idle breathing, sway, head tilt and flicker in `_process` (`idle_enabled` off for pictures); `FighterStage` (`scenes/ui/fighter_stage.tscn` + `.gd`): a transparent sub-viewport with its own world, camera, key and rim light; the camera keeps the width on a tall stage and the height on a wide one. `tests/test_fighter_model.gd` (7 tests). `tools/test.ps1`: 60 tests passed; `tools/lint.ps1`: exit 0; screenshots of the six fighters from a windowed run: Blaze a girl with flame hair, skirt and fireball; Rocko a block golem with yellow eyes and moss; Turbo with yellow helmet, visor and scarf; Frosty a white yeti with ice horns; Luna a grey cat in a purple suit with a ray gun; Pixel a robot with a pixel smile on its screen and an antenna. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.57 M tokens · CHF 1.78 (213 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 4 — Skins and the Legendary glow

### Goal
All 14 skins have their own look, and Legendary skins glow (S7, S11).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `FighterModel.setup(fighter_id, skin_id)`: skin colours and details for Lava, Phoenix,
      Crystal, Neon, Snow King, Galaxy, Supernova, Glitch; Legendary skins add the halo and
      `CPUParticles3D` sparkles (D6).
- [x] Tests: every fighter × skin combination (14) builds; a skin's main colour differs from
      its Default; only Legendary skins have the glow nodes.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of the 14 combinations
      (D10) checked by eye.

### Notes
Started: 2026-11-21 16:27
**Done (2026-11-21 · ~5m · Claude Opus 5.5)** — `FighterModel.LOOKS` has all 14 skins; details per skin: Lava glowing cracks on a dark top, Phoenix wings, Crystal icy glowing blocks with gems, Neon glowing helmet, visor, scarf and strips, Snow King icy fur, gold crown and blue cape, Galaxy stars on a dark suit, Supernova a glowing ring, Glitch magenta/cyan ghost copies of the head. Legendary skins (Phoenix, Snow King, Supernova, Glitch) get `LegendaryGlow`: a soft radial-gradient billboard halo behind the fighter (built in code, no texture file), a turning ring of sparkles and 24 rising `CPUParticles3D` sparkles. `FighterStage` now draws its sub-viewport with premultiplied alpha, so glows and see-through parts (Luna's helmet) show over the screen behind it instead of turning dark. 3 new tests in `tests/test_fighter_model.gd`. `tools/test.ps1`: 63 tests passed; `tools/lint.ps1`: exit 0; screenshots of the 14 combinations from a windowed run: every skin clearly different from its Default, only the four Legendary skins glow. Note for Step 7: a picture rendered from the stage keeps premultiplied colours, so the card should draw it with the same premultiplied blend. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 4.36 M tokens · CHF 1.45 (173 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — Home screen

### Goal
The game opens on the home screen with the selected fighter, trophies, credits, Prestige and
**Play**, and the arena's Back returns to it (S1, S3, S6, S10, S14).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Rename the start screen to `scenes/home.tscn`/`.gd` and its test to `tests/test_home.gd`
      (D9); main scene and `Screens.HOME` updated.
- [x] Layout with containers: top bar (total trophies, credits), title "Hack star", the
      `FighterStage` with the selected fighter and skin (idle), its name and Prestige badge
      (`scenes/ui/prestige_badge.tscn`, shown only at Prestige ≥ 1), big **Play** (opens the
      arena), smaller **Fighters** and **Info** buttons (disabled until Steps 7 and 9).
- [x] Tests: `tests/test_home.gd` (the values come from `GameState`; Blaze shows Prestige 1;
      a fighter under 1000 shows no badge; Play opens the arena); `test_screen_sizes.gd` uses
      the home screen at the five sizes (D10).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 16:33
**Done (2026-11-21 · ~5m · Claude Sonnet 5.5)** — `start_screen` renamed to `scenes/home.tscn`/`.gd` (`git mv`; main scene, `Screens.HOME`, `tests/test_home.gd`); layout with containers: top bar (trophies, credits), title, a `Body` box (the `FighterStage` with the chosen fighter and skin, and the controls: name, `PrestigeBadge`, **Play**, disabled **Fighters** and **Info**) that is one column on tall screens and fighter-left, buttons-right on wide ones; `scenes/ui/prestige_badge.tscn` + `.gd` (hidden below 1000 trophies). `tests/test_home.gd` (7 tests: values from `GameState`, Blaze Prestige 1, no badge for Turbo, selected skin shown, Play opens the arena); `test_screen_sizes.gd` checks every home element at the five sizes. README and `docs/architecture.md` lines about the start screen updated. `tools/test.ps1`: 68 tests passed; `tools/lint.ps1`: exit 0; screenshots from a windowed run (desktop 1280×720, iPad portrait, phone portrait, phone landscape): everything inside the screen, fighter large and Prestige 1 badge visible, Fighters/Info greyed. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.04 M tokens · CHF 0.52 (62 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 6 — Wow entrance

### Goal
At each game start the home screen plays a skippable entrance of at most 3 seconds that does
not replay when coming back (S2).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Entrance after D8 on the home screen: fighter drop-in with bounce, light burst,
      `CPUParticles3D` sparkles, title pop; "Tap to skip" hint while it plays.
- [x] Skip with a mouse button, a touch or a key: jumps to the end state at once.
- [x] Tests: `ENTRANCE_SECONDS` ≤ 3.0; the first home after a fresh `GameState` plays it and
      sets `entrance_played`; a second home does not; a click, a touch and a key each skip it;
      Play still works after a skip.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots at start, middle and
      end of the entrance (D10).

### Notes
Started: 2026-11-21 16:39
**Done (2026-11-21 · ~6m · Claude Opus 5.5)** — `scenes/home.gd`/`.tscn`: on the first home of a game start (`GameState.entrance_played`, set when it starts) a parallel `Tween` of `ENTRANCE_SECONDS` = 2.4 plays: the fighter falls in from the sky small and spinning, growing with the same ease so it never leaves the stage, lands with a squash and an elastic bounce; at the landing a light burst (an `OmniLight3D` flash, a radial-gradient billboard halo, a ground shockwave ring), 64 `CPUParticles3D` sparkles in gold and the fighter's colour, and a short screen flash; then the title pops in (scale from 0.2 with a back ease; hidden by `modulate`, because the column resets its children's scale) and the trophies, credits and buttons fade in; a "Tap to skip" hint shows while it plays. A mouse button, a touch, a key or a joypad button skips to the end state and is taken, so the tap that skips does not also press Play; the 3D effects are freed at the end. 7 new tests in `tests/test_home.gd` (≤ 3 s; first home plays and sets the flag, a second does not; ends by itself; click, touch and key skip; Play works after a skip and is not pressed by the skipping tap); `test_screen_sizes.gd` checks the hint at the five sizes; `docs/architecture.md` home line updated. `tools/test.ps1`: 75 tests passed; `tools/lint.ps1`: exit 0; screenshots from a windowed run at 0.3, 0.6, 0.85, 1.0, 1.2, 1.6, 2.0 and 3.0 s: small fighter falling, landing with halo, ring and sparkles, title pop, UI fading in, clean end state without hint or effects. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.50 M tokens · CHF 1.60 (191 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 7 — Fighter list

### Goal
**Fighters** opens a list of the 6 fighters with picture, name, rarity, trophies, power level
and Prestige; locked fighters are greyed out with a lock (S4, S6, S10).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `scenes/fighter_list.tscn` + `.gd` (`Screens.FIGHTERS`): a scrolling grid of cards
      (`scenes/ui/fighter_card.tscn`) whose column count follows the width; picture from the
      cache (D7), name, rarity in its colour, trophies, power level, Prestige badge; locked
      cards greyed (modulate) with a lock label; Back button (D3); **Fighters** on home enabled.
- [x] Tests: `tests/test_fighter_list.gd` (6 cards in catalogue order; Blaze's card shows
      Prestige 1; Frosty, Luna and Pixel are greyed and show the lock; Back goes home);
      `test_screen_sizes.gd` adds the list (D10).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 16:46
**Done (2026-11-21 · ~7m · Claude Sonnet 5.5)** — `scenes/fighter_list.tscn` + `.gd` (`Screens.FIGHTERS`): a scrolling grid of `scenes/ui/fighter_card.tscn` cards (picture, name, rarity in its colour, trophies, power level, Prestige badge, "Locked" label and a grey tint for locked fighters), columns = width / 300; pictures by `FighterPictures` (`scenes/ui/fighter_pictures.gd`): off-screen `FighterStage`s render each fighter in its chosen skin once, cached as `ImageTexture` in `GameState.pictures` (premultiplied blend on the card, as Step 4 noted; skipped headless); theme gets `CardPanel` and `SubheadingLabel`; **Fighters** on home is enabled; `docs/architecture.md` has the list row. Tests: `tests/test_fighter_list.gd` (8) + home Fighters test + list in `test_screen_sizes.gd` (5 sizes, Back click and touch). `tools/test.ps1`: 86 tests passed; `tools/lint.ps1`: exit 0; screenshots from a windowed run (desktop 1280×720, phone portrait 390×844, iPad portrait): six cards, equal columns, Blaze with Prestige 1, Frosty/Luna/Pixel greyed with Locked. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.69 M tokens · CHF 0.62 (74 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 8 — Fighter screen with skins and Select

### Goal
A card opens the fighter screen with the fighter in 3D and its skins; **Select** makes an
unlocked fighter and skin the home fighter, and the choice stays while the game is open (S5,
S7, S10, S13).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `scenes/fighter_screen.tscn` + `.gd` (`Screens.FIGHTER`, the fighter id passed through
      `GameState`): `FighterStage`, name, rarity, trophies, power level, Prestige; one button
      per skin with its rarity, Legendary skins with a gold frame; choosing a skin previews it;
      **Select** calls `GameState.select` and goes home; for a locked fighter **Select** is
      disabled and shows "Locked"; Back button (D12).
- [x] Tests: `tests/test_fighter_screen.gd` (Rocko + Crystal selected → home shows Rocko with
      Crystal; Pixel cannot be selected; the Legendary skin button has the frame; after the
      arena and back the choice is unchanged); `test_screen_sizes.gd` adds the fighter screen.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 16:53
**Done (2026-11-21 · ~4m · Claude Sonnet 5.5)** — `scenes/fighter_screen.tscn` + `.gd` (`Screens.FIGHTER`; the fighter id passes through the new `GameState.viewed_fighter`, set by the list): `FighterStage`, name as title, rarity in its colour, trophies, power level, Prestige badge, one `scenes/ui/skin_button.tscn` + `.gd` per skin (name and rarity colour; Legendary skins with a 6 px gold frame; the chosen skin highlighted), choosing a skin previews it without choosing it; **Select** calls `GameState.select` and goes home, for a locked fighter it is disabled and reads "Locked" (its skins can still be looked at); Back goes home (D12). Fighter cards got an invisible button over them (`opened` signal, so a scrolling drag does not open them) and the list opens the screen. `tests/test_fighter_screen.gd` (9: values, one button per skin, gold frame only on Legendary, preview, starts on the chosen skin, Rocko + Crystal selected and shown on home, Pixel cannot be selected, choice kept after the arena and back, Back) + list card test + `test_screen_sizes.gd` (5 sizes) + `test_screens.gd`; `docs/architecture.md` has the screen row. `tools/test.ps1`: 97 tests passed; `tools/lint.ps1`: exit 0; screenshots from a windowed run (desktop 1280×720: Blaze with Phoenix; phone portrait 390×844: Blaze with Phoenix; phone landscape: Luna locked; iPad portrait: Frosty with Snow King): the fighter large with its glow, everything inside the screen, the gold frame on the Legendary skin, Select greyed "Locked" for locked fighters. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.35 M tokens · CHF 0.45 (54 credits)
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 9 — Info page

### Goal
**Info** opens a scrolling page with the 24 words of the vocabulary and their meanings (S9,
S10).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `game/vocabulary.gd` (D11) with the 24 words and meanings of Part 1.
- [ ] `scenes/info.tscn` + `.gd` (`Screens.INFO`): title, a `ScrollContainer` with one row per
      word (word in bold style, meaning wrapped); Back button; **Info** on home enabled.
- [ ] Tests: `tests/test_vocabulary.gd` (≥ 24 words, each with a non-empty meaning, every word
      of Part 1 present); `tests/test_info.gd` (one row per word; Back goes home);
      `test_screen_sizes.gd` adds the info page (the list scrolls, Back stays visible).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 10 — Final check, README and architecture

### Goal
Everything that worked before still works, all Godot checks pass, and the README and the
architecture describe the new screens and the UI foundation (S12, all statements).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/docs/architecture.md`: Layout (`scenes/ui/`, `scenes/autoload/`), the
      *UI foundation* (theme, `Screens`, Back button, `FighterStage`, how a later spec adds a
      screen), Screens table (home, fighter list, fighter screen, info, arena Back → home),
      Game rules (`Fighters`, `Rarity`, `Prestige`, `SampleProgress`, `Vocabulary`), 3D models
      (`FighterModel`), Saved progress (`GameState` holds the session; the file still planned,
      spec 05/08), Tests; *How to add a screen* updated.
- [ ] `hack_star_godot/README.md`: the screens (home, Fighters, Info), the controls (skip the
      entrance), the run steps ("the home screen shows …").
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); parse every changed `.ps1` with
      `[System.Management.Automation.Language.Parser]::ParseFile` (if any).
- [ ] `git diff --stat` of this spec shows nothing in `server/` or `ui/`; `LICENSES.md`
      unchanged (no asset added).
- [ ] Note in Notes that the device play-test (iPad and phone, ≥ 30 fps on home and the list)
      stays with the author (spec 03, D6, Deferred Items).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Save the chosen fighter, skin and progress between visits | Nothing is saved yet; the first saving spec defines the file (D4, S13) | [05 Hack codes](2026_11_12_05_hack_codes_spec.md) / [08 Trophies](2026_11_12_08_trophies_spec.md) |
| The selected fighter and skin in the arena | The arena keeps spec 01's fighter (D6) | [06 Graphics demo](2026_11_12_06_graphics_demo_spec.md) (its S2) |
| **Hack** button on the home screen | F2 | [05 Hack codes](2026_11_12_05_hack_codes_spec.md) (its S1) |
| Unlocking fighters with credits | F6 | [09 Unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) |
| Music and sound effects with a mute button | Left out of this spec (Open questions) | [17 Fighter studio, saves and music](2026_11_14_17_fighter_studio_saves_and_music_spec.md) |
| Translations of the new text | English only (S14, D11) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Play-test on a real iPad and phone (touch, ≥ 30 fps on home and the list) | Needs a person with the devices (spec 03, D6) | the author, before spec 08 is closed |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `tools/test.ps1`, `tools/lint.ps1`, `tools/check_tools.ps1` and `tools/export_web.ps1` pass; `hack_star_godot/README.md` / `docs/architecture.md` updated
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted — one pull request for `feature/godot-mvp` at the end of the run
