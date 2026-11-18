# Worlds and World Coins Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed on feature/worlds-and-world-coins
> **Created:** 2026-11-16
> **Last updated:** 2026-11-18
> **Branch:** `feature/worlds-and-world-coins`
> **Issue:** #24

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~1.98 M | ~CHF 0.60 (72 credits) | Part 1 written (from ideas.md, "From Mi and Ma") |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~480 k | ~CHF 0.14 (17 credits) | Part 1 revised: open questions answered — ten worlds to buy with their names, sizes 1.5× / 2×, world coins for existing trophies, UNLOCK_ALL not for worlds, reset clears used codes, older friends only in Canyon Small, five codes of each amount |
| 2026-11-16 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | — | — | issue #24 created |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~3.09 M | ~CHF 0.91 (109 credits) | Part 2 written |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.06 M (100 k in · 1.93 M cached · 26 k out) | CHF 1.18 (141 credits) | Step 1 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 4.22 M (102 k in · 4.08 M cached · 37 k out) | CHF 1.73 (206 credits) | Step 2 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 11.75 M (169 k in · 11.50 M cached · 79 k out) | CHF 3.95 (472 credits) | Step 3 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 3.86 M (109 k in · 3.73 M cached · 25 k out) | CHF 0.75 (89 credits) | Step 4 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 8.24 M (145 k in · 8.05 M cached · 43 k out) | CHF 1.34 (160 credits) | Step 5 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 7.65 M (158 k in · 7.44 M cached · 50 k out) | CHF 2.74 (327 credits) | Step 6 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 5.14 M (112 k in · 5.00 M cached · 32 k out) | CHF 0.92 (110 credits) | Step 7 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | 19.72 M (293 k in · 19.29 M cached · 130 k out) | CHF 1.15 (137 credits) | Step 8 done |
| 2026-11-18 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 1.54 M (612 k in · 914 k cached · 13 k out) | CHF 1.47 (175 credits) | orchestrator that started the eight Step sub-agents |
| 2026-11-18 | review | `REVIEW:` | Claude Opus 5.5, Claude Sonnet 5.5 | 20.66 M (487 k in · 20.05 M cached · 124 k out) | CHF 7.18 (857 credits) | semantic diff written; two Opus review runs plus the Sonnet orchestrator |
| 2026-11-18 | implementation | `CLOSE:` | Claude Sonnet 5.5 | 1.19 M (83 k in · 1.09 M cached · 18 k out) | CHF 0.41 (49 credits) | spec closed |

---

## Cost summary

This feature used ~91.58 M tokens, ~CHF 24.47 (2,920 credits) — see [COSTS.md](../../kit/COSTS.md). Requirements and plan are estimates (VS Code chat transcript). Implementation, review and `CLOSE:` ran in a Copilot CLI session, so the `usage` script could not read them; their numbers are **measured**: they come from the `session.usage_record` events of that session's `events.jsonl` (tokens and AI credits as billed per request, sub-agents included), converted to CHF at the settings' rate. The two kinds of numbers are therefore not computed the same way, and the estimated Opus, Sonnet and Haiku branch figures are not directly comparable with these.

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| requirements | Claude Opus 5.5 | ~2.46 M | ~CHF 0.74 (89 credits) | 4.7 % |
| plan | Claude Opus 5.5 | ~3.09 M | ~CHF 0.91 (109 credits) | 5.7 % |
| implementation | Claude Opus 5.5, Claude Sonnet 5.5, Claude Haiku 5.5 | 65.36 M | CHF 15.64 (1,865 credits) | 98.2 % |
| review | Claude Opus 5.5, Claude Sonnet 5.5 | 20.66 M | CHF 7.18 (857 credits) | 45.1 % |
| **Total** | | **~91.58 M** | **~CHF 24.47 (2,920 credits)** | **153.7 %** |

**Implementation by Step** (the Step sub-agent only; the orchestrator is its own row)

