# Better Graphics Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-22
> **Last updated:** 2026-11-22
> **Branch:** `feature/better-graphics`
> **Issue:** #35

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
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
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 18.96 M (132 k in · 18.75 M cached · 74 k out) | CHF 4.94 (589 credits) | Step 16 done (`usage.ps1 -AgentName s09g-steps15-17` from 15:19:28 to 15:44:13) |---

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
- [Basic UI](done/2026_11_21_04_basic_ui_spec.md) (spec 04) — the screens (home, fighter list,
  fighter screen, info), the shared theme `scenes/ui/hack_star_theme.tres`, `FighterStage`,
  `FighterCard`, `SkinButton`, `PrestigeBadge`, the minimum sizes (44 px buttons, 14 px text,
  D13) and the five screen sizes of `tests/test_screen_sizes.gd`.
- [Graphics Demo](done/2026_11_21_06_graphics_demo_spec.md) (spec 06) — the canyon arena, the
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
  reuses: [Graphics review](../../../.specs/features/2026_11_14_2_graphics_review_spec.md)
  (#20: candidate packs, licence first — CC0, or CC BY with credit — and a phone-size check per
  model), [Art tools research](../../../.specs/features/2026_11_14_3_art_tools_research_spec.md)
  (#21: the questions to ask each tool — cost, ownership, training on uploads, age, formats,
  weight; free use only; Martin owns the accounts; only drawings uploaded),
  [Originality review](../../../.specs/features/2026_11_14_4_originality_review_spec.md) (#22:
  our own identity, no copied look). Part B answers #21's question for the Godot game in a
  narrower form; it does not replace #21.
- The canyon is the only world: `game/arena_layout.gd` (`ArenaLayout`, constants for the walls,
  cactus patches, decoration and start points, read by `Canyon`, `Arena`, `MatchArena`,
  `BotBrain` and `ControlsHelp`) and `scenes/canyon.gd`. More worlds, world coins, prices and
  three sizes are [Worlds and World Coins](2026_11_22_18_worlds_and_world_coins_spec.md)
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

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea ("very good graphics", "woww effect for kids") |
| [architecture.md](../../docs/architecture.md) | How the Godot game is organised (UI foundation, 3D models, art and licences) |
| [README](../../README.md) | How to open, run, test and export the Godot game |
| [LICENSES.md](../../LICENSES.md) | Every asset of the Godot game and its licence |

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
  [Worlds and World Coins](2026_11_22_18_worlds_and_world_coins_spec.md) (spec 18).
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

### Open questions

