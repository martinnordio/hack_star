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

- [ ] New files are in the right place of `docs/architecture.md`: game rules in
      `ui/src/lib/game/`, 3D models in `ui/src/lib/models/`, rooms in `ui/src/lib/net/`,
      texts in `ui/src/lib/i18n/`, server code in `server/src/hack_star_server/`.
- [ ] No new circular imports; game rules do not import screens.
- [ ] Saved progress and room messages stay readable for old saves and other clients, or a
      plan decision says why not.
- [ ] New dependencies (`pyproject.toml`, `package.json`) have a plan decision.

## Layer 3 · Code quality

- [ ] The rules of `.specs/guidelines/<language>.md` and the kit's baseline for each language
      changed (naming, types, errors, files, tests).
- [ ] Errors and empty cases are handled where the player sees them; no swallowed exceptions.
- [ ] Input from players, saved progress, rooms and the network is validated; no injection
      (HTML, shell), no path traversal.
- [ ] New visible text exists in every language of `ui/src/lib/i18n/`.
- [ ] Tests cover the changed behaviour (`server/tests/`, `ui/src/**/*.test.ts`); **removed
      tests** are justified.
- [ ] Names say what things are; no duplicated logic that could share a helper in the same
      module.

## Layer 4 · Quick scan

- [ ] No secrets, tokens or credentials; no internal URLs or personal data.
- [ ] No debug output left (`print`, `console.log`), no commented-out code.
- [ ] No `TODO` without a reference (spec Step, issue).
- [ ] File names follow the conventions; `npm run check` and the tests pass.

## Finding table

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | one line | spec / architecture / code / scan | spec / architecture / guideline / security / test / docs / dead-code | Blocking / Should-fix / Nit | fix now / deferred / new spec / plan decision |

- **Blocking:** wrong behaviour, a statement not met, a security problem, a broken boundary.
- **Should-fix:** works, but will cost later (missing test, unclear name, outdated doc).
- **Nit:** taste; never a reason to request changes.

Also say what is good: a review that only lists problems hides what to keep doing.
