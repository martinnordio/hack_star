# Godot specs — ordered list

The specs of the Godot game, in the order they are worked on. 01 and 02 are Godot specs;
03–18 are the finished specs of the Python + Svelte game, moved here with their requirements
only (Part 1), numbered in the order the features were built
([2026_11_21_02_move_specs_to_godot_spec.md](2026_11_21_02_move_specs_to_godot_spec.md)).
Each spec only needs features of specs with a lower number.

**How to work through it:** take the first spec that is not *closed*, then
1. **S0** — check each statement against the Godot game as built so far and the Godot
   architecture (`hack_star_godot/docs/architecture.md`, spec 03);
2. `REQUIREMENTS: <spec file> — …` if a statement does not fit (and to answer open questions);
3. `PLAN:` → `IMPLEMENT:` → `REVIEW:` → `CLOSE:` with the root kit (`.specs/kit/`, see
   `AGENTS.md`).

Update the status of a spec here whenever it changes.

**Status:** *to move* (not moved yet) · *requirements* · *planned* · *implemented* · *closed*.

| Order | Spec | Moved from | Status |
|-------|------|------------|--------|
| 01 | [Godot Setup and First Game](done/2026_11_21_01_godot_setup_and_first_game_spec.md) | — (Godot spec) | closed |
| 02 | [Move Specs to Godot](2026_11_21_02_move_specs_to_godot_spec.md) | — (Godot spec) | planned |
| 03 | [MVP and Architecture](2026_11_12_03_mvp_and_architecture_spec.md) | [2026_11_12_mvp_and_architecture_spec.md](../../../.specs/features/done/2026_11_12_mvp_and_architecture_spec.md) (#1) | requirements |
| 04 | [Basic UI](2026_11_12_04_basic_ui_spec.md) | [2026_11_12_basic_ui_spec.md](../../../.specs/features/done/2026_11_12_basic_ui_spec.md) (#2) | requirements |
| 05 | [Hack Codes](2026_11_12_05_hack_codes_spec.md) | [2026_11_12_hack_codes_spec.md](../../../.specs/features/done/2026_11_12_hack_codes_spec.md) (#3) | requirements |
| 06 | [Graphics Demo](2026_11_12_06_graphics_demo_spec.md) | [2026_11_12_graphics_demo_spec.md](../../../.specs/features/done/2026_11_12_graphics_demo_spec.md) (#4) | requirements |
| 07 | [First Match](2026_11_12_07_first_match_spec.md) | [2026_11_12_first_match_spec.md](../../../.specs/features/done/2026_11_12_first_match_spec.md) (#5) | requirements |
| 08 | [Trophies](2026_11_12_08_trophies_spec.md) | [2026_11_12_trophies_spec.md](../../../.specs/features/done/2026_11_12_trophies_spec.md) (#6) | requirements |
| 09 | [Unlock and Upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) | [2026_11_12_unlock_and_upgrade_spec.md](../../../.specs/features/done/2026_11_12_unlock_and_upgrade_spec.md) (#7) | requirements |
| 10 | [Skins Shop](2026_11_12_10_skins_shop_spec.md) | [2026_11_12_skins_shop_spec.md](../../../.specs/features/done/2026_11_12_skins_shop_spec.md) (#8) | requirements |
| 11 | [Overtime and Match Options](2026_11_12_11_overtime_and_match_options_spec.md) | [2026_11_12_overtime_and_match_options_spec.md](../../../.specs/features/done/2026_11_12_overtime_and_match_options_spec.md) (#9) | requirements |
| 12 | [Super and Hypercharge](2026_11_12_12_super_and_hypercharge_spec.md) | [2026_11_12_super_and_hypercharge_spec.md](../../../.specs/features/done/2026_11_12_super_and_hypercharge_spec.md) (#11) | requirements |
| 13 | [More Fighters](2026_11_12_13_more_fighters_spec.md) | [2026_11_12_more_fighters_spec.md](../../../.specs/features/done/2026_11_12_more_fighters_spec.md) (#10) | requirements |
| 14 | [Play with Friends](2026_11_12_14_play_with_friends_spec.md) | [2026_11_12_play_with_friends_spec.md](../../../.specs/features/done/2026_11_12_play_with_friends_spec.md) (#12) | requirements |
| 15 | [Accounts, Fighters and Languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) | [2026_11_13_accounts_fighters_and_languages_spec.md](../../../.specs/features/done/2026_11_13_accounts_fighters_and_languages_spec.md) (#15) | requirements |
| 16 | [Bug Fixes](2026_11_14_16_bug_fixes_spec.md) | [2026_11_14_bug_fixes_spec.md](../../../.specs/features/done/2026_11_14_bug_fixes_spec.md) (#17) | requirements |
| 17 | [Fighter Studio, Saves and Music](2026_11_14_17_fighter_studio_saves_and_music_spec.md) | [2026_11_14_1_fighter_studio_saves_and_music_spec.md](../../../.specs/features/done/2026_11_14_1_fighter_studio_saves_and_music_spec.md) (#19) | requirements |
| 18 | [Worlds and World Coins](2026_11_16_18_worlds_and_world_coins_spec.md) | [2026_11_16_worlds_and_world_coins_spec.md](https://github.com/martinnordio/hack_star/blob/feature/worlds-and-world-coins/.specs/features/done/2026_11_16_worlds_and_world_coins_spec.md) (#24, branch `feature/worlds-and-world-coins`) | requirements |

