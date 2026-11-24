# Stage: Requirements

Write **Part 1 · Requirements** of a spec: *what* Hack star should do, as short, testable
statements, after checking what already exists in the repository. The plan (Part 2) is written
later by the plan stage, once the requirements are agreed.

## Commands

```
REQUIREMENTS: <name> — <what you want, in plain words>
```
Creates a new spec file with Part 1 filled.

```
REQUIREMENTS: <spec file> — <what to add or change>
```
Revises Part 1 of an existing spec (for example after the open questions are answered).

```
CREATE ISSUE: <spec file> [parent <n>]
```
Creates the GitHub issue of the spec, optionally as a sub-issue of a parent, with the summary
of the spec; writes its number (and the parent) into the spec header. Offered automatically
when Part 1 is finished.

```
UPDATE ISSUE: <spec file>
```
Puts a summary of the spec into its GitHub issue: a dry run first, then the real update after
the user confirms.

## Skills to load

Always: `../skills/requirements_engineer.md` — the role you take in this stage.

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

Paths are relative to this file (`.specs/kit/requirements/`).

| File | Use |
|------|-----|
| `../skills/requirements_engineer.md` | Your role: how to think and what to avoid |
| `../spec_template.md` | The spec template (Part 1 · Requirements, marker, Part 2 · Plan) |
| `../tools/README.md` | The summary format and the GitHub scripts |
| `.specs/spec-nx.json`, `.specs/spec-nx.local.json` | The settings (section *Settings* above): `git_host` (`github`), `link_issues` (`true`), `work_items`, `parent` (if set), `shell` (`powershell`) |

---

## REQUIREMENTS: new spec

1. **Read the repository first.** Before writing anything, look at:
   - `.specs/overall_req.md` (the overall game idea), `README.md` (how the game is played, run
     and tested) and `docs/architecture.md` (server, screens, game rules, 3D models, saved
     progress, rooms);
   - the specs in `.specs/features/` and `.specs/features/done/` — is this feature, or part of
     it, already specified or built?
   - the code that matches the words of the request: screens in `ui/src/lib/*.svelte`, game
     rules in `ui/src/lib/game/`, 3D models in `ui/src/lib/models/`, rooms in `ui/src/lib/net/`,
     texts in `ui/src/lib/i18n/`, and the server in `server/src/hack_star_server/`.

   Write down what you found: it goes into **Already in the repository**.

2. **Ask before writing if something blocks you.** If the request cannot be turned into
   requirements without an answer (who uses it, what "done" looks like, a choice between two
   very different meanings), ask the user now — at most three short questions. Smaller
   doubts go into **Open questions** in the spec.

3. **Create the file** `.specs/features/<yyyy_mm_dd>_<name>_spec.md`:
   - `<yyyy_mm_dd>` is today's date; `<name>` is short, lowercase, words joined by `_`.
   - If the file already exists, stop and say so.
   - Copy `../spec_template.md`.

4. **Fill the header:**
   - **Author:** the user (from `git config user.name`, or ask).
   - **Status:** `⬜ Requirements in progress`.
   - **Created** and **Last updated:** today.
   - **Branch:** `feature/<name>` (with `-` instead of `_`). Do not create the branch.
   - **Issue:** add the line `> **Issue:** #<n>` if the user gave one. If there is none yet, it
     is created at the end (`CREATE ISSUE`, step 7).
   - **Parent:** add `> **Parent:** #<n>` if the user gave a parent issue.
   - **Stage log:** replace the example row with today, `requirements`, `REQUIREMENTS:`,
     your model, and `Part 1 written`.

5. **Fill Part 1:**
   - **Context:** two or three sentences — the problem and why it matters to the players.
   - **Already in the repository:** what you found in step 1, with file paths. Say how the new
     feature uses or extends it.
   - **New:** what does not exist yet.
   - **1 · Specs:** `S1`, `S2`, … — one concern each:
     - **Testable:** someone can check it is met (something shown on screen, saved, refused,
       a number).
     - **What, not how:** no frameworks, stores, endpoints or function names — those belong
       in the plan.
     - **Short:** one or two sentences; a bold name, then the statement
       (`**S1 — Rename:** …`).
     - Check what is often forgotten: errors and empty states, limits (names, credits,
       counts), saved progress after a reload and on another tab, friends in a room, every
       game language, mouse and touch on desktop, tablet and phone, and what must keep
       working as before.
     - If an existing spec already covers part of it, refer to it instead of repeating it.
   - **Open questions:** what you could not decide; one line each, ending with your
     suggestion (`Suggestion: …`).
   - Delete the template's example block and placeholder rows.

