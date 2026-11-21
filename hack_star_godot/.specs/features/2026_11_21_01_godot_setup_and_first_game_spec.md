# Godot Setup and First Game Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-setup-and-first-game`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 1.93 M (191 k in · 1.72 M cached · 20 k out) | CHF 1.42 (169 credits) | Part 1 written, together with spec 02 (measured from the Copilot CLI session log) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 1.66 M (12 k in · 1.64 M cached · 7 k out) | CHF 0.45 (53 credits) | Part 1 revised: open questions answered — GDScript, pinned latest stable Godot 4, browser only, no server yet; no own kit, the root kit with Godot specs in `hack_star_godot/.specs/` (S3 removed, S15–S19 added) |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 2.07 M (34 k in · 2.02 M cached · 18 k out) | CHF 0.78 (93 credits) | Part 2 written |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.12 M (54 k in · 1.06 M cached · 10 k out) | CHF 0.36 (43 credits) | Step 1 done |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.64 M (49 k in · 1.58 M cached · 13 k out) | CHF 0.44 (52 credits) | Step 2 done |

---

# Part 1 · Requirements

## Context

Hack star is re-implemented with the [Godot Engine](https://godotengine.org/), a free and
open-source (MIT) 2D and 3D game engine, in a new folder `hack_star_godot/` next to the
existing Python + Svelte game. This first spec prepares the ground: the folder with its own
specs, the tools every developer installs, the resources that live outside the
folder, and a first small game that runs, so that the existing features can then be built
again one spec at a time
([2026_11_21_02_move_specs_to_godot_spec.md](2026_11_21_02_move_specs_to_godot_spec.md)).

**Already in the repository** (reuse, don't rebuild):
- The Python + Svelte game: FastAPI server in `server/`, Svelte 5 + TypeScript UI in `ui/`,
  described in [README.md](../../../README.md) and
  [docs/architecture.md](../../../docs/architecture.md). It stays as it is.
- Its specs in the root [.specs/](../../../.specs/) with the spec-nx kit in
  [.specs/kit/](../../../.specs/kit/) (stages requirements, plan, implementation, review, pr;
  per-Step models; cost tracking). Its prompts are plain instructions that work for any
  spec file, but they name the Python + Svelte paths and checks (`server/`, `ui/`,
  `uv run pytest`, `npm test`, …) and write to the root `.specs/` — the reason for S15.
  The kit is generated from the `.spec-nx` submodule, and `GENERATE KIT --update`
  replaces `.specs/kit/`.
- The target the game already promises (MVP spec S1–S3, S6, S11): playable in a browser on a
  desktop, an iPad and a phone; touch, mouse and keyboard; 30 frames per second or more on a
  recent iPad; fighters and arenas in 3D, seen from above at an angle.
- Art rules: only original art or art with a free licence; all fighters, skins and arenas are
  built in code from simple shapes ([LICENSES.md](../../../ui/public/assets/LICENSES.md)).
- Music: the repository has no music; each developer keeps tracks on their own computer,
  git-ignored, CC0 or CC BY only (README, *Developer page*).
- The overall game idea: [.specs/overall_req.md](../../../.specs/overall_req.md).

**New:**
- The folder `hack_star_godot/` with a Godot project and its own `.specs/`.
- A written rule that Godot specs go to `hack_star_godot/.specs/` and use the Godot checks,
  with the root kit.
- Installation instructions for the Godot tools, and a list of what lives outside the folder.
- A first basic game in Godot that starts, shows a fighter in an arena and runs in a browser.

## 1 · Specs

- **S1 — Own folder:** The Godot game lives in `hack_star_godot/` at the root of this
  repository. Nothing of the Python + Svelte game moves or changes: its tests, its build and
  its root `.specs/` work as before.
- **S2 — Two spec folders:** Specs of the Python + Svelte game stay in the root `.specs/`;
  specs of the Godot game are in `hack_star_godot/.specs/`, with the same sub-folders
  (`features/`, `features/done/`, `changes/`, `review/`) and their own `costs.md`, but no
  kit of their own. A developer can tell from the path alone which game a spec belongs to.
- ~~**S3 — Kit for Godot:** `hack_star_godot/.specs/` has a spec-nx kit with the same stages,
  model and cost settings as the root kit, whose prompts, guidelines and checks name the
  Godot project's language, files and commands (run, test, lint, export) — not the Python or
  Svelte ones. The root kit is unchanged.~~ (removed: the root kit is used for both games, S15)
- **S4 — Same commands:** With the root kit, the existing commands (`REQUIREMENTS:`,
  `PLAN:`, `IMPLEMENT:`, `REVIEW:`, `CLOSE:`, `PR:`, `CREATE ISSUE:`) work on a spec in
  `hack_star_godot/.specs/features/`, and write their changes, reviews and costs inside
  `hack_star_godot/.specs/` — never in the root `.specs/`.
- **S5 — Tools installed:** A developer on Windows can install every tool the Godot game
  needs (Godot editor, export templates for the web, test and lint tools) by following
  `hack_star_godot/README.md` step by step, without other knowledge.
- **S6 — Same version for everybody:** The Godot version (and the test and lint tool
  versions) is fixed and written down; one command shows whether the installed versions
  match, and says what to install when they do not.
- **S7 — Resources outside the folder:** `hack_star_godot/README.md` lists everything the
  game uses that is not created inside the folder (for example music, fonts, sounds, art
  made with other tools), where each lives and how it gets into the game. Music stays on
  each developer's computer and is never committed, with the same licence rules as today.
- **S8 — Licences:** Every file in `hack_star_godot/` is original or has a free licence
  written next to it, as in the root `LICENSES.md`; the Godot engine's licence is credited.
  The folder has the same MIT licence and the same fan-project disclaimer as the root game.
- **S9 — First game starts:** The Godot project opens in the Godot editor without errors or
  warnings, and starting it shows a start screen with the title "Hack star" and a **Play**
  button.
- **S10 — First game plays:** **Play** opens a 3D arena seen from above at an angle with one
  fighter built from simple shapes. The fighter moves with the keyboard (WASD and arrow
  keys) on a desktop and with a touch joystick on an iPad and a phone; walls stop it; a
  button leads back to the start screen.
- **S11 — Runs in a browser:** The first game is exported for the web with one command and
  plays in a desktop browser and in Safari on an iPad, in landscape and portrait, at 30
  frames per second or more on a recent iPad.
- **S12 — Checks:** One command runs the automated tests of the Godot project without
  opening the editor (at least one test of the first game), and one command runs the lint
  check; both pass.
- **S13 — Nothing generated in git:** Godot's cache, the exports and the local music are
  git-ignored; a fresh clone plus the README's steps is enough to open, test and export the
  game.
- **S14 — Documented:** `hack_star_godot/README.md` explains install, run, test, lint,
  export and how specs are written for the Godot game; the root `README.md` says in one
  line that the Godot version lives in `hack_star_godot/` and links to it.
- **S15 — One kit, two games:** The root kit in `.specs/kit/` is used for both games; no kit
  is generated for the Godot folder. Every new spec for the Godot game is created in
  `hack_star_godot/.specs/features/`, and when a stage works on such a spec it uses the
  Godot project's language, files and checks (run, test, lint, export, from
  `hack_star_godot/README.md`) instead of the Python and Svelte ones. This rule is written
  where every AI assistant and developer working in the repository reads it.
- **S16 — GDScript:** The game is written in GDScript (no .NET install), in a language and
  Godot version that can export to the web (S11).
- **S17 — Pinned Godot 4:** The Godot version is the latest stable Godot 4 release when the
  plan is written, pinned for everybody (S6); its web export works without special server
  headers if that version allows it.
- **S18 — Browser only:** The game targets the browser only, as today; native Windows, iPad
  or phone apps are left for a later spec.
- **S19 — No server yet:** This spec needs no server; whether the Godot game uses the
  existing FastAPI server for rooms and hack codes is decided in the moved *MVP and
  Architecture* and *Play with Friends* specs.

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Folder, rule for Godot specs, pinned tools | standard (Claude Sonnet 5.5) — files and scripts a clear plan describes | ✅ Done | [→ Step 1](#step-1--folder-rule-for-godot-specs-pinned-tools) |
| **2** | Godot project, start screen, test and lint | standard (Claude Sonnet 5.5) — scaffolding with tests | ✅ Done | [→ Step 2](#step-2--godot-project-start-screen-test-and-lint) |
| **3** | 3D arena with a fighter, keyboard and touch | reasoning (Claude Opus 5.5) — 3D scene, camera and input, graphics-heavy | ⬜ Not started | [→ Step 3](#step-3--3d-arena-with-a-fighter-keyboard-and-touch) |
| **4** | Web export and play in the browser | standard (Claude Sonnet 5.5) — export settings and scripts with a clear check | ⬜ Not started | [→ Step 4](#step-4--web-export-and-play-in-the-browser) |
| **5** | README, licences, final check | light (Claude Haiku 5.5) — docs and running the checks | ⬜ Not started | [→ Step 5](#step-5--readme-licences-final-check) |

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

> **Godot spec (S15):** this spec lives in `hack_star_godot/.specs/`. Every stage writes its
> files there (`changes/`, `review/`, `costs.md`, `features/done/`), never in the root
> `.specs/`; the checks are the Godot ones of D6–D8, not `pytest` / `npm`, except where a
> task says to run the root suites to show they are unchanged.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **Godot 4.7.2 stable**, standard (non-.NET) build, pinned in `hack_star_godot/tools/versions.json` and `project.godot` (`config/features` `4.7`). Installed with `winget install --id GodotEngine.GodotEngine --version 4.7.2 -e`; the scripts find the executable through `$env:GODOT`, else `godot` on the PATH. | Latest stable release (2026-08-18); 4.8 is still in beta (godotengine.org `versions.json`, checked 2026-11-21). One version for everybody (S6, S17); the standard build needs no .NET (S16). |
| D2 | **GDScript only**, statically typed (`var speed: float`), with the pure rules (movement, clamping) in `game/` as plain scripts testable without a scene — the same split as `ui/src/lib/game/` in the Svelte game. | S16; rules testable headless (S12). |
| D3 | **Compatibility renderer** (`rendering/renderer/rendering_method="gl_compatibility"`). | It is the renderer the web export runs on (WebGL 2); using it from the start means what is seen in the editor is what the browser shows (S11). |
| D4 | **Single-threaded web export** (Thread Support off in the `Web` preset). | Since Godot 4.3 the export runs without `SharedArrayBuffer`, so no cross-origin isolation headers are needed and it works on iOS / macOS Safari, where threaded exports had problems (Godot docs, *Exporting for the Web*) (S11, S17). |
| D5 | **Layout:** `project.godot` at the top of `hack_star_godot/`; `scenes/` (`.tscn` + their scripts), `game/` (pure rules), `tests/` (GUT tests), `addons/gut/`, `tools/` (PowerShell scripts), `build/` (exports, ignored), `.specs/`, `README.md`, `LICENSES.md`. | One folder per kind of file, like the root game; exports never mix with sources (S13). |
| D6 | **Tests: GUT 9.7.1** (MIT), committed in `addons/gut/` with its licence; `tools/test.ps1` runs `godot --headless --path . --import`, then `godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit`, and fails when no test ran. | GUT publishes a release line per Godot version (9.7.1 for 4.7.x) and its command line returns a non-zero exit code on failure; committing it means a fresh clone needs no download (S12, S13). Chosen over GdUnit4 for its smaller footprint. |
| D7 | **Lint: gdtoolkit 4.5.0** (`gdlint`, `gdformat --check`), installed with `uv tool install gdtoolkit==4.5.0`; `tools/lint.ps1` runs both on `game/`, `scenes/`, `tests/` (not `addons/`). | `uv` is already used by the server; a tool install adds no dependency to the repository (S12). |
| D8 | **The rule for Godot specs (S15)** goes into a new **`AGENTS.md`** at the repository root (read by the Copilot CLI and VS Code Copilot, and by other agents), with the GDScript rules in `hack_star_godot/.specs/guidelines/gdscript.md`. If a new VS Code chat does not pick up `AGENTS.md`, the same text also goes into `.github/copilot-instructions.md`. Not into `.specs/kit/`. | One place every assistant reads; `GENERATE KIT --update` replaces `.specs/kit/`, so a note there would be lost. The implementation prompt already reads project guidelines before the kit's own. |
| D9 | **Cost list:** `usage.ps1` always runs from the repository root (it finds the chat logs of the repository); the Godot cost list is written with `.specs/kit/tools/costs_ledger.ps1 -Root hack_star_godot -CostsLink ../../.specs/kit/COSTS.md`, which needs `hack_star_godot/.specs/spec-nx.json` holding only a copy of the root `cost` block. | The script reads the cost settings from `<Root>/.specs/spec-nx.json`; a settings file with only `cost` is not a kit (S2, S4). The two `cost` blocks must stay equal; the README says so. |
| D10 | **Art from code:** arena floor, walls and the fighter are built from Godot's primitive meshes (box, capsule, sphere) with plain materials; no imported models, textures or fonts (Godot's default font). | Same rule as the root game (`LICENSES.md`); nothing to license (S8). |
| D11 | **Touch joystick:** a small own control on the left of the screen, shown only when the device has a touch screen; keyboard input through the Input Map (`move_left/right/up/down` on WASD and the arrows). | No addon to license or maintain; the same two inputs feed one movement rule in `game/` (S10). |
| D12 | **Local play on an iPad:** `tools/serve_web.ps1` serves `build/web/` on the local network with `uv run --no-project python -m http.server 8060 --bind 0.0.0.0` and prints the address to open in Safari. | The single-threaded export needs no special headers or HTTPS (D4); Python's server sends the right `.wasm` type. |
| D13 | **Resources outside the folder (S7):** none are needed for this spec. Music, when a later spec adds it, goes to `hack_star_godot/assets/music/` (git-ignored — Godot only imports files inside the project) under the root game's licence rules. | Keeps today's rule: no music in the repository. |

---

## Step 1 — Folder, rule for Godot specs, pinned tools

### Goal
The Godot folder with its spec folders, the written rule for Godot specs, and a check of the
pinned tools exist; nothing of the root game changes (S1, S2, S4, S5, S6, S13, S15, S16, S17).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Create `hack_star_godot/.specs/` sub-folders `features/done/`, `changes/`, `review/`
      (with `.gitkeep`), and `hack_star_godot/.specs/spec-nx.json` with only the root `cost`
      block (D9).
- [x] `hack_star_godot/.specs/guidelines/gdscript.md`: static types, naming (snake_case files
      and functions, PascalCase classes and nodes), rules in `game/` without scene access,
      one scene per screen, tests next to the rule they check in `tests/`, `gdformat` style.
- [x] `AGENTS.md` at the repository root (D8): which game lives where; for a Godot spec —
      create and keep it in `hack_star_godot/.specs/features/`, write `changes/`, `review/`,
      `costs.md` and `done/` under `hack_star_godot/.specs/`, use the root kit's prompts,
      the GDScript guideline and the Godot checks (`tools/test.ps1`, `tools/lint.ps1`,
      `tools/export_web.ps1`) instead of `pytest` / `npm`, run `usage.ps1` from the root and
      `costs_ledger.ps1` as in D9; for a Python + Svelte spec — as today.
- [x] `hack_star_godot/.gitignore`: `.godot/`, `build/`, `assets/music/`, `*.tmp`.
- [x] `hack_star_godot/tools/versions.json` (Godot `4.7.2`, GUT `9.7.1`, gdtoolkit `4.5.0`)
      and `tools/check_tools.ps1`: finds Godot (D1), compares `godot --version`, the GUT
      version in `addons/gut/plugin.cfg` (once Step 2 added it), `gdlint --version`, and the
      web export templates (`%APPDATA%\Godot\export_templates\4.7.2.stable\web_nothreads_release.zip`);
      prints OK or what to install for each, exit code 1 if anything is missing.
- [x] Install the tools on this computer as the README will say (winget, export templates
      from the editor's *Manage Export Templates*, `uv tool install gdtoolkit==4.5.0`).
- [x] Check: `tools/check_tools.ps1` reports Godot, gdtoolkit and the templates OK (GUT
      pending until Step 2); a new chat asked "where does a new Godot spec go?" answers
      `hack_star_godot/.specs/features/` (else add `.github/copilot-instructions.md`, D8);
      `git status` shows no change outside `hack_star_godot/` and `AGENTS.md`.

### Notes
Started: 2026-11-21 13:59

- Godot: winget installed 4.7.2 but created no alias (no admin; `WinGet\Links` is empty and not on PATH). `check_tools.ps1` finds it via `$env:GODOT`, else `godot` on the PATH, else `Godot_v*_win64_console.exe` under `%LOCALAPPDATA%\Microsoft\WinGet\Packages`.
- Export templates: extracted `version.txt`, `web_nothreads_debug.zip`, `web_nothreads_release.zip` from the `.tpz` (names as expected) into `%APPDATA%\Godot\export_templates\4.7.2.stable\`; download deleted.
- gdtoolkit 4.5.0 installed with `uv tool install` (`gdlint --version` = 4.5.0).
- GUT: reported "pending" while `project.godot` does not exist; once it exists a missing or wrong GUT fails (exit 1).
- The Check task stays unticked: its "new chat asked where a new Godot spec goes" part is run by the orchestrator, who ticks it. The tool part passed.
- New-chat check (orchestrator, Claude Opus 5.5): a fresh agent asked, with no hints, where a new Godot spec, its review page and cost list go and which test command replaces `npm test` answered `hack_star_godot/.specs/features/`, `hack_star_godot/.specs/review/`, `hack_star_godot/.specs/costs.md`, `hack_star_godot/tools/test.ps1`, citing `AGENTS.md` — passed; `.github/copilot-instructions.md` not needed.

**Done (2026-11-21 · ~15m · Claude Sonnet 5.5)** — Created `hack_star_godot/.specs/` (features/done, changes, review, guidelines/gdscript.md, spec-nx.json), `.gitignore`, `tools/versions.json`, `tools/check_tools.ps1`, root `AGENTS.md`; installed Godot 4.7.2, web templates, gdtoolkit 4.5.0. `tools/check_tools.ps1` parses cleanly, exit 0: Godot, templates and gdtoolkit OK, GUT pending; `git status` shows changes only in `hack_star_godot/` and `AGENTS.md`; the new-chat check is done by the orchestrator. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 1.12 M (54 k in · 1.06 M cached · 10 k out) · CHF 0.36 (43 credits)
---

## Step 2 — Godot project, start screen, test and lint

### Goal
A Godot 4.7 project that opens without errors and shows the start screen, with the test and
lint commands working (S9, S12, S16, S17).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `project.godot`: name "Hack star", features `4.7`, Compatibility renderer (D3), main
      scene `scenes/start_screen.tscn`, stretch mode `canvas_items` / aspect `expand` so it
      fits landscape and portrait, Input Map actions `move_left/right/up/down` (D11).
- [x] `scenes/start_screen.tscn` + `.gd`: title "Hack star" and a **Play** button (centred,
      large enough for a thumb); **Play** changes to `scenes/arena.tscn` (an empty
      placeholder until Step 3).
- [x] Add GUT 9.7.1 to `addons/gut/` from its GitHub release, with its `LICENSE.md`; enable
      the plugin (D6).
- [x] `tools/test.ps1` (D6) and `tools/lint.ps1` (D7); `.gdlintrc` only if a default rule
      clashes with the guideline.
- [x] First test `tests/test_start_screen.gd`: the scene loads, shows the title text and a
      Play button.
- [x] Check: the editor opens the project with no errors or warnings in the Output panel;
      `tools/test.ps1` passes (≥ 1 test), `tools/lint.ps1` passes, `tools/check_tools.ps1`
      all OK; running the project shows the start screen.

### Notes
Started: 2026-11-21 14:02

- Godot lookup moved into the shared `tools/godot.ps1` (`Find-Godot`), dot-sourced by `check_tools.ps1` and `test.ps1`.
- GUT 9.7.1 copied from the GitHub release `v9.7.1` (only `addons/gut/`; its `LICENSE.md` is inside that folder); `plugin.cfg` says 9.7.1; plugin enabled in `project.godot`.
- `test.ps1` imports, runs GUT (`-gdir=res://tests -ginclude_subdirs -gprefix=test_ -gexit`), exits 1 on a Godot error, a failing test (verified with a temporary failing test, removed) or when the summary shows no test.
- `lint.ps1` runs `gdlint` and `gdformat --check` on `game/`, `scenes/`, `tests/` when they exist; `game/` is not created yet. No `.gdlintrc` needed.
- The editor GUI is not available: the check is headless (`--import`, `--editor --quit-after 60`, `--quit-after 120`): no ERROR / WARNING / SCRIPT ERROR lines. The visual look is checked by the author / in the browser in Step 4.
- Godot writes `.uid` files next to scripts; they are committed (Godot 4.4+ practice). `.godot/` stays ignored.

**Done (2026-11-21 · ~10m · Claude Sonnet 5.5)** — Created `project.godot`, `scenes/start_screen.tscn/.gd`, placeholder `scenes/arena.tscn`, `tests/test_start_screen.gd`, `addons/gut/` (9.7.1), `tools/godot.ps1`, `test.ps1`, `lint.ps1`. Headless check: `test.ps1` passes (2 tests, exit 0; exit 1 with a failing test), `lint.ps1` OK, `check_tools.ps1` all OK (GUT 9.7.1), headless import / editor / run print no ERROR or WARNING lines; all scripts parse. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 1.64 M (49 k in · 1.58 M cached · 13 k out) · CHF 0.44 (52 credits)


---

## Step 3 — 3D arena with a fighter, keyboard and touch

### Goal
**Play** opens a 3D arena seen from above at an angle, with one fighter from simple shapes
that walks with the keyboard or a touch joystick, is stopped by walls, and a button back to
the start screen (S10).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `game/movement.gd`: the pure rule — from an input direction (length ≤ 1), speed and
      delta to a velocity on the ground plane; diagonal not faster; no input → stop.
- [ ] `scenes/arena.tscn` + `.gd`: floor and border walls (static bodies) and a few inner
      walls from box meshes (D10); a `Camera3D` above and behind at an angle that keeps the
      fighter in view in landscape and portrait; one light.
- [ ] `scenes/fighter.tscn` + `.gd`: a `CharacterBody3D` built from a capsule body, a sphere
      head and a direction marker in a bright colour; moves with `move_and_slide` using
      `game/movement.gd`; faces its direction.
- [ ] `scenes/touch_joystick.tscn` + `.gd` (D11): bottom-left, shown only on touch screens,
      gives a direction of length ≤ 1; keyboard and joystick feed the same rule.
- [ ] A **Back** button (top-left) returns to the start screen.
- [ ] Tests: `tests/test_movement.gd` (straight, diagonal not faster, stop, joystick length
      clamped); `tests/test_arena.gd` (the arena loads with fighter, camera and walls; after
      simulated frames pressing right against the east wall, the fighter stays inside).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` pass; in the editor (desktop window,
      then 820 × 1180 and 1180 × 820) the fighter walks with WASD and the arrows, stops at
      walls, Back works; the touch joystick checked with the editor's *Emulate Touch From
      Mouse*.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 4 — Web export and play in the browser

### Goal
One command exports the game for the web and the game plays in a desktop browser and in
Safari on an iPad at 30 frames per second or more; the browser is the only target (S11, S13, S18).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `export_presets.cfg`: preset `Web`, Thread Support off (D4), export path
      `build/web/index.html`; committed (it holds no secrets).
- [ ] `tools/export_web.ps1`: `godot --headless --path . --export-release "Web"
      build/web/index.html`; fails when `index.html`, `.wasm` or `.pck` is missing.
- [ ] `tools/serve_web.ps1` (D12): serves `build/web/` on port 8060 on the local network and
      prints `http://<this computer's address>:8060`.
- [ ] A small frames-per-second label in the arena (top-right), on in the exported game
      while this spec is being checked; a later spec may hide it.
- [ ] Check: `tools/export_web.ps1` succeeds from a clean `build/`; in a desktop browser
      (integrated browser) start screen → Play → walk → Back, no errors in the console;
      **on a real iPad (by the author):** Safari, landscape and portrait, touch joystick,
      the label shows ≥ 30 fps — result written in the Notes; `git status` shows nothing
      under `build/` or `.godot/`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — README, licences, final check

### Goal
The Godot folder is documented and licensed, the root README points to it, and the root game
still passes all its checks; the first game uses no server (S1, S5, S7, S8, S14, S15, S19).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/README.md`: what it is; install step by step on Windows (D1, D6, D7,
      export templates); run in the editor; `tools/check_tools.ps1`, `test.ps1`, `lint.ps1`,
      `export_web.ps1`, `serve_web.ps1`; play on an iPad; resources outside the folder (D13);
      how to write a Godot spec (the rule of `AGENTS.md`, D8) and the cost list (D9); the
      MIT licence of the repository (`../LICENSE`) and the fan-project disclaimer.
- [ ] `hack_star_godot/LICENSES.md`: own art built in code (D10); Godot Engine (MIT,
      © Godot Engine contributors) credited; GUT (MIT) in `addons/gut/`.
- [ ] Root `README.md`: one line that the Godot version lives in
      [hack_star_godot/](hack_star_godot/) with a link.
- [ ] Check the Godot folder: `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`,
      `tools/export_web.ps1` pass; follow the README's install part on the written steps
      once more and fix any gap.
- [ ] Check the root game is unchanged (S1): `cd server; uv run pytest`, `cd ui; npm test`,
      `npm run check`, `npm run build` pass; `git diff --stat main` shows changes only in
      `hack_star_godot/`, `AGENTS.md` and the one README line.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Native Windows, iPad or phone apps | Browser only for now (S18) | a later Godot spec |
| Rooms and hack codes over the network (FastAPI server or Godot's own) | No server in this spec (S19) | moved *MVP and Architecture* / *Play with Friends* specs (spec 02) |
| Music player and the developer page's music tools | No music in this spec (D13) | moved *Fighter Studio, Saves and Music* spec |
| Automatic checks on GitHub (CI) for the Godot folder | The repository has no CI today | a later spec, if wanted |
| Auto-approved Godot commands in `.vscode/settings.json` | Not needed to meet S1–S19 | when the Godot checks are run often |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S19 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass; the root `uv run pytest`, `npm test`, `npm run check` and `npm run build` still pass; READMEs updated
- [ ] Review · review page written in `hack_star_godot/.specs/review/`; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
