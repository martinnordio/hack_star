# First Match Spec

> **Author:** Martin Nordio
> **Status:** ✅ Done
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/first-match`

---

# Part 1 · Requirements

## Context

Hack star can be played: the player runs and shoots in the canyon, but nothing shoots back and
nobody wins. This spec adds the first real match, a "last fighter standing" fight against bots,
like Showdown in Brawl Stars. It is F4 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md). The numbers Mattia
still has to choose (see "Questions to Mattia" in [overall_req.md](../overall_req.md)) are
settings with a default, so his answers change one value each.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Graphics demo spec](done/2026_11_12_graphics_demo_spec.md) — the canyon arena, controls,
  shots, effects, bushes, camera (`ui/src/lib/Arena.svelte`, `ArenaScene.svelte`).
- `ui/src/lib/game/world.ts` — arena rules: movement with wall collisions, shots, target
  dummies, events for effects; `game/arena.ts` — the canyon layout.
- `ui/src/lib/models/` — 3D fighters and skins (`fighters3d.ts`), dummies, particles.
- [Basic UI spec](done/2026_11_12_basic_ui_spec.md) — the home screen with **Play**; the
  selected fighter and skin (`currentFighter()` in `ui/src/lib/hacks.ts`).

**New:**
- Bots, health for every fighter, knock-outs, a timer, a result, and the result screen.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea, planned specs and the questions to Mattia |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Start:** **Play** on the home screen starts a match in the canyon with the player and
  the bots, each at its own start point, after a "3, 2, 1, FIGHT!" countdown during which nobody
  can move or shoot.
- **S2 — Bots:** Each bot is one of the 6 fighters (not the player's), shown with its 3D look.
  Bots walk around, go towards the nearest opponent they can see, and shoot at it when it is in
  range. Bots also fight each other.
- **S3 — Health:** Every fighter has health shown as a bar above it: green for the player, red
  for bots. Each hit takes away health and shows the damage number.
- **S4 — Healing:** A fighter that has not been hit and has not shot for 3 seconds slowly gets
  its health back, as in Brawl Stars.
- **S5 — Knock-out:** A fighter with no health left is knocked out with an effect and leaves the
  arena. The HUD shows how many fighters are still in.
- **S6 — Bushes:** Bots do not see a fighter that stands in a bush unless they are very close.
- **S7 — Timer:** The match has a time limit shown on screen; in the last 10 seconds it turns red.
- **S8 — Result:** The match ends with **Victory** when the player is the last one standing,
  **Defeat** (with the player's place, for example "3rd") when the player is knocked out, or
  **Time's up** (a draw) when the time runs out with bots still in.
- **S9 — Result screen:** The result screen shows the result and the player's fighter, with
  **Play again** and **Home** buttons.
- **S10 — Settings:** Match length (default 2 minutes), number of bots (default 3) and bot
  level (default easy) are set in one place in the code; changing a value changes the next match.
- **S11 — Fair bots:** On "easy", bots react with a delay, miss more often and shoot more slowly
  than the player, so a kid can win most matches.
- **S12 — Training:** The target-dummy arena of the graphics demo stays available from a
  **Training** button on the home screen.
- **S13 — Smooth:** A match with all bots runs at 30 frames per second or more on a recent iPad
  and phone (as S6 of the MVP spec).

### Open questions

_None. The answers Mattia still has to give (match length, number of bots, bot level, time-up
result, bots fighting each other) use the defaults above, set in one place (S10)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Match rules: fighters, health, knock-outs, timer, result | ✅ Done | [→ Step 1](#step-1--match-rules-fighters-health-knock-outs-timer-result) |
| **2** | Bot brains | ✅ Done | [→ Step 2](#step-2--bot-brains) |
| **3** | Match screen | ✅ Done | [→ Step 3](#step-3--match-screen) |
| **4** | Final check and documentation | ✅ Done | [→ Step 4](#step-4--final-check-and-documentation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration>)**`** line to that Step's **Notes**:
>    date, time it took, a one-line summary and the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | `World` gets a list of fighters (the player is fighter 0, bots after it); shots remember who fired them; hits work on fighters and dummies | One set of rules for training and matches; F5+ (trophies, power) build on it |
| D2 | Bot brains in plain TypeScript (`game/bots.ts`), deciding each frame what a bot wants to do (move direction, shoot direction) through the same `move`/`fire` as the player | Bots follow the same rules as the player; testable with `vitest` |
| D3 | A `Match` (`game/match.ts`) wraps a `World`: countdown, timer, knock-out order, result | Keeps match flow separate from arena rules |
| D4 | All match numbers in `game/settings.ts` (`MATCH_SECONDS`, `BOT_COUNT`, `BOT_LEVEL`, `TIME_UP_RESULT`, health, healing); bot levels as a small table | S10: Mattia's answers become one-line changes |
| D5 | Match runs in the browser, like the demo (no server during play) | No lag on Wi-Fi; the result is kept in the browser for F5 |
| D6 | Start points for up to 9 fighters added to the canyon layout | Up to 8 bots possible without layout changes |
| D7 | New `docs/architecture.md` describes the parts of the game and how they fit; README gets "How to play a match" | The user asked that every spec comes with documentation |
| D8 | The address can override match length, bot count and level (`?seconds=30&bots=5&level=hard`), within limits | Try Mattia's answers without changing code; lets browser checks reach every ending quickly |

---

## Step 1 — Match rules: fighters, health, knock-outs, timer, result

### Goal
Fighters with health that shoot each other, heal, get knocked out, and a match with countdown, timer and result (S1, S3–S5, S7, S8, S10).

