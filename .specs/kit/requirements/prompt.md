# Stage: Requirements

Write **Part 1 · Requirements** of a Hack star spec: *what* the game must do, as short,
testable statements, after checking what already exists in the repository. The plan (Part 2) is
written later by the plan stage, once the requirements are agreed.

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

## Files this stage uses

Paths are relative to this file (`.specs/kit/requirements/`).

| File | Use |
|------|-----|
| `../skills/requirements_engineer.md` | Your role: how to think and what to avoid |
| `../spec_template.md` | The spec template (Stage log, Part 1 · Requirements, marker, Part 2 · Plan) |
| `../tools/README.md` | The summary format and the GitHub scripts |
| `.specs/overall_req.md` | The overall game idea and the planned specs |
| `.specs/spec-nx.json` | Project settings: `git_host` (`github`), `link_issues` (`true`) |
| `.specs/spec-nx.local.json` | Developer settings: `shell` (`powershell`) |

---

## REQUIREMENTS: new spec

1. **Read the repository first.** Before writing anything, look at:
   - `.specs/overall_req.md` — the overall vision of Hack star (a browser game inspired by
     Brawl Stars, with hack codes) and which spec the request belongs to;
   - the README and `docs/architecture.md` — how the game is built today;
   - the specs in `.specs/features/` and `.specs/features/done/` — is this feature, or part of
     it, already specified or built?
   - the server (`server/src/hack_star_server/`) and the UI (`ui/src/`): search for the words
     of the request (screens, fighters, trophies, skins, hack codes, rooms, bots).

   Write down what you found: it goes into **Already in the repository**.

2. **Ask before writing if something blocks you.** If the request cannot be turned into
   requirements without an answer (who plays it, what "done" looks like, a choice between two
   very different meanings), ask the user now — at most three short questions. Smaller doubts
   go into **Open questions** in the spec.

3. **Create the file** `.specs/features/<yyyy_mm_dd>_<name>_spec.md`:
   - `<yyyy_mm_dd>` is today's date; `<name>` is short, lowercase, words joined by `_`
     (for example `2026_11_13_online_rooms_spec.md`).
   - If the file already exists, stop and say so.
   - Copy `../spec_template.md`.

4. **Fill the header:**
   - **Author:** the user (from `git config user.name`, or ask).
   - **Status:** `⬜ Requirements in progress`.
   - **Created** and **Last updated:** today.
   - **Branch:** `feature/<name>` (with `-` instead of `_`). Do not create the branch.
   - **Issue:** add `> **Issue:** #<n>` if the user gave one. If there is none yet, it is
     created at the end (`CREATE ISSUE`, step 7).
   - **Parent:** add `> **Parent:** #<n>` if the user gave a parent issue.
   - **Stage log:** replace the example row with today, `requirements`, `REQUIREMENTS:`, the
     exact name of the AI model you are, and `Part 1 written`.

5. **Fill Part 1:**
   - **Context:** two or three sentences — what the player gets and why it matters for the game.
   - **Already in the repository:** what you found in step 1, with file paths. Say how the new
     feature uses or extends it.
   - **New:** what does not exist yet.
   - **1 · Specs:** `S1`, `S2`, … — one concern each:
     - **Testable:** someone can check it in the browser (what is shown, a number, an
       animation that plays, a message).
     - **What, not how:** no libraries, frameworks, endpoints or component names — those
       belong in the plan.
     - **Short:** one or two sentences; a bold name, then the statement
       (`**S1 — Home screen:** …`).
     - Check what is often forgotten in this game: desktop, iPad and phone screens (portrait
       and landscape), touch as well as mouse/keyboard, loading and empty states, invalid hack
       or room codes, playing with friends on other devices, limits (trophies, credits,
       levels), and what must keep working as before.
     - If an existing spec already covers part of it, refer to it instead of repeating it.
   - **Open questions:** what you could not decide; one line each.
   - Delete the template's example block and placeholder rows.

6. **Leave Part 2 for the plan stage.** Keep the marker line `<!-- spec-nx:plan -->` and
   replace everything below it with:

   ```
   ---

   # Part 2 · Plan

   _Written by the plan stage once Part 1 is agreed._
   ```

7. **Report to the user:** the file name, the statements in one line each, the open questions,
   and the next step: *answer the open questions (`REQUIREMENTS: <spec file> — <answers>`),
   then run the plan stage (`PLAN: <spec file>`).* If the spec has an issue, offer
   `UPDATE ISSUE`.

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

1. **Check.** The header has no `Issue:` (otherwise use `UPDATE ISSUE`).
2. **Parent.** From the command (`parent <n>`), the header's `Parent:` line, or ask once:
   *"Is there a parent issue? (number, or none)"*. The new issue becomes a **sub-issue** of the
   parent.
3. **Title:** the spec title without the trailing "Spec".
4. **Summary** as in `UPDATE ISSUE` step 2, in a temporary file outside the repository.
5. **Dry run** and show it:
   `../tools/github/create_issue.ps1 -Title <title> -SummaryFile <file> [-Parent <n>] -DryRun`
6. **After the user confirms,** run it without `-DryRun`; it prints the new number. Delete the
   temporary file.
7. **In the spec header:** `> **Issue:** #<n>` and `> **Parent:** #<n>` if there is one;
   **Last updated** today; a **Stage log** row (today, `requirements`, `CREATE ISSUE:`, your
   model, `issue #<n> created`).
8. **Report** the link, and remind the user that from now on every commit message carries
   `#<n>` (`../guidelines/commits.md`).

## UPDATE ISSUE

1. Read the spec header for `Issue:`. If there is none, offer `CREATE ISSUE`, or ask for the
   number of an existing issue and add it to the header.
2. Build the **summary** in the format of `../tools/README.md` (link to the spec on the feature
   branch while it is open, on `main` once it is in `.specs/features/done/`). While Part 2 has
   no Steps, leave the **Plan** part out. Write it to a temporary file outside the repository.
3. Run `../tools/github/update_issue.ps1 -Issue <n> -SummaryFile <file> -DryRun` and show the
   result.
4. After the user confirms, run it again without `-DryRun`, then delete the temporary file.

## Never

- Write code, or Part 2.
- Change other specs (refer to them instead).
- Change `.specs/overall_req.md` — it is the user's own document.
- Put secrets, tokens, internal URLs or personal data into a spec or an issue.
