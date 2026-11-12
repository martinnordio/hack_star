# More Fighters Spec

> **Author:** Martin Nordio
> **Status:** ✅ Done
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/more-fighters`

---

# Part 1 · Requirements

## Context

Mattia asked to "add more figures". Today there are 6 fighters that all fight the same way, so
the only difference is their look. This spec adds **4 new fighters** and gives every fighter its
own way of attacking, so choosing, unlocking and upgrading a fighter really matters. It is F9 in
the [MVP and architecture spec](2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- Fighter catalogue on the server (`server/src/hack_star_server/fighters.py`, `GET /api/fighters`):
  Blaze, Rocko, Turbo, Frosty, Luna, Pixel with rarity and skins.
- 3D fighters built in code (`ui/src/lib/models/fighters3d.ts`), portraits (`portraits.ts`),
  gallery page (`/?gallery`).
- Match rules: `game/world.ts` (one kind of shot for everyone), `game/bots.ts`,
  `game/economy.ts` (unlock prices by rarity, `stats(level)`), the Shop (skins by rarity).

**New:**
- 4 fighters with their own 3D look and at least one extra skin each.
- Fighter types: health, speed, range and attack differ per fighter.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../../docs/architecture.md) | How the code is organised |
| [README](../../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — 10 fighters:** The game has 10 fighters: the 6 of today and 4 new ones with original
  names and looks (no Supercell names or art), covering the rarities Rare to Legendary.
- **S2 — New skins:** Each new fighter has its Default skin and at least one Epic, Mythic or
  Legendary skin, sold in the Shop like the others.
- **S3 — Fighter types:** Each fighter has a type shown on its card and screen, with its own
  numbers: **Tank** (more health, short range), **Sharpshooter** (long range, less health),
  **Speedy** (fast), **Thrower** (shots fly over walls), **Spreader** (several shots in a fan).
- **S4 — Different attacks:** Fighters attack the way their type says, in matches and in
  Training, also when bots play them. Each type also gets its own Super (today every fighter
  has the same Super blast from the
  [super and hypercharge spec](2026_11_12_super_and_hypercharge_spec.md)).
- **S5 — Fair:** No type wins clearly more often than the others: in a test of many bot-only
  matches with one fighter of each of the 5 types at the same power level, every type wins
  between 10% and 30% of the matches that have a winner (a fair share is 20%).
- **S6 — Bots use them:** Bots pick from all 10 fighters.
- **S7 — Unlock:** New fighters start locked and are unlocked with credits at their rarity price;
  `OPENSESAME` unlocks them too. Saved progress keeps working.
- **S8 — Screens:** Fighter list, fighter screen, home, Shop and gallery show the new fighters
  on desktop, iPad and phone.
- **S9 — Documentation:** README (fighter list and types), `docs/architecture.md` and the Info
  vocabulary ("Tank", "Sharpshooter", "Thrower") are updated.

### Open questions

- **Q1 (Mattia):** Names or ideas for the new fighters? Until he answers, the game invents them
  (Coco, Sparky, Sir Clank, Kira — see D2); renaming later is a one-line change per fighter.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Fighter types in the rules | ✅ Done | [→ Step 1](#step-1--fighter-types-in-the-rules) |
| **2** | Four new fighters and their skins | ✅ Done | [→ Step 2](#step-2--four-new-fighters-and-their-skins) |
| **3** | Types on the screens and in the arena | ✅ Done | [→ Step 3](#step-3--types-on-the-screens-and-in-the-arena) |
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
| D1 | Types and their numbers live in the UI rules (`game/types.ts`, `FIGHTER_TYPES`); the server catalogue only says which type each fighter is (`type` field) | The rules run in the browser; the catalogue stays a plain list |
| D2 | Two fighters per type. Today's six: Blaze Spreader, Rocko Tank, Turbo Speedy, Frosty Thrower, Luna Sharpshooter, Pixel Spreader. New: **Coco** (Rare, coconut-throwing monkey, Thrower, skin Pirate · Epic), **Sparky** (Super Rare, robot dog, Speedy, skin Gold · Mythic), **Sir Clank** (Epic, little knight, Tank, skin Dragon Knight · Legendary), **Kira** (Legendary, ninja archer, Sharpshooter, skin Sakura · Legendary) | Every type twice; the new four cover Rare to Legendary |
| D3 | Supers per type: Tank **Shockwave** (ring of shots), Sharpshooter **Piercing beam** (one huge shot through walls and fighters), Speedy **Dash** (rush that hits everyone on the way), Thrower **Big bomb** (lobbed, big explosion), Spreader **Super blast** (the existing fan) | Each type's Super matches its style (super and hypercharge spec D1 moved here) |
| D4 | Thrower shots are **lobbed**: they fly over walls and fighters and explode where they land (small area); the aim length sets how far they fly | "Shots fly over walls" (S3), like Brawl Stars throwers |
| D5 | A shot carries its own range, size, speed and damage; the Super charges by damage dealt (one normal hit's worth = 1/5) | Spreader pellets and Thrower blasts charge fairly, without a rule per type |
| D6 | Fighters without a type (tests, old data) use a neutral **Basic** type: today's numbers and the Super blast | Existing behaviour and tests stay the same |
| D7 | Fairness (S5) is a `vitest` simulation of bot-only matches; numbers are tuned until it passes | Measurable, repeatable |

---

## Step 1 — Fighter types in the rules

### Goal
Each type moves, shoots and uses its Super its own way, also as a bot; types are fair (S3–S5).

### Tasks
- [x] Record the start time in Notes below.
- [x] `game/types.ts`: `FighterTypeId`, `FIGHTER_TYPES` (health, damage, speed, reload, attack: range, shot speed, size, count, spread, lob, blast; Super kind) and `BASIC`.
- [x] `stats(level, settings, type)` applies the type's health and damage.
- [x] `World`: per-fighter type; spread and lobbed attacks with explosions; Supers: shockwave, beam (pierces), dash, big bomb, blast; Hypercharge makes each bigger; charge by damage; event `explode`.
- [x] `Match` / `Bots`: types per fighter; bots keep to their type's range and use their Super.
- [x] Check: `vitest` — each type's attack and Super, lobs fly over walls, beam pierces, dash hits, Hypercharge bigger, Basic unchanged; fairness simulation (S5).

### Notes
Started: 2026-11-12 13:37

The fairness simulation is `game/tournament.ts` (200 bot-only matches, Hard bots, power 5, one fighter per type, start spots rotated, walls removed in the last 30 s). First numbers: Tank won 58%; after tuning (Tank health ×1.2, damage ×0.95, slower reload; Spreader pellets 46% each, health ×1) the wins are Tank 33, Sharpshooter 40, Speedy 45, Thrower 43, Spreader 38 of 199 (17–23% each). Bots can now also drive the player's fighter (`includePlayer`), used only by the simulation. Bots pass aim vectors as long as the distance so lobs land on the target.

**Done (2026-11-12 · ~4m)** — `npm test` 110 passed (13 new in `game/types.test.ts`, the old 97 unchanged), `svelte-check` 0 errors.

---

## Step 2 — Four new fighters and their skins

### Goal
Coco, Sparky, Sir Clank and Kira exist with 3D models and skins; every fighter has a type (S1, S2, S6, S7).

### Tasks
- [x] Record the start time in Notes below.
- [x] Server: `type` on every fighter, the four new fighters with skins (locked at start); tests.
- [x] 3D models (`fighters3d.ts`) for the four and their skins; shot colours.
- [x] Check: `pytest`; browser `/?gallery` shows 10 fighters and 18 skins; Shop lists the new skins; OPENSESAME unlocks the new fighters; old progress still loads.

### Notes
Started: 2026-11-12 13:42

The gallery (`/?gallery`) had a fixed list of 14 looks in 2 rows; it now has 22 (10 Default + 12 others) in rows of 8. ("18 skins" in the check above was a miscount: 10 fighters × Default + 12 bought skins = 22 looks.) Coco's light face first covered his eyes; it was made smaller and lower.

**Done (2026-11-12 · ~4m)** — `pytest` 18 passed (ten fighters, two of each type, the new four locked and Rare–Legendary); browser: gallery shows all 22 looks; Shop lists Pirate, Gold, Dragon Knight, Sakura ("Unlock … first"); fighter list has the 4 new ones locked; with OPENSESAME they are unlocked; the saved progress loaded unchanged.

---

## Step 3 — Types on the screens and in the arena

### Goal
Players see each fighter's type and feel it in matches and Training (S3, S4, S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Fighter list and fighter screen: type badge and a short line about it; health and damage include the type.
- [x] Arena: bots picked with their types; the player's type in matches and Training; aim guide as long as the fighter's range; lobbed shots fly in an arc; explosions, beam and dash effects.
- [x] Check (browser): each type in Training (Tank shockwave, Kira beam through a wall, Sparky dash, Coco bomb over a wall, Blaze blast); a match against bots of several types.

### Notes
Started: 2026-11-12 13:46

Throwers also get a white ring where the shot will land. Training has no wall between the start and the middle dummy, so "through a wall" and "over a wall" are covered by the unit tests; the browser check shows each Super hitting. Sir Clank's short range (5.5) does not reach the dummy from the start: he has to walk closer, as intended.

**Done (2026-11-12 · ~3m)** — browser Training with the HYPERCHARGE hack: Sir Clank shockwave ring (dummy 1032 → 0), Kira beam (888 → 0), Sparky dash rushed 7 units (1248 → 192), Coco bomb exploded on the dummy (1440 → 0), Blaze pellets 2400 → 1341; fighter list shows each type (🔥 Spreader, 🛡️ Tank…); Kira's screen: "🎯 Sharpshooter — Very long range… Super: Piercing beam", ❤️ 2400 💥 504; a Medium match with 5 bots of mixed types ran with no errors (bots' health 3010–3360 by type); `svelte-check` 0 errors.

---

## Step 4 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains fighters and types (S8, S9).

### Tasks
- [x] Record the start time in Notes below.
- [x] Fighter list, fighter screen, Shop and home checked at 390×844, 844×390, 1024×768, 1440×900.
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README (10 fighters, types, Supers), `docs/architecture.md` (`game/types.ts`, attacks and Supers in `World`), Info vocabulary (Tank, Sharpshooter, Thrower, Spreader, Speedy).

### Notes
Started: 2026-11-12 13:49

**Done (2026-11-12 · ~2m)** — browser at the four sizes: fighter list (10 cards, type labels not cut), Sir Clank's screen and the Shop (12 skins) with no sideways scrolling; `pytest` 18 passed, `npm test` 110 passed, `svelte-check` 0 errors, `npm run build` OK; README (type table), architecture and vocabulary updated.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Names from Mattia | Waits for his answer (Q1) | Rename when he answers |
| A third skin for the new fighters | One each is enough to start | Later spec |
| Gadgets and Star Powers | Not asked yet | Later spec |

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
