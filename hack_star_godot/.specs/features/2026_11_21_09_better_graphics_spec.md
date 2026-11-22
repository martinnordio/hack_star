# Better Graphics Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-22
> **Last updated:** 2026-11-22
> **Branch:** `feature/better-graphics`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 3.90 M (143 k in · 3.73 M cached · 27 k out) | CHF 1.67 (200 credits) | Part 1 written (screenshots of both games compared; web research for part B) |

---

# Part 1 · Requirements

## Context

The author and Mattia find that the Godot game's screens and characters look much worse than
the Python + Svelte game, and Mattia is unhappy with the new game. This spec makes the UI and
the characters clearly better (judged side by side with the Svelte game on the same screens),
lets a child's drawing become a character of the game with what Claude (via Copilot) can do
on its own (part A), and recommends a better drawing-to-character workflow with one or a few
tools, Google Flow among them (part B). Every stage and Step of this spec runs on Claude
Opus 5.5.

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
  Svelte one, and their verdict per screen is written in this spec.
- **G2 — Background:** No Godot screen has a plain flat background: menus have a coloured
  gradient or pattern with depth, and the fighter on home, the fighter screen and the result
  screen stands on a visible pedestal or stage.
- **G3 — Fonts:** The title, headings, buttons and numbers use a bold display font with a dark
  outline or shadow; body text stays readable; the font has a free licence named in
  `LICENSES.md`.
- **G4 — Logo:** "Hack star" on home is a logo (more than one colour, outline, not plain text)
  and plays in the entrance as today.
- **G5 — Buttons and icons:** Every home action is a button with an icon and its own colour,
  **Play** is the largest and most visible button, and trophies, credits, power, lock and price
  are shown with icons instead of words like "Trophies:"; icons are original or CC0.
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

### A — Drawing → character, done by Claude in this spec

- **A1 — Workflow:** A short document in the repository says how to take the photo (whole
  drawing, flat, daylight, plain paper, nothing else in the picture), where to put it, and the
  exact request to give Claude via Copilot; following it, Claude turns one drawing into a
  character of the game without other tools.
- **A2 — In the game:** The drawn character is a new **fighter** (open question 2) with the name
  the child chooses: shown in the fighter list and the fighter screen, selectable, shown on home,
  and playable in Training and a match like every other fighter.
- **A3 — Recognisable:** The character has the drawing's main shapes and colours (head, body,
  limbs, special parts such as a hat or a weapon) in the game's outlined cartoon style;
  Mattia confirms "this is my drawing".
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
- **B6 — Trial:** Whether a trial of the B1 workflow with one drawing is done in this spec is
  decided by the author (open question 4); if it is done, its result, time and cost are
  recorded in the document, and its files join the game only if their licence allows it.

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

- **Q1 — 3D or flat for drawn characters (part A):** a 3D figure Claude builds from shapes
  (matches the other fighters, animates well, loses the drawing's lines), or a flat "paper
  cut-out" of the photo standing in the arena (keeps the drawing exactly, only bobs and turns)?
  Suggestion: 3D built from shapes, with the cut-out as the fallback for drawings too detailed
  for shapes.
- **Q2 — Fighter or skin:** the drawn character as a new fighter (same rules as all fighters
  today, so no gameplay change) or as a skin of an existing fighter? Suggestion: a new fighter,
  unlocked from the start, with one default skin; skins come with spec 10.
- **Q3 — Which screens first:** Suggestion: home and the match first (what Mattia sees most),
  then the fighter list and screen, then the result, info and hack screens; all in this spec.
- **Q4 — Trial of part B in this spec:** Suggestion: yes, one drawing, by the author with his
  accounts (Google Flow, Meshy free plan — CC BY 4.0, credit Meshy), on free use only; the
  result is described in the document and joins the game only if Mattia prefers it to the part A
  version.
- **Q5 — Who judges "better" (G1):** Suggestion: Mattia decides per screen, the author breaks a
  tie; one session at the end of the spec, with a mid-way look after the first screens.
- **Q6 — How close to the Svelte look:** match it (same gradient, icon buttons, yellow Play), or
  use it as the minimum and give Godot its own look (root spec #22, our own identity)?
  Suggestion: match the Svelte layout and style now, own identity later.
- **Q7 — Fonts and icons:** a free display font (OFL) and a CC0 icon pack (for example Kenney's),
  or icons built in code? Suggestion: one OFL font and Kenney CC0 icons, both in `assets/`.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
