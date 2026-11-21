# First Match Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress — Step 1 of 7 done
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-mvp`
> **Issue:** #31
> **Moved from:** [2026_11_12_first_match_spec.md](../../../.specs/features/done/2026_11_12_first_match_spec.md) (#5)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_first_match_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S1, S3, S6, S8, S9, S12, S13 revised; S14 (controls), S15 (English) and S16 (what worked before) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #31 created (no parent) |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 2.48 M (131 k in · 2.32 M cached · 31 k out) | CHF 1.46 (174 credits) | Part 2 written (7 Steps: standard, reasoning, standard, reasoning, standard, standard, light); also the requirements revision and the issue (`usage.ps1 -AgentName s07-lead` from 20:14:28) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 829 k (64 k in · 754 k cached · 12 k out) | CHF 0.30 (35 credits) | Step 1 done (`usage.ps1 -AgentName s07-step1` from 20:14:28) |
---

# Part 1 · Requirements

## Context

Hack star can be played: the player runs and shoots in the canyon, but nothing shoots back and
nobody wins. This spec adds the first real match, a "last fighter standing" fight against bots,
like Showdown in Brawl Stars. It is F4 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md). The numbers Mattia
still has to choose (see "Questions to Mattia" in [overall_req.md](../../../.specs/overall_req.md)) are
settings with a default, so his answers change one value each.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_first_match_spec.md) (#5)
  — its numbers (fighters 3200 health = 7 hits of 480, healing 13 % of full health per second
  after 3 s, a fighter in a bush seen only within 2.5 m, the bot levels easy / medium / hard)
  and its flow (countdown, timer, knock-out order, place = fighters still in + 1) are the model.
- [Graphics demo spec](done/2026_11_12_06_graphics_demo_spec.md) — the canyon arena, controls,
  shots, effects, bushes, camera, target dummies, fighters and skins in 3D.
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — the home screen with **Play**; the
  selected fighter and skin; the UI foundation of the Godot game (S12).
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) — the hacks change nothing in the
  arena (its S12).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  technology, the architecture document `hack_star_godot/docs/architecture.md` and how to run
  the game (S12–S14); S6 (30 frames per second) and D6 (the device play-test stays with the
  author).
- Checked 2026-11-21 (S0) in the code: **Play** on home (`scenes/home.gd`, `Screens.ARENA`)
  opens `scenes/arena.tscn` (`arena.gd`), the spec 06 demo: the canyon built from
  `ArenaLayout` (20 × 26 m, walls, rocks, four cactus patches, one start point `START`), one
  `Fighter` (the selected fighter and skin, `FighterModel` with idle, run and attack
  animations, see-through in a bush), three `TargetDummy`s (2400 health, a green/yellow/red
  health bar, damage numbers, break apart and come back after 5 s), `Shot`s (ray casts against
  the world and targets layers; a hit calls `hit(Combat.DAMAGE)` on what it hits), the
  `ArenaEffects` pools (dust, flash, sparks), a following camera and the HUD (**Back**, the left
  joystick, the right `AimJoystick`, the FPS label). The rules are pure: `Combat` (480 damage,
  0.35 s cool-down, 9 m range, `nearest_target`, `release_aim`), `ArenaLayout`, `Movement`.
  Fighters have no health, nothing hits a fighter, there are no bots, no timer and no result.
  Home has **Play**, **Fighters**, **Info** and **Hack**; there is no **Training** button. The
  Godot game has no languages yet (English, spec 15).

**New:**
- Bots, health for every fighter, healing, knock-outs, a countdown, a timer, a result, the
  result screen, and **Training** on the home screen for the dummy arena.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea, planned specs and the questions to Mattia |
| [README](../../README.md) (Godot game) | How to install, run and play the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–06) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. — checked 2026-11-21: S2, S4, S5, S7, S10,
  S11 fit; S1, S3, S6, S8, S9, S12, S13 revised (the arena of spec 06 is extended, the dummy
  arena moves to **Training**, "very close" gets a number, the place is defined, the device
  play-test stays with the author); S14 (controls), S15 (English) and S16 (what worked before)
  added; no open questions.
- **S1 — Start:** **Play** on the home screen starts a match in the canyon of spec 06 (without
  the target dummies) with the player and the bots, each at its own start point, after a
  "3, 2, 1, FIGHT!" countdown during which nobody can move or shoot. _(revised 2026-11-21: in
  the Godot game **Play** opens the dummy arena of spec 06; the match uses the same canyon, the
  dummies move to Training, S12.)_
- **S2 — Bots:** Each bot is one of the 6 fighters (not the player's), shown with its 3D look.
  Bots walk around, go towards the nearest opponent they can see, and shoot at it when it is in
  range. Bots also fight each other.
- **S3 — Health:** Every fighter in a match has health shown as a bar above it: green for the
  player, red for bots. Each hit takes away health and shows the damage number. _(revised
  2026-11-21: "in a match" — the Training arena stays as in spec 06, S12; the dummies keep
  their green/yellow/red bar.)_
- **S4 — Healing:** A fighter that has not been hit and has not shot for 3 seconds slowly gets
  its health back, as in Brawl Stars.
- **S5 — Knock-out:** A fighter with no health left is knocked out with an effect and leaves the
  arena. The HUD shows how many fighters are still in.
- **S6 — Bushes:** Bots do not see a fighter that stands in a bush unless they are within
  2.5 m of it. A bot in a bush is partly transparent, like the player (spec 06, S6). _(revised
  2026-11-21: "very close" given the original game's number; the see-through of spec 06 holds
  for every fighter.)_
- **S7 — Timer:** The match has a time limit shown on screen; in the last 10 seconds it turns red.
- **S8 — Result:** The match ends with **Victory** when the player is the last one standing,
  **Defeat** (with the player's place, for example "3rd": the number of fighters still in when
  the player is knocked out, plus 1) when the player is knocked out, or **Time's up** (a draw)
  when the time runs out with bots still in. _(revised 2026-11-21: the place is defined so it
  can be tested.)_
- **S9 — Result screen:** The result screen shows the result and the player's fighter and skin
  in 3D, with **Play again** (starts a new match) and **Home** buttons. _(revised 2026-11-21:
  what the two buttons do named; the fighter in 3D as on home, spec 04.)_
- **S10 — Settings:** Match length (default 2 minutes), number of bots (default 3) and bot
  level (default easy) are set in one place in the code; changing a value changes the next match.
- **S11 — Fair bots:** On "easy", bots react with a delay, miss more often and shoot more slowly
  than the player, so a kid can win most matches.
- **S12 — Training:** The target-dummy arena of the graphics demo (spec 06) stays available,
  unchanged, from a new **Training** button on the home screen. _(revised 2026-11-21: in the
  Godot game the dummy arena is what **Play** opens today; home gets the button next to
  **Fighters**, **Info** and **Hack**.)_
- **S13 — Smooth:** A match with all bots runs at 30 frames per second or more on a recent iPad
  and phone (spec 03, S6); the device play-test stays with the author (spec 03, D6). _(revised
  2026-11-21: the Godot MVP spec is spec 03; who checks it on the devices named.)_
- **S14 — Controls:** In a match the player moves and shoots with the controls of spec 06 (S3,
  S4: keys and left stick; mouse and click, right stick and tap), and a quick tap on the right
  stick fires at the nearest bot in range. _(added 2026-11-21: the controls exist since spec 06;
  "the nearest target" of a tap becomes a bot in a match.)_
- **S15 — Language:** All new text (countdown, timer, fighters left, the results, the buttons)
  is in English; translations come with
  [spec 15](2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-21: the
  Godot game has no languages yet, `docs/architecture.md`.)_
- **S16 — What worked before:** Home, the fighter list, the fighter screen, the info page, the
  hack screen and the QR page work as before; **Back** in a match goes home at any time without
  a result; a match changes no trophies, credits or unlocks (trophies come with
  [spec 08](2026_11_12_08_trophies_spec.md)), and the hacks change nothing in a match (spec 05,
  S12). _(added 2026-11-21: the match is shared with the screens of specs 01–06.)_

### Open questions

_None. The answers Mattia still has to give (match length, number of bots, bot level, time-up
result, bots fighting each other) use the defaults above, set in one place (S10). The S0 check
2026-11-21 raised no new question: the revisions take the spec's own suggestions and the
original game's numbers (2.5 m in a bush, the place)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Match rules and settings | standard (Claude Sonnet 5.5) — pure rules and their tests, numbers fixed by D2–D4 | ✅ Done | [→ Step 1](#step-1--match-rules-and-settings) |
| **2** | Bot brain | reasoning (Claude Opus 5.5) — tricky logic: sight and bushes, targets, reaction, aim error, chasing, wandering, all testable without a scene (D5) | ⬜ Not started | [→ Step 2](#step-2--bot-brain) |
| **3** | Fighters that can be hit | standard (Claude Sonnet 5.5) — health, bar, damage number, healing and knock-out on the existing `Fighter`, a small extraction from `TargetDummy` (D6, D7) | ⬜ Not started | [→ Step 3](#step-3--fighters-that-can-be-hit) |
| **4** | Match arena with bots | reasoning (Claude Opus 5.5) — a new scene inheriting the arena, start points, bots driven by their brains, countdown lock, tap on bots, the end of the match (D1, D8) | ⬜ Not started | [→ Step 4](#step-4--match-arena-with-bots) |
| **5** | Match HUD | standard (Claude Sonnet 5.5) — three labels fed by `Match`, checked on screenshots (D9) | ⬜ Not started | [→ Step 5](#step-5--match-hud) |
| **6** | Result screen and Training on home | standard (Claude Sonnet 5.5) — one new screen from the UI foundation and one button (D10, D11) | ⬜ Not started | [→ Step 6](#step-6--result-screen-and-training-on-home) |
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
> changes, and a match calls no server (D12). `gdlint` allows at most 20 public tests per
> file: new tests go into new files where a file is full (e.g. `test_screen_sizes.gd` has 16).
> **Looks are checked on real screenshots:** a windowed Godot run with a temporary capture
> script (saved under `%TEMP%`, viewed, then removed, never committed), at 1280×720 and
> 390×844 unless the Step says otherwise.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **The match is the arena of spec 06 plus a match layer, Training is the arena as it is:** `arena.gd` gets `class_name Arena` and `@export var training: bool = true` (only then are the three dummies placed). A new scene `scenes/match.tscn` **inherits** `arena.tscn` (same canyon, player, camera, sticks, Back, FPS label) with `training = false` and the script `scenes/match_arena.gd` (`MatchArena extends Arena`), which adds the bots, the `Match` and the match HUD. `Screens` gets `MATCH` (`match.tscn`) and `RESULT` (D10); `Screens.ARENA` stays `arena.tscn`, now the Training arena. | S1, S12, S16: Training stays exactly the demo, with its tests; the match reuses the canyon, the controls and the camera instead of copying them. |
| D2 | **Settings in one place:** `game/match_settings.gd` (`MatchSettings`, a `RefCounted` whose fields default to its constants): `match_seconds` 120, `bot_count` 3 (1–8, clamped), `bot_level` `"easy"`, `time_up_result` `"draw"`, `bots_fight_each_other` true, `countdown_seconds` 3, `fighter_health` 3200 (7 hits of 480), `heal_delay` 3.0 s, `heal_per_second` 0.13 (share of full health), `bush_sight` 2.5 m, and `LEVELS` — easy `{reaction 0.6 s, aim_error 0.35 rad, cooldown ×2.4, speed ×0.75, sight 8 m}`, medium `{0.35, 0.2, ×1.6, ×0.9, 10}`, hard `{0.15, 0.08, ×1.15, ×1.0, 12}` (`level(name)`; an unknown name gives easy). `GameState.match_settings` (session only, not saved) holds the instance the next match reads at its start. | S10, S11: Mattia's answers are one-line changes of the constants; the original game's numbers; tests and spec 11 (match options) change the instance without touching code. |
| D3 | **Fighter health in `Combat`:** `health_ratio(health, max_health = DUMMY_HEALTH)`, `can_fire(now, last_fire, cooldown = COOLDOWN)` (bots pass `COOLDOWN × level.cooldown`) and `heal(health, max_health, quiet_seconds, delta, delay, per_second)` (no healing before `delay`, never above `max_health`). The dummy calls stay as they are. | S3, S4, S11: one set of combat rules for dummies and fighters, still pure and tested. |
| D4 | **The match flow is pure:** `game/match.gd` (`Match`, a `RefCounted` with state, no scene): `Match.new(settings, fighter_count)` (fighter 0 is the player); `advance(delta)`; `phase` `COUNTDOWN` → `FIGHT` → `OVER`; `countdown_text()` (`"3"`, `"2"`, `"1"`, then `"FIGHT!"` for 0.7 s after the countdown, else `""`); `can_act()` (only in `FIGHT`); `seconds_left()`, `timer_text()` (`"1:59"`) and `timer_red()` (last 10 s); `knock_out(index)` (records the order, ends the match on the player or on the last bot); `fighters_left()`; `result` (`VICTORY`, `DEFEAT`, `TIME_UP`) and `place` (fighters left + 1 at the player's knock-out, 1 for a victory); `ordinal(n)` (`"1st"`, `"2nd"`, `"3rd"`, `"4th"`, …). With `time_up_result` `"defeat"` the time-up ends as a defeat with the place. | S1, S5, S7, S8, S10: the rules testable without a scene (architecture, *Game rules*); the original game's `Match`. |
| D5 | **Bot brains are pure:** `game/bot_brain.gd` (`BotBrain`, one instance per bot, with a `RandomNumberGenerator` that tests seed): `can_see(from, at, in_bush, sight, bush_sight)` (within `sight`, and within `bush_sight` when the other stands in a bush; walls do not block sight, as in the original game); `think(now, me, opponents, level) -> {move, aim}` where `opponents` are `{at, in_bush}` of the live fighters it may attack (the player and, with `bots_fight_each_other`, the other bots): picks the nearest visible one; a new target first waits `level.reaction` (stands still, no shot); then closes in when farther than 0.65 × `SHOT_RANGE`, backs off when closer than 3 m, else sidesteps a little; `aim` is the direction to the target turned by a random angle within ±`aim_error` when the target is within `SHOT_RANGE`, else `Combat.NO_SHOT`; with nobody seen it wanders to a random free point of `ArenaLayout` (`is_free`) and picks a new one when reached, after 4 s, or when it made no progress for 1 s (stuck at a rock). | S2, S6, S11: bots follow the same rules as the player; every choice testable with fixed random numbers. |
| D6 | **Fighters can be hit:** `Fighter` gets `max_health`, `health`, `knocked_out`, `last_action_seconds` (last hit or shot), signals `hurt(amount)` and `knocked_out_now`, `hit(amount)` (ignored when knocked out), `heal_step(now, delta)` (calls `Combat.heal`) and `knock_out()`. Shots: `COLLISION_MASK` becomes world + fighter + targets; `Shot.launch` takes the shooter, whose RID is excluded from every ray, so a fighter never hits itself. Fighters still do not block each other (their mask stays world + targets). `Arena.fire(direction)` becomes `fire_from(fighter, direction, cooldown)` with a cool-down per fighter; `fire(direction)` stays for the player. | S3, S4, S5: the existing `hit` contract of `Shot` reaches fighters; no change for dummies or Training. |
| D7 | **Health bar and damage number are shared parts:** the bar and the rising number of `TargetDummy` move into `scenes/health_bar.gd` (`HealthBar`, billboard quads; `fixed_color` or, when unset, `Combat.health_color`) and `scenes/damage_number.gd` (`DamageNumber.spawn(parent, at, amount, color)`); the dummy uses them unchanged in look. In a match the player's bar is green (`Combat.COLOR_GREEN`) and the bots' red (`Combat.COLOR_RED`); damage numbers are white for hits on bots and red for hits on the player. Knock-out: `ArenaEffects` gets a `KNOCKOUT` pool (a bigger puff of the fighter's colour, 3 nodes); the fighter spins and shrinks for 0.5 s, then is hidden, its collision off, and it stays out of the match. In Training the player shows no bar. | S3, S5, S12: one bar and one number for dummies and fighters; Training looks as before. |
| D8 | **The match arena** (`MatchArena`): `ArenaLayout.STARTS` — 9 start points (the first is `START`, the player's; the others spread over the canyon, free of walls and bushes, at least 4 m apart); one `Fighter` per bot at the next start point, the bots' fighters taken in order from a shuffle of `Fighters.ids()` without the player's (repeated when there are more than 5 bots), Default skin; each bot has a `BotBrain` and its speed × `level.speed`. Every physics frame while `Match.can_act()`: the player's input as in `Arena`; each live bot gets `think(...)`, its `input_direction` and, when `aim` is a shot, `fire_from(bot, aim, COOLDOWN × level.cooldown)`; every live fighter heals (`heal_step`) and is see-through in a bush (spec 06, D11). Before `FIGHT` and after `OVER` nobody moves or fires (mouse, sticks and keys ignored). A tap on the right stick fires at the nearest live bot in range (`Combat.nearest_target`), else straight ahead. When the match is `OVER`, the arena waits 1.5 s (the knock-out is seen) and goes to the result screen. The random numbers come from one `RandomNumberGenerator` per match that tests can seed. | S1, S2, S6, S11, S14: the original game's flow; deterministic tests. |
| D9 | **Match HUD** in `match.tscn`, under `Hud/MatchHud` (anchors, theme styles, no own colours except the timer's red `Combat.COLOR_RED`): `CountdownLabel` (centre, `HeadingLabel`, shows `Match.countdown_text()`), `TimerLabel` (top-centre, `Match.timer_text()`, red when `timer_red()`), `FightersLeftLabel` (top-right under the FPS label, "Fighters left: 4"). | S1, S5, S7, S15: the UI foundation of spec 04; fits the five screen sizes. |
| D10 | **Result screen:** `scenes/result_screen.tscn` + `.gd` (`Screens.RESULT`, the UI foundation of spec 04): a heading "Victory!", "Defeat" or "Time's up!", a line under it ("You are the last one standing!", "You finished 3rd", "It's a draw"), the player's fighter and skin in a `FighterStage`, **Play again** (`BigButton`, `Screens.MATCH`) and **Home** (`Screens.go_home()`); wide screens put the fighter left, tall screens use one column (like home). It reads `GameState.last_result` (`{outcome, place, fighter, skin}`, session only, not saved), set by `MatchArena` at the end; with no result it goes home. No Back button: **Home** is the way back. | S8, S9, S16: one more screen built like the others; spec 08 will read `last_result` for trophies. |
| D11 | **Training on home:** a **Training** button in `MoreRow` next to **Fighters**, **Info** and **Hack** opens `Screens.ARENA`; **Play** opens `Screens.MATCH`. | S1, S12: the original game's buttons; the home layout of spec 04 keeps working (`MoreRow` is an `HFlowContainer`). |
| D12 | **No server, nothing saved, English:** a match runs in the game only; `last_result` and `match_settings` are session state; every new text is English (spec 15 translates); the hacks are not read by the match. The address overrides of the original game (`?seconds=…&bots=…&level=…`) are not built: tests set `GameState.match_settings`. | S15, S16; the original game's D5; the simplest way to try Mattia's answers in tests (Deferred Items). |
| D13 | **Tests:** `test_match_settings.gd`, `test_match.gd`, `test_bot_brain.gd` (pure); `test_combat.gd` (fighter health, healing, cool-down factor); `test_fighter_health.gd` (hit, bar, number, healing, knock-out, a shot never hits its shooter, a bot's shot hits the player); `test_target_dummy.gd` and the Training tests of spec 06 unchanged in meaning; `test_match_arena.gd` (start points, bots, countdown lock, bots move and shoot, tap on a bot, victory, defeat with place, time up, Back); `test_match_hud.gd`; `test_result_screen.gd`; `test_home.gd` (Play → match, Training → arena); `test_screen_sizes_match.gd` (match HUD and result screen at the five sizes, buttons with mouse and touch). Short matches through `GameState.match_settings` (e.g. 3 s, 1 bot). | Every statement checked by a test or a screenshot; the device play-test stays with the author (spec 03, D6). |

---

## Step 1 — Match rules and settings

### Goal
The settings, fighter health, healing and the match flow (countdown, timer, knock-outs, result,
place) exist and are tested without a scene (S1, S3, S4, S5, S7, S8, S10).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/match_settings.gd` (`MatchSettings`) after D2; `GameState.match_settings` (a new
      `MatchSettings` at every game start and in `reset()`), not saved.
