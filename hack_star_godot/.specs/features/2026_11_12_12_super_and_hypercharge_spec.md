# Super and Hypercharge Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/super-and-hypercharge`
> **Moved from:** [2026_11_12_super_and_hypercharge_spec.md](../../../.specs/features/done/2026_11_12_super_and_hypercharge_spec.md) (#11)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_super_and_hypercharge_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Mattia asked for a **Hypercharge QR code**. In Brawl Stars a fighter charges its **Super** (a
special attack) by hitting enemies, and a **Hypercharge** makes the Super extra strong for a
short time. Hack star has neither yet, so this spec adds the Super, the Hypercharge, and a hack
code that gives Hypercharge. It is F10 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) (it was planned as
part of F8).

**Already in the repository** (reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_super_and_hypercharge_spec.md) (#11).
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) — codes typed or scanned as QR, the
  printable QR codes, the list of hack codes, **Reset all hacks**.
- [First match spec](done/2026_11_12_07_first_match_spec.md) — match rules, bots, HUD and joysticks;
  [graphics demo spec](done/2026_11_12_06_graphics_demo_spec.md) — the arena, touch controls and
  Training.
- Fighter types come later with the [more fighters spec](2026_11_12_13_more_fighters_spec.md)
  (each type can have its own Super then); this spec does not need them.
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- Super charge, Super button and Super attack; Hypercharge; the `HYPERCHARGE` hack code.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and Mattia's answers |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–11) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
- **S1 — Super charge:** Each hit on an enemy fills the fighter's Super meter; about 5 hits fill
  it. The meter is shown around the Super button and over the fighter.
- **S2 — Super:** When full, the player can use the Super: a **Super button** (right side, next
  to the aim joystick) on touch screens, the **E** key or right mouse button on a computer. The
  Super is a **Super blast**: a fan of 5 big shots that fly farther, go through walls and do more
  damage than normal shots. Using it empties the meter. (A different Super per fighter comes
  with the fighter types of the [more fighters spec](2026_11_12_13_more_fighters_spec.md).)
- **S3 — Hypercharge:** After 2 Supers the Hypercharge meter is full; the next Super is a
  **Hypercharge**: for 5 seconds the fighter glows, moves 25% faster, does 25% more damage and
  its Super blast has 7 shots.
- **S4 — Bots:** Bots charge and use Supers too (not Hypercharge on Easy).
- **S5 — HYPERCHARGE hack:** A new hack code `HYPERCHARGE` (typed or scanned as QR; also on the
  `/?qr` page) makes the player's Super charge 3 times faster and every Super a Hypercharge.
  **Reset all hacks** turns it off.
- **S6 — Training:** Super and Hypercharge work in Training against the dummies.
- **S7 — Screens:** The Super button fits on desktop, iPad and phone in both orientations
  without covering the joysticks.
- **S8 — Settings in one place:** Hits to charge, Hypercharge length and boosts are settings.
- ~~**S9 — Documentation:** README (controls, hack table), `docs/architecture.md` and the Info
  vocabulary (Super and Hypercharge already listed; add the hack code) are updated.~~ (replaced
  for the Godot game by S10: it names the documents of the Python + Svelte game)
- **S10 — Documentation (Godot):** `hack_star_godot/README.md` (controls, hack table),
  `hack_star_godot/docs/architecture.md` and the Info vocabulary (Super and Hypercharge already
  listed; add the hack code) are updated.

### Open questions

- **Q1 (Mattia):** What should the Hypercharge QR code do: every Super a Hypercharge (default),
  Hypercharge always on, or something else?

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
