# Graphics Demo Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-mvp`
> **Issue:** #30
> **Moved from:** [2026_11_12_graphics_demo_spec.md](../../../.specs/features/done/2026_11_12_graphics_demo_spec.md) (#4)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_graphics_demo_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S1, S2, S3, S4, S7, S9, S10 revised; S12 (English) and S13 (what worked before) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #30 created (no parent) |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 3.35 M (144 k in · 3.16 M cached · 37 k out) | CHF 1.76 (210 credits) | Part 2 written (8 Steps: standard, reasoning, standard, standard, reasoning, standard, standard, light); also the requirements revision and the issue (`usage.ps1 -AgentName s06-lead` from 18:42:18) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 269 k (50 k in · 213 k cached · 5 k out) | CHF 0.17 (20 credits) | Step 1 done (`usage.ps1 -AgentName s06-step1`) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.39 M (102 k in · 3.26 M cached · 35 k out) | CHF 1.56 (186 credits) | Step 2 done (`usage.ps1 -AgentName s06-step2` from 18:51) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.90 M (101 k in · 1.79 M cached · 16 k out) | CHF 0.49 (59 credits) | Step 3 done (`usage.ps1 -AgentName s06-steps3-4` from 18:59:00 to 19:04:19) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.28 M (30 k in · 1.24 M cached · 10 k out) | CHF 0.25 (30 credits) | Step 4 done (`usage.ps1 -AgentName s06-steps3-4` from 19:04:19 to 19:07:10) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 4.31 M (135 k in · 4.14 M cached · 40 k out) | CHF 1.94 (231 credits) | Step 5 done (`usage.ps1 -AgentName s06-step5`) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.83 M (101 k in · 2.70 M cached · 25 k out) | CHF 0.65 (77 credits) | Step 6 done (`usage.ps1 -AgentName s06-steps6-7` from 19:21:59 to 19:36:40) |
---

# Part 1 · Requirements

## Context

Before adding game rules, Hack star needs an impressive, playable demo that looks like a
Brawl Stars match: a fighter running and shooting in a colourful arena. The rules (win, lose,
trophies) are kept out on purpose and come from F4 on. This is F3 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) and "Spec 2" in
[overall_req.md](../../../.specs/overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_graphics_demo_spec.md) (#4)
  — its numbers (speed 6/s, shots 16/s with range 9, cool-down 0.35 s, 480 damage, dummies
  2400 health) and its controls (left stick moves, right stick aims and fires on release, a
  quick tap fires at the nearest target) are the model.
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — S1–S3 (browser,
  screens, input), S6 (30 frames per second), S7 (own art) and S11 (3D from above at an angle)
  apply here too; the Godot technology, the architecture document
  `hack_star_godot/docs/architecture.md` and how to run the game (S12–S14); D5 (the screen
  sizes of the tests) and D6 (the device play-test stays with the author).
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — the Play button (S3) opens the arena; the
  selected fighter and skin (S5, S7); every Back goes home (S10); the UI foundation (S12).
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) — `OPENSESAME` makes every fighter
  selectable, so every fighter and skin can appear in the arena; the hacks change nothing in the
  arena (its S12).
- Checked 2026-11-21 (S0) in the code: **Play** on home opens `scenes/arena.tscn` (`arena.gd`):
  a 17 × 13 m floor, four border walls and four inner walls (`StaticBody3D` boxes in plain
  colours), a sun with shadows, a dark background; the camera looks down at 55° from behind and
  moves back until the **whole arena** fits the screen (`_frame_camera`, checked by
  `tests/test_arena.gd` and `tests/test_screen_sizes.gd` at five sizes); the HUD has **Back**
  (top-left, goes home), the `TouchJoystick` (bottom-left, visible only on a touch screen) and
  an FPS label (top-right). The fighter (`scenes/fighter.tscn`, `Fighter`) is a
  `CharacterBody3D` with an orange **capsule** look — not the selected fighter — moved by
  `Movement` (`game/movement.gd`: keyboard and joystick give one direction, 5 m/s, faces the
  way it walks) with `move_and_slide`, so it already stops at walls. The six fighters and 14
  skins are built in code by `FighterModel` (`scenes/fighter_model.gd`), which has only an
  **idle** animation; `GameState.selected_fighter` and `selected_skin()` hold the choice.
  Nothing is shot, there are no targets, bushes, effects or decoration, and all art is built in
  code from primitive meshes (no `assets/` yet).

