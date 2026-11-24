### Semantic diff — spec 09 Better Graphics, reopened twice more (#35)
Animated characters (MagMax new), the Glimmer Isles palette pack, colour variations on C, eight camera views and Beatbolt2 · checks 6 pass · 3 n/a · 0 fail · findings 12 (0 blocking, 3 should-fix, 9 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/better-graphics/hack_star_godot/.specs/review/2026-11-23_better-graphics-3.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Glimmer Isles in the author's palette and materials (default Glimmer, Bright day) | modified | S2, S4 (P2–P6) |
| ui | Glimmer Isles' Classic preset: the pack's environment as delivered | modified | S2 (P4) |
| ui | Colour variations on C: Original, Glimmer, Lagoon, Glow night | added | S2 (H1–H4) |
| ui | Views Low, Side, Diagonal, Cinematic; controls and facing by the screen | added | S2 (X1–X5) |
| ui | Echo, Flarekid, MagMax animated in play, on the pedestal and on cards | modified | S2, S4 (M1–M10) |
| ui | Beatbolt2, Echo rebuilt in 3D from shapes | added | S2, S4 (E1–E6) |
| output | 11 fighters, 8 views, 4 colour variations | modified | S2 |
| config | Input actions `view_5`–`view_8`, `colour_next` | modified | S2 (X2, H1) |
| data-format | Save file version 3 with `magmax` and `beatbolt2` | modified | S2 |
| config | Export `exclude_filter` and `.gitignore` | modified | S3, S4 (M12, P8) |
| performance | Web export +2.23 MB (43,477,611 bytes, 1.88 MB under G15) | modified | S3 (M14, E7) |
| command | Kit tools after the regeneration (not spec 09) | modified | S5 |

`server/`, `ui/` unchanged; the kit regeneration (325b5a1, a268200) rides in this pull request.

**Top findings:**
- In the default (Glimmer, Bright day) the light floor tiles and the border tops render pure white. Should-fix, fix now.
- P4: the pack's sky is not seen in Bright day — Low sees the preset's blue. Should-fix, plan decision.
- L8's "every frame under 33 ms" is not met in Steps 40 and 45's warm runs. Should-fix, plan decision.