None. The author answered Q1–Q7 on 2026-11-22 (Q1 3D built from shapes, cut-out as the
fallback → A3; Q2 a new fighter, unlocked from the start, one default skin → A2; Q3 home and the
match first, then the fighter list and screen, then the result, info and hack screens, all in
this spec → G17; Q4–Q7 the suggestions → B6, G1, G18, G3 and G5) and added part W and A0.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

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
| **17** | Adding and removing drawn fighters | reasoning (Claude Opus 5.5) — S1; the add/remove path and the save fallback, with tests (D14) | ⬜ Not started | [→ Step 17](#step-17--adding-and-removing-drawn-fighters) |
| **18** | Tool recommendation document | reasoning (Claude Opus 5.5) — S1; research with sources and dates, licence first (D15) | ⬜ Not started | [→ Step 18](#step-18--tool-recommendation-document) |
| **19** | Trial of the recommended workflow | reasoning (Claude Opus 5.5) — S1; the author's trial with his accounts, recorded and judged (D17) | ⬜ Not started | [→ Step 19](#step-19--trial-of-the-recommended-workflow) |
| **20** | Final check, README and architecture | reasoning (Claude Opus 5.5) — S1; every Godot check, the size budget, the side-by-side verdict and the documents | ⬜ Not started | [→ Step 20](#step-20--final-check-readme-and-architecture) |

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
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../AGENTS.md)). Each
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
- [ ] Record the start time in Notes below.
- [ ] `docs/drawing_to_fighter.md`: *Add another drawing* and *Remove a drawn fighter* sections (the three places of D14).
- [ ] Tests in `test_drawn_fighter.gd`: a save that selected an unknown (removed) drawn fighter loads with the default fighter and keeps the rest; adding a drawn fighter changes no other fighter's data.
- [ ] Check: a dry run of the removal on a scratch copy (not committed) leaves the tests green; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 18 — Tool recommendation document

### Goal
`docs/drawing_tools.md` recommends one main workflow with at most three tools and one fallback,
with the facts, terms and limits of each tool (B1, B2, B3, B4, B5, D15).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Re-check the sources of Part 1's research table (Google Flow, Meshy, Tripo/Hunyuan3D/TRELLIS, Godot import) and date every fact.
- [ ] Write the document: main workflow (Google Flow → Meshy → Claude in Godot) step by step, fallback (Claude alone, or Google Flow → Claude), facts per tool (what it does, cannot do, cost, account and minimum age, output format and Godot import, training on uploads, terms for an MIT game), Google Flow's place (B3), licence first and credits for `LICENSES.md` (B4), the fit limits (MB and triangles for 30 fps on an iPad, outlined look via D5, the A4 animations) (B5); "not legal advice"; link from the README.
- [ ] Check: every fact has a source and date; no tool with unclear terms recommended; `test.ps1`, `lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 19 — Trial of the recommended workflow

### Goal
The author runs the B1 workflow with one drawing on his own accounts; the result, time and cost are
recorded, and it joins the game only if its licence allows it and Mattia prefers it (B6, D17).
**Needs the author.**

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Send the author the trial steps from `docs/drawing_tools.md` (free use only; Meshy free plan = CC BY 4.0, credit Meshy); wait — *waiting for the author* in Notes.
- [ ] Record in the document: what came out, time, credits used, problems.
- [ ] If Mattia prefers it to the Step 16 version and the licence allows: import the GLB (size and triangle limits of B5, D5 outline, A4 animations), credit in `LICENSES.md`; else keep the files out of the repository and say why.
- [ ] Check: the trial section of the document is filled; if imported, `test.ps1`, `lint.ps1`, `export_web.ps1` exit 0 and the export size noted (D16).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 20 — Final check, README and architecture

### Goal
Everything that worked before still works, the size budget is met, the after-screenshots and the
author's verdict are recorded, and the documents describe the new look, the world and the
workflows (G1, G14, G15, G16, W5, S2, S3, S4, S5, S6).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (all exit 0); every `.ps1` changed parses with `[System.Management.Automation.Language.Parser]::ParseFile`; `git status` shows nothing outside `hack_star_godot/` (S5).
- [ ] Size: compare `build/web` with Step 1; ≤ +5 MB (G15, D16); write both numbers in Notes.
- [ ] After screenshots (D2) into `%LOCALAPPDATA%\hack_star\screens\09\after\`; the side-by-side session with the author and Mattia (G1, D17): their verdict per screen recorded in this Step's Notes; the iPad play-test (G14, W5: ≥ 30 fps with 4 fighters in the canyon and in Glimmer Isles, FPS switch of D8; playable within 5 s after **Play**) recorded — *waiting for the author* until then.
- [ ] `README.md`: the new look, the world choice, Glimmer Isles and its re-bake (`tools/bake_world.ps1`), the FPS switch, links to both documents; `docs/architecture.md`: *UI foundation* (font, icons, theme, `MenuBackground`, `IconChip`), *3D models* (toon shaders, `ToonMaterials`, drawn fighters), worlds (`Worlds`, per-world `ArenaLayout`, `GlimmerIsles`, ProtonScatter bake), *Art and licences*; `LICENSES.md` complete (S4).
- [ ] Check: every statement G1–G18, W1–W7, A0–A9, B1–B6, S1–S6 has a Step that is ✅ Done or a Note saying what waits for the author.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| An own visual identity instead of matching the Svelte look | G18: match now, identity later | Root [Originality review](../../../.specs/features/2026_11_14_4_originality_review_spec.md) (#22) |
| Saving the world choice, more worlds, sizes, world coins and prices | W2: only a minimal choice here | [Worlds and World Coins](2026_11_22_18_worlds_and_world_coins_spec.md) (spec 18) |
| More skins for a drawn fighter | A2: one default skin | [Skins Shop](2026_11_22_10_skins_shop_spec.md) (spec 10) |
| The new texts in every game language | S6: English until then | [Accounts, Fighters and Languages](2026_11_22_15_accounts_fighters_and_languages_spec.md) (spec 15) |
| Overtime and closing walls in Glimmer Isles | W4: they come with spec 11 for every world | [Overtime and Match Options](2026_11_22_11_overtime_and_match_options_spec.md) (spec 11) |
| Mattia's confirmation "this is my drawing" for Beatbolt (A3), from the Step 16 screenshots in `%LOCALAPPDATA%\hack_star\screens\09\step16\` | Needs the author and Mattia; the agent cannot ask them and does not invent the answer | This spec, Step 20 / author |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (G1–G18, W1–W7, A0–A9, B1–B6, S1–S6 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` pass; README / `docs/architecture.md` updated where affected; the author's parts (A0 photo, B6 trial, G1 verdict, G14/W5 play-test) recorded
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
