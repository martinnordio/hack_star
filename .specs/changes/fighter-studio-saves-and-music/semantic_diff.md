### Semantic diff
More creator parts, created-fighter skins, safer saves, the account-name fix, and locally chosen music with credits · checks 6 pass · 2 n/a · 1 fail · findings 3

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/fighter-studio-saves-and-music/.specs/review/2026-11-14_feature-fighter-studio-saves-and-music.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| message | created-fighter look id in room messages | modified | S1, S17 |
| data-format | `hack-star.accounts` progress v7 | modified | S10, S12, S13 |
| output | created fighter's skins (add, change, delete, wear) | added | S5, S6, S7 |
| ui | creator (new fighter and skin mode) | modified | S1–S4, S29, S30 |
| ui | created fighter's screen with its skins | modified | S5, S6, S29, S30 |
| output | account name after rename / switch | modified | S8, S9 |
| message | saving notice and persistent storage | added | S11, S14, S15, S29 |
| config | `hack-star.options` (music, track, developer) | modified | S10, S18, S24 |
| output | music in a match | added | S19 |
| ui | Settings | modified | S18, S23, S24, S29, S30 |
| ui | About panel | added | S23, S29, S30, S33 |
| ui | developer page `/?dev` (Music) | added | S24–S28, S33 |
| api | dev server `/__dev/music` | added | S26, S27, S32 |
| output | allowed licences, licence links, choose limit | added | S20, S22, S33 |
| config | git-ignored music files, `LICENSE` access | added | S23, S32 |

**Top findings:**
1. Should-fix · the dev server's GET `/__dev/music/list` and `/file/…` answer Wi-Fi devices too; only changes are limited to this computer.
2. Should-fix · S30 checked only headless; real iPad / phone checks moved to spec 5.
3. Nit · `/__dev/music` middleware has no test (C7).
