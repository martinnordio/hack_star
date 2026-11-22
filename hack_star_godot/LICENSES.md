# Licences of the Godot game

Hack star's Godot folder uses only original work or work with a free licence, as the root game
does ([ui/public/assets/LICENSES.md](../ui/public/assets/LICENSES.md)). Nothing is imported
from other games or artists.

## Own work

| Asset | Source | Licence |
|-------|--------|---------|
| Arena, walls, floor, fighter, touch joystick | Built in code from Godot's primitive meshes (box, capsule, sphere) and plain materials; no imported models, textures or sounds | MIT, as the repository ([LICENSE](../LICENSE)) |
| Scripts, scenes, tests, tools | Written for this project | MIT, as the repository |

The text on the start screen and the buttons uses Godot's default font, built into the engine
(see Godot Engine below).

## Third-party software in the folder

| Component | Where | Licence | Copyright |
|-----------|-------|---------|-----------|
| Godot Engine 4.7.2 | Installed on the computer, not in the repository; its code is part of every exported game | [MIT](https://godotengine.org/license) | © Godot Engine contributors (Juan Linietsky, Ariel Manzur and contributors) |
| GUT 9.7.1 (test tool) | `addons/gut/`, with its [LICENSE.md](addons/gut/LICENSE.md) | MIT | `Copyright (c) 2018 Tom "Butch" Wesley` |
| Fonts of GUT (Anonymous Pro, Courier Prime, Lobster Two) | `addons/gut/fonts/`, with [OFL.txt](addons/gut/fonts/OFL.txt) | SIL Open Font License 1.1 | `Copyright (c) 2009, Mark Simonson` for Anonymous Pro (the licence file names only this font) |
| jsQR 1.4.0 (QR decoder of the camera scanner, the library of the Svelte game) | `web/jsQR.js`, unmodified with a licence header, and its [licence](web/jsQR-LICENSE.txt); copied into the web export | [Apache-2.0](https://github.com/cozmo/jsQR/blob/master/LICENSE) | © Cosmo Wolfe and the jsQR contributors |

GUT is excluded from the exported game (`exclude_filter` in `export_presets.cfg`); it runs only
in the tests and in the editor. `web/qr_scanner.js`, the camera scanner around jsQR, is own work
(MIT).

## Tools, not shipped

- **gdtoolkit 4.5.0** (`gdlint`, `gdformat`), installed with `uv` on the computer for the lint
  check. It is not in the repository and not in the exported game.
- **uv** and **Python** (for the local web server in `tools/serve_web.ps1`). Not in the
  repository and not in the exported game.

## Music

The Godot folder has no music. Developers may add tracks in `assets/music/` on their own
computer; they are git-ignored and never committed. The rules are in the README
(**Resources outside the folder**) and in
[ui/public/assets/LICENSES.md](../ui/public/assets/LICENSES.md).
