# TypeScript — baseline

> Rules for the Hack star UI (`ui/`). `ui/tsconfig*.json` (strict, from `@tsconfig/svelte`) and
> `.specs/guidelines/typescript.md` win over this file. Reference:
> [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/).

## Environment

- **npm** (`ui/package-lock.json`); never mix in pnpm or yarn. `cd ui; npm install`, run with
  `npm run dev` (port 5180, `/api` proxied to the server).
- `strict` mode stays on; a new dependency is a decision in the plan.

## Layout and naming

- `camelCase` variables and functions; `PascalCase` types and components; `UPPER_SNAKE` for
  true constants (`MAX_PLAYERS`, `SETTINGS`).
- File names `camelCase.ts` under `ui/src/lib/`: game rules in `game/`, 3D models in
  `models/`, networking in `net/`.
- ES modules (`import` / `export`); named exports, no default export unless Svelte needs one.

## Types

- No `any`; use `unknown` and narrow it.
- Type every exported function's parameters and return value.
- `type` aliases and union types (`'home' | 'match' | …`), not enums.
- Validate data at the boundary (server responses, WebSocket messages, `localStorage`, URL
  parameters, scanned QR codes) before trusting its type.

## Errors and async

- `async` / `await` or `.then().catch()`, never unhandled promises; a failure the player
  should know about is shown on screen ("Cannot reach the Hack star server.").
- Throw `Error` objects with a clear message; never throw strings.
- No `console.log` left in committed code.

## Comments

- Comments say *why*; types and names say *what*.

## Tests

- Vitest; files `<name>.test.ts` next to the code; run with `cd ui; npm test`.
- Game rules are plain functions in `game/`, so they can be tested without the 3D scene.
- Every Step that changes behaviour adds or updates a test that would fail without it.

## Checks before a Step is done

- `npm run check`, `npm test` and `npm run build` pass.
