# Trophies and Prestige Spec

> **Author:** Martin Nordio
> **Status:** 🟨 In progress
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/trophies`

---

# Part 1 · Requirements

## Context

Matches can be won and lost, but nothing is earned. The kids' favourite part of Brawl Stars is
pushing a fighter's trophies and reaching **Prestige** at 1000 trophies ("if I win, the
fighter gets 10 trophies; at 1000 it gets a diamond with a number"). This spec gives trophies
after each match and celebrates Prestige. It is F5 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md), and with it the
first playable version (F0–F5) is complete.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [First match spec](done/2026_11_12_first_match_spec.md) — matches with a result (victory,
  defeat with place, time's up) and the result screen (`ui/src/lib/Arena.svelte`); match
  settings in `ui/src/lib/game/settings.ts`.
- [Basic UI spec](done/2026_11_12_basic_ui_spec.md) — trophies per fighter in the saved
  progress (`ui/src/lib/progress.ts`), total trophies on home, the Prestige badge
  (`PrestigeBadge.svelte`, `prestigeLevel()` in `fighters.ts`) on home, list and fighter screen.
- [docs/architecture.md](../../docs/architecture.md) — where the parts are.

**New:**
- Trophy rules for each result, saving them, and showing them on the result screen with a
  Prestige celebration.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and the questions to Mattia |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Win:** A victory gives the fighter that played it +10 trophies.
- **S2 — Defeat and time's up:** A defeat or a time's up changes no trophies (default; see S8).
- **S3 — Saved:** The new trophy count is saved at once and shown on home (fighter and total),
  in the fighter list and on the fighter screen, also after the browser is closed.
- **S4 — Result screen:** The result screen shows the trophy change (for example "+10 🏆")
  counting up, the fighter's new trophy count, and a bar to the next Prestige (for example
  "1250 / 2000").
- **S5 — Prestige up:** When a win takes a fighter to 1000, 2000, 3000… trophies, the result
  screen shows a "PRESTIGE 2!" celebration with the diamond badge and its number.
- **S6 — Prestige floor:** A fighter's trophies never drop below the last Prestige it reached
  (only matters if defeats take trophies away, S8).
- **S7 — Only matches count:** Training never changes trophies; leaving a match before it ends
  changes nothing.
- **S8 — Settings:** Trophies for a win (default 10) and for a defeat (default 0) are set in
  one place with the match settings, so Mattia's answer is a one-line change.
- **S9 — Documentation:** README and `docs/architecture.md` describe how trophies and
  Prestige work.

### Open questions

_None. "Should a defeat take trophies?" is one of the questions to Mattia; until then a defeat
takes none (S2, S8)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Trophy rules | ✅ Done | [→ Step 1](#step-1--trophy-rules) |
| **2** | Rewards after a match | ⬜ Not started | [→ Step 2](#step-2--rewards-after-a-match) |
| **3** | Final check and documentation | ⬜ Not started | [→ Step 3](#step-3--final-check-and-documentation) |

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
| D1 | Trophy rules as plain functions in `ui/src/lib/game/trophies.ts`: result → reward (before, after, change, Prestige before/after), and reward → new progress | Testable without the game running; the result screen only shows the reward |
| D2 | `trophiesPerWin`, `trophiesPerDefeat` (0 or negative) and `timeUpTrophies` in `SETTINGS` | S8: one place with the other match settings |
| D3 | The reward is worked out and saved once, when the match ends (in `Arena.svelte`), not when the result screen opens | Leaving during the 1.2 s before the screen still keeps the trophies; leaving before the end gives nothing (S7) |
| D4 | No server change: trophies stay in the browser's saved progress | Same as the rest of the progress (MVP spec D5) |

---

## Step 1 — Trophy rules

### Goal
The rules for trophies and Prestige work and are tested (S1, S2, S5–S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Settings: `trophiesPerWin` 10, `trophiesPerDefeat` 0, `timeUpTrophies` 0.
- [x] `game/trophies.ts`: `rewardFor(trophies, result, settings)` → `{ before, after, change, prestigeBefore, prestigeAfter }` with the Prestige floor; `applyReward(progress, fighterId, reward)`.
- [x] Check: `vitest` — win +10; defeat and time's up 0; 990 + 10 → Prestige 1; with a −20 defeat setting, 1005 → 1000 (floor) and 15 → 0; progress gets the new count for that fighter only.

### Notes
Started: 2026-11-12 11:02

Also `nextPrestigeAt()` for the result screen's progress bar.

**Done (2026-11-12 · ~2m)** — `npm test` 57 passed (5 new), `svelte-check` 0 errors.

---

## Step 2 — Rewards after a match

### Goal
After every match the trophies are saved and the result screen shows them, with a Prestige celebration (S3–S5, S7).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `Arena.svelte`: when a match ends, work out the reward and save it once (match only).
- [ ] Result screen: "+10 🏆" counting up, new count, bar to the next Prestige; "PRESTIGE n!" with the badge when it went up.
- [ ] Check (browser): win with Blaze at 1240 → result shows +10 and 1250 / 2000, home shows 1250 and total +10; set Blaze to 1990 and win → "PRESTIGE 2!"; a defeat shows no change; training changes nothing; leaving a match early changes nothing.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 3 — Final check and documentation

### Goal
Everything still works on every screen size; the documentation explains trophies (S9).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Result screen with reward checked at 390×844, 844×390, 1024×768, 1440×900.
- [ ] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [ ] README: trophies and Prestige, trophy settings.
- [ ] `docs/architecture.md`: `game/trophies.ts` and where rewards are saved.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Trophies by place in a defeat (e.g. 2nd gets +5) | Waits for Mattia's answer on defeats | Later spec |
| Win streaks, Trophy Road rewards | Not needed for the first playable version | Later spec |
| Unlocking fighters with credits; power levels | F6 | Later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
