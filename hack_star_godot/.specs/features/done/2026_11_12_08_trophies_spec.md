# Trophies and Prestige Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ✅ Complete — closed on feature/godot-mvp
> **Created:** 2026-11-21
> **Last updated:** 2026-11-22
> **Branch:** `feature/godot-mvp`
> **Issue:** #32
> **Moved from:** [2026_11_12_trophies_spec.md](../../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_trophies_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S2, S3, S4, S5 revised; S11 (progress kept), S12 (English), S13 (what worked before) and S14 (MVP complete) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #32 created (no parent) |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 2.40 M (119 k in · 2.25 M cached · 26 k out) | CHF 1.32 (157 credits) | Part 2 written (7 Steps: standard, reasoning, standard, standard, standard, standard, light); also the requirements revision and the issue (`usage.ps1 -AgentName s08-lead` from 21:49:57) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 392 k (52 k in · 335 k cached · 5 k out) | CHF 0.18 (21 credits) | Step 1 done (`usage.ps1 -AgentName s08-step1` from 21:49:57) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 862 k (43 k in · 811 k cached · 8 k out) | CHF 0.45 (53 credits) | Step 2 done (`usage.ps1 -AgentName s08-step2` from 21:49:57) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.04 M (48 k in · 978 k cached · 10 k out) | CHF 0.27 (32 credits) | Step 3 done (`usage.ps1 -AgentName s08-steps3-6 -Since "2026-11-21 22:01:47" -Until "2026-11-21 22:06:30"`) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 565 k (14 k in · 545 k cached · 7 k out) | CHF 0.13 (15 credits) | Step 4 done (`usage.ps1 -AgentName s08-steps3-6 -Since "2026-11-21 22:06:30" -Until "2026-11-21 22:09:00"`) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.58 M (40 k in · 2.52 M cached · 17 k out) | CHF 0.44 (52 credits) | Step 5 done (`usage.ps1 -AgentName s08-steps3-6 -Since "2026-11-21 22:09:00" -Until "2026-11-21 22:14:00"`) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.46 M (19 k in · 1.44 M cached · 9 k out) | CHF 0.23 (28 credits) | Step 6 done (`usage.ps1 -AgentName s08-steps3-6 -Since "2026-11-21 22:14:00" -Until "2026-11-21 22:18:00"`) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | 2.78 M (106 k in · 2.65 M cached · 21 k out) | CHF 0.07 (9 credits) | Step 7 done (`usage.ps1 -AgentName s08-step7 -Since "2026-11-21 21:49:57"`) |
| 2026-11-22 | review | `REVIEW:` + `CODE REVIEW:` | Claude Opus 5.5 | 12.77 M (369 k in · 12.28 M cached · 118 k out) | CHF 5.59 (667 credits) | semantic diff written (7 record blocks, checks 7 pass · 2 n/a · 0 fail, [review page](../../review/2026-11-21_godot-mvp-08-trophies.html)); code review: Approve, 0 Blocking · 2 Should-fix · 5 Nit (`usage.ps1 -AgentName s08-review,s08-review2` from 2026-11-21 21:49:57; includes the requests of the interrupted first review agent `s08-review`, whose output was deleted — real cost) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.17 M (81 k in · 1.08 M cached · 8 k out) | CHF 0.33 (39 credits) | review fixes #2, #3, #5, #7 and the decisions D11 (#1) and D12 (#4); #6 was already in Deferred Items; commit `Fix review findings (#32)` (`usage.ps1 -AgentName s08-close` 2026-11-22 08:13:58–08:17:07) |
| 2026-11-22 | implementation | `CLOSE:` | Claude Sonnet 5.5 | 1.36 M (30 k in · 1.32 M cached · 13 k out) | CHF 0.28 (34 credits) | spec closed (`usage.ps1 -AgentName s08-close` from 2026-11-22 08:17:07) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 419 k (153 k in · 260 k cached · 6 k out) | CHF 0.39 (47 credits) | spec runner (coordination); the first runner s08-runner was cut off by a network error and s08-runner2 resumed — both counted (`usage.ps1 -AgentName s08-runner,s08-runner2` from 2026-11-21 21:49:57) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.09 M (1.04 M in · 1.04 M cached · 2 k out) | CHF 4.59 (547 credits) | orchestrator (main chat) (`usage.ps1 -Agent main` from 2026-11-21 21:49:57) |
| 2026-11-22 | pr | `PR:` | Claude Haiku 5.5 | included in spec 16 | included in spec 16 | pull request opened (one PR for the MVP) |
---

## Cost summary

This feature used 29.89 M tokens, CHF 14.27 (1701 credits) — measured, see [COSTS.md](../../../../.specs/kit/COSTS.md).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| requirements | Claude Sonnet 5.5, Claude Opus 5.5 | included in plan | included in plan | 0 % |
| plan | Claude Opus 5.5 | 2.40 M | CHF 1.32 (157 credits) | 8.3 % |
| implementation | Claude Sonnet 5.5, Claude Opus 5.5, Claude Haiku 5.5 | 14.72 M | CHF 7.36 (877 credits) | 46.2 % |
| review | Claude Opus 5.5 | 12.77 M | CHF 5.59 (667 credits) | 35.1 % |
| **Total** | | **29.89 M** | **CHF 14.27 (1701 credits)** | **89.5 %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (CHF) | Share of Copilot Business |
|------|-------|--------|------------|---------------------------|
| Step 1 | Claude Sonnet 5.5 | 392 k | CHF 0.18 (21 credits) | 1.1 % |
| Step 2 | Claude Opus 5.5 | 862 k | CHF 0.45 (53 credits) | 2.8 % |
| Step 3 | Claude Sonnet 5.5 | 1.04 M | CHF 0.27 (32 credits) | 1.7 % |
| Step 4 | Claude Sonnet 5.5 | 565 k | CHF 0.13 (15 credits) | 0.8 % |
| Step 5 | Claude Sonnet 5.5 | 2.58 M | CHF 0.44 (52 credits) | 2.7 % |
| Step 6 | Claude Sonnet 5.5 | 1.46 M | CHF 0.23 (28 credits) | 1.5 % |
| Step 7 | Claude Haiku 5.5 | 2.78 M | CHF 0.07 (9 credits) | 0.5 % |
| Review fixes | Claude Sonnet 5.5 | 1.17 M | CHF 0.33 (39 credits) | 2.1 % |
| CLOSE | Claude Sonnet 5.5 | 1.36 M | CHF 0.28 (34 credits) | 1.8 % |
| Spec runner (coordination) | Claude Sonnet 5.5 | 419 k | CHF 0.39 (47 credits) | 2.5 % |
| Orchestrator (main chat) | Claude Opus 5.5 | 2.09 M | CHF 4.59 (547 credits) | 28.8 % |
| **Total implementation** | | **14.72 M** | **CHF 7.36 (877 credits)** | **46.2 %** |

# Part 1 · Requirements

## Context

Matches can be won and lost, but nothing is earned. The kids' favourite part of Brawl Stars is
pushing a fighter's trophies and reaching **Prestige** at 1000 trophies ("if I win, the
fighter gets 10 trophies; at 1000 it gets a diamond with a number"). This spec gives trophies
after each match and celebrates Prestige. It is F5 in the
[MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md), and with it the
first playable version (F0–F5) is complete.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6).
- [First match spec](2026_11_12_07_first_match_spec.md) — matches with a result (victory,
  defeat with place, time's up) and the result screen; match settings.
- [Basic UI spec](2026_11_12_04_basic_ui_spec.md) — trophies per fighter in the saved
  progress, total trophies on home, the Prestige badge on home, list and fighter screen.
- [MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14); its S8 (the MVP is F0–F5) and S9 (progress kept on the same
  device and browser).
- [Hack codes spec](2026_11_12_05_hack_codes_spec.md) — the first save file (D5).
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
| [overall_req.md](../../../../.specs/overall_req.md) | Overall game idea and the questions to Mattia |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../../README.md) | How to open, run, test and export the Godot game |

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
  [spec 15](../2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-21: the
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

## Closing summary

**Built:** A win now gives the played fighter +10 trophies (0 for a defeat or a time-up), never below its last Prestige (`Trophies`, `Prestige.floor_of` / `next_at`; the two numbers are clamped settings in `MatchSettings`). The trophies are given once, when the match ends, and saved at once; the result screen shows the change ("+10 trophies"), the count "1250 / 2000" and a bar from the last Prestige to the next, counting up over 1 s, and a new Prestige shows "PRESTIGE n!" with the badge and a gold burst. The save file is version 2: the hacks and the whole progress (trophies, power levels, unlocked fighters, credits, chosen fighter and skins); a spec 05 file keeps its hacks, every saved field is checked and a damaged file never stops the game. `tests/pre_run_hook.gd` keeps the tests off the player's file. `tests/test_mvp_flow.gd` walks F0–F5 (home, hack, fighter, match, result with trophies, home, a fresh load). With this the first playable version (F0–F5) is complete. No server call.

**Differs from the plan:** The code review (Approve, 0 Blocking · 2 Should-fix · 5 Nit) was handled: findings 2, 3, 5 and 7 are fixed (the tap-to-skip claim removed from the `finish_count()` comment and the architecture, three wording errors in the architecture, the burst colour set from `Rarity.LEGENDARY_GOLD`, the Definition of Done line); two decisions were added: D11 (the chosen fighter is kept after a restart when `is_unlocked` says it is available, the unlock-all hack included; with a test) and D12 (no `.gutconfig.json`: README and architecture say to run the tests with `tools/test.ps1`); finding 6 (an upper limit for saved power levels) is in Deferred Items for spec 09. Nothing else differs.

**Files:** `hack_star_godot/game/` (`trophies`, `prestige`, `match_settings`, `save_data`), `hack_star_godot/scenes/` (`autoload/game_state`, `match_arena`, `result_screen`, `result_screen.tscn`), `hack_star_godot/scenes/ui/hack_star_theme.tres`, `hack_star_godot/tests/`, `hack_star_godot/tools/test.ps1`, `hack_star_godot/docs/architecture.md`, `hack_star_godot/README.md`; this spec, now in `done/`, its change record in `changes/done/` and the review page in `review/`.

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Trophy rules and settings | standard (Claude Sonnet 5.5) — pure rules and tests, numbers fixed by D1 and D2 | ✅ Done | [→ Step 1](#step-1--trophy-rules-and-settings) |
| **2** | Save file version 2 | reasoning (Claude Opus 5.5) — a new saved format with versioning, migration of the spec 05 file and checks of every field (D3) | ✅ Done | [→ Step 2](#step-2--save-file-version-2) |
| **3** | Progress loaded and saved | standard (Claude Sonnet 5.5) — `GameState` reads and writes the file of Step 2, tests kept away from the player's file (D4, D7) | ✅ Done | [→ Step 3](#step-3--progress-loaded-and-saved) |
| **4** | Trophies after a match | standard (Claude Sonnet 5.5) — one call at the end of the match and its tests (D5) | ✅ Done | [→ Step 4](#step-4--trophies-after-a-match) |
| **5** | Result screen trophies and Prestige | standard (Claude Sonnet 5.5) — a new part of an existing screen with a count-up and a celebration, checked on screenshots (D6) | ✅ Done | [→ Step 5](#step-5--result-screen-trophies-and-prestige) |
| **6** | MVP flow check | standard (Claude Sonnet 5.5) — one end-to-end test across the screens of specs 04–08 (D9) | ✅ Done | [→ Step 6](#step-6--mvp-flow-check) |
| **7** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks and updating two documents | ✅ Done | [→ Step 7](#step-7--final-check-readme-and-architecture) |

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
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../../AGENTS.md)). Each
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
| D11 | **Review finding 1 (runner decision):** `GameState.load_saved` keeps the saved chosen fighter when `is_unlocked(chosen)` is true (the saved `unlocked` list or the `unlock_all` hack, whose hacks are loaded first), so a fighter chosen through the hack survives a restart as S11 says; D4's "known and unlocked" means "available". Test in `test_game_state_save.gd`. | S11; the simplest rule that keeps what the player chose. |
| D12 | **Review finding 4 (runner decision):** no code change (no `.gutconfig.json`): `README.md` and `docs/architecture.md` say that the tests are run with `tools/test.ps1`, because only it passes the pre-run hook (D7), and that GUT started from the editor needs the hook set. | Nit; the checks of every Step already use `tools/test.ps1`. |

---

## Step 1 — Trophy rules and settings

### Goal
The trophies for each result, the Prestige floor and the next Prestige are rules with tests,
and the two trophy numbers are match settings (S1, S2, S5, S6, S8).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `Prestige.floor_of` and `Prestige.next_at` after D1.
- [x] `MatchSettings` trophy constants and fields after D2.
- [x] `game/trophies.gd` (`Trophies`) after D1.
- [x] Tests (D9): `test_prestige.gd`, new `test_trophies.gd`, `test_match_settings.gd`.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 21:55

**Done (2026-11-21 · ~3 min · Claude Sonnet 5.5)** — `Prestige.floor_of`/`next_at`, the
`MatchSettings` trophy settings (win ≥ 0, defeat ≤ 0) and `Trophies.change_for`/`reward` with
tests. `tools/test.ps1` 307 tests passed, `tools/lint.ps1` OK · suggested: standard (Claude
Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~392 k · ~CHF 0.18 (21 credits)

---

## Step 2 — Save file version 2

### Goal
The save file holds the whole progress next to the hacks, with `version` 2; a spec 05 file
keeps its hacks, a damaged or newer file gives nothing, and every field is checked (S3, S11).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/save_data.gd` after D3 (`VERSION` 2, `to_json(hacks, progress)`, `from_json` →
      `{hacks, progress}`, version 1 migration, field checks); update its callers in
      `GameState` so the game behaves as before (hacks only) until Step 3.
- [x] Tests (D9): `test_save_data.gd` adapted to the new return value, new
      `test_save_data_v2.gd` (round trip, version 1, newer, broken, non-object, bad fields).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 21:58

**Done (2026-11-21 · ~4 min · Claude Opus 5.5)** — `SaveData` version 2: `to_json(hacks, progress)`,
`from_json` → `{hacks, progress}`, version 1 kept as hacks with an empty progress, newer/broken/non-object
files give nothing, every progress field checked (unknown fighters, skins and selection, non-whole
or out-of-range numbers left out); `GameState` still saves and loads only the hacks (empty
progress) until Step 3. `tools/test.ps1` 314 tests passed, `tools/lint.ps1` OK · suggested:
reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · ~862 k · ~CHF 0.45 (53 credits)

---

## Step 3 — Progress loaded and saved

### Goal
`GameState` loads the saved progress at the start and saves it after every change, and the tests
use their own file (S3, S11, S13).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `tests/pre_run_hook.gd` and the `-gpre_run_script` argument in `tools/test.ps1` after D7
      (the script still parses with `[System.Management.Automation.Language.Parser]::ParseFile`).
- [x] `GameState` after D4: `load_saved()`, `save()`, saving after `activate_hack`,
      `reset_hacks` and a successful `select`; `award_trophies` after D5 (used in Step 4).
- [x] Tests (D9): new `test_game_state_save.gd`; `test_game_state.gd`, `test_hack_effects.gd`
      and `test_hack_screen.gd` still pass.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; after a test run the player's own
      `user://hack_star_save.json` is unchanged (its time stamp, or absent if it was absent).

### Notes
Started: 2026-11-21 22:02

**Done (2026-11-21 · ~5 min · Claude Sonnet 5.5)** — `GameState.load_saved`, `save` (after
`activate_hack`, `reset_hacks`, `select`) and `award_trophies`; `tests/pre_run_hook.gd` passed
by `tools/test.ps1`; `test_game_state.gd` and `test_hack_screen.gd` read the file with
`SaveData` instead of the removed `_load_hacks`. `tools/test.ps1` 324 tests passed,
`tools/lint.ps1` OK, `test.ps1` parses, the player's `hack_star_save.json` stays absent ·
suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~1.04 M · ~CHF 0.27 (32 credits)

---

## Step 4 — Trophies after a match

### Goal
The end of a match gives the player's fighter its trophies once and saves them before the
result screen opens; Back before the end and Training change nothing (S1, S2, S3, S7).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `MatchArena._store_result_when_over` calls `GameState.award_trophies` and stores the
      reward in `last_result["reward"]` (D5).
- [x] Tests (D9): new `test_match_trophies.gd`; `test_match_arena.gd` still passes.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 22:06

**Done (2026-11-21 · ~3 min · Claude Sonnet 5.5)** — `MatchArena` gives the player's fighter its
trophies once when the match ends (saved before the result screen opens) and stores the reward
in `last_result["reward"]`; tests: victory +10 saved at once, only the chosen fighter, defeat and
time-up 0, a time-up counted as a defeat, the Prestige floor, Back before and during the wait,
Training, a hack. `tools/test.ps1` 334 tests passed, `tools/lint.ps1` OK · suggested: standard
(Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~565 k · ~CHF 0.13 (15 credits)

---

## Step 5 — Result screen trophies and Prestige

### Goal
The result screen shows the trophy change counting up, the new count and the bar to the next
Prestige, and celebrates a new Prestige; it fits every screen size (S4, S5, S12, S13).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `scenes/result_screen.tscn` + `.gd` after D6 (trophy panel, count-up, celebration,
      `finish_count()`, the fighter hidden on short screens).
- [x] Tests (D9): `test_result_screen.gd` / new `test_result_trophies.gd`;
      `test_screen_sizes_match.gd`.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots at 1280×720, 390×844
      and 844×390 of a victory with Blaze at 1240 (+10, "1250 / 2000"), of a defeat (+0) and of
      a win from 1990 ("PRESTIGE 2!" with the badge); the trophy part and both buttons on
      screen.

### Notes
Started: 2026-11-21 22:09

**Done (2026-11-21 · ~5 min · Claude Sonnet 5.5)** — the result screen has a `TrophyPanel`
(change, count, `PrestigeBar` with theme styles, `Celebration` with the badge, a pop and a gold
burst), a 1 s count-up and `finish_count()`; the `ProgressBar` styles are in the theme. Differs
from D6: the content height of a phone on its side is 650 px, not below 520, so `SHORT_HEIGHT`
is 700 px, and short screens also use a smaller heading and buttons so the buttons fit.
Screenshots (9: three cases × 1280×720, 390×844, 844×390, capture script removed) show the
panel and both buttons on screen. `tools/test.ps1` 341 tests passed, `tools/lint.ps1` OK ·
suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~2.58 M · ~CHF 0.44 (52 credits)

---

## Step 6 — MVP flow check

### Goal
F0–F5 work together: hack, fighter choice, match, trophies on the result screen and on home,
and everything back after a reload (S3, S11, S13, S14).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] New `tests/test_mvp_flow.gd` after D10.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; a windowed run: win a match, close
      Godot, open it again — home shows the new total and the chosen fighter (screenshot).

### Notes
Started: 2026-11-21 22:14

**Done (2026-11-21 · ~4 min · Claude Sonnet 5.5)** — `test_mvp_flow.gd` clicks home → **Hack**
(`power22` through the fake `HackServer`) → home → **Fighters** → Blaze → Lava skin → **Select**
→ **Play** (1 bot) → the bot knocked out → the result screen (+10, "1250 / 2000") → **Home**
(total 1755, Prestige badge), then loads a fresh `GameState` from the same file and finds the
trophies, the skin and the hack. Windowed check with two separate Godot processes (win a match
and quit; start again): home shows "Trophies: 1755" and Blaze in Lava with "Prestige 1" on a
screenshot (capture script and test file removed). `tools/test.ps1` 342 tests passed,
`tools/lint.ps1` OK, the player's save file untouched · suggested: standard (Claude Sonnet 5.5)
· ran: Claude Sonnet 5.5 · ~1.46 M · ~CHF 0.23 (28 credits)

---

## Step 7 — Final check, README and architecture

### Goal
Everything that worked before still works, all Godot checks pass, spec 03 S8 (F0–F5 playable
together) is re-checked, and the README and the architecture describe trophies, Prestige and
the saved progress (S10, S13, S14, all statements).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `hack_star_godot/docs/architecture.md`: Game rules (`trophies.gd`, the new `Prestige`
      functions, the trophy settings of `MatchSettings`, `save_data.gd` version 2), Screens
      (the result screen's trophy part and celebration; `MatchArena` gives the trophies),
      UI foundation (`GameState`: `load_saved`, `save`, `award_trophies`, `last_result.reward`),
      *Saved progress* (version 2, the fields, the migration of version 1, no longer
      *planned*; the heading updated), Tests (the new files and the pre-run hook); the line
      "Later specs add their rules here … trophies (specs 08, …)" updated.
- [x] `hack_star_godot/README.md`: trophies and Prestige after a match (+10 for a win, 0 for a
      defeat or time-up, the Prestige floor, the result screen), where the trophy settings
      are (`game/match_settings.gd`), what is saved and where (and how to start fresh: delete
      the save file), and that the MVP (F0–F5) is complete.
- [x] Re-check spec 03 S8: F0–F5 are playable together (`test_mvp_flow.gd` passes; the
      feature list rows F0–F5 are built); write the result into Notes.
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); `git diff --stat` of this spec shows nothing in `server/` or `ui/`.
- [x] Note in Notes that the device play-tests of specs 04–07 and this one (iPad and phone:
      touch, ≥ 30 frames per second, a full match, the trophies after a reload in the same
      browser) and the browser check stay with the author (spec 03, D6, Deferred Items).

### Notes
Started: 2026-11-21 22:17

**Done (2026-11-21 · ~15 min · Claude Haiku 5.5)** — `docs/architecture.md`: the game rules (`trophies.gd`, `Prestige.floor_of`/`next_at`, the trophy settings of `MatchSettings`, `save_data.gd` version 2), the screens (the result screen's trophy part and celebration; `MatchArena` gives the trophies with `award_trophies`), the `GameState` session state (`load_saved`, `save`, `award_trophies`, `last_result.reward`), *Saved progress* (version 2, the fields, the migration of version 1; heading no longer *planned*), the tests (the trophy and save files, `pre_run_hook.gd`) and the "later specs" line. `README.md`: trophies and Prestige (+10 win, 0 defeat or time-up, the Prestige floor, the result screen), where the settings are, what is saved and where (fresh start: delete the save file), and that F0–F5 are complete; "a match changes no trophies" corrected. Spec 03 S8 re-check: `tests/test_mvp_flow.gd` passes (one test: home → hack → fighter → match → result with trophies → home → fresh load of the saved progress), and the feature rows F0–F5 of spec 03 are ✅. Checks: `tools/check_tools.ps1` exit 0 (All pinned tools OK), `tools/test.ps1` exit 0 (342 tests passed), `tools/lint.ps1` exit 0 (gdlint and gdformat OK), `tools/export_web.ps1` exit 0 (web export built). `server/` and `ui/` unchanged. Not done by the AI, stays with the author (Deferred Items): the device play-tests of specs 04–08 (iPad and phone: touch, ≥ 30 frames per second, a full match, the trophies after a reload in the same browser) and the browser check (spec 03, D6). suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · ~2.78 M · ~CHF 0.07 (9 credits)

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Play-test on a real iPad and phone of the whole MVP (specs 04–08: touch, ≥ 30 frames per second, the camera for hack codes, a full match, the trophies kept after a reload) and the browser check of the web export | Needs a person with the devices and a browser (spec 03, D6) | the author, before the MVP pull request |
| Credits, unlocks and power upgrades that change with play (saved with `save()`) | Not part of trophies; the fields are already in the save file (D3) | [09 Unlock and upgrade](../2026_11_12_09_unlock_and_upgrade_spec.md) |
| An upper limit for saved power levels (an edited file can give power 50; `SaveData` checks only ≥ 1) | Code review finding 6 (2026-11-22); power levels change with play only in spec 09 | [09 Unlock and upgrade](../2026_11_12_09_unlock_and_upgrade_spec.md) |
| Progress on another device or browser (accounts) | No login in the MVP (spec 03, S9) | [15 Accounts, fighters and languages](../2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Translations of new text | English only (S12, D8) | [15 Accounts, fighters and languages](../2026_11_13_15_accounts_fighters_and_languages_spec.md) |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-22 | AI assistant (Claude Opus 5.5) | semantic diff | — | [review page](../review/2026-11-21_godot-mvp-08-trophies.html) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | diff | Approve | 0 Blocking · 2 Should-fix · 5 Nit |

### Code review 2026-11-22

Range `bc0147e..a0efdc2` (this spec's commits only). Ran: `tools/test.ps1` (342 of 342 passed),
`tools/lint.ps1` (OK); record checked with `change_record.schema.json` (checks 7 pass · 2 n/a ·
0 fail). Before | After: real screenshots of the result screen from a windowed Godot 4.7.2 run
(temporary capture script, removed) at 1280×720, 390×844 and 844×390, the before side from a
temporary worktree at `bc0147e` (removed); the rules, the end of a match, the save file and a new
game start from a temporary headless probe, the same source on both sides, saving under
`user://review08/` (the player's save file was absent before and after). Good: the rules are pure
and tested without a scene (`Trophies`, `Prestige.floor_of`/`next_at`, clamped settings); the
trophies are given once, when the match ends, and saved before the result screen opens; every
saved field is checked and a damaged file never stops the game; the tests save to their own file
through the pre-run hook; `test_mvp_flow.gd` walks F0–F5 by clicks and reloads the progress;
nothing in `server/` or `ui/` changed.

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | A fighter chosen through the unlock-all hack is lost after a new start: `load_saved` keeps the saved `selected_fighter` only when `unlocked.has(chosen)` (`scenes/autoload/game_state.gd:130`), although the hacks are already loaded (line 120) and `select` accepted it with `is_unlocked`; S11 lists the chosen fighter and the active hacks as kept (record block *progress-restart*, example 3: pixel → blaze). D4 says "known and unlocked"; decide whether a fighter open through the hack counts (simplest: `is_unlocked(chosen)`) and add a test | code | spec | Should-fix | plan decision |
| 2 | A tap-to-skip that does not exist: the `finish_count()` comment (`scenes/result_screen.gd:88`, "the tests, and a player who taps") and `docs/architecture.md:44` ("a tap jumps to the end") promise it, but only tests call `finish_count()` (D6: "(tests)"). Remove the claim from both | architecture | docs | Should-fix | fix now |
| 3 | `docs/architecture.md` wording: line 44 gives the change as ("+10", or "0") — the screen writes "+10 trophies" / "+0 trophies"; line 90 (`trophies.gd`) cites "spec 08, D5" — the rules are D1; line 89 (`match_settings.gd`) says "never negative, the defeat number is never above 0" — `trophies_per_defeat` may be negative (≤ 0) | architecture | docs | Nit | fix now |
| 4 | The pre-run hook (D7) is passed only by `tools/test.ps1` (`-gpre_run_script`); there is no `res://.gutconfig.json`, so GUT started from the editor's GUT panel or `gut_cmdln` without the flag lets the match, select and award tests write the player's `user://hack_star_save.json`. Decide: a `.gutconfig.json` with `pre_run_script`, or a README line "run the tests only with `tools/test.ps1`" | architecture | test | Nit | plan decision |
| 5 | The burst's gold is a copy: `scenes/result_screen.tscn:107` `Burst` `color = Color(1, 0.82, 0.2, 1)`, while D6 says the burst is in `Rarity.LEGENDARY_GOLD` (the one own colour, held by `Rarity`). Set `_burst.color` from `Rarity.LEGENDARY_GOLD` in `result_screen.gd` (the theme's `Bar_fill` cannot reference a constant) | code | guideline | Nit | fix now |
| 6 | Saved power levels have no upper bound: `SaveData._read_progress` (`game/save_data.gd:54`) keeps any whole number ≥ 1, so an edited file gives power 50 although the game's maximum is 11 (22 with the hack). D3 asks only ≥ 1; spec 09 changes power levels with play and owns their limits | code | security | Nit | deferred — [09 Unlock and upgrade](../2026_11_12_09_unlock_and_upgrade_spec.md) |
| 7 | Definition of Done: the *Implementation* line is not ticked although all seven Steps are ✅ Done and Step 7 ran `tools/check_tools.ps1`, `test.ps1`, `lint.ps1` and `export_web.ps1` (exit 0) and updated README and architecture; spec 07 ticked it in its last Step | spec | docs | Nit | fix now |

**Outcome:** Approve — no Blocking finding; findings 2, 3, 5 and 7 to fix now, 1 and 4 need a
plan decision (runner) before `CLOSE:`, 6 is deferred to spec 09.

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked; `tools/test.ps1`, `tools/lint.ps1`, `tools/check_tools.ps1` and `tools/export_web.ps1` pass; `hack_star_godot/README.md` / `docs/architecture.md` updated
- [x] Review · review page written; no Blocking finding open
- [x] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · one pull request for the whole MVP branch at the end (not per spec)
