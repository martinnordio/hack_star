# Skins Shop Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-22
> **Branch:** `feature/skins-shop`
> **Moved from:** [2026_11_12_skins_shop_spec.md](../../../.specs/features/done/2026_11_12_skins_shop_spec.md) (#8)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_skins_shop_spec.md (requirements only) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in [16](done/2026_11_14_16_bug_fixes_spec.md) | included in [16](done/2026_11_14_16_bug_fixes_spec.md) | S13 added from spec 16 (its S0: bugs whose feature comes with this spec) |

---

# Part 1 · Requirements

## Context

Kids love skins, especially Legendary ones ("something like a costume"), and in Brawl Stars they
are bought, which makes them special. In Hack star every skin is free to pick today. This spec
adds a **Shop** where skins are bought with credits, with a "skin of the day" on offer, and makes
the "unlock everything" hack really unlock every skin. It is F7 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_skins_shop_spec.md) (#8).
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — the skins of the fighters with their
  rarities (Default, Epic, Mythic, Legendary), their 3D looks and portraits, the skin choice on
  the fighter screen (S7) and the chosen skins in the saved progress.
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) — `OPENSESAME` "unlocks every fighter
  and every skin" (S5), `INFINITY` unlimited credits.
- [Unlock and upgrade spec](2026_11_12_09_unlock_and_upgrade_spec.md) — credits earned in
  matches, purchases, "UNLOCKED!" celebrations.
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- Owned skins in the saved progress, skin prices, the Shop screen, the skin of the day.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and the questions to Mattia |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–09) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
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
- ~~**S11 — Documentation:** README, `docs/architecture.md` and the Info vocabulary ("Shop",
  "Skin of the day") are updated.~~ (replaced for the Godot game by S12: it names the documents
  of the Python + Svelte game)
- **S12 — Documentation (Godot):** `hack_star_godot/README.md`,
  `hack_star_godot/docs/architecture.md` and the Info vocabulary ("Shop", "Skin of the day") are
  updated.
- **S13 — Skins bought with a code stay:** Skins bought while INFINITY was active stay owned when
  the code turns off by itself after its 3 days ([spec 16](done/2026_11_14_16_bug_fixes_spec.md),
  S16), as after resetting the hacks (S8); when OPENSESAME turns off, the skins that were not
  bought are no longer owned. _(added from spec 16, 2026-11-22)_

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
