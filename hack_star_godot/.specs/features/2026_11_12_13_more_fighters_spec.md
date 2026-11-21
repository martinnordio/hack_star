# More Fighters Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/more-fighters`
> **Moved from:** [2026_11_12_more_fighters_spec.md](../../../.specs/features/done/2026_11_12_more_fighters_spec.md) (#10)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_more_fighters_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Mattia asked to "add more figures". Today there are 6 fighters that all fight the same way, so
the only difference is their look. This spec adds **4 new fighters** and gives every fighter its
own way of attacking, so choosing, unlocking and upgrading a fighter really matters. It is F9 in
the [MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_more_fighters_spec.md) (#10).
- [Basic UI spec](2026_11_12_04_basic_ui_spec.md) — the 6 fighters (Blaze, Rocko, Turbo, Frosty,
  Luna, Pixel) with rarity and skins, their 3D looks and portraits.
- [First match spec](2026_11_12_07_first_match_spec.md) — match rules (one kind of shot for
  everyone) and bots; [unlock and upgrade spec](2026_11_12_09_unlock_and_upgrade_spec.md) —
  unlock prices by rarity and the power level numbers; [skins shop spec](2026_11_12_10_skins_shop_spec.md)
  — the Shop (skins by rarity).
- [Super and hypercharge spec](2026_11_12_12_super_and_hypercharge_spec.md) — the Super blast
  every fighter has so far.
- [MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- 4 fighters with their own 3D look and at least one extra skin each.
- Fighter types: health, speed, range and attack differ per fighter.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and Mattia's answers |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–12) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
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
  [super and hypercharge spec](2026_11_12_12_super_and_hypercharge_spec.md)).
- **S5 — Fair:** No type wins clearly more often than the others: in a test of many bot-only
  matches with one fighter of each of the 5 types at the same power level, every type wins
  between 10% and 30% of the matches that have a winner (a fair share is 20%).
- **S6 — Bots use them:** Bots pick from all 10 fighters.
- **S7 — Unlock:** New fighters start locked and are unlocked with credits at their rarity price;
  `OPENSESAME` unlocks them too. Saved progress keeps working.
- **S8 — Screens:** Fighter list, fighter screen, home, Shop and gallery show the new fighters
  on desktop, iPad and phone.
- ~~**S9 — Documentation:** README (fighter list and types), `docs/architecture.md` and the Info
  vocabulary ("Tank", "Sharpshooter", "Thrower") are updated.~~ (replaced for the Godot game by
  S10: it names the documents of the Python + Svelte game)
- **S10 — Documentation (Godot):** `hack_star_godot/README.md` (fighter list and types),
  `hack_star_godot/docs/architecture.md` and the Info vocabulary ("Tank", "Sharpshooter",
  "Thrower") are updated.

### Open questions

- **Q1 (Mattia):** Names or ideas for the new fighters? Until he answers, the game invents them
  (Coco, Sparky, Sir Clank, Kira — see D2); renaming later is a one-line change per fighter.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
