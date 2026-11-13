# Stage: Pull request

Push the branch and open or update its **pull request** on GitHub with a summary of the spec,
and update the spec's **issue** with the same summary, so the spec, the issue and the pull
request always say the same.

## Command

```
PR: <spec file>
```
Dry run first, then the real update after the user confirms. Run it again whenever the spec
changes (Steps done, spec closed): only the `spec-summary` blocks are rewritten.

## Skills to load

None — this stage is mechanical: it summarises the spec and runs the GitHub scripts.

## Files this stage uses

Paths are relative to this file (`.specs/kit/pr/`).

| File | Use |
|------|-----|
| `../tools/README.md` | The summary format and the scripts |
| `../tools/github/update_pr.ps1` | Open or update the pull request of the current branch |
| `../tools/github/update_issue.ps1` | Update the issue |
| `../guidelines/commits.md` | The issue reference every commit carries |
| `.specs/spec-nx.json` | `git_host` (`github`), `link_issues` (`true`) |

Needs the GitHub CLI `gh`, logged in (`gh auth status`).

---

## PR

1. **Check the branch.**
   - The current branch is the spec's **Branch** (header). If not, stop and say so.
   - Add a **Stage log** row to the spec: today, `pr`, `PR:`, the exact name of the AI model
     you are, `pull request opened` or `pull request updated` (add the section from the
     template above Part 1 if the spec has none).
   - No uncommitted changes (`git status`) apart from that row; otherwise ask the user to
     commit first. Ask the user to commit the row with the rest.
   - The spec has Part 1 (statements) — a pull request needs at least the requirements.
   - **Commit references:** `git log main..HEAD --oneline` — list the commits without the
     spec's `#<n>` and tell the user; never rewrite commits on your own.

2. **Build the summary** in the format of `../tools/README.md`: title, link to the spec
   (`https://github.com/martinnordio/hack_star/blob/<branch>/<path>` — the feature branch
   while the spec is open, `main` once it is in `.specs/features/done/`), status, the
   statements (one line each) and — if Part 2 has Steps — the Plan table with each Step's
   status. Write it to a temporary file outside the repository.

   **Semantic diff:** if the review stage wrote `semantic_diff.md` for this branch
   (`.specs/changes/<name>/` or `.specs/changes/done/<name>/`), pass it to the pull-request
   script too (`-SemanticDiffFile <file>`); it fills the pull request's `semantic-diff` block.
   The review page in `.specs/review/` must be committed so its link works.

3. **Title and issue.**
   - Title of a new pull request: the spec title and the issue (`<title> (#<n>)`).
   - Issue: from the spec header (`Issue:`). `link_issues` is `true`: if the header has none,
     ask for it (or offer `CREATE ISSUE`, requirements stage).
   - New pull requests are opened as a **draft** while the spec is not closed (not yet in
     `.specs/features/done/`).

4. **Dry run** — show the user both results:
   - `../tools/github/update_pr.ps1 -SummaryFile <file> [-SemanticDiffFile <file>] -Title <title> -Issue <n> [-Draft] -DryRun`
   - `../tools/github/update_issue.ps1 -Issue <n> -SummaryFile <file> -DryRun`

5. **After the user confirms:**
   1. Push the branch (`git push -u origin <branch>` the first time, `git push` after).
   2. Run the pull-request script without `-DryRun`.
   3. **Always** run the issue script without `-DryRun` too.
   4. Delete the temporary file and show the pull request link.

6. **Ready for review.** When the spec is closed and the user asks for it, run
   `gh pr ready`. The user reviews and merges — this stage never merges.

## Never

- Merge, close, or force-push.
- Change the spec, except its Stage log.
- Change text outside the `spec-summary` and `semantic-diff` blocks of the pull request, or
  outside the `spec-summary` block of the issue.
- Put secrets, tokens, internal URLs or personal data into a summary.
