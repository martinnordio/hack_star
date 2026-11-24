# Stage: Implementation

Do the Steps of a planned spec **one at a time**, keeping the spec true while you work, and
**close** the spec when every Step is done.

## Commands

```
IMPLEMENT: <spec file> [Step <n>]
```
Does one Step: the one named, or the first Step that is not ✅ Done. Run it again for the next
Step. With per-Step models (`../models.md`) it can run the remaining Steps one after the
other, each on its own model, after one confirmation (*Per-Step run* below).

```
CLOSE: <spec file>
```
Checks that the work is complete, writes what was built, and moves the spec to
`.specs/features/done/`.

## Skills to load

Always: `../skills/developer.md` — the role you take in this stage.

## Settings

Read the settings in their three layers (the kit's README, section *Settings*): the kit's,
the project's `.specs/spec-nx.json` and the developer's `.specs/spec-nx.local.json`, the later
winning. If the settings list `stages` and this stage is neither in it nor in `on_demand`,
answer *"The <stage> stage is turned off in <file>."* and do nothing else. In your report,
name each setting you used that does not come from the kit, with its file (for example
*parent 150310 — from `.specs/spec-nx.local.json`*).
With `prompt_log` on, add the prompt you were given to the prompt log at the start and its reply
summary at the end (the kit's README, section *Prompt log*).

## Model name

**Check the model first** (`../models.md`): with `models` set in the settings, run on the
configured model, as a sub-agent or after asking; with no `models`, use the tool's model.

**Tokens and cost** (`../COSTS.md`): only with the `cost` block on. Note the start time and write the
marker `spec-nx run <yyyymmdd-hhmm>-<4 random letters>` into the chat; at the end run
`../tools/usage.ps1` with the time, your model and `-Run <id>` (the part after
`spec-nx run`), so only this chat is counted, and copy its Tokens and Cost into your Stage log
row — never compute them yourself.

Wherever this prompt says *your model*, write the name of the model that runs this command
now, as your runtime reports it. Never copy it from earlier rows, from `.specs/spec-nx.json`
(its `model` is the model that generated the kit), from the kit's README or from examples. If
you cannot tell, ask the user once; otherwise write `unknown model`.

## Files this stage uses

Paths are relative to this file (`.specs/kit/implementation/`).

| File | Use |
|------|-----|
| `../skills/developer.md` | Your role while implementing |
| `../guidelines/<language>.md` | Baseline rules: `python.md`, `typescript.md`, `svelte.md`, `powershell.md` |
| `../guidelines/commits.md` | How commit messages are written, with the issue reference |
| `.specs/guidelines/<language>.md` | The project's own rules, if they exist; they win over the baseline |
| `docs/architecture.md` | Where things live in the server and the UI |
| `../spec_template.md` | The Step completion protocol and the Definition of Done |

## Checks

| Part | Command | When |
|------|---------|------|
| Server | `cd server; uv run pytest` (`uv run --no-sync pytest` while the server is running on Windows) | Python changed |
| UI tests | `cd ui; npm test` | TypeScript or Svelte changed |
| UI types | `cd ui; npm run check` | TypeScript or Svelte changed |
| UI bundle | `cd ui; npm run build` | Last Step, or imports / assets changed |
| Scripts | parse with `[System.Management.Automation.Language.Parser]::ParseFile` | PowerShell changed |

---

## IMPLEMENT

1. **Pick the Step.** The one named, or the first Step not ✅ Done in **2 · Spec Overview**.
   Stop and say so if:
   - Part 2 has no Steps (run the plan stage first);
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
   `../guidelines/<language>.md`); the matching section of `docs/architecture.md`.

5. **Do the tasks, in order.** The smallest change that does the task. After each task, run
   the checks above that apply, and tick the task only when they pass. Work outside the Step
   goes into **Deferred Items**, not into the code.

6. **Check the Step.** Run the check named in its last task. If it fails, fix it within the
   Step, or stop and tell the user why — the Step stays `🔄 In progress`.

7. **Finish, in one edit** (the template's *Step completion protocol*):
   - all tasks ticked; the Step's row `✅ Done`;
   - a Done line in its Notes: `**Done (YYYY-MM-DD · ~<duration> · <model>)** — <summary>.
     <check and its result>`, where `<model>` is your model;
   - a **Model (suggested)** line: `suggested: <tier> (<model>) · ran: <your model>` at the
     end of the Done line, when `models` is set (`../models.md`);
   - with cost tracking on (`../COSTS.md`): run `usage` from the `Started:` time and end the
     Done line with `· ~<tokens> · ~<currency> <amount>`; the Stage log row gets the same
     numbers in its Tokens and Cost columns;
   - **Last updated** today; a **Stage log** row: today, `implementation`, `IMPLEMENT:`, your
     model, `Step <n> done`.

8. **Report and suggest the commit.** What changed (files), the check results, anything
   deferred, and a commit message:

   ```
   Step <n>: <Step description> (#<issue>)
   ```

   following `../guidelines/commits.md`. If the spec has no issue yet, say so and offer
   `CREATE ISSUE:` (requirements stage) before the first commit. The user commits. Then the
   next step: `IMPLEMENT: <spec file>` for the next Step, or, when all Steps are done,
   `REVIEW: <spec file>` and then `CLOSE: <spec file>`.

## Per-Step run

Only with per-Step models (`models` has tiers). Fixed or no `models`: one Step per
`IMPLEMENT:` as above.

1. **Ask once**, before any work: *"Run Steps <n>–<m> with their models (<n>: <model>, …,
   <m>: <model>), committing each Step with its suggested message? — yes / only Step <n> /
   no"*. Nothing is pushed in any case.
2. **Yes:** for each Step in order, run *IMPLEMENT* steps 3–7 as a **sub-agent on the Step's
   model** (`../models.md`), give it the spec file, the Step number and this prompt; when it
   returns, check its Done line and commit with the suggested message. Stop at the first
   failing check, an open question, or a missing model, and report. Ask nothing else in
   between.
   - If the agent's permissions deny `git commit` (`.claude/settings.json`, the user's
     answer), or the tool has no sub-agents with a model choice, do **only Step <n>** and say
     why.
   - With cost tracking on, after the last Step add one **Stage log** row for this
     orchestrating chat: `implementation`, `IMPLEMENT:`, your model, `orchestrator of the
     per-Step run (Steps <n>–<m>)`, with the numbers of `usage` `-Agent main` over the whole
     run; each Step's row uses `-Agent subagents` over its sub-agent's time (`../COSTS.md`).
