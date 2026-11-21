# Trophies and Prestige Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Not started — plan ready
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-mvp`
> **Issue:** #32
> **Moved from:** [2026_11_12_trophies_spec.md](../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_trophies_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S2, S3, S4, S5 revised; S11 (progress kept), S12 (English), S13 (what worked before) and S14 (MVP complete) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #32 created (no parent) |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 2.40 M (119 k in · 2.25 M cached · 26 k out) | CHF 1.32 (157 credits) | Part 2 written (7 Steps: standard, reasoning, standard, standard, standard, standard, light); also the requirements revision and the issue (`usage.ps1 -AgentName s08-lead` from 21:49:57) |

---

# Part 1 · Requirements

## Context

Matches can be won and lost, but nothing is earned. The kids' favourite part of Brawl Stars is
pushing a fighter's trophies and reaching **Prestige** at 1000 trophies ("if I win, the
fighter gets 10 trophies; at 1000 it gets a diamond with a number"). This spec gives trophies
after each match and celebrates Prestige. It is F5 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md), and with it the
first playable version (F0–F5) is complete.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6).
- [First match spec](done/2026_11_12_07_first_match_spec.md) — matches with a result (victory,
  defeat with place, time's up) and the result screen; match settings.
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — trophies per fighter in the saved
  progress, total trophies on home, the Prestige badge on home, list and fighter screen.
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14); its S8 (the MVP is F0–F5) and S9 (progress kept on the same
  device and browser).
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) — the first save file (D5).
- Checked 2026-11-21 (S0) in the code: `GameState` (`scenes/autoload/game_state.gd`) holds
  trophies, power levels, unlocked fighters, credits and the selected fighter and skins for the
  session only; it starts from `SampleProgress` (`game/sample_progress.gd`: Blaze 1240, Rocko
  420, Turbo 85, the others 0; 500 credits) at every game start (spec 04, D4 and S13: "saving
  between visits comes with spec 05 or 08"). The only save file is `user://hack_star_save.json`
  of spec 05 (D5), `{"version": 1, "hacks": [...]}`, read and written by `GameState` through
  the pure `SaveData` (`game/save_data.gd`; a missing, broken or newer file gives no hacks).
  `Prestige.level(trophies)` (`game/prestige.gd`) and the `PrestigeBadge`
  (`scenes/ui/prestige_badge.tscn`, a panel "Prestige 2", hidden below 1000) exist; home shows
  "Trophies: <total>" and the badge, the list and the fighter screen "Trophies: <n>" and the
  badge. A match (`scenes/match_arena.gd`) stores `GameState.last_result`
  (`{outcome, place, fighter, skin}`, session only, "spec 08 will read it for trophies") the
  moment it is over and opens the result screen (`scenes/result_screen.gd`: heading, line,
  fighter, **Play again**, **Home**) 1.5 s later; **Back** in a match goes home without a
  result; **Training** opens the dummy arena (`arena.tscn`). The match settings are
  `MatchSettings` (`game/match_settings.gd`, D2 of spec 07); its `time_up_result` "defeat"
  turns a time-up into a defeat. No trophy changes anywhere yet. The Godot default font has no
  emoji (no "🏆"). The Godot game has no languages yet (English, spec 15).

**New:**
- Trophy rules for each result, saving the whole progress between visits (a new version of the
  save file), and showing the trophies on the result screen with a Prestige celebration.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and the questions to Mattia |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–07) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. — checked 2026-11-21: S1, S6, S7, S8 fit;
  S2, S3, S4, S5 revised (a time-up set to count as a defeat, what "saved" means with the save
  file of spec 05, no emoji in the Godot font, the Prestige badge of spec 04); S11 (progress
  kept), S12 (English), S13 (what worked before) and S14 (the MVP complete) added; no open
  questions.