6. **Leave Part 2 for the plan stage.** Keep the marker line `<!-- spec-nx:plan -->` and
   replace everything below it with:

   ```
   ---

   # Part 2 · Plan

   _Written by the plan stage once Part 1 is agreed._
   ```

7. **Report to the user:** the file name, the statements in one line each, the open questions,
   and the next step: *answer the open questions (`REQUIREMENTS: <spec file> — <answers>`, or
   `— take your suggestions`), then run the plan stage.* If the spec has an issue, offer `UPDATE ISSUE`.

   **When the requirements are finished** (no open questions left), ask: *"Create the GitHub
   issue for this spec now? If it belongs under a parent issue, give its number."* — and run
   `CREATE ISSUE` if the user says yes. Ask only if the header has no `Issue:` yet.

## REQUIREMENTS: revise an existing spec

- Change **Part 1 only**; never touch anything below `<!-- spec-nx:plan -->`.
- Keep statement numbers stable: add new ones at the end, mark removed ones
  `~~S4 — …~~ (removed: <reason>)` instead of renumbering.
- Move answered open questions into the statements, and remove them from the list.
- Update **Last updated**. If Part 2 already has a plan, tell the user which Steps the change
  may affect.
- Add a **Stage log** row: today, `requirements`, `REQUIREMENTS:`, your model, `Part 1
  revised: <what changed>`. If the spec has no Stage log (older spec), add the section from
  the template above Part 1.
- If the revision leaves no open questions, the requirements are finished: offer
  `CREATE ISSUE` as in step 7 above.

## CREATE ISSUE

1. **Check.** The header has no `Issue:` (otherwise use `UPDATE ISSUE`), and `gh auth status`
   shows a login.
2. **Parent.** From the command (`parent <n>`), the header's `Parent:` line, `parent` from
   the settings, or ask once: *"Is there a parent issue? (number, or none)"*. The dry run
   names the parent — check it. The new issue becomes a **sub-issue** of the parent.
3. **Title:** the spec title without the trailing "Spec".
   **More fields** from the settings' `work_items` (the script reads them; the command can
   override them): `type` (an issue type of the organization) and `assigned_to`. Without
   `assigned_to` the issue is assigned to you (`@me`); `"assigned_to": null` leaves it
   unassigned. The dry run lists every field with the file it comes from, and stops with a
   message naming the setting and its file when a value does not exist (an unknown type,
   person or parent).
4. **Summary** as in `UPDATE ISSUE` step 3, in a temporary file outside the repository.
5. **Dry run** and show it:

   ```
   ../tools/github/create_issue.ps1 -Title <title> -SummaryFile <file> [-Parent <n>] [-Type <type>] [-AssignedTo <login> | -Unassigned] -DryRun
   ```

6. **After the user confirms,** run it without `-DryRun`; it prints the new number. Delete the
   temporary file.
7. **In the spec header:** `> **Issue:** #<n>`, and `> **Parent:** #<n>` if there is one;
   **Last updated** today; a **Stage log** row (today, `requirements`, `CREATE ISSUE:`, your
   model, `issue #<n> created`).
8. **Report** the link, and remind the user that from now on every commit message carries
   `#<n>` (`../guidelines/commits.md`).

## UPDATE ISSUE

1. Read the spec header for `Issue:`. If there is none, offer `CREATE ISSUE`, or ask for the
   number of an existing issue and add it to the header.
2. The project is on GitHub (`git_host` in `.specs/spec-nx.json`) and the kit's scripts are
   PowerShell; they need `gh`, logged in.
3. Build the **summary** in the format of `../tools/README.md`. While Part 2 has no Steps,
   leave the **Plan** part out. If the spec has a **Cost summary** (closed with cost tracking
   on), add it as `## Cost summary` (its sentence and both tables) before the **Plan** part,
   links as full URLs. Write it to a temporary file outside the repository.
4. Run the script **with the dry run** and show the result:

   ```
   ../tools/github/update_issue.ps1 -Issue <n> -SummaryFile <file> -DryRun
   ```

5. After the user confirms, run it again without `-DryRun`, then delete the temporary file.

## Never

- Write code, or Part 2.
- Change other specs (refer to them instead), or `.specs/overall_req.md` — it is the user's
  own document.
- Put secrets, tokens, internal URLs or personal data into a spec or an issue.
