# Hack Codes Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/hack-codes`

---

# Part 1 · Requirements

## Context

Hack codes are what makes Hack star different from Brawl Stars: by typing a secret code or
scanning a QR code, a player gets unlimited credits, all fighters unlocked, and power levels up
to 22 instead of 11. This is F2 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) and the "hack codes" part
of [overall_req.md](../overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) — S1–S3 (browser,
  screens, input) and S9 (progress kept on the device) apply here.
- [Basic UI spec](2026_11_12_basic_ui_spec.md) — credits on the home screen (S1), fighter list
  with locks and power levels (S4). There is no code yet.

**New:**
- A hack screen to enter or scan codes, and the three hack effects.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S1 — Hack screen:** A **Hack** button, always visible on the home screen, opens a screen
  where the player can type a code or scan a QR code.
- **S2 — Type a code:** A typed code is accepted with uppercase or lowercase letters and
  surrounding spaces.
- **S3 — Scan a QR code:** On a device with a camera, the player can scan a QR code that
  contains a hack code, and it works exactly like typing it. If the camera cannot be used
  (no camera or permission refused), the screen says so and typing still works.
- **S4 — Unlimited credits:** The "unlimited credits" code shows credits as ∞ and lets the
  player unlock things without credits going down.
- **S5 — Unlock all:** The "unlock all" code unlocks every fighter and every skin.
- **S6 — 22 power levels:** The "power 22" code raises the maximum power level of every
  fighter from 11 to 22, and the fighter list shows the new levels.
- **S7 — Feedback:** A correct code shows a celebration animation and the name of what it
  unlocked; a wrong code shows "Unknown code" and changes nothing.
- **S8 — Active hacks:** The hack screen lists the hacks that are active, and hacks stay
  active after the browser is closed and opened again.
- **S9 — Reset:** The player can turn all hacks off from the hack screen, after confirming;
  the game goes back to the normal rules.
- **S10 — Printable QR codes:** An adult can get the QR code of each hack code as an image to
  print or show on another screen.
- **S11 — The codes:** `INFINITY` gives unlimited credits (S4), `OPENSESAME` unlocks all
  (S5), `POWER22` gives 22 power levels (S6).
- **S12 — Power 22 for now:** Until power levels affect matches (F6), the power-22 hack
  changes only what the fighter list and fighter screen show.

### Open questions

_None. Answered 2026-11-12: the game invents the codes (S11); the Hack button is visible (S1);
power 22 is shown only until F6 (S12)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
