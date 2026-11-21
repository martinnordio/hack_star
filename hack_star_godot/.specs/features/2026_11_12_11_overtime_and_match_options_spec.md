# Overtime and Match Options Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/overtime-and-match-options`
> **Moved from:** [2026_11_12_overtime_and_match_options_spec.md](../../../.specs/features/done/2026_11_12_overtime_and_match_options_spec.md) (#9)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_overtime_and_match_options_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Mattia's feedback ([overall_req.md](../../../.specs/overall_req.md), "Feedback from Mattia"): matches stay
2 minutes against 3 bots that also fight each other, but the **bot level should be chosen in a
configuration**, and when time runs out with bots still in, **the match goes on for another
minute without walls**. This is F8 in the
[MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_overtime_and_match_options_spec.md) (#9).
- [First match spec](2026_11_12_07_first_match_spec.md) — the match (countdown, timer,
  results), the match settings with the bot levels easy/medium/hard, the arena with its walls,
  the bots.
- [Trophies spec](2026_11_12_08_trophies_spec.md) and
  [unlock and upgrade spec](2026_11_12_09_unlock_and_upgrade_spec.md) — rewards for the
  "time's up" result, and the saved progress they extend.
- [MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- A **Settings** screen for the player (bot level, number of bots), saved on the device.
- **Overtime**: one more minute in which the walls disappear.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and Mattia's answers |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–10) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
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
- ~~**S9 — Screen sizes and documentation:** The Settings screen works on desktop, iPad and phone
  in both orientations; README, `docs/architecture.md` and the Info vocabulary ("Overtime") are
  updated.~~ (replaced for the Godot game by S10: it names the documents of the Python + Svelte
  game)
- **S10 — Screen sizes and documentation (Godot):** The Settings screen works on desktop, iPad
  and phone in both orientations; `hack_star_godot/README.md`,
  `hack_star_godot/docs/architecture.md` and the Info vocabulary ("Overtime") are updated.

### Open questions

- **Q1 (Mattia) — answered 2026-11-12:** "Then it is a draw but …" → **it is a draw**. A draw
  after overtime gives the same as "time's up" today (0 trophies, 20 credits).
- **Q2 (Mattia):** Should harder bots give more trophies or credits? Default: no, the same.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
