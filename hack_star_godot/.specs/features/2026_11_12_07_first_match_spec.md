# First Match Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/first-match`
> **Moved from:** [2026_11_12_first_match_spec.md](../../../.specs/features/done/2026_11_12_first_match_spec.md) (#5)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_first_match_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Hack star can be played: the player runs and shoots in the canyon, but nothing shoots back and
nobody wins. This spec adds the first real match, a "last fighter standing" fight against bots,
like Showdown in Brawl Stars. It is F4 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md). The numbers Mattia
still has to choose (see "Questions to Mattia" in [overall_req.md](../../../.specs/overall_req.md)) are
settings with a default, so his answers change one value each.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_first_match_spec.md) (#5).
- [Graphics demo spec](2026_11_12_06_graphics_demo_spec.md) — the canyon arena, controls,
  shots, effects, bushes, camera, target dummies, fighters and skins in 3D.
- [Basic UI spec](2026_11_12_04_basic_ui_spec.md) — the home screen with **Play**; the
  selected fighter and skin; the UI foundation of the Godot game (S12).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  technology, the architecture document `hack_star_godot/docs/architecture.md` and how to run
  the game (S12–S14).

**New:**
- Bots, health for every fighter, knock-outs, a timer, a result, and the result screen.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea, planned specs and the questions to Mattia |
| [README](../../../README.md) (Python + Svelte game) | How to install, run and play the Python + Svelte game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–06) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
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

_Written by the plan stage once Part 1 is agreed._
