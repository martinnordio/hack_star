### Semantic diff — spec 07 First Match (#31)
Play starts a "last fighter standing" match against bots; the dummy arena moves to Training · checks 6 pass · 3 n/a · 0 fail · findings 9 (0 blocking, 3 should-fix, 6 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-07-first-match.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Home screen: **Training** next to Fighters, Info and Hack | modified | S1, S12, S16 |
| ui | What **Play** opens: the dummy arena → a match | modified | S1–S3, S5, S7, S14, S15 |
| ui | A match during the fight: bots, bars, damage numbers, red timer | added | S2, S3, S5, S7, S11, S15 |
| ui | Result screen: Victory, Defeat with the place, Time's up | added | S8, S9, S15 |
| output | Match rules: `Combat` health and healing, `MatchSettings`, `Match`, `BotBrain`, `ArenaLayout.STARTS` | modified | S1, S2, S4–S8, S10, S11 |
| config | Shot mask 0b101 → 0b111, `Screens.MATCH` / `RESULT`, session-only `match_settings` / `last_result` | modified | S3, S10, S12, S16 |
| tokens | Theme variation `HudLabel` | added | S1, S5, S7 |
| performance | Frame rate after Play, 60 → 60 fps with 3 bots (windowed desktop) | modified | S13 |

`server/` and `ui/` unchanged; no server call, nothing saved.

**Top findings:**
- README says a bot in a bush is seen only within 2.5 m; S6 says bots see a fighter in a bush only within 2.5 m. Should-fix, fix now.
- `docs/architecture.md`: a blank line breaks the Game rules table. Should-fix, fix now.
- A shot in flight can still knock out the player after a Victory (the result stays right). Should-fix, plan decision.
