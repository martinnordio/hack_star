# Stage: Plan

Write **Part 2 · Plan** of a spec whose requirements (Part 1) are agreed: Steps with goals and
tasks, decisions, deferred items and a Definition of Done. The plan says *how*; it never
changes *what* (Part 1).

## Command

```
PLAN: <spec file>
```
Writes Part 2 of the spec. Run it again after Part 1 changes: Steps that are already done are
kept; the rest is re-planned.

## Skills to load

- Always: `../skills/architect.md` — the role you take in this stage.
- Also: `../skills/requirements_engineer.md` — to check that Part 1 is ready (first step below).

## Model name

**Check the model first** (`../models.md`): with `models` set in the settings, run on the
configured model, as a sub-agent or after asking; with no `models`, use the tool's model.

**Tokens and cost** (`../COSTS.md`): only with the `cost` block on. Note the start time; at
the end run `../tools/usage.ps1` with it and your model, and copy its
Tokens and Cost into your Stage log row — never compute them yourself.

Wherever this prompt says *your model*, write the name of the model that runs this command
now, as your runtime reports it. Never copy it from earlier rows, from `.specs/spec-nx.json`
(its `model` is the model that generated the kit), from the kit's README or from examples. If
you cannot tell, ask the user once; otherwise write `unknown model`.

## Files this stage uses

Paths are relative to this file (`.specs/kit/plan/`).

| File | Use |
|------|-----|
| `../skills/architect.md` | Your role while planning |
| `../skills/requirements_engineer.md` | How to judge whether Part 1 is ready |
| `../spec_template.md` | The shape of Part 2 (Overview, Decisions, Steps, Deferred, Review Log, Definition of Done) |
| `docs/architecture.md` | How the server and the UI are organised; where new code belongs |
| `.specs/spec-nx.json` | `stages`: requirements, plan, implementation, review, pr (for the Definition of Done) |

---

## PLAN

1. **Check that Part 1 is ready.** Stop and tell the user — without writing a plan — if:
   - **Open questions** are not empty: list them and suggest
     `REQUIREMENTS: <spec file> — <answers>`;
   - a statement is not testable, or mixes several concerns: say which and why.

   Never change Part 1 yourself.

2. **Read the code the requirements touch.** Start from *Already in the repository* and
   `docs/architecture.md`. The server is FastAPI in `server/src/hack_star_server/` (tests in
   `server/tests/`, run with `cd server; uv run pytest`); the UI is Svelte 5 + Vite in
   `ui/src/` (tests `*.test.ts` next to the code, run with `cd ui; npm test`; types with
   `npm run check`; bundle with `npm run build`).

3. **Write Part 2** below the marker line `<!-- spec-nx:plan -->`, replacing the placeholder,
   in the shape of `../spec_template.md`:
   - **2 · Spec Overview:** one row per Step, status `⬜ Not started`, with an anchor link to
     the Step. Keep the template's *Step completion protocol* and *Time tracking* notes.
     **With per-Step models** (`models` has tiers, `../models.md`): fill the **Model
     (suggested)** column — `<tier> (<model>) — <a few words why>`. Start from the tier's
     `guide`, then judge the Step itself: pick the **cheapest tier that does it well** —
     reasoning for design, refactorings, security, tricky logic, open decisions or complex
     work such as graphics-heavy Steps; standard for work a clear plan describes; light for
     mechanical edits and docs. With `fixed` or no `models` (this project uses `fixed`),
     leave the column out.
   - **Decisions:** `D1`, `D2`, … — every choice another person might make differently (server
     or UI, a new dependency, a saved-progress or room-message format, a migration of old
     saves, where art or music comes from and its licence), with the reason.
   - **Steps:** `Step 0` only if setup is needed, then `Step 1`, … Each Step has:
     - **Goal:** one sentence, naming the statements it covers (`(S1, S3)`);
     - **Tasks:** first task always `Record the start time in Notes below.`; then concrete
       tasks; last task how the Step is checked (a test, a command, or what to look at in the
       browser);
     - **Notes:** empty, with the hint to add the `Done` line.

     Every statement S… is covered by at least one Step. Each Step leaves the game working
     and is small enough to review in one sitting. New visible text is added in every
     language of `ui/src/lib/i18n/`. The last Step checks that what worked before still
     works (both test suites, `npm run check`, `npm run build`) and updates `README.md` and
     `docs/architecture.md` where the change affects them.
   - **Deferred Items:** what is consciously left out, with reason and target; empty table if
     nothing.
   - **Review Log:** the empty table from the template.
   - **Definition of Done:** the template's lines (the kit's stages). Tick *Requirements* and
     *Plan*.

4. **Update the header:** **Status** `⬜ Not started — plan ready`; **Last updated** today.
   Add a **Stage log** row: today, `plan`, `PLAN:`, your model, `Part 2 written` (add the
   section from the template above Part 1 if the spec has none). With per-Step models, the
   report lists each Step's tier so the user can change one before implementing.

5. **Report to the user:** the Steps in one line each, the decisions, anything deferred, and
   the next step — implement Step 0 (or Step 1). If the spec has an issue, suggest updating it
   so it shows the plan (`UPDATE ISSUE`, requirements stage).

## PLAN again (Part 1 changed)

- Keep Steps marked ✅ Done unchanged, with their Notes.
- Re-plan the Steps not started; if a Step in progress is affected, say so and ask before
  changing it.
- Add a line to the Review Log: date, "re-planned", and why.
- Add a **Stage log** row: today, `plan`, `PLAN:`, your model, `re-planned: <why>`.

## Never

- Change Part 1, or plan while Part 1 has open questions.
- Write code — the plan only describes the work.
- Leave a statement without a Step, or a Step without a check.
