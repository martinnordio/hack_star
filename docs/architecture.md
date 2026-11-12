# Architecture

How Hack star is built, for anyone who changes it. What the game must do is in the specs
([.specs/features/](../.specs/features/)); this page explains where things are and how they fit.

```mermaid
flowchart LR
  subgraph Browser["Browser (desktop, iPad, phone)"]
    App["App.svelte<br/>screens"] --> Screens["Home · Fighters · Info · Hack · Arena"]
    Screens --> Game["game/<br/>rules: World, Match, Bots"]
    Screens --> Models["models/<br/>3D fighters, arena, effects"]
    Screens --> Progress["progress.ts<br/>localStorage"]
  end
  Screens -- "/api (Vite proxy)" --> Server["Python server<br/>FastAPI :8180"]
```

## Two parts

| Part | Folder | Runs | Does |
|------|--------|------|------|
| Server | `server/` | Python 3.13, FastAPI, port 8180 | Game data: the fighter catalogue, hack codes |
| UI | `ui/` | Svelte 5 + Vite, port 5180 | Everything the player sees and plays; 3D with Threlte (Three.js) |

In development Vite forwards `/api/...` to the server, so the browser only talks to one
address (also from an iPad or phone on the Wi-Fi).

### Server API

| Endpoint | Returns |
|----------|---------|
| `GET /api/health` | `{"status": "ok"}` |
| `GET /api/fighters` | The 6 fighters with rarity and skins (`server/src/hack_star_server/fighters.py`) |
| `GET /api/hacks` | The hack codes (`hacks.py`), for the printable QR page |
| `POST /api/hacks/redeem` `{"code"}` | The hack for a code (any case, spaces trimmed), or 404 "Unknown code" |

Matches do **not** use the server: they run in the browser so Wi-Fi delays never matter.

## UI

### Screens (`ui/src/`)

`App.svelte` loads fighters and hacks from the server and switches screens with one `screen`
value (no router):

| Screen | File | Notes |
|--------|------|-------|
| Home | `lib/Home.svelte`, `lib/HomeScene.svelte` | 3D fighter on a podium, entrance animation |
| Fighters / Fighter | `lib/FighterList.svelte`, `lib/FighterDetail.svelte` | Pictures come from `lib/portraits.ts` (one off-screen renderer, cached); skins can be tried on and bought |
| Shop | `lib/ShopScreen.svelte` | Skin of the day first, then every skin; buy, "NEW SKIN!", Wear it |
| Info | `lib/InfoPage.svelte`, `lib/vocabulary.ts` | The words kids use |
| Hack | `lib/HackScreen.svelte`, `lib/QrScanner.svelte` | Codes typed or scanned; `/?qr` shows `lib/QrPage.svelte` |
| Match / Training | `lib/Arena.svelte` (HTML: joysticks, HUD, result), `lib/ArenaScene.svelte` (3D) | A new `Arena` is mounted per match |

Extra pages by address: `/?qr` (printable QR codes), `/?gallery` (all fighters and skins).

### Game rules (`ui/src/lib/game/`)

Plain TypeScript, no drawing, all tested with `vitest`:

