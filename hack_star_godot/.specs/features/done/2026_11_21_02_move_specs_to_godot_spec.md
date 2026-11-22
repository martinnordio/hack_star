# Move Specs to Godot Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed on `main`
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `main` (worked on directly, no pull request)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in [01](2026_11_21_01_godot_setup_and_first_game_spec.md) | included in [01](2026_11_21_01_godot_setup_and_first_game_spec.md) | Part 1 written, in the same run as spec 01 |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in [01](2026_11_21_01_godot_setup_and_first_game_spec.md) | included in [01](2026_11_21_01_godot_setup_and_first_game_spec.md) | Part 1 revised: the root kit is used, no Godot kit (Context, S12) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row below | included in the plan row below | Part 1 revised: open questions answered (Worlds moved now from its branch, Bug Fixes own spec, global numbers, `overall_req.md` linked); S1, S7 changed; S13 requirement 0, S14 Godot architecture, S15 Godot UI, S16, S17 (on `main`) added |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 3.05 M (26 k in · 3.01 M cached · 16 k out) | CHF 0.88 (105 credits) | Part 2 written (also covers the requirements revision above) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 714 k (84 k in · 613 k cached · 17 k out) | CHF 0.74 (88 credits) | Step 1 done |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 801 k (74 k in · 706 k cached · 21 k out) | CHF 0.41 (49 credits) | Step 2 done |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 653 k (61 k in · 572 k cached · 20 k out) | CHF 0.35 (41 credits) | Step 3 done |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.69 M (72 k in · 1.59 M cached · 26 k out) | CHF 0.50 (60 credits) | Step 4 done |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | 946 k (85 k in · 839 k cached · 22 k out) | CHF 0.03 (3 credits) | Step 5 done |
| 2026-11-21 | review | `REVIEW:` / `CODE REVIEW:` | Claude Opus 5.5 | 2.60 M (126 k in · 2.44 M cached · 36 k out) | CHF 1.55 (185 credits) | review page written; code review: Approve (0 blocking, 3 should-fix, 5 nit) |
| 2026-11-21 | implementation | `CLOSE:` | Claude Sonnet 5.5 | 1.13 M (68 k in · 1.05 M cached · 13 k out) | CHF 0.34 (40 credits) | review fixes #1–#6, #8; spec closed |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 6.93 M (490 k in · 6.43 M cached · 14 k out) | CHF 3.37 (401 credits) | orchestrator of the per-Step run, review, fixes and close: starting the sub-agents, checks, commits, push (`usage.ps1 -Agent main` from 15:20) |
---

## Cost summary

This feature used 18.51 M tokens, CHF 8.17 (972 credits) — measured, see [COSTS.md](../../../../.specs/kit/COSTS.md).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| requirements | Claude Opus 5.5 | included in plan | included in plan | 0 % |
| plan | Claude Opus 5.5 | 3.05 M | CHF 0.88 (105 credits) | 5.5 % |
| implementation | Claude Opus 5.5, Claude Sonnet 5.5, Claude Haiku 5.5 | 12.86 M | CHF 5.74 (682 credits) | 35.9 % |
| review | Claude Opus 5.5 | 2.60 M | CHF 1.55 (185 credits) | 9.7 % |
| **Total** | | **18.51 M** | **CHF 8.17 (972 credits)** | **51.2 %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (CHF) | Share of Copilot Business |
|------|-------|--------|------------|---------------------------|
| Step 1 | Claude Opus 5.5 | 714 k | CHF 0.74 (88 credits) | 4.6 % |
| Step 2 | Claude Sonnet 5.5 | 801 k | CHF 0.41 (49 credits) | 2.6 % |
| Step 3 | Claude Sonnet 5.5 | 653 k | CHF 0.35 (41 credits) | 2.2 % |
| Step 4 | Claude Sonnet 5.5 | 1.69 M | CHF 0.50 (60 credits) | 3.2 % |
| Step 5 | Claude Haiku 5.5 | 946 k | CHF 0.03 (3 credits) | 0.2 % |
| Review fixes and CLOSE | Claude Sonnet 5.5 | 1.13 M | CHF 0.34 (40 credits) | 2.1 % |
| Orchestrator (Steps, review, fixes, close) | Claude Opus 5.5 | 6.93 M | CHF 3.37 (401 credits) | 21.1 % |
| **Total implementation** | | **12.86 M** | **CHF 5.74 (682 credits)** | **35.9 %** |
# Part 1 · Requirements

