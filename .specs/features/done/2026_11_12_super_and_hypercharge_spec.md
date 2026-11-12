# Super and Hypercharge Spec

> **Author:** Martin Nordio
> **Status:** ✅ Done
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
[MVP and architecture spec](2026_11_12_mvp_and_architecture_spec.md) (it was planned as
part of F8).

**Already in the repository** (reuse, don't rebuild):
- [Hack codes spec](2026_11_12_hack_codes_spec.md): codes typed or scanned as QR, the
  printable QR page (`/?qr`), the hack list on the server (`hacks.py`), **Reset all hacks**.
- Match rules (`game/world.ts`, `game/match.ts`, `game/bots.ts`), HUD and joysticks
  (`Arena.svelte`), effects (`models/particles.ts`).
- Fighter types from the [more fighters spec](../2026_11_12_more_fighters_spec.md) if it is done
  first (each type can have its own Super).

**New:**
- Super charge, Super button and Super attack; Hypercharge; the `HYPERCHARGE` hack code.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../../docs/architecture.md) | How the code is organised |
| [README](../../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Super charge:** Each hit on an enemy fills the fighter's Super meter; about 5 hits fill
  it. The meter is shown around the Super button and over the fighter.
- **S2 — Super:** When full, the player can use the Super: a **Super button** (right side, next
  to the aim joystick) on touch screens, the **E** key or right mouse button on a computer. The
  Super is a **Super blast**: a fan of 5 big shots that fly farther, go through walls and do more
  damage than normal shots. Using it empties the meter. (A different Super per fighter comes
  with the fighter types of the [more fighters spec](../2026_11_12_more_fighters_spec.md).)
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
- **S9 — Documentation:** README (controls, hack table), `docs/architecture.md` and the Info
  vocabulary (Super and Hypercharge already listed; add the hack code) are updated.

### Open questions

- **Q1 (Mattia):** What should the Hypercharge QR code do: every Super a Hypercharge (default),
  Hypercharge always on, or something else?

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Super and Hypercharge rules | ✅ Done | [→ Step 1](#step-1--super-and-hypercharge-rules) |
| **2** | HYPERCHARGE hack code | ✅ Done | [→ Step 2](#step-2--hypercharge-hack-code) |
| **3** | Super button, meters and effects | ✅ Done | [→ Step 3](#step-3--super-button-meters-and-effects) |
| **4** | Final check and documentation | ✅ Done | [→ Step 4](#step-4--final-check-and-documentation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration>)**`** line to that Step's **Notes**:
>    date, time it took, a one-line summary and the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | One Super for every fighter now (Super blast); per-fighter Supers wait for the fighter types (F9) | Fighters all fight the same way today; F9 gives them types, and each type's Super belongs there |
| D2 | Rules in `World`: each fighter has `superCharge` and `hyperCharge` (0–1), `hyperUntil`, `superGain`, `canHyper`, `alwaysHyper`; `useSuper(f, dx, dz)` fires the blast; shots carry `power` and `superShot` (big, through walls, longer range) | Same place as normal shots and damage; testable without drawing |
| D3 | Normal hits on fighters **and dummies** charge the Super; Super hits do not | Training works (S6); a Super cannot chain itself |
| D4 | The hack is applied to the player's fighter when an arena starts (`superGain` 3, `alwaysHyper`), read from the progress like the other hacks | Hacks stay "worked out when used", so Reset all hacks turns it off at once |
| D5 | Touch: **tap** the Super button = Super at the nearest visible enemy (or the way the fighter faces); computer: **E** or right click = Super towards the mouse | Easy for kids; no third joystick |
| D6 | `BotSkill.hyper` (false on Easy); bots use the Super as soon as it is full and the target is in range | S4 |

---

## Step 1 — Super and Hypercharge rules

### Goal
The world handles Super charge, the Super blast and Hypercharge; bots use them; tested (S1–S4, S6, S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Settings: `superHits` 5, `supersPerHypercharge` 2, `hyperchargeSeconds` 5, `hyperchargeBoost` 0.25, `superShots` 5 / `hyperSuperShots` 7, `superDamage` 1.2, `hackSuperGain` 3.
- [x] `World`: charge on normal hits (fighters and dummies), `useSuper()`, super shots (big, through walls, ×1.3 range), Hypercharge boosts (speed, damage), events `super` and `hypercharge`.
- [x] `Bots`: use the Super when full and the target is in range; `BotSkill.hyper` (Easy: no Hypercharge).
- [x] Check: `vitest` — 5 hits fill the Super, Super needs a full meter and empties it, fan of 5 shots through a wall, 2 Supers fill Hypercharge, Hypercharge lasts 5 s with +25% speed and damage and 7 shots, Super hits do not charge, dummies charge, `alwaysHyper` and `superGain`, easy bots never Hypercharge, bots use a full Super.

### Notes
Started: 2026-11-12 13:25

Each shot now carries its damage, worked out when fired (so a Hypercharge boost applies to shots fired during it). The Hypercharge's own blast already gets the +25%.

**Done (2026-11-12 · ~3m)** — `npm test` 96 passed (11 new in `game/super.test.ts`), `svelte-check` 0 errors.

---

## Step 2 — HYPERCHARGE hack code

### Goal
The `HYPERCHARGE` code works like the other hack codes (S5).

### Tasks
- [x] Record the start time in Notes below.
- [x] Server: hack `hypercharge` / `HYPERCHARGE` in `hacks.py`; tests.
- [x] UI: `HackId` gets `hypercharge`; `superHack(progress)` (gain and always-Hypercharge) applied to the player in matches and training.
- [x] Check: `pytest` (four hacks, redeem `hypercharge`); `vitest` (hack on / off after reset); the `/?qr` page shows the new QR code.

### Notes
Started: 2026-11-12 13:28

**Done (2026-11-12 · ~1m)** — `pytest` 16 passed, `npm test` 97 passed; browser: `/?qr` shows 4 QR codes including HYPERCHARGE, `POST /api/hacks/redeem` with `HYPERCHARGE` returns the hack.

---

## Step 3 — Super button, meters and effects

### Goal
Players see, use and feel the Super and Hypercharge (S1–S3, S6, S7).

### Tasks
- [x] Record the start time in Notes below.
- [x] Controls: **E** key and right mouse button; Super button tap (touch and mouse).
- [x] Super button (bottom right, above the aim area) with a ring meter that fills; "HYPER" look when the next Super is a Hypercharge; a yellow Super bar under the player's health bar.
- [x] Effects: big glowing super shots, a blast flash when used; Hypercharge: purple glow around the fighter for 5 s and a "HYPERCHARGE!" banner for the player.
- [x] Check (browser): in Training hit dummies 5 times → button full → Super breaks dummies through the middle wall; 2 Supers → HYPER → glow and banner; with HYPERCHARGE hack, every Super is a Hypercharge; a match where bots use Supers.

### Notes
Started: 2026-11-12 13:29

The Super button aims by itself (nearest visible enemy or dummy); E and right click aim at the mouse. In the Training check the middle dummy broke after 4 hits (power 7), so the Super was charged on the others; the CANYON has no wall between the start and the dummies, so "through walls" is covered by the unit test instead. Bots using Supers is covered by the unit test; the browser match (Hard, 5 bots) ran with no page errors.

**Done (2026-11-12 · ~3m)** — browser Training: button ring fills (0% → 80% → "Super ready"), E fires the blast (dummy 1632 → 710); with the HYPERCHARGE hack 2 hits → "HYPER" button, E → "HYPERCHARGE!" banner, purple glow, 7-shot blast hits all three dummies for 1152 each (768 × 1.2 × 1.25); match Hard · 5 bots ran with no errors; `svelte-check` 0 errors.

---

## Step 4 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains the Super and the new code (S7, S9).

### Tasks
- [x] Record the start time in Notes below.
- [x] Super button checked at 390×844, 844×390, 1024×768, 1440×900 (not covering the joysticks, the timer or the leave button).
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README (controls, Super, Hypercharge, hack table), `docs/architecture.md` (Super in `World`, hack), Info vocabulary (Super blast, HYPERCHARGE code).

### Notes
Started: 2026-11-12 13:31

**Done (2026-11-12 · ~2m)** — browser: the Super button is inside the screen, above the aim joystick area and away from the leave button at all four sizes (390×844: 288–366 × 602–680 px; 844×390: top 148 px, under the timer); `pytest` 16 passed, `npm test` 97 passed, `svelte-check` 0 errors, `npm run build` OK; README, architecture and vocabulary updated.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| A different Super per fighter (dash, bomb, heal…) | Belongs to the fighter types | [More fighters](../2026_11_12_more_fighters_spec.md) |
| Aiming the Super with a third joystick | Tap is easier for kids; maybe later | Later spec, if wanted |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted — no git host yet: merged locally into `master`
