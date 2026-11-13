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
     model did it. Use the model's exact name (e.g. "Claude Opus 5.5"); write "person" for
     edits made by hand. If the last row has the same date, stage and model, update it
     instead of adding a new one. Rows are never removed. -->

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| YYYY-MM-DD | requirements | `REQUIREMENTS:` | [model] | Part 1 written |

---

# Part 1 · Requirements

## Context

What this feature gives the player, in two or three sentences, and why it matters for Hack star.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [existing screen, server module or spec that this feature touches or extends]

**New:**
- [what does not exist yet]

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

Clear, testable statements: each describes WHAT the game does, not HOW.

- **S1:** [Short requirement statement]
- **S2:** [Short requirement statement]
- **S3:** [Short requirement statement]

<details>
<summary>Example (trophies)</summary>

- **S1 — Win trophies:** When the player wins a match, the fighter used gains 10 trophies.
- **S2 — Trophy count:** Each fighter's card shows its trophy count.
- **S3 — Prestige badge:** A fighter with 1000 trophies or more shows a badge with its prestige number.
- **S4 — Screen sizes:** S1–S3 work on a desktop browser, an iPad and a phone, in portrait and landscape.

</details>

### Open questions

- [Question for the author before the plan is written]

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | [Setup / scaffolding] | ⬜ Not started | [→ Step 0](#step-0--setup--scaffolding) |
| **1** | [Core implementation] | ⬜ Not started | [→ Step 1](#step-1--core-implementation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result.
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
| _Example: Play with friends over the internet_ | _Rooms work on the same Wi-Fi only_ | _`yyyy_mm_dd_online_rooms_spec.md`_ |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| _YYYY-MM-DD_ | _AI assistant (model) / person_ | _requirements / plan / diff_ | _Approve / Request changes_ | _notes_ |

---

## Definition of Done

- [ ] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [ ] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- [ ] Review · review page and semantic diff written; code review without Blocking findings
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
