# Trophies and Prestige Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/trophies`
> **Moved from:** [2026_11_12_trophies_spec.md](../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_trophies_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Matches can be won and lost, but nothing is earned. The kids' favourite part of Brawl Stars is
pushing a fighter's trophies and reaching **Prestige** at 1000 trophies ("if I win, the
fighter gets 10 trophies; at 1000 it gets a diamond with a number"). This spec gives trophies
after each match and celebrates Prestige. It is F5 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md), and with it the
first playable version (F0–F5) is complete.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6).
- [First match spec](2026_11_12_07_first_match_spec.md) — matches with a result (victory,
  defeat with place, time's up) and the result screen; match settings.
- [Basic UI spec](2026_11_12_04_basic_ui_spec.md) — trophies per fighter in the saved
  progress, total trophies on home, the Prestige badge on home, list and fighter screen.
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- Trophy rules for each result, saving them, and showing them on the result screen with a
  Prestige celebration.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and the questions to Mattia |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–07) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
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
- ~~**S9 — Documentation:** README and `docs/architecture.md` describe how trophies and
  Prestige work.~~ (replaced for the Godot game by S10: it names the documents of the Python +
  Svelte game)
- **S10 — Documentation (Godot):** `hack_star_godot/README.md` and
  `hack_star_godot/docs/architecture.md` describe how trophies and Prestige work.

### Open questions

_None. "Should a defeat take trophies?" is one of the questions to Mattia; until then a defeat
takes none (S2, S8)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
