# Unlock and Upgrade Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/unlock-and-upgrade`
> **Moved from:** [2026_11_12_unlock_and_upgrade_spec.md](../../../.specs/features/done/2026_11_12_unlock_and_upgrade_spec.md) (#7)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_unlock_and_upgrade_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Credits and power levels are shown but do nothing: Frosty, Luna and Pixel can only be opened
with a hack, and power 22 is just a number. This spec lets players earn credits in matches,
spend them to unlock fighters and upgrade power levels, and makes power levels change health and
damage in matches — so the hack codes "unlimited credits" and "power 22" really pay off. It is F6
in the [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_unlock_and_upgrade_spec.md) (#7).
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) — `INFINITY` (credits shown as ∞),
  `OPENSESAME` (all unlocked), `POWER22` (max power 22). Its S12 said power 22 only changes
  what is shown "until F6" — this spec is F6.
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — credits (500 at start), power levels and
  unlocked fighters in the saved progress; fighter list and fighter screen.
- [First match spec](2026_11_12_07_first_match_spec.md) and
  [trophies spec](2026_11_12_08_trophies_spec.md) — matches, fixed health 3200 and damage
  480, settings, rewards after a match.
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- Credit prices for unlocking (by rarity) and upgrading (by level), credits earned in matches,
  power levels that change health and damage.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and the questions to Mattia |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–08) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
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
- ~~**S11 — Documentation:** README and `docs/architecture.md` describe credits, unlocking,
  upgrades and power.~~ (replaced for the Godot game by S12: it names the documents of the
  Python + Svelte game)
- **S12 — Documentation (Godot):** `hack_star_godot/README.md` and
  `hack_star_godot/docs/architecture.md` describe credits, unlocking, upgrades and power.

### Open questions

_None. "How strong should bots be?" is added to the questions to Mattia; until then bots play
at power 5 (S6, S10)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
