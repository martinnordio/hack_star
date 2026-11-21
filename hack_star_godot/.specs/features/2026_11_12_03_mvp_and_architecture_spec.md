# MVP and Architecture Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Not started — plan ready
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-mvp`
> **Issue:** #27
> **Moved from:** [2026_11_12_mvp_and_architecture_spec.md](../../../.specs/features/done/2026_11_12_mvp_and_architecture_spec.md) (#1)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Opus 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_mvp_and_architecture_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S7 (licences file), S8 (F6–F12 out, F13 only fitting fixes), S9 (same browser), S13 (server connection) revised; S4/S5 marked removed; feature list for the Godot game; server question answered — S15 (keep FastAPI); branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #27 created |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 1.56 M (108 k in · 1.43 M cached · 22 k out) | CHF 1.07 (127 credits) | Part 2 written (3 Steps: standard, standard, light); also the requirements revision and the issue (`usage.ps1 -Agent subagents` from 15:47) |

---

# Part 1 · Requirements

## Context

Hack star is a browser game for kids inspired by Brawl Stars, with one twist: **hack codes**
that give unlimited credits, unlock all fighters and allow 22 power levels instead of 11. This
spec (Spec 0 in [overall_req.md](../../../.specs/overall_req.md)) defines the minimum playable game that can be
built in about one day, the feature list (F0…F13), and the technical foundation that the
other features build on.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_mvp_and_architecture_spec.md) (#1).
- [overall_req.md](../../../.specs/overall_req.md) — the vision and Spec 0, Spec 1 and Spec 2.
- No lower-numbered moved spec: this is the first one. The Godot specs before it:
  [01 Godot Setup and First Game](done/2026_11_21_01_godot_setup_and_first_game_spec.md) and
  [02 Move Specs to Godot](done/2026_11_21_02_move_specs_to_godot_spec.md).
- Spec 01's Godot project in `hack_star_godot/`: Godot 4.7.2 with GDScript, the Compatibility
  renderer and a single-threaded web export; a start screen with **Play**, a 3D arena seen
  from above at an angle with one fighter that moves with the keyboard or a touch joystick;
  GUT tests; the commands in `hack_star_godot/tools/` (`test.ps1`, `lint.ps1`,
  `export_web.ps1`, `serve_web.ps1`, `check_tools.ps1`); install, run, export and play from
  an iPad in [hack_star_godot/README.md](../../README.md). No server. Its iPad play-test
  (Safari, landscape and portrait, ≥ 30 fps) is still open (spec 01, Deferred Items); only
  the Windows desktop was checked (~60 fps).
- The existing FastAPI server in `server/src/hack_star_server/` (`/api/hacks`,
  `/api/hacks/redeem`, the room WebSocket `/api/rooms`), used by the Svelte game through the
  Vite proxy (`/api` on the same address as the page); its tests in `server/tests/`.
- `.specs/kit/` — the spec kit used to write these specs, shared by both games
  ([AGENTS.md](../../../AGENTS.md)).

**New:**
- ~~The Python server, the Svelte UI and a way to run both locally.~~ (replaced for the
  Godot game by S12–S14)
- The architecture document of the Godot game and the way to run it locally (S12–S14).
- The feature list and the MVP scope below.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |
| [Basic UI spec](2026_11_12_04_basic_ui_spec.md) | F1 |
| [Hack codes spec](2026_11_12_05_hack_codes_spec.md) | F2 |
| [Graphics demo spec](2026_11_12_06_graphics_demo_spec.md) | F3 |

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

_History (Python + Svelte game): for the Godot game, Godot replaces these options (S12)._

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
| F0 | Architecture and foundation of the Godot game: architecture document, the existing FastAPI server for rooms and hack codes, runs in the browser on desktop, iPad, phone | this spec | ✅ |
| F1 | Home screen with the wow effect, fighter showcase, trophies, Prestige badge, skins, info page with the game's vocabulary | [basic UI](2026_11_12_04_basic_ui_spec.md) | ✅ |
| F2 | Hack codes (typed or QR): unlimited credits, all fighters unlocked, 22 power levels | [hack codes](2026_11_12_05_hack_codes_spec.md) | ✅ |
| F3 | Graphics demo: one fighter runs and shoots in an animated 3D arena | [graphics demo](2026_11_12_06_graphics_demo_spec.md) | ✅ |
| F4 | First real match: last fighter standing against bots, win or lose | [first match](2026_11_12_07_first_match_spec.md) | ✅ |
| F5 | Trophies after each match and Prestige levels, saved between visits | [trophies](2026_11_12_08_trophies_spec.md) | ✅ |
| F6 | Unlock fighters with credits; power levels change health and damage | [unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) | later |
| F7 | Skins shop | [skins shop](2026_11_12_10_skins_shop_spec.md) | later |
| F8 | Overtime (one more minute without walls) and a Settings screen for bot level and number of bots | [overtime and match options](2026_11_12_11_overtime_and_match_options_spec.md) | later |
| F9 | More fighters (10) with fighter types and different attacks | [more fighters](2026_11_12_13_more_fighters_spec.md) | later |
| F10 | Super, Hypercharge and the HYPERCHARGE hack code | [super and hypercharge](2026_11_12_12_super_and_hypercharge_spec.md) | later |
| F11 | Play with up to 2 friends on their own devices | [play with friends](2026_11_12_14_play_with_friends_spec.md) | later |
| F12 | A second mode (Gem Grab or another, Mattia to choose) | — | later |
| F13 | Bug fixes: created-fighter creation, account-tab sync, timed hack status and room identity | [bug fixes](2026_11_14_16_bug_fixes_spec.md) | only the fixes that fit what is built (its S0) |

_"In MVP" is for the Godot game: "(done)" of the Python + Svelte game was removed (S0,
2026-11-21) — none of F1–F13 is built in Godot yet; the order of work is the
[ordered list](README.md)._

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–02) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. — checked 2026-11-21: S1–S3, S6, S10–S12,
  S14 fit; S7, S8, S9, S13 and the feature list revised; the server question answered (S15).
- **S1 — Browser only:** The game runs in a web browser with nothing to install, on a desktop
  (Chrome, Edge, Safari), an iPad (Safari) and a phone (Safari, Chrome).
- **S2 — Screen sizes:** Every screen fits desktop, iPad and phone screens, in landscape and
  portrait, without parts cut off and without zooming.
- **S3 — Input:** Everything can be done with touch on iPad and phone, and with mouse and
  keyboard on a desktop.
- ~~**S4 — Technology:** The server is written in Python and the UI in Svelte (decided in
  [overall_req.md](../../../.specs/overall_req.md)).~~ (removed: replaced for the Godot game
  by S12)
- ~~**S5 — Run locally:** A developer can start the server and the UI on one computer by
  following the README, and play from an iPad or phone on the same Wi-Fi.~~ (removed:
  replaced for the Godot game by S14)
- **S6 — Smooth:** Animated screens run at 30 frames per second or more on a recent iPad
  and phone.
- **S7 — Own art:** The game uses only original art or art with a free licence; no
  Supercell art, names or logos. The licence of each asset pack is listed in
  `hack_star_godot/LICENSES.md` (as spec 01, S8, set up).
- **S8 — MVP scope:** The first playable version contains F0–F5 of the feature list;
  F6–F12 are not in it, and F13 brings only the fixes that fit what is built by then.
- **S9 — Progress kept:** A player's progress (trophies, unlocked fighters, active hack
  codes) is still there after the browser is closed and opened again on the same device and
  in the same browser. There is no login; progress is not shared between devices or
  browsers.
- **S10 — Feature order:** Features are built in the order of the feature list: F1 basic UI,
  F2 hack codes, F3 graphics demo, then F4 and F5.
- **S11 — 3D look:** Fighters and arenas are shown in 3D, seen from above at an angle, like
  Brawl Stars.
- **S12 — Technology:** The Godot game is made with Godot 4.7 and written in GDScript,
  exported for the web and played in the browser
  ([spec 01](done/2026_11_21_01_godot_setup_and_first_game_spec.md)).
- **S13 — Architecture document:** The Godot game has an architecture document,
  `hack_star_godot/docs/architecture.md`, that describes how screens, game rules, 3D models,
  saved progress, rooms, the connection to the server (S15) and tests are organised; every
  later spec reads it and keeps it up to date.
- **S14 — Run locally:** A developer opens, runs, tests, exports and serves the game by
  following [hack_star_godot/README.md](../../README.md), and plays from an iPad or phone on
  the same Wi-Fi.
- **S15 — Server for rooms and hack codes:** Rooms and hack codes of the Godot game come from
  the existing FastAPI server (`server/`) — the same rooms and codes as the Python + Svelte
  game; the Svelte game keeps working with that server as before (its tests pass).

### Open questions

_None._ The server question was answered on 2026-11-21 with its suggestion (S15).

_S9–S11 answer the earlier questions with the suggested defaults (assumed by the author
on 2026-11-12 so work could start; change them with `REQUIREMENTS:` if needed)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Architecture document | standard (Claude Sonnet 5.5) — a document whose content the decisions fix | ⬜ Not started | [→ Step 1](#step-1--architecture-document) |
| **2** | Screen sizes and input checked by tests | standard (Claude Sonnet 5.5) — GUT tests in sub-viewports, small layout fixes if a size fails | ⬜ Not started | [→ Step 2](#step-2--screen-sizes-and-input-checked-by-tests) |
| **3** | README, ordered list, final check | light (Claude Haiku 5.5) — docs and running the checks | ⬜ Not started | [→ Step 3](#step-3--readme-ordered-list-final-check) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

> **Godot spec:** this spec lives in `hack_star_godot/.specs/`. Every stage writes its files
> there (`changes/`, `review/`, `costs.md`, `features/done/`), never in the root `.specs/`;
> the checks are `hack_star_godot/tools/check_tools.ps1`, `test.ps1`, `lint.ps1`,
> `export_web.ps1` (all exit 0) and the guideline is
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../AGENTS.md)).

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **`hack_star_godot/docs/architecture.md`** (new folder `docs/`) with the sections: Layout (folders of spec 01, D5), Screens (`scenes/`, scene changes with `change_scene_to_file`), Game rules (`game/`: pure, statically typed scripts with `class_name`, tested headless), 3D models (built in code from primitive meshes; imported models later go to `assets/` with their licence in `LICENSES.md`), Saved progress (D4), Server, hack codes and rooms (D2, D3), Languages (none yet — spec 15), Tests and checks (GUT, `tools/*.ps1`), Spec order (the [ordered list](README.md)), How to… (add a screen, a rule, a test). Parts that later specs build are marked *planned — spec NN* so the document matches the folders at every moment. | S13; the same sections as the root `docs/architecture.md`, so a reader of both games finds the same things in the same place. |
| D2 | **Server:** the Godot game uses the existing FastAPI API unchanged — `GET /api/hacks`, `POST /api/hacks/redeem`, the WebSocket `/api/rooms` with the room messages of `server/src/hack_star_server/rooms.py` — through Godot's `HTTPRequest` and `WebSocketPeer`. No Godot-only endpoint and no change to `server/` in this spec. | S15: same codes and rooms as the Svelte game; the server and its tests stay as they are. |
| D3 | **Same address:** the web export reaches the server at `/api` on the address the page came from, as the Svelte game does through the Vite proxy (`ui/vite.config.ts`, port 8180). The local tool that serves `build/web/` and forwards `/api` (HTTP and WebSocket) to the server is built by the first spec that calls the server (05 Hack codes); until then `tools/serve_web.ps1` stays as it is. | No CORS settings in the server, works the same on an iPad over Wi-Fi; nothing is built before a spec needs it. |
| D4 | **Saved progress (planned):** one JSON file in `user://` (in the browser Godot keeps it in IndexedDB, per device and browser — S9) with a `version` number, read and written by one autoload; its fields are defined by the first spec that saves (05 Hack codes / 08 Trophies). Only described in the document in this spec. | One place for every saved value; the version allows later migrations; matches S9's "same device and browser". |
| D5 | **Screen sizes in tests:** GUT tests put each screen into a `SubViewport` of a given size — desktop 1280×720, iPad landscape 1180×820, iPad portrait 820×1180, phone portrait 390×844, phone landscape 844×390 — and check that every control (title, **Play**, **Back**, joystick, FPS label) lies inside the visible rectangle and the arena's four corners are in view. | S2 can be checked without a device; the sizes are the ones of spec 01's checks plus a phone. |
| D6 | **Device checks stay with the author:** the play-test on a real iPad and phone (Safari, landscape and portrait, touch, ≥ 30 fps — S1, S3, S6, S11) needs a person with the devices; it stays in Deferred Items (spec 01's row) and is not a task of an AI Step. | An AI Step cannot hold an iPad; the FPS label and `tools/serve_web.ps1` already make the check quick. |

---

## Step 1 — Architecture document

### Goal
`hack_star_godot/docs/architecture.md` describes how the Godot game is organised today and
where the planned parts go, including the FastAPI server for rooms and hack codes (S7, S9,
S11, S12, S13, S15).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Read `hack_star_godot/README.md`, `project.godot`, `scenes/`, `game/`, `tests/`,
      `tools/`, the root `docs/architecture.md`, `server/src/hack_star_server/app.py` and
      `rooms.py`, and `ui/vite.config.ts`.
- [ ] Write `hack_star_godot/docs/architecture.md` with the sections of D1: what exists
      (start screen, arena, fighter, touch joystick, `Movement`, the GUT tests, the tools) with
      file paths; Server, hack codes and rooms after D2 and D3 (the three endpoints, same
      address, the serving tool deferred to spec 05); Saved progress after D4; art and
      licences (S7, `LICENSES.md`); parts that are not built yet marked *planned — spec NN*.
- [ ] Check: every path named in the document exists (`Test-Path`) or is marked *planned*;
      every relative link resolves; no change outside `hack_star_godot/docs/`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 2 — Screen sizes and input checked by tests

### Goal
Automated tests show that the start screen and the arena fit desktop, iPad and phone sizes in
landscape and portrait, and that **Play** and **Back** work with a mouse click and a touch
(S1, S2, S3, S11).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] New `tests/test_screen_sizes.gd` (D5): for each of the five sizes, the start screen's
      title and **Play** lie inside the visible rectangle; the arena's **Back**, joystick and
      FPS label lie inside it and its four corners are in view of the camera.
- [ ] Tests that **Play** reacts to a mouse click and to a screen touch (Godot's emulated
      mouse from touch), and **Back** likewise, by sending input events to the button.
- [ ] If a size fails, fix the layout in `scenes/` (anchors, margins, minimum sizes) — the
      existing tests keep passing.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 3 — README, ordered list, final check

### Goal
The README points to the architecture document, the feature order and MVP scope are written
where developers look, and all Godot checks pass with the server unchanged (S6, S8, S10, S14,
S15).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/README.md`: `docs/` in the Layout table; a link to
      `docs/architecture.md` (read it before a spec, keep it up to date); one line that rooms
      and hack codes will come from the FastAPI server in `server/` (D2, D3).
- [ ] `hack_star_godot/.specs/features/README.md`: one line that the MVP is specs 03–08
      (F0–F5, S8) and that the order follows the feature list (S10).
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); parse every changed `.ps1` with
      `[System.Management.Automation.Language.Parser]::ParseFile` (if any).
- [ ] Show the server is unchanged (S15): `git diff --stat` of this spec shows nothing in
      `server/` or `ui/`.
- [ ] Note in Notes that the device check (S1, S3, S6, S11 on iPad and phone) stays open
      (D6, Deferred Items).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Play-test on a real iPad and phone (Safari, landscape and portrait, touch, ≥ 30 fps) — S1, S3, S6, S11 device parts | Needs a person with the devices (D6); open since spec 01 | the author, before the MVP's last spec (08) is closed; `tools\export_web.ps1` + `tools\serve_web.ps1` |
| Local tool that serves the web export and forwards `/api` (HTTP and WebSocket) to the FastAPI server | No spec calls the server yet (D3) | [05 Hack codes](2026_11_12_05_hack_codes_spec.md) |
| Saved-progress file and its fields | Nothing is saved yet (D4) | [05 Hack codes](2026_11_12_05_hack_codes_spec.md) / [08 Trophies](2026_11_12_08_trophies_spec.md) |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S15 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass; `hack_star_godot/README.md` and `hack_star_godot/docs/architecture.md` updated
- [ ] Review · review page written in `hack_star_godot/.specs/review/`; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