- [x] `Combat` after D3 (`health_ratio` with `max_health`, `can_fire` with `cooldown`, `heal`).
- [x] `game/match.gd` (`Match`) after D4.
- [x] Tests: `tests/test_match_settings.gd` (defaults; `bot_count` clamped to 1–8; easy reacts
      later, aims worse, fires slower and walks slower than hard; an unknown level gives easy);
      `tests/test_combat.gd` (fighter health ratio; no healing before 3 s; 13 % per second
      after; never above full; cool-down × 2.4); `tests/test_match.gd` (countdown texts "3",
      "2", "1", "FIGHT!"; `can_act` false during the countdown; timer text and red in the last
      10 s; knocking out all bots → Victory, place 1; the player out with 2 bots left →
      Defeat, place 3 and "3rd"; time up with bots left → Time's up, or Defeat with
      `time_up_result` "defeat"; `fighters_left`; `ordinal` 1–4, 11, 12, 13, 21, 22).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 20:22

**Done (2026-11-21 · ~6 min · Claude Sonnet 5.5)** — `MatchSettings`, `GameState.match_settings`,
`Combat` health/heal/cool-down and `Match` with tests (`test_match_settings.gd`, `test_match.gd`,
4 new tests in `test_combat.gd`). `tools/test.ps1` 247 tests pass, `tools/lint.ps1` exit 0.
suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 829 k · CHF 0.30

