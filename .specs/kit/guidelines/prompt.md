# Guidelines

Short coding rules per language, in two layers:

| Layer | Where | Owned by | On `GENERATE KIT --update` |
|-------|-------|----------|----------------------------|
| **Baseline** | `.specs/kit/guidelines/<language>.md` | the generator | replaced |
| **Project** | `.specs/guidelines/<language>.md` | the project | never touched |

When both say something different, the **project** file wins. A linter or formatter
configuration, once the project adds one, wins over everything written here — guidelines never
repeat what a linter already checks.

Baselines in this kit: `python.md` (server), `typescript.md` and `svelte.md` (UI),
`powershell.md` (the kit's scripts), and `commits.md`.

## Command

```
GUIDELINES: <language>
```
Writes `.specs/guidelines/<language>.md` for this project, or proposes changes to it.

## Skills to load

None.

## Settings

Read the settings in their three layers (the kit's README, section *Settings*): the kit's,
the project's `.specs/spec-nx.json` and the developer's `.specs/spec-nx.local.json`, the later
winning. In your report, name each
setting you used that does not come from the kit, with its file (for example *parent 150310 —
from `.specs/spec-nx.local.json`*).
With `prompt_log` on, add the prompt you were given to the prompt log at the start and its reply
summary at the end (the kit's README, section *Prompt log*).

## Files this stage uses

Paths are relative to this file (`.specs/kit/guidelines/`).

| File | Use |
|------|-----|
| `<language>.md` (next to this file) | The baseline for the language |
| `.specs/guidelines/<language>.md` | The project's rules, if they exist |
| `.specs/spec-nx.json` | `languages`: python, typescript, svelte, powershell |

---

## GUIDELINES

1. **Scan the project** for the language:
   - its version: `server/pyproject.toml` `requires-python` and `server/.python-version`;
     `ui/package.json` and `ui/tsconfig*.json`; `#Requires -Version` in scripts;
   - linter, formatter and type-checker configuration, if any (today: `svelte-check` and `tsc`
     through `npm run check`; no ruff, mypy, ESLint, Prettier or PSScriptAnalyzer settings);
   - where tests live, how they are named and how they are run (`server/tests/test_*.py` with
     `uv run pytest`; `ui/src/**/*.test.ts` with `npm test`);
   - how the code is run (`README.md`: `uv run hack-star-server`, `npm run dev`);
   - patterns the code follows consistently (folders, naming, error handling, saved progress,
     texts in `ui/src/lib/i18n/`).

2. **Write only what is true and not already enforced.** Each rule must be either checked in
   the code (it is already followed) or decided by the user. Do not copy the baseline: the
   project file holds only what is **specific** to the project or **differs** from the
   baseline. Keep it under ~60 lines, in this shape:

   ```
   # <Language> — project rules

   > Baseline: .specs/kit/guidelines/<language>.md · Linter: <file or none> · Updated: YYYY-MM-DD

   ## Environment       version, how to install, how to run
   ## Tests             where, naming, command
   ## Rules             only project-specific rules and differences from the baseline
   ## Known issues      workarounds the code depends on, with the reason
   ```

3. **New file:** create `.specs/guidelines/<language>.md` and show it.
   **Existing file:** never overwrite it. Show a diff of what you would add, change or remove,
   with one line of reason each, and apply only what the user accepts.

4. **Report** the file, what came from the scan, and which rules need the user's decision.

## Never

- Copy long reference texts (style guides, framework docs) — link them.
- Write a rule a linter configuration already enforces, or one that contradicts it.
- Overwrite `.specs/guidelines/` without the user's consent.
