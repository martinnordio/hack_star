# Overtime and Match Options Spec

> **Author:** Martin Nordio
> **Status:** ✅ Done
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/overtime-and-match-options`

---

# Part 1 · Requirements

## Context

Mattia's feedback ([overall_req.md](../../overall_req.md), "Feedback from Mattia"): matches stay
2 minutes against 3 bots that also fight each other, but the **bot level should be chosen in a
configuration**, and when time runs out with bots still in, **the match goes on for another
minute without walls**. This is F8 in the
[MVP and architecture spec](2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- [First match spec](2026_11_12_first_match_spec.md): `game/match.ts` (countdown, timer,
  results), `game/settings.ts` (`SETTINGS`, `BOT_LEVELS` easy/medium/hard, `?level=` in the
  address for developers), `game/arena.ts` walls, `game/bots.ts`.
- [Trophies spec](2026_11_12_trophies_spec.md) and
  [unlock and upgrade spec](2026_11_12_unlock_and_upgrade_spec.md): rewards for the
  "time's up" result.
- `progress.ts`: saved progress (version 3).

**New:**
- A **Settings** screen for the player (bot level, number of bots), saved on the device.
- **Overtime**: one more minute in which the walls disappear.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../../docs/architecture.md) | How the code is organised |
| [README](../../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Confirmed defaults:** A match lasts 2 minutes, against 3 bots, and bots also fight each
  other (Mattia confirmed; no change).
- **S2 — Settings screen:** A **Settings** button on the home screen opens a screen where the
  player picks the **bot level** (Easy, Medium, Hard) and the **number of bots** (1 to 5). The
  default is Easy and 3 bots.
- **S3 — Settings saved:** The choice is saved on the device at once and used by every match
  (not Training) until changed. Older saved progress keeps working.
- **S4 — Settings shown:** The match countdown shows the chosen level (for example "Hard · 3 bots").
- **S5 — Overtime:** When the 2 minutes end and more than one fighter is still in, the match is
  not over: a big **"OVERTIME!"** banner appears and the timer shows one more minute.
- **S6 — No walls:** At the start of overtime every wall and cactus bush in the arena breaks
  apart with an effect and is gone for the rest of the match, so nobody can hide.
- **S7 — Overtime end:** If only one fighter is left during overtime, the normal result follows
  (victory or defeat). If more than one fighter is still in when overtime ends, the result is a
  **draw** with the "time's up" rewards.
- **S8 — Settings in one place:** The overtime length and the "no walls" rule are settings next
  to the others in `SETTINGS`.
- **S9 — Screen sizes and documentation:** The Settings screen works on desktop, iPad and phone
  in both orientations; README, `docs/architecture.md` and the Info vocabulary ("Overtime") are
  updated.

### Open questions

- **Q1 (Mattia) — answered 2026-11-12:** "Then it is a draw but …" → **it is a draw**. A draw
  after overtime gives the same as "time's up" today (0 trophies, 20 credits).
- **Q2 (Mattia):** Should harder bots give more trophies or credits? Default: no, the same.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Overtime rules | ✅ Done | [→ Step 1](#step-1--overtime-rules) |
| **2** | Overtime in the arena | ✅ Done | [→ Step 2](#step-2--overtime-in-the-arena) |
| **3** | Settings screen | ✅ Done | [→ Step 3](#step-3--settings-screen) |
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
| D1 | `World` keeps its own lists of walls and bushes (copied from the arena); `removeCover()` empties them and emits a `coverGone` event | Collisions, shots, hiding and bots all read the same lists, so "no walls" is one change; the arena stays a constant |
| D2 | `Match` gets an `overtime` flag: when the time runs out with the player and a bot still in, it sets `timeLeft = overtimeSeconds` once; the result after overtime is the existing "time's up" (draw) | Reuses results, trophies and credits unchanged (Q1: it is a draw) |
| D3 | Player options (bot level, number of bots) saved under their own key `hack-star.options` in `lib/options.ts`, not in the progress | They are preferences, not progress: no progress version change or migration; bad data falls back to the defaults |
| D4 | Address overrides (`?level=`, `?bots=`, `?seconds=`) still win over the saved options | Developers keep their quick testing |

---

## Step 1 — Overtime rules

### Goal
The match rules handle overtime and the walls disappearing, tested (S5–S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Settings: `overtimeSeconds` (60), `overtimeRemovesCover` (true).
- [x] `World`: own `walls` / `bushes`, `removeCover()` with a `coverGone` event; collisions, shots and `inBush` use them.
- [x] `Match`: `overtime` flag; time up with more than one fighter in → overtime once; end of overtime → "time's up" draw; `overtimeSeconds` 0 keeps the old behaviour.
- [x] Check: `vitest` — overtime starts at 0:00 with fighters left, timer shows 60 s, walls and bushes gone (a shot passes where a wall was, nobody hides), a win or defeat in overtime is normal, overtime ending is a draw, no overtime when the match is already decided.

### Notes
Started: 2026-11-12 13:13

Overtime only starts while the player is still in: a knocked-out player has already lost (defeat with a place), as before.

**Done (2026-11-12 · ~5m)** — `npm test` 80 passed (5 new: overtime starts and removes cover, draw at its end, victory in overtime, cover kept when set off, shots pass once cover is gone), `svelte-check` 0 errors.

---

## Step 2 — Overtime in the arena

### Goal
Players see overtime: banner, timer and walls breaking (S5, S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] HUD: `overtime` in the HUD data; big "OVERTIME!" banner for 1.5 s; timer in a different colour during overtime.
- [x] Scene: on `coverGone`, walls and cactus bushes burst into pieces and disappear.
- [x] Check (browser, `?seconds=5`): at 0:00 the banner shows, the timer restarts at 1:00, walls and cacti break; the result after overtime is "TIME'S UP".

### Notes
Started: 2026-11-12 13:15

Added `?overtime=<seconds>` to the address overrides (0 turns overtime off) so the end of overtime can be checked quickly. The banner reads "OVERTIME! — No more walls!" and lasts 1.6 s; walls and cacti burst into pieces and sink away in 0.5 s.

**Done (2026-11-12 · ~4m)** — browser `?seconds=5&bots=3`: at 0:00 the banner shows, timer 1:00 on red, walls and cacti burst and are gone (screenshot), fighters keep fighting (4 → 3 left); `?seconds=5&overtime=5`: result "TIME'S UP · 0 🏆 +20 C"; `npm test` 81 passed.

---

## Step 3 — Settings screen

### Goal
Players choose the bot level and the number of bots (S2–S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] `lib/options.ts`: `Options` (`botLevel`, `botCount` 1–5), load/save with fallback, store; `settingsFrom` applies options, then the address.
- [x] Home: **Settings** button (⚙️); `SettingsScreen.svelte` with Easy / Medium / Hard and 1–5 bots.
- [x] Countdown shows "Easy · 3 bots".
- [x] Check: `vitest` (options load/save/fallback, settings order); browser: pick Hard and 5 bots → match has 6 fighters, countdown says "Hard · 5 bots", choice kept after reload.

### Notes
Started: 2026-11-12 13:17

The level chip sits under the timer during the countdown (in the middle it covered the fighter). The bot test "a full match ends" now allows for overtime.

**Done (2026-11-12 · ~3m)** — `npm test` 85 passed (4 new for options), `svelte-check` 0 errors; browser: fresh options Easy · 3; pick Hard and 5 → saved `{"botLevel":"hard","botCount":5}`, kept after reload; match shows "Hard · 5 bots" and 6 fighters.

---

## Step 4 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains overtime and settings (S1, S9).

### Tasks
- [x] Record the start time in Notes below.
- [x] Settings screen and overtime banner checked at 390×844, 844×390, 1024×768, 1440×900.
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README: Settings screen, overtime; `docs/architecture.md`: `options.ts`, overtime in `Match` / `World`; Info vocabulary: "Overtime".

### Notes
Started: 2026-11-12 13:19

Home now has 6 side buttons (2 × 3 in landscape, 3 × 2 in portrait). On a phone held sideways the Settings screen scrolls to reach the bot numbers. Also fixed a broken 💥 in the README.

**Done (2026-11-12 · ~4m)** — browser at the four sizes: home side buttons fit without touching PLAY or the name plate, Settings has no sideways scrolling, the OVERTIME banner fits (390: 76–315 px); `pytest` 15 passed, `npm test` 85 passed, `svelte-check` 0 errors, `npm run build` OK.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| More trophies for harder bots | Waits for Mattia (Q2) | Later spec, if wanted |
| Sound and music settings | No sound yet | Later spec |

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
