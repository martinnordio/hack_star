# Svelte — baseline

> Rules for the Hack star UI: Svelte 5 (runes) with Vite and Threlte — **no SvelteKit**. Used
> together with `typescript.md`. `.specs/guidelines/svelte.md` wins over this file.
> Reference: [Svelte docs](https://svelte.dev/docs/svelte), [Threlte docs](https://threlte.xyz/docs).

## Files

- Components `PascalCase.svelte` in `ui/src/lib/`, one per file; order: `<script lang="ts">`,
  markup, `<style>`.
- Screens are chosen in `ui/src/App.svelte` (`screen` state), not by a router.
- 3D scenes are Threlte components (`ArenaScene.svelte`, `HomeScene.svelte`); models are built
  in `lib/models/`.

## Reactivity (runes)

- `$state` for local state; `$derived` (or `$derived.by`) for computed values — no side
  effects in it.
- `$props()` with typed props; `$bindable()` only for real two-way binding.
- `$effect` only for side effects after render (DOM, subscriptions, sockets); return a
  clean-up when needed. Never use it to compute state.
- Shared state that outlives a screen (progress, options, room) lives in the existing
  `svelte/store` modules (`progress.ts`, `options.ts`, `net/room.ts`); follow them.
- No legacy syntax in new code: `export let`, `$:`, `on:` directives, `<slot>`,
  `createEventDispatcher`.

## Events and composition

- Event attributes (`onclick={…}`); component events are callback props (`onStart`,
  `onLeave`).
- Snippets (`{#snippet}` / `{@render}`) instead of slots.

## Styling

- Scoped `<style>`; `:global(…)` only with a reason. Per-item colours go through CSS custom
  properties (`style="--rarity: …"`), not inline styles for whole rules.
- Every screen works on desktop, iPad and phone, portrait and landscape, with touch and with
  mouse/keyboard; respect the safe-area insets.

## Accessibility

- Semantic elements, a `<label>` for every input, alt text or `aria-label` for images and
  icon buttons. The compiler's accessibility warnings stay at zero.
- Emojis in the UI are written literally in the source (never as surrogate escapes).

## Checks before a Step is done

- `npm run check` and `npm test` pass; the screen renders without console errors.