---

## Step 2 — Bot brain

### Goal
A bot decides where to walk and where to shoot: it sees opponents (not in a far bush), reacts
after a delay, chases and fights the nearest one, misses more on easy and wanders when it sees
nobody (S2, S6, S11).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `game/bot_brain.gd` (`BotBrain`) after D5.
- [ ] Tests: `tests/test_bot_brain.gd` (with a seeded generator): `can_see` in and out of
      sight, a fighter in a bush seen at 2 m but not at 3 m; no shot during the reaction time,
      then a shot; moves towards a visible opponent far away, backs off when closer than 3 m;
      does not chase a fighter hidden in a far bush (wanders instead); picks the nearest of two
      opponents (a bot and the player, so bots fight each other); on easy the aim spreads up to
      0.35 rad, on hard up to 0.08 rad; no aim beyond `SHOT_RANGE`; a new wander point after
      it is reached or after 1 s without progress; every wander point is free
      (`ArenaLayout.is_free`).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 3 — Fighters that can be hit

### Goal
A fighter has health with a bar, takes damage from shots with a damage number, heals after 3 s,
and is knocked out with an effect; a shot never hits its shooter; Training looks as before (S3,
S4, S5, S12).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `scenes/health_bar.gd` (`HealthBar`) and `scenes/damage_number.gd` (`DamageNumber`)
      after D7, taken out of `TargetDummy`, which uses them (same look, its tests unchanged).
