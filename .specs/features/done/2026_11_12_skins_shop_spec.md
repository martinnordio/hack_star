# Skins Shop Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ✅ Done
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/skins-shop`
> **Issue:** [#8](https://github.com/martinnordio/hack_star/issues/8)

---

# Part 1 · Requirements

## Context

Kids love skins, especially Legendary ones ("something like a costume"), and in Brawl Stars they
are bought, which makes them special. In Hack star every skin is free to pick today. This spec
adds a **Shop** where skins are bought with credits, with a "skin of the day" on offer, and makes
the "unlock everything" hack really unlock every skin. It is F7 in the
[MVP and architecture spec](2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Basic UI spec](2026_11_12_basic_ui_spec.md) — 14 skins (6 Default, 2 Epic, 2 Mythic,
  4 Legendary) in the server catalogue (`fighters.py`), 3D skins (`models/fighters3d.ts`),
  portraits (`portraits.ts`), skin choice on the fighter screen (`FighterDetail.svelte`),
  `selectedSkins` in the saved progress (`progress.ts`).
- [Hack codes spec](2026_11_12_hack_codes_spec.md) — `OPENSESAME` "unlocks every fighter
  and every skin" (S5), `INFINITY` unlimited credits; `hacks.ts`.
- [Unlock and upgrade spec](2026_11_12_unlock_and_upgrade_spec.md) — credits earned in
  matches, purchases as pure functions (`game/economy.ts`), "UNLOCKED!" celebrations.
- [docs/architecture.md](../../../docs/architecture.md) — where the parts are.

**New:**
- Owned skins in the saved progress, skin prices, the Shop screen, the skin of the day.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../overall_req.md) | Overall game idea and the questions to Mattia |
| [architecture.md](../../../docs/architecture.md) | How the code is organised |
| [README](../../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Owned skins:** Every fighter's Default skin is owned; other skins must be bought.
  Skins a player had already chosen before this spec stay owned.
- **S2 — Prices:** Epic 300, Mythic 600, Legendary 1500 credits.
- **S3 — Shop:** A **Shop** button on the home screen opens a screen with every non-default skin:
  picture, skin and fighter name, rarity, and its price or "Owned". Legendary skins glow.
- **S4 — Buy:** **Buy** takes the price from the credits, makes the skin owned with an "NEW SKIN!"
  celebration, and offers to wear it. Without enough credits the button is disabled and says how
  many credits are missing.
- **S5 — Fighter first:** A skin for a locked fighter shows "Unlock <fighter> first" and cannot be
  bought.
- **S6 — Skin of the day:** One skin the player does not own is "Skin of the day" at 30% off,
  shown first in the Shop; it changes every day and is the same all day.
- **S7 — Fighter screen:** Skins not owned show a lock and their price; tapping one still shows
  it on the 3D fighter ("try on"), but **Select** is replaced by **Buy · N C**.
- **S8 — Hacks:** With "unlock everything" every skin is owned; with unlimited credits buying is
  free and the saved credits do not change. Resetting hacks keeps skins bought while a hack was
  on (as for fighters, unlock and upgrade spec S9).
- **S9 — Saved:** Owned skins are saved at once and kept after the browser is closed; progress
  saved before this spec is kept (not reset).
- **S10 — Settings:** Skin prices and the skin-of-the-day discount are in one place.
- **S11 — Documentation:** README, `docs/architecture.md` and the Info vocabulary ("Shop",
  "Skin of the day") are updated.

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Owned skins and shop rules | ✅ Done | [→ Step 1](#step-1--owned-skins-and-shop-rules) |
| **2** | Shop screen and buying on the fighter screen | ✅ Done | [→ Step 2](#step-2--shop-screen-and-buying-on-the-fighter-screen) |
| **3** | Final check and documentation | ✅ Done | [→ Step 3](#step-3--final-check-and-documentation) |

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
| D1 | Progress version 3 adds `ownedSkins` (skin ids per fighter); version 2 data is **migrated** (owned = the skins it had selected), not reset | S9: kids keep their trophies, credits and fighters; until now unknown versions fell back to a fresh start |
| D2 | Skin rules in `ui/src/lib/game/shop.ts` (`ownsSkin`, `skinPrice`, `buySkin`, `skinOfTheDay`), using the same `Purchase` result and payment rule as `economy.ts` | One way to buy things; testable |
| D3 | Skin of the day picked from the date (day number) among the skins the player does not own, so it is the same all day and needs no server | Simple, works offline; S6 |
| D4 | Shop is a new screen like Info and Hack (`ShopScreen.svelte` in a `Panel`) | Same navigation as the other screens |

---

## Step 1 — Owned skins and shop rules

### Goal
Owned skins are saved (with migration) and the buying rules work and are tested (S1, S2, S5, S6, S8–S10).

### Tasks
- [x] Record the start time in Notes below.
- [x] Settings: skin prices by rarity, skin-of-the-day discount 30%.
- [x] `progress.ts` version 3 with `ownedSkins`; migrate version 2 (owned = selected skins).
- [x] `game/shop.ts`: `ownsSkin`, `skinPrice`, `skinOfTheDay(progress, fighters, date)`, `buySkin(progress, fighter, skin, date)`; refactor `economy.ts` so both share the payment rule.
- [x] Check: `vitest` — Default always owned; prices; buying lowers credits and owns the skin; refused when not enough credits (missing amount), for a locked fighter, or already owned; skin of the day is 30% off, same for the same day, never an owned skin, none when all are owned; unlock-everything owns every skin; unlimited credits keeps saved credits; version 2 progress migrates and keeps its data; unknown data still falls back.

### Notes
Started: 2026-11-12 11:50

The day for "skin of the day" is counted in local time, so it changes at the player's midnight. `economy.ts` exports `pay()` and a new `'owned'` reason.

**Done (2026-11-12 · ~4m)** — `npm test` 75 passed (8 new, including the version 2 → 3 migration), `svelte-check` 0 errors.

---

## Step 2 — Shop screen and buying on the fighter screen

### Goal
Players buy skins in the Shop and on the fighter screen (S3–S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Home: **Shop** button.
- [x] `ShopScreen.svelte`: skin of the day first (30% off badge), then all non-default skins with picture, names, rarity, price / Owned / "Unlock <fighter> first"; **Buy**; celebration with **Wear it**.
- [x] Fighter screen: lock and price on skins not owned; try-on; **Buy · N C** instead of Select.
- [x] Check (browser): with 1000 credits buy Rocko Crystal (300) → 700, owned, wear it → home shows it; Blaze Phoenix (1500) shows "Need 800 more"; Luna skins say "Unlock Luna first"; skin of the day shows the discounted price; with OPENSESAME all skins owned; old version 2 progress keeps its selected skin.

### Notes
Started: 2026-11-12 11:52

`wornSkin()` (in `game/shop.ts`) is the skin a fighter really wears: a chosen skin that is no longer owned (after a hack reset) shows as Default; home, list, fighter screen and matches use it. Home's side buttons are now a grid (2 columns; 3 in portrait, with the name plate moved under the top bar) to fit the new Shop button. Fixed the struck-through price running into the new price.

**Done (2026-11-12 · ~10m)** — browser: version 2 progress (1000 C, Phoenix selected) → version 3, 1000 C, Phoenix owned; Shop: skin of the day first (Blaze Lava 300 → 210), Phoenix "Owned", Crystal 300, Neon 600, Frosty/Luna/Pixel skins "Unlock … first"; buy Crystal → "NEW SKIN!", 700 C, Wear it → home shows Rocko; fresh progress with 700 C: Phoenix (skin of the day, 1050) "Need 350 more C"; OPENSESAME → all 8 skins Owned, no skin of the day, Phoenix selectable; after reset Blaze wears Default.

---

## Step 3 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains the shop (S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] Shop and fighter screen checked at 390×844, 844×390, 1024×768, 1440×900.
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README: the Shop, prices, skin of the day, hacks.
- [x] `docs/architecture.md`: `game/shop.ts`, progress version 3 and migration.
- [x] Info vocabulary: "Shop", "Skin of the day".

### Notes
Started: 2026-11-12 11:55

**Done (2026-11-12 · ~3m)** — browser: home, Shop and fighter screen at the four sizes with no sideways scrolling (portrait home grid 3 + 2 buttons); `pytest` 15 passed, `npm test` 75 passed, `svelte-check` 0 errors, `npm run build` OK; README, architecture and vocabulary updated.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Bots wearing skins | Nice extra, not asked | Later spec |
| More skins (Mattia's ideas) | Waits for Mattia | Later spec |
| Gems as a second currency | One currency is easier for kids | Later spec, if wanted |

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