3. **Only Step <n>:** that Step on its model (as a sub-agent where possible), then stop; the
   user commits.
4. **No:** stop.
5. **Tools without sub-agents:** at the end of each Step, name the next Step's model:
   *"Step <m> is set to <model> — switch before `IMPLEMENT:`."*

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

   **Cost summary** (only with cost tracking on, `../COSTS.md`): first add this command's own
   Stage log row with its `usage` numbers, then write, directly above `# Part 1 ·
   Requirements`:

   ```
   ## Cost summary

   This feature used ~<tokens> tokens, ~<currency> <amount> — estimate, see [COSTS.md](<link>).

   | Stage | Models | Tokens | Cost (<currency>) | Share of <plan> |
   |-------|--------|--------|-------------------|-----------------|
   | requirements | <model> | … | … | … % |
   | plan | <model> | … | … | … % |
   | implementation | <model>, <model> | … | … | … % |
   | review | <model> | … | … | … % |
   | pr | <model> | … | … | … % |
   | **Total** | | **…** | **…** | **… %** |

   **Implementation by Step**

   | Step | Model | Tokens | Cost (<currency>) | Share of <plan> |
   |------|-------|--------|-------------------|-----------------|
   | Step 1 | <model> | … | … | … % |
   | … | | | | |
   | CLOSE | <model> | … | … | … % |
   | **Total implementation** | | **…** | **…** | **… %** |
   ```

   The numbers are the sums of the Stage log rows per stage (`CREATE ISSUE:` / `UPDATE
   ISSUE:` under requirements, `CLOSE:` under implementation, `CODE REVIEW:` under review;
   leave out the rows of stages that have no Stage log row yet — such as `pr`, which runs after
   `CLOSE:` — and put any other stage, such as documentation, in its own row). Cost cells are
   written as in the Stage log: `~<currency> <amount> (<credits> credits)` — the `~` only when a
   row added up is estimated; all measured, no `~` (also in the sentence above the table). When
   a table mixes measured and estimated rows, add under it: *Mixes measured and estimated (`~`)
   numbers — see COSTS.md.* A row whose cells say `included in <spec>` is counted there, not
   here; a stage with only such rows reads `included in <spec>`. **Models** lists the
   models of the stage's Stage log rows (each once, in order); a Step's **Model** is the model
   in its Stage log row — the model that ran it. The second table splits implementation into its Steps and
   `CLOSE:`; its total equals the implementation row. The share is credits ÷
   `monthly_credits`. A row without numbers reads `N/A`. Then rebuild the list of all specs:
   `../tools/costs_ledger.ps1` (writes `.specs/costs.md`).

4. **Definition of Done.** Tick the lines that are true; leave the pull-request line for the
   pr stage. Never tick a line that is not true — report it instead.

5. **Deferred items.** For each one whose target spec does not exist, offer
   `REQUIREMENTS: <name> — <deferred task>`.

6. **Move the spec.**
   - Header: **Status** `✅ Complete — closed on <branch>`; **Last updated** today.
   - A **Stage log** row: today, `implementation`, `CLOSE:`, your model, `spec closed`.
   - `git mv` the spec to `.specs/features/done/` (the name stays the same).
   - Relative links in the spec are one level deeper now: change `../` to `../../` and check
     that every link resolves. Fix links **to** the spec from other files (for example
     `SPEC-NX.md`); `.specs/overall_req.md` is the user's — only report links there.
   - If the review stage wrote `.specs/changes/<name>/`, `git mv` it to
     `.specs/changes/done/<name>/` and fix the links (the review pages in `.specs/review/` stay
     where they are).

7. **Report** and suggest the commit `Close the spec (#<issue>)`. The next step is
   `PR: <spec file>` — the closed spec ships in the same pull request, and the pull request
   and the issue get the **Cost summary**.

## Never

- Work on more than one Step per `IMPLEMENT:`, or start the next Step on your own — except a
  **Per-Step run** the user said yes to.
- Change Part 1 while implementing (only `CLOSE` adds discovered statements); if Part 1 is
  wrong, stop and suggest `REQUIREMENTS: <spec file> — …`.
- Tick a task whose check fails, or write a Done line for a Step that is not done.
- Commit, push or merge — the user does that; the only exception is the per-Step commit of a
  confirmed **Per-Step run**. Never push.
