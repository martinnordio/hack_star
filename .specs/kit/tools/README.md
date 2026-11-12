# Tools

Small PowerShell scripts that keep a GitHub issue and pull request in sync with a spec. They do
not read the spec: the stage prompt builds the **summary** from the spec and writes it to a
file; the script puts that text into the description, between the markers

```
<!-- spec-summary:start -->
…
<!-- spec-summary:end -->
```

Text outside the markers (written by hand) is kept. Without markers, the block is added at the
end. Every script has `-DryRun`, which prints the new description and changes nothing.

| Script | Does |
|--------|------|
| `github/update_issue.ps1` | Issue description |
| `github/update_pr.ps1` | Pull request of the current branch; creates it (draft allowed, `Closes #<issue>`) if there is none |
| `spec_summary.ps1` | Shared helper: puts a summary between the markers |

**Needs:** the GitHub CLI `gh`, logged in (`gh auth login`). The scripts run in Windows
PowerShell 5.1 and PowerShell 7.

## Examples

```
powershell -File .specs/kit/tools/github/update_issue.ps1 -Issue 12 -SummaryFile summary.md -DryRun
powershell -File .specs/kit/tools/github/update_pr.ps1 -SummaryFile summary.md -Title "Skins shop (#12)" -Issue 12 -Draft
```

## The summary

Built by the stage prompt from the spec file, in this form:

```markdown
### <Spec title>

**Spec:** [<file name>](<link to the spec>) · **Status:** <Status from the header>

**Requirements**
- **S1 — <name>:** <first sentence of S1>
- **S2 — <name>:** <first sentence of S2>

**Plan**
| Step | Description | Status |
|------|-------------|--------|
| 0 | <description> | ✅ Done |
| 1 | <description> | ⬜ Not started |
```

- The link is a full URL (`https://github.com/martinnordio/hack_star/blob/<branch>/<path>`):
  to the feature branch while the spec is open, to `main` once it is closed (in
  `.specs/features/done/`) — the feature branch is deleted after the merge.
- While the spec has no plan yet (requirements stage), the **Plan** part is left out.
