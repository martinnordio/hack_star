## README.md — section "Worlds and world coins"

### Worlds and world coins

Every match and every Training session is played in a **world**. There are 13 worlds, and each
comes in three sizes:

| Size | Ground |
|------|--------|
| Small | 30 × 24, today's arena |
| Medium | 36 × 30, about 1.5 times the ground |
| Large | 42 × 34, about 2 times the ground |

A bigger size has more cover (walls and bushes), so fighters walk further to meet. The rules
are the same in every world: fighters, match length, overtime, bots, Training dummies, Supers
and rewards.

- **Free** for every account, in Small: **Canyon**, **Jungle Ruins** and **Neon Docks**.
- **To buy** with world coins: **Lava Forge**, **Sky Islands**, **Crystal Caves**, **Mini City**,
  **Kata Jungle**, **Candy Factory**, **Robot Workshop**, **Pirate Cove**, **Moon Base** and
  **Desert Oasis**.

**World coins** (🌍, shown on Home next to the credits; a new account starts with 0):

- **Earn:** each time the account's total trophies reach the next 500 (500, 1000, 1500…) for the
  first time, it gets **250 world coins** at once, and the result screen shows it. Each 500 pays
  only once, even if the total goes down and up again.
- **Old saves** get the coins for every 500 their trophies had already reached (1240 trophies →
  500 world coins), and keep everything else.
- **Prices:**

  | To get | World coins |
  |--------|-------------|
  | A locked world in Small | 500 |
  | A locked world in Small + Medium | 750 |
  | A locked world in Small + Medium + Large | 1000 |
  | The next size of a world you have (Medium after Small, Large after Medium) | 250 |

- Credits cannot buy worlds, the `INFINITY` hack gives no world coins, and `OPENSESAME` does not
  unlock worlds or sizes. Worlds come only from world coins.

**World-coin codes:** ten codes, five give 500 world coins and five give 1000. They are typed on
the Hack screen or scanned like the other codes; the codes themselves are listed in
`server/src/hack_star_server/world_codes.py`, not here.

| Question | Answer |
|----------|--------|
| How often | Once per account. The same code works again for that account 30 days after it was used |
| Before that | It is refused, with the date it works again |
| Other accounts | Each account on the device has its own 30 days |
| Where the dates are kept | In each account's saved progress on the device, not on the server, so clearing the browser's data lets a code be used early |
| Shown | The Hack screen lists the used world-coin codes with the date they work again |
| Reset | **Reset coins and trophies** (Settings) makes every code usable again at once; **Reset all hacks** does not touch them |
| Changing | The amounts, the 30 days and the codes are all in `world_codes.py` |

**The world screen** is opened by **Play** and **Training** before the match, and by the host of a
room before **START**:

- The balance is shown at the top, and each world has a card with its name (free worlds are
  tagged **Free**).
- Each card has three size buttons, **Small**, **Medium** and **Large**. An unlocked size shows ✔:
  tap it to choose that world and size (the choice is kept for next time, and the chosen card is
  highlighted). A size you can buy shows its price in 🌍: tap it and confirm. With too few world
  coins the screen says how many more are needed. A size above the next one stays 🔒 until the
  smaller one is unlocked.
- The bar at the bottom shows the chosen world and size; **START** plays it.
- In a room, the host's world is used for everyone, including friends who have not unlocked it.
  A friend on the previous version of the game can join only a room that plays in Canyon Small.
  In any other world the server removes that friend, and the host is told why; the friend needs
  to update the game.

## docs/architecture.md — lines mentioning worlds, world coins or world_codes (79)

