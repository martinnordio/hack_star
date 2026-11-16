# Model Comparison Experiment Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-16
> **Last updated:** 2026-11-16
> **Branch:** `main` (the three experiment branches are listed in D1)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~789 k | ~CHF 0.22 (26 credits) | Part 1 and Part 2 written; branches set up |

---

# Part 1 · Requirements

## Context

The [worlds and world coins spec](2026_11_16_worlds_and_world_coins_spec.md) (#24) is a large
feature with a finished plan. We use it to compare how the AI model choice changes cost and
result: the same spec and plan are implemented three times, each on its own branch with a
different `models` setting, and one branch is kept. The other two are not merged, but their
specs are kept so their costs can be counted and compared.

**Already in the repository:**
- `.specs/spec-nx.json` — `models` (today fixed Claude Opus 5.5) and the `cost` block (on).
- `.specs/kit/models.md`, `.specs/kit/COSTS.md`, `.specs/kit/tools/usage.ps1`,
  `.specs/kit/tools/costs_ledger.ps1` — model check per stage, tokens and cost per Stage log
  row and Done line, `.specs/costs.md`.

**New:**
- Three branches with the same spec and plan and different models; a comparison and a choice.

## 1 · Specs

- **S1 — Same start:** All three branches start from the same commit of `main`, with the same
  worlds spec, the same Part 1 and the same Steps.
- **S2 — One difference:** The branches differ only in `models` in `.specs/spec-nx.json`
  (and, on the per-Step branch, the Model column the plan needs).
- **S3 — Same way of working:** Each branch is implemented with the kit's commands
  (`IMPLEMENT:` Step by Step, `REVIEW:`, `CLOSE:`), in its own chat session, by the same
  person, with the same checks.
- **S4 — Costs counted:** Every Stage log row and Done line of each branch has its tokens and
  cost from `usage.ps1`; nothing is computed by hand.
- **S5 — Compared:** For each branch the comparison records: total tokens and cost, time, the
  number of Steps that needed a fix or a second try, test results (`pytest`, `npm test`,
  `npm run check`, `npm run build`), review findings by severity, and a short judgement of
  the result in the browser (looks of the worlds, bots in Large worlds).
- **S6 — Choice:** One branch is chosen with a written reason; only it is merged into `main`
  and closes #24.
- **S7 — Kept for counting:** The worlds spec of the two other branches (with their Stage logs
  and Done lines) is copied to `.specs/experiments/model-comparison/` before their branches
  are deleted, so their costs stay in the repository; they are not counted again as features.

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Set up the three branches | ✅ Done | [→ Step 1](#step-1--set-up-the-three-branches) |
| **2** | Run the Opus branch | ✅ Done | [→ Step 2](#step-2--run-the-opus-branch) |
| **3** | Run the Haiku branch | ⬜ Not started | [→ Step 3](#step-3--run-the-haiku-branch) |
| **4** | Run the per-Step branch | ⬜ Not started | [→ Step 4](#step-4--run-the-per-step-branch) |
| **5** | Compare, choose and keep the specs | ⬜ Not started | [→ Step 5](#step-5--compare-choose-and-keep-the-specs) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Branches: `feature/worlds-and-world-coins-opus` — `models: { "fixed": "Claude Opus 5.5" }`; `feature/worlds-and-world-coins-haiku` — `models: { "fixed": "Claude Haiku 5.5" }`; `feature/worlds-and-world-coins` — per Step: reasoning Claude Opus 5.5, standard Claude Sonnet 5.5, light Claude Haiku 5.5. | Two extremes and spec-nx's own mapping (S2). |
| D2 | The per-Step branch adds only the **Model (suggested)** column to the worlds spec's overview: Steps 1, 2, 3 and 6 reasoning (layout generator, migration and merge, graphics, room protocol); Steps 4, 5 and 7 standard; Step 8 light. | The plan stage would write it for per-Step models; the Steps themselves stay identical (S1). |
| D3 | Each branch runs in a new chat session, with the model selected in the picker before every command (`models.md` asks when it differs). | `usage.ps1` reads one transcript; separate sessions keep the costs apart (S4). |
| D4 | The kept copies go to `.specs/experiments/model-comparison/<branch>_spec.md`, outside `.specs/features/`. | `costs_ledger.ps1` counts only `features/` and `done/`, so the feature is counted once; the copies keep the other two costs (S7). |
| D5 | Order: Opus, Haiku, per-Step; each branch finishes `CLOSE:` before the next starts. The chosen branch then runs `PR:`. | Same person, no mixing of sessions; only one pull request (S3, S6). |

---

## Step 1 — Set up the three branches

### Tasks
- [x] Commit the worlds spec (Part 1, plan, issue #24) and this spec on `main`.
- [x] Create the three branches from that commit and set `models` on each (D1); add the Model
      column on the per-Step branch (D2); one commit per branch.

### Notes
Started: 2026-11-16 18:26

---

## Step 2 — Run the Opus branch

### Tasks
- [x] `git switch feature/worlds-and-world-coins-opus`; new chat; model Claude Opus 5.5.
- [x] `Load .specs/kit/implementation/prompt.md` → `IMPLEMENT: .specs/features/2026_11_16_worlds_and_world_coins_spec.md`
      Step by Step until Step 8; then `REVIEW:` and `CLOSE:`.
- [x] Record the branch's totals in the Results table below.

### Notes

**Done (2026-11-16 · ~1h 35m · Claude Opus 5.5)** — run on its own copy, [2026_11_16_worlds_and_world_coins_opus_spec.md](2026_11_16_worlds_and_world_coins_opus_spec.md) (copied here from the branch, where it is closed in `done/`); eight Step commits plus "Review and close the spec" on `feature/worlds-and-world-coins-opus`, not pushed.

---

## Step 3 — Run the Haiku branch

### Tasks
- [ ] `git switch feature/worlds-and-world-coins-haiku`; new chat; model Claude Haiku 5.5.
- [ ] The same commands as Step 2.
- [ ] Record the branch's totals in the Results table below.

### Notes

---

## Step 4 — Run the per-Step branch

### Tasks
- [ ] `git switch feature/worlds-and-world-coins`; new chat; switch the model per Step as the
      spec's Model column says (`IMPLEMENT:` asks).
- [ ] The same commands as Step 2.
- [ ] Record the branch's totals in the Results table below.

### Notes

---

## Step 5 — Compare, choose and keep the specs

### Tasks
- [ ] Fill the Results table (S5) and write the choice with its reason (S6).
- [ ] On `main`: copy the worlds spec of the two other branches to
      `.specs/experiments/model-comparison/` (D4), with this spec's results; commit.
- [ ] `PR:` on the chosen branch; after the merge delete all three branches.

### Results

| Branch | Models | Tokens | Cost (CHF) | Time | Fixes / retries | Tests | Review findings | In the browser |
|--------|--------|--------|------------|------|-----------------|-------|-----------------|----------------|
| `…-opus` | fixed Opus 5.5 | ~25.30 M (Steps, review, close) | ~CHF 7.39 (882 credits) | ~1h 35m | 3 (Step 1 map generator reworked, Step 5 world screen rewritten after an encoding slip, Step 7 Swiss German dates) | pytest 64, npm test 488, check 0, build ok | 0 blocking, 2 should-fix, 2 nits | every Step checked; Large world 60 fps at 820 × 1180 |
| `…-haiku` | fixed Haiku 5.5 | | | | | | | |
| `feature/worlds-and-world-coins` | per Step | | | | | | | |

**Choice:** _…, because …_

### Notes

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S7 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- [ ] Spec closed · moved to `.specs/features/done/`