- **S1 — Win:** A victory gives the fighter that played it +10 trophies.
- **S2 — Defeat and time's up:** A defeat or a time's up changes no trophies (default; see S8).
  When the match settings count a time-up as a defeat (spec 07, S10), it gets the trophies of
  a defeat. _(revised 2026-11-21: the Godot match has the setting `time_up_result`.)_
- **S3 — Saved:** The new trophy count is saved at once (when the match ends, before the result
  screen opens) and shown on home (fighter and total), in the fighter list and on the fighter
  screen, also after the game or the browser is closed and opened again (S11). _(revised
  2026-11-21: "at once" made testable; the Godot game saves only the hacks so far, spec 05.)_
- **S4 — Result screen:** The result screen shows the trophy change (for example "+10
  trophies", "+0 trophies" after a defeat) counting up, the fighter's new trophy count, and a
  bar to the next Prestige (for example "1250 / 2000"). _(revised 2026-11-21: the Godot
  default font has no emoji, so "trophies" is written out.)_
- **S5 — Prestige up:** When a win takes a fighter to 1000, 2000, 3000… trophies, the result
  screen shows a "PRESTIGE 2!" celebration with the Prestige badge (spec 04) and its number.
  _(revised 2026-11-21: the badge of the Godot game is the "Prestige n" badge of spec 04.)_
- **S6 — Prestige floor:** A fighter's trophies never drop below the last Prestige it reached
  (only matters if defeats take trophies away, S8).
- **S7 — Only matches count:** Training never changes trophies; leaving a match before it ends
  changes nothing.
- **S8 — Settings:** Trophies for a win (default 10) and for a defeat (default 0) are set in
  one place with the match settings, so Mattia's answer is a one-line change.
- ~~**S9 — Documentation:** README and `docs/architecture.md` describe how trophies and
  Prestige work.~~ (replaced for the Godot game by S10: it names the documents of the Python +
  Svelte game)
- **S10 — Documentation (Godot):** `hack_star_godot/README.md` and
  `hack_star_godot/docs/architecture.md` describe how trophies and Prestige work, and how the
  progress is saved.
- **S11 — Progress kept:** The player's progress — trophies per fighter, unlocked fighters,
  credits, power levels, the chosen fighter and its skin per fighter, and the active hacks — is
  still there after the game or the browser is closed and opened again on the same device and
  in the same browser (spec 03, S9). A first visit starts from the sample progress (spec 04);
  a save file of spec 05 keeps its hacks and starts the rest from the sample progress; a
  broken or unreadable file starts from the sample progress without hacks and the game still
  opens. _(added 2026-11-21: spec 03 S9 and spec 04 S13 leave saving between visits to this
  spec; the save file of spec 05 holds only the hacks.)_
- **S12 — Language:** All new text (the trophy change, the count, the bar, the celebration) is
  in English; translations come with
  [spec 15](2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-21: the
  Godot game has no languages yet.)_
- **S13 — What worked before:** Home, the fighter list, the fighter screen, the info page, the
  hack screen with its codes, Training, the match and the result screen work as before; the
  result screen fits the five screen sizes of the other screens with the new trophy part, with
  mouse and touch; the hacks change no trophies (spec 05, S12). _(added 2026-11-21: the
  result screen and the save file are shared with specs 04–07.)_
- **S14 — MVP complete:** With this spec, F0–F5 of the feature list are playable together
  (spec 03, S8): from home a player picks a fighter, uses a hack code, plays a match, sees the
  trophies on the result screen and on home, and finds them again after a reload. The
  play-test on a real iPad and phone stays with the author (spec 03, D6). _(added
  2026-11-21: this is the last spec of the MVP.)_

### Open questions

_None. "Should a defeat take trophies?" is one of the questions to Mattia; until then a defeat
takes none (S2, S8). The S0 check 2026-11-21 raised no new question: the revisions take the
spec's own suggestion (a defeat takes none) and the decisions of specs 03–07 (what progress is
kept, S11)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Trophy rules and settings | standard (Claude Sonnet 5.5) — pure rules and tests, numbers fixed by D1 and D2 | ⬜ Not started | [→ Step 1](#step-1--trophy-rules-and-settings) |
| **2** | Save file version 2 | reasoning (Claude Opus 5.5) — a new saved format with versioning, migration of the spec 05 file and checks of every field (D3) | ⬜ Not started | [→ Step 2](#step-2--save-file-version-2) |
| **3** | Progress loaded and saved | standard (Claude Sonnet 5.5) — `GameState` reads and writes the file of Step 2, tests kept away from the player's file (D4, D7) | ⬜ Not started | [→ Step 3](#step-3--progress-loaded-and-saved) |
| **4** | Trophies after a match | standard (Claude Sonnet 5.5) — one call at the end of the match and its tests (D5) | ⬜ Not started | [→ Step 4](#step-4--trophies-after-a-match) |
| **5** | Result screen trophies and Prestige | standard (Claude Sonnet 5.5) — a new part of an existing screen with a count-up and a celebration, checked on screenshots (D6) | ⬜ Not started | [→ Step 5](#step-5--result-screen-trophies-and-prestige) |
| **6** | MVP flow check | standard (Claude Sonnet 5.5) — one end-to-end test across the screens of specs 04–08 (D9) | ⬜ Not started | [→ Step 6](#step-6--mvp-flow-check) |
| **7** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks and updating two documents | ⬜ Not started | [→ Step 7](#step-7--final-check-readme-and-architecture) |

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
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0. Nothing in `server/` or `ui/`
> changes, and no server is called for trophies or saving (D8). `gdlint` allows at most 20
> public tests per file: new tests go into new files where a file is full (`test_home.gd` has
> 18, `test_screen_sizes.gd` 16). **Looks are checked on real screenshots:** a windowed Godot
> run with a temporary capture script (saved under `%TEMP%`, viewed, then removed, never
> committed), at 1280×720 and 390×844 unless the Step says otherwise.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **Trophy rules are pure:** `game/trophies.gd` (`Trophies`, static): `change_for(outcome, settings)` — `Match.Result.VICTORY` → `settings.trophies_per_win`, `DEFEAT` → `settings.trophies_per_defeat`, `TIME_UP` → 0 (a time-up that the settings count as a defeat is already `DEFEAT` in `Match`, spec 07 D4); `reward(before, outcome, settings) -> {before, after, change, prestige_before, prestige_after}` with `after = maxi(before + change_for(...), Prestige.floor_of(before))` (never below 0) and `change = after - before`. `Prestige` gets `floor_of(trophies)` (level × 1000) and `next_at(trophies)` ((level + 1) × 1000). | S1, S2, S5, S6: the original game's `rewardFor`; testable without a scene (architecture, *Game rules*). |
| D2 | **Trophy settings with the match settings:** `MatchSettings` gets `TROPHIES_PER_WIN` 10 and `TROPHIES_PER_DEFEAT` 0 and the fields `trophies_per_win` (≥ 0, clamped) and `trophies_per_defeat` (≤ 0, clamped: a defeat never gives trophies). | S8: Mattia's answer is one constant; tests change the instance in `GameState.match_settings`. |
| D3 | **Save file version 2** (`user://hack_star_save.json`, still written only by `GameState` through `SaveData`): `{"version": 2, "hacks": [...], "progress": {"trophies": {id: n}, "power_levels": {id: n}, "unlocked": [id, …], "credits": n, "selected_fighter": id, "selected_skins": {id: skin}}}`. `SaveData.VERSION` = 2; `to_json(hacks, progress)`; `from_json(text) -> {"hacks": Array[String], "progress": Dictionary}`. Reading: **version 1** (spec 05) gives its hacks and an empty progress (migration: the rest starts from the sample progress); **version 2** gives hacks and the progress after checks — fighter ids the game does not know are dropped, trophies and credits are whole numbers ≥ 0, power levels ≥ 1, `unlocked` keeps known ids only, a missing field or fighter is left out (filled from the sample by `GameState`), a skin a fighter does not have is left out; a missing, broken, non-object or **newer** file gives no hacks and an empty progress (as in spec 05; the next save writes version 2). | S3, S11: the architecture's plan (one JSON, one autoload, `version` for migrations); a spec 05 file keeps its hacks; a damaged file never stops the game. |
| D4 | **`GameState` loads and saves the whole progress:** `_ready` calls `reset()` (sample progress) and then `load_saved()` (reads the file and lays the saved values over the sample: trophies, power levels and selected skins per fighter, `unlocked` joined with `Fighters.start_unlocked()`, credits, and the selected fighter when it is known and unlocked, else the sample's); `save()` writes hacks and progress (replaces `_save_hacks`, same warning when the file cannot be written). It saves after `activate_hack`, `reset_hacks`, a successful `select` and `award_trophies` (D5). `reset()` stays in memory only. The hacks are never written into the progress (`unlock_all` does not add to `unlocked`). Credits and power levels are saved as they are; nothing in this spec changes them (spec 09 will, and calls `save()`). | S3, S11, S13: one owner of the file (spec 05, D5); spec 04 S13 ("saving between visits comes with spec 05 or 08") is now met. |
| D5 | **Trophies at the end of the match:** `GameState.award_trophies(fighter_id, outcome) -> Dictionary` applies `Trophies.reward` with `GameState.match_settings` to that fighter, saves at once and returns the reward. `MatchArena._store_result_when_over` (runs once per match) calls it for the player's fighter and puts the reward into `GameState.last_result["reward"]`. **Back** before the end gives nothing; **Back** during the 1.5 s wait keeps the saved trophies; Training (`Arena`, no `Match`) never calls it. Hacks are not read. | S1–S3, S7: the original game's D3 (worked out once, when the match ends, not when the screen opens). |
| D6 | **Result screen trophy part** (`scenes/result_screen.tscn`, under the line): `TrophyPanel` (`CardPanel`) with `ChangeLabel` ("+10 trophies", "+0 trophies"), `CountLabel` ("1250 / 2000": the count and `Prestige.next_at`), `PrestigeBar` (`ProgressBar` with theme styles, from `Prestige.floor_of(after)` to `next_at(after)`, no percentage text) and `Celebration` (hidden unless `prestige_after > prestige_before`: a `HeadingLabel` "PRESTIGE 2!", a `PrestigeBadge` and a short pop of both, scale 0.6 → 1.1 → 1.0, plus a one-shot `CPUParticles2D` burst in `Rarity.LEGENDARY_GOLD`). The change, the count and the bar count up from `before` to `after` in `COUNT_SECONDS` = 1.0 (a `Tween`); the celebration starts when the count reaches the new Prestige. `finish_count()` jumps to the end (tests). Short screens (content height below 520 px, phones on their side) hide the `FighterStage` so the trophy part and the buttons stay visible. A result without `reward` (should not happen) hides the panel. | S4, S5, S12, S13: the original game's result screen; the UI foundation of spec 04 (theme, no own colours except Legendary gold, which `Rarity` holds). |
| D7 | **Tests never touch the player's save file:** `tests/pre_run_hook.gd` (a GUT pre-run hook, passed by `tools/test.ps1` as `-gpre_run_script=res://tests/pre_run_hook.gd`) points `GameState.save_path` to `user://test/run_save.json`, deletes that file and calls `GameState.reset()`; the tests that check the file keep their own path as today (`test_game_state.gd`, `test_hack_effects.gd`, `test_hack_screen.gd`). | Every match test now saves; a developer's own progress must not change and must not change what a test sees. |
| D8 | **No server, English:** trophies and progress live in the save file on the device (spec 03, S9; no login, nothing shared between devices — spec 15); all new text is English (spec 15 translates). | S11, S12; the original game's D4. |
| D9 | **Tests:** `test_prestige.gd` (`floor_of`, `next_at`); `test_trophies.gd` (win +10; defeat and time-up 0; a time-up counted as a defeat gets the defeat's trophies; 990 + 10 → Prestige 1; with a defeat of −20: 1005 → 1000 (floor) and 15 → 0); `test_match_settings.gd` (defaults and clamps of the two trophy fields); `test_save_data.gd` / new `test_save_data_v2.gd` (round trip; version 1 → hacks and empty progress; newer, broken, non-object → nothing; unknown fighters, negative numbers, unknown skins and an unknown selected fighter dropped); `test_game_state_save.gd` (a fresh start is the sample; saved trophies, unlocks, credits, power levels and selection come back after a new load; a spec 05 file keeps its hacks; `select` and `award_trophies` save; `reset()` writes nothing); `test_match_trophies.gd` (victory +10 saved before the result screen opens; defeat and time-up 0; Back before the end changes nothing; Training changes nothing; a hack changes nothing; `last_result.reward`); `test_result_screen.gd` / new `test_result_trophies.gd` (texts, bar range, count-up end state, celebration only on a new Prestige); `test_screen_sizes_match.gd` (the result screen with the trophy part at the five sizes, buttons with mouse and touch, the celebration on screen); `test_mvp_flow.gd` (D10). | Every statement checked by a test or a screenshot; the device play-test stays with the author (spec 03, D6). |
| D10 | **The MVP check (spec 03, S8) is a test:** `tests/test_mvp_flow.gd` walks home → **Hack** (a `power22` code with the fake `HackServer` responder) → **Fighters** → a fighter → **Select** → home → **Play** (`match_settings`: 1 bot, short countdown) → the bot knocked out → the result screen (+10) → **Home** (total +10, the badge), then loads a fresh `GameState` state from the same test file and finds the trophies, the selection and the hack again. | S14: F0–F5 together, checked by a script; what a script cannot check stays with the author. |

---

## Step 1 — Trophy rules and settings

### Goal
The trophies for each result, the Prestige floor and the next Prestige are rules with tests,
and the two trophy numbers are match settings (S1, S2, S5, S6, S8).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `Prestige.floor_of` and `Prestige.next_at` after D1.
- [ ] `MatchSettings` trophy constants and fields after D2.
- [ ] `game/trophies.gd` (`Trophies`) after D1.
- [ ] Tests (D9): `test_prestige.gd`, new `test_trophies.gd`, `test_match_settings.gd`.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 2 — Save file version 2

### Goal
The save file holds the whole progress next to the hacks, with `version` 2; a spec 05 file
keeps its hacks, a damaged or newer file gives nothing, and every field is checked (S3, S11).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `game/save_data.gd` after D3 (`VERSION` 2, `to_json(hacks, progress)`, `from_json` →
      `{hacks, progress}`, version 1 migration, field checks); update its callers in
      `GameState` so the game behaves as before (hacks only) until Step 3.
- [ ] Tests (D9): `test_save_data.gd` adapted to the new return value, new
      `test_save_data_v2.gd` (round trip, version 1, newer, broken, non-object, bad fields).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 3 — Progress loaded and saved

### Goal
`GameState` loads the saved progress at the start and saves it after every change, and the tests
use their own file (S3, S11, S13).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `tests/pre_run_hook.gd` and the `-gpre_run_script` argument in `tools/test.ps1` after D7
      (the script still parses with `[System.Management.Automation.Language.Parser]::ParseFile`).
- [ ] `GameState` after D4: `load_saved()`, `save()`, saving after `activate_hack`,
      `reset_hacks` and a successful `select`; `award_trophies` after D5 (used in Step 4).
- [ ] Tests (D9): new `test_game_state_save.gd`; `test_game_state.gd`, `test_hack_effects.gd`
      and `test_hack_screen.gd` still pass.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; after a test run the player's own
      `user://hack_star_save.json` is unchanged (its time stamp, or absent if it was absent).

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 4 — Trophies after a match

### Goal
The end of a match gives the player's fighter its trophies once and saves them before the
result screen opens; Back before the end and Training change nothing (S1, S2, S3, S7).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `MatchArena._store_result_when_over` calls `GameState.award_trophies` and stores the
      reward in `last_result["reward"]` (D5).
- [ ] Tests (D9): new `test_match_trophies.gd`; `test_match_arena.gd` still passes.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 5 — Result screen trophies and Prestige

### Goal
The result screen shows the trophy change counting up, the new count and the bar to the next
Prestige, and celebrates a new Prestige; it fits every screen size (S4, S5, S12, S13).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `scenes/result_screen.tscn` + `.gd` after D6 (trophy panel, count-up, celebration,
      `finish_count()`, the fighter hidden on short screens).
- [ ] Tests (D9): `test_result_screen.gd` / new `test_result_trophies.gd`;
      `test_screen_sizes_match.gd`.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots at 1280×720, 390×844
      and 844×390 of a victory with Blaze at 1240 (+10, "1250 / 2000"), of a defeat (+0) and of
      a win from 1990 ("PRESTIGE 2!" with the badge); the trophy part and both buttons on
      screen.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 6 — MVP flow check

### Goal
F0–F5 work together: hack, fighter choice, match, trophies on the result screen and on home,
and everything back after a reload (S3, S11, S13, S14).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] New `tests/test_mvp_flow.gd` after D10.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; a windowed run: win a match, close
      Godot, open it again — home shows the new total and the chosen fighter (screenshot).

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 7 — Final check, README and architecture

### Goal
Everything that worked before still works, all Godot checks pass, spec 03 S8 (F0–F5 playable
together) is re-checked, and the README and the architecture describe trophies, Prestige and
the saved progress (S10, S13, S14, all statements).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/docs/architecture.md`: Game rules (`trophies.gd`, the new `Prestige`
      functions, the trophy settings of `MatchSettings`, `save_data.gd` version 2), Screens
      (the result screen's trophy part and celebration; `MatchArena` gives the trophies),
      UI foundation (`GameState`: `load_saved`, `save`, `award_trophies`, `last_result.reward`),
      *Saved progress* (version 2, the fields, the migration of version 1, no longer
      *planned*; the heading updated), Tests (the new files and the pre-run hook); the line
      "Later specs add their rules here … trophies (specs 08, …)" updated.
- [ ] `hack_star_godot/README.md`: trophies and Prestige after a match (+10 for a win, 0 for a
      defeat or time-up, the Prestige floor, the result screen), where the trophy settings
      are (`game/match_settings.gd`), what is saved and where (and how to start fresh: delete
      the save file), and that the MVP (F0–F5) is complete.
- [ ] Re-check spec 03 S8: F0–F5 are playable together (`test_mvp_flow.gd` passes; the
      feature list rows F0–F5 are built); write the result into Notes.
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); `git diff --stat` of this spec shows nothing in `server/` or `ui/`.
- [ ] Note in Notes that the device play-tests of specs 04–07 and this one (iPad and phone:
      touch, ≥ 30 frames per second, a full match, the trophies after a reload in the same
      browser) and the browser check stay with the author (spec 03, D6, Deferred Items).

### Notes
_Add the `Done` line here when the Step is finished._

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Play-test on a real iPad and phone of the whole MVP (specs 04–08: touch, ≥ 30 frames per second, the camera for hack codes, a full match, the trophies kept after a reload) and the browser check of the web export | Needs a person with the devices and a browser (spec 03, D6) | the author, before the MVP pull request |
| Credits, unlocks and power upgrades that change with play (saved with `save()`) | Not part of trophies; the fields are already in the save file (D3) | [09 Unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) |
| Progress on another device or browser (accounts) | No login in the MVP (spec 03, S9) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Translations of new text | English only (S12, D8) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |

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
- [ ] Pull request · one pull request for the whole MVP branch at the end (not per spec)
