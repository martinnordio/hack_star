# Art Tools Research Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/art-tools-research`

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written (spec 3 of 4) |

---

# Part 1 · Requirements

## Context

We want to make Hack star's graphics ourselves, starting from our own simple drawings and
ideas, but we need help turning them into a good-looking design that works in the game. This
spec is research only: it compares free tools that can help (for example turning a picture
into a 3D model, or designing screens), tries the most promising ones on our own drawings,
and recommends a way of working. It changes no game code.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `ui/src/lib/models/` — fighters, skins and arena built in code from simple shapes with
  three.js; the game loads no model files today.
- `ui/public/assets/LICENSES.md` and the README section **Art** — only original or CC0 art;
  every asset gets a licence line.
- `/?gallery` (`ui/src/lib/Gallery.svelte`) — all fighters and skins in one 3D scene, useful
  to compare results with today's look.
- [Asset review page and developer mode](2026_11_14_2_asset_review_and_developer_mode_spec.md)
  — a page to load candidate 3D models; if it exists by then, trial results can be viewed
  there.

**New:**
- A comparison of art tools and a recommended way from drawing to game.
- Trials of a few tools with our own drawings.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [Asset licences](../../ui/public/assets/LICENSES.md) | Where every asset comes from and its licence |

## 1 · Specs

- **S1 — Kinds of tools:** The research covers at least these kinds: picture or sketch to 3D
  model, text to 3D model, picture to clean 2D art, screen and menu design (for example
  Google Stitch, which designs app screens), and free 3D modelling for fixing results by hand.
- **S2 — Enough choices:** At least eight tools are compared, with at least one in each kind
  of S1.
- **S3 — Same questions for each tool:** For each tool the comparison answers: what it does;
  cost and limits of the free use; who owns the result and whether it may be published in this
  MIT-licensed project; whether uploads are used to train the tool; minimum age and account
  needed; output file formats and whether the game can load them; how detailed (heavy) the
  results are for a phone; and how hard it is to learn.
- **S4 — Licence and terms:** A tool whose terms do not allow publishing its results in an
  open-source game, or whose terms are unclear, is marked "not recommended", with the reason
  and a link to the terms.
- **S5 — Trials:** At least three tools from S1 are tried with the same two of our own
  drawings; for each trial, the input, the result (picture or file), the time it took and a
  short judgement are recorded.
- **S6 — Side by side:** The trial results are compared with each other and with today's
  fighters at the same size and lights (for example in `/?gallery` or the review page of
  spec 2).
- **S7 — Recommendation:** The research ends with one recommended way to go from our drawing
  to a model in the game, step by step, and one fallback, each with what it costs and what it
  needs from us.
- **S8 — Privacy:** Only drawings are uploaded to online tools — no photos of people, names or
  other personal data — and only to tools whose terms allow it.
- **S9 — No game change:** The game's code and assets do not change; trial results are not
  added to the game. The findings are written into this spec.

### Open questions

- Only free tools, or also paid tools with a free trial? Proposed: free use only.
- Many online tools need an account from age 13 or 18; Martin creates and uses the accounts?
  Proposed: yes.
- Which two drawings are used for the trials?
- 3D first, or also 2D (portraits, icons, menu screens)? Proposed: 3D first, 2D as a short
  section.
- Are trial results with a clear licence kept in the repository for a later spec, or only
  described? Proposed: only described, with pictures in this spec.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
