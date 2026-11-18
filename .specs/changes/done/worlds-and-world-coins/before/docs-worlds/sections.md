## docs/architecture.md — lines mentioning worlds, world coins or world_codes (7)

10:     Screens --> Game["game/<br/>rules: World, Match, Bots"]
85: | `world.ts` | `World`: fighters (fighter 0 is the player) with health and damage from their power level and type, shots with owners (each shot carries its range, speed, size and damage, worked out when fired; lobbed shots fly over everything and explode; piercing shots go on after a hit), collisions (circles against rectangles), healing, knock-outs, dummies; its own `walls` / `bushes` lists, emptied by `removeCover()` (overtime); Super and Hypercharge: per-fighter `superCharge` / `hyperCharge` meters filled by damage dealt, `useSuper()` does the type's Super (blast, shockwave, beam, dash, bomb), `isHyper()` boosts speed and damage; emits events for effects |
88: | `match.ts` | `Match`: countdown, timer, overtime (when time runs out with the player and a bot in: `overtimeSeconds` more and `removeCover()`), result (victory, defeat with place, time's up) around a `World` |
96: Every frame (`ArenaScene.svelte`, `useTask`): input → `match.update(dt)` (bots think, world
97: steps) → events turned into effects → 3D objects moved to match the world. Per-frame data stays
222:   team; `World.playerId` is the fighter this device controls; `teamArena()` starts the people
228: - **Friend** (`GuestMatch`): a mirror `World` with the same fighters. Its own fighter moves at
