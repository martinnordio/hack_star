### Semantic diff — spec 04 Basic UI (#28)
Home screen with a 3D fighter, entrance, fighter list, skins and info page on a shared UI foundation · checks 7 pass · 2 n/a · 0 fail · findings 8 (0 blocking, 4 should-fix, 4 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-04-basic-ui.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | First screen: start screen → home (`scenes/home.tscn`) | modified | S1, S3, S6, S8, S12, S14 |
| ui | Wow entrance (2.4 s, once per start, skippable) | added | S2 |
| ui | Arena Back (shared `BackButton`, goes home) | modified | S3, S10, S12 |
| ui | Fighter list (`scenes/fighter_list.tscn`) | added | S4, S6, S10, S11 |
| ui | Fighter screen with skins and Select | added | S5, S7, S10, S11, S13 |
| ui | Info page with 24 words | added | S9, S10, S14 |
| output | Catalogue, rarity, Prestige, sample progress, vocabulary, `GameState` | added | S5, S6, S8, S11, S13 |
| config | `project.godot`: main scene, autoloads `Screens`/`GameState`, theme | modified | S1, S12, S13 |
| tokens | Hack star theme (`scenes/ui/hack_star_theme.tres`) | added | S12 |

`server/` and `ui/` unchanged; no dependency added.

**Top findings:**
- On a phone in portrait the 1280-wide stretch makes text about 9 px and Fighters/Info about 26 px tall. This needs a plan decision.
- `SkinButton` and `PrestigeBadge` set their own colours and font size instead of using the theme (D1). Fix now.
- Several new buttons (cards, skins, Select, fighter-screen Back) are tested only by emitting `pressed`, with no click or touch. Fix now.
