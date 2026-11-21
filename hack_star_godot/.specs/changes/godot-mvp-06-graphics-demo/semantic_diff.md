### Semantic diff — spec 06 Graphics Demo (#30)
A playable canyon arena: the selected fighter runs and shoots at three dummies, with bushes and effects · checks 6 pass · 3 n/a · 0 fail · findings 6 (1 blocking, 2 should-fix, 3 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-06-graphics-demo.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Arena: canyon, selected fighter, following camera, aim stick | modified | S1–S3, S7, S9, S11, S13 |
| ui | Shots, target dummies, bushes and effects | added | S4–S6, S8, S12 |
| output | Combat rules (`Combat`), `ArenaLayout`, `Movement.follow` | added | S4, S5, S7, S11 |
| output | `Shot` fired point-blank at a wall, a rock or a dummy | added | S4, S5 |
| config | Physics layers world / fighter / targets (D13) | modified | S3, S4 |
| performance | Arena ready 81 → 249 ms, 60 → 59.8 fps (windowed desktop) | modified | S10 |

`server/` and `ui/` unchanged; no server call, nothing saved.

**Top findings:**
- A shot fired with the fighter against a wall, a rock or a dummy passes through it (out of the arena at the border). Blocking, fix now.
- Steps 3 and 4 have no Started / Done lines and no record of their screenshot checks. Fix now.
- Step 8's browser check (S10: playable within 5 s after Play) is open although the Step is ✅. Needs a plan decision.
