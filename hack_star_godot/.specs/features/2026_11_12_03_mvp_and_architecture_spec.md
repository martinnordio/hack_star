# MVP and Architecture Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/mvp-and-architecture`
> **Moved from:** [2026_11_12_mvp_and_architecture_spec.md](../../../.specs/features/done/2026_11_12_mvp_and_architecture_spec.md) (#1)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Opus 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_mvp_and_architecture_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Hack star is a browser game for kids inspired by Brawl Stars, with one twist: **hack codes**
that give unlimited credits, unlock all fighters and allow 22 power levels instead of 11. This
spec (Spec 0 in [overall_req.md](../../../.specs/overall_req.md)) defines the minimum playable game that can be
built in about one day, the feature list (F0…F8), and the technical foundation that the
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
  an iPad in [hack_star_godot/README.md](../../README.md). No server.
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
| F0 | Architecture and foundation: server, UI, runs on desktop, iPad, phone (Python + Svelte game; see S0 / spec 03's server question) | this spec | ✅ |
| F1 | Home screen with the wow effect, fighter showcase, trophies, Prestige badge, skins, info page with the game's vocabulary | [basic UI](2026_11_12_04_basic_ui_spec.md) | ✅ |
| F2 | Hack codes (typed or QR): unlimited credits, all fighters unlocked, 22 power levels | [hack codes](2026_11_12_05_hack_codes_spec.md) | ✅ |
| F3 | Graphics demo: one fighter runs and shoots in an animated 3D arena | [graphics demo](2026_11_12_06_graphics_demo_spec.md) | ✅ |
| F4 | First real match: last fighter standing against bots, win or lose | [first match](2026_11_12_07_first_match_spec.md) | ✅ |
| F5 | Trophies after each match and Prestige levels, saved between visits | [trophies](2026_11_12_08_trophies_spec.md) | ✅ |
| F6 | Unlock fighters with credits; power levels change health and damage | [unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) | later (done) |
| F7 | Skins shop | [skins shop](2026_11_12_10_skins_shop_spec.md) | later (done) |
| F8 | Overtime (one more minute without walls) and a Settings screen for bot level and number of bots | [overtime and match options](2026_11_12_11_overtime_and_match_options_spec.md) | later (done) |
| F9 | More fighters (10) with fighter types and different attacks | [more fighters](2026_11_12_13_more_fighters_spec.md) | later (done) |
| F10 | Super, Hypercharge and the HYPERCHARGE hack code | [super and hypercharge](2026_11_12_12_super_and_hypercharge_spec.md) | later (done) |
| F11 | Play with up to 2 friends on their own devices | [play with friends](2026_11_12_14_play_with_friends_spec.md) | later (done) |
| F12 | A second mode (Gem Grab or another, Mattia to choose) | — | later |
| F13 | Bug fixes: created-fighter creation, account-tab sync, timed hack status and room identity | [bug fixes](2026_11_14_16_bug_fixes_spec.md) | ✅ |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–02) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
- **S1 — Browser only:** The game runs in a web browser with nothing to install, on a desktop
  (Chrome, Edge, Safari), an iPad (Safari) and a phone (Safari, Chrome).
- **S2 — Screen sizes:** Every screen fits desktop, iPad and phone screens, in landscape and
  portrait, without parts cut off and without zooming.
- **S3 — Input:** Everything can be done with touch on iPad and phone, and with mouse and
  keyboard on a desktop.
- ~~**S4 — Technology:** The server is written in Python and the UI in Svelte (decided in
  [overall_req.md](../../../.specs/overall_req.md)).~~ (replaced for the Godot game by S12)
- ~~**S5 — Run locally:** A developer can start the server and the UI on one computer by
  following the README, and play from an iPad or phone on the same Wi-Fi.~~ (replaced for the
  Godot game by S14)
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
- **S12 — Technology:** The Godot game is made with Godot 4.7 and written in GDScript,
  exported for the web and played in the browser
  ([spec 01](done/2026_11_21_01_godot_setup_and_first_game_spec.md)).
- **S13 — Architecture document:** The Godot game has an architecture document,
  `hack_star_godot/docs/architecture.md`, that describes how screens, game rules, 3D models,
  saved progress, rooms and tests are organised; every later spec reads it and keeps it up
  to date.
- **S14 — Run locally:** A developer opens, runs, tests, exports and serves the game by
  following [hack_star_godot/README.md](../../README.md), and plays from an iPad or phone on
  the same Wi-Fi.

### Open questions

- **Server for rooms and hack codes:** does the Godot game use the existing FastAPI server
  (`server/`) for rooms and hack codes, or something in Godot? Suggestion: keep the FastAPI
  server (same rooms and codes as the Python game).

_S9–S11 answer the earlier questions with the suggested defaults (assumed by the author
on 2026-11-12 so work could start; change them with `REQUIREMENTS:` if needed)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
