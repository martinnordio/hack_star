# Stage: Review

Give the reviewer what to read first, and review the change against its spec.

- **Semantic diff** — not the lines that changed, but the **objects** that changed (a screen,
  a game rule, an API endpoint, a room message, the saved progress, a setting), each shown
  **Before | After** with the smallest example, linked to the spec's statements. It goes into
  the pull request.
- **Code review** — a layered review (spec, architecture, code, quick scan) whose findings go
  into the spec's Review Log.

## Commands

```
REVIEW: <spec file>
```
Writes the change record, the HTML review page (with the index of all review pages) and the
pull-request text of the semantic diff. Run it again after more Steps or review fixes:
hand-written parts of the record are kept, and the page is rewritten.

```
CODE REVIEW: <spec file>
```
Reviews the branch's changes layer by layer and logs the findings in the spec.

## Skills to load

Always: `../skills/reviewer.md` — the role you take in this stage.

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

Paths are relative to this file (`.specs/kit/review/`).

| File | Use |
|------|-----|
| `semantic_diff.md` | Rules: what needs a record, kinds of objects, how Before / After are made, checks |
| `change_record.yaml` | Template of the change record |
| `change_record.schema.json` | Schema the record must pass |
| `code_review.md` | The layered checklist and the finding table |
| `review_page.html` | Template of the HTML review page (styles, sections, tooltips, metadata) |
| `index_page.html` | Template of the index of all review pages |
| `../guidelines/<language>.md`, `.specs/guidelines/<language>.md` | Coding rules of the languages changed |
| `docs/architecture.md` | How the server and the UI are organised |

**Output:**

| Where | What |
|-------|------|
| `.specs/review/<yyyy-mm-dd>_<branch-slug>.html` | The **review page** — the HTML report reviewers open first |
| `.specs/review/index.html` | All review pages, newest first |
| `.specs/changes/<name>/` | The change record, `before/`, `after/` and `semantic_diff.md` (the pull-request text); `.specs/changes/done/<name>/` once the spec is closed |

`<branch-slug>` is the branch with `/` → `-` (`feature-created-fighter-studio`); `<name>` is the
branch without `feature/` (`created-fighter-studio`).

---

## REVIEW

1. **Range.** The default branch is `main`; base = `git merge-base HEAD main`; head = `HEAD`
   plus uncommitted changes. The current branch must be the spec's **Branch**.