**New:**
- The canyon arena (bigger, with rocks, cacti as bushes and decoration), the selected fighter
  in it with run and attack animations, a following camera, aiming and shooting with mouse and
  a second touch stick, three target dummies, bushes and effects.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–05) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. — checked 2026-11-21: S5, S6, S8, S11 fit;
  S1, S2, S3, S4, S7, S9, S10 revised (the arena, fighter, joystick and Back of specs 01 and
  04 are extended, the camera of spec 01 frames the whole arena, the web game is loaded once
  before Play); S12 (English) and S13 (what worked before) added; no open questions.
- **S1 — Arena:** The arena that **Play** opens (spec 01) becomes an arena seen from above at
  an angle, like Brawl Stars, with ground, walls, bushes and some decoration. _(revised
  2026-11-21: the Godot game already has an arena; it is extended, not replaced by a second
  one.)_
- **S2 — Your fighter:** The fighter and skin selected on the home screen (spec 04, S5 and S7)
  appear in the arena instead of the placeholder of spec 01, with idle, run and attack
  animations. _(revised 2026-11-21: spec 01's fighter is a placeholder shape, and the 3D
  fighters of spec 04 have only an idle animation.)_
- **S3 — Move:** On touch screens the fighter moves with the on-screen joystick on the left; on
  a desktop with WASD or the arrow keys (both from spec 01). The fighter cannot walk through
  walls, rocks or the target dummies. _(revised 2026-11-21: the controls exist since spec 01;
  the new solid things of the arena block the fighter too.)_
- **S4 — Attack:** On touch screens the fighter attacks with a second joystick on the right,
  aimed in the direction dragged and fired when released (a quick tap fires at the nearest
  target); on a desktop with the mouse (aim) and click. Shots fly visibly and stop at walls,
  rocks and targets. _(revised 2026-11-21: "a button or joystick" decided as the joystick of
  the original game; what stops a shot named.)_
- **S5 — Targets:** The arena has 3 target dummies with a health bar; a hit shows an effect
  and a damage number, and a dummy with no health left breaks apart and comes back after
  5 seconds.
- **S6 — Bushes:** The fighter becomes partly transparent while standing in a bush.
- **S7 — Camera:** The camera follows the fighter smoothly and the whole fighter is always
  visible, in landscape and portrait on desktop, iPad and phone; the arena may be larger than
  the screen. _(revised 2026-11-21: spec 01's camera shows the whole arena at once; now it
  follows the fighter, as in Brawl Stars.)_
- **S8 — Effects:** Movement and attacks have visible effects (dust when running, muzzle flash,
  hit sparks) that make the demo look lively.
- **S9 — Leave:** The arena's **Back** button (top-left, spec 04 S10) returns to the home
  screen at any time. _(revised 2026-11-21: the Godot arena already has Back.)_
- **S10 — Smooth on iPad:** The demo runs at 30 frames per second or more on a recent iPad and
  phone, and the arena is playable within 5 seconds after **Play** is tapped. _(revised
  2026-11-21: the web game loads once at the start, so the 5 seconds count from Play; the
  device play-test stays with the author, spec 03 D6.)_
- **S11 — One arena:** There is one arena with a sunny canyon theme (sand, rocks, cacti as
  bushes); the target dummies stand still.
- **S12 — Language:** All new text (the damage numbers and any label) is in English;
  translations come with [spec 15](2026_11_13_15_accounts_fighters_and_languages_spec.md).
  _(added 2026-11-21: the Godot game has no languages yet, `docs/architecture.md`.)_
- **S13 — What worked before:** Home, the fighter list, the fighter screen, the info page,
  the hack screen and the QR page work as before, and the arena keeps its FPS label. _(added
  2026-11-21: the arena is shared with the screens of specs 01–05.)_

### Open questions

