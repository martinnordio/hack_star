# Code review — checklist

Review **layer by layer**: a broken boundary matters more than a style nit, so the order is
fixed. For a large change, read new files fully, files with more than ~50 changed lines
carefully, and skim the rest.

## Layer 1 · Spec alignment

- [ ] The change does what the spec's Steps say — nothing missing, nothing extra.
- [ ] Every statement the change claims is met and can be checked.
- [ ] Requirements found while implementing are in the spec; deviations from the plan are
      explained in the Step's Notes.
- [ ] The Overview table, the Steps and the Definition of Done agree with reality.

## Layer 2 · Architecture

- [ ] New files are in the right module; module boundaries in `docs/architecture.md` hold.
- [ ] No new circular or cross-boundary imports.
- [ ] New external dependencies, boundary changes and file formats have a decision (plan or
      ADR).

## Layer 3 · Code quality

- [ ] The rules of `.specs/guidelines/<language>.md` and the kit's baseline for each language
      changed (naming, types, errors, files, tests).
- [ ] Errors and empty cases are handled where the user sees them; no swallowed exceptions.
- [ ] Input from users, files and the network is validated; no injection (SQL, shell, HTML),
      no path traversal.
- [ ] Tests cover the changed behaviour; **removed tests** are justified.
- [ ] Names say what things are; no duplicated logic that could share a helper in the same
      module.

## Layer 4 · Quick scan

- [ ] No secrets, tokens or credentials; no internal URLs or personal data.
- [ ] No debug output left (`print`, `console.log`), no commented-out code.
- [ ] No `TODO` without a reference (spec Step, issue).
- [ ] File names follow the conventions; the linter and formatter pass.

## Finding table

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | one line | spec / architecture / code / scan | spec / architecture / guideline / security / test / docs / dead-code | Blocking / Should-fix / Nit | fix now / `IMPROVE:` / new spec / `ADR:` |

- **Blocking:** wrong behaviour, a statement not met, a security problem, a broken boundary.
- **Should-fix:** works, but will cost later (missing test, unclear name, outdated doc).
- **Nit:** taste; never a reason to request changes.

Also say what is good: a review that only lists problems hides what to keep doing.
