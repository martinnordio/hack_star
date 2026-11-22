# GitHub tools

Small PowerShell scripts that keep a spec's GitHub issue and pull request in sync with the
spec. They do not read the spec: the stage prompt (the AI assistant) builds the **summary**
from the spec and writes it to a file; the script puts that text into the description, between
the markers

```
[//]: # (spec-summary:start)

…

[//]: # (spec-summary:end)
```

The markers are Markdown comment lines: they are not shown. Blocks between the older markers
`<!-- spec-summary:start -->` … `<!-- spec-summary:end -->` (issues and pull requests written
by earlier kits, e.g. #17 and #18) are still found and replaced.

Text outside the markers (written by hand) is kept. Without markers, the block is added at the
end. Every script has `-DryRun`, which prints the new description and changes nothing.

`update_pr.ps1` also fills a second block, `[//]: # (semantic-diff:start)` …
`[//]: # (semantic-diff:end)`, when it gets `-SemanticDiffFile` (written by `REVIEW:`).
Without it, that block is left as it is.

| Script | Does |
|--------|------|
| `github/create_issue.ps1` | Creates an issue with the summary; optionally a sub-issue of a parent issue; prints its number |
| `github/update_issue.ps1` | Issue description |
| `github/update_pr.ps1` | Pull request of the current branch; creates it (draft allowed, `Closes #<issue>`) if there is none |
| `spec_summary.ps1` | Shared helper: puts a text between the markers |

**Needs:** the GitHub CLI `gh`, logged in (`gh auth status`). Credentials are never printed.
The scripts run in Windows PowerShell 5.1 and PowerShell 7.

## Examples

From the repository root:

```
.specs/kit/tools/github/update_issue.ps1 -Issue 12 -SummaryFile summary.md -DryRun
.specs/kit/tools/github/update_pr.ps1 -SummaryFile summary.md -Title "Created fighter studio (#12)" -Issue 12 -Draft -DryRun
.specs/kit/tools/github/update_pr.ps1 -SummaryFile summary.md -SemanticDiffFile semantic_diff.md -DryRun
```

## Tokens and cost

`usage.ps1` estimates (VS Code Copilot) or measures (Claude Code) the tokens of a
time range of the AI chat and prices them, by the method of `../COSTS.md`. It reads the
`cost` block of `.specs/spec-nx.json` (and `.local.json`); without it,
or with `enabled: false`, it prints that cost tracking is off and does nothing. It changes no
file.

| Parameter | Meaning |
|-----------|---------|
| `-Since` | Start of the range: the stage's or Step's start time (local time or ISO with `Z`) |
| `-Until` | End of the range (default: now) |
| `-Model` | The model that ran, as named in the tool's model list or in `cost.prices` (a Copilot CLI log names its models itself) |
| `-Transcript` | The chat log (default: of all logs of this project written since `-Since` — Copilot CLI sessions, VS Code Copilot chats of this workspace, Claude Code sessions — the one with the most requests in the range) |
| `-Root` | The project root (default: the current folder) |
| `-ContextCap` | Context size at which the chat is assumed to be summarized (default 200000) |
| `-Agent` | `all` (default), `main` (only the chat's own requests) or `subagents` (only its sub-agents') — Copilot CLI logs only; a `Split:` line always shows both parts |
| `-AgentName` | Only the requests of the sub-agents started under these display names (also nested ones) — Copilot CLI logs only; exact per-agent rows without time windows |
| `-Json` | One JSON line instead of the three text lines |

```
.specs/kit/tools/usage.ps1 -Since "2026-11-16 08:55" -Model "Claude Opus 5.5"
```

Output (`~` = estimated; measured numbers have none):

```
Tokens: ~1.34 M (18 k in · 1.31 M cached · 11 k out)
Cost: ~CHF 0.48 (57 credits, 3.0 % of Copilot Business)
Source: estimated from <transcript> · 17 requests · Claude Opus 5.5
```

With no request in the range it stops with an error that lists the logs it checked.

`costs_ledger.ps1` rebuilds `.specs/costs.md` — every spec in
`.specs/features/` and `done/` with its tokens and cost per stage, per Step and in total, and
the total of all specs — from the Tokens and Cost columns of the Stage logs; specs without
them show `N/A`. Run at `CLOSE:`; after a merge conflict in `.specs/costs.md`, run it again.
Parameters: `-Root`, `-CostsLink` (path from `.specs/` to COSTS.md; default from `kit_dir`),
`-DryRun` (print, write nothing).

```
.specs/kit/tools/costs_ledger.ps1 -DryRun
```

## The summary

Built by the stage prompt from the spec file, in this form:

```markdown
### <Spec title>

**Spec:** [<file name>](<link to the spec on the branch>) · **Status:** <Status from the header>

**Requirements**
- **S1 — <name>:** <first sentence of S1>
- **S2 — <name>:** <first sentence of S2>

## Cost summary
This feature used ~<tokens> tokens, ~<currency> <amount> — estimate, see [COSTS.md](<full URL of COSTS.md>).

| Stage | Models | Tokens | Cost (<currency>) | Share of <plan> |
|-------|--------|--------|-------------------|-----------------|
| requirements | <model> | ~… | ~… | … % |
| **Total** | | **~…** | **~…** | **… %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (<currency>) | Share of <plan> |
|------|-------|--------|-------------------|-----------------|
| Step 1 | <model> | ~… | ~… | … % |
| **Total implementation** | | **~…** | **~…** | **… %** |

**Plan**
| Step | Description | Status |
|------|-------------|--------|
| 0 | <description> | ✅ Done |
| 1 | <description> | ⬜ Not started |
```

- The link is a full URL to the spec, so it works from the issue and the pull request:
  `https://github.com/martinnordio/hack_star/blob/<branch>/<path>`. While the spec is open,
  link to the feature branch; once it is closed (in `.specs/features/done/`), link to `main` —
  the feature branch is deleted after the merge, `main` stays.
- While the spec has no plan yet (requirements stage), the **Plan** part is left out.
- **Cost summary:** only when the spec has one (written by `CLOSE:` with cost tracking on):
  its sentence and both tables (by stage, implementation by Step), copied as they are, before
  the **Plan** part. Make its links full URLs on `main`
  (`https://github.com/martinnordio/hack_star/blob/main/.specs/kit/COSTS.md`) — never local
  or editor links.
- Keep it short: one line per statement, no Notes or Decisions.