_None. Answered 2026-11-12 with the suggested defaults (S11); more arenas and moving targets
are for later specs. S0 check 2026-11-21 raised no new question: the revisions above take the
simplest reading that fits the Godot game (the attack control of S4 is the original game's
right joystick)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Combat rules | standard (Claude Sonnet 5.5) — pure rules and their tests, numbers fixed by D3 | ✅ Done | [→ Step 1](#step-1--combat-rules) |
| **2** | Canyon arena | reasoning (Claude Opus 5.5) — graphics-heavy: a bigger arena built in code (rocks, cacti, decoration, light) that must look good and stay fast (D1, D2, D10) | ✅ Done | [→ Step 2](#step-2--canyon-arena) |
| **3** | Your fighter and the following camera | standard (Claude Sonnet 5.5) — reuses `FighterModel` and the camera math of spec 01, fixed by D4 and D5 | ✅ Done | [→ Step 3](#step-3--your-fighter-and-the-following-camera) |
| **4** | Run and attack animations | standard (Claude Sonnet 5.5) — two more animation states on the existing rig (D6) | ✅ Done | [→ Step 4](#step-4--run-and-attack-animations) |
| **5** | Aiming and shooting | reasoning (Claude Opus 5.5) — mouse and touch at the same time (emulated mouse, GUI clicks), a second stick, a tap rule, shots with ray casts (D7, D8) | ✅ Done | [→ Step 5](#step-5--aiming-and-shooting) |
| **6** | Target dummies | standard (Claude Sonnet 5.5) — one small scene with a health bar, a damage number and a respawn timer (D9) | ✅ Done | [→ Step 6](#step-6--target-dummies) |
| **7** | Bushes and effects | standard (Claude Sonnet 5.5) — see-through in a bush and small particle pools, fixed by D10 and D11 | ⬜ Not started | [→ Step 7](#step-7--bushes-and-effects) |
| **8** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks, measuring the frame rate and updating two documents | ⬜ Not started | [→ Step 8](#step-8--final-check-readme-and-architecture) |

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
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../AGENTS.md)). Each
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0. Nothing in `server/` or `ui/`
> changes, and the demo calls no server (D12). **Looks are checked on real screenshots:** a
> windowed Godot run with a temporary capture script (saved under `%TEMP%`, viewed, then
> removed, never committed), at 1280×720 and 390×844 unless the Step says otherwise.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **Extend the arena of spec 01, don't add a second one:** `scenes/arena.tscn` + `arena.gd` stay the scene that **Play** opens (`Screens.ARENA`), with its `Fighter`, `Camera`, `Hud/BackButton`, `Hud/TouchJoystick` and `Hud/FpsLabel`. The hand-placed walls of the `.tscn` are replaced by the canyon built in code (D2); the node names `Floor` (a `StaticBody3D`) and `Walls` (only `StaticBody3D` children) are kept, so the tests of spec 01 keep their meaning. | S1, S13: the spec 01–04 screens and tests keep working; one arena (S11). |
| D2 | **The canyon layout is data, the scenery is built from it:** `game/arena_layout.gd` (`ArenaLayout`, pure) holds the arena on the ground plane (x right, z towards the camera, as `Movement`): size 20 × 26 m (`SIZE`), the border and the rock blocks as `Rect2` (`WALLS`), the cactus patches (`BUSHES`, `Rect2`), the decoration spots with a kind (`DECORATION`: crates, skulls, small rocks, bones — no collision), the 3 dummy spots (`DUMMIES`), the start point (`START`, near the camera side) and `in_bush(point)`, `is_free(point, radius)`. `scenes/canyon.gd` (`Canyon`, a `Node3D` in `arena.tscn`) builds from it at `_ready`: sand floor (one big box plus a `MultiMeshInstance3D` of slightly different sand tiles), canyon rock walls (boxes with a darker top and a few stacked rocks, low on the camera side so they never hide the fighter), cacti for the bushes, decoration meshes, a warm sky colour (`Environment` background), a sun with shadows (`directional_shadow_max_distance` ≈ 40). Materials: toon-like `StandardMaterial3D` (`diffuse_mode` toon, `specular_mode` disabled) in a sand/terracotta/green palette like the fighters. | S1, S3, S11: the layout can be tested without a scene; rocks and walls block through their `StaticBody3D`s; own art built in code (spec 03, S7), nothing to license; MultiMesh keeps draw calls low on an iPad (S10). |
| D3 | **Combat rules are pure:** `game/combat.gd` (`Combat`) with the original game's numbers: `SHOT_SPEED` 16 m/s, `SHOT_RANGE` 9 m, `COOLDOWN` 0.35 s, `DAMAGE` 480, `DUMMY_HEALTH` 2400 (5 hits), `RESPAWN_SECONDS` 5.0, `AIM_DEAD_ZONE` 0.3, `TAP_SECONDS` 0.25; functions `can_fire(now, last_fire)`, `take_damage(health, amount)` (never below 0), `is_broken(health)`, `health_ratio(health)`, `health_color(ratio)` (green, yellow below 0.5, red below 0.25), `release_aim(direction, held_seconds)` (an aim direction, `Vector2.ZERO` for "nearest target", or no shot), `nearest_target(from, targets, max_range)` (index or -1) and `ground_point(ray_origin, ray_direction, height)` (where a mouse ray meets the plane y = height). The fighter keeps the 5 m/s of spec 01. | S4, S5: rules testable without a scene (architecture, *Game rules*); the numbers are the model's (original spec, Step 1). |
| D4 | **The selected fighter replaces the capsule:** `scenes/fighter.tscn` loses its placeholder meshes (`Body`, `Head`, `Nose`, `Chest`) and gets a `Model` (`FighterModel`, turned by π so its front faces the fighter's forward −z) and a `Muzzle` (`Marker3D`, 0.7 m in front, 0.9 m up). `Fighter.set_look(fighter_id, skin_id)` calls `Model.setup`; `arena.gd` calls it in `_ready` with `GameState.selected_fighter` and `GameState.selected_skin()`, and places the fighter at `ArenaLayout.START`. The collision capsule (radius 0.4) stays. | S2: the fighters of spec 04 reused, not rebuilt; `OPENSESAME` (spec 05) works without any change. |
| D5 | **The camera follows:** the pitch of 55° from behind stays; on `size_changed`, `arena.gd` computes the distance (as `_frame_camera` does today) so that a box of ±7 m (x) and ±5 m (z) around the fighter fits the screen with the margins of spec 01, then every frame the camera's look-at point moves towards the fighter (plus 1 m ahead in −z) with exponential smoothing (`Movement.follow(current, target, delta, rate)`, rate 6/s). No clamping at the arena edges. `ARENA_CORNERS` and the "whole arena in view" tests are replaced by "the fighter's feet and head are in view" at the five sizes of spec 03, D5, also after the fighter walked into a corner. | S7: like Brawl Stars; the bigger arena (D2) no longer fits a phone in portrait; a pure smoothing rule is testable. |
| D6 | **Run and attack animations in `FighterModel`:** `running: bool` (set by `Fighter` when its velocity is above 0.1 m/s) switches `animate(time)` from idle to run: a bounce of `abs(sin)` at 10/s, a forward lean of the `Rig` of about 0.18 rad and a faster head bob; `play_attack()` starts a 0.25 s recoil (the `Body` kicks back and squashes, then springs back) that runs on top of idle or run (`attack_left` counts down in `_process`). Built on the existing `Rig` / `Body` / `Head` nodes, the same for all six fighters. | S2: one animation code for all fighters, like the idle one; testable through `animate(time)` and `attack_left`. |
| D7 | **Controls:** left: the `TouchJoystick` of spec 01 (unchanged, moves). Right: a second `TouchJoystick` instance `Hud/AimJoystick` (bottom-right, visible only on a touch screen); `TouchJoystick` gets a signal `released(direction, held_seconds)`; `arena.gd` passes it to `Combat.release_aim`: dragged past the dead zone → fire that way; a quick tap → fire at the nearest dummy in range (else straight ahead). While the aim stick is dragged a thin aim line lies on the ground. Desktop: the mouse ray meets the ground (`Combat.ground_point`), the fighter turns towards it while firing; left button fires and holding it keeps firing with the cool-down. Mouse events from touch emulation (`InputEvent.DEVICE_ID_EMULATION`) are ignored, and the arena reads the mouse in `_unhandled_input`, so a click on **Back** or a touch on a stick never fires. The fighter turns to the aim direction when it fires. | S4, S3: the original game's controls (its D5); one touch never counts twice. |
| D8 | **Shots:** `scenes/shot.gd` (`Shot`, a `Node3D` with a glowing sphere in the fighter's `main_color`, unshaded with emission) flies at `SHOT_SPEED` at 0.9 m height; every physics frame it casts a ray (`PhysicsDirectSpaceState3D.intersect_ray`) from its last to its next position against the world and target layers (D13) and stops at the first wall, rock or dummy, or after `SHOT_RANGE`; on a dummy it calls `hit(DAMAGE)`; it emits `ended(position, hit_something)` and frees itself. The arena's `Shots` node holds them. | S4: ray casts never miss a thin wall at 16 m/s; no physics body per shot. |
| D9 | **Target dummies:** `scenes/target_dummy.tscn` + `.gd` (`TargetDummy`, a `StaticBody3D` on the target layer, so the fighter cannot walk through it): straw body on a post with a painted target, built from primitive meshes; a health bar of two billboard quads above it (green/yellow/red from `Combat.health_color`); `hit(amount)` lowers `health`, flashes white for 0.1 s and shows the damage number (a billboard `Label3D`, e.g. "480", rising and fading in 0.8 s); at 0 it breaks apart (the parts fly out and fall, collision off, bar hidden) and after `respawn_seconds` (default `Combat.RESPAWN_SECONDS`, smaller in tests) comes back with full health and a pop. Three at `ArenaLayout.DUMMIES`, standing still. | S5, S11, S12: one scene used three times; testable by calling `hit`. |
| D10 | **Effects are small pools:** `scenes/arena_effects.gd` (`ArenaEffects`, in the arena) owns a few one-shot `CPUParticles3D` per kind — dust (4), muzzle flash (3), hit sparks (4) — built in code, and `play(kind, position, color)` restarts the next one of that kind at the position. Dust plays every 0.25 s while the fighter runs; the flash at `Muzzle` on every shot; sparks where a shot ends. No `GPUParticles3D`. | S8, S10: `CPUParticles3D` works in the Compatibility renderer on WebGL (as the home entrance of spec 04); reusing nodes avoids creating nodes every frame on a phone. |
| D11 | **See-through in a bush:** every physics frame `arena.gd` asks `ArenaLayout.in_bush(fighter position)`; `FighterModel.set_see_through(on)` sets `GeometryInstance3D.transparency` of its meshes to 0.55 (0 when off). If the Compatibility renderer does not show it (checked on a screenshot), the Step switches the fighter's materials to alpha instead and notes it. | S6: one pure rule decides; the look is checked on a screenshot. |
| D12 | **No server and English:** the demo calls no server and saves nothing; the only new text is the damage numbers (numbers) — any other label is English (spec 15 translates). | S12; the demo is local like the original's D1. |
| D13 | **Physics layers** (named in `project.godot`): 1 `world` (floor, walls, rocks), 2 `fighter`, 3 `targets` (dummies). The fighter's mask is world + targets; shots cast against world + targets. | S3, S4: one place says what blocks what. |
| D14 | **Tests:** `test_combat.gd`, `test_arena_layout.gd` (start, dummies and bushes free of walls, `in_bush`), `test_movement.gd` (`follow`), `test_arena.gd` (walls from the layout, the selected fighter's model, the camera follows, a shot stops at a wall, a shot lowers a dummy, a broken dummy comes back, the see-through in a bush, Back), `test_fighter_model.gd` (run and attack), `test_touch_joystick.gd` (`released`), `test_target_dummy.gd`, `test_shot.gd`, `test_screen_sizes.gd` (the aim stick inside, the fighter in view at five sizes). Mouse and touch are pushed as real events with `tests/ui_input.gd`. | Every statement checked by a test or a screenshot; the device play-test stays with the author (spec 03, D6). |

---

## Step 1 — Combat rules

### Goal
The rules of shooting and targets exist and are tested without a scene (S4, S5).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/combat.gd` (`Combat`) after D3.
- [x] `Movement.follow(current, target, delta, rate)` (exponential smoothing for the camera, D5).
- [x] Tests: `tests/test_combat.gd` (cool-down; 5 hits break a dummy, health never below 0;
      ratio and colours at 1, 0.4, 0.2; `release_aim`: a drag past the dead zone, a quick tap,
      a short drag inside the dead zone held long; `nearest_target` with none in range, two
      targets; `ground_point` of a ray looking down at 55°) and `follow` in
      `tests/test_movement.gd` (moves part of the way, reaches the target after a long time,
      no overshoot).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 18:49

**Done (2026-11-21 · ~2 min · Claude Sonnet 5.5)** — `game/combat.gd` (`Combat`, D3; `release_aim` returns `Combat.NO_SHOT` = `Vector2.INF` for no shot, `ground_point` returns `Vector3.INF` when the ray never meets the plane; positions are ground-plane `Vector2`), `Movement.follow`, tests in `tests/test_combat.gd` and `tests/test_movement.gd`. `tools/test.ps1` 185 tests passed, `tools/lint.ps1` exit 0; suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~269 k tokens · ~CHF 0.17

---

## Step 2 — Canyon arena

### Goal
**Play** opens a sunny canyon with sand, rock walls and rocks, cacti as bushes and decoration;
the fighter still walks and stops at every wall and rock (S1, S3, S6, S11).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/arena_layout.gd` (`ArenaLayout`) after D2; physics layer names of D13 in
      `project.godot`.
- [x] `scenes/canyon.gd` (`Canyon`) after D2, in `arena.tscn`; the old hand-placed walls and
      materials of the `.tscn` removed; `Floor` and `Walls` kept (D1); the fighter starts at
      `ArenaLayout.START`. Until Step 3 the camera still frames the whole (bigger) arena:
      `ARENA_CORNERS` follow `ArenaLayout.SIZE`.
- [x] Tests: `tests/test_arena_layout.gd` (start, dummy spots and bushes do not overlap walls;
      `in_bush` inside and outside a patch; every wall inside the arena); `tests/test_arena.gd`
      updated (walls built from the layout, the fighter stops at the east border and at one
      rock block).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of the arena at
      1280×720 and 390×844: sand, canyon walls, cacti and decoration are clearly visible,
      colourful and sunny, nothing hides the fighter; the FPS label of a windowed desktop run
      is noted.

### Notes
Started: 2026-11-21 18:51

- Layout: 20 × 26 m, 4 border walls + 7 rock blocks (`ArenaLayout.BORDER_COUNT` = 4), 4 cactus
  patches, 12 decoration spots, dummies at (−4, −2.5), (4, −2.5), (0, −9), start (0, 9.5); the
  centre rock lies straight north of the start (used by the rock test).
- `Canyon` gets `Floor` and `Walls` as exported nodes and builds into them; wall heights 2.2 m
  (border), 0.7 m (camera side), 1.4 m (rocks) — `Canyon.wall_height(index)`. Sand tiles,
  boulders (on the walls and outside the arena) and cacti are four MultiMeshes with per-instance
  colours; decoration and walls are plain meshes with cached toon materials. The warm sky,
  ambient light and the sun (energy 0.8, `directional_shadow_max_distance` 40) are set in
  `arena.tscn`. The fighter is on layer 2 `fighter` with mask `world` + `targets` (D13).
- `CAMERA_MAX_DISTANCE` raised from 60 to 120 m so the whole 20 m wide arena still fits a phone
  in portrait until Step 3.
- Screenshots (windowed run, temporary capture script under `%TEMP%`, removed): first run too
  pale (sand nearly white, the outside blended with the sky, bones looked like sparkles, skull
  eyes inside the head) → richer sand and rock colours, darker outside ground, cooler and
  weaker ambient light, sun 1.1 → 0.8, bigger bones and skulls. Final at 1280×720 and 390×844:
  checkered sand, red canyon walls with boulders, green cacti with pink flowers, crates, skulls,
  bones and rocks clearly visible; the fighter (still the capsule) visible, nothing hides it.
  FPS label of the windowed desktop run: **60**.

**Done (2026-11-21 · ~8 min · Claude Opus 5.5)** — `game/arena_layout.gd` (`ArenaLayout`), `scenes/canyon.gd` (`Canyon`), `arena.tscn` (hand-placed walls removed, `Canyon` node, warm light), `arena.gd` (start at `ArenaLayout.START`, `ARENA_CORNERS` from `ArenaLayout.SIZE`), D13 layer names in `project.godot`, fighter layers; tests `tests/test_arena_layout.gd` (7) and `tests/test_arena.gd` (walls from the layout, start, east border, rock). `tools/test.ps1` 195 tests passed, `tools/lint.ps1` exit 0, screenshots checked (FPS 60); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.39 M tokens · CHF 1.56 (186 credits)

---

## Step 3 — Your fighter and the following camera

### Goal
The selected fighter and skin stand in the arena, and the camera follows them smoothly on every
screen size; Back still goes home (S2, S3, S7, S9, S13).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `Fighter` after D4 (`Model`, `Muzzle`, `set_look`); `arena.gd` sets the look from
      `GameState` in `_ready`.
- [x] Following camera after D5 in `arena.gd` (`ARENA_CORNERS` and the whole-arena framing
      removed).
- [x] Tests: `tests/test_arena.gd` (with `GameState.select("rocko", "crystal")` the fighter's
      model is Rocko in Crystal; the model faces the walking direction; after walking east for
      1 s the camera's look-at point moved east; Back goes home);
      `tests/test_screen_sizes.gd` (`test_arena_fits_every_size`: Back, joystick and FPS label
      inside, and the fighter's feet and head in view at the five sizes, also after walking
      into the north-east corner).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots at 1280×720, 390×844
      and 844×390 with two different fighters (one Legendary skin): the whole fighter visible,
      the camera does not jump.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 4 — Run and attack animations

### Goal
The fighter has idle, run and attack animations (S2).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `FighterModel`: `running`, run animation and `play_attack()` after D6; the idle of
      spec 04 unchanged (home, fighter screen and pictures look the same).
- [x] `Fighter` sets `Model.running` from its velocity.
- [x] Tests: `tests/test_fighter_model.gd` (running leans the `Rig` forward and bounces the
      `Body`; idle leaves the `Rig` straight; `play_attack` sets `attack_left`, which is 0
      again after 0.3 s of `_process`); `tests/test_arena.gd` (walking sets `running`,
      standing clears it).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of a running fighter
      and of the attack recoil (a few frames apart) for two fighters with different shapes
      (e.g. Blaze and Frosty).

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 5 — Aiming and shooting

### Goal
The fighter shoots with the mouse on a desktop and with the right stick (or a tap) on a touch
screen; shots fly visibly and stop at walls and rocks (S4, S12).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `TouchJoystick`: signal `released(direction, held_seconds)`; `Hud/AimJoystick`
      bottom-right in `arena.tscn` (same size as the left one).
- [x] `scenes/shot.gd` (`Shot`) after D8; `arena.gd` fires after D7 (cool-down from
      `Combat.can_fire`, the fighter turns to the aim, `Model.play_attack()`, a shot from
      `Muzzle`), the aim line while the right stick is dragged.
- [x] Tests: `tests/test_shot.gd` (a shot towards a wall ends at the wall; without a wall it
      ends after `SHOT_RANGE`); `tests/test_touch_joystick.gd` (`released` with the direction
      and the time held); `tests/test_arena.gd` (a left click on the ground fires one shot
      towards the click; holding fires again only after the cool-down; an emulated mouse event
      does not fire; a click on Back does not fire; releasing the aim stick after a drag fires
      that way; a quick tap fires); `tests/test_screen_sizes.gd` (the aim stick inside at the
      five sizes and not overlapping the left stick or Back).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of shots in flight and
      of a shot stopping at a rock, at 1280×720 and 390×844 (the aim stick made visible for the
      capture).

### Notes
Started: 2026-11-21 19:07

- `TouchJoystick` emits `released(direction, held_seconds)` (the direction before it resets,
  the time from `Time.get_ticks_msec`) and has `is_held()`; `Hud/AimJoystick` is a second
  instance anchored bottom-right (240 × 240, 32 px margins). At 390×844 the content is 650 px
  wide, so the two sticks never overlap (tested at the five sizes).
- `arena.gd`: `fire(direction)` (cool-down, turn, `play_attack`, a `Shot` from `Muzzle` in the
  fighter's `main_color` into `Shots`); the mouse in `_unhandled_input` (emulated events
  ignored; holding the button fires again in `_process` after the cool-down; the fighter turns
  to where the mouse ray meets the ground); the aim stick's `released` goes through
  `Combat.release_aim`; a quick tap aims at the nearest node of the group `targets` in range
  (Step 6 puts the dummies there), else straight ahead; `AimLine` (a 9 m flat box in
  `arena.tscn`) lies on the ground while the stick is dragged past the dead zone.
- **Differs from D4:** `Muzzle` is 0.6 m up instead of 0.9 m — the border on the camera side
  is only 0.7 m high (D2), so shots at 0.9 m flew over it; at 0.6 m they stop there too
  (tested: a tap fires south and the shot ends at the low wall).
- `Shot` shares its meshes and materials per colour (static caches), so firing creates no new
  resources: a white core, a ball of the fighter's colour, a see-through halo and a tail, all
  unshaded.
- Screenshots (windowed run, temporary capture script under `%TEMP%`, removed): first look too
  small and pale (additive blending washed out on the bright sand) → bigger ball, alpha-blended
  halo and tail in the saturated colour. Final at 1280×720 and 390×844: a shot in flight east
  with its tail, a shot just before the centre rock, the aim line and the aim stick visible.
  FPS of the windowed desktop run while firing continuously for 7 s: **60**.

**Done (2026-11-21 · ~14 min · Claude Opus 5.5)** — `TouchJoystick.released`/`is_held`, `Hud/AimJoystick`, `AimLine` and `Shots` in `arena.tscn`, `scenes/shot.gd` (`Shot`), firing in `arena.gd` (mouse, aim stick, tap), `Muzzle` at 0.6 m; tests `tests/test_shot.gd` (2), `tests/test_touch_joystick.gd` (`released`), `tests/test_arena.gd` (6: click, hold and cool-down, emulated click, Back, drag-release, tap to the low wall), `tests/test_screen_sizes.gd` (aim stick inside, apart from the left stick and Back). `tools/test.ps1` 209 tests passed, `tools/lint.ps1` exit 0, screenshots checked (FPS 60); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 4.31 M tokens · CHF 1.94 (231 credits)

---

## Step 6 — Target dummies

### Goal
Three still target dummies take hits with an effect and a damage number, break apart at zero
health and come back after 5 seconds; the fighter cannot walk through them (S3, S5, S11, S12).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `scenes/target_dummy.tscn` + `.gd` (`TargetDummy`) after D9; three in the arena at
      `ArenaLayout.DUMMIES`; `nearest_target` of the tap (Step 5) uses them.
- [x] Tests: `tests/test_target_dummy.gd` (`hit` lowers health and the bar, shows a
      "480" label; 5 hits break it and turn its collision off; it is back with full health
      after `respawn_seconds`); `tests/test_arena.gd` (three dummies; a shot fired at a dummy
      lowers its health; the fighter stops at a dummy; a quick tap aims at the nearest one).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of a dummy with a
      lowered (yellow) bar and a damage number, of it breaking apart and of it back after
      5 s.

### Notes
Started: 2026-11-21 19:22

- `TargetDummy` (`StaticBody3D`, layer 3, group `targets` set in the scene) builds its parts
  in code (post, straw body, arms, head, three painted rings); the bar is two billboard
  quads (the fill's mesh is resized and coloured by `Combat.health_color`); the damage
  number is a billboard `Label3D` that rises and fades in 0.8 s; the hit flash is a white
  `material_overlay` for 0.1 s; at 0 the parts fly out and fall, then after `respawn_seconds`
  they return, with a pop. Signals `broken` and `respawned`. `arena.gd` spawns the three
  dummies into `Dummies`; a tap skips a broken dummy.
- The arena tests are in `tests/test_arena_dummies.gd` (not `test_arena.gd`): `gdlint` allows
  at most 20 public test functions per file and `test_arena.gd` was full.
- Screenshots (windowed run, temporary capture script under `%TEMP%`, removed) at 1280×720:
  one dummy with a yellow bar and "480", the same breaking apart (parts in the air), and back
  with a full green bar after 5 s. The dummies read as target dummies; the damage number is
  large enough to read.

**Done (2026-11-21 · ~15 min · Claude Sonnet 5.5)** — `scenes/target_dummy.tscn` + `.gd`, `Dummies` in `arena.tscn` and `arena.gd`; tests `tests/test_target_dummy.gd` (5), `tests/test_arena_dummies.gd` (4). `tools/test.ps1` 218 tests passed, `tools/lint.ps1` exit 0, screenshots checked; suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.83 M tokens · CHF 0.65 (77 credits)

---

## Step 7 — Bushes and effects

### Goal
The fighter is see-through in a cactus patch, and running and shooting have dust, a muzzle
flash and hit sparks (S6, S8).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `FighterModel.set_see_through(on)` and the bush check in `arena.gd` after D11.
- [ ] `scenes/arena_effects.gd` (`ArenaEffects`) after D10; dust while running, flash on every
      shot, sparks where a shot ends (also on a dummy).
- [ ] Tests: `tests/test_arena.gd` (standing in a bush makes the model see-through, leaving
      it makes it solid; a shot plays a flash; a shot that ends plays sparks; running plays
      dust; the pools never grow beyond their size).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots of the fighter in a
      cactus patch (see-through, D11 fallback noted if needed), of dust while running, of a
      muzzle flash and of sparks on a dummy.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Step 8 — Final check, README and architecture

### Goal
Everything that worked before still works, the demo is smooth, all Godot checks pass, and the
README and the architecture describe the demo (S10, S13, all statements).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/docs/architecture.md`: Screens (the arena: canyon, fighter, aim stick,
      dummies, effects, following camera instead of "the whole arena"), Game rules
      (`Combat`, `ArenaLayout`, `Movement.follow`), 3D models (the canyon, dummies, shots and
      effects built in code; the run and attack animations), the new scenes (`Canyon`, `Shot`,
      `TargetDummy`, `ArenaEffects`), the physics layers (D13), Tests.
- [ ] `hack_star_godot/README.md`: how to play the demo (keys, mouse, left and right stick,
      tap; dummies; bushes) in *Controls*.
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); `git diff --stat` of this spec shows nothing in `server/` or `ui/`.
- [ ] A windowed desktop run and the web export in a desktop browser (`tools/serve_web.ps1`):
      the FPS label while running and shooting (≥ 30) and the time from **Play** to a playable
      arena (≤ 5 s) noted; home, fighter list, fighter screen, info, hack screen and QR page
      open as before (S13).
- [ ] Note in Notes that the device play-test (iPad and phone: both sticks, ≥ 30 frames per
      second, the arena within 5 s after Play) stays with the author (spec 03, D6, Deferred
      Items).

### Notes
_Add the `Done` line here when the Step is finished._

<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Play-test on a real iPad and phone (both sticks, ≥ 30 frames per second, arena within 5 s after Play) | Needs a person with the devices (spec 03, D6) | the author, before spec 08 is closed |
| Shots that hurt fighters, winning and losing | The demo has no rules on purpose (Context) | [07 First match](2026_11_12_07_first_match_spec.md) |
| Super attacks | Not part of the demo | [12 Super and hypercharge](2026_11_12_12_super_and_hypercharge_spec.md) |
| More arenas and moving targets | One arena with still dummies (S11) | a later spec (not in the ordered list yet) |
| Translations of new text | English only (S12, D12) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `tools/test.ps1`, `tools/lint.ps1`, `tools/check_tools.ps1` and `tools/export_web.ps1` pass; `hack_star_godot/README.md` / `docs/architecture.md` updated
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · one pull request for the whole MVP branch at the end (not per spec)
