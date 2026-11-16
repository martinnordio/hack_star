### Semantic diff
13 worlds in three sizes, world coins and ten world-coin codes, a world screen, worlds in rooms · checks 6 pass · 3 n/a · 0 fail · findings 6 (0 blocking)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/worlds-and-world-coins-sonnet/.specs/review/2026-11-16_feature-worlds-and-world-coins-sonnet.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| data-format | Saved progress, version 7 to 8 | modified | S8, S19, S20, S21 |
| api | GET /api/hacks, POST /api/hacks/redeem | modified | S14, S15, S17, S18 |
| message | Room start message and member version | modified | S7 |
| config | SETTINGS: world coin numbers | added | S9, S11, S12, S17 |
| ui | World screen, Home chip, result line | added | S1, S3, S8, S9, S11, S12, S13, S22, S23 |
| output | arenaFor(worldId, size) | added | S2, S4, S5, S6 |

**Top findings:** two tabs reaching the same 500-trophy step both add 250 world coins (should-fix, deferred); the chosen world is not re-checked as unlocked when a match starts (should-fix, deferred); Large worlds not measured on a real iPad (should-fix, deferred).
