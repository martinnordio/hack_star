### Semantic diff
13 worlds in three sizes, unlocked with world coins (per 500 trophies or 30-day hack codes) · checks 8 pass · 1 n/a · 0 fail · findings 7

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/worlds-and-world-coins/.specs/review/2026-11-18_feature-worlds-and-world-coins.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | World screen | added | S1, S3, S8, S11–S13, S22, S23 |
| ui | Home header, result line (manual), hack screen, QR page, friends' lobby | modified | S7–S9, S14–S16, S18, S22, S23 |
| ui | /?gallery=worlds | added | S4, S5, S23 |
| output | WORLDS / arenaFor, world-coin earning, world shop | added | S1–S5, S9–S13 |
| output | buildArena looks (Canyon unchanged), bot seek rule, two-tab merge | modified | S4–S6, S13, S19, S21, S23 |
| data-format | Saved progress v8 (migration, reset) | modified | S8, S19–S21 |
| schema | Room start `settings.world`, member `version` | modified | S7 |
| output | Server removal outside Canyon Small (`removed`) | added | S7 |
| api | GET /api/hacks, POST /api/hacks/redeem | modified | S14, S15, S17, S18 |
| config | SETTINGS world numbers, world_codes.py | added | S9, S11, S12, S14, S15, S17 |
| config | .specs/spec-nx.json models | modified | — |
| message | New texts in five languages | added | S4, S22 |
| output | README and docs/architecture.md | modified | S24 |

**Top findings:**
1. Should-fix — two stale tabs winning the same 500-step pay it twice (500 world coins for one step; `mergeProgress` has no refund for `worldSteps`).
2. Should-fix — after 6 s bots walk to a player hiding in a bush, also in Canyon Small; D5 needs a decision.
3. Nit — "works again on <date>" ignores the time of day the code was used.