| Step | Model | Tokens | Cost (CHF) | Share of Copilot Business |
|------|-------|--------|------------|---------------------------|
| Step 1 | Claude Opus 5.5 | 2.06 M | CHF 1.18 (141 credits) | 7.4 % |
| Step 2 | Claude Opus 5.5 | 4.22 M | CHF 1.73 (206 credits) | 10.9 % |
| Step 3 | Claude Opus 5.5 | 11.75 M | CHF 3.95 (472 credits) | 24.8 % |
| Step 4 | Claude Sonnet 5.5 | 3.86 M | CHF 0.75 (89 credits) | 4.7 % |
| Step 5 | Claude Sonnet 5.5 | 8.24 M | CHF 1.34 (160 credits) | 8.4 % |
| Step 6 | Claude Opus 5.5 | 7.65 M | CHF 2.74 (327 credits) | 17.2 % |
| Step 7 | Claude Sonnet 5.5 | 5.14 M | CHF 0.92 (110 credits) | 5.8 % |
| Step 8 | Claude Haiku 5.5 | 19.72 M | CHF 1.15 (137 credits) | 7.2 % |
| Orchestrator | Claude Sonnet 5.5 | 1.54 M | CHF 1.47 (175 credits) | 9.2 % |
| CLOSE | Claude Sonnet 5.5 | 1.19 M | CHF 0.41 (49 credits) | 2.6 % |
| **Total implementation** | | **65.36 M** | **CHF 15.64 (1,865 credits)** | **98.2 %** |

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
  [Fighter studio, saves and music spec](2026_11_14_1_fighter_studio_saves_and_music_spec.md)
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
| [overall_req.md](../../overall_req.md) | Overall game idea and product questions |
| [ideas.md](../ideas.md) | Where this request came from |
| [architecture.md](../../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../../README.md) | How to install, run, test and play |

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

## Closing summary

