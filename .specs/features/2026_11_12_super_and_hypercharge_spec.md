# Super and Hypercharge Spec

> **Author:** Martin Nordio
> **Status:** 🟦 Requirements agreed (defaults where Mattia's answer is open)
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/super-and-hypercharge`

---

# Part 1 · Requirements

## Context

Mattia asked for a **Hypercharge QR code**. In Brawl Stars a fighter charges its **Super** (a
special attack) by hitting enemies, and a **Hypercharge** makes the Super extra strong for a
short time. Hack star has neither yet, so this spec adds the Super, the Hypercharge, and a hack
code that gives Hypercharge. It is F10 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) (it was planned as
part of F8).

**Already in the repository** (reuse, don't rebuild):
- [Hack codes spec](done/2026_11_12_hack_codes_spec.md): codes typed or scanned as QR, the
  printable QR page (`/?qr`), the hack list on the server (`hacks.py`), **Reset all hacks**.
- Match rules (`game/world.ts`, `game/match.ts`, `game/bots.ts`), HUD and joysticks
  (`Arena.svelte`), effects (`models/particles.ts`).
- Fighter types from the [more fighters spec](2026_11_12_more_fighters_spec.md) if it is done
  first (each type can have its own Super).

**New:**
- Super charge, Super button and Super attack; Hypercharge; the `HYPERCHARGE` hack code.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Super charge:** Each hit on an enemy fills the fighter's Super meter; about 5 hits fill
  it. The meter is shown around the Super button and over the fighter.
- **S2 — Super:** When full, the player can use the Super: a **Super button** (right side, next
  to the aim joystick) on touch screens, the **E** key or right mouse button on a computer. Each
  fighter has its own Super (for example a big blast, a dash, a wall-breaking shot) that does
  much more damage than a normal shot. Using it empties the meter.
- **S3 — Hypercharge:** After 2 Supers the Hypercharge meter is full; the next Super can be a
  **Hypercharge**: for 5 seconds the fighter glows, moves 25% faster, does 25% more damage and
  its Super is bigger.
- **S4 — Bots:** Bots charge and use Supers too (not Hypercharge on Easy).
- **S5 — HYPERCHARGE hack:** A new hack code `HYPERCHARGE` (typed or scanned as QR; also on the
  `/?qr` page) makes the player's Super charge 3 times faster and every Super a Hypercharge.
  **Reset all hacks** turns it off.
- **S6 — Training:** Super and Hypercharge work in Training against the dummies.
- **S7 — Screens:** The Super button fits on desktop, iPad and phone in both orientations
  without covering the joysticks.
- **S8 — Settings in one place:** Hits to charge, Hypercharge length and boosts are settings.
- **S9 — Documentation:** README (controls, hack table), `docs/architecture.md` and the Info
  vocabulary (Super and Hypercharge already listed; add the hack code) are updated.

### Open questions

- **Q1 (Mattia):** What should the Hypercharge QR code do: every Super a Hypercharge (default),
  Hypercharge always on, or something else?

<!-- spec-nx:plan -->