## Context

The Godot game is built from the same requirements as the Python + Svelte game, instead of by
studying its code. Every finished spec of the root `.specs/features/done/` is copied into
`hack_star_godot/.specs/features/` with its requirements only (Part 1), numbered in the order
the features were built, so that the plan and implementation stages can then run on them one
after the other. It needs the folder, and the rule for Godot specs with the root kit, from
[2026_11_21_01_godot_setup_and_first_game_spec.md](2026_11_21_01_godot_setup_and_first_game_spec.md).

**Already in the repository:**
- 17 finished specs in [.specs/features/done/](../../../../.specs/features/done/). Each has a
  header, a Stage log, Part 1 · Requirements, the marker `<!-- spec-nx:plan -->` and Part 2 ·
  Plan (Steps with Done lines, Decisions, Review Log, Definition of Done); the later ones also
  have a Cost summary above Part 1.
- Their Part 1 mixes requirements with facts about the Python + Svelte game: the
  *Already in the repository* lists name files in `server/` and `ui/`, and the
  *MVP and Architecture* spec has statements about the technology (S4 Python and Svelte,
  S5 run the server and the UI).
- The order they were built in, from git (the commit that moved each spec to `done/`) — on
  2026-11-12 twelve specs were closed one after another between 09:38 and 14:24:

  | Order | Spec in `.specs/features/done/` | Closed |
  |-------|---------------------------------|--------|
  | 03 | `2026_11_12_mvp_and_architecture_spec.md` (#1) | 11-12 09:38 |
  | 04 | `2026_11_12_basic_ui_spec.md` (#2) | 11-12 09:57 |
  | 05 | `2026_11_12_hack_codes_spec.md` (#3) | 11-12 10:09 |
  | 06 | `2026_11_12_graphics_demo_spec.md` (#4) | 11-12 10:31 |
  | 07 | `2026_11_12_first_match_spec.md` (#5) | 11-12 10:49 |
  | 08 | `2026_11_12_trophies_spec.md` (#6) | 11-12 11:09 |
  | 09 | `2026_11_12_unlock_and_upgrade_spec.md` (#7) | 11-12 11:33 |
  | 10 | `2026_11_12_skins_shop_spec.md` (#8) | 11-12 11:57 |
  | 11 | `2026_11_12_overtime_and_match_options_spec.md` (#9) | 11-12 13:24 |
  | 12 | `2026_11_12_super_and_hypercharge_spec.md` (#11) | 11-12 13:33 |
  | 13 | `2026_11_12_more_fighters_spec.md` (#10) | 11-12 13:51 |
  | 14 | `2026_11_12_play_with_friends_spec.md` (#12) | 11-12 14:24 |
  | 15 | `2026_11_13_accounts_fighters_and_languages_spec.md` (#15) | 11-13 18:05 |
  | 16 | `2026_11_14_bug_fixes_spec.md` (#17) | 11-14 13:40 |
  | 17 | `2026_11_14_1_fighter_studio_saves_and_music_spec.md` (#19) | 11-14 19:46 |
  | 18 | `2026_11_16_worlds_and_world_coins_spec.md` (#24) | 11-18 15:50, on `feature/worlds-and-world-coins` |

  Not a game feature: `2026_11_16_spec_nx_kit_update_spec.md` (a kit update). Not finished,
  so not moved: the specs still in `.specs/features/` (graphics review, art tools research,
  originality review, device and end-to-end testing, model experiment, and two stale copies
  of *More Fighters* and *Super and Hypercharge*).
- The plan stage ([.specs/kit/plan/prompt.md](../../../../.specs/kit/plan/prompt.md)) only
  plans a spec whose Part 1 has no open questions and whose Part 2 is the placeholder below
  the marker.

**New:**
- The finished game specs, requirements only, numbered, in `hack_star_godot/.specs/features/`.
- An ordered list of them, so the next spec to plan and implement is always clear.

## 1 · Specs

- **S1 — Which specs:** Every finished game spec is moved — the 16 listed above (03–18).
  Specs about the kit or tools, and specs that are not finished, are not moved. 03–17 come
  from the root `.specs/features/done/` on `main`; 18 (*Worlds and World Coins*) is finished
  only on the branch `feature/worlds-and-world-coins`, so its closed copy is taken from that
  branch (`.specs/features/done/2026_11_16_worlds_and_world_coins_spec.md`).
- **S2 — Order:** The specs are numbered in the order the features were built (the table
  above), so that each one only needs features of specs with a lower number. The two Godot
  specs of this folder are 01 and 02, and the moved specs continue with 03.
- **S3 — File name:** A moved spec is named `<original date>_<NN>_<original name>_spec.md`,
  with the two-digit order number right after the date (for example
  `2026_11_21_03_mvp_and_architecture_spec.md`); an older number in the name is replaced
  (`2026_11_14_1_fighter_studio_…` becomes `2026_11_14_17_fighter_studio_…`).
- **S4 — Requirements only:** A moved spec keeps its title and Part 1 statements word for
  word; everything below the marker `<!-- spec-nx:plan -->` is replaced by the empty Part 2
  placeholder, and the Cost summary is removed.
- **S5 — Fresh header:** A moved spec has the status `⬜ Requirements in progress`, today's
  dates, a Godot branch name, no `Issue:` line (so a new issue can be created), a line
  `> **Moved from:** <link to the original spec> (#<original issue>)`, and a new Stage log
  whose first row records the move.
- **S6 — No Python facts as requirements:** The *Already in the repository* part of a moved
  spec no longer lists Python or Svelte files as if they were in the Godot game: it points to
  the original spec for how the Python game did it and lists what the Godot folder already
  has (the lower-numbered specs).
- **S7 — Technology statements replaced, not hidden:** A statement that names the Python +
  Svelte technology or tools is not silently changed or deleted: it is struck through with
  the reason (`~~S4 — …~~ (replaced for the Godot game by S<n>)`) and a Godot statement is
  added at the end of the list (S13, S14). Where the Godot answer is not decided yet (for
  example whether rooms and hack codes use the existing FastAPI server), it goes under
  **Open questions** with a suggestion, so the author decides it before the spec is
  planned.
- **S8 — Links work:** Every link in a moved spec opens the right file from its new place
  (the overall game idea, the original spec, other moved specs, images).
- **S9 — Originals unchanged:** The specs in the root `.specs/` are not changed, moved or
  deleted.
- **S10 — One after another:** The specs are moved in their order, one at a time; each moved
  spec is checked (S3–S8) before the next one, and the move can stop after any spec and go
  on later.
- **S11 — Ordered list:** `hack_star_godot/.specs/features/README.md` lists all moved specs in
  their order with the original spec and the status of each (requirements, planned,
  implemented, closed), and is updated when a spec changes status.
- **S12 — Ready for the tools:** After the move, `PLAN:` of the root kit can run on the first
  moved spec whose open questions are answered, then `IMPLEMENT:`, `REVIEW:` and `CLOSE:` as
  for any spec, and the cost list `hack_star_godot/.specs/costs.md` lists every moved spec.
- **S13 — Requirement 0 in every moved spec:** Every moved spec starts its statements with
  **S0 — Check with the Godot game**: before the spec is planned, each of its statements is
  checked against the Godot game as built so far (the lower-numbered specs) and the Godot
  architecture (S14); a statement that does not fit — it names the Python + Svelte game, the
  behaviour was changed by a later spec, or it no longer makes sense — is revised with
  `REQUIREMENTS: <spec file> — …` before `PLAN:`. In *Bug Fixes* (16), S0 also asks for
  each bug whether it can happen in the Godot game at all, and a bug that cannot is turned
  into a statement of the correct behaviour (so it is still tested) instead of a fix.
- **S14 — Godot architecture (*MVP and Architecture*, 03):** The moved spec 03 describes the
  architecture of the Godot game instead of the Python + Svelte one: its technology and
  run-locally statements (S4, S5) are replaced (S7) by statements for Godot 4.7 with
  GDScript, exported for the web and played in the browser (from spec 01), and by a
  statement that the Godot game has an architecture document,
  `hack_star_godot/docs/architecture.md`, describing how screens, game rules, 3D models,
  saved progress, rooms and tests are organised, which every later spec reads and keeps up
  to date. The server question (rooms and hack codes) is an open question of spec 03.
- **S15 — Godot UI (*Basic UI*, 04):** The moved spec 04 asks for the user interface of the
  Godot game as its foundation: one look shared by all screens (colours, text styles,
  buttons, the Back button), one way to go from screen to screen that later specs reuse, and
  layouts that fit desktop, iPad and phone in landscape and portrait — in addition to its
  screens (home, fighters, skins, info).
- **S16 — Links to the overall game idea:** Links to `overall_req.md` point to the root
  [.specs/overall_req.md](../../../../.specs/overall_req.md); it is not copied.
- **S17 — On `main`:** The move is done on `main`, committed after each Step, without a pull
  request; the moved specs have no issue yet.

### Open questions

_None. Answered 2026-11-21: Worlds and World Coins is moved now as 18 from its branch (S1);
Bug Fixes is moved as its own spec (16, S13); global numbers 01–18 (S2); `overall_req.md` is
linked, not copied (S16)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** The Godot game now has its own spec set: the ordered list `hack_star_godot/.specs/features/README.md` (01–18) and 16 specs (03–18) moved from the Python + Svelte game, each with the Godot header, a Stage log row, S0 (check the spec against the Godot game before planning) and its statements adapted where D3 says so; 03 and 04 got the Godot architecture and UI statements, 18 was moved from its branch. The root `.specs/` is unchanged (S9). The code review (Approve) found 8 points; #1–#6 and #8 are fixed, #7 is a Deferred Item.

**Differs from the plan:** Steps 2–4 and the final check found nothing to change; the work was on `main` without a pull request (S17), so the pull-request line of the Definition of Done is not applicable. The review fixes and the closing ran in one run after the code review.

**Files:** `hack_star_godot/.specs/features/README.md`, `hack_star_godot/.specs/features/2026_11_12_03` … `2026_11_16_18` (16 moved specs), `hack_star_godot/.specs/costs.md`, `hack_star_godot/README.md` (Specs section), `hack_star_godot/.specs/review/2026-11-21_main-move-specs-to-godot.html` and `index.html`; this spec, now in `done/`.
## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Ordered list; move 03 MVP and Architecture and 04 Basic UI for Godot | reasoning (Claude Opus 5.5) — Godot architecture and UI statements | ✅ Done | [→ Step 1](#step-1--ordered-list-move-03-mvp-and-architecture-and-04-basic-ui-for-godot) |
| **2** | Move 05–10 | standard (Claude Sonnet 5.5) — same rules, applied to six specs | ✅ Done | [→ Step 2](#step-2--move-0510) |
| **3** | Move 11–15 | standard (Claude Sonnet 5.5) — same rules, applied to five specs | ✅ Done | [→ Step 3](#step-3--move-1115) |
| **4** | Move 16 Bug Fixes, 17 Fighter Studio, 18 Worlds | standard (Claude Sonnet 5.5) — same rules; S0 variant for bugs; Worlds from its branch | ✅ Done | [→ Step 4](#step-4--move-16-bug-fixes-17-fighter-studio-18-worlds) |
| **5** | Final check of all moved specs | light (Claude Haiku 5.5) — running the checks, fixing links | ✅ Done | [→ Step 5](#step-5--final-check-of-all-moved-specs) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· <tokens> · <currency> <amount>` from the `usage` script (`-Agent subagents` over the
>    sub-agent's time in a per-Step run; the orchestrator gets its own row, `-Agent main`).
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

> **Godot spec (`AGENTS.md`):** everything this spec writes is under
> `hack_star_godot/.specs/`; the root `.specs/` is only read (S9). Work and commit on `main` (S17).

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **By hand, no script:** each spec is moved by reading it and writing the new file; nothing is added to the game or the tools. | The adaptations (Already in the repository, technology statements, S0) need judgement; a change of specs and documents only needs a review page, not a change record (`.specs/kit/review/semantic_diff.md`). |
| D2 | **Header of a moved spec:** title unchanged; `Author` as in the original; `Status: ⬜ Requirements in progress`; `Created` and `Last updated` 2026-11-21; `Branch: feature/<name>` (name without date and number, `_` → `-`); `> **Moved from:** [<original file>](<link>) (#<original issue>)`; no `Issue:` line; a Stage log (template of `.specs/kit/spec_template.md`) whose first row is `\| 2026-11-21 \| requirements \| move \| <model> \| included in [02](2026_11_21_02_move_specs_to_godot_spec.md) \| included in [02](…) \| moved from <original> (requirements only) \|`. | S5; costs are counted once, in this spec (COSTS.md rule 4). |
| D3 | **What is copied:** from `# Part 1 · Requirements` down to the marker, word for word, except the changes of S6, S7, S13–S16; the original header, Stage log, Cost summary and Part 2 are dropped; below the marker only the Part 2 placeholder of the requirements stage. | S4; the history stays in the original (the *Moved from* link). |
| D4 | **S0** is the first statement of `## 1 · Specs`: `- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is checked against the Godot game as built so far (specs 01–<NN−1>) and the Godot architecture (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense — is revised with `REQUIREMENTS:` before `PLAN:`.` In 16 (*Bug Fixes*) it adds: `For each bug: can it happen in the Godot game? If not, the statement describes the correct behaviour so it is still tested, not a fix.` | S13 — one fixed wording, so every spec asks the same. |
| D5 | **Already in the repository** of a moved spec: (1) `How the Python + Svelte game did it: [original spec](…)`; (2) the moved specs with a lower number it builds on (links); (3) for 03–04 also spec 01's Godot project. Python and Svelte file paths are removed. | S6. |
| D6 | **Links** from `hack_star_godot/.specs/features/`: `overall_req.md` → `../../../.specs/overall_req.md` (S16); the original spec → `../../../.specs/features/done/<file>`; another moved spec → its new file name in the same folder; root documents (README, `docs/architecture.md`) → `../../../<path>`, labelled *(Python + Svelte game)*; images → their root path. *Worlds* (18) is not on `main`: its *Moved from* link is `https://github.com/martinnordio/hack_star/blob/feature/worlds-and-world-coins/.specs/features/done/2026_11_16_worlds_and_world_coins_spec.md`. | S8. |
| D7 | **Spec 03 (S14):** S4 and S5 struck through (`(replaced for the Godot game by S12 / S14)`); new **S12 — Technology:** Godot 4.7 with GDScript, exported for the web, played in the browser (spec 01); **S13 — Architecture document:** `hack_star_godot/docs/architecture.md` describes how screens, game rules, 3D models, saved progress, rooms and tests are organised; every later spec reads it and keeps it up to date; **S14 — Run locally:** a developer opens, runs, tests, exports and serves the game following `hack_star_godot/README.md`, and plays from an iPad or phone on the same Wi-Fi. Open question: *rooms and hack codes — the existing FastAPI server or something in Godot? Suggestion: keep the FastAPI server (same rooms and codes as the Python game).* The *graphics fast* investigation table (Three.js, PixiJS, Phaser) stays as history with a one-line note that Godot replaces those options; the feature list links point to the moved specs. | S14, S7. |
| D8 | **Spec 04 (S15):** new **S12 — UI foundation:** one look shared by all screens (colours, text styles, buttons, the Back button), one way to go from screen to screen that later specs reuse, layouts that fit desktop, iPad and phone in landscape and portrait, touch and mouse; written down in `hack_star_godot/docs/architecture.md` (spec 03). Its screens (S1–S11) stay. | S15. |
| D9 | **Ordered list** `hack_star_godot/.specs/features/README.md`: one table — `Order \| Spec \| Moved from \| Status` — with 01 and 02 (Godot specs, `done/` links) and 03–18; status words: *requirements*, *planned*, *implemented*, *closed*; a short paragraph on how to work through it (S0 → `REQUIREMENTS:` if needed → `PLAN:` → `IMPLEMENT:` → `REVIEW:` → `CLOSE:`). | S11. |

---

## Step 1 — Ordered list; move 03 MVP and Architecture and 04 Basic UI for Godot

### Goal
The ordered list exists and the two foundation specs are moved with the Godot architecture
and Godot UI statements (S2–S8, S11, S13–S16).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `hack_star_godot/.specs/features/README.md` (D9) with all 18 rows (03–18 status
      *to move* until moved).
- [x] `2026_11_21_03_mvp_and_architecture_spec.md` from the root original (D2–D7).
- [x] `2026_11_21_04_basic_ui_spec.md` from the root original (D2–D6, D8).
- [x] Check: both files have the header of D2, S0 first, no Part 2 content, every link
      resolves (`Test-Path` from the folder; the GitHub link of D6 not needed here); the
      README lists 03–04 as *requirements*; `git status` shows nothing under the root
      `.specs/`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-21 15:20

Links from 03 and 04 to the not-yet-moved specs use their future names (03: 05–14, 16; 04: 06);
they resolve once Steps 2–4 move them and are checked in Step 5. The feature list of 03 has no
rows for 15, 17 and 18 (as in the original), so it links only to 04–14 and 16.

**Done (2026-11-21 · ~2m · Claude Opus 5.5)** — ordered list `README.md` (01–18; 03–04
*requirements*, 05–18 *to move*); 03 moved with S0, S4/S5 struck, S12 Technology, S13
Architecture document, S14 Run locally and the server open question; 04 moved with S0 and S12
UI foundation. Check: both headers as D2 (no `Issue:`), first statement S0, only the Part 2
placeholder below the marker, every relative link resolves with `Test-Path` except the 12
future targets above; `git status --short .specs` empty. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 714 k (84 k in · 613 k cached · 17 k out) · CHF 0.74 (88 credits)

---

## Step 2 — Move 05–10

### Goal
*Hack Codes*, *Graphics Demo*, *First Match*, *Trophies and Prestige*, *Unlock and Upgrade*
and *Skins Shop* are moved in their order (S1–S10, S13, S16).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Move 05 `hack_codes`, 06 `graphics_demo`, 07 `first_match`, 08 `trophies`, 09
      `unlock_and_upgrade`, 10 `skins_shop` (D2–D6), one after another; technology
      statements per S7; update the README row of each.
- [x] Check (each file): header of D2, S0 first, statements otherwise word for word
      (compare with the original), no Part 2 content, every link resolves.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-21 15:23

Only the documentation statements named the Python + Svelte documents (08 S9, 09 S11, 10 S11):
each is struck through and replaced at the end of the list (08 S10, 09 S12, 10 S12). Python and
Svelte file paths were removed from *Already in the repository*; the lists of documents point to
`hack_star_godot/docs/architecture.md` (not written yet, so not a link) and
[hack_star_godot/README.md](../../../README.md). 06 also lists spec 01's Godot arena. No links to
not-yet-moved specs.

**Done (2026-11-21 · ~2m · Claude Sonnet 5.5)** — 05–10 moved, README rows 05–10 set to
*requirements*. Check: header of D2 (no `Issue:`), S0 first, only the Part 2 placeholder below
the marker, all other statements identical to the originals, every relative link resolves with
`Test-Path`; `git status --short .specs` empty. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 801 k (74 k in · 706 k cached · 21 k out) · CHF 0.41 (49 credits)
---

## Step 3 — Move 11–15

### Goal
*Overtime and Match Options*, *Super and Hypercharge*, *More Fighters*, *Play with Friends*
and *Accounts, Create a Fighter, New Fighters and Languages* are moved (S1–S10, S13, S16).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Move 11 `overtime_and_match_options`, 12 `super_and_hypercharge`, 13 `more_fighters`,
      14 `play_with_friends`, 15 `accounts_fighters_and_languages` (D2–D6); technology
      statements per S7 (14 names the server: open question pointing to spec 03's server
      question); update the README rows.
- [x] Check (each file): as in Step 2.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-21 15:26

The documentation statements of 11–14 (S9) name the Python + Svelte documents: each is struck
through and replaced at the end of the list (S10). 15 has no such statement. 14 got the open
question Q3 pointing to spec 03's server question, with the same suggestion (keep the FastAPI
server). The *Already in the repository* lists lost their Python and Svelte file paths; 12 says
fighter types come later with 13 (the original said "if it is done first"). No links to
not-yet-moved specs (16–18).

**Done (2026-11-21 · ~3m · Claude Sonnet 5.5)** — 11–15 moved, README rows 11–15 set to
*requirements*. Check: header of D2 (no `Issue:`), S0 first, only the Part 2 placeholder below
the marker, all other statements identical to the originals, every relative link resolves with
`Test-Path`; `git status --short .specs` empty. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 653 k (61 k in · 572 k cached · 20 k out) · CHF 0.35 (41 credits)

---

## Step 4 — Move 16 Bug Fixes, 17 Fighter Studio, 18 Worlds

### Goal
The last three specs are moved, *Bug Fixes* with the bug variant of S0 and *Worlds* from its
branch (S1–S10, S13, S16).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Move 16 `bug_fixes` (S0 with the bug sentence of D4), 17 `fighter_studio_saves_and_music`
      (from `2026_11_14_1_…`; the music rules stay: no music in the repository), 18
      `worlds_and_world_coins` from `git show feature/worlds-and-world-coins:.specs/features/done/2026_11_16_worlds_and_world_coins_spec.md`
      with the GitHub *Moved from* link (D6); update the README rows.
- [x] Check (each file): as in Step 2.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-21 15:28

16: S0 has the bug sentence of D4; no statement was struck. The *What was found* list is kept as
history (it names the Python + Svelte game's dev server); the `REQUIREMENTS:` file name in the
Context and the link in S7 point to the new names. 17: S31 (documents and paths), S32 (path of
the licences document) and S34 (`npm run dev`) are struck and replaced by S35, S36 (music in the
git-ignored `hack_star_godot/assets/music/`, spec 01 D13) and S37; new open question Q1: how the
music tools work in Godot. 18: S24 (documentation) struck, replaced by S25; `ideas.md` links to
the root file; Created/Last updated are today's date (D2).

**Done (2026-11-21 · ~3m · Claude Sonnet 5.5)** — 16–18 moved, README rows 16–18 set to
*requirements*. Check: header of D2 (no `Issue:`), S0 first, only the Part 2 placeholder below
the marker, all other statements identical to the originals, every relative link resolves with
`Test-Path`; `git status --short .specs` empty. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 1.69 M (72 k in · 1.59 M cached · 26 k out) · CHF 0.50 (60 credits)

---

## Step 5 — Final check of all moved specs

### Goal
All 16 moved specs and the list are consistent, the originals are unchanged, and the tools
work on the moved specs (S1–S13, S16, S17).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Script-free check over all 16 files: name pattern `<date>_<NN>_<name>_spec.md` with
      03–18 once each; header of D2; first statement `S0`; the marker followed only by the
      Part 2 placeholder; no `### Notes`, `**Done (`, `## Cost summary`; every relative link
      resolves; struck statements have a replacement or reason.
- [x] `git diff --stat HEAD~4 -- .specs/` shows no change in the root `.specs/` (S9).
- [x] `.specs/kit/tools/costs_ledger.ps1 -Root hack_star_godot -CostsLink ../../.specs/kit/COSTS.md`
      lists all 18 specs (S12); the README list matches the files (S11).
- [x] `hack_star_godot/README.md`: a short section *Specs* pointing to the ordered list.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-21 15:32

**Done (2026-11-21 · ~3m · Claude Haiku 5.5)** — check script over the 16 moved files (name and original date, D2 header, Stage log first row, first statement S0, only the Part 2 placeholder below the marker, no `### Notes`, `**Done (`, `## Cost summary`, every relative link resolves, every struck statement followed by a reason): all PASS, no fix needed. Root `.specs/`: `git diff --stat c2ff04c -- .specs/` empty, `git status --short .specs` empty. `costs_ledger.ps1` lists 18 specs (01 closed, 02, 03–18); README list: 18 rows, links resolve, statuses 01 closed, 02 planned, 03–18 requirements. `hack_star_godot/README.md`: the existing *Specs* section (linked from the layout table) got the pointer to `.specs/features/README.md`, the work-through order and the `hack_star_godot/.specs/` rule. suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · 946 k (85 k in · 839 k cached · 22 k out) · CHF 0.03 (3 credits)

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Create GitHub issues for the moved specs | Not needed to move them (S17); each gets its issue when it is planned | each moved spec, at `CREATE ISSUE:` |
| Run S0 of each moved spec | It belongs to that spec, before its plan | 03 … 18 |
| Re-point 18's *Moved from* link from the blob on `feature/worlds-and-world-coins` to `main` (review finding #7) | The branch is not merged yet; the link breaks when it is merged and deleted | when `feature/worlds-and-world-coins` is merged or deleted |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-21 | AI assistant (Claude Opus 5.5) | semantic diff (specs and documents only: summary and highlights, no change record, no PR text — S17) | [review page](../../review/2026-11-21_main-move-specs-to-godot.html) | — |
| 2026-11-21 | AI assistant (Claude Opus 5.5) | diff `c2ff04c..5cccaae` (16 moved specs, ordered list, README, costs) | Approve | 0 blocking · 3 should-fix · 5 nit |
| 2026-11-21 | AI assistant (Claude Sonnet 5.5) | review fixes | fixed | #1–#6, #8 |

### Code review 2026-11-21

Range `c2ff04c..5cccaae` on `main` (Steps 1–5). All 16 moved specs pass the structural checks
(re-run by script: name, D2 header, S0 wording of D4 with the right range and the bug sentence
in 16, numbering, placeholder, links); Part 1 of every spec was diffed against its original (18
against the branch copy) — only the documented changes differ; root `.specs/` unchanged (S9).

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | Definition of Done: the *Implementation* line is not ticked although Steps 1–5 are ✅ Done and Step 5's checks passed | spec | spec | Should-fix | fix now — fixed 2026-11-21 |
| 2 | `features/README.md`: row 02 says *planned* although all Steps are done (should be *implemented*, S11) | spec | docs | Should-fix | fix now — fixed 2026-11-21 |
| 3 | 17 Q1 (music tools in Godot) does not name the statements its answer changes: S24/S25 (developer mode "in this browser", page by address `/?dev`) and S26/S27 (candidate files in the project, list in the repository — already in conflict with S36, inherited from the original S32) | spec | spec | Should-fix | fix now — fixed 2026-11-21 |
| 4 | Context/feature-list text still names the Python server unmarked: 03 F0 ("server, UI") next to "No server."; 14 Context ("the Python server must connect the devices"); 15 Context (`GET /api/hacks`); 05 has no pointer to 03's question "Server for rooms and hack codes" | spec | docs | Nit | fix now — fixed 2026-11-21 |
| 5 | 17 S36 replaces "the repository credits of S20, S22 and S35", but the new S35 has no repository credits (should be S20, S22 or the struck S31) | spec | docs | Nit | fix now — fixed 2026-11-21 |
| 6 | 17: the answered note of the original Open questions (candidate tracks made by us or from CC0 / CC BY libraries) was dropped when Q1 was added | spec | docs | Nit | fix now — fixed 2026-11-21 |
| 7 | 18 *Moved from* links to the blob on `feature/worlds-and-world-coins`; it breaks when that branch is merged and deleted — point it to `main` then | spec | docs | Nit | deferred (see Deferred Items) |
| 8 | "(found by the requirements stage — reuse, don't rebuild)" kept in 03–15, "(reuse, don't rebuild)" in 16–18; one wording | scan | docs | Nit | fix now — fixed 2026-11-21 |

**Good:** identical S0 in all 16 specs; every struck statement names its successor and the
reason; the server question is asked once (03) and referenced (14 Q3); 03 S12–S14 and 04 S12
match D7/D8; no broken link; Step notes document every deviation.

**Outcome:** Approve (no Blocking finding open).

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S17 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked; all 16 specs moved and checked; root `.specs/` unchanged
- [x] Review · review page written in `hack_star_godot/.specs/review/`; no Blocking finding open
- [x] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · not applicable — worked on `main`, no pull request (S17)