- [ ] `Fighter` after D6 (health, `hit`, signals, `heal_step`, `knock_out` with the spin and
      shrink of D7); `ArenaEffects` gets the `KNOCKOUT` pool.
- [ ] `Shot` after D6 (fighter layer in the mask, the shooter excluded); `Arena.fire_from`
      with a cool-down per fighter; `fire(direction)` unchanged for the player.
- [ ] Tests: `tests/test_fighter_health.gd` (a hit lowers health and shows a number; the bar's
      fill follows the health; healing starts after 3 s quiet and stops at full; a shot resets
      the quiet time; 0 health → knocked out, hidden after the effect, collision off, further
      hits ignored; a shot from fighter A hits fighter B; a shot never hits its own shooter,
      also point-blank); `tests/test_target_dummy.gd`, `test_arena*.gd` still pass.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of the Training arena
      (dummy bar and damage number look as before) and of a temporary scene with two fighters
      (green and red bars, a red damage number, the knock-out puff).

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 4 — Match arena with bots

### Goal
`match.tscn` starts a match: the player and the bots at their start points, nobody moves during
the countdown, then the bots walk, chase, shoot and fight each other, every fighter heals and can
be knocked out, a tap fires at the nearest bot, and the match ends (S1, S2, S3, S5, S6, S8, S11,
S14).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `ArenaLayout.STARTS` (9 points, D8); `Arena` after D1 (`class_name Arena`, `training`).
- [ ] `scenes/match.tscn` (inherits `arena.tscn`) and `scenes/match_arena.gd` (`MatchArena`)
      after D8; `Screens.MATCH`. Until Step 6 the end of the match goes home (the result is
      already stored in `GameState.last_result`, D10).
