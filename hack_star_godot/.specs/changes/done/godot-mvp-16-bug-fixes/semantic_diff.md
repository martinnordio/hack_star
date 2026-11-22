### Semantic diff — spec 16 Bug Fixes (#33)
Hacks last 3 days (POWER22 for ever) with the time left shown, a locked fighter is never chosen or played, and the web tabs share one save · checks 7 pass · 2 n/a · 0 fail · findings 5 (0 blocking, 3 should-fix, 2 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-16-bug-fixes.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Hack screen: each active hack with its time left ("· 1 day 19 hours left", "· Lasts for ever") | modified | S6, S18, S23 |
| output | Hack time rules: `duration_seconds`, `until_for`, `is_expired`, `time_left_text` | added | S16, S17, S18, S23 |
| data-format | Save: version 2 (hack ids) → 3 (`{"id", "until"}` and `revision`); version 1 and 2 files migrated | modified | S16, S17, S25 |
| output | A hack turning off after 3 days and **Turn all hacks off**: the chosen fighter stays usable | modified | S16, S19, S22 |
| output | End of a match: the trophies go to the fighter the match started with | modified | S22 |
| output | Two tabs on one save: a hack from one tab is kept when the other saves; sync at the front | modified | S4 |
| config | `TIMED_SECONDS` 3 days, expiry check 30 s, hack screen refresh 60 s, `VERSION` 3, web key `hack_star_save` | modified | S4, S16, S18 |

`server/` and `ui/` unchanged. A build of specs 05–08 treats a version 3 save as newer; the web save moves from `user://` to `localStorage` (copied once).

**Top findings:**
- A hack turned off in one tab comes back when another tab saves before it syncs (the merge is a union). Should-fix, plan decision.
- The fighter screen does not refresh its trophies and Prestige badge on `progress_changed` (S4). Should-fix, fix now.
- The 30 s expiry timer and the focus / `visibilitychange` triggers have no test (D8). Should-fix, fix now.