| File | What |
|------|------|
| `arena.ts` | The canyon layout: walls, bushes (cacti), decorations, dummies, start points |
| `world.ts` | `World`: fighters (fighter 0 is the player) with health and damage from their power level, shots with owners (a shot does its shooter's damage), collisions (circles against rectangles), healing, knock-outs, dummies; emits events for effects |
| `match.ts` | `Match`: countdown, timer, result (victory, defeat with place, time's up) around a `World` |
| `bots.ts` | `Bots`: each bot picks the nearest fighter it can see, reacts after a delay, closes in, circles, shoots with an aim error; wanders when it sees nobody |
| `controls.ts` | Input shared between the HTML layer and the frame loop (keys, mouse, joysticks) |
| `trophies.ts` | `rewardFor(trophies, result, settings)`: trophies after a match with the Prestige floor; `applyReward()` saves them into the progress |
| `economy.ts` | Credits and power: `unlockPrice`, `upgradeCost`, `stats(level)` (health and damage), `creditsFor(result)`, and the purchases `unlock()` / `upgrade()` (progress in, new progress or the reason out — not enough credits, max power, owned…); `powerOf()` caps a level at the current maximum |
| `shop.ts` | Skins: `ownsSkin` (default skins and the OPENSESAME hack count as owned), `wornSkin` (the chosen skin if owned, else Default), `skinOfTheDay(date)` (picked from the local day number, same for everyone that day), `skinPrice`, and the purchase `buySkin()` |
| `settings.ts` | `SETTINGS` (match length, bots, level, healing, trophies, credits, prices, power…) and `BOT_LEVELS`; `settingsFrom()` reads `?seconds=&bots=&level=` |

Every frame (`ArenaScene.svelte`, `useTask`): input → `match.update(dt)` (bots think, world
steps) → events turned into effects → 3D objects moved to match the world. Per-frame data stays
in plain objects and Three.js meshes, not in Svelte state, to keep phones fast; only the HUD
gets a Svelte update, and only when a shown value changes.

### 3D models (`ui/src/lib/models/`)

Everything is built in code from simple shapes, so there is no art to download or license:

| File | What |
|------|------|
| `parts.ts` | Toon material, outline ("inverted hull"), shape helpers, cartoon eyes, Legendary glow |
| `fighters3d.ts` | `buildFighter(id, skin)` for the 6 fighters and 14 skins; idle animation; see-through in bushes |
| `arena3d.ts` | Tiles, cliffs, rock walls, cacti, crates, barrels, skulls |
| `dummy3d.ts`, `healthBar.ts` | Training dummy; health bars |
| `particles.ts` | One pool of reused meshes for dust, flashes, sparks and pieces |

### Saved progress (`ui/src/lib/progress.ts`)

Per device in `localStorage` (no login): credits, trophies and power level per fighter,
unlocked fighters, owned skins, active hacks, chosen fighter and skins. The format has a
`version` (now 3); a version 2 save is migrated (its chosen skins become owned skins, so
nobody loses a skin), and anything else that does not match falls back to the starting
progress. Hack effects are worked out when shown
(`lib/hacks.ts`: `credits`, `isUnlocked`, `maxPower`, `currentFighter`), so resetting the hacks
brings the normal rules back exactly.

Trophies change in one place: when a match ends, `Arena.svelte` works out the reward
(`game/trophies.ts`) and the credits (`game/economy.ts`) for the fighter that played and saves
them at once, before the result screen opens, so leaving then still keeps them; leaving during
a match or playing Training saves nothing. Prestige is not stored: it is
`prestigeLevel(trophies)` (every 1000).

Spending happens only on the fighter screen and in the Shop through `unlock()` / `upgrade()` /
`buySkin()`. With the
unlimited-credits hack nothing is taken from the saved credits, so resetting the hacks shows
the real amount again.

## How to…

- **Change match settings:** edit `SETTINGS` in `ui/src/lib/game/settings.ts` (or try values
  with `?seconds=&bots=&level=`).
- **Add a fighter:** add it to `FIGHTERS` in `server/src/hack_star_server/fighters.py`, add a
  builder in `ui/src/lib/models/fighters3d.ts` and a shot colour in `ArenaScene.svelte`; check
  it with `/?gallery`.
- **Add a hack code:** add it to `HACKS` in `server/src/hack_star_server/hacks.py`, add its id
  to `HackId` and its effect in `ui/src/lib/hacks.ts`.
- **Add a spec:** use the spec kit — `Load .specs/kit/requirements/prompt.md` →
  `REQUIREMENTS: <name> — <request>`, then `PLAN:`. Every spec also updates this page and the
  README.

## Tests

| Command | Covers |
|---------|--------|
| `cd server; uv run pytest` | API: fighters, hacks |
| `cd ui; npm test` | Game rules, bots, match, trophies, credits and power, settings, progress, hacks, QR codes, vocabulary |
| `cd ui; npm run check` | Type checks (TypeScript and Svelte) |