- [ ] Tests: `tests/test_arena_layout.gd` (9 start points, free, not in a bush, ≥ 4 m apart);
      `tests/test_match_arena.gd` (with `GameState.match_settings` and a seeded generator:
      3 bots by default, none is the player's fighter, each at its own start point, no
      dummies; during the countdown keys and a mouse click neither move nor fire, and the bots
      stand still; after the countdown a bot moves and fires at the player in range; with 1 bot
      that the player knocks out → Victory in `last_result`; the player knocked out with 2 bots
      left → Defeat, place 3; with 3 s and the player in a far bush → Time's up; a tap on the
      aim stick fires at the nearest bot; a bot in a bush is see-through; Back goes home without
      a result); `test_arena.gd` (Training still has 3 dummies and no bots).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots at 1280×720 and 390×844
      during a fight: bots with their own 3D look, shots in their colours, bars above every
      fighter; the FPS label of a windowed desktop run with 3 bots is noted.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 5 — Match HUD

### Goal
The match shows the "3, 2, 1, FIGHT!" countdown, the timer (red in the last 10 s) and how many
fighters are still in, on every screen size (S1, S5, S7, S15).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `Hud/MatchHud` in `match.tscn` after D9, updated by `MatchArena` from `Match`.
- [ ] Tests: `tests/test_match_hud.gd` (the countdown label shows "3" at the start and
      "FIGHT!" right after the countdown, then nothing; the timer shows "2:00" then counts
      down and is red in the last 10 s; "Fighters left: 4" becomes 3 after a knock-out);
      `tests/test_screen_sizes_match.gd` (countdown, timer, fighters left, Back and both sticks
      inside at the five sizes, no overlap with Back or the FPS label).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots at 1280×720, 390×844
      and 844×390 of the countdown and of the red timer.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 6 — Result screen and Training on home

