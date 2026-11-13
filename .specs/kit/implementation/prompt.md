# Stage: Implementation

Do the Steps of a planned Hack star spec **one at a time**, keeping the spec true while you
work, and **close** the spec when every Step is done.

## Commands

```
IMPLEMENT: <spec file> [Step <n>]
```
Does one Step: the one named, or the first Step that is not ✅ Done. Run it again for the next
Step.

```
CLOSE: <spec file>
```
Checks that the work is complete, writes what was built, and moves the spec to
`.specs/features/done/`.

## Skills to load

Always: `../skills/developer.md` — the role you take in this stage.

## Files this stage uses

Paths are relative to this file (`.specs/kit/implementation/`).

| File | Use |
|------|-----|
| `../skills/developer.md` | Your role while implementing |
| `../guidelines/<language>.md` | Baseline rules: `python.md` (server), `typescript.md` and `svelte.md` (UI), `powershell.md` |
| `../guidelines/commits.md` | Commit messages with the issue reference `#<n>` |
| `.specs/guidelines/<language>.md` | The project's own rules, if they exist; they win over the baseline |
| `docs/architecture.md` | Where things are: server, screens, game rules, 3D models, rooms |
| `../spec_template.md` | The Step completion protocol and the Definition of Done |
| `.specs/spec-nx.json` | `stages` (which Definition of Done lines apply) |

Checks of the project: `cd server; uv run pytest` and `cd ui; npm test; npm run check`
(`npm run build` before closing); for screens, a look in the browser at phone, iPad and
desktop size (`cd ui; npm run dev`, server `cd server; uv run hack-star-server`).

---

## IMPLEMENT

1. **Pick the Step.** The one named, or the first Step not ✅ Done in **2 · Spec Overview**.
   Stop and say so if:
   - Part 2 has no Steps (run `PLAN:` first);
   - an earlier Step is not done and the user did not name this Step on purpose;
   - the Step's tasks are unclear — ask; never guess.

2. **Check the branch.** The current branch is the spec's **Branch** (header). If you are on
   `main` and the feature branch does not exist yet, offer to create it
   (`git checkout -b <branch>`); otherwise stop and say so.

3. **Start.** Tick the first task and write `Started: YYYY-MM-DD HH:MM` (the real clock time)
   in the Step's **Notes**. Set the Step's row to `🔄 In progress` and the header **Status** to
   `🔄 In progress`.

4. **Read before writing.** The Step's goal and the statements it names; the code it touches;
   the guidelines of the languages it touches (`.specs/guidelines/<language>.md` first, then
   `../guidelines/<language>.md`); `docs/architecture.md`.

5. **Do the tasks, in order.** The smallest change that does the task. After each task, run
   the checks that apply and tick the task only when they pass. Every new player-visible text
   goes into all five dictionaries in `ui/src/lib/i18n/`. Work outside the Step goes into
   **Deferred Items**, not into the code.

6. **Check the Step.** Run the check named in its last task. If it fails, fix it within the
   Step, or stop and tell the user why — the Step stays `🔄 In progress`.

7. **Finish, in one edit** (the template's *Step completion protocol*):
   - all tasks ticked; the Step's row `✅ Done`;
   - a Done line in its Notes: `**Done (YYYY-MM-DD · ~<duration> · <model>)** — <summary>.
     <check and its result>`, with the exact name of the AI model you are;
   - **Last updated** today; a **Stage log** row: today, `implementation`, `IMPLEMENT:`, your
     model, `Step <n> done`.

8. **Report and suggest the commit.** What changed (files), the check result, anything
   deferred, and a commit message:

   ```
   Step <n>: <Step description> (#<issue>)
   ```

   If the spec has no issue yet, say so and offer `CREATE ISSUE:` (requirements stage) before
   the first commit. The user commits. Then the next step: `IMPLEMENT: <spec file>` for the
   next Step, or `CLOSE: <spec file>` when all Steps are done.

## CLOSE

1. **Check that the spec can be closed.** Every Step is ✅ Done or `🔜 Deferred` (its open
   tasks moved to **Deferred Items**). Otherwise stop and list what is open.

2. **Write what was built.** Directly under `# Part 2 · Plan`, add:

   ```
   ## Closing summary

   **Built:** <one paragraph: what the feature does now>
   **Differs from the plan:** <what changed while implementing, and why — or "nothing">
   **Files:** <main files created or changed>
   ```

   Do not delete Steps, Notes or decisions — the history stays.

3. **Requirements discovered while implementing** go into Part 1 as new statements at the end
   (numbers stay stable), each marked `(added while implementing)`.

4. **Definition of Done.** Tick the lines that are true; leave the pull-request line for the
   pr stage. Never tick a line that is not true — report it instead.

5. **Deferred items.** For each one whose target spec does not exist, offer
   `REQUIREMENTS: <name> — <deferred task>`.

6. **Move the spec.**
   - Header: **Status** `✅ Complete — closed on <branch>`; **Last updated** today.
   - A **Stage log** row: today, `implementation`, `CLOSE:`, your model, `spec closed`.
   - `git mv` the spec to `.specs/features/done/` (the name stays the same).
   - Relative links in the spec are one level deeper now: change `../` to `../../` and check
     that every link resolves. Fix links **to** the spec from other files (`SPEC-NX.md`,
     `.specs/overall_req.md` is the user's — only report links there).
   - If the review stage wrote `.specs/changes/<name>/`, `git mv` it to
     `.specs/changes/done/<name>/` and fix the links (the review pages in `.specs/review/` stay
     where they are).

7. **Report** and suggest the commit `Close the spec (#<issue>)`. Next: `REVIEW:` if not run
   yet, then `PR: <spec file>` — the closed spec ships in the same pull request.

## Never

- Work on more than one Step per `IMPLEMENT:`, or start the next Step on your own.
- Change Part 1 while implementing (only `CLOSE` adds discovered statements); if Part 1 is
  wrong, stop and suggest `REQUIREMENTS: <spec file> — …`.
- Tick a task whose check fails, or write a Done line for a Step that is not done.
- Commit, push or merge — the user does that.
