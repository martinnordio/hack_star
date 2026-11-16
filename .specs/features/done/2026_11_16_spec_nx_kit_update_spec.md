# spec-nx Kit Update Spec

> **Status:** ✅ Complete
> **Created:** 2026-11-16
> **Last updated:** 2026-11-16
> **Branch:** `main`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | generator | `GENERATE KIT --update --force` | Claude Opus 5.5 | ~2.40 M | ~CHF 0.75 (90 credits) | kit generated |

## Cost summary

This feature used ~2.40 M tokens, ~CHF 0.75 — estimate, see [COSTS.md](../../kit/COSTS.md).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| generator | Claude Opus 5.5 | ~2.40 M | ~CHF 0.75 (90 credits) | 4.7 % |
| **Total** | | **~2.40 M** | **~CHF 0.75 (90 credits)** | **4.7 %** |

---

# Part 1 · Requirements

## Context

The kit was regenerated from spec-nx **v0.4.0** (`1d72273`; before: `ec52844`, 29 commits),
which adds a model per stage and Step (`models.md`) and token and cost tracking (`COSTS.md`,
`tools/usage.ps1`, `tools/costs_ledger.ps1`). With `--force` every question was asked again;
all saved answers were confirmed. The scan found the same project: an existing Python / FastAPI
server in `server/` and a Svelte 5 / TypeScript UI in `ui/`, on GitHub, edited in VS Code
Copilot on Windows, with no company layer.

## 1 · Specs

- **S1 — Project:** existing (from the scan).
- **S2 — Languages:** python, typescript, svelte, powershell.
- **S3 — Workflow:** requirements, plan, implementation, review, pr; no on-demand stages.
- **S4 — Git host:** GitHub, specs linked to issues.
- **S5 — Kit:** shared, in `.specs/kit`.
- **S6 — Shell:** PowerShell (developer setting); the kit has PowerShell scripts only.
- **S7 — Agent permissions:** VS Code Copilot.
- **S8 — Models:** fixed — Claude Opus 5.5 for every stage and Step.
- **S9 — Cost tracking:** on (Copilot Business, CHF at 0.8384 per USD of 2026-11-13).

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
- [x] Settings: `spec_nx_version` `1d72273`, `generated` 2026-11-16, `model` Claude Opus 5.5;
      every other answer kept (`models`, `cost` unchanged).
- [x] Kit: each file merged from spec-nx's changes `ec52844` → `1d72273` onto this project's
      adapted kit (conflicts resolved keeping the GitHub / PowerShell wording); new
      `models.md`, `COSTS.md`, `tools/usage.ps1`, `tools/costs_ledger.ps1`; scripts copied
      unchanged.
- [x] Checks: no conflict markers; every `../` path in the prompts exists; PowerShell scripts
      parse and are ASCII-only.
- [x] Agent permissions: `.vscode/settings.json` gains two entries — `usage.ps1` (reads only)
      and `costs_ledger.ps1 -DryRun` run without asking.

### Notes
Started: 2026-11-16 15:44

**Done (2026-11-16 · ~10m · Claude Opus 5.5 · ~2.40 M · ~CHF 0.75)** — kit regenerated from
spec-nx v0.4.0: 8 kit files updated (README, spec template, requirements, plan,
implementation, review and pr prompts, tools README), 4 added; checks pass.
