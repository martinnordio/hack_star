# Graphics Demo Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/graphics-demo`
> **Moved from:** [2026_11_12_graphics_demo_spec.md](../../../.specs/features/done/2026_11_12_graphics_demo_spec.md) (#4)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_graphics_demo_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Before adding game rules, Hack star needs an impressive, playable demo that looks like a
Brawl Stars match: a fighter running and shooting in a colourful arena. The rules (win, lose,
trophies) are kept out on purpose and come from F4 on. This is F3 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) and "Spec 2" in
[overall_req.md](../../../.specs/overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_graphics_demo_spec.md) (#4).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — S1–S3 (browser,
  screens, input), S6 (30 frames per second), S7 (own art) apply here too; the graphics
  options investigated there; the Godot technology, the architecture document
  `hack_star_godot/docs/architecture.md` and how to run the game (S12–S14).
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — the Play button (S3) opens this demo; the
  selected fighter and skin (S5, S7); the UI foundation of the Godot game (S12).
- Spec 01's Godot project
  ([01 Godot Setup and First Game](done/2026_11_21_01_godot_setup_and_first_game_spec.md)):
  a 3D arena seen from above at an angle with one fighter, moved with the keyboard or a touch
  joystick.

**New:**
- The arena, fighter movement and attack, target dummies, effects.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–05) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
- **S1 — Arena:** The demo shows an arena seen from above at an angle, like Brawl Stars, with
  ground, walls, bushes and some decoration.
- **S2 — Your fighter:** The fighter and skin selected on the home screen appear in the arena,
  with idle, run and attack animations.
- **S3 — Move:** On touch screens the fighter moves with an on-screen joystick on the left; on
  a desktop with WASD or the arrow keys. The fighter cannot walk through walls.
- **S4 — Attack:** On touch screens the fighter attacks with a button or joystick on the
  right, aimed in the direction dragged; on a desktop with the mouse (aim) and click. Shots fly
  visibly and stop at walls.
- **S5 — Targets:** The arena has 3 target dummies with a health bar; a hit shows an effect
  and a damage number, and a dummy with no health left breaks apart and comes back after
  5 seconds.
- **S6 — Bushes:** The fighter becomes partly transparent while standing in a bush.
- **S7 — Camera:** The camera follows the fighter smoothly and the whole fighter is always
  visible.
- **S8 — Effects:** Movement and attacks have visible effects (dust when running, muzzle flash,
  hit sparks) that make the demo look lively.
- **S9 — Leave:** A button returns to the home screen at any time.
- **S10 — Smooth on iPad:** The demo runs at 30 frames per second or more on a recent iPad and
  phone, and starts within 5 seconds on home Wi-Fi.
- **S11 — One arena:** There is one arena with a sunny canyon theme (sand, rocks, cacti as
  bushes); the target dummies stand still.

### Open questions

_None. Answered 2026-11-12 with the suggested defaults (S11); more arenas and moving targets
are for later specs._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
