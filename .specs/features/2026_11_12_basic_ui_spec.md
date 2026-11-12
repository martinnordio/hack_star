# Basic UI Spec

> **Author:** Martin Nordio
> **Status:** 🟨 In progress
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/basic-ui`

---

# Part 1 · Requirements

## Context

The first screen has to make kids say "wow" and feel like Brawl Stars: a big animated fighter,
trophies, the Prestige badge and cool skins. It also needs an info page explaining the words
kids use, so adults can understand them. This is F1 / Spec 1 in
[overall_req.md](../overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) — browser, screen sizes,
  input, own art and smooth animation (S1–S3, S6, S7) apply here too; Brawl Stars investigation
  and feature list. There is no code yet.

**New:**
- Home screen, fighter screen with skins, info page with vocabulary.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S1 — Home screen:** Opening the game shows the home screen: the selected fighter large in
  the centre with an idle animation, the game name "Hack star", a big **Play** button, the
  player's total trophies and credits.
- **S2 — Wow entrance:** The first time the home screen opens, it plays an entrance animation
  (fighter jumps in, light or particle effects) of at most 3 seconds that can be skipped with a
  tap or click.
- **S3 — Play button:** Tapping **Play** opens the graphics demo
  ([graphics demo spec](2026_11_12_graphics_demo_spec.md)); until that exists, it shows
  "Coming soon".
- **S4 — Fighter list:** A **Fighters** button opens a list of all fighters (4–6), each with
  its picture, name, rarity, trophy count and power level; locked fighters look greyed out
  with a lock.
- **S5 — Choose fighter:** Choosing an unlocked fighter in the list makes it the fighter
  shown on the home screen.
- **S6 — Prestige badge:** A fighter with 1000 trophies or more shows a Prestige badge with
  its number (1 at 1000–1999, 2 at 2000–2999, …) on the home screen and in the fighter list.
- **S7 — Skins:** Each fighter has 2–3 skins; the fighter screen shows them, each with its
  rarity (for example Epic, Mythic, **Legendary**), and the chosen skin is shown on the home
  screen. Legendary skins have a special frame or glow.
- **S8 — Sample progress:** Until matches exist (F4, F5), the fighters start with sample
  trophies and power levels so that at least one fighter shows a Prestige badge.
- **S9 — Info page:** An **Info** button opens a page with at least the vocabulary in the
  table below: each word with a one-sentence meaning a parent understands.
- **S10 — Back:** Every screen other than home has a back button to the home screen.
- **S11 — The fighters:** The game has these 6 original fighters, each in 3D with its own
  shape and colours:

  | Fighter | Rarity | Idea | Skins (rarity) |
  |---------|--------|------|----------------|
  | Blaze | Rare | Girl with fire powers | Default · Lava (Epic) · Phoenix (Legendary) |
  | Rocko | Rare | Friendly rock golem, a tank | Default · Crystal (Epic) |
  | Turbo | Super Rare | Fast racing kid with a helmet | Default · Neon (Mythic) |
  | Frosty | Epic | Small ice yeti | Default · Snow King (Legendary) |
  | Luna | Mythic | Space cat with a ray gun | Default · Galaxy (Mythic) · Supernova (Legendary) |
  | Pixel | Legendary | Hacker robot, the face of Hack star | Default · Glitch (Legendary) |

  At the start Blaze, Rocko and Turbo are unlocked; the others are locked.

### Vocabulary for the info page

| Word | Meaning |
|------|---------|
| Brawler / fighter | A character you play with |
| Trophies | Points a fighter wins in matches; they show how good you are with it |
| Prestige | A level a fighter reaches at every 1000 trophies, shown as a badge with a number |
| Power level | How strong a fighter is (1 to 11; up to 22 in Hack star with a hack code) |
| Rarity | How rare a fighter or skin is: Rare, Super Rare, Epic, Mythic, Legendary |
| Skin | A different look (costume) for a fighter; it does not make it stronger |
| Legendary skin | The rarest and most special-looking skins |
| Credits | Money used to unlock new fighters |
| Super | A special attack that charges up by hitting enemies |
| Gadget | A small extra ability you can use a few times per match |
| Star Power | A passive bonus a fighter gets at a high power level |
| Hypercharge | A boosted Super that makes the fighter extra strong for a short time |
| Showdown | Mode where the last fighter standing wins |
| Gem Grab | Team mode: collect and hold 10 gems to win |
| Brawl Ball | Team mode: score two goals, like football |
| Bush | Tall grass where fighters hide |
| Main | The fighter a kid plays the most |
| Push / pushing | Playing a lot to win trophies with one fighter |
| Camping | Hiding (often in a bush) and waiting for others |
| Tank | A fighter with a lot of health |
| Starr Drop | A surprise reward box |
| Brawl Pass | Season pass with rewards for playing |
| GG | "Good game", said at the end of a match |
| Hack code | Hack star only: a secret code (typed or QR) that gives extras |

### Open questions

_None. Answered 2026-11-12: 3D look; the game invents the fighters (S11). Sound is left out
of this spec (see Deferred Items in the plan)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Fighter catalogue and sample progress | ✅ Done | [→ Step 1](#step-1--fighter-catalogue-and-sample-progress) |
| **2** | 3D fighter models and skins | ✅ Done | [→ Step 2](#step-2--3d-fighter-models-and-skins) |
| **3** | Home screen with entrance | ✅ Done | [→ Step 3](#step-3--home-screen-with-entrance) |
| **4** | Fighter list and fighter screen | ⬜ Not started | [→ Step 4](#step-4--fighter-list-and-fighter-screen) |
| **5** | Info page | ⬜ Not started | [→ Step 5](#step-5--info-page) |
| **6** | Final check | ⬜ Not started | [→ Step 6](#step-6--final-check) |

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
| D1 | The fighter catalogue (fighters, rarities, skins, start unlocks) is served by the Python server at `GET /api/fighters` | Game data lives on the server, as planned for matches and hack codes; tested with `pytest` |
| D2 | Fighter models are built in plain Three.js code (`buildFighter(id, skin)`) from simple shapes with toon shading and outlines, no downloaded art | One model function serves the live 3D scene and the list pictures; no asset licences to manage; fast to load (S7 of the MVP spec) |
| D3 | List pictures are rendered once into images by an off-screen renderer and cached | Six live 3D canvases would be slow and hit the iPad's limit of WebGL contexts |
| D4 | Screens are switched with one `screen` state in `App.svelte`; no router library | Four screens; a router adds nothing |
| D5 | Progress v2 adds `credits`, `powerLevels` and `selectedSkins`; old saved data falls back to the sample progress | Sample progress (S8) needs these values; there are no real players yet |
| D6 | The entrance plays once each time the game is opened | "First time the home screen opens" (S2) per visit; coming back from another screen does not replay it |

---

## Step 1 — Fighter catalogue and sample progress

### Goal
The server serves the 6 fighters with rarities and skins, and a new player starts with the sample progress (S8, S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `server/src/hack_star_server/fighters.py`: the catalogue of S11; `GET /api/fighters`.
- [x] `pytest`: 6 fighters, every fighter has 2–3 skins with one Default, Blaze/Rocko/Turbo unlocked at start.
- [x] UI `fighters.ts`: types, `loadFighters()`, Prestige level from trophies.
- [x] Progress v2 with sample data: Blaze 1240 trophies (Prestige 1), Rocko 420, Turbo 85; power levels 7, 4, 2; 500 credits.
- [x] Check: `uv run pytest` and `npm test` pass (Prestige: 999 → 0, 1000 → 1, 2500 → 2).

### Notes
Started: 2026-11-12 09:39

The server now watches only `src/hack_star_server/` for reloads (it reloaded on `.venv` changes). While the server runs on Windows, run its tests with `uv run --no-sync pytest` (the running server locks its launcher).

**Done (2026-11-12 · ~3m)** — `GET /api/fighters`, `fighters.ts`, progress v2 with sample data; `pytest` 5 passed, `npm test` 14 passed, `svelte-check` 0 errors.

---

## Step 2 — 3D fighter models and skins

### Goal
Each of the 6 fighters and each skin has a recognisable 3D look with an idle animation; Legendary skins glow (S7, S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `ui/src/lib/models/`: `buildFighter(id, skinId)` returns a Three.js group with toon materials and outlines; per-fighter shapes (Blaze flames, Rocko rocks, Turbo helmet, Frosty fur, Luna ears and ray gun, Pixel screen face).
- [x] Skins change colours and add details; Legendary skins add a glow.
- [x] `FighterStage.svelte`: shows one fighter with idle animation (breathing, sway).
- [x] Check: all 14 fighter/skin combinations render in the browser without errors.

### Notes
Started: 2026-11-12 09:42

There are 14 combinations (3+2+2+2+3+2), not 15. `?gallery` (or `?gallery=<fighter>`) shows them side by side for checking looks.

**Done (2026-11-12 · ~6m)** — 6 fighters, 14 skins with toon shading, outlines, flicker/spin idle effects; Legendary halo + sparkle ring. `?gallery` shows all 14 with no console errors.

---

## Step 3 — Home screen with entrance

### Goal
The home screen shows the selected fighter large, title, trophies, credits, Play, Fighters and Info buttons, with the entrance animation (S1–S3, S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] Home layout: top bar (total trophies, credits), fighter in the centre on a podium with its name and Prestige badge, big Play button, Fighters and Info buttons.
- [x] Entrance (≤ 3 s): fighter drops in with a bounce and sparkles, title pops in; tap or click skips.
- [x] Play shows "Coming soon".
- [x] Check: in the browser the entrance plays and can be skipped; Play shows "Coming soon"; Blaze shows Prestige 1.

### Notes
Started: 2026-11-12 09:47

The F0 placeholder arena (`Scene.svelte`) and its server/FPS overlay were replaced by the home screen; the server status now shows as a "Cannot reach the Hack star server" message with **Try again**. Portrait phones get a stacked layout (buttons above a full-width Play).

**Done (2026-11-12 · ~8m)** — home screen with rays, podium, 2.2 s drop-in entrance with sparkle burst and title pop; tap skips. Browser: skip hides "Tap to skip", Play shows "Coming soon!", Blaze shows Prestige 1 badge, 61 FPS at 1024×768; phone 390×844 layout checked.

---

## Step 4 — Fighter list and fighter screen

### Goal
The player browses fighters, sees locks, trophies, power, Prestige, and chooses a fighter and a skin (S4–S7, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Off-screen portrait renderer with cache (D3).
- [ ] Fighter list: cards with picture, name, rarity colour, trophies, power level, Prestige badge; locked cards greyed with a lock.
- [ ] Fighter screen: the fighter in 3D, its skins with rarity, Legendary with a glowing frame; **Select** sets fighter and skin.
- [ ] Back buttons to home.
- [ ] Check: choose Rocko with the Crystal skin → home shows Rocko Crystal; locked Pixel cannot be selected; reload keeps the choice.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 5 — Info page

### Goal
The Info page lists the vocabulary of Part 1 (S9, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `vocabulary.ts` with the 24 words; Info page with a readable list and a back button.
- [ ] Check: `npm test` checks there are at least 24 words, each with a meaning; the page scrolls on a phone.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 6 — Final check

### Goal
Everything works on desktop, iPad and phone sizes and the F0 foundation still works.

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Browser check at 390×844, 844×390, 1024×768, 768×1024, 1440×900: nothing cut off, ≥ 30 FPS, all buttons reachable by touch.
- [ ] `uv run pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [ ] README: mention the screens; asset list still "none" (shapes only).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Music and sound effects with a mute button | Not needed for the first wow; adds assets and licences | Later spec |
| Unlocking fighters with credits | F6 | Later spec |
| Hack button on the home screen | F2 | `2026_11_12_hack_codes_spec.md` |

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
