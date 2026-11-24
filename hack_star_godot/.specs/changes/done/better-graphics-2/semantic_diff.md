### Semantic diff — spec 09 Better Graphics, reopened (#35)
Two picture fighters (Flarekid, Echo), a reveal on the pedestal, four camera views, brighter worlds and lighting presets · checks 6 pass · 3 n/a · 0 fail · findings 5 (1 should-fix, 4 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/better-graphics/hack_star_godot/.specs/review/2026-11-22_better-graphics-2.html)
— download it and open it in a browser (first round: [2026-11-22_better-graphics.html](https://github.com/martinnordio/hack_star/raw/feature/better-graphics/hack_star_godot/.specs/review/2026-11-22_better-graphics.html))

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Home and fighter screen: every fighter pops in with sparks and a rarity halo | modified | S6 (C3) |
| ui | Flarekid and Echo: outlined picture fighters on home, cards, fighter screen | added | S4, S6 (C1, C2, C4, C6) |
| ui | Matches in both worlds: brighter, new decoration, hint names V, 1-4, L, K | modified | S2 (L1, L2, V7) |
| ui | Camera views Close, Behind, Overview with a toast | added | S2 (V1-V6) |
| ui | Lighting presets and the saturation boost | added | S2 (L3-L7) |
| output | 9 fighters (Flarekid, Echo unlocked); view, preset, boost in memory | modified | S2 |
| config | Input actions `view_next`, `view_1`-`view_4`, `light_next`, `saturation_boost` | modified | S2 (V2, L3, L4) |
| data-format | Save file version 3 with `flarekid` and `echo` entries | modified | S2 |
| config | `.gitignore` and export `exclude_filter` keep the delivery's extras and the author's newer art out | modified | S3, S4 (C10, D31) |
| performance | Web export +0.73 MB (pictures 0.67 MB; budget C11 1.0 MB, G15 5 MB) | modified | S3 (C11) |

`server/`, `ui/` unchanged; deferred to the author: the iPad check (L8), the image tool (C9), more art (C8), touch views (V6).

**Top findings:**
- In Overview a picture fighter's health bar shows under him in the lower half of the screen. Should-fix, fix now.
- Glimmer Isles' crystal pulse changes the shared cached toon material. Nit, fix now.
- The ordered list still says *planned* for spec 09. Nit, fix now.
