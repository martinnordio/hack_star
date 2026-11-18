# Worlds and World Coins Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-16
> **Last updated:** 2026-11-18
> **Branch:** `feature/worlds-and-world-coins`
> **Issue:** #24

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~1.98 M | ~CHF 0.60 (72 credits) | Part 1 written (from ideas.md, "From Mi and Ma") |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~480 k | ~CHF 0.14 (17 credits) | Part 1 revised: open questions answered — ten worlds to buy with their names, sizes 1.5× / 2×, world coins for existing trophies, UNLOCK_ALL not for worlds, reset clears used codes, older friends only in Canyon Small, five codes of each amount |
| 2026-11-16 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | — | — | issue #24 created |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~3.09 M | ~CHF 0.91 (109 credits) | Part 2 written |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | — | — | Step 1 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | — | — | Step 2 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | — | — | Step 3 done |

---

# Part 1 · Requirements

## Context

Every match and every Training session is played in the same arena, the same size. Players
want to choose between several **worlds**, each in a small, medium and large size, so matches
feel different and bigger worlds mean more running. The free worlds come in small; other worlds
and bigger sizes are unlocked with a new currency, **world coins**, which players earn by
collecting trophies or get from special hack codes that can be used again after 30 days.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `ui/src/lib/game/arena.ts` — one arena, `CANYON` (30 × 24, with walls, bushes, decorations,
  Training dummies, start and spawn points); `ui/src/lib/game/world.ts` and `match.ts` read
  its size for movement limits, and overtime removes its walls and bushes. Today's arena
  becomes the first free world in Small.
- `ui/src/lib/Home.svelte`, `ui/src/App.svelte`, `ui/src/lib/Arena.svelte` — **Play** and
  **Training** start the same arena in a different mode.
- `ui/src/lib/net/shared.ts` — the host sends the match settings (match length, overtime, bot
  count and level) to friends when the room starts; friends mirror the host's match.
- `ui/src/lib/progress.ts` — per-account progress (version 7): trophies per fighter,
  `totalTrophies()`, credits, unlocked fighters, active hacks with expiry dates;
  `ui/src/lib/accounts.ts` keeps accounts in sync across tabs; the
  [Fighter studio, saves and music spec](done/2026_11_14_1_fighter_studio_saves_and_music_spec.md)
  made sure every choice is kept.
- `ui/src/lib/game/trophies.ts`, `ui/src/lib/fighters.ts` — trophies per match (+10 for a
  win, never below the last Prestige level); Prestige every 1000 total trophies.
- `ui/src/lib/game/economy.ts`, `ui/src/lib/game/shop.ts` — credits: earning, paying, prices
  in `ui/src/lib/game/settings.ts`; refusal when there are not enough.
- `ui/src/lib/hacks.ts`, `server/src/hack_star_server/hacks.py`, `ui/src/lib/QrPage.svelte` —
  hack codes are checked by the server and applied to the account; timed hacks last 72 hours;
  the QR page (password `M6D2`) prints every code. There is no per-code "already used" record
  today.
- `ui/src/lib/i18n/` — five languages (English, Deutsch, Schwiizerdütsch, Español, Italiano).

**New:**
- Several original worlds, each in three sizes, and a world choice before Play, Training and
  a friends' room.
- World coins: earned per 500 trophies, spent to unlock worlds and sizes.
- World-coin hack codes that each account can use once every 30 days.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [ideas.md](ideas.md) | Where this request came from |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../README.md) | How to install, run, test and play |

## 1 · Specs

### Worlds

- **S1 — Choose a world:** Before a match and before Training, the player chooses a world and
  a size from the unlocked ones; the last choice is kept and offered next time. The first time,
  the choice is today's arena in Small.
- **S2 — Free worlds:** Three worlds are free and unlocked for every account in Small: today's
  arena and two new worlds. Their Medium and Large sizes are locked.
- **S3 — More worlds:** At least ten more worlds can be bought with world coins (S11). The
  game shows every world, locked ones with their prices.
