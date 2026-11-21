# Basic UI Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/basic-ui`
> **Moved from:** [2026_11_12_basic_ui_spec.md](../../../.specs/features/done/2026_11_12_basic_ui_spec.md) (#2)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Opus 5.5 | included in [02](2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_basic_ui_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

The first screen has to make kids say "wow" and feel like Brawl Stars: a big animated fighter,
trophies, the Prestige badge and cool skins. It also needs an info page explaining the words
kids use, so adults can understand them. This is F1 / Spec 1 in
[overall_req.md](../../../.specs/overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_basic_ui_spec.md) (#2).
- [MVP and architecture spec](2026_11_12_03_mvp_and_architecture_spec.md) — browser, screen sizes,
  input, own art and smooth animation (S1–S3, S6, S7) apply here too; Brawl Stars investigation
  and feature list; the Godot technology, the architecture document
  `hack_star_godot/docs/architecture.md` and how to run the game (S12–S14).
- Spec 01's Godot project
  ([01 Godot Setup and First Game](done/2026_11_21_01_godot_setup_and_first_game_spec.md)):
  a start screen with **Play** that opens a 3D arena seen from above at an angle with one
  fighter, moved with the keyboard or a touch joystick; Godot 4.7.2 with GDScript, the
  Compatibility renderer, a single-threaded web export, GUT tests and the commands in
  `hack_star_godot/tools/` ([hack_star_godot/README.md](../../README.md)).

**New:**
- Home screen, fighter screen with skins, info page with vocabulary.
- The UI foundation of the Godot game that later specs reuse (S12).

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–03) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
- **S1 — Home screen:** Opening the game shows the home screen: the selected fighter large in
  the centre with an idle animation, the game name "Hack star", a big **Play** button, the
  player's total trophies and credits.
- **S2 — Wow entrance:** The first time the home screen opens, it plays an entrance animation
  (fighter jumps in, light or particle effects) of at most 3 seconds that can be skipped with a
  tap or click.
- **S3 — Play button:** Tapping **Play** opens the graphics demo
  ([graphics demo spec](2026_11_12_06_graphics_demo_spec.md)); until that exists, it shows
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
- **S12 — UI foundation:** The user interface of the Godot game has one look shared by all
  screens (colours, text styles, buttons, the Back button), one way to go from screen to
  screen that later specs reuse, and layouts that fit desktop, iPad and phone in landscape
  and portrait, with touch and mouse; it is written down in
  `hack_star_godot/docs/architecture.md` ([spec 03](2026_11_12_03_mvp_and_architecture_spec.md)).

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
of this spec (see Deferred Items in the plan of the
[original spec](../../../.specs/features/done/2026_11_12_basic_ui_spec.md))._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
