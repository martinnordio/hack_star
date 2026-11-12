# Unlock and Upgrade Spec

> **Author:** Martin Nordio
> **Status:** ✅ Done
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/unlock-and-upgrade`

---

# Part 1 · Requirements

## Context

Credits and power levels are shown but do nothing: Frosty, Luna and Pixel can only be opened
with a hack, and power 22 is just a number. This spec lets players earn credits in matches,
spend them to unlock fighters and upgrade power levels, and makes power levels change health and
damage in matches — so the hack codes "unlimited credits" and "power 22" really pay off. It is F6
in the [MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Hack codes spec](done/2026_11_12_hack_codes_spec.md) — `INFINITY` (credits shown as ∞),
  `OPENSESAME` (all unlocked), `POWER22` (max power 22); rules in `ui/src/lib/hacks.ts`
  (`credits`, `isUnlocked`, `maxPower`). Its S12 said power 22 only changes what is shown
  "until F6" — this spec is F6.
- [Basic UI spec](done/2026_11_12_basic_ui_spec.md) — credits (500 at start), power levels and
  unlocked fighters in the saved progress (`ui/src/lib/progress.ts`); fighter list and fighter
  screen (`FighterList.svelte`, `FighterDetail.svelte`).
- [First match spec](done/2026_11_12_first_match_spec.md) and
  [trophies spec](done/2026_11_12_trophies_spec.md) — matches, fixed health 3200 and damage
  480 (`game/world.ts`), settings (`game/settings.ts`), rewards after a match
  (`game/trophies.ts`, `Arena.svelte`).
- [docs/architecture.md](../../docs/architecture.md) — where the parts are.

**New:**
- Credit prices for unlocking (by rarity) and upgrading (by level), credits earned in matches,
  power levels that change health and damage.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and the questions to Mattia |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Earn credits:** After a match the player gets credits: 100 for a victory, 20 for a
  defeat or time's up. The result screen shows them (for example "+100 C").
- **S2 — Unlock price:** A locked fighter's screen shows its price by rarity, as in Brawl Stars:
  Rare 160, Super Rare 430, Epic 925, Mythic 1900, Legendary 3800 credits. The fighter list shows
  the price on locked cards.
- **S3 — Unlock:** With enough credits, **Unlock** takes the price from the credits, unlocks the
  fighter with a celebration, and it can be selected. Without enough credits the button is
  disabled and says how many credits are missing.
- **S4 — Upgrade:** An unlocked fighter's screen has **Upgrade** to the next power level for
  20 × the current level credits (level 1 → 2 costs 20, 10 → 11 costs 200). At the maximum
  (11, or 22 with the power-22 hack) the button says "Max power".
- **S5 — Stats:** The fighter screen shows the fighter's health and damage. Each power level
  above 1 adds 10%: power 1 has 3200 health and 480 damage, power 11 has 6400 and 960, power 22
  has 9920 and 1488.
- **S6 — In matches:** The player's fighter plays with the health and damage of its power level;
  bots play at power 5 (a setting).
- **S7 — Unlimited credits:** With the unlimited-credits hack, unlocking and upgrading are free
  and the credits stay ∞ (completes S4 of the hack codes spec).
- **S8 — Power 22:** With the power-22 hack, fighters can be upgraded up to 22 and the higher
  levels count in matches (replaces S12 of the hack codes spec).
- **S9 — Saved:** Credits, unlocked fighters and power levels are saved at once and kept after
  the browser is closed. Resetting hacks brings back the real credits and the 11 limit, but
  fighters unlocked and levels bought while a hack was on are kept (levels above 11 count again
  only with power 22).
- **S10 — Settings:** Credits per result, prices, upgrade cost, the 10% per level and the bots'
  power level are in one place.
- **S11 — Documentation:** README and `docs/architecture.md` describe credits, unlocking,
  upgrades and power.

### Open questions

_None. "How strong should bots be?" is added to the questions to Mattia; until then bots play
at power 5 (S6, S10)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Economy and power rules | ✅ Done | [→ Step 1](#step-1--economy-and-power-rules) |
| **2** | Power and credits in matches | ✅ Done | [→ Step 2](#step-2--power-and-credits-in-matches) |
| **3** | Unlock and upgrade screens | ✅ Done | [→ Step 3](#step-3--unlock-and-upgrade-screens) |
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
| D1 | Prices, upgrade costs, stats and credits per result in `ui/src/lib/game/economy.ts`, numbers in `SETTINGS` | Rules next to the other game rules, testable; S10 |
| D2 | `unlock()` and `upgrade()` are pure functions: progress in → new progress or a reason it is not possible | One place checks credits, limits and hacks; screens only show the result |
| D3 | `World` takes health and damage per fighter; a shot does its shooter's damage | Power levels change matches without special cases |
| D4 | Credits are earned together with trophies when a match ends (same moment as trophies spec D3) | Leaving before the end gives nothing, as for trophies |
| D5 | Spending with the unlimited-credits hack does not change the saved credits | Resetting hacks brings back the real credits (S9) |
| D6 | Prices stay in the UI by rarity, not in the server catalogue | They are a rule of the game (like trophies), not data about a fighter |

---

## Step 1 — Economy and power rules

### Goal
The rules for prices, spending, earning and power stats work and are tested (S1–S5, S7–S10).

### Tasks
- [x] Record the start time in Notes below.
- [x] Settings: credits per win 100 / defeat 20 / time up 20; unlock prices by rarity; upgrade cost per level 20; +10% per level; bot power 5.
- [x] `game/economy.ts`: `unlockPrice(rarity)`, `upgradeCost(level)`, `stats(level)`, `creditsFor(result)`, `unlock(progress, fighter)`, `upgrade(progress, fighterId)`, `earn(progress, credits)`.
- [x] Check: `vitest` — prices per rarity; costs 20 / 200; stats at 1, 11, 22; unlock with enough credits lowers them and unlocks, without enough is refused with the missing amount; already unlocked is refused; upgrade raises the level and costs credits, refused at 11 and allowed to 22 with the hack; with unlimited credits the saved credits do not change.

### Notes
Started: 2026-11-12 11:27

`powerOf(progress, id)` caps a fighter's level at the current maximum, so levels bought above 11 with power 22 count only while that hack is on (S9: resetting brings the normal rules back). `shotDamage` moved into `SETTINGS` next to `fighterHealth`.

**Done (2026-11-12 · ~3m)** — `npm test` 65 passed (8 new), `svelte-check` 0 errors.

---

## Step 2 — Power and credits in matches

### Goal
Matches use power levels for health and damage, and the player earns credits (S1, S6, S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] `World`: health and damage per fighter; hurt uses the shooter's damage.
- [x] `Match`: the player's power level from progress; bots at the bot power setting.
- [x] `Arena.svelte`: save credits with the trophies when the match ends; result screen shows "+100 C".
- [x] Check: `vitest` — a power-11 shooter does 960; a power-11 fighter has 6400 health; match fighters get the right stats. Browser: a win shows +100 C and home credits go up by 100.

### Notes
Started: 2026-11-12 11:28

Training also uses the fighter's power (its damage on the dummies). Damage numbers now show the real damage (for example 768 for Blaze at power 7).

**Done (2026-11-12 · ~4m)** — `npm test` 67 passed; browser: Blaze (power 7) starts with 5120 health, the bot (power 5) with 4480; a win shows "+10 🏆 +100 C", saved credits 600, home shows 600.

---

## Step 3 — Unlock and upgrade screens

### Goal
The player unlocks and upgrades fighters from the fighter screen, and sees prices in the list (S2–S5, S7).

### Tasks
- [x] Record the start time in Notes below.
- [x] Fighter screen: health and damage; **Unlock for N C** (or "Need N more") on locked fighters; **Upgrade to Power n · N C** (or "Max power") on unlocked ones; a short celebration after each.
- [x] Fighter list: price on locked cards.
- [x] Check (browser): with 1000 credits unlock Frosty (925) → 75 left, Frosty selectable; upgrade Blaze 7 → 8 costs 140; Pixel shows "Need …"; with INFINITY unlock Pixel for free, credits stay ∞; with POWER22 upgrade past 11; reset hacks → Pixel stays unlocked (it was bought), credits back to the real amount.

### Notes
Started: 2026-11-12 11:30

S9 reworded while checking: a fighter unlocked for free with unlimited credits stays unlocked after a reset (friendlier for kids, and the same as upgrades: levels stay, only the 11 limit returns). `Celebration.svelte` got a `label` ("UNLOCKED!", "UPGRADED!" besides "HACKED!"). The list shows power capped at the current maximum.

**Done (2026-11-12 · ~6m)** — browser: list shows 🔒 925 / 1900 / 3800 C; Frosty "Unlock · 925 C" → "UNLOCKED!" celebration, 75 left, SELECT; Blaze "Upgrade to Power 8 · 140 C" → 500 → 360, ❤️ 5120 💥 768 → 5440 / 816; Pixel "Need 3440 more C" (disabled); INFINITY → "Unlock · free", saved credits stay 360; POWER22 + INFINITY → Blaze to Power 14/22 (7360 / 1104); reset → Pixel still SELECT, Blaze 11/11 "Max power" (6400 / 960), home 360 C.

---

## Step 4 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains credits and power (S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] Fighter screen (locked and unlocked) and result screen checked at 390×844, 844×390, 1024×768, 1440×900.
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README: earning credits, unlocking, upgrading, power; the hacks' effects.
- [x] `docs/architecture.md`: `game/economy.ts`, stats in matches.
- [x] Info vocabulary: add "Upgrade".
- [x] Questions to Mattia: add "How strong should bots be?".

### Notes
Started: 2026-11-12 11:32

Removed the second "🔒 Locked" button on locked fighters (the unlock button already says what is needed).

**Done (2026-11-12 · ~2m)** — 4 sizes: Blaze "Upgrade to Power 8 · 140 C" and Luna "Need 1400 more C" reachable, no sideways scrolling; `pytest` 15 passed, `npm test` 67 passed, `svelte-check` 0 errors, build ok; README, `docs/architecture.md`, vocabulary (25 words) and questions to Mattia updated; links resolve.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Buying skins | Next feature | Later spec (F7) |
| Coins and Power Points as separate currencies | One currency is easier for kids | Later spec, if wanted |
| Bots matched to the player's trophies or power | Waits for Mattia's answer | Later spec |

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
