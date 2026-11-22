### Semantic diff — spec 08 Trophies and Prestige (#32)
A win gives the played fighter +10 trophies with a Prestige celebration, and the whole progress is saved between visits · checks 7 pass · 2 n/a · 0 fail · findings 7 (0 blocking, 2 should-fix, 5 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-08-trophies.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Result screen: trophy change, count, bar to the next Prestige, "PRESTIGE 2!" | modified | S4, S5, S12, S13 |
| output | Trophy rules: `Trophies`, `Prestige.floor_of` / `next_at`, trophy settings | modified | S1, S2, S5, S6, S8 |
| output | End of a match: +10 for Blaze, `last_result.reward`, saved at once | modified | S1, S3, S7 |
| data-format | Save file `hack_star_save.json`: version 1 (hacks) → 2 (hacks and progress) | modified | S3, S11 |
| output | A new game start: trophies and the chosen fighter come back | modified | S3, S11, S13 |
| config | `TROPHIES_PER_WIN` 10, `TROPHIES_PER_DEFEAT` 0; tests save to `user://test/run_save.json` | modified | S8, S13 |
| tokens | Theme `ProgressBar` styles (dark track, Legendary-gold fill) | added | S4 |

`server/` and `ui/` unchanged; no server call. A build of specs 05–07 treats a version 2 file as newer.

**Top findings:**
- A fighter chosen through the unlock-all hack is not restored after a restart (`load_saved` checks the unlocked list, not `is_unlocked`). Should-fix, plan decision.
- `finish_count()` comment and `docs/architecture.md` promise a tap-to-skip that does not exist. Should-fix, fix now.
- The GUT pre-run hook is only passed by `tools/test.ps1`; GUT started another way can write the player's save file. Nit, plan decision.