### Goal
The match ends on a result screen with Victory, Defeat with the place or Time's up, the
player's fighter, **Play again** and **Home**; **Play** starts a match and **Training** opens the
dummy arena (S1, S8, S9, S12, S15, S16).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `scenes/result_screen.tscn` + `.gd` after D10; `Screens.RESULT`; `MatchArena` goes there
      at the end of a match.
- [ ] Home after D11 (**Play** → match, **Training** → arena).
- [ ] Tests: `tests/test_result_screen.gd` (each of the three results shows its heading and
      line, "You finished 3rd"; the player's fighter and skin in the stage; **Play again**
      opens the match; **Home** goes home; no result → home); `tests/test_home.gd` (Play opens
      the match, Training opens the arena; trophies and credits unchanged after a match);
      `tests/test_screen_sizes_match.gd` (the result screen fits the five sizes; **Play
      again**, **Home** and **Training** react to a mouse click and a touch); the spec 04–06
      screen tests still pass.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of home (with
      **Training**) and of the three results at 1280×720 and 390×844.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 7 — Final check, README and architecture

### Goal
Everything that worked before still works, all Godot checks pass, and the README and the
architecture describe the match (S13, S16, all statements).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/docs/architecture.md`: Layout and Screens (`match.tscn` /
      `MatchArena`, the match HUD, the result screen, **Training** on home, `Screens.MATCH`
      and `RESULT`, `HealthBar`, `DamageNumber`, the fighter's health), Game rules
      (`MatchSettings`, `Match`, `BotBrain`, the new `Combat` functions, `ArenaLayout.STARTS`),
      UI foundation (`GameState.match_settings` and `last_result`), Physics layers (shots hit
      fighters, the shooter excluded), Tests (the new test files).
- [ ] `hack_star_godot/README.md`: how to play a match (Play, countdown, bots, health and
      healing, bushes, timer, results, Play again) and Training, and where the match settings
      are (`game/match_settings.gd`).
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); `git diff --stat` of this spec shows nothing in `server/` or `ui/`.
- [ ] Note in Notes that the device play-test (iPad and phone: a full match with 3 bots at
      ≥ 30 frames per second, both sticks) and the browser check stay with the author (spec 03,
      D6, Deferred Items).

### Notes
_Add the `Done` line here when the Step is finished._

<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Play-test on a real iPad and phone (a full match with 3 bots at ≥ 30 frames per second, both sticks) and the browser check of the web export | Needs a person with the devices and a browser (spec 03, D6) | the author, before spec 08 is closed |
| Trophies and credits for a result | Not part of the first match (S16) | [08 Trophies](2026_11_12_08_trophies_spec.md) |
| Overtime and choosing match length, bot count and level in the game; address overrides of the settings (`?seconds=…`) | The defaults are set in code (S10, D12) | [11 Overtime and match options](2026_11_12_11_overtime_and_match_options_spec.md) |
| Bot Supers and Hypercharge | Not part of the first match | [12 Super and hypercharge](2026_11_12_12_super_and_hypercharge_spec.md) |
| Translations of new text | English only (S15, D12) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |

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
