# Asset Review Page and Developer Mode Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/asset-review-and-developer-mode`

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written (spec 2 of 4) |

---

# Part 1 · Requirements

## Context

Hack star's fighters and arena are built in code from simple shapes. To find out whether free
3D packs can make the game look more impressive, the team needs a place to load candidate
models, look at them next to today's fighters, and accept or reject them — without players
seeing it. The same "developer" idea replaces the **Print QR codes** link on the Hack screen,
which players should no longer see.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `ui/src/main.ts` — pages chosen by address: `/?qr` (`QrPage.svelte`), `/?gallery`
  (`Gallery.svelte`, every fighter and skin in one 3D scene), otherwise the game.
- `ui/src/lib/QrPage.svelte`, `ui/src/lib/hacks.ts` (`QR_PASSWORD`, `isQrPassword`) — the
  QR page asks for the code `M6D2` every time; the code is in the public source, so it is a
  lock for kids, not security.
- `ui/src/lib/HackScreen.svelte` — shows the **Print QR codes** link (`/?qr`) to every player.
- `ui/src/lib/SettingsScreen.svelte`, `ui/src/lib/options.ts` — Settings, saved per browser
  under `hack-star.options`.
- `ui/src/lib/FighterStage.svelte`, `ui/src/lib/models/` — how a fighter is shown in 3D with
  the game's lights.
- `ui/public/assets/LICENSES.md` — allowed sources already include Quaternius (CC0); every
  asset added gets a line there.

**New:**
- A list of candidate graphics resources with their status.
- A development page to view, add, remove, accept and reject candidates.
- A developer mode per browser, switched on in Settings with the code.
- The QR printing link shown only in developer mode.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../README.md) | How to install, run, test and play |
| [Asset licences](../../ui/public/assets/LICENSES.md) | Where every asset comes from and its licence |

## 1 · Specs

### Candidate list

- **S1 — Candidates:** The project keeps a list of candidate resources; each has a name, a
  source link, its licence, a status (candidate, accepted or rejected) and a short note.
- **S2 — First candidates:** The list starts with the Quaternius packs "Easy Enemy"
  (<https://quaternius.com/packs/easyenemy.html>) and "Ultimate Monsters"
  (<https://quaternius.com/packs/ultimatemonsters.html>).
- **S3 — Licence first:** A candidate can be accepted only if its licence allows use, change
  and redistribution in this MIT-licensed project (for example CC0); the licence is checked on
  the source's own page and written in the list. Others stay rejected with the reason.

### Review page

- **S4 — Hidden page:** The review page opens only by its address (for example `/?assets`);
  no button or link in the game leads to it.
- **S5 — Code once per browser:** The first time, the page asks for the developer code (the
  same code as the QR page). A wrong code shows a message; after the right code, this browser
  opens the page without asking again.
- **S6 — Look at a model:** The page shows each model of a candidate in 3D, turning, with the
  game's lights, next to an existing fighter at the same scale.
- **S7 — Size for phones:** For each model the page shows its download size and number of
  triangles, so the team can judge whether it runs well on a phone.
- **S8 — Decide:** On the page, the team can add a candidate, remove one, and mark it accepted
  or rejected with a note; the decisions are still there the next time the page is opened.
- **S9 — Not in the game yet:** Accepting a candidate does not change the game; using
  accepted models for fighters or arenas is a later spec.

### Developer mode

- **S10 — Switch in Settings:** Settings has a **Developer mode** control. Turning it on asks
  for the developer code; with the right code, developer mode stays on in this browser until
  it is turned off.
- **S11 — Developer buttons:** In developer mode, Settings shows the developer buttons: print
  QR codes and open the review page.
- **S12 — No QR link for players:** The Hack screen no longer shows **Print QR codes**;
  scanning and typing codes stay as they are.
- **S13 — QR page:** `/?qr` still works by its address, and asks for the code as today unless
  developer mode is on in this browser.

### Everywhere

- **S14 — Languages:** The Settings developer control and its messages are shown in all game
  languages.
- **S15 — Devices:** The review page and the developer control work with mouse and touch on
  desktop and tablet; the review page may be desktop-first.
- **S16 — Documentation:** The README and `docs/architecture.md` describe the review page,
  developer mode and where the code is entered; `ui/public/assets/LICENSES.md` gets a line for
  every accepted resource.

### Open questions

- Where is the candidate list kept so that both developers see the same decisions: a file in
  the repository (the page offers the updated list to save), a development-only server
  endpoint, or only in the browser? Proposed: a file in the repository.
- Are the downloaded pack files committed to the repository, or kept out of it until a model
  is accepted? Proposed: kept out; only accepted models are added, with their licence line.
- Is the review page in English only? Proposed: yes, it is for developers.
- Page address: `/?assets`, or another name?
- Can developer mode also be turned off from the review page? Proposed: only in Settings.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
