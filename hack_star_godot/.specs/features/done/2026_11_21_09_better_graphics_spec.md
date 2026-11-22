# Better Graphics Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress — reopened 2026-11-22: two characters, views, lighting
> **Created:** 2026-11-22
> **Last updated:** 2026-11-22
> **Branch:** `feature/better-graphics`
> **Issue:** #35

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 3.90 M (143 k in · 3.73 M cached · 27 k out) | CHF 1.67 (200 credits) | Part 1 written (screenshots of both games compared; web research for part B) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: Q1–Q7 answered (Q4–Q7 the suggestions) and moved into the statements (A2, A3, B6, G1, G3, G5, new G17, G18); group W added (W1–W7, a new world built with ProtonScatter, repository checked); A0 added |
| 2026-11-22 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #35 created (no parent) |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 2.87 M (138 k in · 2.69 M cached · 50 k out) | CHF 1.86 (222 credits) | Part 2 written: 20 Steps, all reasoning (Claude Opus 5.5) per S1; Step 14 is the gate for the author's drawing (A0) (agent `s09g-lead`; requirements revision and issue included) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.82 M (117 k in · 2.69 M cached · 13 k out) | CHF 1.15 (138 credits) | Step 1 done (`usage.ps1 -AgentName s09g-steps1-3` from 12:35:00 to 12:42:16) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 8.99 M (88 k in · 8.86 M cached · 39 k out) | CHF 2.50 (298 credits) | Step 2 done (`usage.ps1 -AgentName s09g-steps1-3` from 12:42:16 to 12:55:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 10.98 M (93 k in · 10.84 M cached · 41 k out) | CHF 2.89 (345 credits) | Step 3 done (`usage.ps1 -AgentName s09g-steps1-3` from 12:55:30 to 13:11:15) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.56 M (72 k in · 7.45 M cached · 38 k out) | CHF 2.19 (261 credits) | Step 4 done (`usage.ps1 -AgentName s09g-steps4-6` from 13:12:53 to 13:22:37) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.15 M (48 k in · 7.08 M cached · 22 k out) | CHF 1.75 (208 credits) | Step 5 done (`usage.ps1 -AgentName s09g-steps4-6` from 13:22:37 to 13:30:18) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 11.32 M (74 k in · 11.20 M cached · 39 k out) | CHF 2.84 (339 credits) | Step 6 done (`usage.ps1 -AgentName s09g-steps4-6` from 13:30:18 to 13:42:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.48 M (121 k in · 5.33 M cached · 25 k out) | CHF 1.82 (217 credits) | Step 7 done (`usage.ps1 -AgentName s09g-steps7-9` from 13:43:19 to 13:50:52) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.19 M (251 k in · 5.92 M cached · 25 k out) | CHF 2.47 (295 credits) | Step 8 done (`usage.ps1 -AgentName s09g-steps7-9` from 13:51:50 to 14:13:07) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.44 M (49 k in · 6.37 M cached · 19 k out) | CHF 1.60 (190 credits) | Step 9 done (`usage.ps1 -AgentName s09g-steps7-9` from 14:13:42 to 14:21:06) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 4.78 M (125 k in · 4.63 M cached · 23 k out) | CHF 1.68 (201 credits) | Step 10 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:22:23 to 14:30:28) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 10.98 M (91 k in · 10.84 M cached · 44 k out) | CHF 2.93 (349 credits) | Step 11 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:31:56 to 14:44:53) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 12.65 M (86 k in · 12.52 M cached · 43 k out) | CHF 3.18 (379 credits) | Step 12 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:45:43 to 14:56:09) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 13.27 M (54 k in · 13.18 M cached · 37 k out) | CHF 3.05 (364 credits) | Step 13 done (`usage.ps1 -AgentName s09g-steps10-13` from 14:56:50 to 15:09:25) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 650 k (30 k in · 614 k cached · 6 k out) | CHF 0.32 (39 credits) | Step 14 done (`usage.ps1 -AgentName s09g-step14` from 15:12:33 to 15:13:43) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.32 M (95 k in · 2.22 M cached · 12 k out) | CHF 0.97 (116 credits) | Step 15 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:14:29 to 15:19:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 18.96 M (132 k in · 18.75 M cached · 74 k out) | CHF 4.94 (589 credits) | Step 16 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:19:28 to 15:44:13) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.84 M (31 k in · 5.78 M cached · 24 k out) | CHF 1.50 (179 credits) | Step 17 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:44:41 to 15:57:30) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.49 M (114 k in · 2.36 M cached · 15 k out) | CHF 1.13 (135 credits) | Step 18 done (`usage.ps1 -AgentName s09g-steps18-20` from 15:58:18 to 16:03:41) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 434 k (4 k in · 427 k cached · 3 k out) | CHF 0.14 (17 credits) | Step 19 prepared, trial deferred (`usage.ps1 -AgentName s09g-steps18-20` from 16:04:13 to 16:06:57) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.86 M (61 k in · 5.78 M cached · 20 k out) | CHF 1.57 (187 credits) | Step 20 done; the G1 verdict, A3, the iPad play-test and the B6 trial wait for the author (`usage.ps1 -AgentName s09g-steps18-20` from 16:07:28 to 16:17:13) |
| 2026-11-22 | review | `REVIEW:` | Claude Opus 5.5 | 16.93 M (258 k in · 16.61 M cached · 67 k out) | CHF 4.99 (595 credits) | semantic diff written: change record `changes/better-graphics/` (16 blocks), review page [2026-11-22_better-graphics.html](../../review/2026-11-22_better-graphics.html) and index row, PR text `semantic_diff.md`; checks 6 pass · 2 n/a · 1 fail (agent `s09g-review`; `CODE REVIEW:` included) |
| 2026-11-22 | review | `CODE REVIEW:` | Claude Opus 5.5 | included in the review row | included in the review row | Approve — 0 Blocking · 2 Should-fix · 8 Nit (7 fix now, 2 deferred, 1 plan decision); check_tools, lint, test (468 passed), export_web exit 0 |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.41 M (130 k in · 6.25 M cached · 27 k out) | CHF 2.05 (245 credits) | review fixes #1–#7, deferred rows #8, #9 and the decision D19 (#10); `tools/test.ps1` 469 passed, `lint.ps1`, `check_tools.ps1` exit 0; commit `Fix review findings (#35)` (`usage.ps1 -AgentName s09g-close` 2026-11-22 16:35:25–16:42:47) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 1.26 M (388 k in · 853 k cached · 22 k out) | CHF 2.14 (255 credits) | spec runner (coordination); two runner agents, s09g-runner and s09g-runner2 — both counted (`usage.ps1 -AgentName s09g-runner,s09g-runner2` from 2026-11-22 12:34:45) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 5.19 M (1.73 M in · 3.45 M cached · 10 k out) | CHF 8.00 (955 credits) | orchestrator (main chat) (`usage.ps1 -Agent main` from 2026-11-22 12:12:57) |
| 2026-11-22 | implementation | `CLOSE:` | Claude Opus 5.5 | 4.42 M (45 k in · 4.36 M cached · 18 k out) | CHF 1.21 (145 credits) | spec closed (`usage.ps1 -AgentName s09g-close` from 2026-11-22 16:42:47) |
| 2026-11-22 | pr | `PR:` | Claude Opus 5.5 | 1.43 M (66 k in · 1.36 M cached · 9 k out) | CHF 0.66 (78 credits) | pull request opened (#36, base `main`, not draft; issue #35 updated and commented; `usage.ps1 -AgentName s09g-pr` from 2026-11-22 16:48:31) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: spec reopened in place for the author's request (issue #35 kept, comment added); groups C (C1–C11, two new characters Flarekid and Echo), V (V1–V7, views) and L (L1–L8, brighter worlds and lighting presets) added; Q8–Q13 answered with the suggestions; no open questions |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 3.64 M (128 k in · 3.47 M cached · 40 k out) | CHF 1.79 (214 credits) | re-planned: two characters, views, lighting — Steps 1–20 kept; Steps 21–29 added, all reasoning (Claude Opus 5.5); D20–D30 (agent `s09g-lead3`; requirements revision included; `usage.ps1 -AgentName s09g-lead3` from 2026-11-22 16:55:00) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 3.98 M (119 k in · 3.84 M cached · 19 k out) | CHF 1.47 (175 credits) | Step 21 done (`usage.ps1 -AgentName s09g-steps21-22` from 17:03:28 to 17:11:25) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 18.47 M (167 k in · 18.23 M cached · 73 k out) | CHF 4.98 (594 credits) | Step 22 done (`usage.ps1 -AgentName s09g-steps21-22` from 17:11:25 to 17:37:12) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 9.62 M (171 k in · 9.40 M cached · 50 k out) | CHF 3.14 (374 credits) | Step 23 done; runner decision D31 recorded (`usage.ps1 -AgentName s09g-steps23-24` from 17:41:35 to 17:58:59) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 13.91 M (92 k in · 13.76 M cached · 56 k out) | CHF 3.63 (433 credits) | Step 24 done (`usage.ps1 -AgentName s09g-steps23-24` from 17:58:59 to 18:17:35) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.87 M (160 k in · 7.65 M cached · 56 k out) | CHF 2.89 (345 credits) | Step 25 done; runner decision D31 extended (export filter `characters/*_new/*`, `characters/magmax*/*`) (`usage.ps1 -AgentName s09g-steps25-26` from 18:19:26 to 18:39:21) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 8.86 M (94 k in · 8.72 M cached · 48 k out) | CHF 2.67 (318 credits) | Step 26 done (`usage.ps1 -AgentName s09g-steps25-26` from 18:39:21 to 18:52:12) |
---

## Cost summary

This feature used 187.57 M tokens, CHF 63.20 (7541 credits) — measured, see [COSTS.md](../../../../.specs/kit/COSTS.md).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| requirements | Claude Opus 5.5 | 3.90 M | CHF 1.67 (200 credits) | 10.5 % |
| plan | Claude Opus 5.5 | 2.87 M | CHF 1.86 (222 credits) | 11.7 % |
| implementation | Claude Opus 5.5 | 162.44 M | CHF 54.02 (6446 credits) | 339.3 % |
| review | Claude Opus 5.5 | 16.93 M | CHF 4.99 (595 credits) | 31.3 % |
| pr | Claude Opus 5.5 | 1.43 M | CHF 0.66 (78 credits) | 4.1 % |
| **Total** | | **187.57 M** | **CHF 63.20 (7541 credits)** | **396.9 %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (CHF) | Share of Copilot Business |
|------|-------|--------|------------|---------------------------|
| Step 1 | Claude Opus 5.5 | 2.82 M | CHF 1.15 (138 credits) | 7.3 % |
| Step 2 | Claude Opus 5.5 | 8.99 M | CHF 2.50 (298 credits) | 15.7 % |
| Step 3 | Claude Opus 5.5 | 10.98 M | CHF 2.89 (345 credits) | 18.2 % |
| Step 4 | Claude Opus 5.5 | 7.56 M | CHF 2.19 (261 credits) | 13.7 % |
| Step 5 | Claude Opus 5.5 | 7.15 M | CHF 1.75 (208 credits) | 10.9 % |
| Step 6 | Claude Opus 5.5 | 11.32 M | CHF 2.84 (339 credits) | 17.8 % |
| Step 7 | Claude Opus 5.5 | 5.48 M | CHF 1.82 (217 credits) | 11.4 % |
| Step 8 | Claude Opus 5.5 | 6.19 M | CHF 2.47 (295 credits) | 15.5 % |
| Step 9 | Claude Opus 5.5 | 6.44 M | CHF 1.60 (190 credits) | 10.0 % |
| Step 10 | Claude Opus 5.5 | 4.78 M | CHF 1.68 (201 credits) | 10.6 % |
| Step 11 | Claude Opus 5.5 | 10.98 M | CHF 2.93 (349 credits) | 18.4 % |
| Step 12 | Claude Opus 5.5 | 12.65 M | CHF 3.18 (379 credits) | 19.9 % |
| Step 13 | Claude Opus 5.5 | 13.27 M | CHF 3.05 (364 credits) | 19.2 % |
| Step 14 | Claude Opus 5.5 | 650 k | CHF 0.32 (39 credits) | 2.1 % |
| Step 15 | Claude Opus 5.5 | 2.32 M | CHF 0.97 (116 credits) | 6.1 % |
| Step 16 | Claude Opus 5.5 | 18.96 M | CHF 4.94 (589 credits) | 31.0 % |
| Step 17 | Claude Opus 5.5 | 5.84 M | CHF 1.50 (179 credits) | 9.4 % |
| Step 18 | Claude Opus 5.5 | 2.49 M | CHF 1.13 (135 credits) | 7.1 % |
| Step 19 | Claude Opus 5.5 | 434 k | CHF 0.14 (17 credits) | 0.9 % |
| Step 20 | Claude Opus 5.5 | 5.86 M | CHF 1.57 (187 credits) | 9.8 % |
| Review fixes | Claude Opus 5.5 | 6.41 M | CHF 2.05 (245 credits) | 12.9 % |
| Spec runner (coordination) | Claude Opus 5.5 | 1.26 M | CHF 2.14 (255 credits) | 13.4 % |
| Orchestrator (main chat) | Claude Opus 5.5 | 5.19 M | CHF 8.00 (955 credits) | 50.3 % |
| CLOSE | Claude Opus 5.5 | 4.42 M | CHF 1.21 (145 credits) | 7.6 % |
| **Total implementation** | | **162.44 M** | **CHF 54.02 (6446 credits)** | **339.3 %** |

# Part 1 · Requirements

## Context

The author and Mattia find that the Godot game's screens and characters look much worse than
the Python + Svelte game, and Mattia is unhappy with the new game. This spec makes the UI and
the characters clearly better (judged side by side with the Svelte game on the same screens),
adds a second, fantasy world built with the ProtonScatter addon (part W), lets a child's
drawing become a character of the game with what Claude (via Copilot) can do on its own
(part A), and recommends a better drawing-to-character workflow with one or a few tools,
Google Flow among them (part B). Every stage and Step of this spec runs on Claude Opus 5.5.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Basic UI](2026_11_21_04_basic_ui_spec.md) (spec 04) — the screens (home, fighter list,
  fighter screen, info), the shared theme `scenes/ui/hack_star_theme.tres`, `FighterStage`,
  `FighterCard`, `SkinButton`, `PrestigeBadge`, the minimum sizes (44 px buttons, 14 px text,
  D13) and the five screen sizes of `tests/test_screen_sizes.gd`.
- [Graphics Demo](2026_11_21_06_graphics_demo_spec.md) (spec 06) — the canyon arena, the
  effects, the see-through in a bush and S10 (30 frames per second or more on a recent iPad and
  phone, checked by the author with the FPS label).
- `scenes/fighter_model.gd` (`FighterModel`) — the 6 fighters and 14 skins built in code from
  primitive meshes, with a toon material (`DIFFUSE_TOON`) and an outline pass
  (`OUTLINE_GROW` 0.022), idle, run and attack animations; `scenes/canyon.gd` builds the arena
  the same way. No imported model, texture, icon or font: the text uses Godot's default font
  (`LICENSES.md`, `docs/architecture.md` *3D models* and *Art and licences*).
- The Svelte game's look, the reference: `ui/src/lib/models/parts.ts` (3-step toon shading and
  a dark "inverted hull" outline, 7 % larger, on every part), `heroes3d.ts`, `fighters3d.ts`,
  `skins3d.ts`, `arena3d.ts`, and the screens `Home.svelte`, `FighterList.svelte`,
  `FighterDetail.svelte`, `Arena.svelte` (weight 900 text with a dark outline and shadow, round
  icon buttons, coloured chips).
- Asset rules: `hack_star_godot/LICENSES.md` and `ui/public/assets/LICENSES.md` — original art
  or free licence (Quaternius and Kenney, CC0), a line per asset, no Supercell art, names or
  logos; root README **Art** and **Licence and disclaimer**.
- Root specs still open (Python + Svelte game, requirements only) whose findings this spec
  reuses: [Graphics review](../../../../.specs/features/2026_11_14_2_graphics_review_spec.md)
  (#20: candidate packs, licence first — CC0, or CC BY with credit — and a phone-size check per
  model), [Art tools research](../../../../.specs/features/2026_11_14_3_art_tools_research_spec.md)
  (#21: the questions to ask each tool — cost, ownership, training on uploads, age, formats,
  weight; free use only; Martin owns the accounts; only drawings uploaded),
  [Originality review](../../../../.specs/features/2026_11_14_4_originality_review_spec.md) (#22:
  our own identity, no copied look). Part B answers #21's question for the Godot game in a
  narrower form; it does not replace #21.
- The canyon is the only world: `game/arena_layout.gd` (`ArenaLayout`, constants for the walls,
  cactus patches, decoration and start points, read by `Canyon`, `Arena`, `MatchArena`,
  `BotBrain` and `ControlsHelp`) and `scenes/canyon.gd`. More worlds, world coins, prices and
  three sizes are [Worlds and World Coins](../2026_11_22_18_worlds_and_world_coins_spec.md)
  (spec 18, requirements only); part W adds one world and a minimal choice, nothing of spec 18.
