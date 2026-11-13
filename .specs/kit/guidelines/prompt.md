# Guidelines

Short coding rules per language, in two layers:

| Layer | Where | Owned by | On `GENERATE KIT --update` |
|-------|-------|----------|----------------------------|
| **Baseline** | `.specs/kit/guidelines/<language>.md` (from spec-nx, adapted to Hack star) | the generator | replaced |
| **Project** | `.specs/guidelines/<language>.md` | the project | never touched |

When both say something different, the **project** file wins. Linter, formatter or type-checker
configuration (`tsconfig*.json`, `svelte-check`; any ruff or ESLint configuration added later)
wins over everything written here — guidelines never repeat what a tool already checks.

Hack star's languages: `python` (server), `typescript` and `svelte` (UI), `powershell` (kit
scripts).

## Command

```
GUIDELINES: <language>
```
Writes `.specs/guidelines/<language>.md` for Hack star, or proposes changes to it.

## Skills to load

None.

## Files this stage uses

Paths are relative to this file (`.specs/kit/guidelines/`).

| File | Use |
|------|-----|
| `<language>.md` (next to this file) | The baseline for the language |
| `.specs/guidelines/<language>.md` | The project's rules, if they exist |
| `.specs/spec-nx.json` | `languages` |

---

## GUIDELINES

1. **Scan the project** for the language:
   - its version (`server/pyproject.toml` `requires-python`, `ui/package.json`,
     `ui/tsconfig.app.json` `target`, `#Requires -Version`);
   - linter, formatter and type-checker configuration and the rules they set;
   - where tests live, how they are named and how they are run (`server/tests/`,
     `ui/src/**/*.test.ts`);
   - how the code is run (README, `npm run dev`, `uv run hack-star-server`);
   - patterns the code follows consistently (folders, naming, error handling, stores).

2. **Write only what is true and not already enforced.** Each rule must be either checked in
   the code (it is already followed) or decided by the user. Do not copy the baseline: the
   project file holds only what is **specific** to Hack star or **differs** from the baseline.
   Keep it under ~60 lines, in this shape:

   ```
   # <Language> — project rules

   > Baseline: .specs/kit/guidelines/<language>.md · Linter: <file> · Updated: YYYY-MM-DD

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
- Write a rule a tool's configuration already enforces, or one that contradicts it.
- Overwrite `.specs/guidelines/` without the user's consent.
