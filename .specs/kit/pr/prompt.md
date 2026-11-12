# Stage: Pull request

Prepare the **pull request** of a spec with a summary of the spec. Hack star has no git host
yet (`git_host` is `"none"` in `.specs/spec-nx.json`), so this stage builds the summary and
explains the manual steps; it does not run any git-host script.

## Command

```
PR: <spec file>
```
Run it again whenever the spec changes (Steps done, spec closed): only the `spec-summary`
block is rebuilt.

## Skills to load

None — this stage is mechanical: it summarises the spec.

## Files this stage uses

Paths are relative to this file (`.specs/kit/pr/`).

| File | Use |
|------|-----|
| `../tools/README.md` | The summary format |
| `.specs/spec-nx.json` | `git_host` |

---

## PR

1. **Check the branch.**
   - The current branch is the spec's **Branch** (header). If not, stop and say so.
   - No uncommitted changes (`git status`); otherwise ask the user to commit first.
   - The spec has Part 1 (statements) — a pull request needs at least the requirements.

2. **Check the git host.** Read `git_host` in `.specs/spec-nx.json`. While it is `"none"`:
   - if `git remote get-url origin` now points to GitHub or Azure DevOps, tell the user to set
     `git_host` in `.specs/spec-nx.json` and run `GENERATE KIT --update` to get the scripts;
   - otherwise go on with the manual steps below.

3. **Build the summary** in the format of `../tools/README.md`: title, the spec file path,
   status, the statements (one line each) and — if Part 2 has Steps — the Plan table with each
   Step's status. Put it between the markers `<!-- spec-summary:start -->` and
   `<!-- spec-summary:end -->`.

4. **Title.** The spec title.

5. **Show the user** the title and the summary, and the manual steps:
   1. Push the branch when a remote exists (`git push -u origin <branch>` the first time,
      `git push` after).
   2. Open the pull request on the host as a **draft** while the spec is not closed (not yet
      in `.specs/features/done/`), and paste the summary into its description.
   3. Later runs: replace only the text between the `spec-summary` markers.

   Without a remote, the summary is ready to paste once the repository is hosted; the branch
   can be merged locally by the user meanwhile.

## Never

- Merge, close, push or force-push.
- Change text outside the `spec-summary` block of a pull request.
- Put secrets, tokens, internal URLs or personal data into a summary.
