# Graphics Review Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/graphics-review`
> **Issue:** #20

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written (spec 2 of 4) |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: renamed from "Asset Review Page and Developer Mode"; developer mode and the developer page moved to spec 1; open questions answered |
| 2026-11-14 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #20 created |

---

# Part 1 · Requirements

## Context

Hack star's fighters and arena are built in code from simple shapes. To find out whether free
3D packs can make the game look more impressive, the team needs a place to load candidate
models, look at them next to today's fighters, and accept or reject them — without players
seeing it. This spec adds a **Graphics** section to the developer page of spec 1, and moves the
**Print QR codes** link, which players should no longer see, behind developer mode.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Fighter studio, saves and music](2026_11_14_1_fighter_studio_saves_and_music_spec.md) —
  **must be done first**: it adds developer mode in Settings (S24) and the developer page
  `/?dev` with its code check and the **Music** section (S25–S28).
- `ui/src/main.ts` — pages chosen by address: `/?qr` (`QrPage.svelte`), `/?gallery`
  (`Gallery.svelte`, every fighter and skin in one 3D scene), otherwise the game.
- `ui/src/lib/QrPage.svelte`, `ui/src/lib/hacks.ts` (`QR_PASSWORD`, `isQrPassword`) — the
  QR page asks for the code `M6D2` every time.
- `ui/src/lib/HackScreen.svelte` — shows the **Print QR codes** link (`/?qr`) to every player.
- `ui/src/lib/FighterStage.svelte`, `ui/src/lib/models/` — how a fighter is shown in 3D with
  the game's lights; the game loads no model files today.
- `ui/public/assets/LICENSES.md` — allowed sources already include Quaternius (CC0); every
  asset added gets a line there.

**New:**
- A list of candidate graphics resources with their status.
- A **Graphics** section on the developer page to view, add, remove, accept and reject them.
- The QR printing link only in developer mode.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../README.md) | How to install, run, test and play |
| [Asset licences](../../ui/public/assets/LICENSES.md) | Where every asset comes from and its licence |

## 1 · Specs

### Candidate list

- **S1 — Candidates:** The project keeps a list of candidate graphics resources; each has a
  name, a source link, its licence, a status (candidate, accepted or rejected) and a short
  note. The list is kept in the repository, so both developers see the same decisions.
- **S2 — First candidates:** The list starts with the Quaternius packs "Easy Enemy"
  (<https://quaternius.com/packs/easyenemy.html>) and "Ultimate Monsters"
  (<https://quaternius.com/packs/ultimatemonsters.html>).
- **S3 — Licence first:** A candidate can be accepted only under CC0, or under CC BY with its
  credit shown in the About panel (spec 1, S23); the licence is checked on the source's own
  page and written in the list. Other licences are rejected with the reason.
- **S4 — Files:** The model files of a candidate are downloaded so the page works without the
  internet, but they are not part of the game players download and are not committed until
  the candidate is accepted.

### Graphics section of the developer page

- **S5 — Look at a model:** The Graphics section shows each model of a candidate in 3D,
  turning, with the game's lights, next to an existing fighter at the same scale.
- **S6 — Size for phones:** For each model the section shows its download size and number of
  triangles, so the team can judge whether it runs well on a phone.
- **S7 — Decide:** In the section, the team can add a candidate, remove one (with its
  downloaded files), and mark it accepted or rejected with a note; the decisions are kept as
  in S1.
- **S8 — Not in the game yet:** Accepting a candidate does not change the game; using
  accepted models for fighters or arenas is a later spec.

### QR codes

- **S9 — No QR link for players:** The Hack screen no longer shows **Print QR codes**;
  scanning and typing codes stay as they are.
- **S10 — QR in developer mode:** In developer mode, Settings shows a **Print QR codes**
  button next to the developer page button.
- **S11 — QR page:** `/?qr` still works by its address; in a browser with developer mode it
  opens without asking for the code, otherwise it asks as today.

### Everywhere

- **S12 — Languages:** The Settings **Print QR codes** button is shown in all game languages;
  the Graphics section is in English only, like the rest of the developer page.
- **S13 — Devices:** The Graphics section works with mouse and touch on desktop and tablet;
  it may be desktop-first.
- **S14 — Documentation:** The README and `docs/architecture.md` describe the Graphics
  section and the new place of the QR printing; `ui/public/assets/LICENSES.md` gets a line for
  every accepted resource.

### Open questions

_None — answered on 2026-11-14._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