2. **Record** (`change_record.yaml`, only when `semantic_diff.md` says it is required):
   - read the spec (Context, statements, Steps, decisions) and `git diff --stat -M <base>`;
   - one block per changed **object**, with its kind, `added` / `modified` / `removed`, the
     statements it serves, a one-line `note` of what to look at, and the smallest example
     that shows the change on both sides;
   - `why` (2–6 lines, from the spec's Context), `breaking`, and up to four `review`
     questions and answers for choices a reviewer will ask about;
   - check it against `change_record.schema.json`; on a re-run, keep what the author edited
     and only add.

   **Show the record and ask the user to confirm it** before going on.

3. **Before | After.** For each block and example, produce both sides as described for its kind
   in `semantic_diff.md` — from the base revision (`git show <base>:<path>`, or a temporary
   `git worktree add --detach <tmp> <base>`, removed afterwards) and from the head. Same
   input, same settings on both sides: for the server, call the endpoint with the FastAPI test
   client or `uv run`; for the UI, run the game rule in a Vitest case, or open the screen with
   `npm run dev` (port 5180) and capture it at the same size on both sides; for saved
   progress, compare the `localStorage` JSON. If a side cannot be produced, mark the block
   `manual` with the reason — never invent output.

4. **Checks.** Run the checks of `semantic_diff.md` (C1–C9): `pass`, `fail` or `n/a`. Each
   failure is a finding.

5. **Previous reviews.** Read the `review-meta` block of earlier pages in `.specs/review/` for
   this branch: hunks already covered are not explained again unless they changed; their
   findings get a status (resolved / partially / still open) under **Previously reviewed**.

6. **Review page** `.specs/review/<yyyy-mm-dd>_<branch-slug>.html` (a re-run on the same day
   overwrites it; on another day, a new page), from `review_page.html`. One self-contained
   file: no external files (images as `data:` URIs while it stays under ~5 MB), works without
   JavaScript, every code character escaped, relative links only. Sections, in this order:
   1. **Header** — title, branch, base, head, target, date, commits, files, `+/-` lines; a
      table of contents with one entry per change card and per highlight.
   2. **Summary** — a short paragraph and three to five bullets in plain words, and the
      recommendation (Approve / Approve with follow-ups / Request changes).
   3. **Spec context** — link, statements covered, Steps.
   4. **Semantic diff** — `why`, `breaking`, the checks; then one card per block:
      `<KIND> · <object> — <change>`, the note, the example input, and Before | After side by
      side with the changed lines shaded; the author Q&A.
   5. **Previously reviewed** — see step 5.
   6. **Highlights** — at most 12 real diff hunks (≤ 40 lines each, with line numbers, never
      reformatted or invented), most relevant first: API and room-message changes, saved
      progress, non-trivial game logic, security, statements' acceptance; for each: what
      changed, why it matters, what to check, and 2–5 **concept tooltips**: the concept in one
      sentence, then why it is used on that line (≤ 40 words), correct for the versions in use
      (Python 3.13, FastAPI, Svelte 5, TypeScript 6, three.js / Threlte).
   7. **Findings** — the table of `code_review.md` (failed checks included).
   8. **Not covered** — what was left out (`package-lock.json`, `uv.lock`, generated files,
      renames, formatting), with the reason.
   9. **Concepts glossary** — every concept of the tooltips once.
   10. **Reviewer checklist**, and the `review-meta` data (commits, covered hunks, findings).

   Then **`.specs/review/index.html`**: create it from `index_page.html` if missing; add a row
   for the page (or update the branch's row), newest first.

7. **Pull-request text** `.specs/changes/<name>/semantic_diff.md` (at most ~2 000 characters):

   ```markdown
   ### Semantic diff
   <why, one line> · checks <n pass · n n/a · n fail> · findings <n>

   **Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/<branch>/.specs/review/<page>.html)
   — download it and open it in a browser

   | Kind | Object | Change | Statements |
   |------|--------|--------|------------|
   | <kind> | <object> | <added / modified / removed> | S1, S2 |

   **Top findings:** <up to three, one line each, or "none">
   ```

   The pr stage puts it into the pull request's `semantic-diff` block. The page must be
   committed and pushed for the link to work.

8. **In the spec:** tick the *Review* line of the Definition of Done when the page exists and
   no Blocking finding is open; add a Review Log row (today, your model, `semantic diff`, `—`,
   link to the page) and a **Stage log** row (today, `review`, `REVIEW:`, your model,
   `semantic diff written`).

9. **Report:** the record's blocks per kind, the checks, the page, the top findings, and the
   next step (`CODE REVIEW:`, `CLOSE:`, or `PR:` to publish).

## CODE REVIEW

1. **Read** the spec, the review page if `REVIEW:` was run, then the diff
   (`git diff <base>...HEAD`).
2. **Review layer by layer** with `code_review.md`: spec alignment, architecture, code quality
   against the guidelines of the languages changed, quick scan.
3. **Findings** in the table of `code_review.md`, each with a **target**:
   - in the spec's scope and no change of behaviour → *fix now* (the user runs
     `IMPLEMENT:` again or fixes it);
   - clean-up outside the scope → *deferred* (a row in the spec's **Deferred Items**) — never
     fixed in place;
   - a change of behaviour that the spec does not ask for → *new spec*
     (`REQUIREMENTS: <name> — …`);
   - a missing decision → *plan decision* (a `D<n>` added with `PLAN: <spec file>`).
4. **In the spec:** under **Review Log**, add a row (today, `AI assistant (<your model>)`,
   `diff`, the outcome, the number of findings per severity) and, below the table, a
   `### Code review YYYY-MM-DD` section with the finding table. Add a **Stage log** row
   (today, `review`, `CODE REVIEW:`, your model, the outcome).
5. **Outcome:** **Approve** (no Blocking), **Request changes**, or **Blocked on a decision**.

## Never

- Change code — this stage writes only `.specs/review/`, `.specs/changes/` and the spec's
  logs.
- Write Before | After by hand without marking it `manual` with the reason.
- Invent code, line numbers or output.
- Put secrets, tokens, internal URLs or personal data into the record, the page or the pull
  request; replace them with `«redacted»` and raise a Blocking finding.
