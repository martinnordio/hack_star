# AGENTS.md

Instructions for every AI assistant and developer working in this repository.

## Two games, two spec folders

| Game | Lives in | Specs in | Checks |
|------|----------|----------|--------|
| Python + Svelte (the existing game) | `server/`, `ui/` | `.specs/` | `cd server; uv run pytest`, `cd ui; npm test`, `npm run check`, `npm run build` |
| Godot (re-implementation) | `hack_star_godot/` | `hack_star_godot/.specs/` | `hack_star_godot/tools/test.ps1`, `lint.ps1`, `export_web.ps1`, `check_tools.ps1` |

A developer can tell from a spec's path which game it belongs to. The kit in `.specs/kit/` is
shared by both games; there is no kit inside `hack_star_godot/`.

## Python + Svelte specs

Work as always: specs in `.specs/features/`, the kit's prompts and checks, `server/` and `ui/`.

## Godot specs

When a spec is for the Godot game (it lives, or must live, in `hack_star_godot/.specs/`):

- **Create and keep it in `hack_star_godot/.specs/features/`** (`features/done/` once closed).
  A new Godot spec never goes into the root `.specs/`.
- Write `changes/`, `review/`, `costs.md` and `features/done/` under `hack_star_godot/.specs/`,
  never in the root `.specs/`.
- Use the root kit's prompts (`.specs/kit/`), but replace the Python and Svelte parts:
  - guideline: `hack_star_godot/.specs/guidelines/gdscript.md` (GDScript, Godot 4.7);
  - checks: `hack_star_godot/tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1` (and
    `tools/check_tools.ps1` for the pinned tools) instead of `pytest` / `npm`;
  - run, install and export steps: `hack_star_godot/README.md`.
- Costs: run `.specs/kit/tools/usage.ps1` from the **repository root**; build the Godot cost
  list with `.specs/kit/tools/costs_ledger.ps1 -Root hack_star_godot -CostsLink ../../.specs/kit/COSTS.md`.
  `hack_star_godot/.specs/spec-nx.json` holds only a copy of the root `cost` block; keep the two
  equal.
- Nothing of the Python + Svelte game changes for a Godot spec.
