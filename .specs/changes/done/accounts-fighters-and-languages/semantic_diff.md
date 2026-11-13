### Semantic diff
Own accounts, a designed fighter, more fighters and skins, five languages · checks 7 pass · 2 n/a · 0 fail · findings 5

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/accounts-fighters-and-languages/.specs/review/2026-11-13_feature-accounts-fighters-and-languages.html) — download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| data-format | localStorage hack-star.accounts (accounts with progress v4) | added | S1, S2, S4, S5, S20, S23 |
| output | resetProgress(progress) | added | S6 |
| ui | Home screen + accounts panel | modified | S1, S2, S3, S21, S23 |
| ui | Settings screen | modified | S6, S18, S20, S21 |
| ui | Fighter list entry + Create a fighter screen | added | S7, S8, S9, S10, S24 |
| ui | /?qr print page | modified | S13 |
| api | GET /api/fighters | modified | S14, S15 |
| api | GET /api/hacks, POST /api/hacks/redeem | modified | S11 |
| schema | Room member (WS /api/rooms) | modified | S12, S22 |
| message | Every player-visible text in en, de, gsw, es, it | added | S18, S19, S20 |
| config | SETTINGS.recreateCost | added | S24 |
| performance | Frames per second, match with 5 bots | modified | S17 |
| command | Kit commands IMPLEMENT:, CLOSE:, REVIEW:, CODE REVIEW: | added | — |

**Top findings:** visual checks of new fighters, skins and screens still open (Should-fix) · cloned 3D materials not disposed (Nit) · plan decisions D8/D11/D14 outdated (Nit)