- **S4 — Names and looks:** Every world has its own name, look (ground, walls, plants or other
  cover, colours) and layout, original to Hack star — no names, maps or art from other games.
  Free: **Canyon** (today's arena), **Jungle Ruins**, **Neon Docks**. To buy: **Lava Forge**,
  **Sky Islands**, **Crystal Caves**, **Mini City**, **Kata Jungle**, **Candy Factory**,
  **Robot Workshop**, **Pirate Cove**, **Moon Base**, **Desert Oasis**.
- **S5 — Three sizes:** Each world has a **Small** size (as big as today's arena), a
  **Medium** size with about 1.5 times its ground and a **Large** size with about 2 times its
  ground; a bigger size has more cover too, so fighters walk further to meet. The sizes are
  named in the game.
- **S6 — Same rules everywhere:** In every world and size the match rules stay as today:
  number of fighters, match length, overtime (walls and cover disappear), bots that find and
  fight the others, Training dummies, Supers, rewards. Bots still reach the other fighters in
  a Large world.
- **S7 — Friends:** In a room, the host's world and size are used; friends play in it even if
  they have not unlocked it. Friends on the previous version may join only a room in Canyon
  Small; any other room tells them to update the game.

### World coins

- **S8 — Balance:** Every account has a world-coin balance, shown next to the credits on the
  home screen and wherever worlds are unlocked. A new account starts with 0.
- **S9 — Earn:** Each time the account's total trophies reach the next multiple of 500
  (500, 1000, 1500, …) for the first time, the account gets 250 world coins at once, and the
  match result shows it. Each step pays only once, even if the total goes down and up again.
- **S10 — Separate from credits:** World coins are not credits: credits cannot buy worlds, the
  infinite-credits hack does not give world coins, and the UNLOCK_ALL hack does not unlock
  worlds or sizes. Worlds come only from world coins.

### Unlocking

- **S11 — Prices of a new world:** A locked world is bought in Small for 500 world coins,
  Small + Medium for 750, or Small + Medium + Large for 1000.
- **S12 — Bigger sizes:** Each next size of an unlocked world costs 250 world coins: Medium
  needs Small, Large needs Medium. This applies to the free worlds and to worlds bought
  smaller.
- **S13 — Pay:** A purchase takes its world coins from the balance and unlocks at once. With
  too few world coins nothing changes and the game says how many more are needed. Something
  already unlocked cannot be bought again.

### World-coin hack codes

- **S14 — Codes:** There are five hack codes that give 500 world coins and five that give
  1000. Each code is a unique, distinct code (not a shared word), entered like today's hack
  codes or scanned as a QR code.
- **S15 — Once per 30 days:** A world-coin code works once for an account; the same code works
  again for that account 30 days after it was used. Before then it is refused with the date it
  can be used again. Other accounts on the device have their own 30 days.
- **S16 — Used codes kept:** For each account the game remembers which world-coin codes were
  used and when they can be used again, and shows this on the hack screen.
- **S17 — Easy to change:** The amounts (500 / 1000), the waiting time (30 days) and the list
  of codes can be changed later in one place, without changing how the rest of the game works.
- **S18 — QR page:** The QR page (behind the existing password) lists and prints the
  world-coin codes with their amounts.

### Saving and everywhere

- **S19 — Saved:** World coins, the trophy steps already paid, the unlocked worlds and sizes,
  the chosen world and size, and the used codes with their dates are kept after a reload, a
  restart of the browser or device, and across tabs, per account — like the rest of the
  progress.
- **S20 — Old saves:** Saves from earlier versions still load, with the three free worlds in
  Small, today's arena chosen and nothing else lost. The first time such a save is loaded, the
  account gets 250 world coins once for each 500-step its total trophies already reached
  (for example 1240 trophies → 2 steps → 500 world coins).
- **S21 — Reset:** Resetting an account's progress also resets its world coins, worlds and
  used world-coin codes: after a reset every world-coin code can be used again at once.
- **S22 — Languages:** Every new label, world and size name and message is shown in all five
  game languages.
- **S23 — Devices:** Choosing worlds, unlocking and the world-coin codes work with mouse and
  touch on desktop, tablet and phone, in portrait and landscape; a Large world plays smoothly
  on an iPad.
- **S24 — Documentation:** The README and `docs/architecture.md` describe worlds, sizes,
  world coins, prices and the world-coin codes.

### Open questions

_None — answered on 2026-11-16._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | World catalogue and sizes | reasoning (Claude Opus 5.5) — seeded layout generator and its checks | ✅ Done | [→ Step 1](#step-1--world-catalogue-and-sizes) |
| **2** | World coins, worlds and saved progress v8 | reasoning (Claude Opus 5.5) — migration and two-tab merge | ✅ Done | [→ Step 2](#step-2--world-coins-worlds-and-saved-progress-v8) |
| **3** | A look for every world | reasoning (Claude Opus 5.5) — graphics-heavy | ✅ Done | [→ Step 3](#step-3--a-look-for-every-world) |
| **4** | Matches and Training in the chosen world | standard (Claude Sonnet 5.5) — clear wiring, bot rule with tests | ⬜ Not started | [→ Step 4](#step-4--matches-and-training-in-the-chosen-world) |
| **5** | World screen: choose, buy and grow worlds | standard (Claude Sonnet 5.5) — screen following the plan | ⬜ Not started | [→ Step 5](#step-5--world-screen-choose-buy-and-grow-worlds) |
| **6** | Worlds in friends' rooms | reasoning (Claude Opus 5.5) — room protocol and old clients | ⬜ Not started | [→ Step 6](#step-6--worlds-in-friends-rooms) |
| **7** | World-coin hack codes | standard (Claude Sonnet 5.5) — server list, client rules, tests | ⬜ Not started | [→ Step 7](#step-7--world-coin-hack-codes) |
| **8** | Documentation and final check | light (Claude Haiku 5.5) — docs and running checks | ⬜ Not started | [→ Step 8](#step-8--documentation-and-final-check) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With cost tracking on, end it with
>    `· ~<tokens> · ~CHF <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | The world catalogue is one module, `ui/src/lib/game/worlds.ts`: 13 worlds with a stable id (`canyon`, `jungle-ruins`, `neon-docks`, `lava-forge`, `sky-islands`, `crystal-caves`, `mini-city`, `kata-jungle`, `candy-factory`, `robot-workshop`, `pirate-cove`, `moon-base`, `desert-oasis`), a `free` flag (the first three), a theme id and a layout seed. Names are i18n keys, never saved. | One place lists the worlds; ids stay stable when names or translations change (S2–S4, S22). |
| D2 | Sizes are `small`, `medium`, `large`. Small is 30 × 24 like today; Medium 36 × 30 (1.5× the ground); Large 42 × 34 (2.0×). `arenaFor(worldId, size)` builds an `Arena` (the existing shape: walls, bushes, decorations, dummies, start, spawns). Canyon Small returns today's `CANYON` exactly. | Bots, overtime, Training and spawns already read the `Arena` shape and its size, so they work unchanged (S5, S6); Canyon Small keeps today's matches identical. |
| D3 | Other layouts come from a small seeded generator in `worlds.ts`: mirror-symmetric cover groups (walls and bushes) placed on a grid that grows with the size, decorations at random free spots, spawns spread around the edge, Training start and dummies as in Canyon. Tests check every world × size: no spawn, start or dummy inside a wall, a clear path from every spawn to the centre, cover count grows with size. | 39 hand-made maps would be slow to write and review; a seeded generator gives each world a fixed, testable layout (S4, S5). |
| D4 | Each theme sets colours and the kind of cover drawn from simple shapes in `ui/src/lib/models/arena3d.ts` (rocks and cacti, ruins and ferns, crates and neon posts, lava rocks, clouds, crystals, houses, sweets, machines, palms and barrels, moon rocks, dunes and palms…). No image or model files. | Original looks without art licences (S4, `ui/public/assets/LICENSES.md`); the same draw calls as today, so Large stays smooth (S23). |
| D5 | Bots keep their sight; when a bot has seen nobody for 6 seconds it walks towards the nearest fighter. | In Large worlds bots could otherwise wander a long time without meeting anyone (S6). |
| D6 | Saved progress version 8 adds: `worldCoins` (number), `worldSteps` (500-steps already paid), `worlds` (`Record<worldId, size>`: the biggest unlocked size), `selectedWorld` (`{ id, size }`), `worldCodes` (`Record<codeId, nextUseAt>`). Migration from v2–v7: the three free worlds in Small, Canyon Small chosen, `worldSteps = floor(totalTrophies / 500)` and `worldCoins = 250 × worldSteps` (S20). | One migration, the same pattern as versions 4–7; the choice is per account because unlocked worlds are (S1, S19, S20). |
| D7 | Across tabs: `worldCoins` merges as a delta like `credits`; `worlds` keeps the bigger size per world; `worldSteps` the larger value; `worldCodes` the later date per code; `selectedWorld` the local change. `resetProgress` clears all five back to the start values (S21). | Same rules as the rest of the progress (S19, bug fixes spec); a purchase in one tab is not lost in another. |
| D8 | Prices and amounts live in `ui/src/lib/game/settings.ts`: `worldCoinsPerStep: 250`, `trophiesPerWorldStep: 500`, `worldPrices: { small: 500, medium: 750, large: 1000 }`, `worldSizeStep: 250`. Rules in `ui/src/lib/game/worldShop.ts`: `worldCoinsFor(totalBefore, totalAfter, steps)`, `buyWorld`, `growWorld`, refusals with the missing amount. | Like the credits shop (`economy.ts`, `shop.ts`); numbers in one place (S9, S11–S13). |
| D9 | World-coin codes are server data in `server/src/hack_star_server/world_codes.py`: `WORLD_CODE_REUSE_DAYS = 30` and a list of `{ id, code, amount }` (five of 500, five of 1000; codes like `WC5-7K2QX`, unique, not words). `/api/hacks/redeem` also accepts them and answers with the code's `id`, `world_coins` and `reuse_days` (new optional fields of `Hack`); `/api/hacks` lists them for the QR page. The client records `worldCodes[id] = now + reuse_days` per account and refuses a code before that date with the date. | Amounts, waiting time and codes change in one file (S17); one hack screen and one QR page as today (S14, S18); per-account dates follow the account (S15, S16). |
| D10 | World-coin codes are checked by the server, but the "used" dates live in the account's saved progress on the device. | The game has no server accounts; for a kids' game this is enough. Server-side tracking is deferred. |
| D11 | Rooms: the start message's settings gain `world: { id, size }`; the join message's member gains `version: 2`. The server accepts members without `version` (previous version). When the host starts in a world other than Canyon Small, the server removes members without `version` with the existing room-error message, and the host sees who was removed and why. Friends with the new version use the host's world even if they have not unlocked it. | Friends on the previous version keep working in Canyon Small and are told otherwise (S7); no change for rooms in Canyon Small. |
| D12 | The world picker is a new screen `ui/src/lib/WorldScreen.svelte`, opened from Play and Training (and by the host in a room) before the match starts; the balance shows on Home next to the credits. | One place to choose, buy and grow (S1, S8, S11–S13); Home stays simple. |

---

## Step 1 — World catalogue and sizes

### Goal
The 13 worlds and their Small, Medium and Large layouts exist as game data, with Canyon Small
equal to today's arena (S2, S3, S4, S5).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `ui/src/lib/game/worlds.ts`: the 13 worlds (D1), sizes and dimensions (D2),
      `arenaFor(worldId, size)` with the seeded layout generator (D3); Canyon Small returns
      `CANYON`.
- [x] World and size names as i18n keys in all five languages.
- [x] Tests `worlds.test.ts`: 13 worlds, 3 free, unique ids; Canyon Small deep-equals `CANYON`;
      every world × size: dimensions and ground ratio (~1.5, ~2.0), no spawn / start / dummy in
      a wall, a clear line from every spawn towards the centre, at least 9 spawns, cover grows
      with size, the same layout for the same world and size every time.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 13:34

**Done (2026-11-18 · ~7m · Claude Opus 5.5)** — `ui/src/lib/game/worlds.ts`: 13 worlds (ids, free flag, theme, seed), sizes Small 30×24 / Medium 36×30 / Large 42×34, `arenaFor(id, size)` with a seeded mirror-symmetric generator (Canyon Small returns `CANYON`); world and size names in all five languages; `worlds.test.ts` checks the catalogue, ground ratios, free and reachable spawns / start / dummies (flood fill from the centre — a straight line would fail for Canyon's own back spawn), ≥ 9 spawns, growing cover and stable layouts. `cd ui; npm test` 324 passed, `npm run check` 0 errors. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · — · — (usage script: no price for this model outside VS Code)

---

## Step 2 — World coins, worlds and saved progress v8

### Goal
Accounts earn world coins per 500 trophies, buy worlds and bigger sizes, and keep it all in
saved progress v8 with old saves migrated (S8–S13, S19, S20, S21).

### Tasks
- [x] Record the start time in Notes below.
- [x] `progress.ts`: version 8 fields and start values (D6); migration from v2–v7 with world
      coins for trophies already reached; `resetProgress` resets them (S21).
- [x] `accounts.ts`: merge rules for the new fields (D7).
- [x] `settings.ts` numbers and `game/worldShop.ts` rules (D8): earning per new 500-step,
      buying in Small / Small + Medium / all sizes, growing one size for 250, refusals with the
      missing amount, already unlocked refused; credits and the infinite-credits and
      UNLOCK_ALL hacks do not count (S10).
- [x] `Arena.svelte` `saveReward`: add world coins when a match passes a 500-step, and keep the
      amount for the result screen.
- [x] Tests: earning (499 → 509 gives 250; 990 → 1010 gives 250; a step is never paid twice);
      prices and size rules; migration (1240 trophies → 500 world coins, free worlds, Canyon
      Small chosen; v2–v7 saves load); reset; two-tab merges (a purchase and a match in two
      tabs, codes, sizes).
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 13:40

**Done (2026-11-18 · ~7m · Claude Opus 5.5)** — progress v8 (`worldCoins`, `worldSteps`, `worlds`, `selectedWorld`, `worldCodes`) with v2–v7 migration (free worlds in Small, Canyon Small, 250 world coins per 500-step reached) and reset; tab merge (coins as a delta with a refund for a world bought in both tabs, bigger size, larger steps, later code date, local choice; a reset wins); world numbers in `settings.ts` and `game/worldShop.ts` (`worldCoinsFor`, `earnWorldCoins`, `buyWorld`, `growWorld`, `chosenWorld`, `chooseWorld`, refusals with the missing amount; credits and hacks never count); `Arena.svelte` pays world coins after a match and keeps `earnedWorldCoins` for the result screen (Step 5). No new visible text yet. `cd ui; npm test` 352 passed, `npm run check` 0 errors. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · — · — (usage script: no price for this model in this environment)

---

## Step 3 — A look for every world

### Goal
Every world is drawn with its own theme and cover, in every size, smoothly on an iPad (S4, S5,
S23).

### Tasks
- [x] Record the start time in Notes below.
- [x] `models/arena3d.ts`: themes (D4) — ground colours, edge (cliffs or other border), wall and
      bush shapes per theme; `buildArena(arena, theme)`.
- [x] `ArenaScene.svelte`: draw the arena it is given instead of `CANYON`; the light's shadow
      area covers Large.
- [x] `/?gallery`: a section that shows each world's ground and cover, to look at the themes.
- [x] Tests: every theme id of the catalogue has a look; building every world × size gives
      ground, walls and cover.
- [x] Check: `npm test; npm run check`; in the browser, `/?gallery` and a Large world at iPad
      size (820 × 1180) — screenshots of several themes, frame rate noted.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 13:47

**Done (2026-11-18 · ~18m · Claude Opus 5.5)** — `models/arena3d.ts`: `WORLD_LOOKS` for all 13 themes (tiles, floor, sky, border: cliffs / trees / docks and water / clouds / buildings / lollipops / dunes; walls: rock / ruin / crates / crystal / house / machine / blocks / logs; cover: cacti / ferns / neon posts / clouds / crystals / mushrooms / hedges / sweets / palms), `buildArena(arena, theme)` merges border, walls, cover and decorations by material (a few draw calls instead of ~1000; Canyon draws exactly as before — pinned by a triangle/position/colour fingerprint), `disposeArena`, `shadowReach`; `ArenaScene.svelte` draws `world.arena` with an optional `theme` prop (Canyon by default — `Arena.svelte` passes the chosen world and uses `look.sky` for its background in Step 4), overtime bursts in the theme's colours, the shadow area covers Large; `/?gallery=worlds&world=<id>&size=<size>` (`WorldGallery.svelte`, names from the existing i18n keys, `data-fps`); `arena3d.test.ts`; architecture lines for `arena3d.ts` and the gallery. `cd ui; npm test` 357 passed, `npm run check` 0 errors, `npm run build` ok; browser (integrated browser, viewport emulated at 820 × 1180 via CDP): all 13 worlds in Large in the gallery at 60 fps (desktop GPU, not a real iPad), screenshots of Lava Forge, Neon Docks, Candy Factory, Jungle Ruins, Sky Islands, Crystal Caves, Mini City, Kata Jungle, Robot Workshop, Pirate Cove, Moon Base, Desert Oasis and Canyon; a Canyon match (`?seconds=20&bots=3`) at 820 × 1180 at 60 fps through overtime to the result, no page errors; `/?gallery` fighters unchanged. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · — · — (usage script: no price for this model in this environment)

---

## Step 4 — Matches and Training in the chosen world

### Goal
Matches and Training are played in the account's chosen world and size, with the same rules
as today (S1, S6).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `Arena.svelte` and the match / Training start use `arenaFor(selectedWorld)` instead of
      `CANYON`; overtime removes the cover of any world.
- [ ] Bots (D5): walk towards the nearest fighter after 6 seconds without seeing anyone.
- [ ] Tests: a bots-only match ends with a winner in every Large world within the match time
      (fixed random seed); Training dummies and start in every world; overtime empties walls
      and bushes of a Large world.
- [ ] Check: `npm test; npm run check`; in the browser, a short match (`?seconds=20&bots=3`)
      in a Large world and Training in a Medium world.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — World screen: choose, buy and grow worlds

### Goal
Players see their world coins, choose a world and size before Play and Training, and buy
worlds and bigger sizes; the result screen shows world coins earned (S1, S3, S8, S9, S11–S13,
S22, S23).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Home: world-coin balance next to the credits.
- [ ] `WorldScreen.svelte` (D12): every world with its size buttons; unlocked ones selectable,
      locked ones with their prices (500 / 750 / 1000, +250 per size); buy and grow with
      confirmation; "N more world coins needed" when too few; the choice is saved.
- [ ] Play and Training open the world screen first, preselected on the last choice, with
      **Start**.
- [ ] Result screen: "+250 world coins" when a step was reached.
- [ ] Texts in all five languages; mouse and touch; desktop, iPad and phone in portrait and
      landscape.
- [ ] Check: `npm test; npm run check`; in the browser at the three sizes: buy a world with
      enough and with too few coins, grow a free world to Medium, choose it, start a match,
      reload — all kept; screenshots.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 6 — Worlds in friends' rooms

### Goal
Friends play in the host's world and size; friends on the previous version only in Canyon
Small (S7).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `net/shared.ts`: the start settings carry `world`; guests build the host's arena.
- [ ] `net/room.ts` and `server/.../rooms.py`: member `version` (D11); on a start outside Canyon
      Small, members without it are removed with the room-error message; the host sees who and
      why.
- [ ] The host chooses the world on the world screen before **START**.
- [ ] Tests: server — joins with and without `version`; removal on start outside Canyon Small,
      none in Canyon Small (`server/tests/test_rooms.py`); UI — start info with the world;
      a guest builds the same arena as the host.
- [ ] Check: `cd server; uv run --no-sync pytest`; `cd ui; npm test; npm run check`; two
      browser tabs: host in a Large world, friend joins and plays in it.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 7 — World-coin hack codes

### Goal
Ten world-coin codes give 500 or 1000 world coins, once per 30 days per account, shown on the
hack screen and printed on the QR page (S14–S18, S21).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `server/.../world_codes.py` (D9): `WORLD_CODE_REUSE_DAYS`, five codes of 500 and five of
      1000; `hacks.py` / `app.py`: redeem and list include them with `world_coins` and
      `reuse_days`.
- [ ] `hacks.ts` and `HackScreen.svelte`: a world-coin code adds its coins and stores its next
      date; before that date it is refused with the date; a list of used codes with the dates
      they work again.
- [ ] `QrPage.svelte`: the world-coin codes with their amounts.
- [ ] Texts in all five languages.
- [ ] Tests: server — every code unique, amounts 500 / 1000, reuse days 30, redeem answers;
      UI — use, refuse before 30 days with the date, accept after, other account independent,
      reset clears the dates (S21).
- [ ] Check: `cd server; uv run --no-sync pytest`; `cd ui; npm test; npm run check`; in the
      browser: redeem a code, try again (refused with date), switch account (works), QR page.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 8 — Documentation and final check

### Goal
The documents describe worlds and world coins, and everything that worked before still works
(S19, S22, S23, S24).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `README.md`: worlds and sizes, world coins and prices, world-coin codes (table of how they
      work, not the codes themselves), the world screen.
- [ ] `docs/architecture.md`: `worlds.ts`, `worldShop.ts`, themes, progress v8 and merge rules,
      room `world` and member `version`, `world_codes.py`.
- [ ] Full check: `cd server; uv run --no-sync pytest`; `cd ui; npm test; npm run check;
      npm run build`; in the browser, one pass over S1–S24 on desktop and phone, including a
      reload, a second tab and an old save.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

Tasks set aside for a future spec, so nothing is forgotten.

| Task | Reason | Target Spec |
|------|--------|------------------|
| Server-side record of used world-coin codes (D10) | The game has no server accounts; clearing the browser's data lets a code be used early | a later accounts spec, if wanted |
| Music or rules of their own per world | Part 1 asks for looks and layouts only (S6) | a later spec, if wanted |
| Real-device check of Large worlds on an iPad and phone | Real-device testing is spec 5's subject | [Device and end-to-end testing](2026_11_14_5_device_and_end_to_end_testing_spec.md) |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S24 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `uv run pytest`, `npm test`, `npm run check` and `npm run build` pass; README / `docs/architecture.md` updated where affected
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
