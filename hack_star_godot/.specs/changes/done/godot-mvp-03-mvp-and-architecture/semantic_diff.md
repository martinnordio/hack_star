### Semantic diff — spec 03 MVP and Architecture (#27)
Architecture document, MVP scope and screen-size tests for the Godot game · checks 6 pass · 3 n/a · 0 fail · findings 7 (0 blocking, 4 should-fix, 3 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-03-mvp-and-architecture.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Start-screen title (`scenes/start_screen.tscn`, font 96 → 72) | modified | S2 |
| output | Screen-size and button-input checks (`tests/test_screen_sizes.gd`) | added | S2, S3, S11 |

Documents (no record block): `docs/architecture.md` (new), `README.md`, `.specs/features/README.md`. `server/` and `ui/` unchanged (S15).

**Top findings:**
- The "touch" tests send a mouse click; no touch event is exercised (S3) — fix now.
- The SubViewport tests skip the project's `canvas_items` stretch, so the title shrink fixes a cut-off no player sees — plan decision.
- `docs/architecture.md` still says the Step 2 tests are planned — fix now.
