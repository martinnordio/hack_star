# Svelte — baseline

> Rules for Svelte 5 (runes) components in `ui/src/`, built with Vite (no SvelteKit), used
> together with `typescript.md`. `.specs/guidelines/svelte.md` wins over this file.
> Reference: [Svelte docs](https://svelte.dev/docs/svelte).

## Files

- `ui/src/App.svelte` chooses the screen with its `screen` state — there is no router.
  Screens and parts are in `ui/src/lib/`, named
  `PascalCase.svelte`, one component per file; order: `<script lang="ts">`, markup, `<style>`.
- 3D scenes use Threlte (`@threlte/core`, `@threlte/extras`) with models from
  `ui/src/lib/models/`.

## Reactivity (runes)

- `$state` for local state; `$derived` (or `$derived.by`) for computed values — no side
  effects in it.
- `$props()` with typed props; `$bindable()` only for real two-way binding.
- `$effect` only for side effects after render (DOM, timers, subscriptions); return a clean-up
  when needed. Never use it to compute state.
- Shared state (accounts, settings, texts) lives in the existing stores in `ui/src/lib/`
  (`svelte/store`), read with `$store`; follow them instead of adding a second mechanism.
- No legacy syntax in new code: `export let`, `$:`, `on:` directives, `<slot>`,
  `createEventDispatcher`.

## Events and composition

- Event attributes (`onclick={…}`); component events are callback props (`onBack`).
- Snippets (`{#snippet}` / `{@render}`) instead of slots.

## Text

- Visible text through `$t('<key>')` from `./i18n`; new keys in every language file.

## Styling

- Scoped `<style>`; `style:` directives (or `style=`) only for values computed at run time
  (colours of a fighter, positions), preferably as CSS custom properties (`style:--rarity`)
  that the scoped rules use. `:global(…)` only with a reason.
- Every screen works with mouse and touch, on desktop, tablet and phone, in portrait and
  landscape; respect the safe-area insets.

## Accessibility

- Semantic elements, a label for every input, `aria-label` on icon buttons, everything usable
  with the keyboard. The compiler's accessibility warnings stay at zero.

## Checks before a Step is done

- `cd ui; npm run check` and `npm test` pass; the screen renders without console errors in
  `npm run dev`.
