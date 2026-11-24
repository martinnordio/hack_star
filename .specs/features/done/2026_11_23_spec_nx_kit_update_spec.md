# spec-nx Kit Update Spec

> **Status:** ✅ Complete
> **Created:** 2026-11-23
> **Last updated:** 2026-11-23
> **Branch:** `feature/better-graphics`

## Stage log

| Date | Stage | Command | Model | Tokens (see [COSTS.md](../../kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-23 | generator | `GENERATE KIT --update` | Claude Opus 5.5 | 3.42 M (68 k in · 3.33 M cached · 20 k out) | CHF 1.17 (140 credits) | kit generated |

## Cost summary

This feature used 3.42 M tokens, CHF 1.17 — measured, see [COSTS.md](../../kit/COSTS.md).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| generator | Claude Opus 5.5 | 3.42 M | CHF 1.17 (140 credits) | 7.4 % |
| **Total** | | **3.42 M** | **CHF 1.17 (140 credits)** | **7.4 %** |

---

# Part 1 · Requirements

## Context

The kit was regenerated from spec-nx `fe88876` (before: `1d72273`), which adds settings in
layers (`tools/settings.ps1`; a developer's `.specs/spec-nx.local.json` may change any
project key), an optional prompt log, the `-Run` marker of `usage` (only the chat that runs
the command is counted), `-AgentName` (one named sub-agent's requests), new issue fields
(`work_items.type`, `assigned_to`) and measured costs without `~`. No question was asked: every
key had a saved answer and spec-nx added no new question. The project is unchanged: Hack star,
on GitHub, edited on Windows with PowerShell, no company layer.

## 1 · Specs

- **S1 — Project:** existing.
- **S2 — Languages:** python, typescript, svelte, powershell.
- **S3 — Workflow:** requirements, plan, implementation, review, pr; no on-demand stages.
- **S4 — Git host:** GitHub, specs linked to issues.
- **S5 — Kit:** shared, in `.specs/kit` (`kit_ref` = `kit_dir`).
- **S6 — Shell:** PowerShell (developer setting); the kit has PowerShell scripts only.
- **S7 — Agent permissions:** Copilot (`.vscode/settings.json`), unchanged.
- **S8 — Models:** fixed — Claude Opus 5.5 for every stage and Step.
- **S9 — Cost tracking:** on (Copilot Business, CHF at 0.8384 per USD of 2026-11-13), unchanged.
- **S10 — Prompt log:** not asked and not written (off unless set by hand).

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Generate the kit | ✅ Done | [→ Step 1](#step-1--generate-the-kit) |

## Step 1 — Generate the kit

### Tasks
- [x] Settings: `spec_nx_version` `fe88876`, `generated` 2026-11-23, `model` Claude Opus 5.5;
      every other answer kept (`models`, `cost` unchanged).
- [x] Kit: each adapted file merged from spec-nx's changes `1d72273` → `fe88876` onto this
      project's kit (conflicts resolved keeping the GitHub / PowerShell wording; the kit's own
      later changes — Copilot CLI costs, orchestrator row, `-AgentName` — are now in spec-nx);
      `models.md` and the scripts copied unchanged; new `tools/settings.ps1`.
- [x] Checks: no conflict markers; no bash or Azure DevOps references; PowerShell scripts parse
      and are ASCII-only; `usage.ps1 -AgentName s09g-runner4` gives the same 74 credits as
      before; `costs_ledger.ps1 -Root hack_star_godot -DryRun` works with the Godot folder's
      cost-only settings.
- [x] Agent permissions: unchanged (`settings.ps1` only reads; not added to the auto-approve
      list without asking).

### Notes
Started: 2026-11-23 07:38

**Done (2026-11-23 · ~5m · Claude Opus 5.5 · 3.42 M · CHF 1.17)** — kit regenerated from
spec-nx `fe88876`: 9 kit files merged (README, COSTS, guidelines, requirements, plan,
implementation, review and pr prompts, tools README), `models.md` and 3 scripts (`usage`,
`costs_ledger`, `github/create_issue`) copied unchanged, 1 added (`settings.ps1`); checks pass.
