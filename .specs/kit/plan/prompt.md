# Stage: Plan

Write **Part 2 · Plan** of a Hack star spec whose requirements (Part 1) are agreed: Steps with
goals and tasks, decisions, deferred items and a Definition of Done. The plan says *how*; it
never changes *what* (Part 1).

## Command

```
PLAN: <spec file>
```
Writes Part 2 of the spec. Run it again after Part 1 changes: Steps that are already done are
kept; the rest is re-planned.

## Skills to load

- Always: `../skills/architect.md` — the role you take in this stage.
- Also: `../skills/requirements_engineer.md` — to check that Part 1 is ready (first step below).

## Files this stage uses

Paths are relative to this file (`.specs/kit/plan/`).

| File | Use |
|------|-----|
| `../skills/architect.md` | Your role while planning |
| `../skills/requirements_engineer.md` | How to judge whether Part 1 is ready |
| `../spec_template.md` | The shape of Part 2 (Overview, Decisions, Steps, Deferred, Review Log, Definition of Done) |
| `.spec/overall_req.md` | The technology already chosen: Python server, Svelte UI, browser only |
| `.specs/spec-nx.json` | `stages`: `requirements`, `plan`, `pr` (for the Definition of Done) |

---

## PLAN

1. **Check that Part 1 is ready.** Stop and tell the user — without writing a plan — if:
   - **Open questions** are not empty: list them and suggest
     `REQUIREMENTS: <spec file> — <answers>`;
   - a statement is not testable, or mixes several concerns: say which and why.

   Never change Part 1 yourself.

2. **Read the code the requirements touch.** Use *Already in the repository* as the starting
   point. Look at the Python server and the Svelte UI (if they exist yet): how they are
   structured, started, built and tested. If there is no code yet, the first Step sets up the
   server and the UI so both run locally.

3. **Write Part 2** below the marker line `<!-- spec-nx:plan -->`, replacing the placeholder,
   in the shape of `../spec_template.md`:
   - **2 · Spec Overview:** one row per Step, status `⬜ Not started`, with an anchor link to
     the Step. Keep the template's *Step completion protocol* and *Time tracking* notes.
   - **Decisions:** `D1`, `D2`, … — every choice another person might make differently (a new
     Python or npm package, a graphics or animation library, where assets come from and their
     licence, a data format, where the code goes), with the reason.
   - **Steps:** `Step 0` only if setup is needed, then `Step 1`, … Each Step has:
     - **Goal:** one sentence, naming the statements it covers (`(S1, S3)`);
     - **Tasks:** first task always `Record the start time in Notes below.`; then concrete
       tasks; last task how the Step is checked — a test (for example `pytest` for the
       server, the UI's test command) or what to look at in the browser at desktop, iPad and
       phone sizes;
     - **Notes:** empty, with the hint to add the `Done` line.

     Every statement S… is covered by at least one Step. Each Step leaves the game running and
     is small enough to review in one sitting. The last Step checks that what worked before
     still works, and updates the documents the change affects (README: how to install, run
     and play).
   - **Deferred Items:** what is consciously left out, with reason and target spec; empty table
     if nothing.
   - **Review Log:** the empty table from the template.
   - **Definition of Done:** the lines for Requirements, Plan, Spec closed and Pull request.
     Tick *Requirements* and *Plan*.

4. **Update the header:** **Status** `⬜ Not started — plan ready`; **Last updated** today.

5. **Report to the user:** the Steps in one line each, the decisions, anything deferred, and
   the next step — implement Step 0 (or Step 1), then open the pull request with
   `PR: <spec file>` when the work is done.

## PLAN again (Part 1 changed)

- Keep Steps marked ✅ Done unchanged, with their Notes.
- Re-plan the Steps not started; if a Step in progress is affected, say so and ask before
  changing it.
- Add a line to the Review Log: date, "re-planned", and why.

## Never

- Change Part 1, or plan while Part 1 has open questions.
- Write code — the plan only describes the work.
- Leave a statement without a Step, or a Step without a check.
