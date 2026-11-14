# Device and End-to-End Testing Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/device-and-end-to-end-testing`
> **Issue:** —

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written (spec 5): real-device checks left from spec 1, responsiveness, end-to-end test |

---

# Part 1 · Requirements

## Context

Spec 1 ([fighter studio, saves and music](2026_11_14_1_fighter_studio_saves_and_music_spec.md))
was checked with unit tests and in a headless desktop browser, sometimes at phone size, but
never on a real iPad or phone. Three checks were left open there. This spec does them, adds a
check of every screen on several screen sizes, and adds an end-to-end test that plays the
game from start to finish, so later specs can be checked the same way.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `ui/` unit tests with Vitest (`npm test`, 267 tests) and `npm run check`; `server/` tests
  with pytest (45 tests). No end-to-end test and no browser test tool in the repository.
- README **Play on an iPad or phone**: `npm run dev` already prints a `Network:` address for
  devices on the same Wi-Fi; `npm run dev:https` for the camera (Scan QR).
- Address options for quick matches: `?seconds=…&bots=…&level=…` (README), so a test match can
  be short.
- `ui/src/lib/music/player.ts` (start, stop, pause while the tab is hidden), `AboutPanel.svelte`
  (credits from the local track list), the creator with the new parts and skins
  (`custom3d.ts`, `FighterDetail`), the developer page `/?dev`.
- Spec 1, Steps 11–13 notes: what was checked headless and what was left for real devices.

**New:**
- Results of the three open checks from spec 1, on real devices.
- A responsiveness check of every screen on a set of device sizes.
- An end-to-end test of the main player journey.

| Document | Purpose |
|----------|---------|
| [Spec 1](2026_11_14_1_fighter_studio_saves_and_music_spec.md) | The features to check and the checks left open |
| [README](../../README.md) | How to run, play on a device, address options |
| [architecture.md](../../docs/architecture.md) | Screens and modules |

## 1 · Specs

### Checks left open from spec 1

- **S1 — Music on a real device:** On a real iPad and a real phone (Safari, and Chrome where
  available), opened by the `Network:` address, with music on:
  - the chosen track starts with the match after tapping Play, and stops when the match ends
    or the player leaves;
  - with music off in Settings, the next match is silent;
  - switching to another app or locking the screen pauses the music, and coming back to a
    running match plays it again;
  - the result for the device's silent switch and volume is written down.
- **S2 — About credits on a phone:** On a real phone, Settings → About shows every chosen
  local track (title, author or requested credit, licence) and the note; the long credit
  text wraps without sideways scrolling; the title opens the source page and the licence
  opens its official Creative Commons page. (Already passed in a headless browser at phone
  width on 2026-11-14; this is the real-device confirmation.)
- **S3 — Creator looked at by Mattia:** Mattia uses the creator on an iPad: chooses the new
  heads, bodies, hands and legs, turns the preview, makes, wears, changes and deletes skins.
  His opinion (what he likes, what looks wrong, what is hard to use) is written down, and each
  problem becomes a bug in `bug_fixes` or an idea in `ideas.md`.

### Responsiveness

- **S4 — Device set:** Every screen is checked on these sizes, in portrait and landscape:
  small phone (about 375×667), large phone (about 430×932), iPad (about 820×1180), and
  desktop (1280×800 and 1920×1080). At least one real phone and one real iPad are among them.
- **S5 — Screens:** The check covers: home with the 3D fighter, fighter list and detail,
  skins and the shop, the creator, hack codes, Settings (music, bots, language, developer
  mode), About, accounts, Friends (room and join), a match (joystick, aim, Super), the result
  screen, the info page and `/?dev` (desktop only, S30 of spec 1).
- **S6 — Pass rule:** On each size a screen passes when nothing is cut off or overlaps, there is
  no sideways scrolling, every button can be reached and tapped, and text is readable.
- **S7 — Languages:** The check is done in English and in the language with the longest
  words (German or Swiss German), so long labels are seen.
- **S8 — Results:** The results are a table in this spec (screen × size, pass or the
  problem); each problem becomes a bug in `bug_fixes` with a screenshot description.

### End-to-end test

- **S9 — Player journey:** An end-to-end test plays the main journey in a real browser:
  open the game, add an account, open a fighter, play a short match against bots
  (`?seconds=…`) to the result, see trophies and credits change, buy or wear a skin, enter a
  hack code, create a fighter with a skin, turn music off and on, open About, reload the page
  and see everything kept.
- **S10 — Friends:** The test also opens a room in one browser and joins it from a second one,
  and both reach the start of the match.
- **S11 — Repeatable:** The test runs with one command, starts from a clean browser, needs no
  music files (with no tracks the music part checks "Music is coming soon."), and reports
  which step failed.
- **S12 — Sizes:** The journey runs at least at desktop and phone size (S4).
- **S13 — Documentation:** The README section on checks says how to run the end-to-end test
  and the device checks.

### Everywhere

- **S14 — No game change:** This spec changes no game behaviour; problems found become bugs
  or ideas. Small fixes to make the test possible (for example a stable label to find a
  button) are allowed and listed.

### Open questions

- **Q1 — Test tool:** Should the end-to-end test be added to the repository with a browser
  test tool (for example Playwright, as a dev dependency in `ui/`), or be a written checklist
  run by hand? Default: Playwright in the repository, so it can be repeated after every spec.
- **Q2 — Devices at hand:** Which real devices are available (iPad model, phone model,
  iOS / Android)? Default: one iPad and one iPhone with Safari.
- **Q3 — Branch:** Should the three spec 1 checks (S1–S3) wait for this spec, or be done now
  on the spec 1 branch before it is closed? Default: they move here, and spec 1 closes with
  them listed as moved to this spec.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
