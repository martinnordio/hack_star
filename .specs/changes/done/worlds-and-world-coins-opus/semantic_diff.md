### Semantic diff
13 worlds in three sizes, unlocked with world coins earned per 500 trophies or from 30-day hack codes · checks 7 pass · 2 n/a · 0 fail · findings 4

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/worlds-and-world-coins-opus/.specs/review/2026-11-16_feature-worlds-and-world-coins-opus.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| data-format | saved progress v8 | modified | S19, S20, S21 |
| output | world catalogue and `arenaFor` | added | S2–S5 |
| output | `buyWorld`, `growWorld`, `earnWorldCoins` | added | S9–S13 |
| config | `SETTINGS` world-coin keys | modified | S9, S11, S12, S17 |
| output | bot that sees nobody | modified | S6 |
| message | room start settings (`world`) | modified | S7 |
| schema | room `Member` (`version`) | modified | S7 |
| message | start outside Canyon Small with an older friend | modified | S7 |
| api | `GET /api/hacks`, `POST /api/hacks/redeem` | modified | S14, S17, S18 |
| output | `useWorldCode` | added | S15, S16, S21 |
| ui | Home | modified | S8 |
| ui | `/?gallery=worlds` | added | S4, S5, S23 |
| ui | world screen (manual) | added | S1, S3, S8, S11, S13, S22, S23 |

**Top findings:** a v8 save with an unknown world id is refused whole (should-fix, deferred) · bots that hunt after 6 s also find fighters hiding in bushes (should-fix, plan decision)
