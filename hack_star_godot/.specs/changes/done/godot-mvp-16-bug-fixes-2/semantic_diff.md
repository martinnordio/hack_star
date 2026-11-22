### Semantic diff — spec 16 Bug Fixes, the author's reports (#33)
Scan only where it works, Space shoots (the mouse no longer), How to play on Info and a start hint · checks 6 pass · 3 n/a · 0 fail · findings 5 (0 blocking, 3 should-fix, 2 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-22_godot-mvp-16-bug-fixes-2.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Hack screen in the desktop run: **Scan QR code** disabled, `ScanHint` "Camera scanning works in the browser version — type the code here" | modified | S26, S6, S23 |
| output | Firing in Training: Space → 1 shot at the dummy 1 m west; a left click → no shot (before: 0 and 1) | modified | S28, S29 |
| config | Input map: new action `shoot` (Space); the arena's **Back** `focus_mode` FOCUS_NONE | modified | S28, S29 |
| ui | Info page: "How to play" (five sections) before the words | modified | S30, S6, S23 |
| ui | Training and a match at the start: the controls hint, faded after 5 s | modified | S31, S6 |
| message | `ControlsHelp`: the start hint and the How to play texts, numbers from the rules | added | S30, S31, S23 |

`server/` and `ui/` unchanged; the save file is unchanged. A left click no longer fires (by request).

**Top findings:**
- Step 10 removed `test_save_tabs.gd` from the test list of `docs/architecture.md`. Should-fix, fix now.
- The spec's Stage log is broken by lone CR line breaks (Steps 9 and 10 render as text, the Cost summary heading is lost). Should-fix, fix now.
- The touch position of the start hint has no test and was not seen on a screenshot. Should-fix, fix now.
