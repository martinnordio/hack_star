# Graphics Demo Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/graphics-demo`

---

# Part 1 · Requirements

## Context

Before adding game rules, Hack star needs an impressive, playable demo that looks like a
Brawl Stars match: a fighter running and shooting in a colourful arena. The rules (win, lose,
trophies) are kept out on purpose and come from F4 on. This is F3 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) and "Spec 2" in
[overall_req.md](../overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) — S1–S3 (browser,
  screens, input), S6 (30 frames per second), S7 (own art); the graphics options
  investigated there.
- [Basic UI spec](2026_11_12_basic_ui_spec.md) — the Play button (S3) opens this demo; the
  selected fighter and skin (S5, S7). There is no code yet.

**New:**
- The arena, fighter movement and attack, target dummies, effects.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

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

### Open questions

- Is one arena enough, and does it have a theme the kids would like (desert, candy, space…)?
- Should the dummies move, or is standing still enough for this demo?

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
