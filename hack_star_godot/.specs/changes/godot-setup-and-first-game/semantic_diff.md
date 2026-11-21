### Semantic diff
Godot folder, pinned tools and a first browser game; Copilot CLI costs measured · checks 6 pass · 2 n/a · 1 fail · findings 10

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-setup-and-first-game/hack_star_godot/.specs/review/2026-11-21_feature-godot-setup-and-first-game.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | start-screen | added | S9 |
| ui | arena | added | S10, S11 |
| output | movement-rule | added | S10, S12, S16 |
| command | test-command | added | S12 |
| command | lint-command | added | S12 |
| command | check-tools-command | added | S5, S6 |
| command | export-web-command | added | S11, S13 |
| command | serve-web-command | added | S11 |
| config | project-settings | added | S9, S10, S16, S17 |
| config | web-export-preset | added | S11, S17, S18 |
| config | ignored-files | added | S7, S13 |
| dependency | godot-toolchain | added | S6, S12, S13, S16, S17 |
| dependency | spec-nx-submodule | modified | S4 |
| command | godot-spec-rule | modified | S2, S4, S15 |
| output | usage-cost | modified | S4 |
| command | usage-command | modified | S4 |
| command | stage-cost-rules | modified | S4 |

**Top findings:** S11 iPad check not done (deferred) · test.ps1 loses GUT output on stderr in PowerShell 5.1 · no test of the touch joystick's input handling
