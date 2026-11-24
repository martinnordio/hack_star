### Semantic diff — spec 09 Better Graphics (#35)
The Svelte game's outlined look everywhere, a second world (ProtonScatter, baked), Mattia's drawing as a fighter · checks 6 pass · 2 n/a · 1 fail · findings 10 (2 should-fix, 8 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/better-graphics/hack_star_godot/.specs/review/2026-11-22_better-graphics.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Home: gradient, pedestal, logo, coloured icon buttons, big yellow **Play**, chips | modified | S6 (G2–G6, G18) |
| ui | World choice on home (Canyon / Glimmer Isles, for Play and Training) | added | S2 (W2) |
| ui | Fighter list and fighter screen: rarity backdrops, lock, chips, skin pictures | modified | S6 (G7, G8) |
| ui | Beatbolt, the fighter from Mattia's drawing | added | S2, S4 (A2–A5) |
| ui | Training and a match: outlined toon canyon, thin near wall, HUD chips | modified | S2 (G9–G12) |
| ui | Glimmer Isles in Training | added | S4 (W1, W3, W4) |
| ui | Info (Show FPS switch) and Hack screens in the new look | modified | S6 (G13) |
| output | 7 fighters (Beatbolt unlocked), `ArenaLayout.use`, `Hacks.credits_amount` | modified | S2 |
| data-format | Save file version 3 with a `beatbolt` entry; world and FPS switch not saved | modified | S2 |
| command | `tools/check_tools.ps1` checks ProtonScatter; new `tools/bake_world.ps1` | modified / added | S3 |
| dependency | ProtonScatter 4.2.0 (editor only), Lilita One, Kenney Game Icons | added | S4 (W6) |
| tokens | Theme: display font, coloured buttons, chips | modified | S6 |
| performance | Web export +0.16 MB (budget 5 MB) | modified | S3 (G15) |

`server/`, `ui/` unchanged; deferred to the author: G1, A3, G14/W5, B6.

**Top findings:**
- `docs/architecture.md` does not list the five new look tests. Should-fix, fix now.
- G11 (near wall ≤ 10 %) is tested only in the canyon, not in Glimmer Isles. Should-fix, fix now.
- Step 16's Done line renders as a heading (no blank line before `---`). Nit, fix now.
