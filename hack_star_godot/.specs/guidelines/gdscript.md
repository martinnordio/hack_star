# GDScript - project guideline

> Rules for the GDScript of `hack_star_godot/` (Godot 4.7, GDScript only). Style follows the
> [official GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html);
> `gdformat` (gdtoolkit 4.5.0) decides the layout, `gdlint` the rest.

## Types

- Static types everywhere: `var speed: float = 4.0`, `func step(delta: float) -> Vector3:`,
  typed arrays (`Array[Node3D]`). No untyped `var x = ...` unless the type is obvious from
  `:=`.
- Exported and constant values have a type and a name that says the unit when it is not
  obvious (`speed_per_second`).

## Naming

- Files, functions, variables, signals: `snake_case` (`touch_joystick.gd`, `move_left`).
- Classes (`class_name`) and nodes in scenes: `PascalCase`; constants: `UPPER_SNAKE_CASE`.
- A script has the name of its scene (`arena.tscn` + `arena.gd`).

## Structure

- **`game/`: rules without scene access.** Plain scripts (`extends RefCounted`, static
  functions) with no `get_node`, no `Input`, no `Engine` calls; they take values and return
  values, so a test can call them without a scene.
- **One scene per screen** in `scenes/`, with the script next to it; scenes read the input
  and call `game/` rules, they do not hold the rules.
- **Tests in `tests/`**, one file per rule or scene (`test_movement.gd` checks
  `game/movement.gd`), GUT 9.7.1, headless through `tools/test.ps1`.
- Art is built in code from primitive meshes and plain materials; no imported models or
  textures. The only files are the display font in `assets/fonts/` and the icons in
  `assets/icons/` (free licences, pinned; see `LICENSES.md`).

## Checks

- `tools/lint.ps1` (`gdlint` and `gdformat --check` on `game/`, `scenes/`, `tests/`; not
  `addons/`) and `tools/test.ps1` pass before a Step is done.
