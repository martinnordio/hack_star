# Move Specs to Godot Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/move-specs-to-godot`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in [01](done/2026_11_21_01_godot_setup_and_first_game_spec.md) | included in [01](done/2026_11_21_01_godot_setup_and_first_game_spec.md) | Part 1 written, in the same run as spec 01 |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in [01](done/2026_11_21_01_godot_setup_and_first_game_spec.md) | included in [01](done/2026_11_21_01_godot_setup_and_first_game_spec.md) | Part 1 revised: the root kit is used, no Godot kit (Context, S12) |

---

# Part 1 · Requirements

## Context

The Godot game is built from the same requirements as the Python + Svelte game, instead of by
studying its code. Every finished spec of the root `.specs/features/done/` is copied into
`hack_star_godot/.specs/features/` with its requirements only (Part 1), numbered in the order
the features were built, so that the plan and implementation stages can then run on them one
after the other. It needs the folder, and the rule for Godot specs with the root kit, from
[2026_11_21_01_godot_setup_and_first_game_spec.md](done/2026_11_21_01_godot_setup_and_first_game_spec.md).

**Already in the repository:**
- 17 finished specs in [.specs/features/done/](../../../.specs/features/done/). Each has a
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
- The plan stage ([.specs/kit/plan/prompt.md](../../../.specs/kit/plan/prompt.md)) only
  plans a spec whose Part 1 has no open questions and whose Part 2 is the placeholder below
  the marker.

**New:**
- The finished game specs, requirements only, numbered, in `hack_star_godot/.specs/features/`.
- An ordered list of them, so the next spec to plan and implement is always clear.

## 1 · Specs

- **S1 — Which specs:** Every finished game spec of the root `.specs/features/done/` is
  moved — the 16 listed above (03–18). Specs about the kit or tools, and specs that are not
  finished, are not moved.
- **S2 — Order:** The specs are numbered in the order the features were built (the table
  above), so that each one only needs features of specs with a lower number. The two Godot
  specs of this folder are 01 and 02, and the moved specs continue with 03.
- **S3 — File name:** A moved spec is named `<original date>_<NN>_<original name>_spec.md`,
  with the two-digit order number right after the date (for example
  `2026_11_12_03_mvp_and_architecture_spec.md`); an older number in the name is replaced
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
- **S7 — Technology statements flagged:** A statement that names the Python + Svelte
  technology or tools (for example *MVP and Architecture* S4 and S5) is not silently
  changed: it is listed under **Open questions** with a suggestion for the Godot game, so the
  author decides it before the spec is planned.
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

### Open questions

- **Worlds and World Coins:** it is finished only on the branch
  `feature/worlds-and-world-coins` and not yet merged into `main`. Suggestion: move it (18)
  once that branch is merged; until then the move stops after 17.
- **Bug Fixes:** move it as its own spec (16) or fold its statements into the specs it
  fixes? Suggestion: move it as its own spec — the order already puts it after the features
  it fixes, and nothing is lost.
- **Numbering:** global numbers 01–18 (the two Godot specs first, as in S2), or 01–16 for the
  moved specs only? Suggestion: global, so one number gives the place of every spec in the
  Godot folder.
- **Overall game idea:** link to the root `.specs/overall_req.md` or copy it into
  `hack_star_godot/.specs/`? Suggestion: link to it — it is the author's own document and
  describes both games.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