**Built:** Players choose a world and a size before Play, Training and a friends' room. There are 13 original worlds (Canyon, Jungle Ruins and Neon Docks free in Small; ten more to buy), each in Small (30 × 24, today's arena), Medium (36 × 30) and Large (42 × 34), drawn with their own looks and generated from fixed seeds (Canyon Small is exactly today's arena). Accounts have a world-coin balance (shown on Home), earn 250 world coins for every 500 trophies reached for the first time (also for trophies already earned when an old save loads), and buy worlds (500 / 750 / 1000) and bigger sizes (+250) on a new world screen. Friends play in the host's world, and friends on the previous version are only allowed in Canyon Small. Ten server-side world-coin codes (five of 500, five of 1000) work once per account every 30 days, are listed on the hack screen and printed on the QR page. All of it is saved per account in progress v8 with a migration from v2–v7, merged across tabs, cleared by reset, and translated into all five languages. README and `docs/architecture.md` describe it. Checks at the end: `pytest` 56, `npm test` 375, `npm run check` 0 errors, `npm run build` ok.
**Differs from the plan:** Mostly small deviations, all recorded in the Steps' Done lines:
- Step 1 — the "clear line from every spawn to the centre" check is a **walkable-path check** (flood fill from the centre), because a straight line would fail for Canyon's own back spawn.
- Step 2 — the tab merge also **refunds** a world bought in two tabs (D7 only said the bigger size is kept); a step crossed in two tabs is *not* refunded (review finding 1).
- Step 3 — all cover of a world is merged by material (a few draw calls instead of ~1000); Canyon's look is pinned by a fingerprint test; the gallery is `/?gallery=worlds&world=<id>&size=<size>`. Frame rates were measured on a desktop GPU, not a real iPad.
- Step 4 — the bots' seek rule (D5) targets the nearest fighter that is still in, **without checking bushes**, so after 6 s a bot also walks to a player hiding in a bush, in Canyon Small too (review finding 2; the plan did not say whether hiding still works).
- Step 5 — the pure rule `worldOffers` (what each size button does) was added to `worldShop.ts`; the result line `+N world coins` was seen only with a temporary forced value (the earning itself is covered by tests); touch was not emulated on the world screen.
- Step 6 — the server also sends the host a `removed` message (who and why), tags old friends in the lobby, and hands a friend removed after the start to a bot; its error message is `update-the-game`.
- Step 7 — codes look like `WC5-7K2QX` with no vowels or 0/1 so they are never words; the world codes are part of `ALL_HACKS`, so the existing list and redeem endpoints serve them.
- Step 8 — S7 was only partly checked in the browser (the friend shared the host's storage; the not-unlocked and old-version rules are covered by `room.test.ts`, `shared.test.ts` and `test_rooms.py`); Large-world smoothness on a real iPad and the camera QR scan were **not** verified (the real-device check is in Deferred Items). The reset warning does not name world coins (Deferred Items).
- Review — no Blocking finding; two Should-fix and five Nit findings. Findings 1 and 5 were marked "fix now" but are **not fixed** in this spec; they are in Deferred Items, finding 1 first. Finding 7 (Definition of Done) is fixed by this close.
- Cost — token counts and prices were unavailable, so the Stage log and the Cost summary have no numbers for implementation, review and `CLOSE:`.
**Files:** `ui/src/lib/game/worlds.ts`, `worldShop.ts`, `settings.ts`, `bots.ts`; `ui/src/lib/progress.ts`, `accounts.ts`, `hacks.ts`; `ui/src/lib/models/arena3d.ts`, `ArenaScene.svelte`, `WorldGallery.svelte`; `ui/src/lib/WorldScreen.svelte`, `Arena.svelte`, `App.svelte`, `Home.svelte`, `HackScreen.svelte`, `QrPage.svelte`; `ui/src/lib/net/shared.ts`, `room.ts`; `ui/src/lib/i18n/` (five languages); `server/src/hack_star_server/world_codes.py`, `hacks.py`, `rooms.py`; the matching tests; `README.md`, `docs/architecture.md`.

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | World catalogue and sizes | reasoning (Claude Opus 5.5) — seeded layout generator and its checks | ✅ Done | [→ Step 1](#step-1--world-catalogue-and-sizes) |
| **2** | World coins, worlds and saved progress v8 | reasoning (Claude Opus 5.5) — migration and two-tab merge | ✅ Done | [→ Step 2](#step-2--world-coins-worlds-and-saved-progress-v8) |
| **3** | A look for every world | reasoning (Claude Opus 5.5) — graphics-heavy | ✅ Done | [→ Step 3](#step-3--a-look-for-every-world) |
| **4** | Matches and Training in the chosen world | standard (Claude Sonnet 5.5) — clear wiring, bot rule with tests | ✅ Done | [→ Step 4](#step-4--matches-and-training-in-the-chosen-world) |
| **5** | World screen: choose, buy and grow worlds | standard (Claude Sonnet 5.5) — screen following the plan | ✅ Done | [→ Step 5](#step-5--world-screen-choose-buy-and-grow-worlds) |
| **6** | Worlds in friends' rooms | reasoning (Claude Opus 5.5) — room protocol and old clients | ✅ Done | [→ Step 6](#step-6--worlds-in-friends-rooms) |
| **7** | World-coin hack codes | standard (Claude Sonnet 5.5) — server list, client rules, tests | ✅ Done | [→ Step 7](#step-7--world-coin-hack-codes) |
| **8** | Documentation and final check | light (Claude Haiku 5.5) — docs and running checks | ✅ Done | [→ Step 8](#step-8--documentation-and-final-check) |

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

**Done (2026-11-18 · ~7m · Claude Opus 5.5)** — `ui/src/lib/game/worlds.ts`: 13 worlds (ids, free flag, theme, seed), sizes Small 30×24 / Medium 36×30 / Large 42×34, `arenaFor(id, size)` with a seeded mirror-symmetric generator (Canyon Small returns `CANYON`); world and size names in all five languages; `worlds.test.ts` checks the catalogue, ground ratios, free and reachable spawns / start / dummies (flood fill from the centre — a straight line would fail for Canyon's own back spawn), ≥ 9 spawns, growing cover and stable layouts. `cd ui; npm test` 324 passed, `npm run check` 0 errors. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.06 M tokens · CHF 1.18 (141 credits)

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

**Done (2026-11-18 · ~7m · Claude Opus 5.5)** — progress v8 (`worldCoins`, `worldSteps`, `worlds`, `selectedWorld`, `worldCodes`) with v2–v7 migration (free worlds in Small, Canyon Small, 250 world coins per 500-step reached) and reset; tab merge (coins as a delta with a refund for a world bought in both tabs, bigger size, larger steps, later code date, local choice; a reset wins); world numbers in `settings.ts` and `game/worldShop.ts` (`worldCoinsFor`, `earnWorldCoins`, `buyWorld`, `growWorld`, `chosenWorld`, `chooseWorld`, refusals with the missing amount; credits and hacks never count); `Arena.svelte` pays world coins after a match and keeps `earnedWorldCoins` for the result screen (Step 5). No new visible text yet. `cd ui; npm test` 352 passed, `npm run check` 0 errors. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 4.22 M tokens · CHF 1.73 (206 credits)
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

**Done (2026-11-18 · ~18m · Claude Opus 5.5)** — `models/arena3d.ts`: `WORLD_LOOKS` for all 13 themes (tiles, floor, sky, border: cliffs / trees / docks and water / clouds / buildings / lollipops / dunes; walls: rock / ruin / crates / crystal / house / machine / blocks / logs; cover: cacti / ferns / neon posts / clouds / crystals / mushrooms / hedges / sweets / palms), `buildArena(arena, theme)` merges border, walls, cover and decorations by material (a few draw calls instead of ~1000; Canyon draws exactly as before — pinned by a triangle/position/colour fingerprint), `disposeArena`, `shadowReach`; `ArenaScene.svelte` draws `world.arena` with an optional `theme` prop (Canyon by default — `Arena.svelte` passes the chosen world and uses `look.sky` for its background in Step 4), overtime bursts in the theme's colours, the shadow area covers Large; `/?gallery=worlds&world=<id>&size=<size>` (`WorldGallery.svelte`, names from the existing i18n keys, `data-fps`); `arena3d.test.ts`; architecture lines for `arena3d.ts` and the gallery. `cd ui; npm test` 357 passed, `npm run check` 0 errors, `npm run build` ok; browser (integrated browser, viewport emulated at 820 × 1180 via CDP): all 13 worlds in Large in the gallery at 60 fps (desktop GPU, not a real iPad), screenshots of Lava Forge, Neon Docks, Candy Factory, Jungle Ruins, Sky Islands, Crystal Caves, Mini City, Kata Jungle, Robot Workshop, Pirate Cove, Moon Base, Desert Oasis and Canyon; a Canyon match (`?seconds=20&bots=3`) at 820 × 1180 at 60 fps through overtime to the result, no page errors; `/?gallery` fighters unchanged. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 11.75 M tokens · CHF 3.95 (472 credits)

---

## Step 4 — Matches and Training in the chosen world

### Goal
Matches and Training are played in the account's chosen world and size, with the same rules
as today (S1, S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Arena.svelte` and the match / Training start use `arenaFor(selectedWorld)` instead of
      `CANYON`; overtime removes the cover of any world.
- [x] Bots (D5): walk towards the nearest fighter after 6 seconds without seeing anyone.
- [x] Tests: a bots-only match ends with a winner in every Large world within the match time
      (fixed random seed); Training dummies and start in every world; overtime empties walls
      and bushes of a Large world.
- [x] Check: `npm test; npm run check`; in the browser, a short match (`?seconds=20&bots=3`)
      in a Large world and Training in a Medium world.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 14:06

**Done (2026-11-18 · ~9m · Claude Sonnet 5.5)** — `Arena.svelte` plays Matches and Training in `arenaFor(chosenWorld(progress))` with the world's `theme` passed to `ArenaScene` and the world's sky colours as the background (rooms still use Canyon Small until Step 6); `bots.ts`: a bot that has seen nobody for `SEEK_AFTER_SECONDS` (6) walks towards the nearest opponent that is still in (D5; `lastSeenAt` in `BotState`); tests: seek rule (fails with the rule off), bots-only match in all 13 Large worlds ends with a win or defeat within the match time (seeded), Training dummies and start in every world × size, overtime empties walls and bushes of every Large world; architecture lines for Match / Training and `bots.ts`. No new visible text. `cd ui; npm test` 361 passed, `npm run check` 0 errors. Browser (headless Chromium with software rendering, so frame rate is not meaningful; 820 × 1180): Large Neon Docks match (`?seconds=20&bots=3&overtime=5`) with the Neon sky, themed cover, overtime removing the walls, through to the result (410 × 590 run), and Training in Jungle Ruins Medium with its dummies and walking; no page errors. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 3.86 M tokens · CHF 0.75 (89 credits)

---

## Step 5 — World screen: choose, buy and grow worlds

### Goal
Players see their world coins, choose a world and size before Play and Training, and buy
worlds and bigger sizes; the result screen shows world coins earned (S1, S3, S8, S9, S11–S13,
S22, S23).

### Tasks
- [x] Record the start time in Notes below.
- [x] Home: world-coin balance next to the credits.
- [x] `WorldScreen.svelte` (D12): every world with its size buttons; unlocked ones selectable,
      locked ones with their prices (500 / 750 / 1000, +250 per size); buy and grow with
      confirmation; "N more world coins needed" when too few; the choice is saved.
- [x] Play and Training open the world screen first, preselected on the last choice, with
      **Start**.
- [x] Result screen: "+250 world coins" when a step was reached.
- [x] Texts in all five languages; mouse and touch; desktop, iPad and phone in portrait and
      landscape.
- [x] Check: `npm test; npm run check`; in the browser at the three sizes: buy a world with
      enough and with too few coins, grow a free world to Medium, choose it, start a match,
      reload — all kept; screenshots.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 14:17

**Done (2026-11-18 · ~14m · Claude Sonnet 5.5)** — WorldScreen.svelte (D12): every world with Small / Medium / Large buttons (unlocked: choose, saved at once; next size: price and confirmation dialog; `N more world coins needed` with a disabled Buy when too few; locked sizes wait for the smaller one), balance and **Start**; the pure rule `worldOffers` in `game/worldShop.ts` (what each size button does, with prices and the missing amount; 4 new tests); Play and Training open the world screen first (`App.svelte`), preselected on the last choice; Home shows the world-coin balance next to the credits; the result screen shows `+N world coins`; 16 new texts in en, de, gsw, es, it; architecture line. `cd ui; npm test` 365 passed, `npm run check` 0 errors, `npm run build` ok. Browser (integrated browser; desktop 1280 wide, iPad 820 × 1180, phone 390 × 844 portrait and 844 × 390 landscape through same-origin iframes, mouse only — touch not emulated): bought Lava Forge Small with 800 world coins (→ 300), grew Jungle Ruins to Medium (→ 50), Sky Islands refused with `450 more world coins needed` (nothing changed), chose Jungle Ruins Medium, Start → arena, reload and Play again: balance, bought world, Medium and the choice all kept; Training also opens the world screen; screenshots of all sizes looked right. The result line `+250 world coins` was checked only with a temporary forced value (a time-up match pays 0 trophies and a win could not be played by script); the earning itself is covered by the Step 2 tests. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 8.24 M tokens · CHF 1.34 (160 credits)

---

## Step 6 — Worlds in friends' rooms

### Goal
Friends play in the host's world and size; friends on the previous version only in Canyon
Small (S7).

### Tasks
- [x] Record the start time in Notes below.
- [x] `net/shared.ts`: the start settings carry `world`; guests build the host's arena.
- [x] `net/room.ts` and `server/.../rooms.py`: member `version` (D11); on a start outside Canyon
      Small, members without it are removed with the room-error message; the host sees who and
      why.
- [x] The host chooses the world on the world screen before **START**.
- [x] Tests: server — joins with and without `version`; removal on start outside Canyon Small,
      none in Canyon Small (`server/tests/test_rooms.py`); UI — start info with the world;
      a guest builds the same arena as the host.
- [x] Check: `cd server; uv run --no-sync pytest`; `cd ui; npm test; npm run check`; two
      browser tabs: host in a Large world, friend joins and plays in it.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 14:32

**Done (2026-11-18 · ~10m · Claude Opus 5.5)** — `net/shared.ts`: the start settings carry `world: { id, size }` (`startInfo(…, world)`, the host's `chosenWorld`); `sharedWorld` / `sharedArena` build the same arena and theme on every device (a start without a known world, from a previous host, is Canyon Small); friends play there even if they have not unlocked it; `startInfo` leaves out friends without `version` outside Canyon Small and `HostMatch` hands a late-removed friend to a bot. `net/room.ts`: members send `version: 2` (`ROOM_VERSION`), `canPlayIn`, the room state keeps `removed`. `rooms.py`: `Member.version` (optional, strict 2–99); on a start outside Canyon Small the server removes members without it with the room-error message `update-the-game` (shown as is by previous versions), sends the host `removed` with who, and announces the room; a removed socket can only create or join again. The host's **START** opens the world screen first (`App.svelte`); the lobby tags friends with an older game and, after the start, says who had to leave and why; `Arena.svelte` plays rooms in the host's world with its sky. 3 new texts in en, de, gsw, es, it; two architecture lines. Tests: server — joins with and without `version`, bad versions refused, removal on a Large start (old friend gets the error, host gets `removed`, its input no longer reaches the host), none in Canyon Small or with no world; UI — start info with the world, a guest builds the same arena as the host from the JSON start (Large Neon Docks, walls, bushes, spawns, walking far), unknown world → Canyon Small, old friends left out outside Canyon Small, `removed` → bot. `cd server; uv run --no-sync pytest` 52 passed; `cd ui; npm test` 368 passed, `npm run check` 0 errors. Browser (headless Chromium, two separate browser contexts as two tabs, 1000 × 700): host with Neon Docks Large chosen creates a room, a fresh friend (free worlds in Small only) joins, host START → world screen (Neon Docks · Large) → START; both play in Large Neon Docks (same sky and layout), the friend walks in it; and with a previous-version friend (raw WebSocket without `version`): the lobby shows "Older game: plays only in Canyon · Small", on the Large start the old client gets `update-the-game`, and back in the lobby the host reads "Player 2 (Rocko) had to leave: …"; no page errors. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 7.65 M tokens · CHF 2.74 (327 credits)

---

## Step 7 — World-coin hack codes

### Goal
Ten world-coin codes give 500 or 1000 world coins, once per 30 days per account, shown on the
hack screen and printed on the QR page (S14–S18, S21).

### Tasks
- [x] Record the start time in Notes below.
- [x] `server/.../world_codes.py` (D9): `WORLD_CODE_REUSE_DAYS`, five codes of 500 and five of
      1000; `hacks.py` / `app.py`: redeem and list include them with `world_coins` and
      `reuse_days`.
- [x] `hacks.ts` and `HackScreen.svelte`: a world-coin code adds its coins and stores its next
      date; before that date it is refused with the date; a list of used codes with the dates
      they work again.
- [x] `QrPage.svelte`: the world-coin codes with their amounts.
- [x] Texts in all five languages.
- [x] Tests: server — every code unique, amounts 500 / 1000, reuse days 30, redeem answers;
      UI — use, refuse before 30 days with the date, accept after, other account independent,
      reset clears the dates (S21).
- [x] Check: `cd server; uv run --no-sync pytest`; `cd ui; npm test; npm run check`; in the
      browser: redeem a code, try again (refused with date), switch account (works), QR page.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 14:43

**Done (2026-11-18 · ~6m · Claude Sonnet 5.5)** — `server/.../world_codes.py`: `WORLD_CODE_REUSE_DAYS = 30` and ten codes (`WC5-7K2QX` … five of 500, `WC1-K3W7P` … five of 1000; unique, no vowels or 0/1 so never a word). `hacks.py`: `Hack` gets optional `world_coins` and `reuse_days`; `ALL_HACKS` adds one hack per world code, so `/api/hacks` (QR page) and `/api/hacks/redeem` (any case, spaces trimmed) include them; the five old hacks are unchanged. `hacks.ts`: `isWorldCode`, `useWorldCode` (adds the coins and stores `worldCodes[id] = now + reuse_days`; before that date it answers `wait` with the date), `usedWorldCodes`, `formatCodeDate` (Swiss German → `de-CH`). `HackScreen.svelte`: a world-coin code adds its coins and is celebrated; a used code is refused with "It works again on {date}"; a list "Used world-coin codes" with the dates; `QrPage.svelte`: the ten codes with amount and waiting time. 5 new texts in en, de, gsw, es, it. Tests: server — five normal hacks unchanged, ten codes (five of each amount, 30 days, unique ids and codes, non-word pattern), redeem answers, normal hacks without the new fields; UI — world code detection, use, refuse before 30 days with the date and accept after, other code and other account independent, used list, reset clears the dates (S21), date in the language. `cd server; uv run --no-sync pytest` 56 passed; `cd ui; npm test` 375 passed, `npm run check` 0 errors. Browser (Vite dev + API, integrated Chromium): `?hack=WC5-7K2QX` → 500 world coins, "HACKED!" and the used list; entering it again → "You already used this code. It works again on December 18, 2026." with coins unchanged; a new account "Mia" redeemed the same code (500) while Player 1 kept its date; `/?qr` with password `M6D2` shows 15 QR codes, the ten world-coin codes with 500 / 1000 and "Once every 30 days for each player."; servers stopped. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 5.14 M tokens · CHF 0.92 (110 credits)

---

## Step 8 — Documentation and final check

### Goal
The documents describe worlds and world coins, and everything that worked before still works
(S19, S22, S23, S24).

### Tasks
- [x] Record the start time in Notes below.
- [x] `README.md`: worlds and sizes, world coins and prices, world-coin codes (table of how they
      work, not the codes themselves), the world screen.
- [x] `docs/architecture.md`: `worlds.ts`, `worldShop.ts`, themes, progress v8 and merge rules,
      room `world` and member `version`, `world_codes.py`.
- [x] Full check: `cd server; uv run --no-sync pytest`; `cd ui; npm test; npm run check;
      npm run build`; in the browser, one pass over S1–S24 on desktop and phone, including a
      reload, a second tab and an old save.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

Started: 2026-11-18 14:49

**Done (2026-11-18 · ~20m · Claude Haiku 5.5)** — `README.md`: worlds and sizes, free worlds and prices, world coins, the world-coin code rules (no codes listed), the world screen and friends' worlds; `docs/architecture.md`: worlds and shop, themes, progress v8 and merge rules, room `world` and member `version`, world codes (extended the existing lines, no duplicates); no code changed. Check: server `uv run --no-sync pytest` 56 passed; `npm test` 375 passed; `npm run check` 0 errors; `npm run build` passed (chunk-size warning only). Browser pass on the dev server and API: desktop with mouse, phone 390×844 with touch, tablet and landscape layouts; S1–S6, S8–S13, S15–S16, S18–S22 (German checked, other languages by `i18n.test.ts`), S19 with reload, a second tab and a v7 save (1240 trophies → 500 coins), S23 except below, S24; S17 by reading the code. Partly: S7 (a room started in Neon Docks Medium with a friend, but the friend shared the host's storage; the not-unlocked and old-version rules are covered by `room.test.ts`, `shared.test.ts` and `test_rooms.py`). Not verified: Large-world smoothness on a real iPad (headless ~30 fps is not a device test); the camera QR scan. Found: the reset warning does not name world coins (see Deferred Items). suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · 19.72 M tokens · CHF 1.15 (137 credits)

---

## Deferred Items

Tasks set aside for a future spec, so nothing is forgotten.

| Task | Reason | Target Spec |
|------|--------|------------------|
| Server-side record of used world-coin codes (D10) | The game has no server accounts; clearing the browser's data lets a code be used early | a later accounts spec, if wanted |
| Music or rules of their own per world | Part 1 asks for looks and layouts only (S6) | a later spec, if wanted |
| Real-device check of Large worlds on an iPad and phone | Real-device testing is spec 5's subject | [Device and end-to-end testing](../2026_11_14_5_device_and_end_to_end_testing_spec.md) |
| Reset warning (`settings.resetWarning`, five languages) names credits, trophies, fighters, power and skins only | Found in the browser pass: the reset does clear world coins, worlds and world-coin codes (S21), but the text does not say so | a later spec, if wanted |
| **Fix first (review finding 1, Should-fix, target "fix now"):** two stale tabs of one account that both cross the **same** 500-trophy step both keep their 250 world coins (495 → 515 trophies ends with `worldCoins: 500`, `worldSteps: 1`). `mergeProgress` merges `worldCoins` as a delta and `worldSteps` by max, with no refund for a step paid in both tabs (as `worldRefund` has for worlds). Add the refund and a two-tab test. | S9 "each step pays only once" is broken in this race. Not fixed in this spec (CLOSE changes no code); it needs two tabs of the same account finishing matches at once and only gives coins, so it was not Blocking | **fix now** — a follow-up fix to S9 / D7 (no spec yet) |
| Bots seek a player hiding in a bush (review finding 2, Should-fix, plan decision): the seek rule (D5) skips `canSee`, so after 6 s a bot walks straight to a player in a bush, also in Canyon Small (26.6 → 5.4 after 12 s; before it stopped at 13.9). Decide whether to seek only fighters not in a bush, or only in Medium / Large, and note it in D5 | D2 says Canyon Small matches stay identical and S6 keeps today's rules, but D5 does not say whether hiding still works | needs a plan decision on D5 / D2 (a follow-up fix or a small spec) |
| "It works again on *date*" names the day, but `useWorldCode` stores `now + 30 × 24 h` (review finding 3, Nit): on that day the code is still refused until the time of day it was used, and across a DST change the day can shift. Round `nextUseAt` to the start of the local day, or show the time | Nit; found in the review | a later spec, if wanted |
| The server removes friends without `version` for any start whose world is not exactly Canyon Small — also an unknown or malformed world, for which every client falls back to Canyon Small (review finding 4, Nit). Check the id and size against the catalogue so both sides agree | Only a modified host can send it | a later spec, if wanted |
| Unused `SETTINGS` import in `WorldScreen.svelte` (review finding 5, Nit, target "fix now") | Dead code; not removed because CLOSE changes no code | a follow-up fix (no spec yet) |
| The ten world-coin codes are readable without the QR password from `GET /api/hacks` and in `world_codes.py` (review finding 6, Nit): the 30-day limit is a speed bump, not a lock | Accepted by D9 / D10 for a kids' game; belongs with "Server-side record of used world-coin codes" above | a later accounts spec, if wanted |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-18 | Claude Opus 5.5 | semantic diff | — | [review page](../../review/2026-11-18_feature-worlds-and-world-coins.html) |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S24 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked; `uv run pytest`, `npm test`, `npm run check` and `npm run build` pass; README / `docs/architecture.md` updated where affected
- [x] Review · review page written; no Blocking finding open
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
