# Graphics Demo Spec

> **Author:** Martin Nordio
> **Status:** 🟨 In progress
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
- [Basic UI spec](done/2026_11_12_basic_ui_spec.md) — the Play button (S3) opens this demo; the
  selected fighter and skin (S5, S7); 3D fighters `buildFighter()` with idle animation
  (`ui/src/lib/models/`); toon materials and outlines (`models/parts.ts`).

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
- **S11 — One arena:** There is one arena with a sunny canyon theme (sand, rocks, cacti as
  bushes); the target dummies stand still.

### Open questions

_None. Answered 2026-11-12 with the suggested defaults (S11); more arenas and moving targets
are for later specs._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Arena rules (movement, shots, targets) | ✅ Done | [→ Step 1](#step-1--arena-rules-movement-shots-targets) |
| **2** | Canyon arena and camera | ✅ Done | [→ Step 2](#step-2--canyon-arena-and-camera) |
| **3** | Controls, running and shooting | ⬜ Not started | [→ Step 3](#step-3--controls-running-and-shooting) |
| **4** | Targets and effects | ⬜ Not started | [→ Step 4](#step-4--targets-and-effects) |
| **5** | Final check | ⬜ Not started | [→ Step 5](#step-5--final-check) |

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
| D1 | The demo runs entirely in the browser; no server calls during play | No rules or multiplayer yet (F4+); no lag on Wi-Fi |
| D2 | Game rules in plain TypeScript (`ui/src/lib/game/world.ts`): a `World` updated once per frame, separate from drawing | Rules can be unit-tested with `vitest`; F4 builds matches on it |
| D3 | Collisions on the ground plane only: fighter and shots are circles, walls are rectangles; the fighter slides along walls | Simple, fast and enough for a top-down arena |
| D4 | Per-frame data (positions, shots, effects) is kept in plain objects and Three.js meshes, not Svelte state; only the HUD uses Svelte state | Svelte updates for every bullet each frame would cost frames on the iPad |
| D5 | Touch controls like Brawl Stars: left joystick moves; right joystick aims while dragged and fires on release; a quick tap fires at the nearest target | Familiar to the kids |
| D6 | Effects (dust, muzzle flash, sparks, dummy pieces) use small pools of reused meshes | No garbage collection pauses on phones |
| D7 | The arena is built from simple shapes with toon materials (sand, canyon rocks, cacti, crates) like the fighters | Same look, no art licences, loads instantly |

---

## Step 1 — Arena rules (movement, shots, targets)

### Goal
The arena rules work and are tested: moving with wall collisions, bushes, shots that stop at walls, targets with health that break and come back (S3–S6, S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `game/arena.ts`: canyon layout — size, walls, cactus bushes, decoration spots, 3 dummy spots, start point.
- [x] `game/world.ts`: `World` with `move(dir, dt)` (slides along walls, stays inside), `fire(aim)` (cool-down), `step(dt)` (shots fly, stop at walls or range, hit dummies), dummy health, break, respawn after 5 s, `inBush`, events for effects.
- [x] Check: `vitest` — cannot walk through a wall, slides along it; shot stops at a wall; shot hits a dummy and lowers health; 0 health breaks it and it is back after 5 s; standing in a cactus patch is "in bush".

### Notes
Started: 2026-11-12 10:10

The fighter also cannot walk through standing dummies. Numbers: speed 6/s, shots 16/s with range 9, cool-down 0.35 s, 480 damage, dummies 2400 health (5 hits).

**Done (2026-11-12 · ~2m)** — `vitest src/lib/game`: 8 passed.

---

## Step 2 — Canyon arena and camera

### Goal
Play opens a good-looking canyon arena with the selected fighter, a following camera and a leave button (S1, S2, S7, S9, S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `ArenaScene.svelte`: sand ground with tiles, canyon rock walls, cacti bushes, decoration (crates, skulls, small rocks), sky colour, sun light with shadows.
- [x] The selected fighter and skin stand at the start point with the idle animation.
- [x] Camera from above at an angle, following the fighter smoothly; further away on portrait screens.
- [x] Play on home opens the arena; a back button returns home.
- [x] Check: browser at desktop and phone sizes — arena visible, fighter visible, back button works.

### Notes
Started: 2026-11-12 10:12

Scenery is built in `models/arena3d.ts` (tiles as one instanced mesh). Cliffs on the camera side are kept low so they never hide the arena. "Coming soon" on Play is gone; Play opens the arena. `currentFighter()` (in `hacks.ts`) is shared by home and the arena.

**Done (2026-11-12 · ~6m)** — Play opens the canyon in ~1.8 s with the selected fighter facing the camera; checked at 1024×768 and 390×844; back returns to home. `svelte-check` 0 errors.

---

## Step 3 — Controls, running and shooting

### Goal
The fighter runs and shoots with keyboard and mouse or with touch joysticks (S2–S4).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Keyboard: WASD and arrow keys; mouse aims (on the ground) and click fires.
- [ ] Touch: left joystick moves; right joystick aims and fires on release; quick tap fires at the nearest target.
- [ ] Run animation (lean, bounce, faces the way it runs) and attack animation (turn to aim, recoil).
- [ ] Shots drawn as glowing balls in the fighter's colour.
- [ ] Check: browser — keys move the fighter, it stops at walls; click fires a shot that stops at a wall; simulated touch on both joysticks moves and fires.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 4 — Targets and effects

### Goal
Targets react to hits, and everything has lively effects (S5, S6, S8).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] 3 target dummies with health bars; hit flash and floating damage numbers; break into pieces at 0 and come back after 5 s.
- [ ] Effects: dust puffs when running, muzzle flash, hit sparks.
- [ ] Fighter partly transparent in a bush.
- [ ] Check: browser — shooting a dummy shows damage numbers and lowers its bar; it breaks and returns after 5 s; standing in a bush makes the fighter see-through.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 5 — Final check

### Goal
The demo is smooth and fits every screen; F0–F2 still work (S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Browser check at 390×844, 844×390, 1024×768, 1440×900: FPS ≥ 30 while running and shooting; joysticks and back button reachable; arena opens within 5 s.
- [ ] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [ ] README: how to play the demo (keys, mouse, touch).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Bots that move and fight back, win/lose, trophies | Game rules come from F4 on | Later spec (F4, F5) |
| Super, different attacks per fighter | Keeps the demo simple | Later spec (F8) |
| Sound effects | Not in scope (see basic UI deferred items) | Later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
