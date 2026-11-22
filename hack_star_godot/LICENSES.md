# Licences of the Godot game

Hack star's Godot folder uses only original work or work with a free licence, as the root game
does ([ui/public/assets/LICENSES.md](../ui/public/assets/LICENSES.md)): own work, one free font
and free icons (below). Nothing is imported from other games.

## Own work

| Asset | Source | Licence |
|-------|--------|---------|
| Arena, walls, floor, fighter, touch joystick | Built in code from Godot's primitive meshes (box, capsule, sphere) and plain materials; no imported models, textures or sounds | MIT, as the repository ([LICENSE](../LICENSE)) |
| Icons coin, bolt, clock, world, eye | Drawn in code at start-up (`scenes/ui/icons.gd`); the pack below has no such icon | MIT, as the repository |
| Scripts, scenes, tests, tools | Written for this project | MIT, as the repository |

The body text uses Godot's default font, built into the engine (see Godot Engine below); the
title, headings, buttons and numbers use Lilita One (below).

## Fonts and icons

| Asset | Where | Source and version | Licence | SHA-256 |
|-------|-------|--------------------|---------|---------|
| **Lilita One** 1.002 (display font), © 2011 Juan Montoreano, Reserved Font Name "Lilita One" | `assets/fonts/LilitaOne-Regular.ttf`, with its licence [OFL.txt](assets/fonts/OFL.txt) | [google/fonts `ofl/lilitaone/`](https://github.com/google/fonts/tree/0b03411188731f960e8fa7064e940407ade0e6d4/ofl/lilitaone) at commit `0b03411` (2026-11-04), downloaded 2026-11-22; version from the font's name table; pinned in `tools/versions.json` (`font_lilita_one`) | [SIL Open Font License 1.1](assets/fonts/OFL.txt) | `f5b641c45c69d772ee4eda687bc9fda411d5cad6b0b45371491da4580cbc8d59` (TTF) |
| **Game Icons** by Kenney (14 of its 105 icons, white, 100 px: `right`, `trophy`, `multiplayer`, `singleplayer`, `information`, `wrench`, `arrowLeft`, `home`, `gear`, `target`, `locked`, `checkmark`, `cross`, `star`) | `assets/icons/*.png`, with Kenney's [License.txt](assets/icons/License.txt) | Kenney's upload on [OpenGameArt](https://opengameart.org/content/game-icons) of 2014-11-03 (`Kenney_gameIcons.zip`, folder `PNG/White/2x`), downloaded 2026-11-22 (kenney.nl was not reachable from the author's network; the pack has no version number, so the upload date is pinned in `tools/versions.json`, `kenney_game_icons`); unchanged | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) — no credit needed; credited anyway | `7a86d8d58e0b851e22004b3c70bf90b003632bbf9ac633424daa3bb17d9e7e4e` (zip) |

## Third-party software in the folder

| Component | Where | Licence | Copyright |
|-----------|-------|---------|-----------|
| Godot Engine 4.7.2 | Installed on the computer, not in the repository; its code is part of every exported game | [MIT](https://godotengine.org/license) | © Godot Engine contributors (Juan Linietsky, Ariel Manzur and contributors) |
| GUT 9.7.1 (test tool) | `addons/gut/`, with its [LICENSE.md](addons/gut/LICENSE.md) | MIT | `Copyright (c) 2018 Tom "Butch" Wesley` |
| ProtonScatter 4.2.0 (editor tool that places the Glimmer Isles props) | `addons/proton_scatter/`, with its [LICENSE](addons/proton_scatter/LICENSE); unchanged except that `demos/` and `tests/` are left out (not used); pinned in `tools/versions.json` (`protonscatter`) | MIT | `Copyright (c) 2019 HungryProton` — [Godot Asset Store](https://store.godotengine.org/asset/hungryproton/protonscatter/) download of version 4.2.0 (2026-07-28), downloaded 2026-11-22; [source](https://codeberg.org/hungryproton/proton_scatter); zip SHA-256 `ea971151188dfa33ad78c0a53058cfdfdc0a97e4d310641a14dfefe9b5e0e449` |
| Fonts of GUT (Anonymous Pro, Courier Prime, Lobster Two) | `addons/gut/fonts/`, with [OFL.txt](addons/gut/fonts/OFL.txt) | SIL Open Font License 1.1 | `Copyright (c) 2009, Mark Simonson` for Anonymous Pro (the licence file names only this font) |
| jsQR 1.4.0 (QR decoder of the camera scanner, the library of the Svelte game) | `web/jsQR.js`, unmodified with a licence header, and its [licence](web/jsQR-LICENSE.txt); copied into the web export | [Apache-2.0](https://github.com/cozmo/jsQR/blob/master/LICENSE) | © Cosmo Wolfe and the jsQR contributors |

GUT and ProtonScatter are excluded from the exported game (`exclude_filter` in
`export_presets.cfg`); GUT runs only in the tests and in the editor, ProtonScatter only in the
editor and in the bake tool — the game loads only its baked result. `web/qr_scanner.js`, the camera scanner around jsQR, is own work
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
