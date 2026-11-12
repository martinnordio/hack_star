# Basic UI Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
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

### Open questions

_None. Answered 2026-11-12: 3D look; the game invents the fighters (S11). Sound is left out
of this spec (see Deferred Items in the plan)._

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

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