### Tasks
- [x] Record the start time in Notes below.
- [x] `game/settings.ts` with the defaults of S10 and the bot levels.
- [x] `World`: fighters (id, position, facing, health, knocked out, last hurt/shot time), shots with owner, hits on fighters (not on the shooter), healing after 3 s, knock-out events; training dummies still work.
- [x] Canyon start points for up to 9 fighters.
- [x] `game/match.ts`: countdown (no moving/shooting), timer, knock-out order, result (victory / defeat with place / time's up).
- [x] Check: `vitest` — a shot hurts another fighter but not its shooter; healing starts after 3 s; 0 health knocks out; last standing wins; player out → defeat with place; time up → draw; no moving during countdown; the training tests still pass.

### Notes
Started: 2026-11-12 10:35

The training API (`move`, `fire`, `player`) is kept as shortcuts for fighter 0, so the graphics demo works unchanged. Fighters have 3200 health (7 hits of 480). `World.canSee()` (bush rule) was added here as the bots need it. Place on defeat = bots still in + 1.

**Done (2026-11-12 · ~4m)** — `vitest src/lib/game`: 19 passed (9 new); `svelte-check` 0 errors.

---

## Step 2 — Bot brains

### Goal
Bots wander, chase the nearest visible opponent, shoot when in range, respect bushes, and are fair on "easy" (S2, S6, S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `game/bots.ts`: per-bot state (target, reaction delay, wander point); `think(world, bot, level, dt)` → move and shoot through the world.
- [x] Visibility: a fighter in a bush is seen only within 2.5 units; walls do not block sight (keeps it simple).
- [x] Level table: reaction delay, aim error, shot cool-down multiplier, move speed multiplier.
- [x] Check: `vitest` — a bot moves towards a visible opponent; shoots when in range; does not chase a fighter hidden in a far bush; on easy its shots spread; bots fight each other.

### Notes
Started: 2026-11-12 10:38

While reacting, a bot stops and turns towards the fighter it just noticed (found while testing: wandering during the reaction made shots start from unexpected places; it also reads well on screen as "it saw me"). In a fight a bot closes in when far, backs off when closer than 3, and circles a little. `Match` creates the brains; tests can switch them off (`{ bots: false }`) or fix the random numbers.

**Done (2026-11-12 · ~4m)** — `vitest src/lib/game`: 27 passed (8 bot tests, including a full default match that ends within its time).

---

## Step 3 — Match screen

### Goal
Play starts a match that looks and feels like Brawl Stars, ends with a result screen, and Training keeps the dummy arena (S1–S9, S12).

### Tasks
- [x] Record the start time in Notes below.
- [x] Arena scene draws every fighter (bots as other fighters), with green/red health bars and damage numbers on fighters.
- [x] Knock-out effect (fighter spins, falls apart into a puff) and bot shots in the bot's colour.
- [x] HUD: countdown "3, 2, 1, FIGHT!", timer (red in the last 10 s), fighters left.
- [x] Result screen: Victory / Defeat (place) / Time's up, the player's fighter, **Play again** and **Home**.
- [x] Home: **Play** starts a match; new **Training** button opens the dummy arena.
- [x] Check (browser): countdown blocks moving; bots move and shoot; knocking out all bots shows Victory; being knocked out shows Defeat with place; a short time limit shows Time's up; Play again starts a new match; Training still has dummies.

### Notes
Started: 2026-11-12 10:41

Bots hiding in a bush are invisible (with their shots) unless the player is within 2.5 units, as in Brawl Stars. Damage numbers show for hits the player gives (white) and takes (red). Space / quick tap now aims at the nearest visible bot in a match. Shared `models/healthBar.ts` for dummies and fighters. Added D8 (address overrides) to reach every ending quickly. Browser checks need a visible page: a hidden tab pauses animation frames, so the game loop does not run there.

**Done (2026-11-12 · ~20m)** — browser: during the countdown D does not move the player and "3"/"2" show, then "FIGHT!"; after 6 s of fighting one bot was out (health `1280,0,2720,3200`, 👤 3); `?seconds=5&bots=1` hiding in a bush → TIME'S UP; `?bots=8&level=hard` standing still → DEFEAT "You finished 7th"; `?bots=1` shooting → VICTORY!; Play again → new countdown, full health; Training → dummies `2400,2400,2400`, no HUD. `npm test` 52 passed, `svelte-check` 0 errors.

---

## Step 4 — Final check and documentation

### Goal
Smooth on every screen size; F0–F3 still work; README and architecture documentation describe the game (S13, D7).

### Tasks
- [x] Record the start time in Notes below.
- [x] Browser check at 390×844, 844×390, 1024×768, 1440×900: ≥ 30 FPS with all bots; HUD and buttons visible.
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README: how a match works and its controls; where the settings are.
- [x] `docs/architecture.md`: server, UI screens, game rules (`game/`), 3D models (`models/`), saved progress, settings, how to add a fighter or a hack.

### Notes
Started: 2026-11-12 10:47

The spec kit now makes documentation part of every spec: the requirements stage reads `docs/architecture.md`, the plan stage's last Step always updates README and `docs/architecture.md`, and the spec template links both.

**Done (2026-11-12 · ~3m)** — 4 sizes: 61 FPS while running and shooting with 3 bots; timer, fighters-left and back button inside the screen. `pytest` 15 passed, `npm test` 52 passed, `svelte-check` 0 errors, build ok; all links in README and `docs/architecture.md` resolve.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Trophies and Prestige from match results | Next feature | Later spec (F5) |
| Power levels changing health and damage | Needs unlocking and upgrades | Later spec (F6) |
| Showdown power cubes, closing poison cloud | Keeps the first match simple | Later spec |
| Bots that avoid shots or use walls as cover | "Easy" bots do not need it | Later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted — no git host yet: merged locally into `master`