10:     Screens --> Game["game/<br/>rules: World, Match, Bots"]
21: | Server | `server/` | Python 3.13, FastAPI, port 8180 | Game data: the fighter catalogue, hack codes and world-coin codes; rooms for playing with friends (with the host's world) |
33: | `GET /api/hacks` | The hack codes (`hacks.py`) and the world-coin codes (`world_codes.py`, with `world_coins` and `reuse_days`), for the printable QR page |
34: | `POST /api/hacks/redeem` `{"code"}` | The hack for a code (any case, spaces trimmed), or 404 "Unknown code"; a world-coin code answers with its `id`, `world_coins` and `reuse_days` |
53: | Worlds | `lib/WorldScreen.svelte`, `game/worldShop.ts` (`worldOffers`) | Opened by Play and Training before the match, and by the host of a room before START (`App.svelte`, screen `world`): every world with Small / Medium / Large buttons (unlocked: choose, saved at once; next size: price and confirmation; "N more world coins needed" when too few), the world-coin balance, **Start**; Home shows the balance next to the credits and the result screen "+N world coins" |
56: | Hack | `lib/HackScreen.svelte`, `lib/QrScanner.svelte` | Codes typed or scanned; world-coin codes (`hacks.ts`: `useWorldCode`, `usedWorldCodes`) add their coins and show the date they work again; `/?qr` shows `lib/QrPage.svelte` |
57: | Friends | `lib/FriendsScreen.svelte`, `lib/net/room.ts` | Create / join a room (code, QR, `?room=CODE` link), lobby, Start (the host chooses the world on the world screen first) |
58: | Match / Training | `lib/Arena.svelte` (HTML: joysticks, HUD, result), `lib/ArenaScene.svelte` (3D) | A new `Arena` is mounted per match; it plays in the account's chosen world and size (`chosenWorld` → `arenaFor`, with the world's theme and sky colours); a room is played in the host's world and size (`sharedArena` from the start message) |
62: for created-fighter parts; `?gallery=worlds&world=<id>&size=<size>` for each world's look, `lib/WorldGallery.svelte`), `/?dev` (`lib/dev/DevPage.svelte`, the developer page: asks the
85: | `arena.ts` | The `Arena` shape (walls, bushes, decorations, dummies, start and spawn points) and `CANYON`, the canyon layout = Canyon Small; other worlds come from `worlds.ts` |
86: | `worlds.ts` | The 13 `WORLDS` (id, `free`, `theme`, `seed`), `WORLD_DIMENSIONS` (Small 30 × 24, Medium 36 × 30, Large 42 × 34), `arenaFor(worldId, size)` with the seeded layout generator; see [Worlds](#worlds-catalogue-sizes-themes-and-shop) |
87: | `worldShop.ts` | World coins and worlds: `worldCoinsFor`, `earnWorldCoins`, `buyWorld`, `growWorld`, `worldCost`, `worldOffers`, `chosenWorld` / `chooseWorld` (see below) |
88: | `world.ts` | `World`: fighters (fighter 0 is the player) with health and damage from their power level and type, shots with owners (each shot carries its range, speed, size and damage, worked out when fired; lobbed shots fly over everything and explode; piercing shots go on after a hit), collisions (circles against rectangles), healing, knock-outs, dummies; its own `walls` / `bushes` lists, emptied by `removeCover()` (overtime); Super and Hypercharge: per-fighter `superCharge` / `hyperCharge` meters filled by damage dealt, `useSuper()` does the type's Super (blast, shockwave, beam, dash, bomb), `isHyper()` boosts speed and damage; emits events for effects |
91: | `match.ts` | `Match`: countdown, timer, overtime (when time runs out with the player and a bot in: `overtimeSeconds` more and `removeCover()`), result (victory, defeat with place, time's up) around a `World` |
92: | `bots.ts` | `Bots`: each bot picks the nearest fighter it can see, reacts after a delay, closes in, circles, shoots with an aim error (and uses its Super when full; `BotSkill.hyper` is off on Easy); wanders when it sees nobody, and after 6 seconds without seeing anyone walks towards the nearest opponent (big worlds) |
97: | `settings.ts` | `SETTINGS` (match length, bots, level, healing, trophies, credits, prices, power, world-coin amounts and world prices…) and `BOT_LEVELS`; `settingsFrom(search, defaults, chosen)` applies the Settings screen choices, then `?seconds=&bots=&level=&overtime=` |
99: Every frame (`ArenaScene.svelte`, `useTask`): input → `match.update(dt)` (bots think, world
100: steps) → events turned into effects → 3D objects moved to match the world. Per-frame data stays
104: ### Worlds: catalogue, sizes, themes and shop
106: Worlds are game data in `ui/src/lib/game/worlds.ts` and `game/worldShop.ts`; the look of each
107: theme is in `ui/src/lib/models/arena3d.ts`. Names are never saved: a world is saved by its id
108: (`canyon`, `jungle-ruins`, …), and its name is the text key `world.<id>.name`, so names can be
114: - **Layouts:** `arenaFor(worldId, size)` returns `CANYON` for Canyon Small, and otherwise a
115:   seeded layout (`generate()`, the world's `seed` and size index): mirror-symmetric pairs of
118:   keep a gap from each other, from the spawns and from the centre. The same world and size always
119:   give the same layout; `worlds.test.ts` checks every world × size.
120: - **Themes:** `WORLD_LOOKS` (`arena3d.ts`) maps a `WorldTheme` to its colours, sky, edge kind,
122:   the walls, cover and border are merged into a few meshes, so Large worlds stay smooth.
124:   | Theme | World | Edge | Walls | Cover |
140: - **Free worlds:** the three with `free: true` (Canyon, Jungle Ruins, Neon Docks) are unlocked in
141:   Small for every account (`startWorlds()` in `progress.ts`).
142: - **Prices and earning:** `SETTINGS` (`settings.ts`): `worldCoinsPerStep` 250,
143:   `trophiesPerWorldStep` 500, `worldPrices` `{ small: 500, medium: 750, large: 1000 }`,
144:   `worldSizeStep` 250. `worldShop.ts` holds the rules and never reads or writes credits:
145:   `worldCoinsFor(totalBefore, totalAfter, steps)` gives the coins of each new 500-step (once, via
146:   `worldSteps`), `earnWorldCoins()` applies it to a progress, `worldCost(from, to)` is the price,
147:   `buyWorld()` / `growWorld()` return the new progress with the cost, or the reason for a refusal
148:   (`locked`, `owned`, `unknown`, or `world-coins` with the `missing` amount). `worldOffers()`
149:   gives the three size buttons of the world screen; `chosenWorld()` returns the saved choice when
150:   it is still unlocked (else Canyon Small), and `chooseWorld()` keeps a new one.
163: | `arena3d.ts` | `buildArena(arena, theme)`: tiles, border, walls, cover and crates, barrels, skulls in the colours and shapes of the world's theme (`WORLD_LOOKS`: canyon cliffs and cacti, ruins and ferns, docks and neon posts…); walls, cover and border are merged by material into a few meshes so Large worlds stay smooth |
179: fighters (look and up to 5 created skins), and the world fields: `worldCoins`, `worldSteps` (the
180: 500-steps already paid), `worlds` (`Record<worldId, size>`: the biggest unlocked size of each
181: world), `selectedWorld` (`{ id, size }`) and `worldCodes` (`Record<codeId, nextUseAt>`). The
182: progress format is version 8. Formats v2 through v7 migrate forward: v7 gets the world fields (the
183: three free worlds in Small, Canyon Small chosen, `worldSteps = floor(trophies / 500)` and 250 world
189: fighters (a skin id added in two tabs gets the next free id). Worlds merge across tabs in
190: `mergeProgress()`: `worldCoins` as a delta like credits, plus a refund when this tab paid for a
191: world the other tab had already bought (`worldRefund()`); `worlds` keeps the bigger size per
192: world; `worldSteps` the larger value; `worldCodes` the later date per code; `selectedWorld` the
204: World coins are paid in the same place: `Arena.svelte` `saveReward` calls `earnWorldCoins()`
206: amount in `earnedWorldCoins` for the result screen.
209: `buySkin()`. Worlds are bought and grown only on the world screen, with world coins, through
210: `buyWorld()` / `growWorld()`. With the
232: ### World-coin codes (`server/.../world_codes.py`, `ui/src/lib/hacks.ts`)
234: `world_codes.py` holds `WORLD_CODE_REUSE_DAYS = 30` and `WORLD_CODES`: ten `{ id, code, amount }`,
235: five of 500 and five of 1000 world coins. `hacks.py` adds one `Hack` per code to `ALL_HACKS`, with
236: `world_coins` and `reuse_days` set (the five normal hacks have neither), so `/api/hacks` and
237: `/api/hacks/redeem` include them without other server code. In the UI, `isWorldCode()` recognises
238: them; `useWorldCode(progress, hack, now)` adds the coins and stores `worldCodes[id] = now +
240: the Hack screen shows it. `usedWorldCodes()` lists the codes that cannot be used yet. Only the
280:   H->>S: start {settings (with world), fighters}
296: - **Worlds and versions:** the start message's `settings` carry `world: { id, size }` (the host's
297:   world; `start_world()`; a message without it means Canyon Small). A member sends `version: 2`
299:   the start is in any world other than Canyon Small, `remove_old_versions()` removes those members
301:   the Friends screen shows. Friends with `version` play the host's world even if they have not
305:   team; `World.playerId` is the fighter this device controls; `teamArena()` starts the people
311: - **Friend** (`GuestMatch`): a mirror `World` with the same fighters. Its own fighter moves at
322: - **Change a world:** the catalogue is `WORLDS` in `ui/src/lib/game/worlds.ts` (id, `free`,
323:   `theme`, `seed`; also `WORLD_IDS`). A new world needs its name in the five dictionaries
324:   (`world.<id>.name`), and a new theme needs `WorldTheme` and a `WORLD_LOOKS` entry in
325:   `arena3d.ts`. `worlds.test.ts` then checks every world × size.
326: - **Change world prices, earning or sizes:** `worldPrices`, `worldCoinsPerStep`,
327:   `trophiesPerWorldStep` and `worldSizeStep` in `SETTINGS`; the sizes are `WORLD_DIMENSIONS` and
328:   the cover counts `COVER` in `worlds.ts`.
329: - **Change the world-coin codes or their amounts:** edit `WORLD_CODES` and
330:   `WORLD_CODE_REUSE_DAYS` in `server/src/hack_star_server/world_codes.py`; keep the codes unique
363: | `cd server; uv run --no-sync pytest` | API: fighters and skins, hack durations and world-coin codes, rooms (world and member versions) and created-fighter member data |
364: | `cd ui; npm test` | Game rules, bots, match, worlds and layouts, world shop, world-coin codes, trophies, credits and power, settings, progress (v2–v8 migration and merges), accounts and tab sync (created fighters and skins), saving and the notice, languages, created fighters and skins, 3D models (created parts), timed hacks, QR codes and password, developer mode, music rules and player, vocabulary |
