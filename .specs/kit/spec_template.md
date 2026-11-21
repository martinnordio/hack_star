# [Feature Name] Spec

> **Author:** [Your name]
> **Status:** ⬜ Requirements in progress
> **Created:** YYYY-MM-DD
> **Last updated:** YYYY-MM-DD
> **Branch:** `feature/…`

<!-- File name: .specs/features/yyyy_mm_dd_<name>_spec.md — the date the spec is created.
     The name never changes, also when the spec moves to .specs/features/done/.

     Linked to GitHub, the header also gets (requirements stage, CREATE ISSUE):
       > **Issue:** #<n>
       > **Parent:** #<n>   (optional: parent issue)

     One file, two parts:
       Part 1 · Requirements — written first by the requirements stage (what, not how).
       Part 2 · Plan         — added by the plan stage once Part 1 is agreed (how, in Steps).
     The marker line `<!-- spec-nx:plan -->` separates them; keep it. -->

## Stage log

<!-- Every stage that writes to this spec adds a row: which stage, which command, and which AI
     model did it — the model that ran that command, as the assistant's runtime reports it,
     never copied from earlier rows, the settings or the kit's README ("unknown model" if it
     cannot tell); write "person" for edits made by hand. If the last row has the same date,
     stage and model, update it instead of adding a new one. Rows are never removed.
     The Tokens and Cost columns are only there with cost tracking on (the `cost` block,
     COSTS.md of the kit): copied from the `usage` script, never computed by hand; `N/A` only
     after the script still fails with the right start time and log, with its error in the
     Note (COSTS.md, rule 3). Without cost tracking, drop both columns. -->

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| YYYY-MM-DD | requirements | `REQUIREMENTS:` | [model] | ~111 k (38 k in · 70 k cached · 3 k out) | ~CHF 0.22 (26 credits) | Part 1 written |

---

# Part 1 · Requirements

## Context

What this feature is about, in two or three sentences, and why it is needed.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [existing screen, module, endpoint or spec that this feature touches or extends]

**New:**
- [what does not exist yet]

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../README.md) | How to install, run, test and play |

## 1 · Specs

Clear, testable statements: each describes WHAT the game does, not HOW.

- **S1:** [Short requirement statement]
- **S2:** [Short requirement statement]
- **S3:** [Short requirement statement]

<details>
<summary>Example (a game feature)</summary>

- **S1 — Rename:** The player can rename a created fighter to a name of 1–12 characters.
- **S2 — Empty name:** An empty name is refused with a message, in every game language.
- **S3 — Kept:** The new name is kept after the page is reloaded and shows in a friend's room.
- **S4 — Unchanged:** Trophies, power and skins of the fighter stay as they were.

</details>

### Open questions

- [Question for the author before the plan is written]

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

<!-- The Model (suggested) column is only there with per-Step models (`models` in the settings,
     models.md): `<tier> (<model>) — <why>`, chosen by the plan stage. Without it, drop the column. -->

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **0** | [Setup / scaffolding] | [light (<model>) — why] | ⬜ Not started | [→ Step 0](#step-0--setup--scaffolding) |
| **1** | [Core implementation] | [standard (<model>) — why] | ⬜ Not started | [→ Step 1](#step-1--core-implementation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | [Choice made while planning] | [Reason] |

---

## Step 0 — [Setup / Scaffolding]

### Goal
[One sentence describing what this step achieves.]

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Task A
- [ ] Task B

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 1 — [Core Implementation]

### Goal
[One sentence describing what this step achieves.]

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Task A
- [ ] Task B

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

Tasks set aside for a future spec, so nothing is forgotten.

| Task | Reason | Target Spec |
|------|--------|------------------|
| _Example: Trade fighters between accounts_ | _Needs server-side accounts_ | _`yyyy_mm_dd_trading_spec.md`_ |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| _YYYY-MM-DD_ | _AI assistant (model) / person_ | _requirements / plan / diff_ | _Approve / Request changes_ | _notes_ |

---

## Definition of Done

- [ ] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [ ] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `uv run pytest`, `npm test`, `npm run check` and `npm run build` pass; README / `docs/architecture.md` updated where affected
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
