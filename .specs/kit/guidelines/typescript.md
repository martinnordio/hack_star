# TypeScript — baseline

> Rules for the UI in `ui/`, used together with `svelte.md`. `ui/tsconfig*.json` and
> `.specs/guidelines/typescript.md` win over this file. Reference:
> [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/).

## Environment

- npm (`ui/package-lock.json`); never another package manager. `npm install` once, in `ui/`.
- TypeScript 6 in `strict` mode (from `@tsconfig/svelte`); a new dependency is a decision in
  the plan.
- Run the UI with `cd ui; npm run dev` (port 5180; `/api` is proxied to the server on 8180),
  or `npm run dev:https` for the camera on tablets and phones.

## Layout and naming

- Code in `ui/src/lib/`: game rules in `game/`, 3D models in `models/`, rooms in `net/`,
  texts in `i18n/`. Game rules are plain functions that tests can call without a screen.
- 2 spaces; single quotes; no semicolons — follow the file you edit.
- `camelCase` variables, functions and file names; `PascalCase` types; `UPPER_SNAKE` for true
  constants (`MAX_CREATED_FIGHTERS`).
- ES modules with named exports; `import type` for types only.

## Types

- No `any`; use `unknown` and narrow it.
- Type every exported function's parameters and return value.
- Union types and `as const` arrays, not enums (the code has none).
- Validate data at the boundary — saved progress from `localStorage`, room messages, server
  responses, QR codes — before trusting its type; old saves must still load.

## Errors and async

- `async` / `await`, never unhandled promises; every `await` that can fail is handled where
  the player can see the error.
- Throw `Error` objects with a clear message; never throw strings.
- No `console.log` in committed code.

## Text

- Every visible text is a key in `ui/src/lib/i18n/en.ts`, translated in every other language
  file of that folder; no hard-coded text in screens.

## Comments

- Comments say *why*; types and names say *what*.

## Tests

- Vitest; files `<name>.test.ts` next to the code in `ui/src/`.
- Every Step that changes behaviour adds or updates a test that would fail without it.

## Checks before a Step is done

- `cd ui; npm test` and `npm run check` pass; `npm run build` when imports or assets changed.
