# MVP and Architecture Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Not started — plan ready
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/mvp-and-architecture`

---

# Part 1 · Requirements

## Context

Hack star is a browser game for kids inspired by Brawl Stars, with one twist: **hack codes**
that give unlimited credits, unlock all fighters and allow 22 power levels instead of 11. This
spec (Spec 0 in [overall_req.md](../overall_req.md)) defines the minimum playable game that can be
built in about one day, the feature list (F0…F8), and the technical foundation that the
other features build on.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [overall_req.md](../overall_req.md) — the vision and Spec 0, Spec 1 and Spec 2. There is no code yet.
- `.spec-nx/` and `.specs/kit/` — the spec kit used to write these specs.

**New:**
- The Python server, the Svelte UI and a way to run both locally.
- The feature list and the MVP scope below.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |
| [Basic UI spec](2026_11_12_basic_ui_spec.md) | F1 |
| [Hack codes spec](2026_11_12_hack_codes_spec.md) | F2 |
| [Graphics demo spec](2026_11_12_graphics_demo_spec.md) | F3 |

### Investigation: Brawl Stars (the parts that matter for Hack star)

Source: Brawl Stars Wiki (Trophies, Brawlers pages), checked 2026-11-12. These details change
often in the real game, so Hack star uses a simplified version.

| Topic | Brawl Stars | Hack star MVP |
|-------|-------------|---------------|
| Fighters | Called **brawlers**; 100+ of them, each with a rarity: Rare, Super Rare, Epic, Mythic, Legendary, Ultra Legendary | 4–6 original fighters |
| Match | Short top-down matches (2–3 min); modes like Showdown (last one standing), Gem Grab, Brawl Ball | One mode: last fighter standing against bots |
| Trophies | Each brawler has its own trophy count; a win gives up to +15 at low trophies, a loss can take some away | Win: +10 trophies (as the kids describe it); loss: 0 |
| Prestige | At every 1000 trophies a brawler gets a **Prestige** level (1, 2, 3…), shown as a badge with the number; it cannot drop below that level | Badge with the Prestige number at 1000, 2000, … trophies |
| Power level | Brawlers upgrade from power level 1 to **11** | 1–11; **22** with a hack code |
| Skins | Cosmetic outfits with rarities (for example Epic, Mythic, Legendary) | 2–3 skins per fighter, one marked Legendary |
| Currencies | Coins, Power Points, Credits (unlock brawlers), Gems, Bling | Credits only (unlimited with a hack code) |
| Abilities | Main attack, **Super** (charged special), Gadgets, Star Powers, Gears, Hypercharge | Main attack only in the MVP; Super later |

### Investigation: graphics fast

Brawl Stars looks like cartoon-style 3D seen from above. Ways to get that look quickly in a
browser (the plan picks one and records it as a decision):

| Option | What it gives | Good for |
|--------|---------------|----------|
| Three.js through **Threlte** (Three.js for Svelte) | Real 3D, lights, shadows, animated models (glTF) | Closest to the Brawl Stars look |
| **PixiJS** | Fast 2D (WebGL) with sprites and particles | Simple, very fast on phones |
| **Phaser** | 2D game framework (physics, input, scenes) | Quick 2D gameplay |

Free art, with no permission needed (CC0 licence): **Quaternius** (animated low-poly characters
with idle, run and attack animations), **Kenney** (game kits, UI, particles). Supercell's art,
names and logos are copyrighted and are not used.

### Feature list

| # | Feature | Spec | In MVP |
|---|---------|------|--------|
| F0 | Architecture and foundation: server, UI, runs on desktop, iPad, phone | this spec | ✅ |
| F1 | Home screen with the wow effect, fighter showcase, trophies, Prestige badge, skins, info page with the game's vocabulary | [basic UI](2026_11_12_basic_ui_spec.md) | ✅ |
| F2 | Hack codes (typed or QR): unlimited credits, all fighters unlocked, 22 power levels | [hack codes](2026_11_12_hack_codes_spec.md) | ✅ |
| F3 | Graphics demo: one fighter runs and shoots in an animated 3D arena | [graphics demo](2026_11_12_graphics_demo_spec.md) | ✅ |
| F4 | First real match: last fighter standing against bots, win or lose | — | ✅ |
| F5 | Trophies after each match and Prestige levels, saved between visits | — | ✅ |
| F6 | Unlock fighters with credits; power levels change health and damage | — | later |
| F7 | Skins shop | — | later |
| F8 | Super ability, a second mode (Gem Grab) | — | later |

## 1 · Specs

- **S1 — Browser only:** The game runs in a web browser with nothing to install, on a desktop
  (Chrome, Edge, Safari), an iPad (Safari) and a phone (Safari, Chrome).
- **S2 — Screen sizes:** Every screen fits desktop, iPad and phone screens, in landscape and
  portrait, without parts cut off and without zooming.
- **S3 — Input:** Everything can be done with touch on iPad and phone, and with mouse and
  keyboard on a desktop.
- **S4 — Technology:** The server is written in Python and the UI in Svelte (decided in
  [overall_req.md](../overall_req.md)).
- **S5 — Run locally:** A developer can start the server and the UI on one computer by
  following the README, and play from an iPad or phone on the same Wi-Fi.
- **S6 — Smooth:** Animated screens run at 30 frames per second or more on a recent iPad
  and phone.
- **S7 — Own art:** The game uses only original art or art with a free licence; no
  Supercell art, names or logos. The licence of each asset pack is listed in the repository.
- **S8 — MVP scope:** The first playable version contains F0–F5 of the feature list; F6–F8
  are not in it.
- **S9 — Progress kept:** A player's progress (trophies, unlocked fighters, active hack
  codes) is still there after the browser is closed and opened again on the same device.
  There is no login; progress is not shared between devices.
- **S10 — Feature order:** Features are built in the order of the feature list: F1 basic UI,
  F2 hack codes, F3 graphics demo, then F4 and F5.
- **S11 — 3D look:** Fighters and arenas are shown in 3D, seen from above at an angle, like
  Brawl Stars.

### Open questions

_None. S9–S11 answer the earlier questions with the suggested defaults (assumed by the author
on 2026-11-12 so work could start; change them with `REQUIREMENTS:` if needed)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | Server and UI scaffolding | ⬜ Not started | [→ Step 0](#step-0--server-and-ui-scaffolding) |
| **1** | Responsive 3D shell | ⬜ Not started | [→ Step 1](#step-1--responsive-3d-shell) |
| **2** | Progress saved on the device | ⬜ Not started | [→ Step 2](#step-2--progress-saved-on-the-device) |
| **3** | README, asset licences, final check | ⬜ Not started | [→ Step 3](#step-3--readme-asset-licences-final-check) |

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
| D1 | Two folders: `server/` (Python) and `ui/` (Svelte) | Clear split; each has its own tools and tests |
| D2 | Server: FastAPI + Uvicorn, managed with `uv` (Python 3.13) | Small, fast to write, automatic JSON API; `uv` installs Python itself (no Python on PATH on the dev machine) |
| D3 | UI: Svelte 5 + Vite + TypeScript, no SvelteKit | A single-page game needs no server rendering or file routing; fewer moving parts |
| D4 | 3D: Three.js through Threlte (`@threlte/core`, `@threlte/extras`) | Brawl Stars-like 3D look (S11) with Svelte components |
| D5 | Progress in the browser's `localStorage`, behind one small store module | Per device, no login (S9); the server stays stateless for the MVP |
| D6 | In development, Vite proxies `/api` to the server; both listen on all network interfaces | One address to open on iPad/phone on the same Wi-Fi (S5) |
| D7 | Tests: `pytest` for the server, `vitest` for UI logic | Standard for each language |
| D8 | Art: only CC0 packs (Quaternius, Kenney); licences listed in `ui/public/assets/LICENSES.md`. F0 uses simple shapes, no art yet | S7; real art comes with F1 and F3 |

---

## Step 0 — Server and UI scaffolding

### Goal
The Python server and the Svelte UI exist, start, and have a passing test each (S4).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `server/`: uv project with FastAPI; `GET /api/health` returns `{"status": "ok", "game": "Hack star"}`.
- [ ] `server/tests/test_health.py` with `pytest`.
- [ ] `ui/`: Vite + Svelte 5 + TypeScript; `vitest` set up.
- [ ] Check: `uv run pytest` in `server/` and `npm run build` in `ui/` pass.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 1 — Responsive 3D shell

### Goal
A full-screen page with an animated 3D scene that fits every screen, reacts to touch and mouse, and shows the server is reachable (S1–S3, S6, S11).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Threlte canvas filling the screen; a placeholder fighter (simple shapes) bobbing on an arena floor, camera from above at an angle.
- [ ] Tap/click on the floor makes the placeholder hop (proves touch and mouse input).
- [ ] Layout uses the full viewport (`100dvh`, safe areas), no zoom (`viewport` meta), works in portrait and landscape.
- [ ] Small overlay: "Hack star", server status from `/api/health`, frames-per-second counter.
- [ ] Vite proxy for `/api`; both servers listen on `0.0.0.0`.
- [ ] Check: `npm run build` passes; in the browser at desktop, iPad (1024×768) and phone (390×844) sizes the scene fills the screen, the overlay is readable, FPS ≥ 30.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 2 — Progress saved on the device

### Goal
A progress store (trophies per fighter, unlocked fighters, active hacks) that survives closing the browser (S9).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `ui/src/lib/progress.ts`: typed progress, load/save to `localStorage` with a version number; broken or missing data falls back to the default.
- [ ] Svelte store wrapping it, saved on every change.
- [ ] Check: `vitest` tests for default, save/load round trip and broken data pass.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 3 — README, asset licences, final check

### Goal
Anyone can install, run and open the game on the computer and on an iPad/phone (S5, S7, S8).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `README.md`: what Hack star is, feature list link, prerequisites (`uv`, Node), how to install, run, test, and play from iPad/phone on the same Wi-Fi.
- [ ] `ui/public/assets/LICENSES.md`: the allowed sources and licence rule (D8), empty asset list.
- [ ] `.gitignore`: `node_modules`, `dist`, `.venv`, caches.
- [ ] Check: from a clean clone, the README steps start both parts; `uv run pytest` and `npm test` pass.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Real fighter models and animations | Belong to the home screen and the demo | `2026_11_12_basic_ui_spec.md`, `2026_11_12_graphics_demo_spec.md` |
| Production hosting (one server serving the built UI) | Only local play needed for the trip | Later spec |
| F4–F8 | Separate features in the feature list | Later specs |

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