- **ProtonScatter** (checked 2026-11-22: [Godot Asset Store](https://store.godotengine.org/asset/hungryproton/protonscatter/),
  version 4.2.0 of 2026-07-28; [source](https://codeberg.org/hungryproton/proton_scatter),
  `addons/proton_scatter/`, MIT, "Copyright (c) 2019 HungryProton") is a **placement tool**,
  not a world: a `ProtonScatter` node with a modifier stack (points on a grid, at random, along
  an edge; then moved, rotated, scaled, projected), `ScatterItem` nodes naming the scene to
  place, and `ScatterShape` nodes (box, sphere, path; can be negative) for the area. It places
  instanced meshes (MultiMesh) or copies of scenes. In a running game it rebuilds on load
  (`force_rebuild_on_load`, default on) **on a `Thread`** unless `dbg_disable_thread` is set —
  a risk for the single-threaded web export. Its repository has demo assets
  (`addons/proton_scatter/demos/assets/`: rocks, grass, bush, pine tree, mushroom, fence,
  brick, dead branch, the Godot mascot Gobot, a `source.blend` with textures) under the addon's
  MIT licence; they are textured and realistic, not Hack star's outlined cartoon look, so the
  objects to scatter are made for Hack star (W3).

**Compared on screenshots (2026-11-22, 1280 × 720, same screens, both games run locally; the
Svelte game rendered in a headless browser with software 3D, so its colours are paler than on a
device; screenshots not committed).** What is worse in the Godot game:
- **Background and depth:** every screen is a flat dark navy colour; the Svelte game has a
  purple gradient with light rays, the fighter stands on a round pedestal, and the fighter
  screen frames the stage.
- **Fonts:** Godot's default font in normal weight, plain white, no outline or shadow; the title
  "Hack star" is plain text. Svelte uses very bold text with a dark outline and drop shadow, and a
  two-colour, slanted logo.
- **Buttons and layout:** five identical purple text buttons in a centred block; Svelte has round
  coloured buttons with icons (a different colour per action), a large yellow **PLAY** in the
  corner, and chips with icons for trophies, credits and the account. Godot shows
  "Trophies: 1745" / "Credits: 500" as plain labels.
- **Fighter list and screen:** Godot cards are dark boxes with five lines of text; Svelte cards
  have a coloured backdrop by unlock state, a lock icon and price on locked fighters, icons for
  trophies and power, and the fighter's type. Godot skin buttons are text only ("Lava Epic");
  Svelte shows a picture of every skin in a rarity frame, and health, damage and a power bar.
- **Characters:** the Godot outline is thin and disappears at card size; shading is soft and
  "plastic" (faces nearly white, little form), where Svelte's 3-step cel shading and thick dark
  outline read clearly at every size. The Godot shapes themselves (Blaze, Rocko, Turbo) are close
  to the Svelte ones.
- **Arena:** the Godot floor is a saturated yellow checkerboard, the wall nearest to the camera
  covers about a quarter of the screen at the start, the controls hint is low-contrast text on
  orange, and "FPS: 60" is shown to the player; Svelte has softer sand tiles, outlined rocks and
  props, and the timer and fighters-left in dark chips with icons.
- **Animation:** both have idle animations and a home entrance; Svelte's buttons react visibly to
  a press, Godot's barely do.

**Research for part B (sources read 2026-11-22):**

| Tool | What it can do for a drawn character | What it cannot do | Cost (free use) | Terms for an MIT open-source game | Source |
|------|------|------|------|------|------|
| **Google Flow** (Google Labs, AI film studio) | Images with Nano Banana (generate and edit, also from an uploaded picture, lasso edits), videos with Veo and Gemini Omni; keeps a character consistent across images and scenes; agent for batch variations; mobile app (Android beta) | **No 3D model, no rig, no game asset formats** — images and video clips only; 18+ with age verification; Chromium browser; supported regions only | No subscription: basic features and 50 credits a day; images "for free" (Feb 2026); full features with Google AI Plus, Pro or Ultra | Google's terms: "Google won't claim ownership" of generated content; no explicit commercial grant; invisible SynthID watermark on every output; Generative AI Prohibited Use Policy; protections for uploaded photos of people and minors | [Flow help: Get started](https://support.google.com/flow/answer/16353333) (read 2026-11-22); [Flow updates, Feb 2026](https://blog.google/innovation-and-ai/models-and-research/google-labs/flow-updates-february-2026/) (2026-02-25); [Flow updates, May 2026](https://blog.google/innovation-and-ai/models-and-research/google-labs/flow-updates/) (2026-05-19) |
| **Meshy** (image or multi-view to 3D) | Textured 3D model from an image; auto-rig of humanoids with walk and run loops, 600+ motion presets; GLB, FBX, USDZ | Fine details of a child's drawing; four-legged characters only get a walk | Free: 100 credits a month (a few models; the newest model's downloads may need Pro); Pro about $20 a month, 1,000 credits | Free plan: outputs under **CC BY 4.0** (credit to Meshy needed); paid plans: the user owns the assets, commercial use allowed | [Meshy pricing](https://www.meshy.ai/pricing) and [docs](https://docs.meshy.ai/en/webapp/pricing) (read 2026-11-22); [Meshy Animate](https://docs.meshy.ai/en/webapp/guides/animate) (read 2026-11-22); [comparison, Oct 2026](https://news.littlewolflabs.com/posts/2026-10-18-image-to-3d-compared) |
| Tripo, Hunyuan3D, TRELLIS (other image-to-3D) | Similar models | — | Tripo free: 200 credits a month | Tripo free outputs are **non-commercial**; Hunyuan3D's licence **excludes the EU, UK and South Korea**; TRELLIS is MIT but needs a 24 GB GPU — not recommended | [comparison, Oct 2026](https://news.littlewolflabs.com/posts/2026-10-18-image-to-3d-compared); [free image-to-3D, Jul 2026](https://triposr.org/blog/free-image-to-3d) |
| **Claude via Copilot** | Reads a photo; writes the code that builds a fighter from shapes and colours (as for today's fighters), or turns the photo into a flat cut-out figure; imports a GLB into Godot and fits it into the game | **Does not generate images or 3D models** itself | Included in the author's Copilot plan | Code written for the project (MIT) | — |
| **Godot 4.7** | Imports glTF 2.0 (`.glb`, recommended), also `.blend`, FBX, OBJ | — | Free | MIT | [Godot docs: Available 3D formats](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) (read 2026-11-22) |

Result: Google Flow alone cannot make a game character — it can clean and complete the
drawing (front, side and back views in the game's style), which is the input a 3D tool needs.
The smallest set for a real 3D character is **Google Flow → Meshy → Claude in Godot** (three
tools, all free to start); the smallest set without a 3D tool is **Claude alone** (part A), or
**Google Flow → Claude** for a cleaned-up flat figure. Outputs of AI tools may not be protected by
copyright at all; the drawing itself is Mattia's own work. Not legal advice.

**New:**
- A clearly better look of the Godot game's screens and characters, checked side by side with
  the Svelte game.
- A second world, a fantasy place unlocked from the start, its objects placed with
  ProtonScatter, and a minimal choice between the two worlds.
- A drawing → character workflow that Claude runs on its own (part A), with a first drawing of
  Mattia's in the game.
- A written recommendation for a better workflow with Google Flow and few other tools (part B).
- _(added 2026-11-22, reopened)_ Two new fighters from the author's generated pictures (part C),
  camera views switchable with the keyboard (part V), and brighter worlds with lighting presets
  switchable with the keyboard (part L).

**Reopened 2026-11-22 (author's request) — found in the repository:**
- `characters/blaze2/` and `characters/echo/` (untracked, made by the author with an AI image
  tool from Mattia's drawing): `<name>_hero.png` (full body, transparent, 1058 × 1415 and
  1088 × 1431, 1.9 and 2.2 MB), `<name>_card.png` (512 × 512, 0.34 and 0.42 MB), a `Sprite3D`
  billboard scene `<name>_hero.tscn`, a `TextureRect` scene `<name>_hero_ui.tscn`, a helper
  `character_preview.gd` (pop-in and bob on a podium) and a README each. Both READMEs say: a 2D
  picture in 3D, it does not turn or animate. `blaze2`'s two scenes point to
  `res://characters/blaze/` (wrong folder). The PNGs are imported as VRAM-compressed S3TC, which
  the web export does not ship for mobile (`vram_texture_compression/for_mobile=false`; an iPad
  has no S3TC). The Blaze picture is a "hero upgrade" of Blaze (flame hood, scarf, fire ball);
  Echo has teal headphones that send sound waves, a "sound blaster" staff and neon soles — like
  Beatbolt, who was built from shapes from Mattia's drawing (A2, A3), and who stays.
- `scenes/blaze_godot.zip` (2.3 MB) and `scenes/blaze_godot/` (a duplicate with
  `echo_godot (1).zip`, 2.6 MB): untracked copies of the same delivery. Step 20 measured that
  Godot packs untracked files of the project folder into the web export (+4.7 MB in the working
  tree); `.gitignore` and the export's `exclude_filter` do not name them yet.
- `FighterModel` (rig, body, head; idle, run lean and bounce, attack recoil; see-through by
  material swap), `DrawnFighters` (a registry asked first by `FighterModel.setup`),
  `Fighters.LIST` (`"drawn": true`, `"plays_like"`), `FighterPictures` (cards rendered
  off-screen), `FighterStage` (pedestal on home and the fighter screen), `Fighter` (turns to the
  input; knock-out spin and shrink in 0.5 s).
- `Arena` (Training) and `MatchArena` (extends `Arena`): one `Camera3D` at a 55° pitch looking
  north, distance fitted to the screen, the G11 near-wall rule; `WorldEnvironment` (ambient
  only) and `Sun` in `arena.tscn`; `GlimmerIsles` sets its own sky and sun. Input actions:
  `move_*` (WASD and arrows) and `shoot` (Space) — no key is bound to `1`–`4`, `V`, `L` or `K`,
  and the arena has no text field.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../../.specs/overall_req.md) | Overall game idea ("very good graphics", "woww effect for kids") |
| [architecture.md](../../../docs/architecture.md) | How the Godot game is organised (UI foundation, 3D models, art and licences) |
| [README](../../../README.md) | How to open, run, test and export the Godot game |
| [LICENSES.md](../../../LICENSES.md) | Every asset of the Godot game and its licence |

## 1 · Specs

### G — Better graphics of the UI and the characters

- **G1 — Side by side:** Before and after this spec, the home screen, the fighter list, the
  fighter screen and a match of both games are captured at the same size (desktop landscape and
  iPad portrait); the author and Mattia judge each Godot screen "as good as or better than" the
  Svelte one, and their verdict per screen is written in this spec. Mattia decides per screen and
  the author breaks a tie, in one session at the end of the spec, with a mid-way look after the
  first screens (home and match).
- **G2 — Background:** No Godot screen has a plain flat background: menus have a coloured
  gradient or pattern with depth, and the fighter on home, the fighter screen and the result
  screen stands on a visible pedestal or stage.
- **G3 — Fonts:** The title, headings, buttons and numbers use a bold display font with a dark
  outline or shadow; body text stays readable; the font is one free display font under the SIL
  Open Font License, in `assets/`, named in `LICENSES.md`.
- **G4 — Logo:** "Hack star" on home is a logo (more than one colour, outline, not plain text)
  and plays in the entrance as today.
- **G5 — Buttons and icons:** Every home action is a button with an icon and its own colour,
  **Play** is the largest and most visible button, and trophies, credits, power, lock and price
  are shown with   icons instead of words like "Trophies:"; the icons are Kenney's (CC0) or original, in
  `assets/`.
- **G6 — Press feedback:** Every button visibly reacts to a press (mouse and touch) within one
  frame, and to hovering with a mouse.
- **G7 — Fighter cards:** A card shows the fighter's picture on a coloured backdrop (unlocked)
  or grey with a lock icon (locked), its name, rarity in its colour, trophies and power with
  icons; the Prestige badge as today.
- **G8 — Skin pictures:** On the fighter screen every skin button shows a picture of the fighter
  in that skin, framed in its rarity colour (Legendary gold as today), with its name.
- **G9 — Characters:** Every fighter and skin has a dark outline that is visible on the cards and
  in the arena, and cel shading with at least two clear tones per colour; faces (eyes) are
  readable on a card. The 6 fighters keep their shapes, names and colours.
- **G10 — Arena look:** The arena floor, walls, cacti and props have the same outlined cartoon
  look as the fighters; the floor is less saturated than the fighters, so fighters stand out.
- **G11 — Arena framing:** At the start of a match and of Training, the wall nearest to the
  camera covers at most 10 % of the screen height at the five screen sizes.
- **G12 — Match HUD:** The timer, "fighters left" and the controls hint are shown on dark rounded
  backings with icons, readable on every part of the arena; the FPS label is hidden for players
  and can be switched on for the author's play-test.
- **G13 — All screens:** The info, hack, QR codes and result screens use the same new look
  (theme, fonts, buttons, icons) as the four compared screens.
- **G14 — Smooth:** A match with 4 fighters runs at 30 frames per second or more on a recent
  iPad and phone in the web export (as spec 06 S10), checked by the author.
- **G15 — Download size:** The web export grows by at most 5 MB, and the game is playable within
  5 s after **Play** on the iPad, as before.
- **G16 — Sizes and input:** Every screen still fits the five screen sizes, buttons stay at least
  44 px and text at least 14 px on screen, and every button works with mouse and touch.
- **G17 — Order:** Home and the match get the new look first (what Mattia sees most), then the
  fighter list and the fighter screen, then the result, info, hack and QR screens; all of them
  in this spec.
- **G18 — Style:** The new look matches the Svelte game's layout and style (gradient, coloured
  icon buttons, a large yellow **Play**); an own identity (root spec #22) comes later.

### W — A new world, built with ProtonScatter

- **W1 — Glimmer Isles:** A second world, **Glimmer Isles** (floating islands with glowing
  crystals and giant mushrooms — not a real place; original art), is unlocked for every account
  from the start, old saves included.
- **W2 — Choose the world:** Before a match and before Training the player chooses between the
  canyon and Glimmer Isles with a minimal choice (both names shown, the current one marked; the
  canyon is the default); the choice is used by **Play** and **Training** and kept while the
  game is open. World coins, prices, sizes, more worlds and saving the choice stay with
  [Worlds and World Coins](../2026_11_22_18_worlds_and_world_coins_spec.md) (spec 18).
- **W3 — Own look:** Glimmer Isles has its own ground, cover (the hiding patches), walls and
  decoration, placed with ProtonScatter, in the outlined cartoon look of G9 and G10; every
  object placed is made for Hack star (the addon's demo assets are not used).
- **W4 — Same rules:** The match rules stay as in the canyon: the arena is as big, bots find
  the player, the cover hides as the cactus patches do, start points are free of walls and
  cover and at least 4 m apart, and overtime and closing walls work as in the canyon (once spec
  11 adds them).
- **W5 — Smooth and on the web:** A match with 4 fighters in Glimmer Isles runs at 30 frames per
  second or more on a recent iPad (as G14) and works in the single-threaded web export; nothing
  of the world is computed on a thread while the game runs (if ProtonScatter cannot run there,
  its result is baked in the editor — the plan decides).
- **W6 — Credit:** ProtonScatter (HungryProton, MIT, version 4.2.0, its source) is credited in
  `LICENSES.md` with its licence file, and its version is pinned.
- **W7 — Canyon unchanged:** The canyon looks (apart from G10, G11) and plays as before.

### A — Drawing → character, done by Claude in this spec

- **A0 — Author's drawing first:** Part A starts only after the author has sent the photo of
  the drawing. Before part A the implementation stops, tells the author exactly what to do
  (photograph the whole drawing flat, in daylight, on plain paper with nothing else in the
  picture; no people, faces, full names or places; remove the photo's metadata such as GPS —
  as A1 and A7 say) and where to put it, and reminds him while it waits; nothing of part A is
  built from an invented drawing.
- **A1 — Workflow:** A short document in the repository says how to take the photo (whole
  drawing, flat, daylight, plain paper, nothing else in the picture), where to put it, and the
  exact request to give Claude via Copilot; following it, Claude turns one drawing into a
  character of the game without other tools.
- **A2 — In the game:** The drawn character is a new **fighter**, unlocked from the start with
  one default skin (more skins come with spec 10), with the name the child chooses: shown in the
  fighter list and the fighter screen, selectable, shown on home, and playable in Training and a
  match like every other fighter.
- **A3 — Recognisable:** The character is a 3D figure built from shapes, with the drawing's main
  shapes and colours (head, body, limbs, special parts such as a hat or a weapon) in the game's
  outlined cartoon style; a flat "paper cut-out" of the photo is the fallback only for a drawing
  too detailed for shapes. Mattia confirms "this is my drawing".
- **A4 — Moves like the others:** The drawn character has the idle, run and attack animations,
  its picture on the card, and the see-through in a bush, as the other fighters.
- **A5 — First drawing done:** At least one of Mattia's drawings is in the game at the end of this
  spec; the author provides the photo.
- **A6 — Limits written down:** The workflow document states what the result can and cannot be
  (one drawing per run; front view only — sides and back are guessed; no fine lines, textures or
  writing from the drawing; a name of 1–12 letters; a fighter, not a new attack) and how long a
  run takes.
- **A7 — Privacy:** Only drawings are photographed — no people, faces, full names or places; the
  photo's metadata (for example GPS) is removed before it is used; the original photo is not
  committed unless the author says so.
- **A8 — Licence:** The drawn character is credited in `LICENSES.md` as the child's own work
  under the repository's licence (with the first name or a nickname the author chooses); no
  drawing copied from a game, film or brand is accepted.
- **A9 — Repeatable:** A second drawing can be added the same way without changing the other
  fighters, and a drawn fighter can be removed again; saves that chose a removed fighter fall
  back to the default fighter.

### B — A better workflow: recommendation

- **B1 — Recommendation document:** A short document in the repository recommends one main
  workflow from a photo of a drawing to a 3D character in the Godot game with at most three
  tools (Google Flow and/or others, plus Claude via Copilot), step by step, and one fallback
  with fewer tools.
- **B2 — Facts per tool:** For each tool of B1 the document states what it does in the
  workflow, what it cannot do, the cost (free use and paid), account and minimum age, the
  output format and how Godot loads it, whether uploads are used for training, and the terms
  for using the result in this MIT-licensed open-source game, each with its source and date.
- **B3 — Google Flow:** The document states what Google Flow can and cannot do for a game
  character (images and videos, character consistency; no 3D model or rig), and where it fits in
  the workflow.
- **B4 — Licence first:** A tool whose terms do not allow publishing its results in an MIT
  open-source game, or are unclear, is not recommended (as root spec #21, S4); any required
  credit (for example CC BY 4.0) is listed for `LICENSES.md`.
- **B5 — Fit for the game:** The document states the limits a generated character must meet to
  join the game (size in MB and triangles for an iPad at 30 frames per second, the outlined
  cartoon look, the animations of A4).
- **B6 — Trial:** One drawing goes through the B1 workflow in this spec, done by the author with
  his own accounts (Google Flow; Meshy free plan — CC BY 4.0, credit Meshy), on free use only;
  its result, time and cost are recorded in the document, and it joins the game only if its
  licence allows it and Mattia prefers it to the part A version.

### Everywhere

- **S1 — Model:** Every stage and every Step of this spec (requirements, plan, implementation,
  review, close) runs on Claude Opus 5.5; the plan's Model column says so for every Step.
- **S2 — Gameplay unchanged:** Rules, numbers, controls, bots, matches, trophies, hack codes and
  saved progress behave as before; old saves load as before.
- **S3 — Checks pass:** `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass;
  tests that check texts or layouts are updated only where the look changes, not the behaviour.
- **S4 — Assets and licences:** Every new font, icon, texture, model or drawing is in
  `assets/` (or built in code) with a line in `LICENSES.md`; no Supercell art, names or logos;
  the README and `docs/architecture.md` describe the new look and the workflows.
- **S5 — Python + Svelte game unchanged:** Nothing outside `hack_star_godot/` changes, except
  links from root documents if needed.
- **S6 — Language:** New visible text is in English, as in the rest of the Godot game until
  spec 15.

### C — Two new characters (added 2026-11-22, author's request)

- **C1 — Two new fighters:** **Flarekid** (the "hero upgrade" of Blaze, a fighter of its own,
  not a Blaze skin) and **Echo** (the sound-powered hero from Mattia's drawing) join the
  fighters, unlocked for every account from the start (old saves included), with one Default
  skin each and playing like an existing fighter (as A2): Flarekid like Blaze, Echo like Luna.
  Both are shown in the fighter list, the fighter screen and on home, can be chosen, and are
  playable in Training and a match. Blaze and Beatbolt stay as they are.
- **C2 — The author's pictures:** Each new fighter is shown with the author's pictures from
  `characters/blaze2/` and `characters/echo/`: the full-body picture in 3D, and the 512 × 512
  card picture on its fighter card and its skin button. The delivered scene files point to their
  own folder (`blaze2`'s path is fixed).
- **C3 — Reveal on the pedestal:** Whenever a fighter appears on home's pedestal or on the
  fighter screen (opening the screen, choosing another fighter or skin), it pops in — grows from
  small to its size with a short overshoot within 0.5 s — with a burst of glowing particles and a
  halo or frame in its rarity colour behind it. This holds for every fighter, not only the new
  ones.
- **C4 — Alive when standing:** On home and the fighter screen the two new fighters are never
  still: they breathe (a slight stretch and squash), bob and sway gently in a loop.
- **C5 — Alive in play:** In Training and a match the two new fighters move like paper
  cut-outs: running hops with a lean and a squash on landing; they face left or right by
  flipping with the movement direction (and keep the last facing when moving straight up or
  down); a shot gives a recoil and a muzzle flash; a hit gives a short white flash; a knock-out
  makes them fall flat and fade before they are hidden, as the other fighters are.
- **C6 — Toon fit:** The new fighters have a dark outline around their silhouette, as wide on
  screen as the other fighters' outline (G9), and a soft shadow on the ground; on a card and in
  the arena they read as clearly as the other fighters at the five screen sizes.
- **C7 — Cover:** In a bush (cover) the new fighters are see-through like the others.
- **C8 — What is missing, written down:** A document says what a flat picture cannot do (no
  side or back view, no real turning, no drawn run or shot frames), what the author can make with
  the same tool to improve it (side and back views, a run cycle of 4–8 frames, a shot pose and a
  hit pose — same size, transparent background — or a 3D model through the B1 workflow), where to
  put the files, and what the game then does with them.
- **C9 — Licence:** `LICENSES.md` has a row per new picture: "generated by the author with an AI
  image tool from Mattia's drawing — tool to be confirmed by the author".
- **C10 — Kept out:** `scenes/blaze_godot.zip` and `scenes/blaze_godot/` (with its zip) are never
  committed (`.gitignore`) and never in the web export; files of the delivery that the game does
  not use are not in the web export either; the author's files are not deleted.
- **C11 — Size:** The two new fighters add at most 1.0 MB to the web export, and the whole
  export stays within G15's budget (Step 1 + 5 MB), measured in the working tree with the
  author's untracked files present.

### V — Views while playing (added 2026-11-22, author's request)

- **V1 — Four views:** In Training and a match the player can switch between four camera views:
  **Classic** (today's angled view from above, the default), **Close** (the same angle, nearer to
  the fighter), **Behind** (low, just behind the fighter, looking ahead up the arena) and
  **Overview** (high above, the whole arena in sight).
- **V2 — Keys:** `V` switches to the next view (Classic → Close → Behind → Overview → Classic),
  `1`–`4` (also on the number pad) choose a view directly; they work during the countdown and the
  fight, and clash with no other key of the game.
- **V3 — Name shown:** After a switch the view's name is shown at the top of the screen on a dark
  backing for about 1.5 s.
- **V4 — Same controls:** In every view the movement keys move the fighter the same way on the
  screen as in Classic (W and up move away from the camera), and shooting is unchanged.
- **V5 — Framing:** In every view the player's fighter stays within the screen at the five screen
  sizes; Classic keeps G11; Overview shows all four border walls.
- **V6 — Kept and touch:** The chosen view is kept for the next match and Training while the game
  is open (not saved). Touch players get the default view; no touch button in this spec.
- **V7 — Documented:** The README's controls, the Info page's *How to play* and the start hint
  name the view keys.

### L — Brighter worlds and lighting presets (added 2026-11-22, author's request)

- **L1 — Brighter colours:** The canyon and Glimmer Isles look clearly more saturated and
  brighter than before the reopening (before and after screenshots of both worlds compared); the
  floor stays less saturated than the fighters, so the fighters stand out (G10).
- **L2 — More detail:** Each world gets at least three new kinds of decoration, at least one of
  them moving (for example flags, birds or water in the canyon; fireflies, waterfalls or
  pulsing crystals in Glimmer Isles); walls, cover, start points and collisions stay as they are
  (W4, W7, S2).
- **L3 — Lighting presets:** `L` switches to the next of at least four lighting presets —
  **Bright day**, **Golden sunset**, **Neon night**, **Candy pop** — in both worlds; each changes
  the sun, the sky, the ambient light and the colour balance (brightness, contrast, saturation);
  glow is used only where the web export shows it and the frame rate allows (L8).
- **L4 — Saturation boost:** `K` switches an extra saturation boost on and off, on top of any
  preset.
- **L5 — Name shown:** After `L` or `K` the preset's name, or "Saturation boost on/off", is shown
  as in V3.
- **L6 — Best default:** The preset a game starts with is the best-looking one, chosen from
  screenshots of every preset in both worlds; the reason is written down. The chosen preset and
  the boost are kept while the game is open (not saved).
- **L7 — Readable:** In every preset, with and without the boost, the fighters, shots, health
  bars, cover and see-through, and the HUD stay readable (screenshots).
- **L8 — Smooth:** With 4 fighters in both worlds, every preset and the boost, the desktop frame
  time and draw calls are measured and compared with a measurement before the reopening: draw
  calls at most 30 % more, frame time at most 30 % more and under 33 ms; the iPad check
  (≥ 30 frames per second, G14) stays with the author.

### Open questions

None. The author answered Q1–Q7 on 2026-11-22 (Q1 3D built from shapes, cut-out as the
fallback → A3; Q2 a new fighter, unlocked from the start, one default skin → A2; Q3 home and the
match first, then the fighter list and screen, then the result, info and hack screens, all in
this spec → G17; Q4–Q7 the suggestions → B6, G1, G18, G3 and G5) and added part W and A0.

Reopened 2026-11-22: the questions of parts C, V and L were answered with the suggestions
(the author's rule for this run): Q8 the Blaze upgrade's name → **Flarekid** (C1; original,
not "Blaze"); Q9 rarity and how they play → Flarekid like Blaze, Echo like Luna, one Default skin
(C1); Q10 the keys → `V` and `1`–`4` for views, `L` and `K` for lighting, checked against the
existing keys (V2, L3, L4); Q11 a touch button for views → not in this spec, touch keeps the
default (V6); Q12 the Behind view and the controls → the camera never turns, so the keys keep
their direction (V1, V4); Q13 the reveal → for every fighter (C3).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

_First close (2026-11-22, Steps 1–20). The spec was reopened in place the same day for the
author's request — two new characters, views and lighting (C1–C11, V1–V7, L1–L8, Steps 21–29);
it is closed again after Step 29._

**Built:** The Godot game has the new cartoon look: every menu screen stands on a purple gradient with soft light rays (`MenuBackground`), titles, headings, buttons and numbers use the outlined display font Lilita One, the buttons are coloured with icons (Kenney *Game Icons*, CC0, plus a few drawn in code) and show hover and press from the theme alone, and trophies, credits, power, the timer and the fighters left are icon chips. Home has a two-colour logo, the chosen fighter on a pedestal and a large yellow **Play**; the fighter cards have rarity-coloured backdrops (grey with a lock for locked fighters); the fighter screen a framed stage and skin pictures in rarity frames; the result, info, hack and QR screens follow. Fighters, the canyon and the new world share cel-shaded toon materials with an outline of fixed pixel width (`ToonMaterials`), the camera keeps the near wall under 10 % of the screen in every world, and the FPS label is hidden unless **Show FPS (play-test)** is switched on in Info. A second world, **Glimmer Isles** (crystal ridges, glow-fern cover, giant mushrooms and floating islands, original art), is placed with ProtonScatter 4.2.0 in the editor and baked into plain MultiMeshes (`tools/bake_world.ps1`), so no addon code ships; the world button on home chooses it for **Play** and **Training** (`Worlds`, per-world `ArenaLayout`). Mattia's drawing became **Beatbolt**, a seventh fighter built from shapes (`scenes/drawn/`), unlocked from the start and playable; `docs/drawing_to_fighter.md` says how to add or remove a drawn fighter and `docs/drawing_tools.md` recommends a Google Flow → Meshy → Claude workflow with sources, terms and fit limits. The web export grew by 0.16 MB (budget 5 MB). Nothing in `server/` or `ui/` changed.

**Differs from the plan:** Step 19 (the B6 trial with Google Flow and Meshy) is 🔜 Deferred: it needs the author's own accounts; its instructions are in `docs/drawing_tools.md`. What only the author and Mattia can do is not invented and stays in **Deferred Items**: the G1 side-by-side verdict, Mattia's A3 "this is my drawing", the iPad play-test (G14, W5, G15's 5 s) and the trial — the spec is closed with these open, as D17 foresaw. Step 7 shows a "Locked" chip instead of a price on locked cards, because the game has no prices yet (D19). Step 16 keeps Beatbolt standing instead of the drawing's crouch (the animations need it) and scales him to 0.85. The code review (Approve, 0 Blocking · 2 Should-fix · 8 Nit) was handled: findings 1–7 fixed (the architecture names the five look tests; the near-wall test runs in every world; a Markdown heading in Step 16; the ordered list's status and the double 09 explained; two float/int warnings; `Hacks.power_text`, the theme's `BackgroundPanel` and `IconButton` and the icons `gear`, `star`, `singleplayer` removed; `GameState.reset()` also sets `ArenaLayout` back to the canyon, with a test), findings 8 and 9 deferred (tool scripts without tests and lint; the kit's schema accepts only S-numbered statements), finding 10 decided as D19 (prices come with Unlock and Upgrade S2 and the Skins Shop).

**Files:** `hack_star_godot/assets/` (`fonts/` Lilita One, `icons/` Kenney), `hack_star_godot/scenes/` (`toon/`, `ui/` — theme, `icons`, `icon_chip`, `menu_background`, `world_choice`, `fighter_card`, `fighter_stage`, `fighter_pictures` —, `drawn/`, `worlds/glimmer_isles/`, `home`, `arena`, `match_arena`, `canyon`, `fighter_model`, `fighter_screen`, `result_screen`, `info`, `hack_screen`, `qr_page`, `autoload/game_state`), `hack_star_godot/game/` (`worlds`, `glimmer_isles_layout`, `arena_layout`, `fighters`, `sample_progress`, `hacks`, `bot_brain`, `controls_help`), `hack_star_godot/addons/proton_scatter/` (editor only, excluded from the export), `hack_star_godot/tools/` (`bake_world.ps1`, `bake_world.gd`, `check_tools.ps1`, `versions.json`), `hack_star_godot/tests/` (the look, world, framing and drawn-fighter tests), `hack_star_godot/docs/` (`architecture.md`, `drawing_to_fighter.md`, `drawing_tools.md`), `hack_star_godot/README.md`, `hack_star_godot/LICENSES.md`, `project.godot`, `export_presets.cfg`; this spec, now in `done/`, its change record in `changes/done/` and the review page in `review/`.

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Before screenshots and size baseline | reasoning (Claude Opus 5.5) — S1; capturing both games the same way, the reference for G1 and G15 | ✅ Done | [→ Step 1](#step-1--before-screenshots-and-size-baseline) |
| **2** | Font, icons and theme | reasoning (Claude Opus 5.5) — S1; new pinned assets with licences and a theme that every screen inherits (D3, D4, D7) | ✅ Done | [→ Step 2](#step-2--font-icons-and-theme) |
| **3** | Toon look of the fighters | reasoning (Claude Opus 5.5) — S1; shaders for cel shading and a screen-space outline, graphics-heavy (D5) | ✅ Done | [→ Step 3](#step-3--toon-look-of-the-fighters) |
| **4** | Home screen | reasoning (Claude Opus 5.5) — S1; the screen Mattia sees most, layout at five sizes (D6, D7) | ✅ Done | [→ Step 4](#step-4--home-screen) |
| **5** | Arena look | reasoning (Claude Opus 5.5) — S1; the canyon in the outlined look without losing frames (D5) | ✅ Done | [→ Step 5](#step-5--arena-look) |
| **6** | Arena framing and match HUD | reasoning (Claude Opus 5.5) — S1; camera rule with a test, HUD chips, the FPS switch (D8); mid-way look | ✅ Done | [→ Step 6](#step-6--arena-framing-and-match-hud) |
| **7** | Fighter cards | reasoning (Claude Opus 5.5) — S1; the list's cards with pictures, icons and the lock | ✅ Done | [→ Step 7](#step-7--fighter-cards) |
| **8** | Fighter screen and skin pictures | reasoning (Claude Opus 5.5) — S1; stage, skin pictures in rarity frames | ✅ Done | [→ Step 8](#step-8--fighter-screen-and-skin-pictures) |
| **9** | Result, info, hack and QR screens | reasoning (Claude Opus 5.5) — S1; the remaining screens in the new look | ✅ Done | [→ Step 9](#step-9--result-info-hack-and-qr-screens) |
| **10** | ProtonScatter addon | reasoning (Claude Opus 5.5) — S1; a new pinned dependency kept out of the export (D11) | ✅ Done | [→ Step 10](#step-10--protonscatter-addon) |
| **11** | Worlds and the world choice | reasoning (Claude Opus 5.5) — S1; the arena layout per world, the Glimmer Isles layout and the choice on home (D9, D10) | ✅ Done | [→ Step 11](#step-11--worlds-and-the-world-choice) |
| **12** | Glimmer Isles objects and scatter scene | reasoning (Claude Opus 5.5) — S1; original fantasy props and the ProtonScatter setup (D13) | ✅ Done | [→ Step 12](#step-12--glimmer-isles-objects-and-scatter-scene) |
| **13** | Glimmer Isles baked and playable | reasoning (Claude Opus 5.5) — S1; the bake tool, the world in a match, web export and frame rate (D12) | ✅ Done | [→ Step 13](#step-13--glimmer-isles-baked-and-playable) |
| **14** | Gate: author's drawing photo | reasoning (Claude Opus 5.5) — S1; no code: stops the run and tells the author what to do (A0, D14) | ✅ Done | [→ Step 14](#step-14--gate-authors-drawing-photo) |
| **15** | Drawing workflow document | reasoning (Claude Opus 5.5) — S1; the repeatable workflow, limits and privacy rules (D15) | ✅ Done | [→ Step 15](#step-15--drawing-workflow-document) |
| **16** | Drawn fighter in the game | reasoning (Claude Opus 5.5) — S1; reading the drawing and building a recognisable fighter from shapes (D14) | ✅ Done | [→ Step 16](#step-16--drawn-fighter-in-the-game) |
| **17** | Adding and removing drawn fighters | reasoning (Claude Opus 5.5) — S1; the add/remove path and the save fallback, with tests (D14) | ✅ Done | [→ Step 17](#step-17--adding-and-removing-drawn-fighters) |
| **18** | Tool recommendation document | reasoning (Claude Opus 5.5) — S1; research with sources and dates, licence first (D15) | ✅ Done | [→ Step 18](#step-18--tool-recommendation-document) |
| **19** | Trial of the recommended workflow | reasoning (Claude Opus 5.5) — S1; the author's trial with his accounts, recorded and judged (D17) | 🔜 Deferred | [→ Step 19](#step-19--trial-of-the-recommended-workflow) |
| **20** | Final check, README and architecture | reasoning (Claude Opus 5.5) — S1; every Godot check, the size budget, the side-by-side verdict and the documents | ✅ Done | [→ Step 20](#step-20--final-check-readme-and-architecture) |
| **21** | Baseline, art import and licences | reasoning (Claude Opus 5.5) — S1; the before set and the measurements of the reopening, web-safe imports within the size budget (D22, D28) | ✅ Done | [→ Step 21](#step-21--baseline-art-import-and-licences) |
| **22** | Flarekid and Echo in the game | reasoning (Claude Opus 5.5) — S1; a new kind of fighter look (cut-out shader with outline, shadow, see-through) behind the existing model API (D20, D21) | ✅ Done | [→ Step 22](#step-22--flarekid-and-echo-in-the-game) |
| **23** | Pedestal reveal and idle | reasoning (Claude Opus 5.5) — S1; animation and particles on home and the fighter screen, graphics-heavy (D23) | ✅ Done | [→ Step 23](#step-23--pedestal-reveal-and-idle) |
| **24** | Paper cut-out animation in play | reasoning (Claude Opus 5.5) — S1; run, facing, recoil, flashes and knock-out of a flat figure; the missing-art document (D24, D29) | ✅ Done | [→ Step 24](#step-24--paper-cut-out-animation-in-play) |
| **25** | Camera views | reasoning (Claude Opus 5.5) — S1; four camera rigs with framing rules at five sizes, new keys and the HUD toast (D25) | ✅ Done | [→ Step 25](#step-25--camera-views) |
| **26** | Brighter worlds and more detail | reasoning (Claude Opus 5.5) — S1; palettes and new animated decoration in both worlds without touching the rules (D26) | ✅ Done | [→ Step 26](#step-26--brighter-worlds-and-more-detail) |
| **27** | Lighting presets and saturation boost | reasoning (Claude Opus 5.5) — S1; environment and light presets in the Compatibility renderer, the default chosen from screenshots (D27) | ⬜ Not started | [→ Step 27](#step-27--lighting-presets-and-saturation-boost) |
| **28** | Performance comparison | reasoning (Claude Opus 5.5) — S1; measuring every preset, world and view against the baseline and trimming what is over (D28) | ⬜ Not started | [→ Step 28](#step-28--performance-comparison) |
| **29** | Final check of the reopening, README and architecture | reasoning (Claude Opus 5.5) — S1; every Godot check, the size report, the after set and the documents | ⬜ Not started | [→ Step 29](#step-29--final-check-of-the-reopening-readme-and-architecture) |

**Reopened 2026-11-22:** Steps 1–20 were done in the first run and are kept unchanged with their
Notes. Steps 21–29 cover the added parts C, V and L; every one runs on Claude Opus 5.5 (S1, D1)
and is done by the agent; the iPad check of the new parts stays with the author (Deferred Items).

**Who does what:** Steps 1–13, 15–18 and 20 are done by the agent. **Step 14 is a gate:** it
stops the run until the author has sent the photo (A0); Steps 15–20 start only after it.
**Step 19 needs the author** (his Google Flow and Meshy accounts, B6); Step 20 needs the author
and Mattia for the side-by-side verdict (G1) and the iPad play-test (G14, W5) — the agent
prepares everything and records their answers (D17).

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
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../../AGENTS.md)). Each
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0. Nothing in `server/` or `ui/`
> changes (S5). `gdlint` allows at most 20 public tests per file: new tests go into new files
> where a file is full. **Looks are checked on real screenshots** (D2): a windowed Godot run
> (not headless) with a temporary capture script (PNGs under `%TEMP%`, viewed, then the script
> removed, never committed), at 1280×720 and 820×1180 (iPad portrait) unless the Step says
> otherwise; the Step's Notes say what was looked at and what was changed after looking.
> **Every Step runs on Claude Opus 5.5** (S1, D1).

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **One model:** every Step's Model column is `reasoning (Claude Opus 5.5)`; the implementation, review and close run on Claude Opus 5.5 too, and the Done lines say `suggested: reasoning (Claude Opus 5.5) · ran: <model>`. | S1, the author's choice for this spec. |
| D2 | **Screenshots:** looks are judged on real screenshots of a windowed Godot run (the GPU renders as on a device; headless has no image). A temporary script (an autoload added for the run, or `--script`) waits for the screen, saves `get_viewport().get_texture().get_image()` as PNG and quits; it is removed before the commit. The **before** and **after** sets for G1 (home, fighter list, fighter screen, a match; both games; 1280×720 and 820×1180) are kept outside the repository in `%LOCALAPPDATA%\hack_star\screens\09\before\` and `…\after\` with the same file names (`godot_home_1280x720.png`, `svelte_home_1280x720.png`, …) — not committed (size, and the Svelte side is software-rendered); the Svelte game is run with `npm run dev` in `ui/` and captured in a headless browser, as the requirements stage did, without changing `ui/`. | G1, G17; the same method for both sets makes the comparison fair; the repository stays small. |
| D3 | **Font:** **Lilita One** (Google Fonts, Juan Montoreano, SIL Open Font License 1.1, one heavy weight, about 30–60 KB) in `assets/fonts/LilitaOne-Regular.ttf` with `assets/fonts/OFL.txt`; pinned in `tools/versions.json` (`"font_lilita_one"`: the version in the font's name table) with its source (the `ofl/lilitaone/` folder of `github.com/google/fonts` at a named commit) and SHA-256 in `LICENSES.md`. It is used for the title, headings, buttons and numbers, with `outline_size` and a dark `font_outline_color` plus a shadow in the theme; body text keeps Godot's default font (readable, no download). | G3, G15, S4: one bold, rounded display font close to the Svelte look's weight 900 text; OFL allows shipping it in an MIT game with its licence file. |
| D4 | **Icons:** **Kenney "Game Icons"** (kenney.nl, CC0 1.0): only the icons used (play, trophy, credits/coin, power, lock, price tag, fighters, info, hack/key, back, home, clock, fighters left, eye, world, settings — about 15–20 white PNGs, tinted in Godot with `modulate` or `icon_*_color`) are copied into `assets/icons/` with Kenney's `License.txt`; the pack version (from its `License.txt`/download page) is pinned in `tools/versions.json` (`"kenney_game_icons"`), the download URL and date in `LICENSES.md`. An icon missing from the pack is drawn in code (own work, MIT). | G5, G15, S4: CC0 needs no credit but we credit anyway, as `ui/public/assets/LICENSES.md`; copying only the used icons keeps the export small. |
| D5 | **Toon look (outline technique):** two shaders in `scenes/toon/`: `toon.gdshader` (3 clear bands — light, mid, shadow — in `light()`, a thin rim; colour, emission and see-through alpha as uniforms; works in the Compatibility renderer) and `outline.gdshader`, an **inverted hull** as the material's `next_pass` (`cull_front`, `unshaded`, dark colour) that grows each vertex **along its normal in clip space by a fixed number of pixels** (about 3 px at 720 px height, scaled with the viewport height), so the outline keeps its width on a 150 px card and in the arena — unlike today's `OUTLINE_GROW` 0.022 in metres. `ToonMaterials` (`scenes/toon/toon_materials.gd`) caches one material pair per colour, shared by fighters, arena and world props (also on `MultiMeshInstance3D` via `material_override`). It replaces `DIFFUSE_TOON` and the grown copy in `FighterModel` and the toon materials of `Canyon`. | G9, G10, W3, G14: the Svelte look (`parts.ts`: 3-step shading, dark hull 7 % larger) in a form that stays visible at every size; one pair per colour keeps draw state small for the iPad. |
| D6 | **Menu background and stage:** a `MenuBackground` scene (`scenes/ui/menu_background.tscn`, a `ColorRect` with `menu_background.gdshader`: a purple gradient with slow soft light rays) behind every menu screen; `FighterStage` gets a round pedestal (a toon-shaded cylinder with outline and a soft shadow disc) and a frame on the fighter screen. | G2: one shared background instead of a flat colour per screen; drawn by the GPU, no texture to download. |
| D7 | **Buttons in the theme:** `hack_star_theme.tres` gets type variations per colour (`PlayButton` large yellow, `GreenButton`, `BlueButton`, `PinkButton`, `IconButton` round) with `StyleBoxFlat`s for normal, hover (lighter), pressed (darker, content moved 3 px down, no bottom edge) and focus; icons are set as `Button.icon`. A press and a hover are shown by the theme in the same frame, with no script; the entrance animation stays in `home.gd`. Chips (trophies, credits, power, timer, fighters left) are one small scene `scenes/ui/icon_chip.tscn` (dark rounded backing, icon, number in the display font). | G5, G6, G12, G18: a theme change reaches every screen; no per-button script to forget. |
| D8 | **FPS label:** hidden for players; the info screen gets a **Show FPS (play-test)** switch that sets `GameState.show_fps` (kept while the game is open, not saved — no save change). | G12, S2: the author can switch it on on the iPad without a keyboard; saves stay as they are. |
| D9 | **Worlds and layouts:** `game/worlds.gd` (`Worlds`, static): the list `[{id: "canyon", name: "Canyon"}, {id: "glimmer_isles", name: "Glimmer Isles"}]`, `ids()`, `get_world(id)`, all unlocked from the start (no save field). `ArenaLayout` becomes per world: today's constants become the canyon's layout data, a second layout holds Glimmer Isles (same `SIZE` 20 × 26 m, own walls, cover patches, decoration spots, dummies and start points); `ArenaLayout.use(world_id)` sets the active layout (default canyon) and the existing functions (`bounds`, `in_bush`, `is_free`, …) and accessors (`walls()`, `bushes()`, `starts()`, …) read it, so `BotBrain`, `ControlsHelp`, `Arena` and `MatchArena` keep their logic. `GameState.world` (memory only, default `"canyon"`) holds the choice; `Arena` and `MatchArena` call `ArenaLayout.use(GameState.world)` and build `Canyon` or `GlimmerIsles`. Collisions and hiding come from the layout rectangles, never from scattered meshes. | W1, W2, W4, W7, S2: one source of truth for the rules per world; the canyon's numbers do not change; saving the choice is spec 18 (S19), so the save version stays. |
| D10 | **World choice (minimal):** on home, a `WorldButton` (world icon + the current world's name) next to **Play** opens a small popup with the two worlds (the current one marked); the choice applies to **Play** and **Training**. Spec 18 replaces it with its world screen. | W2: the smallest UI that lets the player choose before a match and before Training. |
| D11 | **ProtonScatter in the project:** version **4.2.0** from the Godot Asset Store download (its `plugin.cfg` says 4.2.0) is copied into `addons/proton_scatter/` **without** `demos/` and `tests/` (not used — the demo assets are textured and realistic, Gobot is Godot's mascot — and they are most of the repository's 15 MiB); its `LICENSE` stays in the folder. The plugin is enabled in `project.godot` (`editor_plugins`, next to GUT). `tools/versions.json` gets `"protonscatter": "4.2.0"`, and `check_tools.ps1` checks `addons/proton_scatter/plugin.cfg` like GUT. `LICENSES.md` gets a row (MIT, "Copyright (c) 2019 HungryProton", source URL, download date and SHA-256 of the zip). `lint.ps1` already skips `addons/`; `export_presets.cfg` excludes `addons/proton_scatter/*` (the game uses only the baked result, D12). | W3, W6, G15: a new dependency, pinned and credited like GUT; nothing of it ships. |
| D12 | **Always baked:** ProtonScatter rebuilds on load on a `Thread` (`force_rebuild_on_load`, `dbg_disable_thread`) — a risk in the single-threaded web export and extra start-up time — so the scatter result is **baked**: `tools/bake_world.ps1` runs `tools/bake_world.gd` with Godot (headless; a windowed run if headless cannot rebuild), which loads `scenes/worlds/glimmer_isles/scatter_source.tscn`, sets every `ProtonScatter` to `dbg_disable_thread = true` and `enable_updates_in_game = true` with a fixed `global_seed`, waits for the rebuild, and saves the outputs as plain `MultiMeshInstance3D` nodes (toon materials of D5) in `scenes/worlds/glimmer_isles/baked.tscn`, which references no addon script. The game loads only `baked.tscn`; the source scene is re-baked by hand when it changes (README *How to…*). | W5, G15: no thread and no addon code while the game runs; the same result every time; the decision Part 1 leaves to the plan. |
| D13 | **Glimmer Isles look:** own props in `scenes/worlds/glimmer_isles/props/`, built from Godot's primitive meshes with the D5 materials: crystal clusters (walls: tall prisms with glowing tips), glow-fern and small-mushroom patches (cover), giant mushrooms and floating island chunks with hanging roots (decoration, outside the border), a soft teal-lavender tiled ground with a glowing path and a starry sky gradient. ProtonScatter places them: one scatter per kind, its `ScatterShape` boxes taken from the layout rectangles (crystals inside each wall, cover plants inside each cover patch, a negative box around the start points, islands outside the border). `GlimmerIsles` (`scenes/worlds/glimmer_isles/glimmer_isles.gd`) adds the floor, the colliders from the layout and the baked scene. Original art, MIT. | W1, W3, W4, S4: not a real place; readable like the canyon (walls block, cover hides); scatter only decides where the looks go. |
| D14 | **Drawn fighters:** the author sends the photo in the chat or puts it in `%USERPROFILE%\hack_star_drawings\` (outside the repository; never committed unless he says so, A7); the agent re-encodes it with Godot's `Image` (load → resize to at most 1024 px → `save_png`), which drops EXIF/GPS metadata, and checks it shows only the drawing. The fighter is a new entry in `Fighters.LIST` (`drawn: true`, the child's name, one `default` skin, stats and attack copied from an existing fighter the child picks — no new attack, A6), unlocked through `Fighters.start_unlocked()` (old saves join it, spec 08 D4); its look is code in `scenes/drawn/<id>_model.gd` (shapes and colours from the drawing, D5 materials, the same idle, run and attack animation hooks and see-through as `FighterModel`), registered in one table `scenes/drawn/drawn_fighters.gd`. Removing it = deleting its file, its table row and its list entry; a save that chose it falls back to the default fighter through the existing checks (`SaveData` drops unknown ids, spec 08 D3/D11). If the drawing is too detailed for shapes, the fallback (A3) is a flat cut-out: the re-encoded picture on a double-sided quad with an outline, bobbing and turning. | A2–A5, A7–A9: no change to the rules or the save format; one place per drawn fighter, so adding or removing one touches nothing else. |
| D15 | **Documents:** `hack_star_godot/docs/drawing_to_fighter.md` (A1, A6, A7, A9: photo rules, where to put it, the exact request to Claude, limits, time, add/remove) and `hack_star_godot/docs/drawing_tools.md` (B1–B6: the recommended workflow Google Flow → Meshy → Claude in Godot, the fallback Claude alone, the facts per tool with sources and dates, the fit limits, the trial result). Both linked from the README. | A1, B1: the author follows them without this spec open. |
| D16 | **Web size budget (G15):** Step 1 measures the web export (`build/web` total and the `.pck`); the budget for the whole spec is **+5 MB**, planned as font ≤ 0.1 MB, icons ≤ 0.3 MB, shaders and scenes ≤ 0.5 MB, Glimmer Isles baked scene ≤ 1.5 MB, drawn fighter (code) ≈ 0 — ProtonScatter is excluded (D11). Steps 2, 10, 13 and 16 note the size after their change; Step 20 fails if the total grows by more than 5 MB. | G15: checked as it grows, not only at the end. |
| D17 | **What needs the author:** Step 14 stops the run (A0) and Steps 15–20 wait for the photo. The B6 trial (Step 19) is done by the author with his accounts; the agent prepares the instructions, records the result and imports it only if D14's licence rules and Mattia allow it. The G1 verdict and the G14/W5 iPad play-test (Step 20) are done by the author and Mattia; a mid-way look (G1) is sent after Step 6 without stopping. A Step that waits says *waiting for the author* in its Notes and is not ✅ Done until the answer is recorded. | A0, B6, G1, G14, W5: what only the author can do is visible in the table and never invented. |
| D18 | **Tests:** looks are checked on screenshots; what a script can check is tested: the theme's fonts and button styles exist and every home button has an icon (`test_home.gd` / new `test_home_look.gd`); the toon and outline materials on every fighter part (`test_fighter_model.gd`); the nearest wall's share of the screen height ≤ 10 % at the five sizes (new `test_arena_framing.gd`); the FPS label hidden by default (`test_match_hud.gd`); `Worlds`, `ArenaLayout.use` and the Glimmer Isles layout (starts free and ≥ 4 m apart, every cover reachable, walls inside the bounds — new `test_world_layouts.gd`); the world choice used by Play and Training (new `test_world_choice.gd`); the baked scene has no addon reference and has props in every wall and cover rectangle (new `test_glimmer_isles.gd`); the drawn fighter in the list, selectable, playable, and the fallback after removal (new `test_drawn_fighter.gd`); the existing screen-size tests at the five sizes with the new layouts. Tests that count fighters (`test_fighters.gd`, `test_fighter_list.gd`, `test_sample_progress.gd`) are updated in Step 16. | S2, S3, G16: behaviour stays tested; tests change only where the look changes. |
| D19 | **Review finding 10 (runner decision): no price on locked fighters yet.** A locked fighter's card shows the lock icon on a grey backdrop, a grey picture and a lock chip "Locked" instead of a price, and the fighter screen a disabled **Locked** button, because the game has no prices yet (a fighter is unlocked only by the start list or the unlock-all hack). G5's price tag on locked fighters comes with the prices: [Unlock and Upgrade](../2026_11_22_09_unlock_and_upgrade_spec.md) S2 (the unlock price by rarity, also on locked cards); skin prices with [Skins Shop](../2026_11_22_10_skins_shop_spec.md) (spec 10). | S2 (nothing invented: no number without a rule behind it); Part 1, the plan (Step 7) and the result now agree. |
| D20 | **Name and data of the new fighters (reopened, Q8–Q9):** the Blaze upgrade is **Flarekid** (id `flarekid`) — a kid whose hood is a flame, an original name that is not "Blaze" and is not used by any fighter, skin or brand checked in the repository; rarity **Legendary** (an upgrade hero), `"plays_like": "blaze"`. **Echo** (id `echo`), rarity **Mythic**, `"plays_like": "luna"` (a ranged "sound blaster", like Luna's ray gun). Both are rows in `Fighters.LIST` with `"unlocked": true`, `"cutout": true`, one `default` skin, and the `plays_like` numbers (as drawn fighters, D14; `SampleProgress` gets their numbers); old saves get them through `Fighters.start_unlocked()` (spec 08 D4). Their folders stay `characters/blaze2/` and `characters/echo/` as the author delivered them. | C1: the author asked for an own name; a known rule (`plays_like`) gives the numbers without inventing an attack (A6). |
| D21 | **Cut-out fighter look:** a registry `CutoutFighters` (`scenes/cutout/cutout_fighters.gd`, like `DrawnFighters`): id → hero texture, card texture, height in metres (about 1.6 m, as the other fighters), the feet point of the picture. `FighterModel.setup` asks it after `DrawnFighters` and builds into its body a `MeshInstance3D` with a `QuadMesh` and a `ShaderMaterial` of a new `scenes/toon/cutout.gdshader`: the quad turns to the camera around the vertical axis in the vertex shader (Y billboard, so the model's own yaw does not matter); alpha scissor; a dark outline found from the picture's alpha in a ring of a fixed **screen-pixel** width (D5's width); uniforms `flash` (mix to white), `fade` (see-through and knock-out alpha), `flip` (mirror), `saturation`. Plus a soft round blob shadow on the ground (unshaded, transparent disc, as the pedestal's shadow). See-through (C7) sets `fade` instead of the material swap. The card picture is the author's `_card.png` itself (`FighterPictures` returns it instead of rendering). The delivered `Sprite3D` scenes are not used (they cannot outline, flash or flip). | C2, C5, C6, C7: one material does all the per-fighter effects; the rig/body/head API of `FighterModel` keeps the existing idle, run and recoil code working for the new fighters. |
| D22 | **Art files, web size and git:** the author's two folders are committed (pictures, READMEs, scenes with `blaze2`'s path fixed to `res://characters/blaze2/`). The hero pictures are imported **not** VRAM-compressed (the web export has no mobile VRAM formats) with `process/size_limit` 768 (hero) and 256 (card) and `compress/mode` lossless, or lossy WebP if lossless is over the C11 budget of 1.0 MB for both — Step 21 measures and decides. Not shipped (export `exclude_filter`): `characters/*/character_preview.gd`, `characters/*/*_hero.tscn`, `characters/*/*_hero_ui.tscn`, `characters/*/README.md`, `scenes/blaze_godot/*`, `scenes/blaze_godot.zip`. `.gitignore` gets `/scenes/blaze_godot.zip` and `/scenes/blaze_godot/`; the zips and the duplicate folder are never touched. | C2, C9, C10, C11: the original pictures stay as delivered (re-import is lossless for the source); the game ships only what it uses, sized for a phone. |
| D23 | **Reveal and idle:** `FighterStage.show_fighter` plays a reveal whenever it shows a fighter with `pedestal = true` (home, fighter screen; not the off-screen pictures): scale 0.3 → 1.08 → 1.0 in 0.45 s (`Tween`, `TRANS_BACK`), a one-shot `CPUParticles3D` burst (about 24 sparks in the rarity colour, `Rarity` colours) and a rarity-coloured halo quad behind the fighter (the radial gradient of home's halo) that flares and settles. The cut-out idle is in `FighterModel.animate` for cut-out fighters: body scale y `1 + 0.03·sin`, x `1 − 0.02·sin` (breathing), bob 0.04 m, sway ±4° around the view axis. CPU particles, not GPU (Compatibility and web safe). | C3, C4: one place for both screens; reused by every fighter. |
| D24 | **In-play cut-out animation:** in `FighterModel.animate` (cut-out branch) — running: a hop `|sin|·0.18 m` with a squash at the bottom (scale y 0.9, x 1.08) and a lean of 8° towards the movement; facing: `Fighter` sets `model.facing_left` from the sign of the input's x (unchanged when x ≈ 0), the shader's `flip`; shot: the existing recoil plus `FighterModel.muzzle_flash()` — a small unshaded star quad at the muzzle for 0.08 s; hit: `Fighter.hit` calls `model.flash()` (white for 0.12 s); knock-out: cut-out fighters tip backwards (rotation about the screen's horizontal axis to 80°) and fade out in `KNOCK_OUT_SECONDS` instead of the spin and shrink. Shape fighters keep their animations. | C5: the "paper" moves the author asked for with the one picture that exists. |
| D25 | **Camera views:** `game/camera_views.gd` (`CameraViews`, static data): `classic` (pitch 55°, distance fitted as today, G11), `close` (55°, 0.6 × the fitted distance, at least 6 m), `behind` (pitch 28°, 6 m, look-ahead 4 m north), `overview` (pitch 78°, distance fitted to the whole `ArenaLayout.bounds()` at the screen's aspect). The camera's yaw never changes — it always looks north — so the keys keep their screen direction (V4) and the billboards face it. `Arena` keeps one `Camera3D` and moves it between rigs with a short blend (0.3 s); the follow, look-ahead and near-wall rule stay for `classic`. Input actions in `project.godot`: `view_next` (V), `view_1`–`view_4` (keys 1–4 and keypad 1–4), `light_next` (L), `saturation_boost` (K) — none is bound elsewhere (only `move_*` and `shoot` exist; the arena has no text field). `GameState.camera_view` (memory only, default `classic`). A shared `HudToast` (`scenes/ui/hud_toast.gd`: a `ChipPanel` backing with a `HudLabel`, top centre, shown 1.5 s then faded) says the view's name and is reused by D27. No touch button (V6, Deferred Items). | V1–V6: a fixed yaw is the simplest way to keep world-relative controls right in every view. |
| D26 | **Brighter worlds and detail:** palette constants of `Canyon` and `GlimmerIsles` (and their props) are raised in saturation and value — canyon: warmer orange-red rock, apricot sand floor, greener cacti; Glimmer Isles: vivid teal and violet ground, magenta and cyan crystals — the floor stays the least saturated surface (L1, G10). New decoration only in decoration spots or outside the border, with no collider: canyon — flowering cactus tops, flags on the border that wave, circling birds, a turquoise stream outside the border with moving highlights; Glimmer Isles — fireflies (`CPUParticles3D`, at most 64), pulsing crystal glow (one shared material, its emission animated), waterfalls from the floating islands (a scrolling quad), slowly turning islands. Static props are instanced (MultiMesh), moving ones in code; `baked.tscn` is re-baked with `tools/bake_world.ps1` only if the scatter source changes. | L1, L2, W4, W7: more life without touching the rules, the layouts or the bake's no-thread rule (D12). |
| D27 | **Lighting presets:** `game/light_presets.gd` (`LightPresets`, data per preset: name, sun colour, energy and angle, ambient colour and energy, sky top/horizon/ground colours, `adjustment_brightness/contrast/saturation`, optional fog and glow) and `scenes/world_lighting.gd` (`WorldLighting`, applies a preset to the arena's `WorldEnvironment`, `Sun` and the world's sky; each world may tint a preset through its own base values). Presets in `L` order: **Bright day**, **Golden sunset**, **Neon night**, **Candy pop**, plus **Classic** (the look before the reopening, to compare). `K`: saturation × 1.3 on top. `GameState.light_preset` and `GameState.saturation_boost` (memory only); `HudToast` (D25) shows the name. Glow is enabled in a preset only if a windowed Compatibility run and the web export both show it and Step 28's numbers stay within L8; otherwise the preset uses emission and the adjustments only. The default (L6) is chosen in Step 27 from screenshots of every preset × world at 1280×720 and 820×1180 and recorded in this table (D27's last sentence and the Step's Notes). | L3–L7: data in one place, applied in one place, the same for Training and a match. |
| D28 | **Measurements and budgets:** Step 21 takes the reopening's **before** set (D2 method: both worlds in a match 4 s in, home, fighter screen; 1280×720 and 820×1180; `%LOCALAPPDATA%\hack_star\screens\09b\before\`), the **performance baseline** (a windowed run, vsync off, a 4-fighter match in each world, Classic view, 10 s: average and worst frame time, `Performance` `RENDER_TOTAL_DRAW_CALLS_IN_FRAME` and `RENDER_TOTAL_PRIMITIVES_IN_FRAME`, by a temporary script, never committed) and the **web size** (`tools/export_web.ps1` in the working tree). Budgets: the two characters ≤ 1.0 MB (C11); the reopening ≤ 1.5 MB in total; the whole export ≤ 45,361,090 bytes (G15: Step 1 + 5 MB); L8 as stated. Step 28 repeats the performance run for every preset × world, with and without the boost, in Classic and Overview, and trims (particle counts, glow off) what is over. | L8, C11, G15: measured the same way before and after, in the same folder state the author has. |
| D29 | **Missing-art document:** `docs/drawing_to_fighter.md` gets a section *Picture fighters (Flarekid, Echo)*: how a picture fighter is added or removed (folder, imports, `CutoutFighters` row, `Fighters.LIST` row, `SampleProgress`, `LICENSES.md`), what a single picture cannot do, and exactly what the author can generate with the same tool to improve it — a side and a back view, a run cycle of 4–8 frames, a shot pose and a hit pose (same height and feet point, transparent PNG, `characters/<folder>/<name>_<pose>.png`), or a GLB through the B1 workflow (`docs/drawing_tools.md`) — and what the game then does (frames swapped by the animation; a GLB replaces the cut-out). | C8: the author knows what to deliver next without this spec open. |
| D30 | **Tests (reopening):** new files (at most 20 tests each, D18): `test_cutout_fighters.gd` (both in the list and unlocked, old save gets them, card picture is the delivered card, model builds the cut-out quad with the outline shader, see-through `fade`, `flip` follows the input, `flash` after a hit, knock-out fades), `test_fighter_reveal.gd` (reveal on home and the fighter screen, not on pictures; particles and halo in the rarity colour), `test_camera_views.gd` (order of `V`, keys `1`–`4`, the toast, fighter within the screen per view at the five sizes, Overview sees the four borders, Classic keeps G11, kept for the next match), `test_light_presets.gd` (order of `L`, `K` toggles, default preset, each preset changes sun, sky and adjustments, kept for the next match), `test_world_decor.gd` (new decoration has no collider, layouts and start points unchanged, at least three new kinds per world). Tests that count fighters are updated in Step 22. | S2, S3: what a script can check is tested; looks are checked on screenshots (D2). |
| D31 | **The author's newer files (runner decision, during Step 23):** during the run the author dropped new untracked files — `characters/magmax/`, `characters/echo_new/` (with `gameplay/frames/`: directional idle, walk and shoot frames) and `characters/echo_godot_gameplay.zip`. They are not part of this reopening's request: never committed, modified or moved; `.gitignore` gets `/characters/*.zip`; the web export's `exclude_filter` gets `characters/magmax/*`, `characters/echo_new/*` and `characters/*.zip`, so the web budget (C11, G15) holds in the author's working tree; a Deferred Items row says a follow-up can use them (Echo's in-play animation, a new fighter). Committed with Step 23. **Extended in Step 25 (runner decision):** the author also dropped `characters/blaze_new/` and `characters/magmax_new/`; the filter is made robust — `characters/*_new/*` and `characters/magmax*/*` replace the two folder entries (`characters/*.zip` and the D22 entries stay), so only the game files of `characters/blaze2/` and `characters/echo/` are exported, measured with `tools/export_web.ps1` in Step 25. | C10, C11, G15: the reopening ships only what it planned; the author's files stay as he left them. |

---

## Step 1 — Before screenshots and size baseline

### Goal
The **before** screenshots of both games and the web export size are recorded, the reference for
the side-by-side verdict and the size budget (G1, G15, G17).

### Tasks
- [x] Record the start time in Notes below.
- [x] Capture the Godot game (D2): home, fighter list, fighter screen, a match a few seconds in, at 1280×720 and 820×1180, into `%LOCALAPPDATA%\hack_star\screens\09\before\`.
- [x] Capture the Svelte game the same way (`ui/`: `npm run dev`, headless browser), the same screens and sizes, same folder; stop the dev server; `git status` shows nothing in `ui/`.
- [x] Run `tools/export_web.ps1`; write the total size of `build/web` and of the `.pck` in Notes (D16).
- [x] Check: 16 PNGs present and viewed; the size line in Notes; `tools/test.ps1` and `tools/lint.ps1` exit 0 (nothing in the game changed).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 12:35
**Before set** (D2): 16 PNGs in `%LOCALAPPDATA%\hack_star\screens\09\before\` — `godot_` and `svelte_` × `home`, `fighters`, `fighter`, `match` × `1280x720`, `820x1180`, all viewed. Godot: a windowed run (`--resolution`) with a temporary `-s` capture script (kept outside the repository, never committed; at 820×1180 the window is taller than the 960 px desktop and Windows allows it); the game's own save (Rocko chosen, 1755 trophies), the match 4 s in. Svelte: `npm run dev` (the FastAPI server already ran on 8180) and headless Edge through Playwright (`uv run --with playwright`, SwiftShader), a fresh account (Blaze), the match 6 s in (countdown / *FIGHT!* still visible); dev server stopped, nothing changed in `ui/`. What the requirements stage saw holds: flat navy vs purple gradient with rays and a pedestal, plain default font vs bold outlined display text and a two-colour logo, five identical purple buttons vs coloured icon buttons and a big yellow **PLAY**, text-only cards and skin buttons, thin outline, yellow checker floor, the near wall covering the lower ~25 % (1280×720) and ~35 % (820×1180) of the match, FPS shown.
**Size baseline** (D16, `tools/export_web.ps1` exit 0): `build/web` total **40,361,090 bytes** (38.49 MiB), of which `index.wasm` 39,514,754 and `index.pck` **239,960 bytes**; budget for the spec: total ≤ 45,361,090 bytes (+5 MB).
**Done (2026-11-22 · ~7 min · Claude Opus 5.5)** — before screenshots of both games (16 PNGs, outside the repository) and the web size baseline; no game file changed. `tools/test.ps1` 403 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.82 M tokens · CHF 1.15 (138 credits)

---

## Step 2 — Font, icons and theme

### Goal
The display font and the icons are in `assets/`, pinned and credited, and the theme gives every
screen bold outlined text and buttons that react to a press and a hover (G3, G5, G6, G16, S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] Add Lilita One and `OFL.txt` to `assets/fonts/` (D3); add the used Kenney icons and `License.txt` to `assets/icons/` (D4); pin both in `tools/versions.json`; rows in `LICENSES.md` (source, version, date, SHA-256, licence).
- [x] Theme (`scenes/ui/hack_star_theme.tres`): the display font with outline and shadow for the title, heading, button and number types; body text unchanged; the button type variations and states of D7; the `IconChip` scene.
- [x] Keep every button ≥ 44 px and text ≥ 14 px (`UiScale`, spec 04 D13).
- [x] Check: screenshots of home and info at 1280×720 and 390×844 show the new text and buttons, hover and pressed states captured; `test.ps1`, `lint.ps1`, `check_tools.ps1` exit 0; export size noted (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 12:42
**Assets** (D3, D4): Lilita One 1.002 (name table) from `google/fonts` `ofl/lilitaone/` at commit `0b03411` (28,092 bytes, with `OFL.txt`); Kenney **Game Icons** — kenney.nl is blocked by the author's network filter (Zscaler, "games" category), so the same pack was taken from Kenney's own upload on OpenGameArt (`Kenney_gameIcons.zip`, 2014-11-03, CC0, no version number → the upload date is pinned); 14 white 100 px icons copied unchanged with `License.txt`. The pack has no coin, bolt, clock, world or eye: `Icons` (`scenes/ui/icons.gd`) draws them once in code (own work) and names every icon (`Icons.get_icon("trophy")`). Both pinned in `tools/versions.json` (`font_lilita_one`, `kenney_game_icons`), rows with source, date, licence and SHA-256 in `LICENSES.md`; `.specs/guidelines/gdscript.md` *Art* line updated (the font and icons are the only files).
**Theme** (D7): Lilita One with a dark outline on `Button` (and every button variation), `HeadingLabel`, `SubheadingLabel`, `HudLabel`, new `NumberLabel`, `BadgeLabel`; a drop shadow on the heading and HUD labels; plain `Label` (body text) keeps Godot's default font and size. Button variations `PlayButton` (large yellow, dark text and icon, 60 px), `GreenButton`, `BlueButton`, `PinkButton`, `IconButton` (round) and the base purple `Button`: dark 3 px border with an 8 px bottom edge; hover lighter; pressed darker, edge 3 px, content 3 px lower (also `hover_pressed`); focus is now a white ring (before it reused the hover look); `icon_max_width` 48 (Play 64). `IconChip` (`scenes/ui/icon_chip.tscn` + `.gd`, `ChipPanel` dark rounded backing, icon tinted, number in `NumberLabel`). Button and text sizes unchanged (≥ 44 px buttons, ≥ 14 px text: `test_screen_sizes*.gd` green). New `tests/test_theme_look.gd` (8 tests: display font and outline, body font unchanged, hover lighter / pressed darker and lower per variation, own colours, focus ring, every icon, drawn icons not empty, chip).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step2\`, viewed): home and info at 1280×720 and 390×844 (headings, name and buttons in the outlined display font, body text unchanged and readable); home with the mouse over **Play** (lighter) and pressed (darker, text 3 px lower, short edge) — real input events, so the theme alone reacts in the same frame; a gallery of the six variations × normal/hover/pressed, the chips with all drawn icons and a heading. After looking: the first gallery showed purple for every variation (the capture read the styles before the buttons were in the tree) — fixed in the capture code; nothing to change in the theme. Home still uses the base purple buttons and plain title until Step 4.
**Size** (D16): `build/web` 40,406,582 bytes (+45,492 vs Step 1), `index.pck` 285,452 bytes (+45,492); budget font ≤ 0.1 MB and icons ≤ 0.3 MB met.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — Lilita One and 14 Kenney icons in `assets/` (pinned, credited, checksums), `Icons`, the theme's display font, button colours and states, `IconChip`; `tests/test_theme_look.gd`. `tools/test.ps1` 411 tests passed (one run before had a timing flake in `test_touch_joystick.gd` "held about 0.3 s", unrelated; green on the re-run), `tools/lint.ps1` exit 0, `tools/check_tools.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 8.99 M tokens · CHF 2.50 (298 credits)

---

## Step 3 — Toon look of the fighters

### Goal
Every fighter and skin has 3-band cel shading and a dark outline that stays visible on a card and
in the arena, with readable eyes; shapes, names and colours unchanged (G9).

### Tasks
- [x] Record the start time in Notes below.
- [x] Add `scenes/toon/toon.gdshader`, `outline.gdshader` and `toon_materials.gd` (D5).
- [x] `FighterModel`: use the shared materials on every part (replacing `DIFFUSE_TOON` and the grown copy); eyes with a white and a dark part large enough for a card; the see-through in a bush still works.
- [x] Update `test_fighter_model.gd` (every visible part has the toon material with the outline pass; see-through).
- [x] Check: screenshots of all 6 fighters and the 14 skins on cards (150 px) and in Training; outline visible at both sizes, two or more tones per colour; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 12:55
**Shaders and materials** (D5): `scenes/toon/toon.gdshader` — per light three bands (lit 0.85, mid 0.5, none; a surface in a cast shadow gets none), the ambient light is the shadow tone, so every colour shows two or three clear tones; a thin light rim; colour and glow as uniforms. `scenes/toon/outline.gdshader` — inverted hull (`cull_front`, unshaded, dark navy) as `next_pass`; each vertex moves out from the part's centre (not along the face normal, so box corners stay closed) by `grow` 0.012 m and then by 3 px on screen, scaled up when the shorter side of the view is over 720 px (820×1180 → 3.4 px). `ToonMaterials` (`scenes/toon/toon_materials.gd`) caches one material per colour/glow/outline, shared by every fighter (`test_fighters_share_their_materials`), and the see-through copies. **Differs from D5:** the see-through copy is a transparent toon `StandardMaterial3D` with a faded grown outline, not an alpha uniform in `toon.gdshader` — writing `ALPHA` in the shader would make every fighter part transparent all the time (sorting artefacts between parts, cost on the iPad). `Canyon` keeps its own materials until Step 5.
**FighterModel**: every `_toon` part takes `ToonMaterials.toon` (no `DIFFUSE_TOON` and no per-model outline copy left); `_faded` and the per-model cache replaced by `ToonMaterials.see_through`; eyes darker than 0.35 luminance get an outlined white (`LeftEyeWhite`/`RightEyeWhite`) around a larger-looking pupil (`…Pupil`) with the shine; Rocko's yellow glowing eyes stay without a white. Shapes, names and colours unchanged.
**Tests**: `tests/test_fighter_model.gd` +4 (all 14 looks cel-shaded with the shared outline pass and ≥ 8 outlined parts, materials shared, eye whites and pupils, see-through copy transparent with a faded outline); the see-through swap tests in `test_arena_effects.gd` / `test_match_arena.gd` unchanged and green. `tests/test_touch_joystick.gd`: the "held about 0.3 s" test failed in every run of this Step, also on the plan commit `dd563c8` (checked in a scratch worktree) — GUT's `wait_seconds` counts physics time, which ran ahead of the wall clock the joystick measures (0.18–0.22 s); the test now waits on the wall clock (test only, no game change).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step3\`, viewed): all 14 looks rendered at the picture size (256×320) and shown at 150 px like a card (1280×720) and at 80 px (820×1180); home and the fighter screen (close-ups); the fighter list; Training and a match at 1280×720 and 820×1180. Outline visible at every size, faces and bodies show a lit and a shaded tone, eye whites readable on the 150 px pictures; a bot in a cactus patch is see-through. After looking: lit band 1.0 → 0.85 and mid 0.55 → 0.5 (faces were nearly white on home); the screen width first scaled with the view height (4.9 px at 820×1180 looked heavy in the arena) → now with the shorter side.
**Done (2026-11-22 · ~16 min · Claude Opus 5.5)** — toon and outline shaders, `ToonMaterials`, `FighterModel` on the shared materials with eye whites, tests. `tools/test.ps1` 415 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 10.98 M tokens · CHF 2.89 (345 credits)

---

## Step 4 — Home screen

### Goal
Home has the gradient background, the fighter on a pedestal, the "Hack star" logo, coloured icon
buttons with a large yellow **Play**, and icon chips for trophies and credits (G2, G4, G5, G6,
G16, G17, G18).

### Tasks
- [x] Record the start time in Notes below.
- [x] Add `MenuBackground` (D6) and use it on home; the pedestal in `FighterStage`.
- [x] Logo: "Hack" and "star" in two colours, outlined, slightly slanted, in the display font; the entrance animation as today.
- [x] Buttons: **Play** large yellow (corner in wide layout, bottom in tall), Training, Fighters, Info, Hack as coloured buttons with icons (D7); trophies and credits as `IconChip`s.
- [x] Update `test_home.gd` / add `test_home_look.gd` (each button has an icon and its colour variation; chips show the numbers; button names and actions unchanged); `test_screen_sizes.gd` passes at the five sizes.
- [x] Check: screenshots at the five sizes and with a press and a hover; compared with the Svelte before shot; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:12
**Background and pedestal** (D6): `scenes/ui/menu_background.tscn` (a `ColorRect`, mouse ignored) with `menu_background.gdshader` — purple gradient (lighter top, dark bottom), a soft glow above the middle and 14 slow light rays (one turn in ~170 s); used on home instead of the flat `BackgroundPanel` (the other screens follow in Steps 7–9). `FighterStage` builds a `Pedestal` (three outlined toon drums from `ToonMaterials`: blue side, cream rim, lavender top just under the feet) and moves its camera back and up to show it; `@export var pedestal` (default on) — `FighterPictures` turns it off, so the card pictures are unchanged until Step 7. The fighter screen and result screen now also show the pedestal (G2).
**Logo** (G4): `Title` is an `HBoxContainer` with `Hack` (yellow) and `Star` ("star", pink) labels; theme variations `LogoHackLabel` / `LogoStarLabel` use a `FontVariation` of Lilita One slanted by `variation_transform` (0.22), 88 px, 18 px dark outline, dark drop shadow; the entrance pops it as before (scale/alpha on `Title`).
**Buttons and chips** (G5, G6, G18): Training `PinkButton`, Fighters `BlueButton`, Info the base purple `Button`, Hack `GreenButton`, each with its icon (`home.gd` `BUTTON_ICONS` → `Icons`: target, two people, i, wrench); **Play** `PlayButton` (yellow, play arrow, 360×120) now after the other buttons — bottom-right corner when wide, across the bottom when tall (`_arrange`). Trophies and credits are `IconChip`s (`TrophiesChip` trophy, `CreditsChip` drawn coin) with the number only; `Hacks.credits_text` ("Credits: 500") became `Hacks.credits_amount` ("500" / "∞"); `docs/architecture.md` updated for the rename. Node paths of the buttons unchanged.
**Tests**: new `tests/test_home_look.gd` (6: every button has an icon and its own colour; Play the largest and yellow; Play in the corner when wide and under the buttons, across the screen when tall; chips with trophy/coin icons and numbers; the two-colour outlined slanted logo; gradient background and outlined toon pedestal); `test_home.gd`, `test_hacks.gd`, `test_hack_effects.gd`, `test_hack_expiry.gd`, `test_mvp_flow.gd`, `test_screen_sizes.gd` updated for the chips and the logo labels only.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step4\`, viewed): home at 1280×720, 1180×820, 820×1180, 390×844, 844×390; Play hovered and pressed at 1280×720 and 390×844 (real mouse events: lighter on hover, darker and 3 px lower when pressed). Compared with `before\svelte_home_1280x720.png`: gradient with rays, a pedestal, a two-colour slanted logo, coloured icon buttons, a big yellow Play in the corner and dark chips — the same layout ideas; the Svelte's square icon tiles and player chip are not copied (wide buttons stay readable at 390 px). After looking: the logo slant checked on an enlarged crop (leans right as intended); nothing else changed. Also captured the fighter screen at 1280×720 (`godot_fighter_1280x720.png`): Blaze on the pedestal, nothing cut off.
**Done (2026-11-22 · ~10 min · Claude Opus 5.5)** — home on the gradient background with the fighter on a pedestal, the two-colour slanted logo, coloured icon buttons with a large yellow Play in the corner / at the bottom, trophy and coin chips; `tests/test_home_look.gd`. `tools/test.ps1` 421 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.56 M tokens · CHF 2.19 (261 credits)

---

## Step 5 — Arena look

### Goal
The canyon's floor, walls, cacti and props have the outlined cartoon look, and the floor is less
saturated than the fighters (G10, W7).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Canyon`: softer sand tiles (lower saturation), D5 materials with outline on walls, boulders, cacti, crates, skulls and bones (also on its `MultiMeshInstance3D`s); layout and collisions unchanged.
- [x] Note the draw calls (`Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME`) and the frame time of Training on the desktop before and after in Notes.
- [x] Check: screenshots of Training and a match at 1280×720 and 820×1180; fighters stand out from the floor; `test_arena*.gd` unchanged and green; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:22
**Canyon** (D5, G10, W7): every part takes its material from `ToonMaterials` (the canyon's own `_toon` / `_vertex_color_material` StandardMaterials are gone): walls (body, band, top), the boulders on and outside the walls, cactus trunks, arms and flowers, crates, skulls, bones and rocks are cel-shaded with the dark outline pass; the floor box, the sand tiles, the outside ground and the bush patches are cel-shaded without an outline (flat ground needs none). For the MultiMeshes `toon.gdshader` got `use_instance_color` and `ToonMaterials.instanced(outlined)` (one shared material each), so every boulder, tile and cactus keeps its own colour. Sand `f2b866`/`e4a456` → `b89c74`/`ad9068` (the arena's bright sun made the first try, `ecd3a4`, render almost white — measured on the screenshot, the old floor rendered at 255,255,140, the new one at about 248,208,155: saturation 0.45 → 0.37, the fighters' colours stay at 0.8–1.0); bush ground `b9a24a` → olive `8f9a5a` so the patches still read; outside ground `a5512f` → `b47552`. Layout, wall heights, collisions and names unchanged.
**Draw calls and frame time** (Training at 1280×720, desktop GPU, vsync off, mean of 240 frames, two runs each): before **384** draw calls, 3.2 / 4.8 ms per frame; after **539** draw calls (+155: one outline pass per outlined mesh and MultiMesh), 2.6–5.1 ms per frame (same as before within the run-to-run noise). The iPad check stays with Step 20 (G14).
**Tests**: new `tests/test_canyon_look.gd` (2: walls and props cel-shaded with the outline; the ground cel-shaded without one); `test_arena*.gd` unchanged and green.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step5\`, viewed): Training and a match (5 s in) at 1280×720 and 820×1180. Outlines on walls, boulders, cacti, crates, skulls and bones read like the fighters'; the soft sand lets the fighters stand out. After looking: the first sand was too pale (blown out by the sun) → darker, and the bush ground greener. The near wall and the HUD are Step 6.
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the canyon on the shared toon materials with the dark outline on walls and props (MultiMeshes too, per-instance colour), softer sand; `tests/test_canyon_look.gd`. `tools/test.ps1` 423 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.15 M tokens · CHF 1.75 (208 credits)

---

## Step 6 — Arena framing and match HUD

### Goal
The nearest wall covers at most 10 % of the screen height at the start, the HUD shows the timer,
fighters left and the controls hint on dark backings with icons, and the FPS label is hidden
unless switched on (G11, G12, G1 mid-way look).

### Tasks
- [x] Record the start time in Notes below.
- [x] Camera framing and/or the camera-side wall height so that the projected nearest wall is ≤ 10 % of the screen height at the start of a match and of Training at the five sizes; new `test_arena_framing.gd` measures it with `Camera3D.unproject_position`.
- [x] HUD: timer and fighters left as `IconChip`s, the controls hint on a dark rounded backing with icons; the FPS label hidden by default; the info screen's **Show FPS (play-test)** switch (D8); `test_match_hud.gd` updated.
- [x] Mid-way look (G1, D17): copy the current home and match screenshots to `%LOCALAPPDATA%\hack_star\screens\09\midway\` and write in Notes that they are ready for the author and Mattia (not blocking).
- [x] Check: screenshots of a match and Training at five sizes; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:30
**Framing** (G11): the wall heights stay (W7); the camera does the work. After `_frame_camera` has found the distance (as before), `Arena._near_wall_offset` finds by bisection how far south of the camera target the near wall's top edge (`Canyon.CAMERA_SIDE_WALL_HEIGHT` + `WALL_CAP_HEIGHT` 0.1, at `Arena.near_wall_z()`, the inner face of the southmost border wall) may lie so that it projects at 92 % of the screen height (`NEAR_WALL_SHARE` 0.08), and the camera target is never south of that (`_camera_max_z`). The camera moves with its target, so the limit is computed once per screen size. A tall screen now shows more arena ahead instead of the wall and the ground behind it. Measured as "from the wall's top edge to the bottom of the screen" (the wall and the outside ground behind it — what hid the arena): before 26 % (1280×720, 844×390), 30 % (1180×820), 40 % (820×1180), 43 % (390×844); now ≤ 8 % at all five sizes, Training and a match (`tests/test_arena_framing.gd`: the share ≤ 10 %, and the player in view above the wall; checked that it fails with the old framing). The existing camera tests (`test_screen_sizes.gd` fighter in view at the start and in the far corner) still pass.
**HUD** (G12, D8): `match.tscn` — `TimerChip` (clock icon, white; `IconChip.text_color` red in the last 10 s) and `FightersLeftChip` (fighters icon in red, the number) replace `TimerLabel` / `FightersLeftLabel` (and the scene's own timer StyleBox); `IconChip` got `text_color`, setters that skip unchanged values (the HUD sets them every physics frame) and children that ignore the mouse. `arena.tscn` — `ControlsHint` is a `PanelContainer` (`ChipPanel`, dark rounded) with `Row/Icon` (info icon) and `Row/Label` (the same text), growing upwards from the bottom; the FPS label moved under the fighters-left chip (top 88 px) and is hidden unless `GameState.show_fps` (new, memory only, reset by `reset()`; no save change). Info screen: a `FpsSwitch` `CheckButton` **Show FPS (play-test)** under the list (80 px tall, 28 px text). Docs: `docs/architecture.md` (arena and match rows, play-test line) and the README's match rules updated for the chips and the switch.
**Tests**: new `tests/test_arena_framing.gd` (2); `test_match_hud.gd` (chips, red timer via `text_color`, icons, FPS hidden by default and shown with the switch on: +2); `test_controls_hint.gd` (hint on the dark backing with an icon, every part ignores input; text read from `Row/Label`); `test_screen_sizes_match.gd` (chip paths); `test_info.gd` (+1: the switch by click on, by touch off).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step6\`, viewed): a match (1.5 s in, countdown) and Training at 1280×720, 1180×820, 820×1180, 390×844, 844×390; a match with the FPS switch on; the info screen at 1280×720 and 390×844. The near wall is a thin strip at the bottom; the hint covers the lowest ~15 % for its 5 s, then fades; the chips read on sand and on walls.
**Mid-way look** (G1, D17, not blocking): `%LOCALAPPDATA%\hack_star\screens\09\midway\` has `godot_home_1280x720.png`, `godot_home_820x1180.png`, `godot_match_1280x720.png`, `godot_match_820x1180.png` — ready for the author and Mattia to compare with `…\09\before\svelte_*` (home and match).
**Done (2026-11-22 · ~12 min · Claude Opus 5.5)** — the camera never shows more than 8 % of near wall at the bottom, the timer and fighters left as icon chips, the controls hint on a dark backing with an icon, the FPS label hidden unless Info's **Show FPS (play-test)** is on; mid-way screenshots ready; `tests/test_arena_framing.gd`. `tools/test.ps1` 428 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 11.32 M tokens · CHF 2.84 (339 credits)

---

## Step 7 — Fighter cards

### Goal
Each card shows the fighter's picture on a coloured backdrop (or grey with a lock icon and price
when locked), its name, rarity in its colour, trophies and power with icons, and the Prestige
badge (G5, G7, G16).

### Tasks
- [x] Record the start time in Notes below.
- [x] `FighterCard`: backdrop by unlock state and rarity, picture from `fighter_pictures.gd` with the new look, lock icon and price for locked fighters, icon chips for trophies and power, rarity label in `Rarity` colours, `PrestigeBadge` as today; the fighter list on `MenuBackground`.
- [x] Update `test_fighter_list.gd` (lock icon only on locked cards; numbers shown); screen sizes pass.
- [x] Check: screenshots of the list (unlocked and locked cards, with the unlock-all hack and without) at five sizes; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:43
**Card** (G5, G7): `FighterCard` — `Column/Backdrop` (a rounded, dark-bordered panel in `Rarity.color` of the fighter, `LOCKED_BACKDROP` grey while locked) holding the `Picture` (the cached `FighterPictures` render, unchanged: the toon look of Step 3, no pedestal) and a centred `LockIcon` (Kenney lock, tinted orange); the name; the rarity in its colour, upper case, in the display font with an outline (new theme variation `RarityLabel`); the `PrestigeBadge` as before; `Stats` with a `TrophiesChip` (trophy, "1240") and a `PowerChip` (drawn bolt, "7 / 11" — new `Hacks.power_amount`, `power_text` now uses it) at 26 px; a `LockChip` (lock, "Locked") on locked cards. A locked picture is drawn grey by `scenes/ui/fighter_picture.gdshader` (keeps the premultiplied blend of the old `CanvasItemMaterial`; one material per card, `resource_local_to_scene`) instead of tinting the whole card. `CardPanel` (also used by the result and QR screens) is now the dark violet card with a dark border and a thicker bottom edge. The list's flat `BackgroundPanel` became `MenuBackground`. **Differs from the plan:** no price on locked cards — the game has no fighter prices yet (fighters unlock only by the hack; the shop is a later spec), so the lock chip says "Locked" instead of inventing a number (S2).
**Tests**: `test_fighter_list.gd` (the numbers in the chips with their icons; locked cards — lock icon, lock chip, grey backdrop and grey picture — and unlocked cards — none of them, the backdrop in the rarity colour); `test_hack_effects.gd` (unlock-all removes the lock icon and the grey; Power 22 shows "7 / 22" on the card's chip). `test_screen_sizes*.gd` unchanged and green. `docs/architecture.md` (list row, `power_amount`) updated.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step7\`, viewed): `godot_fighters_<size>.png` and `godot_fighters_unlockall_<size>.png` at 1280×720, 1180×820, 820×1180, 390×844, 844×390 (sample progress; with the unlock-all hack every card has its rarity backdrop: green, blue, purple, red, gold). Compared with `before\svelte_fighters_1280x720.png`: the same idea (rarity-coloured backdrop, grey locked fighter with a lock, icons for trophies and power); the text stays readable at 390 px (two columns). Nothing changed after looking.
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — fighter cards with a rarity-coloured backdrop, grey picture with a lock for locked fighters, trophy and power chips, outlined rarity; the list on the gradient background. `tools/test.ps1` 428 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 5.48 M tokens · CHF 1.82 (217 credits)

---

## Step 8 — Fighter screen and skin pictures

### Goal
The fighter screen frames the fighter on its stage, and every skin button shows a picture of the
fighter in that skin in its rarity frame with its name (G2, G8, G16).

### Tasks
- [x] Record the start time in Notes below.
- [x] Fighter screen on `MenuBackground`, the stage framed with the pedestal; `SkinButton` shows the skin's picture (rendered once per skin and cached, as `fighter_pictures.gd`), a rarity-coloured frame (Legendary gold as today) and the name; select and back actions unchanged.
- [x] Update `test_fighter_screen.gd` (every skin button has a picture and the frame colour of its rarity).
- [x] Check: screenshots for a fighter with several skins at five sizes; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 13:51
**Screen** (G2, G8): `fighter_screen.tscn` on `MenuBackground`; the `FighterStage` (with the pedestal of Step 4) now sits in `Body/StageFrame`, a `PanelContainer` with the new theme variation `StageFramePanel` (a translucent lighter purple inside a dark rounded border, like the Svelte stage frame). The rarity is upper case; trophies and power are `IconChip`s next to the Prestige badge in one `Details/Stats` row (G5; saves height on a phone held sideways); **Select** is a `GreenButton` with a tick icon (a lock icon while it reads "Locked"); "Skins" in the outlined display font. Select, preview and Back unchanged.
**Skin pictures** (G8): `FighterPictures` renders any list of fighter/skin pairs (`_render`); `ensure` (the list, as before) and new `ensure_skins(host, fighter_id)` (every skin of one fighter), `cached_skin`; the fighter screen shows the cached pictures at once and the rest after rendering (once per skin per game start, headless renders nothing). `SkinButton` (150×190) shows the picture as its expanded icon above the name and rarity (`clip_text` on, otherwise Godot subtracts the text width from the icon's room), frames it in `Rarity.color` (a duplicate of the theme's frame per state with the border in that colour; Legendary keeps the thicker gold frame; Default the plain frame), `frame_color()`. Theme: skin frames 4 px on a dark violet fill, text 24 px, `icon_max_width` 0 for both skin variations.
**Tests**: `test_fighter_screen.gd` +2 (every skin of Blaze and Luna shows its cached picture and the frame colour of its rarity, Default the plain frame; the gradient background, the `StageFramePanel` frame and the pedestal); values read from the chips; `test_hack_effects.gd` and `test_screen_sizes.gd` paths for the chips and `StageFrame/FighterStage`. `docs/architecture.md` (fighter screen row, `FighterPictures`) updated.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step8\`, viewed): `godot_fighter_blaze_<size>.png` (3 skins: Default, Lava Epic, Phoenix Legendary) and `godot_fighter_luna_<size>.png` (locked; Default, Galaxy Mythic, Supernova Legendary) at 1280×720, 1180×820, 820×1180, 390×844, 844×390. After looking: the skin pictures first drew at ~40 px — the theme's `icon_max_width` 48 and Godot subtracting the text width — fixed with `icon_max_width` 0 and `clip_text`; now the fighter fills the frame above its name at every size. One test run hung in Godot's `--import` step (no output for 10 min, the author's editor open on the same project); the process was stopped and the re-run passed — not a code problem.
**Done (2026-11-22 · ~21 min · Claude Opus 5.5)** — the fighter screen on the gradient with the fighter framed on its pedestal, chips for trophies and power, a green Select, and skin buttons with the fighter's picture in each skin in a rarity-coloured frame. `tools/test.ps1` 430 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 6.19 M tokens · CHF 2.47 (295 credits)

---

## Step 9 — Result, info, hack and QR screens

### Goal
The result, info, hack and QR screens use the new background, fonts, buttons and icons; the
fighter on the result screen stands on the pedestal (G2, G13, G16).

### Tasks
- [x] Record the start time in Notes below.
- [x] `MenuBackground`, display font headings, coloured icon buttons and chips on `result_screen`, `info`, `hack_screen`, `qr_page`; the result screen's trophy part (spec 08) in the new look; the QR page keeps printable black-on-white codes.
- [x] Update the tests of these screens only where names or the look changed; `test_screen_sizes*.gd` pass.
- [x] Check: screenshots of the four screens at five sizes (result: victory with a Prestige celebration); `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:13
**Screens** (G2, G13): `result_screen`, `info`, `hack_screen` and `qr_page` stand on `MenuBackground` (no screen uses `BackgroundPanel` any more); the scrolling content of info, hack and QR codes sits on a dark rounded panel (new theme variation `ContentScroll`, the `ScrollContainer`'s own `panel` style, so no node path changed). `BackButton` shows the back arrow on every screen. **Result**: heading in gold for Victory and light red for Defeat (Time's up white); **Play again** the yellow `PlayButton` with the play icon (60 px text, 40 px on short screens), **Home** a `BlueButton` with the home icon; the trophy part on the new dark `CardPanel` with a gold trophy icon in its corner (`TrophyPanel/TrophyIcon`), the change green for a gain and red for a loss, the count in `NumberLabel`; the Prestige celebration and the gold bar as before; the fighter on its pedestal (Step 4). **Info**: the words in the display font, gold with a dark outline (`WordLabel`; still "bold" for `test_info.gd`), the FPS switch unchanged. **Hack**: **Use code** green with a tick, **Scan QR code** blue with the eye, **Turn all hacks off** pink with a cross, **QR codes** purple with a new drawn `qr` icon (`Icons`, own work), "Active hacks" as a subheading. **QR codes**: the cards on the dark `CardPanel`, **Save image** blue; the codes stay black on white with their quiet zone (`QrImage` unchanged). Chips are not used here — these screens show no trophies, credits or power except the result's trophy part, which got the icon.
**Tests**: new `tests/test_screens_look.gd` (3: the four screens on the gradient, the back arrow and the dark content panel; the result's yellow Play again, blue Home, trophy icon, gold Victory heading, green gain and pedestal; the hack buttons' colours and icons); no existing test had to change (names and paths kept); `test_screen_sizes*.gd` green. `docs/architecture.md` (theme paragraph: `MenuBackground` on every menu screen, `ContentScroll`, the icons) updated.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step9\`, viewed): `godot_result_<size>.png` (a victory from 1990 trophies: +10, 2000 / 3000, PRESTIGE 2! with the badge and the gold burst), `godot_info_<size>.png`, `godot_hack_<size>.png` (with Unlimited credits active), `godot_qr_<size>.png` (three codes from a fake server list) at 1280×720, 1180×820, 820×1180, 390×844, 844×390. On the short screen (844×390) the result hides the fighter as spec 08 decided. Nothing changed after looking.
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the result, info, hack and QR screens on the gradient with the dark content panel, coloured icon buttons, the back arrow, a trophy icon and coloured results; `tests/test_screens_look.gd`. `tools/test.ps1` 433 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 6.44 M tokens · CHF 1.60 (190 credits)

---

## Step 10 — ProtonScatter addon

### Goal
ProtonScatter 4.2.0 is in the project, pinned, credited and kept out of the export (W6, D11).

### Tasks
- [x] Record the start time in Notes below.
- [x] Download 4.2.0 from the Godot Asset Store page; copy `addons/proton_scatter/` without `demos/` and `tests/`; keep `LICENSE`; note the zip's SHA-256.
- [x] Enable the plugin in `project.godot`; `tools/versions.json` `"protonscatter": "4.2.0"`; `check_tools.ps1` checks its `plugin.cfg` version (pending/fail rules as GUT); `export_presets.cfg` excludes `addons/proton_scatter/*`; `LICENSES.md` row.
- [x] Check: `check_tools.ps1` shows ProtonScatter 4.2.0; Godot imports the project headless without errors from the addon; `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0; no addon file in the `.pck` (export file list); export size unchanged (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:22
**Addon** (D11, W6): the Godot Asset Store download of version 4.2.0 (`/asset/hungryproton/protonscatter/download/4384/`, 10,151,948 bytes, SHA-256 `ea971151188dfa33ad78c0a53058cfdfdc0a97e4d310641a14dfefe9b5e0e449`; `plugin.cfg` says 4.2.0, `LICENSE` MIT "Copyright (c) 2019 HungryProton") copied unchanged into `addons/proton_scatter/` without `demos/` (11.8 MB) and `tests/` — 334 files, 0.6 MB. The two built-in presets (`presets/grass.tscn`, `scatter_default.tscn`) name demo assets by path; they are loaded only when someone picks them in the editor's preset menu, so they stay unchanged (the import shows no error). Enabled in `project.godot` next to GUT; `tools/versions.json` `"protonscatter": "4.2.0"`; `check_tools.ps1` checks `addons/proton_scatter/plugin.cfg` like GUT (pending without `project.godot`, fails when missing or another version); `export_presets.cfg` excludes `addons/proton_scatter/*`; `LICENSES.md` row (source, version and date, download date, zip SHA-256, licence file) and the "excluded from the export" paragraph; README (folders, setup, `check_tools.ps1`) and `docs/architecture.md` (folders, checks) name the addon.
**Export** (D16): the only trace of the addon in `index.pck` is its `plugin.cfg` path in the project settings (as GUT's) — no addon file. `index.pck` 306,300 bytes vs 306,252 at `6c00b7e` (exported from a scratch worktree, then removed): +48 bytes, the setting; `build/web` 40,427,430 bytes (+66,340 vs the Step 1 baseline of 40,361,090, budget +5 MB).
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — ProtonScatter 4.2.0 in `addons/proton_scatter/` (without demos and tests), pinned, checked by `check_tools.ps1`, credited, enabled in the editor and excluded from the export. `tools/check_tools.ps1` exit 0 (ProtonScatter 4.2.0), headless `--import` exit 0 without errors, `tools/test.ps1` 433 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 4.78 M tokens · CHF 1.68 (201 credits)

---

## Step 11 — Worlds and the world choice

### Goal
The arena layout is per world with a tested Glimmer Isles layout, and the player chooses the
world on home for **Play** and **Training** (W1, W2, W4, W7, S2).

### Tasks
- [x] Record the start time in Notes below.
- [x] `game/worlds.gd` and the per-world `ArenaLayout` (D9); callers read the active layout; the canyon's data unchanged.
- [x] The Glimmer Isles layout: walls, cover patches, decoration spots, dummies, start points (same size).
- [x] `GameState.world`; `WorldButton` and popup on home (D10); `Arena` and `MatchArena` use the chosen world; until Step 13, `GlimmerIsles` builds plain toon blocks and patches from the layout so the world is playable.
- [x] Tests: new `test_world_layouts.gd` (both layouts: starts free and ≥ 4 m apart, walls inside the bounds, every cover reachable, `in_bush` per world) and `test_world_choice.gd` (default canyon; the choice used by Play and Training; a bot finds the player in Glimmer Isles; saves unchanged); all existing arena and bot tests green for the canyon.
- [x] Check: screenshot of home with the world button and popup at 1280×720 and 390×844; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:31
**Worlds and layouts** (D9, W1, W4, W7): `game/worlds.gd` (`Worlds`: `LIST` canyon first, `ids()`, `get_world()`, `is_unlocked()` — every known world, no save field). `ArenaLayout`'s constants stay the canyon's layout, unchanged (`Canyon` and the canyon tests read them); `use(world_id)` sets the active layout in static variables (an unknown id gives the canyon), and `in_bush`, `is_free` and the new accessors `world()`, `walls()`, `border_count()`, `bushes()`, `decoration()`, `dummies()`, `starts()`, `start()` read it. `Arena` (start, dummies, near wall), `MatchArena` (starts), `BotBrain` (fallback wander point) and `ControlsHelp` (dummy count) now use the accessors. `game/glimmer_isles_layout.gd` (`GlimmerIslesLayout`): the canyon's size and border, 7 crystal ridges, 5 glow-fern patches, 10 decoration spots (crystal, mushroom, stone), 3 dummies and 9 starts. `GameState.world` (memory only, `reset()` → canyon). **Choosing the scenery:** `Arena` handles `NOTIFICATION_SCENE_INSTANTIATED` (before any child is ready) — `ArenaLayout.use(GameState.world)` and, for Glimmer Isles, `GlimmerIsles` replaces the scene's `Canyon` node on the same `Floor` and `Walls` (`match.tscn` inherits the scene, so the notification comes once per scene level; the second finds no `Canyon`). `scenes/worlds/glimmer_isles/glimmer_isles.gd` (`GlimmerIsles`, for now): violet sky and ambient light, a pale teal ground with its collision, the border in violet, the crystal ridges as glowing cyan toon blocks (collision boxes from the layout, the canyon's wall heights, so the camera framing of G11 holds), the fern patches as green ground; Step 13 adds the baked props.
**World choice** (D10, W2): `scenes/ui/world_choice.tscn` + `.gd` (`WorldChoice`: a dimmed screen with a `CardPanel` "Choose a world" and one 400×84 button per world, the current one `GreenButton` with a tick, the other purple with the world icon; a choice sets `GameState.world` and closes it, a tap on the dimmed part closes it unchanged). Home's `WorldButton` (world icon, the current world's name, new theme variation `TealButton`: compact teal, 28 px text, 76 px tall = 45.6 px on a phone) opens it. **Differs from D10:** the button sits in the top bar between the trophy and credit chips, not next to **Play** — next to Play it did not fit the phone held sideways (844×390: the controls column is full) and would have moved **Play**'s node path; the top bar has room at all five sizes. README (home, *How to play a match*) and `docs/architecture.md` (home, arena, `ArenaLayout`, `Worlds`, `GlimmerIslesLayout`, tests) updated.
**Tests**: new `tests/test_world_layouts.gd` (7: worlds, canyon default and unchanged, Glimmer Isles active and as big with the same border, walls/cover/decoration/dummies fit, starts free and ≥ 4 m apart, every cover and start reachable on foot from the player's start — a 0.25 m grid walk with the 0.4 m fighter radius —, `in_bush` per world) and `tests/test_world_choice.gd` (10: canyon default on home, the button opens the choice with the current world marked, choosing Glimmer Isles keeps it and shows it on home, a tap beside closes without change, Training and a match built in Glimmer Isles with its walls, start, dummies and bot starts, back to the canyon, a bot fires at the player in Glimmer Isles, wander points free in Glimmer Isles, the world is not saved). All existing arena, bot and screen-size tests unchanged and green (the first world button, 60 px tall, was below 44 px on the phone sizes → 76 px).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step11\`, viewed): `godot_home_world_<size>.png`, `godot_home_world_choice_<size>.png`, `godot_home_world_glimmer_<size>.png` and `godot_training_glimmer_<size>.png` at 1280×720 and 390×844 — the teal "Canyon" button between the chips, the choice over the dimmed home with Canyon marked, "Glimmer Isles" on the button after choosing, Training in Glimmer Isles (plain glowing blocks, fern patches, the dummies). Nothing changed after looking.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — the arena layout per world (`Worlds`, `ArenaLayout.use`, `GlimmerIslesLayout`), the world choice on home for Play and Training, Glimmer Isles playable with placeholder blocks; `tests/test_world_layouts.gd`, `tests/test_world_choice.gd`. `tools/test.ps1` 450 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 10.98 M tokens · CHF 2.93 (349 credits)

---

## Step 12 — Glimmer Isles objects and scatter scene

### Goal
The fantasy props exist in the outlined look, and a ProtonScatter scene places them from the
layout (W1, W3, D13).

### Tasks
- [x] Record the start time in Notes below.
- [x] Props in `scenes/worlds/glimmer_isles/props/` (crystal cluster, glow fern, small mushroom, giant mushroom, floating island chunk), each a small scene from primitive meshes with D5 materials.
- [x] `scatter_source.tscn`: one `ProtonScatter` per kind with its `ScatterItem`s and `ScatterShape` boxes from the layout (negative boxes around the start points), fixed seeds; `LICENSES.md` own-work row for the props.
- [x] Check: a windowed run of the source scene with the scatter rebuilt shows the props in the right places (screenshot from above and from the game camera); `test.ps1`, `lint.ps1` exit 0 (the source scene is not loaded by the game).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:45
**Props** (D13, W3): one `@tool` script `props/glimmer_prop.gd` (`GlimmerProp`, `kind` one of `KINDS`; setting it builds the parts at once, so `instantiate()` — what `ScatterItem` does, also in the editor — gives a finished prop) and five scenes `props/crystal_cluster.tscn` (a dark violet rock with three glowing six-sided spikes, cyan and pink, ~1.5 m), `glow_fern.tscn` (four green fronds with glowing tips, ~1.1 m, half-hides a fighter like a cactus), `small_mushroom.tscn` (cream stem, glowing violet cap), `giant_mushroom.tscn` (~4 m, pink cap with light gills), `island_chunk.tscn` (a grass disc on a rock cone with hanging roots). Every part is a direct `MeshInstance3D` from a primitive mesh with a `ToonMaterials` material (cel-shaded, outlined, glow where it shines), placed without scale — so the bake can give each part its own MultiMesh with a correct outline (ProtonScatter merges a prop's parts into one mesh, whose outline would grow from the prop's origin, not from each part). `ToonMaterials` became `@tool` (the props build in the editor too). The decoration kind "stone" of Step 11's layout had no prop: those three spots are now crystal or mushroom (`GlimmerIslesLayout.DECORATION`, test and `docs/architecture.md` updated).
**Scatter source** (`scenes/worlds/glimmer_isles/scatter_source.tscn`, D13): written once by a temporary generator from `GlimmerIslesLayout` (outside the repository, removed) and from now on edited in the editor like any scene. Seven `ProtonScatter`s with fixed `global_seed`s (11–17), chunks off: **Crystals** (a box inside each of the 7 crystal ridges, inset 0.15 m, grid 0.85 m + small jitter, random turn, scale 1–1.35; 31 clusters), **BorderCrystals** (random on top of the north, west and east border walls, not the low camera-side one; 41), **Ferns** (a box inside each of the 5 fern patches, grid 0.62 m + jitter, 75 % glow ferns and 25 % small mushrooms; 88), **DecorationCrystal** / **DecorationMushroom** (one *Add Single Item* modifier per decoration spot; 5 + 5), **GiantMushrooms** (random on the rim strips west, east and north of the border; 12), **Islands** (random in big boxes around and 4 m below to 1 m above the arena; 16). Crystals and Ferns have a negative 1.5 m box around each of the 9 start points. The grid boxes' tops lie on exactly representable heights (0.0, 0.375): the grid modifier puts its points on the top face of the shapes (it keeps `restrict_height` on after a reload), so a box top that is not exact in binary can drop every point. The scene references only addon scripts and the prop scenes; the game never loads it and `export_presets.cfg` now leaves it out of the export as well (it needs the excluded addon). `LICENSES.md`: own-work row for the props and their placement.
**Tests**: new `tests/test_glimmer_props.gd` (2: every prop scene has outlined toon parts from primitive meshes, direct and without scale, right after `instantiate()`; changing `kind` rebuilds the parts).
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step12\`, viewed): a windowed run of Training in Glimmer Isles with `scatter_source.tscn` added and every scatter rebuilt on the main thread (`dbg_disable_thread`) — `godot_scatter_game_camera_<size>.png` (the game camera; Step 11's placeholder crystal blocks hidden so the clusters show), `godot_scatter_above_<size>.png` and `godot_scatter_above_arena_<size>.png` (orthographic from above: clusters exactly on the ridge rectangles, ferns and mushrooms filling the patches, one prop per decoration spot, border crystals on three sides, giant mushrooms on the rim, islands around), `godot_props_<size>.png` (close-up) at 1280×720 and 820×1180. After looking: both mushroom caps were tall egg shapes (a hemisphere's `height` is its own height, not the whole sphere's) → flat domes; the crystal ridges now read as crystal walls; the pale ground and the lighting are Step 13.
**Done (2026-11-22 · ~11 min · Claude Opus 5.5)** — five original Glimmer Isles props built from primitive meshes in the outlined look, and the ProtonScatter source scene placing them from the layout with fixed seeds; `tests/test_glimmer_props.gd`. `tools/test.ps1` 452 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 12.65 M tokens · CHF 3.18 (379 credits)

---

## Step 13 — Glimmer Isles baked and playable

### Goal
The scatter result is baked into a plain scene, Glimmer Isles is played with it in Training and a
match, also in the web export, at a good frame rate (W3, W4, W5, D12).

### Tasks
- [x] Record the start time in Notes below.
- [x] `tools/bake_world.ps1` + `tools/bake_world.gd` (D12) write `baked.tscn`; `GlimmerIsles` loads it with the floor and the layout colliders; the sky gradient and glow.
- [x] New `test_glimmer_isles.gd`: `baked.tscn` loads without the addon and references no `addons/proton_scatter` path; props in every wall and cover rectangle; no prop on a start point.
- [x] Desktop: draw calls and frame time of a 4-fighter match in Glimmer Isles vs the canyon in Notes; web: `export_web.ps1`, `serve_web.ps1`, a match in Glimmer Isles in a browser starts and runs (screenshot); export size noted (D16).
- [x] Check: screenshots of Training and a match in Glimmer Isles at 1280×720 and 820×1180; `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 14:56
**Bake** (D12, W5): `tools/bake_world.ps1` imports the project and runs `tools/bake_world.gd` headless: it loads `scatter_source.tscn`, sets every `ProtonScatter` to `dbg_disable_thread`, `enable_updates_in_game` and `force_rebuild_on_load`, waits for every `build_completed` (main thread), and writes `scenes/worlds/glimmer_isles/baked.tscn` — one plain `MultiMeshInstance3D` per prop part (19: crystal cluster 4, glow fern 6, small mushroom 2, giant mushroom 3, island chunk 4), no script, no addon path, 127 KB. **Differs from D12** (found while baking headless): a headless run has no renderer, so a MultiMesh holds no transforms there (the scatter's own output and a baked MultiMesh both came back empty or as identity) and a `ShaderMaterial` saves its unset uniforms as `null`; so the bake reads the places from each scatter's transform list and splits them between its items as ProtonScatter does (`_update_multimeshes`, chunks off), and stores per part the places (`transforms`, prop place × part offset) and colours (`albedo`, `glow`, `glow_strength`, `outlined`) as metadata; `GlimmerIsles.load_baked()` fills each MultiMesh and puts the shared `ToonMaterials` material on it (fighters, canyon and Glimmer Isles share one material per colour). Two bakes give the same places; only Godot's random node `unique_id`s differ. ProtonScatter 4.2.0's grid modifier puts its points at the height *bounds max + bounds min* of its shapes, so the grid boxes of `scatter_source.tscn` were changed to [−0.25, 0.25] m (ferns and mushrooms on the ground) and [−0.25, 0.5] m (crystal clusters at 0.25 m, on the plinths); counts unchanged (crystal clusters 77, glow ferns 66, small mushrooms 27, giant mushrooms 12, island chunks 16).
**World** (W3, D13): `GlimmerIsles` now builds a tiled teal-lavender ground (MultiMesh, per-tile colour) with a path of glowing stones along the two middle lines (skipping walls and patches), the violet border walls with caps (unchanged heights, so G11's framing holds), low dark-violet rock plinths (0.25 m) under the crystal ridges — the baked clusters fill the ridge rectangles; the collision boxes stay 1.4 m —, the fern-patch ground, the island's teal rim (where the giant mushrooms stand) and a rocky underside cone, a starry-violet `ProceduralSkyMaterial` gradient (the camera looks down, so its dark lower half shows around the island), lavender ambient light and a pink-white sun; Step 11's "Outside" plane and glowing blocks are gone. **Glow** is the props' own emission (crystals, fern tips, mushroom caps, path stones), not the environment's glow post-process: a full-screen pass costs too much on the iPad for G14/W5.
**Tests**: new `tests/test_glimmer_isles.gd` (4: `baked.tscn` has no `addons/` or `proton_scatter` text, only plain `MultiMeshInstance3D`s without script, every prop kind placed; crystal clusters in every ridge, ≥ 6 plants in every fern patch, one prop at each decoration spot; no prop within 0.75 m of a start point; in the game every MultiMesh is filled and on a cel-shaded material with the stored outline choice, and no node of the running world has an addon script).
**Frame rate (desktop, 1280×720, vsync off, a 4-fighter match, mean of 240 frames, two runs each):** canyon 748 / 738 draw calls, 9.1 / 3.1 ms per frame; Glimmer Isles 623 / 670 draw calls, 7.8 / 3.7 ms per frame — the same within the run-to-run noise, about 0.8 M primitives each. The iPad check stays with Step 20 (G14, W5).
**Web** (D16): `tools/export_web.ps1` exit 0, `build/web` **40,510,230 bytes** (+149,140 vs the Step 1 baseline; budget +5 MB), `index.pck` 389,100 bytes (+82,800 vs Step 10, the baked scene and the world code; the plan's ≤ 1.5 MB for Glimmer Isles met); `scatter_source.tscn`, the bake tool and the addon are not in the `.pck` (the addon only as its `plugin.cfg` path in the project settings). `tools/serve_web.ps1` (port 8061) and headless Edge (software WebGL, Playwright): skip the entrance, world button → Glimmer Isles → Play: the match starts in Glimmer Isles in the single-threaded web build, countdown "2" and then "FIGHT!" (`web_match_glimmer_1280x720.png`, `web_match_glimmer_later_1280x720.png`; software rendering in a headless browser runs at about 1 frame per second, so it says nothing about the frame rate); server stopped.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step13\`, viewed): `godot_training_glimmer_<size>.png` and `godot_match_glimmer_<size>.png` (5 s in) at 1280×720 and 820×1180, and the web shots above. Crystal ridges read as walls, the fern patches are dense, the outlined props match the fighters' look, the near border stays a thin strip. Nothing changed after looking.
**README**: *Commands* gets `bake_world.ps1` and a *How to change Glimmer Isles* section (edit the source scene or props, bake, test, commit both); `docs/architecture.md` (tools, 3D models, tests) updated.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — the bake tool, Glimmer Isles built from its baked props with ground, path, plinths, rim, sky and lights, playable in Training, a match and the web export; `tests/test_glimmer_isles.gd`. `tools/test.ps1` 456 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0, `tools/bake_world.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 13.27 M tokens · CHF 3.05 (364 credits)

---

## Step 14 — Gate: author's drawing photo

### Goal
Part A starts only with the author's real photo: the run stops here and tells the author exactly
what to do (A0, A1, A7, D14, D17). No code.

### Tasks
- [x] Record the start time in Notes below.
- [x] Author has modified this. I saw the instruction and placed the image named: character_drawing_01.png at `%USERPROFILE%\hack_star_drawings\`. No need to stop, we can continue. So, don't Stop the implementation and the requests  *"Please photograph one of Mattia's drawings: the whole drawing, lying flat, in daylight, on plain paper, with nothing else in the picture — no people, faces, full names, addresses or places. Remove the photo's location and other metadata (or send it as a screenshot of the photo). Send it in the chat or put it in `%USERPROFILE%\hack_star_drawings\`, and tell me the fighter's name (1–12 letters), which existing fighter's attack it should use, and the first name or nickname for `LICENSES.md`. If you also want the part B trial (Step 19), it needs your Google Flow and Meshy accounts."* is already done. 
- [x] Create a name for the character by yourself. 
- [x] Check: the photo has arrived and its location is noted (not the photo itself); no need for the author's answers (name, attack, credit name)  in Notes since you decide the name..

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:12
**Gate** (A0, D17): the author placed the photo and asked to continue without stopping; the run goes on with Step 15.
**Photo**: `%USERPROFILE%\hack_star_drawings\character_drawing_01.jpg` (JPEG, 1308×1744 px, 710 KB) — the author's task line says `.png`, the real file is `.jpg`. Location noted only; the photo is not copied into the repository (A7). Viewed: it shows only the drawing on plain white paper — no people, faces of real persons, full names, addresses or places; only a tiny pen mark ("B-") at the lower right edge of the paper. **Metadata**: no EXIF and no GPS (System.Drawing finds only the two JPEG quantisation tables, no camera, date or location tags); Step 16 re-encodes it anyway (D14).
**Drawing** (shapes and colours, no personal data): a chibi kid in a crouching action pose, front view, big round head; spiky hair in purple and navy with a pink streak across it; large white-and-teal over-ear headphones (white band, teal cups with an orange detail, a small red block on top of the right cup); big dark-blue eyes, serious look; white jacket with teal trim (round teal shoulder pad with orange edge, teal collar, hem and cuff); navy trousers; black shoes; one hand in a black fingerless glove touching the ground; the other arm is a long white tube (an arm cannon or bat) held forward and down.
**Name**: **Beatbolt** (8 letters, within 1–12) — "beat" for the big headphones, "bolt" for the shots from the white tube arm cannon; original (not from a game, film or brand known to us), not an existing fighter in `game/fighters.gd` (Blaze, Rocko, Turbo, Frosty, Luna, Pixel) and not "Blaze".
**Attack source** (D14, A6): **Luna** — the space cat with a ray gun; the tube arm cannon is a ranged weapon like her ray gun. Today every fighter shares the same shot rules of `game/combat.gd` (speed, range, cool-down, damage), so Step 16 copies Luna's entry (stats and attack) without a new attack.
**Credit name** for `LICENSES.md`: "Mattia (drawing)".
No code changed in this Step, so `tools/test.ps1` and `tools/lint.ps1` were not run.
**Done (2026-11-22 · ~2 min · Claude Opus 5.5)** — photo found at `%USERPROFILE%\hack_star_drawings\character_drawing_01.jpg` (not `.png`), checked (only the drawing, no EXIF/GPS), the fighter named Beatbolt with Luna's attack, credit "Mattia (drawing)"; no code changed; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 650 k tokens · CHF 0.32 (39 credits)

---

## Step 15 — Drawing workflow document

### Goal
`docs/drawing_to_fighter.md` tells the author how to photograph a drawing, where to put it, what
to ask Claude, what the result can and cannot be and how long it takes (A1, A6, A7, D15).

### Tasks
- [x] Record the start time in Notes below.
- [x] Write the document: photo rules and privacy (A7, as Step 14's request), where the photo goes, metadata removal (D14), the exact request to Claude via Copilot, the limits of A6 (one drawing per run, front view only, no fine lines/texture/writing, name 1–12 letters, a fighter not a new attack, 3D from shapes with the cut-out fallback), expected time; link from the README.
- [x] Check: the document's steps match what Step 16 does (re-read after Step 16); links valid; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:14
**Document** (D15): `docs/drawing_to_fighter.md` — 1 photograph (only the drawing, flat, daylight, nothing else; no people, faces, full names, addresses, places; remove metadata; own idea, no copied character), 2 where it goes (`%USERPROFILE%\hack_star_drawings\` outside the repository or the chat; never committed) and the three choices (name 1–12 letters, the fighter whose attack and starting numbers it copies, the credit name), 3 the exact request to Claude and what Claude then does (re-encode with `Image` ≤ 1024 px `save_png` outside the repository, read shapes and colours, build from shapes in `scenes/drawn/<id>_model.gd` with `ToonMaterials`, the three places of D14 + `SampleProgress`, credit, screenshots next to the photo, the child's "this is my drawing"), the A6 limits (one drawing per run, front view only, shapes not lines, no new attack, name 1–12 letters, the cut-out fallback) and the time (≈ 15 min of the author, 30–60 min of Claude). Linked from the README (*Layout* `docs/` row and a new *How to turn a drawing into a fighter* section). Written before Step 16 from D14 and the Step 16 plan; the re-read against what Step 16 really did is in Step 16's Notes (any change goes into Step 16's commit). *Add another drawing* / *Remove a drawn fighter* come in Step 17.
**Done (2026-11-22 · ~5 min · Claude Opus 5.5)** — `docs/drawing_to_fighter.md` (photo and privacy rules, where it goes, the request to Claude, limits, time) and the README links; links checked by hand. `tools/test.ps1` 456 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.32 M tokens · CHF 0.97 (116 credits)

---

## Step 16 — Drawn fighter in the game

### Goal
Mattia's drawing is a new fighter built from shapes, unlocked from the start, with its name,
card, animations and see-through, playable in Training and a match (A2, A3, A4, A5, A8).

### Tasks
- [x] Record the start time in Notes below.
- [x] Re-encode the photo without metadata (D14); describe the drawing's main shapes and colours in Notes (no personal data).
- [x] Add the fighter (D14): `Fighters.LIST` entry, `scenes/drawn/<id>_model.gd`, the `drawn_fighters.gd` row; the cut-out fallback only if shapes cannot carry the drawing (say why in Notes).
- [x] `LICENSES.md`: the drawn character as the child's own work under the repository licence, with the chosen name; confirm it is not copied from a game, film or brand.
- [x] Tests: new `test_drawn_fighter.gd` (in the list, selectable, shown on home, plays in Training and a match, has idle/run/attack and see-through); update the fighter counts in existing tests.
- [x] Check: screenshots of the card, the fighter screen, home and a match next to the photo; export size noted (D16); `test.ps1`, `lint.ps1` exit 0.
- [x] Screenshots ready to send to the author for Mattia's "this is my drawing" (A3) — the answer itself is *waiting for the author* (not invented; moved to Deferred Items, target Step 20 / author).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:19
**Photo** (D14, A7): re-encoded with Godot's `Image` (load the JPEG → Lanczos resize to 768×1024 → `save_png`) by a temporary headless script outside the repository into `%USERPROFILE%\hack_star_drawings\character_drawing_01_clean.png` (1,237,131 bytes, a PNG without metadata); viewed: only the drawing. Neither the photo nor the PNG is committed (the shapes version needs no picture; only the cut-out fallback would).
**Drawing** (shapes and colours, no personal data; adds to Step 14's description): big round head with yellow-peach skin; spiky hair in purple and navy, the big locks swept to both sides and a fringe over the forehead, a pink streak across the left side; big dark-blue eyes with black upper lids under serious slanted brows, a small frown; large white over-ear headphones with teal cups, an orange mark on each and a red block on top of the right one, the white band crossing over the hair; white jacket with teal collar, hem and a teal stripe down the front, a round teal shoulder pad with an orange edge on the left shoulder (screen right); left hand in a black fingerless glove with the fingertips showing, teal cuff; the right arm a long white tube with a cuff ring and an orange accent; navy trousers, black shoes; a crouching pose.
**Fighter** (D14, A2, A4): `Fighters.LIST` gets `beatbolt` ("Beatbolt", `drawn: true`, unlocked, one Default skin, rarity Mythic and `SampleProgress` 0 trophies / power 1 copied from Luna — every fighter shoots with `Combat`'s shared rules, so the attack is Luna's without a new one); old saves get him through `Fighters.start_unlocked()` (tested). `scenes/drawn/drawn_fighters.gd` (`DrawnFighters`: the `MODELS` table, `has`, `looks`, `build`) and `scenes/drawn/beatbolt_model.gd` (`LOOKS` + static `build`): legs, shoes, jacket with teal hem, collar and stripe; head, eyes (dark-blue pupils on whites), lids, brows, frown; `SpikyHair` (cap, navy back, 11 swept locks, 5-lock fringe, `PinkStreak` of 4 segments on the cap); `Headphones` (cups with teal discs and orange marks, sliders, a 7-segment band over the hair, the red `BeatLight` that flickers); the glove arm with cuff, black glove, fingertips, `ShoulderPad` with an orange ring; `ArmCannon` (the long white tube with cuff and orange ring). The whole rig is scaled 0.85 (his hair and headphones made him taller than the others and hid the health bar at `Fighter.BAR_Y` 2.3). `FighterModel.setup` asks `DrawnFighters` first; its building blocks became public for the look files (`part`, `group`, `eyes`, `flicker`, static `sphere`, `capsule`, `cone`, `cylinder`, `box`, `torus` — renamed from `_…`, no change in what they do) with `get_rig`, `get_body`, `get_head`; the six fighters are unchanged. **No cut-out fallback**: the drawing's parts are all round or straight shapes, so they carry it. **Differs from the drawing**: the crouching pose becomes the standing pose (the idle, run and attack animations need it), written in `docs/drawing_to_fighter.md` (A6).
**Licence** (A8): `LICENSES.md` *Own work* row — Beatbolt, the child's own drawing, credited "Mattia (drawing)", MIT as the repository, the photo not in the repository; not a character of a game, film or brand known to us.
**Tests**: new `tests/test_drawn_fighter.gd` (9: a drawn, unlocked fighter with one Default skin and a 1–12 letter name; rarity and numbers of Luna; every drawn fighter has one look file and every look file a drawn fighter; an old save without him gets him unlocked; selectable and on home; plays in Training (runs) and in a match against the bots; idle, run and attack; see-through and back). Updated for the 7th fighter only: `test_fighters.gd` (7 fighters, a drawn one has 1 skin, 15 skins, start unlocks, ids), `test_fighter_model.gd` (Beatbolt's idea parts, 15 combinations — the cel-shading and outline tests cover him), `test_fighter_list.gd` (7 cards), `test_sample_progress.gd`, `test_game_state.gd`, `test_game_state_save.gd`, `test_hack_effects.gd` (the start unlocks). The first version of the match test left its match in the tree, whose walls stopped a shot in `test_fighter_health.gd`; the test now frees it.
**Screenshots** (`%LOCALAPPDATA%\hack_star\screens\09\step16\`, a windowed run with a temporary `-s` capture script kept outside the repository, viewed next to the photo): `godot_closeup{,_turn,_back}_1280x720.png` (on the stage: front, turned, back), `godot_cards_`, `godot_fighter_`, `godot_home_`, `godot_match_` (5 s in) at 1280×720 and 820×1175 (the desktop caps the window height at 1175, not 1180), `godot_training_1280x720.png`, `godot_closeup_820x1175.png`. After looking: (1) the hair cap covered the eyes and the fringe and brows were inside the head → cap moved up and back, fringe and brows in front of the forehead; (2) a "sunburst" of thin spikes → fewer, wider locks swept to the sides as drawn; (3) the pink streak looked like a hairpin, then like a headband → a diagonal streak of 4 segments on the left; (4) the headphone band was hidden in the hair → a larger band with sliders; (5) in the match his health bar was hidden in his hair → the figure scaled 0.85, the bar shows; (6) a straight mouth → a small frown. **How he reads now**: on home, the fighter screen and the 150 px card the spiky purple-and-navy hair with the pink streak, the big white headphones with teal cups and the red light, the big blue eyes, the white jacket with teal trim and shoulder pad, the black glove, navy trousers, black shoes and the long white arm tube are all recognisable; in the match (seen from above) the purple spikes, the white band and the white tube make him easy to tell from the other fighters.
**Waiting for the author (A3)**: Mattia's "this is my drawing" cannot be asked by the agent; the screenshots above wait for the author and Mattia in that folder (best: `godot_home_820x1175.png`, `godot_fighter_1280x720.png`, `godot_closeup_turn_1280x720.png`, `godot_cards_1280x720.png`, `godot_match_1280x720.png`), next to the photo. No answer is invented; the item is in **Deferred Items** (target Step 20 / author).
**Size** (D16): `tools/export_web.ps1` exit 0. In the working tree the export is 45,232,739 bytes (`index.pck` 5,111,608) because Godot packs the author's untracked `characters/` folder (Blaze PNGs and scenes, created 15:11, not part of this spec, not committed). What this Step adds, measured on a scratch copy of the project without `characters/` and `scenes/blaze_godot.zip` (under `%LOCALAPPDATA%\hack_star\step16\`, not committed): `build/web` **40,520,286 bytes** (+10,056 vs Step 13's 40,510,230; +159,196 vs Step 1's 40,361,090), `index.pck` 399,156 bytes (+10,056) — the plan's "drawn fighter (code) ≈ 0" holds. If the author's `characters/` folder joins the export it adds about 4.7 MB (then +4.87 MB vs Step 1, close to the 5 MB budget of G15).
**Step 15 re-read** (its check): `docs/drawing_to_fighter.md` matches what this Step did; adjusted in this commit: the rarity is copied too, and the figure is scaled to the others' height so the health bar stays visible. `docs/architecture.md` (*Game rules* `Fighters`, *3D models* drawn fighters, *Tests*) updated.
**Done (2026-11-22 · ~25 min · Claude Opus 5.5)** — Beatbolt built from shapes after Mattia's drawing (`scenes/drawn/`, `DrawnFighters`, `Fighters.LIST`, `SampleProgress`), credited, tested and checked on screenshots next to the photo; Mattia's A3 answer waits for the author (Deferred Items). `tools/test.ps1` 465 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 18.96 M tokens · CHF 4.94 (589 credits)

---

## Step 17 — Adding and removing drawn fighters

### Goal
A second drawing can be added the same way without touching other fighters, and a drawn fighter
can be removed with saves falling back to the default fighter (A9).

### Tasks
- [x] Record the start time in Notes below.
- [x] `docs/drawing_to_fighter.md`: *Add another drawing* and *Remove a drawn fighter* sections (the three places of D14).
- [x] Tests in `test_drawn_fighter.gd`: a save that selected an unknown (removed) drawn fighter loads with the default fighter and keeps the rest; adding a drawn fighter changes no other fighter's data.
- [x] Check: a dry run of the removal on a scratch copy (not committed) leaves the tests green; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:44
**Document** (A9): `docs/drawing_to_fighter.md` gets *Add another drawing* (the new look file, its `DrawnFighters.MODELS` row, its `Fighters.LIST` entry with the two `SampleProgress` numbers, its `LICENSES.md` row; no test change) and *Remove a drawn fighter* (delete the same places and the doc mentions; a save that chose it falls back to Blaze and keeps the rest); D14's three places plus the `SampleProgress` lines Step 16 added. `docs/architecture.md` (*3D models*, *Tests*) updated.
**Tests made independent of the drawn fighters** (so adding or removing one changes no test): `test_drawn_fighter.gd` now checks *every* drawn fighter (12 tests): unlocked with one Default skin and a 1–12 letter name; rarity and numbers of the fighter in its new `"plays_like"` field (`"luna"` for Beatbolt); one look file per drawn fighter and back; its `IDEA_PARTS` (new const in the look file, read by `DrawnFighters.idea_parts`; Beatbolt: `SpikyHair`, `PinkStreak`, `Headphones`, `ArmCannon`); old saves; **new** `test_a_save_that_chose_a_removed_drawn_fighter_falls_back_to_the_default` (a version 3 save with `selected_fighter`, trophies, power, unlock and skin of an unknown `removedbolt` → Blaze chosen, the unknown id dropped everywhere, Blaze's 1300 trophies, Rocko's power 6 and 42 credits kept); **new** `test_drawn_fighters_change_no_other_fighter` (the six originals first, in order, with their names, rarities, skins, unlocks, start numbers and own looks; `FighterModel.LOOKS` still six); the home, Training, match, animation and see-through tests on the first drawn fighter (with none: pass with a note). Step 16's count changes were replaced: `test_fighters.gd` checks the six originals (drawn ones filtered), `test_fighter_model.gd` the originals' idea parts and 14 + the drawn skins, `test_fighter_list.gd` 6 + the drawn cards, `test_game_state.gd`, `test_game_state_save.gd`, `test_hack_effects.gd` compare with `Fighters.start_unlocked()`.
**Dry run** (A9): the project copied without the author's `characters/` and `blaze_godot` files to `%LOCALAPPDATA%\hack_star\step17\proj` (never committed); there Beatbolt was removed exactly as the document says (deleted `beatbolt_model.gd` and its `.uid`, `MODELS = {}`, the `Fighters.LIST` entry, the two `SampleProgress` lines); only a comment in `test_drawn_fighter.gd` still named him. `tools/test.ps1` 468 tests passed (the first run had 3 "risky" tests that asserted nothing without a drawn fighter → they now pass with a note; re-run clean), `tools/lint.ps1` exit 0. The copy was deleted; the repository was never changed by the dry run.
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — add and remove sections in the workflow document, the drawn-fighter tests made generic with the removed-fighter save fallback and the no-change-to-others check, the removal dry run green on a scratch copy. `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 5.84 M tokens · CHF 1.50 (179 credits)

---

## Step 18 — Tool recommendation document

### Goal
`docs/drawing_tools.md` recommends one main workflow with at most three tools and one fallback,
with the facts, terms and limits of each tool (B1, B2, B3, B4, B5, D15).

### Tasks
- [x] Record the start time in Notes below.
- [x] Re-check the sources of Part 1's research table (Google Flow, Meshy, Tripo/Hunyuan3D/TRELLIS, Godot import) and date every fact.
- [x] Write the document: main workflow (Google Flow → Meshy → Claude in Godot) step by step, fallback (Claude alone, or Google Flow → Claude), facts per tool (what it does, cannot do, cost, account and minimum age, output format and Godot import, training on uploads, terms for an MIT game), Google Flow's place (B3), licence first and credits for `LICENSES.md` (B4), the fit limits (MB and triangles for 30 fps on an iPad, outlined look via D5, the A4 animations) (B5); "not legal advice"; link from the README.
- [x] Check: every fact has a source and date; no tool with unclear terms recommended; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 15:58
**Sources re-checked** (2026-11-22, web_fetch/web_search): Flow help *Get started* and *Manage your credits*, the Flow Privacy Notice (2026-05-19), the Feb 2026 Flow blog, Google Terms of Service (effective 2026-07-30), Meshy pricing, docs (*Pricing and credits*, *Image to 3D*, *Animation*), Meshy Terms of Service and Privacy Policy (both 2026-09-19), the Oct 2026 image-to-3D comparison, the Hunyuan3D-2.1 licence, Godot's *Available 3D formats*, CC BY 4.0. **New or changed against Part 1's table:** Meshy's free plan downloads only **10 Meshy 6 Lite models a month** (no texture at generation; AI Texturing 10 credits), has **20** of the animation presets, rigging and presets cost 0 credits; Meshy's minimum age is **14** (under 18 with a parent's permission); Meshy may **train on uploads and outputs** of non-Enterprise users (opt-out by e-mail to support@meshy.ai); on the free plan **Meshy owns the output** and licenses it under CC BY 4.0; uploads to the **Meshy Community** become CC BY-NC 4.0 (images) / CC0 (models) — so never publish there; Google Flow uses uploads and outputs to improve products and ML (switch *Help improve Flow* off); Google's terms forbid using AI output to develop ML models; the Pro price is shown as CHF 18 a month to a Swiss visitor (Part 1: about $20).
**Document** (D15, B1–B5): `docs/drawing_tools.md` — recommendation (main Google Flow → Meshy → Claude in Godot; fallback A Claude alone; fallback B Google Flow → Claude), licence first (B4), the main workflow in 5 steps, facts per tool (Google Flow with its place before the 3D tool, B3; Meshy; Claude; Godot 4.7), the tools not recommended (Tripo free = non-commercial, Hunyuan3D excludes the EU/UK/South Korea, TRELLIS.2 needs a 24 GB GPU), the `LICENSES.md` credit line for a Meshy free-plan model (CC BY 4.0, © Meshy LLC, changes noted), the fit limits (B5: ≤ 10,000 triangles per fighter, GLB ≤ 2 MB with textures ≤ 1024 px, rig with idle/run/attack, the D5 toon material and outline, licence, the child's preference), "not legal advice", and a *Sources* table (every fact, page date, read 2026-11-22). The fit limits are this spec's own numbers, reasoned from Step 13's ~0.8 M primitives per match and G15's budget. The *Trial (B6)* section is a placeholder for Step 19. Linked from the README (*Layout* `docs/` row and *How to turn a drawing into a fighter*) and from `docs/drawing_to_fighter.md`.
**Done (2026-11-22 · ~6 min · Claude Opus 5.5)** — `docs/drawing_tools.md` with the recommended workflow, fallbacks, facts and terms per tool with sources and dates, fit limits; README and workflow-document links. `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.49 M tokens · CHF 1.13 (135 credits)

---

## Step 19 — Trial of the recommended workflow

### Goal
The author runs the B1 workflow with one drawing on his own accounts; the result, time and cost are
recorded, and it joins the game only if its licence allows it and Mattia prefers it (B6, D17).
**Needs the author.**

### Tasks
- [x] Record the start time in Notes below.
- [x] Send the author the trial steps from `docs/drawing_tools.md` (free use only; Meshy free plan = CC BY 4.0, credit Meshy); wait — *waiting for the author* in Notes.
- [ ] Record in the document: what came out, time, credits used, problems.
- [ ] If Mattia prefers it to the Step 16 version and the licence allows: import the GLB (size and triangle limits of B5, D5 outline, A4 animations), credit in `LICENSES.md`; else keep the files out of the repository and say why.
- [ ] Check: the trial section of the document is filled; if imported, `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0 and the export size noted (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 16:04
**Waiting for the author** (B6, D17): the trial needs the author's own Google Flow and Meshy accounts, which the agent does not have; nothing of the trial is invented. Prepared in `docs/drawing_tools.md` § *Trial (B6)*: before-you-start (folder `%USERPROFILE%\hack_star_drawings\trial\` outside the repository, the cleaned photo `character_drawing_01_clean.png` of Beatbolt, Meshy Free plan without card, the training opt-out e-mail to support@meshy.ai, never publish to the Meshy Community, Flow's *Help improve Flow* off), Step A Google Flow (the prompt to paste: front view, A-pose, whole body, plain white background, toon style with flat colours and thick outlines, Beatbolt's shapes and colours), Step B Meshy Image to 3D (Meshy 6 Lite, Pose A-Pose, licence CC BY 4.0, poly count 8,000 if offered — limit 10,000, AI Texturing at 1024 if grey, at most 3 models ≤ 60 credits), Step C rig (0 credits), idle + run + attack-like clip, download **GLB** with all clips as `beatbolt_meshy.glb`, Step D Mattia's preference next to the Step 16 screenshots, the list of what to send back (GLB and size, screenshots, time per step, Flow and Meshy credits before/after, model and settings, problems, Mattia's words, opt-out sent) and an empty *Trial results* table. The remaining tasks (record the result, import or not, check) wait for the author's files; the item is in **Deferred Items**. No game file changed; `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0.
**Done — agent part only, trial deferred (2026-11-22 · ~3 min · Claude Opus 5.5)** — trial instructions, prompts, settings, what to send back and the empty results table in `docs/drawing_tools.md`; Deferred Items row added. `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 434 k tokens · CHF 0.14 (17 credits)

---

## Step 20 — Final check, README and architecture

### Goal
Everything that worked before still works, the size budget is met, the after-screenshots and the
author's verdict are recorded, and the documents describe the new look, the world and the
workflows (G1, G14, G15, G16, W5, S2, S3, S4, S5, S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (all exit 0); every `.ps1` changed parses with `[System.Management.Automation.Language.Parser]::ParseFile`; `git status` shows nothing outside `hack_star_godot/` (S5).
- [x] Size: compare `build/web` with Step 1; ≤ +5 MB (G15, D16); write both numbers in Notes.
- [ ] After screenshots (D2) into `%LOCALAPPDATA%\hack_star\screens\09\after\`; the side-by-side session with the author and Mattia (G1, D17): their verdict per screen recorded in this Step's Notes; the iPad play-test (G14, W5: ≥ 30 fps with 4 fighters in the canyon and in Glimmer Isles, FPS switch of D8; playable within 5 s after **Play**) recorded — *waiting for the author* until then. *(Agent part done: the after set is captured and viewed; the verdict and the iPad play-test wait for the author — Notes and Deferred Items.)*
- [x] `README.md`: the new look, the world choice, Glimmer Isles and its re-bake (`tools/bake_world.ps1`), the FPS switch, links to both documents; `docs/architecture.md`: *UI foundation* (font, icons, theme, `MenuBackground`, `IconChip`), *3D models* (toon shaders, `ToonMaterials`, drawn fighters), worlds (`Worlds`, per-world `ArenaLayout`, `GlimmerIsles`, ProtonScatter bake), *Art and licences*; `LICENSES.md` complete (S4).
- [x] Check: every statement G1–G18, W1–W7, A0–A9, B1–B6, S1–S6 has a Step that is ✅ Done or a Note saying what waits for the author.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 16:07
**Checks** (S3): `tools/check_tools.ps1` exit 0 (Godot 4.7.2, web_nothreads templates, gdlint 4.5.0, GUT 9.7.1, ProtonScatter 4.2.0), `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0. The `.ps1` files changed in `91cc8be..HEAD` — `tools/bake_world.ps1`, `tools/check_tools.ps1` — parse with `Parser::ParseFile` with 0 errors. **S5**: `git diff --name-only 91cc8be..HEAD` lists nothing outside `hack_star_godot/`; `git status` shows only ` M .spec-nx` (the submodule, not ours) and the author's untracked `hack_star_godot/characters/`, `scenes/blaze_godot.zip`, `scenes/blaze_godot/` (his unrelated work in progress, not committed, not used).
**Size** (G15, D16; Step 1: `build/web` 40,361,090 bytes, `index.pck` 239,960): measured on a scratch copy of the project without the author's three untracked items (`%LOCALAPPDATA%\hack_star\step20\proj`, deleted afterwards), as Step 16 did: **`build/web` 40,520,478 bytes, +159,388 bytes (+0.16 MB) vs Step 1** — the budget of +5 MB is met by far; `index.pck` 399,348 bytes. In the working tree the export is **45,232,931 bytes (+4,871,841 vs Step 1)**, `index.pck` 5,111,800, because Godot packs every resource in the project folder, including the author's untracked `characters/` and `blaze_godot` files (about 4.7 MB); they are not part of this spec. Even so it stays under +5 MB, but with almost no room: if that work is committed later, its spec must count it against the size.
**After screenshots** (D2, G1), `%LOCALAPPDATA%\hack_star\screens\09\after\` (18 PNGs, all viewed; not committed): the 16 file names of the before set — `godot_` and `svelte_` × `home`, `fighters`, `fighter`, `match` × `1280x720`, `820x1180` — plus `godot_match_glimmer_1280x720.png` and `godot_match_glimmer_820x1180.png`. Godot: a windowed run (`--resolution`) with a temporary `-s` capture script outside the repository (deleted afterwards, never committed), the game's own save (now Blaze chosen, 1765 trophies), the matches 4 s in; the 820×1180 window is capped by the desktop at 820×1175 (as in Step 16), the files keep the D2 names. Svelte: `npm run dev` in `ui/` (port 5180; the FastAPI server already ran on 8180) and headless Edge through Playwright (`uv run --with playwright`, SwiftShader), a fresh account (Blaze), the match about 6 s in (countdown "1"); dev server stopped, nothing changed in `ui/`. Seen: home (gradient with rays, pedestal, two-colour outlined logo, coloured icon buttons, large yellow **Play**, trophy and coin chips, world button), fighter list (coloured backdrops by rarity, grey with a lock for locked fighters, rarity colours, trophy and power chips, Beatbolt as the seventh card), fighter screen (framed stage on a pedestal, chips, skin pictures in rarity frames, Legendary gold), match (outlined toon canyon with a soft sand floor, a thin near wall, timer and fighters-left chips, the hint on a dark backing, no FPS label) and Glimmer Isles. Nothing changed after looking.
**Waiting for the author** (D17): (1) **G1 verdict** — the author and Mattia compare `…\screens\09\before\` and `…\after\` side by side (same file names; open e.g. `godot_home_1280x720.png` of *after* next to `svelte_home_1280x720.png`), per screen (home, fighter list, fighter screen, match; desktop and iPad portrait) "as good as or better than the Svelte one?" — Mattia decides, the author breaks a tie; their words go into these Notes. (2) **A3** — Mattia's "this is my drawing" for Beatbolt (Step 16 screenshots in `…\screens\09\step16\`, and `godot_fighters_*.png` of the after set). (3) **G14 / W5 / G15 iPad play-test** — `tools/export_web.ps1`, `tools/serve_web.ps1 -Https` (README *Play on an iPad or a phone*), on the iPad: **Info → Show FPS (play-test)** on, then **Play** with 4 fighters in the canyon and again with **Glimmer Isles** chosen with the world button; measure the FPS label during a fight (lowest value seen, should stay ≥ 30) and the seconds from pressing **Play** to the arena showing (≤ 5 s). (4) the **B6 trial** of Step 19. All four are rows in **Deferred Items**; none is invented.
**Documents** (S4): README — intro (seven fighters with Beatbolt, two worlds), *Run in the editor* (seven fighters), a new *The look* section (gradient, pedestal, Lilita One, icon buttons, chips, toon outline, Glimmer Isles with ProtonScatter and the bake, the **Show FPS (play-test)** switch), *Play on an iPad* step 5 and *Controls* (the FPS switch), *Resources outside the folder* (art, fonts, drawing photos); the world choice, *How to change Glimmer Isles* (`bake_world.ps1`) and both document links were already there (Steps 11, 13, 15, 18). `docs/architecture.md` — *Layout* (`docs/` and `assets/` rows), *UI foundation* (font, button variations, `Icons`, `IconChip`, the world choice, the FPS switch), *3D models* (toon shaders, `ToonMaterials`; the tools workflow link), *Art and licences*; `MenuBackground`, worlds (`Worlds`, per-world `ArenaLayout`, `GlimmerIsles`, the bake) and drawn fighters were already described by Steps 4–17. `LICENSES.md` — complete: own work (now naming the shaders and the theme), Beatbolt, the Glimmer Isles props, the drawn icons, Lilita One and Kenney Game Icons with source, version, SHA-256, GUT, ProtonScatter, jsQR; every file in `assets/` has its row and licence file.
**Coverage of the statements** (the check task): G2 Steps 4, 8, 9 · G3 2 · G4 4 · G5 2, 4, 7 · G6 2 · G7 7 · G8 8 · G9 3 · G10 5 · G11 6 · G12 6 · G13 9 · G16 every Step (`test_screen_sizes*.gd`) · G17 the order of Steps 4–9 · G18 2, 4 · W1 11–13 · W2 11 · W3 12, 13 · W4 11 (overtime → spec 11, Deferred Items) · W6 10 · W7 5, 11 · A0 14 · A1 15 · A2 16 · A4 16 · A5 16 · A6 15 · A7 14, 16 · A8 16 · A9 17 · B1–B5 18 · S1 every Step on Claude Opus 5.5 · S2 the 468 tests · S3 this Step · S4 Steps 2, 10, 16 and this Step · S5 this Step · S6 all new text English (translations → spec 15) — all ✅ Done. **Waiting for the author** (Notes above and Deferred Items): G1 (before and after sets ready, verdict open), G14 and W5 (desktop frame time in Step 13, web build single-threaded and baked in Step 13; iPad check open), G15 (size met here; the 5 s on the iPad open), A3 (built from shapes; Mattia's confirmation open), B6 (Step 19 🔜 Deferred).
**Done (2026-11-22 · ~10 min · Claude Opus 5.5)** — all Godot checks green, size +0.16 MB vs Step 1 (working tree +4.87 MB with the author's untracked folders), the after set of both games captured and viewed, README, `docs/architecture.md` and `LICENSES.md` brought up to date, every statement covered; the G1 verdict, A3, the iPad play-test and the B6 trial wait for the author. `tools/check_tools.ps1` exit 0, `tools/test.ps1` 468 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 5.86 M tokens · CHF 1.57 (187 credits)

---

## Step 21 — Baseline, art import and licences

### Goal
The reopening's before set and measurements exist, the author's pictures are imported web-safe
and within budget, credited, and the delivery's extra files are kept out of git and the export
(C2, C9, C10, C11, L1, L8; D22, D28).

### Tasks
- [x] Record the start time in Notes below.
- [x] Before set (D28, D2): home, fighter screen, a 4-fighter match 4 s in, in the canyon and in Glimmer Isles, at 1280×720 and 820×1180, into `%LOCALAPPDATA%\hack_star\screens\09b\before\`; all viewed; capture script outside the repository, deleted.
- [x] Performance baseline (D28): a windowed run, vsync off, 4-fighter match per world, Classic view, 10 s — average and worst frame time, draw calls, primitives — written in Notes; temporary script deleted.
- [x] `.gitignore`: `/scenes/blaze_godot.zip`, `/scenes/blaze_godot/`; `export_presets.cfg` `exclude_filter`: the D22 entries; the zips and `scenes/blaze_godot/` untouched (`git status` shows them as ignored, not untracked).
- [x] Imports (D22): the four PNGs not VRAM-compressed, `size_limit` 768 / 256, lossless (lossy WebP if over budget); `blaze_hero.tscn` and `blaze_hero_ui.tscn` point to `res://characters/blaze2/`; the two folders committed (pictures, `.import`, READMEs, scenes, preview scripts with their `.uid`).
- [x] `LICENSES.md`: one row per picture (C9 wording, Mattia's drawing, the author, date 2026-11-22); `tools/export_web.ps1` in the working tree: total and `.pck` size and the size of the two characters' imported files in Notes (C11 ≤ 1.0 MB; total ≤ 45,361,090 bytes).
- [x] Check: 8 PNGs present and viewed; the numbers in Notes; `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` exit 0; `git status --short` shows no zip and no `scenes/blaze_godot`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:03
**Before set** (D28, D2), `%LOCALAPPDATA%\hack_star\screens\09b\before\` (8 PNGs, all viewed; not committed): `godot_home_<size>.png`, `godot_fighter_<size>.png`, `godot_match_canyon_<size>.png`, `godot_match_glimmer_<size>.png` at `1280x720` and `820x1180` (the 820×1180 window is capped by the desktop at 820×1175, as in Steps 16 and 20). A windowed run (`--resolution`) with a temporary `-s` capture script under `%TEMP%` (outside the repository, deleted afterwards), the game's own save (Blaze, 1765 trophies), the entrance skipped, the matches 4 s in (timer 2:00, the fight just started). Seen: home and the fighter screen with Blaze on the pedestal; the canyon in its sand-and-orange look and Glimmer Isles in pale lavender and teal with crystal ridges and fern patches — the reference for L1 ("more saturated and brighter").
**Performance baseline** (D28, L8; a windowed Compatibility run at 1280×720, vsync off, `Engine.max_fps` 0, a 4-fighter match per world, Classic view, sampled for 10 s from 1 s after the scene loads, the same temporary script, deleted): run 1 — canyon 764 frames, average **13.09 ms**, worst 131.43 ms, draw calls avg **792** (max 844), primitives avg 926 k (max 959 k); Glimmer Isles 1012 frames, average **9.89 ms**, worst 65.86 ms, draw calls avg **570** (max 674), primitives avg 810 k (max 894 k). Run 2 — canyon 780 frames, 12.84 ms, worst 93.88 ms, draw calls avg **1042** (max 1139), primitives avg 1.40 M (max 1.48 M); Glimmer Isles 1397 frames, 7.16 ms, worst 36.33 ms, draw calls avg 533 (max 577), primitives avg 752 k (max 787 k). The bots' fighters are random per match, so the canyon's draw calls vary by about a third between runs; the worst frame is the first frames' shader compilation. Step 28 compares against the higher of the two runs per world and repeats each run twice.
**Git and export** (C10, D22): `.gitignore` gets `/scenes/blaze_godot.zip` and `/scenes/blaze_godot/`; `git status --short --ignored` shows both as `!!` (ignored), the files untouched. `export_presets.cfg` `exclude_filter` gets `characters/*/character_preview.gd`, `characters/*/*_hero.tscn`, `characters/*/*_hero_ui.tscn`, `characters/*/README.md`, `scenes/blaze_godot/*`, `scenes/blaze_godot.zip`; the exported `index.pck` holds only the four pictures of `characters/` (searched for the file names: no preview script, scene, README or zip).
**Imports** (D22, C11): every picture not VRAM-compressed (`detect_3d/compress_to` off too, so Godot does not switch it to VRAM when a 3D material uses it); heroes `size_limit` 768 with mipmaps (they are small in the arena), cards 256 without. **Lossless was over budget**: heroes 780,800 + 904,548 bytes, cards 91,500 + 109,874 = 1,886,722 bytes (> 1.0 MB). **Decided:** heroes **lossy WebP** at quality 0.9 (210,596 + 258,378 bytes; alpha is kept exact by WebP), cards stay **lossless** (crisp on the card and skin buttons): **670,348 bytes for both characters** (C11 ≤ 1.0 MB met). The author's PNGs are unchanged. `blaze_hero.tscn` and `blaze_hero_ui.tscn` now point to `res://characters/blaze2/`. The two folders are committed: pictures, `.import`, READMEs, the four scenes and `character_preview.gd` with its `.uid` (not used by the game, not exported).
**Licences** (C9): `LICENSES.md` gets *Pictures of Flarekid and Echo*, a row per picture (the C9 wording, Mattia's drawing, the author, 2026-11-22; the tool and its terms to be confirmed by the author — Deferred Items), and the intro names the pictures.
**Web size** (`tools/export_web.ps1` exit 0, in the working tree with the author's untracked zip and folder present): `build/web` **41,188,483 bytes** (≤ 45,361,090; +827,393 vs Step 1, −4,044,448 vs Step 20's working-tree export, which packed the delivery's VRAM pictures), `index.pck` **1,067,352 bytes** (+668,004 vs Step 20's clean 399,348 — the two characters' imported pictures, 670,348 bytes).
**Done (2026-11-22 · ~8 min · Claude Opus 5.5)** — the reopening's before set (8 PNGs) and performance baseline, the delivery's extras ignored by git and kept out of the export, the four pictures imported web-safe (heroes lossy WebP, cards lossless, 0.67 MB for both) and credited, `blaze2`'s scenes fixed, the two folders committed. `tools/test.ps1` 469 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (41,188,483 bytes); `git status --short` shows no zip and no `scenes/blaze_godot`; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 3.98 M tokens · CHF 1.47 (175 credits)

---

## Step 22 — Flarekid and Echo in the game

### Goal
Flarekid and Echo are fighters, unlocked from the start, shown with their pictures — an outlined
cut-out with a shadow in 3D, their card picture on cards and skin buttons — and see-through in
cover (C1, C2, C6, C7; D20, D21).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Fighters.LIST` rows and `SampleProgress` numbers (D20); `CutoutFighters` registry and `scenes/toon/cutout.gdshader` (Y billboard, alpha scissor, pixel-width outline, `flash`, `fade`, `flip`, `saturation`) and the blob shadow (D21); `FighterModel.setup` builds a cut-out fighter; `FighterPictures` returns the card picture.
- [x] See-through in cover through `fade` (C7); the tests that count fighters updated; `tests/test_cutout_fighters.gd` (D30, the data, card, model, see-through parts).
- [x] Screenshots (D2) at 1280×720 and 820×1180: home with Flarekid and with Echo on the pedestal, the fighter list (both cards), the fighter screen, both in a match in each world and in a bush; the outline compared with Blaze's next to it; Notes say what was looked at and changed.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0; both fighters selectable and playable in Training and a match (a test and the screenshots).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:12
**Data** (D20): `Fighters.LIST` gets **Flarekid** (`flarekid`, Legendary, plays like Blaze) and **Echo** (`echo`, Mythic, plays like Luna), both `"unlocked": true`, `"cutout": true`, one Default skin; old saves get them through `Fighters.start_unlocked()`. **Differs from D20:** `SampleProgress` gives both the numbers of a new fighter — 0 trophies, power level 1 — not Blaze's 1240 trophies and level 7 for Flarekid: the sample totals are the Svelte game's values (1745 trophies, checked by `test_game_state`, `test_hack_effects`, `test_match_trophies`, `test_mvp_flow`), and a new fighter with a Prestige badge it never earned would be wrong; Echo's numbers equal Luna's anyway.
**Look** (D21): `CutoutFighters` (`scenes/cutout/cutout_fighters.gd`) — id → hero and card picture, height, feet point, main colour; `build` puts one `QuadMesh` with a new `scenes/toon/cutout.gdshader` into the model's body (so the existing bob, squash and recoil move it) and turns the rig's shadow into a soft radial blob (`PlaneMesh`, `GradientTexture2D`, 0.03 m over the floor — at the floor's height it flickered into a thin streak from the arena camera). The shader: alpha-blended, unshaded, a dark outline found from the picture's alpha in two rings of 12 samples at `ToonMaterials.OUTLINE_PIXELS` screen pixels (scaled with the screen like `outline.gdshader`) plus its `OUTLINE_GROW` metres, the quad 5 % larger on each side for the outline's room, uniforms `flash`, `fade`, `flip` (around the feet), `saturation`. `FighterModel.setup` asks `CutoutFighters` after `DrawnFighters` (`get_cutout()`); see-through (C7) sets `fade` to `SEE_THROUGH_ALPHA` instead of swapping the material; `FighterPictures.cached_skin` returns the delivered card picture (never rendered), so the card and the skin button show it. **Differs from D21, found on the screenshots:** (1) a Y billboard looked half as tall and squashed in the arena (the camera looks down at 55°), so the quad turns fully to the camera and shrinks around its feet by 40 % of the camera's foreshortening (`foreshorten` 0.4): proportions kept, about Blaze's size on screen; (2) heights **2.7 m** (Flarekid) and **2.5 m** (Echo, crouching), not 1.6 m — the fighters of shapes are 2.3–2.6 m with hair, and at 2.3 m Flarekid looked smaller than Blaze on the pedestal; (3) the health bar and damage numbers over a picture fighter follow the camera (`Fighter._bar_y`, `FighterModel.picture_top`, `CutoutFighters.top_height`: over the picture's top + 0.3 m), because at the usual 2.3 m the bar crossed the picture's face.
**Tests** (D30): new `tests/test_cutout_fighters.gd` (9: data and unlocked, old save, card picture on the card and the skin button, the outlined quad on its feet with the soft shadow, own material per fighter, see-through `fade` and back, chosen and on home, Training (runs, moves, shoots) for both, a match with Echo and the bar over the picture). Tests that count or loop over fighters skip the picture fighters, which have their own file: `test_fighters.gd`, `test_fighter_model.gd` (`_shape_fighters()`), `test_drawn_fighter.gd`, `test_fighter_list.gd` (6 + drawn + picture fighters).
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a temporary `-s` script under `%TEMP%\hs09b\`, deleted; the PNGs stay there, viewed): home with Flarekid and with Echo, the fighter screen of each, the fighter list scrolled to its end (both cards), and a match in each world with Flarekid as the player, Echo on his right, Blaze on his left and another Echo in the nearest bush — and the same with Echo as the player (`final\godot_<screen>_<size>.png`, 18 files). Seen: on the pedestal both stand on their feet with a dark outline as wide as the pedestal's and Blaze's, a soft shadow under them; the cards show the delivered card pictures in the rarity colours (Echo's card has a white fringe in the delivered picture, kept as delivered); in the arena both read as clearly as Blaze next to them, outlined, the bush copy faded. **Changed after looking:** the billboard, the heights, the bar height and the shadow's lift above.
**Open (not in this Step):** the author added `characters/magmax/` (untracked, 17:24) during this Step; it is not used, not committed, and its pictures would be packed by the web export if they stay in the folder (Step 21's numbers were measured before it).
**Done (2026-11-22 · ~25 min · Claude Opus 5.5)** — Flarekid and Echo are unlocked fighters shown as the author's pictures: an outlined, camera-facing cut-out with a soft shadow on home, the fighter screen and in play, their card pictures on the cards and skin buttons, see-through in cover; both selectable and playable in Training and a match. `tools/test.ps1` 478 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 18.47 M tokens · CHF 4.98 (594 credits)

---

## Step 23 — Pedestal reveal and idle

### Goal
Every fighter pops in with particles and a rarity halo on home and the fighter screen, and the
cut-out fighters breathe, bob and sway when standing (C3, C4; D23).

### Tasks
- [x] Record the start time in Notes below.
- [x] Reveal in `FighterStage` (scale tween, `CPUParticles3D` burst, rarity halo) when the stage has a pedestal; none on the off-screen pictures.
- [x] Cut-out idle in `FighterModel.animate` (breathing, bob, sway).
- [x] `tests/test_fighter_reveal.gd` (D30); existing home and fighter-screen tests still green.
- [x] Screenshots (D2): a sequence of 4 frames (0, 0.15, 0.3, 0.6 s) of the reveal on home and on the fighter screen for Flarekid (Legendary), Echo (Mythic) and Rocko (Rare), and two idle frames of each new fighter 0.5 s apart; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:41
**Reveal** (C3, D23): `FighterStage` builds, when it has a pedestal, a `Reveal` node with a soft radial **halo** (a camera-facing quad behind the fighter, 3.6 × 4 m) and a one-shot `CPUParticles3D` **burst** of 24 sparks; `show_fighter` plays `reveal()` in the fighter's rarity colour (`rarity_color()`, `Rarity`): the rig grows 0.3 → 1.0 in 0.45 s with `TRANS_BACK` (a ~7 % overshoot), the halo flares to 1.2× in 0.15 s and settles to its size at alpha 0.55 in 0.45 s, where it stays behind the fighter. It scales the model's **rig**, not the model, so home's entrance (which tweens the model's scale and position) and the knock-out keep their own transforms. The off-screen pictures (`pedestal = false`) build no halo and no sparks. Home's first entrance hides the reveal while the fighter drops (`hide_reveal()`) and plays it without the pop at the landing (`reveal(false)`, the drop is the pop); skipping ends it settled (`finish_reveal()`). The result screen's stage has a pedestal, so the fighter pops in there too (D23: every pedestal stage). Showing the same fighter and skin again does nothing — home refreshes on every progress change (a hack from another tab) and must not replay it.
**Idle** (C4, D23): for a picture fighter that is not running, `FighterModel.animate` sets the body's scale y `1 + 0.03·sin`, x `1 − 0.02·sin` (breathing, at the shapes' `BREATH_SPEED`), a bob of 0.04 m **upwards only** (so the feet never sink into the pedestal) at its own speed, and a sway of ±4° around the view axis through a new `tilt` uniform of `cutout.gdshader` (the quad turns to the camera in the shader, so a node rotation would not show), each wave at its own speed so the loop never looks mechanical. Fighters of shapes keep their idle.
**Tests** (D30): new `tests/test_fighter_reveal.gd` (8): the pop within 0.5 s with a 3–15 % overshoot; home reveals Flarekid, Echo and Rocko in gold, red and green (halo and sparks) and settles; the fighter screen on opening and on another skin; no reveal on the off-screen pictures; the entrance without a second pop, no halo or sparks while falling, settled after it; no replay for the same fighter, a replay for another; the picture fighters breathe (area kept), bob (never under 0), sway (±4°); shapes keep their idle. The existing home and fighter-screen tests pass unchanged.
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a temporary `-s` script under `%TEMP%\hs09b\`, deleted; the PNGs stay in `%TEMP%\hs09b\s23\`, viewed as contact sheets): the reveal at 0, 0.15, 0.3 and 0.6 s on home and the fighter screen for Flarekid, Echo and Rocko (`home_<id>_<ms>_<size>.png`, `screen_…`), two idle frames 0.5 s apart of each new fighter (`idle_<id>_a|b_…`), and the first home's entrance with Echo at 0.5 s, 1.0 s and the end (`entrance_echo_…`). Seen: the fighter small with the halo flaring and sparks rising at 0 s, growing past its size at 0.3 s, standing with a soft halo of its rarity colour (gold, red, green) and the last sparks falling at 0.6 s; the idle frames differ by a small lean and lift. **Changed after looking:** (1) on the first frames of the fighter screen the pop was already over — the screen's first frame (the skin pictures and the shaders) takes long and a tween jumps over it — so the reveal runs on its own clock that moves at most 1/30 s per frame (`MAX_REVEAL_STEP`): a slow first frame slows the pop instead of skipping it; (2) the halo did not grow or shrink — a billboard material drops the node's scale — `billboard_keep_scale` on; (3) during the entrance the halo and the sparks of the first `show_fighter` showed around the falling fighter — `hide_reveal()` hides the sparks too (stopped particles keep their last frame) and the same fighter is not shown twice; (4) sparks 0.09 m instead of 0.07 m (hard to see at 820 px).
**Runner decision D31** (recorded here): the author's newer untracked files (`characters/magmax/`, `characters/echo_new/` with `gameplay/frames/`, `characters/echo_godot_gameplay.zip`) are not part of this reopening: not committed, modified or moved; `.gitignore` gets `/characters/*.zip`; `export_presets.cfg` `exclude_filter` gets `characters/magmax/*`, `characters/echo_new/*`, `characters/*.zip`; a Deferred Items row. `tools/export_web.ps1` exit 0 in the working tree with those files present: `build/web` **41,203,139 bytes** (≤ 45,361,090), `index.pck` **1,082,008 bytes** (+14,656 vs Step 21: this Step's code); the `.pck` holds no `magmax`, `echo_new`, `echo_down` or zip name (searched).
**Done (2026-11-22 · ~18 min · Claude Opus 5.5)** — every fighter on a pedestal (home, the fighter screen, the result) pops in with an overshoot, a burst of sparks and a halo in its rarity colour that settles behind it; home's entrance plays it at the landing; the picture fighters breathe, bob and sway; the author's newer files kept out of git and the export (D31). `tools/test.ps1` 486 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (41,203,139 bytes); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 9.62 M tokens · CHF 3.14 (374 credits)

---

## Step 24 — Paper cut-out animation in play

### Goal
In Training and a match the cut-out fighters hop, lean, flip with the direction, recoil with a
muzzle flash, flash white when hit and fall flat at a knock-out; the missing art is written down
(C5, C8; D24, D29).

### Tasks
- [x] Record the start time in Notes below.
- [x] Run hop, squash and lean; `facing_left` from `Fighter` → shader `flip`; `muzzle_flash()` on a shot; `flash()` on a hit; the knock-out tip-and-fade for cut-out fighters (D24); shape fighters unchanged.
- [x] Tests in `tests/test_cutout_fighters.gd` for flip, flash and knock-out (D30).
- [x] `docs/drawing_to_fighter.md` section *Picture fighters (Flarekid, Echo)* (D29); README link.
- [x] Screenshots (D2) in a match at 1280×720: running left and right (flip), mid-hop, a shot (flash), a hit (white), the knock-out at 0.25 s; both fighters; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 17:59
**Motion** (C5, D24): a new `CutoutMotion` (`scenes/cutout/cutout_motion.gd`, static) holds the picture fighters' poses and effects — `FighterModel` would have passed gdlint's 1000-line limit, so Step 23's idle moved there too (`CutoutMotion.pose(time, running, facing_left)`: lift, scale, tilt). Running: a hop `|sin|·0.18 m` at the shapes' bounce speed, squashed to x 1.08, y 0.9 on landing (eased out within the first third of each hop) and a lean of 8° towards where the picture looks (the shader's `tilt`; a node rotation would not show on a camera-facing quad). **Facing:** `FighterModel.facing_left` (a setter that sets the shader's `flip`); `Fighter.face(direction)` sets it from the input's x when |x| ≥ 0.1, so going straight up or down keeps the last facing; each picture says which way it was drawn (`CutoutFighters` `faces_left`: Flarekid right, Echo left) and is mirrored only when looking the other way. **Differs from D24:** `Arena.fire_from` also turns the picture to the shot's side (`face(direction)`), as it already turns the fighter's yaw — a picture shooting behind its back looked wrong. **Shot:** the existing recoil plus `FighterModel.muzzle_flash()` — a yellow four-pointed star with a soft glow (a 64 px texture drawn once in code) for 0.08 s, placed every frame where the picture's muzzle shows on screen (`CutoutFighters` `muzzle`: Flarekid's fireball, Echo's blaster tip; mirrored with the picture, shrunk with its foreshortening). **Hit:** `Fighter.hit` calls `model.flash()` — the shader's `flash` at 1 for 0.12 s. **Knock-out:** `Fighter` asks `model.knock_out_pose(progress)`; a picture fighter tips over around its feet (the shader's new `tip`, to 80°) and fades (`fade` to 0) in `KNOCK_OUT_SECONDS`, no spin and no shrink, then is hidden as before. **Differs from D24:** it tips **towards** the camera around the screen's horizontal axis, not away from it — away, the top goes along the view into the floor and the floor cuts it; on screen both look the same (the picture folds down onto its feet). Fighters of shapes keep everything (`flash()` and `muzzle_flash()` do nothing for them; the arena's muzzle flash stays for all).
**Tests** (D30): `tests/test_cutout_fighters.gd` +5 (14): looks where it runs and keeps it going up or almost straight down, mirrored per drawn side, kept after a rebuild; running hops from 0 to 0.18 m, squashes on landing, stretches back in the air and leans to its side; a hit flashes white and back after 0.12 s (shapes unchanged); a shot shows the star on the right of the picture aiming right and on the left aiming left, gone after 0.08 s (shapes: none); a knock-out tips and fades halfway, no spin or shrink, flat, gone and hidden at the end. `test_fighter_reveal.gd` reads the idle numbers from `CutoutMotion`.
**Document** (C8, D29): `docs/drawing_to_fighter.md` § *Picture fighters (Flarekid, Echo)* — what the game does with one picture, what a single picture cannot do (no side or back view, no drawn run, shot or hit, one pose), what the author can make with the same tool (side and back views, a run cycle of 4–8 frames, a shot and a hit pose: same height and feet point, transparent PNG, `characters/<folder>/<name>_<pose>.png`) or a GLB through the B1 workflow, what the game then does, how to add and remove a picture fighter; it names the author's `characters/echo_new/gameplay/frames/` (D31) as such a set for a later spec. The README's *How to turn a drawing into a fighter* links the section.
**Screenshots** (D2; a windowed match at 1280×720 with a temporary `-s` script under `%TEMP%\hs09b\`, deleted; PNGs in `%TEMP%\hs09b\s24\`, viewed full and cropped): for Flarekid and for Echo as the player — running left, mid-hop, running right, running up after right, a shot right and left, a hit, the knock-out at 0.25 s and its end (`<id>_<moment>.png`). Seen: each picture mirrored to the side it runs or shoots, its feet staying in place, keeping its facing going up; the lean and the hop; the star at the fireball and at the blaster's tip; the whole picture white on the hit; at 0.25 s the picture folded halfway down and faded inside the arena's knock-out burst. **Changed after looking:** (1) Echo mirrored lost its blaster's tip — the shader mirrored the picture around its feet (Echo's feet are at 0.56, off the middle), so a strip went outside the quad: it now mirrors around the middle and moves the quad back under the feet (`width_m`); (2) the muzzle star did not show at all — the picture, transparent too, was drawn over it: the star is drawn after it (`render_priority` 1, no depth test) and alpha-blended instead of additive (white added to the light sand did not show); (3) the star larger (1.5 m) with thicker rays and a wider glow.
**Open (not in this Step):** two more untracked folders of the author appeared during this Step, `characters/blaze_new/` and `characters/magmax_new/` (32 PNGs, 10.6 MB); D31 does not name them: they are not committed or touched, but the web export would pack them (not measured here; Step 29's export) — for the runner to decide.
**Done (2026-11-22 · ~19 min · Claude Opus 5.5)** — in Training and a match Flarekid and Echo hop with a squash and a lean, look left or right with the movement and the shot (keeping it going up or down), show a muzzle star on a shot, flash white on a hit and tip over and fade at a knock-out; fighters of shapes unchanged; the picture fighters' limits and what to deliver are documented. `tools/test.ps1` 491 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 13.91 M tokens · CHF 3.63 (433 credits)

---

## Step 25 — Camera views

### Goal
Four camera views switch with `V` and `1`–`4` in Training and a match, the name shows briefly,
the controls and framing stay right, and the choice is kept while the game is open (V1–V7; D25).

### Tasks
- [x] Record the start time in Notes below.
- [x] Input actions `view_next`, `view_1`–`view_4`, `light_next`, `saturation_boost` in `project.godot` (D25; the last two used in Step 27); `CameraViews`; `Arena` places the camera per view with the blend; `GameState.camera_view`.
- [x] `HudToast` (D25) on switching; the start hint (`ControlsHelp.KEYBOARD_HINT`) and *How to play* name the view keys (V7).
- [x] `tests/test_camera_views.gd` (D30); `tests/test_arena_framing.gd` still green.
- [x] Screenshots (D2): each view in each world at 1280×720 and 820×1180 (16 PNGs) with the toast in one of them; viewed; Notes say what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 18:19
**Views** (V1, V2, V4, V5, D25): `game/camera_views.gd` (`CameraViews`, static data) lists Classic, Close, Behind and Overview in `V`'s order with their numbers; `project.godot` gets `view_next` (V), `view_1`–`view_4` (keys 1–4 and the number pad's 1–4), `light_next` (L) and `saturation_boost` (K; Step 27) — no other action uses these keys (a test). `Arena._unhandled_input` switches (also during the countdown); `Arena.set_view` keeps the view in `GameState.camera_view` (memory only, Classic after `reset()`), names it in the toast and blends the camera to it in 0.3 s (the two transforms interpolated with a smoothstep); `Arena.view_pose(view)`: **Classic** unchanged (fitted distance, look-ahead, near-wall rule, G11); **Close** at 55°, 0.6 × Classic's fitted distance (at least 6 m); **Behind** low behind the fighter looking up the arena; **Overview** at 78°, its distance fitted (on every size change) so that the whole `ArenaLayout.bounds()` at the walls' height fits under the top margin of the Back button and the chips. The yaw never changes, so the keys move the fighter the same way on the screen in every view (V4) and the pictures still face the camera.
**Differs from D25:** (1) **Behind:** "6 m" is the camera's distance behind the fighter, at the height where its line to the look-ahead point (4 m north) is 28° down (5.3 m) — orbiting the look-ahead point at 6 m put the fighter's feet 37° under the view axis, outside the 25° half field of view; (2) **Close** keeps a near-wall limit of its own (the Classic rule for Close's distance): without it, at the south start in portrait the near wall and the ground behind it filled a third of the screen (seen on the first screenshots); (3) **the health bar over a picture fighter:** `CutoutFighters.top_height` now takes the camera's transform and the fighter's feet and solves the perspective (a point straight up also comes nearer to a camera that looks down): Step 22's approximation from the camera's up vector only was right at Classic's distance but put Flarekid's bar far over his head in Close (behind the timer chip) and Behind (seen on the screenshots).
**Toast** (V3, D25): `HudToast` (`scenes/ui/hud_toast.gd`, a `ChipPanel` with a `HudLabel`, top centre 84 px down — under the match's timer chip —, shown 1.5 s, then faded in 0.3 s, ignores the mouse); the arena builds one and `Arena.toast()` hands it to Step 27.
**Texts** (V7): the start hint gets "View: V or 1-4"; *How to play*'s Controls: "V switches the camera view, 1 to 4 choose one (Classic, Close, Behind, Overview)" (the names from `CameraViews`). The README's controls follow in Step 29 (its task).
**Tests** (D30): new `tests/test_camera_views.gd` (11): `V`'s order; keys 1–4 and the number pad, during the countdown; the view keys bound to no other action; the toast (name, backing, top centre, gone after ~1.5 s); Flarekid's feet and bar on the screen in every view, in both worlds, at the five sizes; Overview sees both corners of every border wall at the five sizes; the camera always looks north and down; Close nearer, Behind lower, Overview higher than Classic; Classic back where it was after a round of views (G11); the blend half-way at 0.15 s and arrived after 0.3 s; the view kept for the next match, Classic after a fresh start. `test_controls_help.gd` checks the view keys in both texts; `test_cutout_fighters.gd` uses the camera's transform; `test_arena_framing.gd` green unchanged.
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a 4-fighter match with Flarekid as the player, each view 2 s after its switch, in both worlds, a temporary `-s` script under `%TEMP%\hs09b\s25\`, deleted; PNGs there, all viewed): `<view>_<world>_<size>.png` (16) and `toast_close_<world>_<size>.png` (4, 0.5 s after the switch). Seen: Classic as before; Close nearer with the fighter below the middle; Behind low behind the fighter, the arena and the bots ahead up to the far wall; Overview the whole arena with its four walls inside the screen under the chips; the toast "Close" under the timer chip. **Changed after looking:** the bar's height (3) and Close's near-wall limit (2).
**Runner decision (D31 extended):** the export's `exclude_filter` replaces `characters/magmax/*` and `characters/echo_new/*` by `characters/*_new/*` and `characters/magmax*/*` (`characters/*.zip` and the D22 entries kept). `tools/export_web.ps1` exit 0 in the working tree with the author's four untracked folders present (`blaze_new`, `echo_new`, `magmax`, `magmax_new`, 20.0 MB): `build/web` **41,222,079 bytes** (≤ 45,361,090; +18,940 vs Step 23: this Step's code), `index.pck` **1,100,948 bytes**; the `.pck` holds no `magmax`, `_new` or `.zip` name, only paths of `characters/blaze2/` and `characters/echo/` (searched). The author's folders are not committed, modified or moved.
**Done (2026-11-22 · ~20 min · Claude Opus 5.5)** — `V` and `1`–`4` switch Training and a match between Classic, Close, Behind and Overview with a 0.3 s blend and the view's name in a toast; the camera never turns, so the controls stay the same; the fighter and its bar stay on the screen in every view at the five sizes, Overview shows the four walls, Classic keeps G11; the view is kept while the game is open; the hint and *How to play* name the keys; the export filter keeps all of the author's newer folders out (D31). `tools/test.ps1` 502 tests passed, `tools/lint.ps1` exit 0, `tools/export_web.ps1` exit 0 (41,222,079 bytes); suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.87 M tokens · CHF 2.89 (345 credits)

---

## Step 26 — Brighter worlds and more detail

### Goal
The canyon and Glimmer Isles are brighter and more saturated, with at least three new kinds of
decoration each, some moving, and the same rules (L1, L2, L7; D26).

### Tasks
- [x] Record the start time in Notes below.
- [x] Palettes of `Canyon`, `GlimmerIsles` and their props (D26); the floor stays the least saturated surface.
- [x] New decoration per world (D26), no colliders, instanced where static; re-bake Glimmer Isles only if its scatter source changed (`tools/bake_world.ps1`, D12).
- [x] `tests/test_world_decor.gd` (D30); `tests/test_world_layouts.gd`, `test_glimmer_isles.gd`, `test_canyon_look.gd` still green (tests changed only where colours are checked).
- [x] Screenshots (D2): both worlds in a match at 1280×720 and 820×1180 next to Step 21's before set; viewed; Notes say what is brighter, what was added and what was changed after looking.
- [x] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 18:39
**Palettes** (L1, D26): `Canyon` — warmer orange-red rock (`ROCK` c95a33 → e65a2a, band, top and boulders likewise), apricot sand (`SAND` b89c74 → d6ad7e, `SAND_DARK` cb9f6e), a warmer outside, greener cacti (3fd35c / 1fa848) on a fresher patch ground, brighter crates, bones and pebbles; `GlimmerIsles` — teal and violet ground tiles (`GROUND` 86a3b4 → 74bccb, `GROUND_LAVENDER` 9a95c4 → a294dc), a greener rim, a violet border, plinths and underside; `GlimmerProp` — cyan and magenta crystals (4feaff, ff5cd6) with stronger glow colours, greener ferns, brighter mushroom caps, island grass and rock. The ground stays the least saturated surface of each world (G10: sand about 40 %, the teal tiles about 43 %; rocks, cacti, crystals and caps 60–90 %). **Re-bake:** the scatter source did not change, but the bake stores each part's colours in `baked.tscn` (`tools/bake_world.ps1` says to re-bake after changing the props), so Glimmer Isles was re-baked: only the colours and the node ids changed, every transform is the same (diff checked).
**New decoration** (L2, D26; no collider, nothing in the playing area): **canyon** — (1) **blossoms** on the cactus tops without a flower (a five-petal disc in yellow, orange or pink; one MultiMesh `CactusBlossoms`, from a second seed so every older piece keeps its place), (2) **flags** that wave on the three high border walls (9; a pole and a cloth with the new `scenes/toon/flag.gdshader`, out of step by their place), (3) **birds** circling high over the canyon (5, flapping; `CanyonDecor._process`), (4) a **turquoise stream** outside the east wall among the outside boulders, its light bands flowing (`scenes/toon/flowing_water.gdshader`); all in `scenes/canyon_decor.gd` (`CanyonDecor`, the canyon's child `Decor`) but the blossoms. **Glimmer Isles** — (1) **fireflies** (`CPUParticles3D`, 48, fading in and out over the island), (2) the **crystals' glow pulses** (the baked crystal parts' shared materials, ±60 % of their baked strength), (3) **waterfalls** pouring from every second floating island (8; the flowing-water shader downwards, fading at the foot), (4) the **islands turn** slowly around their own axes and bob (their baked MultiMesh transforms moved each frame; the waterfalls bob with them); all in `scenes/worlds/glimmer_isles/glimmer_decor.gd` (`GlimmerDecor`, the world's child `Decor`). Static props are instanced (the blossoms), the moving ones are shaders (flags, water) or code (birds, islands, pulse). **Differs from D26:** the stream runs outside the **east** wall, not beyond the far one — there it showed only in the Behind view (seen on the first screenshots); beside the east wall it shows in Classic at the right edge and in Overview.
**Tests** (D30): new `tests/test_world_decor.gd` (5): the canyon's four new kinds are there and the world has no collider of its own (only the floor and one body per layout wall, at the layout's places); flags on the high border walls, the stream outside, the birds high; the birds fly on and flap, the flags and the stream use their shaders; Glimmer Isles' four kinds (at most 64 fireflies, D26) and no collider; the waterfalls outside, the crystals pulse, the islands turn and bob around their own axes. `test_world_layouts.gd`, `test_glimmer_isles.gd`, `test_canyon_look.gd` green unchanged (no test checks a colour value).
**Screenshots** (D2; windowed runs at 1280×720 and 820×1180 — capped at 820×1175 —, a 4-fighter match 4 s in with the game's own save (Blaze), as Step 21's before set, plus Behind and Overview at 1280×720 to see the decoration around the arena; a temporary `-s` script under `%TEMP%\hs09b\s26\`, deleted; PNGs there: `godot_match_<world>_<size>.png`, `behind_<world>_1280x720.png`, `overview_<world>_1280x720.png`, viewed next to `%LOCALAPPDATA%\hack_star\screens\09b\before\`). Seen: the canyon clearly warmer and brighter — orange-red rock, light apricot sand, vivid green cacti with yellow, orange and pink blossoms; flags on the walls, birds over the outside, the stream with its light bands beside the east wall; Glimmer Isles clearly more vivid — cyan and lilac tiles instead of grey-blue and lavender, deeper violet walls, brighter crystals and ferns, fireflies over the island, waterfalls under the islands; the fighters stand out on both floors. **Changed after looking:** the stream moved to the east wall (above); the Glimmer rim toned down (3fbf98 → 4aa892: from Overview, a large loud green slab around the arena).
**Done (2026-11-22 · ~13 min · Claude Opus 5.5)** — both worlds brighter and more saturated (the floors still the least saturated surfaces), four new kinds of decoration each — the canyon's blossoms, waving flags, circling birds and a flowing stream; Glimmer Isles' fireflies, pulsing crystals, waterfalls and turning islands —, no collider and the layouts unchanged; Glimmer Isles re-baked for the props' colours only. `tools/test.ps1` 507 tests passed, `tools/lint.ps1` exit 0; suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 8.86 M tokens · CHF 2.67 (318 credits)

---

## Step 27 — Lighting presets and saturation boost

### Goal
`L` cycles the lighting presets and `K` the saturation boost in both worlds, the name shows
briefly, and the default is the best-looking preset chosen from screenshots (L3–L7; D27).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `LightPresets` and `WorldLighting` (D27); `Arena` applies `GameState.light_preset` and `saturation_boost` at start and on `L` / `K`; `HudToast` shows the name.
- [ ] Glow: try it in a windowed Compatibility run and in the web export (`tools/export_web.ps1`, `tools/serve_web.ps1`, a desktop browser); keep it only where both show it (D27), Notes say the result.
- [ ] `tests/test_light_presets.gd` (D30); *How to play*, the start hint and the README controls name `L` and `K`.
- [ ] Screenshots (D2): every preset × both worlds × 1280×720 and 820×1180, and the boost on for two of them; viewed; the default chosen and its reason written into D27 and the Notes; L7 checked on them (fighters, shots, health bars, cover, HUD).
- [ ] Check: `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 28 — Performance comparison

### Goal
The new looks are measured against Step 21's baseline and stay within L8 (L8, C11; D28).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] The D28 performance run for every preset × world, with and without the boost, in Classic and Overview, with Flarekid and Echo among the 4 fighters; a table in Notes (frame time average and worst, draw calls, primitives) next to the baseline.
- [ ] Anything over L8 trimmed (particle counts, glow, decoration counts) and measured again; temporary scripts deleted.
- [ ] Check: every row within L8 in Notes; `tools/test.ps1`, `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 29 — Final check of the reopening, README and architecture

### Goal
Everything that worked before still works, the size budget is met and reported, the after set is
recorded, and the documents describe the new fighters, views and lighting (C1–C11, V1–V7,
L1–L8, S2–S6).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (all exit 0); every `.ps1` changed parses with `[System.Management.Automation.Language.Parser]::ParseFile`; nothing outside `hack_star_godot/` changed (S5); `git status` shows no zip and no `scenes/blaze_godot`.
- [ ] Web export size report in Notes: total and `.pck` vs Step 1, Step 20 and Step 21; the two characters' share (C11 ≤ 1.0 MB); total ≤ 45,361,090 bytes (G15).
- [ ] After set (D2) into `%LOCALAPPDATA%\hack_star\screens\09b\after\` with Step 21's file names; viewed next to the before set; Notes say what changed (L1).
- [ ] `README.md`: the two new fighters, the reveal, the controls (`V`, `1`–`4`, `L`, `K`), the presets and the default, the link to *Picture fighters*; `docs/architecture.md`: `CutoutFighters` and the cut-out shader (*3D models*), the reveal (*UI foundation*), `CameraViews`, `HudToast`, `LightPresets`, `WorldLighting`, the new tests; `LICENSES.md` complete (S4).
- [ ] Check: every statement C1–C11, V1–V7, L1–L8 has a Step that is ✅ Done (the iPad check of L8 in Deferred Items).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| An own visual identity instead of matching the Svelte look | G18: match now, identity later | Root [Originality review](../../../../.specs/features/2026_11_14_4_originality_review_spec.md) (#22) |
| Saving the world choice, more worlds, sizes, world coins and prices | W2: only a minimal choice here | [Worlds and World Coins](../2026_11_22_18_worlds_and_world_coins_spec.md) (spec 18) |
| More skins for a drawn fighter | A2: one default skin | [Skins Shop](../2026_11_22_10_skins_shop_spec.md) (spec 10) |
| The new texts in every game language | S6: English until then | [Accounts, Fighters and Languages](../2026_11_22_15_accounts_fighters_and_languages_spec.md) (spec 15) |
| Overtime and closing walls in Glimmer Isles | W4: they come with spec 11 for every world | [Overtime and Match Options](../2026_11_22_11_overtime_and_match_options_spec.md) (spec 11) |
| Mattia's confirmation "this is my drawing" for Beatbolt (A3), from the Step 16 screenshots in `%LOCALAPPDATA%\hack_star\screens\09\step16\` | Needs the author and Mattia; the agent cannot ask them and does not invent the answer | This spec, Step 20 / author |
| The B6 trial with Google Flow + Meshy (free use) and the possible import of its GLB (Step 19; instructions in `docs/drawing_tools.md` § *Trial (B6)*) | Needs the author's own Google Flow and Meshy accounts (and Mattia's preference); the agent has neither | This spec's follow-up by the author / a later spec |
| The side-by-side verdict of the author and Mattia per screen (G1), from the before and after sets in `%LOCALAPPDATA%\hack_star\screens\09\before\` and `…\after\` (Step 20) | Needs the author and Mattia; the agent cannot judge for them and does not invent the verdict | This spec, Step 20 / author |
| The iPad (and phone) play-test: ≥ 30 fps with 4 fighters in the canyon and in Glimmer Isles with **Show FPS (play-test)**, and playable within 5 s after **Play** (G14, G15, W5) | Needs the author's iPad; the agent has no device | This spec, Step 20 / author |
| Lint and format-check `tools/*.gd` (first file: `tools/bake_world.gd`) and smoke-test `tools/check_tools.ps1` and `tools/bake_world.ps1` | Code review 2026-11-22 finding 8: outside this spec's scope (the Godot tooling) | A later Godot tooling spec |
| Allow letter-prefixed statement ids (G1, W1, A0, B1) in the kit's `change_record.schema.json` | Code review 2026-11-22 finding 9: the kit lives in the root `.specs/kit/`, which a Godot spec does not change | A kit spec in the root `.specs/` |
| The price tag on locked fighter cards and on the fighter screen (G5; D19) — and the skin prices | Code review 2026-11-22 finding 10: the game has no prices yet; the unlock price by rarity is that spec's S2, skin prices come with the shop | [Unlock and Upgrade](../2026_11_22_09_unlock_and_upgrade_spec.md) (S2) · [Skins Shop](../2026_11_22_10_skins_shop_spec.md) (spec 10) |
| A touch button to switch the camera view (and the lighting presets) | V6: touch players keep the default view in this spec (reopened 2026-11-22, Q11) | A later Godot UI spec |
| The iPad check of the reopened parts: ≥ 30 fps with Flarekid and Echo, every view and the default preset (L8, G14) | Needs the author's iPad; Step 28 measures on the desktop only | This spec, Step 29 / author |
| Side and back views, run, shot and hit frames, or a 3D model for Flarekid and Echo | C8: only one front picture each exists; `docs/drawing_to_fighter.md` *Picture fighters* says what to deliver | The author, then a later spec |
| Which AI image tool made the Flarekid and Echo pictures, for `LICENSES.md` | C9: "tool to be confirmed by the author" | The author |
| The author's newer art (echo_new directional gameplay frames, blaze_new, magmax, magmax_new) — a follow-up can use them for Echo's and Flarekid's in-play animation and a new fighter | D31: dropped into `characters/` during the run (`characters/magmax/`, `characters/echo_new/` with `gameplay/frames/`, `characters/blaze_new/`, `characters/magmax_new/`, `characters/echo_godot_gameplay.zip`); not part of this reopening's request, kept untracked and out of the web export (`characters/*_new/*`, `characters/magmax*/*`, `characters/*.zip`) | A later Godot spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-22 | AI assistant (Claude Opus 5.5) | semantic diff | — | [2026-11-22_better-graphics.html](../../review/2026-11-22_better-graphics.html) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | diff `91cc8be..060ff79` | Approve | 0 Blocking · 2 Should-fix · 8 Nit |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | plan | re-planned | re-planned: spec reopened for the author's request — two new characters, views, lighting (C1–C11, V1–V7, L1–L8; Steps 1–20 kept, Steps 21–29 added, D20–D30) |

### Code review 2026-11-22

Range `91cc8be..060ff79` (requirements, plan, Steps 1–20), layer by layer; page [2026-11-22_better-graphics.html](../../review/2026-11-22_better-graphics.html). Accepted as deferred, not findings: the G1 verdict, Mattia's A3 confirmation, the iPad G14/W5 play-test and the B6 trial (Step 19).

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | hack_star_godot/docs/architecture.md:363-400 — the Tests paragraph does not name the five look tests this spec added: test_theme_look.gd (Step 2), test_home_look.gd (Step 4), test_canyon_look.gd (Step 5), test_arena_framing.gd (Step 6) and test_screens_look.gd (Step 9), although those Steps say the architecture was updated and D18 lists them. Add one clause each | architecture | docs | Should-fix | fix now — **handled:** the Tests paragraph of `docs/architecture.md` names the five look tests and what each checks |
| 2 | hack_star_godot/tests/test_arena_framing.gd:58-79 — G11 (near wall at most 10 % of the screen height at the start of a match and Training) is measured only in the canyon (before_each resets to it); Glimmer Isles gets the same framing only because GlimmerIsles copies Canyon.CAMERA_SIDE_WALL_HEIGHT and Arena._near_wall_offset (scenes/arena.gd:311) reads the canyon's constant. Run both tests for every world in Worlds.ids() | code | test | Should-fix | fix now — **handled:** both tests of `test_arena_framing.gd` run for every world of `Worlds.ids()` (the arena checked to use it; the Glimmer Isles wall height from `GlimmerIsles`) |
| 3 | hack_star_godot/.specs/features/2026_11_21_09_better_graphics_spec.md:796-797 — Step 16's Done line is followed directly by '---' with no blank line, so Markdown renders the Done line as a heading instead of a paragraph and a rule. Add the blank line | spec | docs | Nit | fix now — **handled:** blank line added |
| 4 | hack_star_godot/.specs/features/README.md:32 — the ordered list still says 'planned' for spec 09 Better Graphics although every Step is done and the review runs; it also shares the number 09 with Unlock and Upgrade (next row). Set the status to the current stage (closed at CLOSE:) and say in the list's intro that two specs carry 09 | spec | docs | Nit | fix now — **handled:** *closed* at `CLOSE:`; the intro says why two specs carry 09 (numbers are not changed, as links and issues use them) |
| 5 | hack_star_godot/tests/test_home_look.gd:59-60 — assert_gt compares a float with an int (1280 - 64, 720 - 64), so every run prints two GUT 'Float/Int comparison' warnings; use 1280.0 - 64.0 and 720.0 - 64.0 | code | test | Nit | fix now — **handled:** float operands; the run prints no warning |
| 6 | Unused after this spec: Hacks.power_text (hack_star_godot/game/hacks.gd:155-157, now called only by test_hacks.gd), the theme variations BackgroundPanel (no screen uses it since Step 9) and IconButton (D7; only test_theme_look.gd uses it), and three Kenney icons that Icons names but no screen shows — gear.png ('settings'), star.png ('star'), singleplayer.png ('fighter') — although D4 says only the used icons are copied. Remove them (and their LICENSES.md names), or say in D4/D7 why they stay | code | dead-code | Nit | fix now — **handled:** all removed (grep: no other use): `Hacks.power_text` (its test now checks `power_amount`), the theme's `BackgroundPanel` and `IconButton` with their style boxes, the icons `gear`, `star`, `singleplayer` with their `.import` files; `LICENSES.md` (11 icons) and `docs/architecture.md` updated |
| 7 | hack_star_godot/game/arena_layout.gd:68-96 and scenes/autoload/game_state.gd:80-81 — the active layout is global static state that stays on the last world after its arena closes; GameState.reset() sets world back to the canyon but not ArenaLayout, so code that reads ArenaLayout without an arena (BotBrain, ControlsHelp, tests) depends on the last scene built, and tests reset it by hand (test_world_choice.gd:25, test_glimmer_isles.gd:29). Call ArenaLayout.use(world) in GameState.reset(), and drop 'Pure data' from the class comment | architecture | architecture | Nit | fix now — **handled:** `GameState.reset()` calls `ArenaLayout.use(world)`; the class comment says the active layout is static state that `reset()` sets back; test `test_game_state_reset_sets_the_active_layout_back_to_the_canyon` (`test_world_layouts.gd`) |
| 8 | Semantic-diff check C7: the changed command tools/check_tools.ps1 and the new tools/bake_world.ps1 / tools/bake_world.gd have no automated test, and tools/lint.ps1 lints only game/, scenes/ and tests/, so bake_world.gd (the first .gd in tools/) is never linted or format-checked. A Deferred Items row: lint tools/*.gd and smoke-test the tools | scan | test | Nit | deferred — **handled:** row in Deferred Items |
| 9 | The kit's change_record.schema.json accepts only S<n> statement ids, but this spec's statements are G1–G18, W1–W7, A0–A9 and B1–B6; the record lists S2–S6 and names the others in each block's note. A Deferred Items row for the kit (root .specs/kit, not changed by a Godot spec): allow letter-prefixed ids | spec | docs | Nit | deferred — **handled:** row in Deferred Items |
| 10 | Part 1 G5 asks for lock and price with icons, and the plan's Step 7 task says 'lock icon and price for locked fighters'; the game has no fighter prices yet, so Step 7 shows a 'Locked' chip without a price and says so only in its Notes. Record the deviation as a decision (price on locked cards comes with the shop spec) so Part 1, the plan and the result agree | spec | spec | Nit | plan decision — **handled:** D19 (no price before prices exist) and a Deferred Items row for Unlock and Upgrade (S2) and Skins Shop |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (G1–G18, W1–W7, A0–A9, B1–B6, S1–S6 testable, open questions answered; reopened 2026-11-22: C1–C11, V1–V7, L1–L8 added, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks (re-planned 2026-11-22: Steps 21–29)
- [ ] Implementation · every Step's tasks checked; `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass; README / `docs/architecture.md` updated where affected; the author's parts (A0 photo, B6 trial, G1 verdict, G14/W5 play-test) recorded — *not ticked:* the checks pass and the documents are updated, the A0 photo is recorded, but Step 19 (B6 trial) is 🔜 Deferred and the G1 verdict, A3 and the G14/W5 play-test wait for the author (Deferred Items)
- [x] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/` _(reopened in place 2026-11-22 for Steps 21–29; closed again after Step 29)_
- [ ] Pull request · opened with the spec summary ([#36](https://github.com/martinnordio/hack_star/pull/36), from `feature/better-graphics` to `main`); reviewed; merged; branch deleted — *not ticked:* opened, not merged (the author reviews and merges)
