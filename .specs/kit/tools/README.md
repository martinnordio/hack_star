# GitHub tools

Small PowerShell scripts that keep a spec's GitHub issue and pull request in sync with the
spec. They do not read the spec: the stage prompt (the AI assistant) builds the **summary**
from the spec and writes it to a file; the script puts that text into the description, between
the markers

```
<!-- spec-summary:start -->
…
<!-- spec-summary:end -->
```

Text outside the markers (written by hand) is kept. Without markers, the block is added at the
end. Every script has `-DryRun`, which prints the new description and changes nothing.

`update_pr.ps1` also fills a second block, `<!-- semantic-diff:start -->` …
`<!-- semantic-diff:end -->`, when it gets `-SemanticDiffFile`. Hack star's kit has no review
stage, so that block is normally left as it is.

| Script | Does |
|--------|------|
| `github/create_issue.ps1` | Creates an issue with the summary; optionally a sub-issue of a parent issue; prints its number |
| `github/update_issue.ps1` | Issue description |
| `github/update_pr.ps1` | Pull request of the current branch; creates it (draft allowed, `Closes #<issue>`) if there is none |
| `spec_summary.ps1` | Shared helper: replaces a marked block in a description |

**Needs:** the GitHub CLI `gh`, logged in (`gh auth status`). The scripts run in Windows
PowerShell 5.1 and PowerShell 7 and never print credentials.

## Examples

```
.specs/kit/tools/github/create_issue.ps1 -Title "Online rooms" -SummaryFile summary.md -DryRun
.specs/kit/tools/github/update_issue.ps1 -Issue 12 -SummaryFile summary.md -DryRun
.specs/kit/tools/github/update_pr.ps1 -SummaryFile summary.md -Title "Online rooms (#12)" -Issue 12 -Draft
```

## The summary

Built by the stage prompt from the spec file, in this form:

```markdown
### <Spec title>

**Spec:** [<file name>](<link to the spec on the branch>) · **Status:** <Status from the header>

**Requirements**
- **S1 — <name>:** <first sentence of S1>
- **S2 — <name>:** <first sentence of S2>

**Plan**
| Step | Description | Status |
|------|-------------|--------|
| 0 | <description> | ✅ Done |
| 1 | <description> | ⬜ Not started |
```

- The link is a full URL to the spec, so it works from the issue and the pull request:
  `https://github.com/martinnordio/hack_star/blob/<branch>/<path>`. While the spec is open,
  link to the feature branch; once it is closed (in `.specs/features/done/`), link to `main` —
  the feature branch is deleted after the merge.
- While the spec has no plan yet (requirements stage), the **Plan** part is left out.
