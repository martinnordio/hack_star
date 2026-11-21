# Worlds and World Coins Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/worlds-and-world-coins`
> **Moved from:** [2026_11_16_worlds_and_world_coins_spec.md](https://github.com/martinnordio/hack_star/blob/feature/worlds-and-world-coins/.specs/features/done/2026_11_16_worlds_and_world_coins_spec.md) (#24)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_16_worlds_and_world_coins_spec.md on the branch feature/worlds-and-world-coins (requirements only) |

---

# Part 1 · Requirements

## Context

Every match and every Training session is played in the same arena, the same size. Players
want to choose between several **worlds**, each in a small, medium and large size, so matches
feel different and bigger worlds mean more running. The free worlds come in small; other worlds
and bigger sizes are unlocked with a new currency, **world coins**, which players earn by
collecting trophies or get from special hack codes that can be used again after 30 days.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](https://github.com/martinnordio/hack_star/blob/feature/worlds-and-world-coins/.specs/features/done/2026_11_16_worlds_and_world_coins_spec.md) (#24, on the branch `feature/worlds-and-world-coins`).
- One arena, `CANYON` (30 × 24, with walls, bushes, decorations, Training dummies, start and
  spawn points), read for the movement limits; overtime removes its walls and bushes. Today's
  arena becomes the first free world in Small. In the Godot game: spec 01's arena and
  [graphics demo spec](2026_11_12_06_graphics_demo_spec.md),
  [first match spec](2026_11_12_07_first_match_spec.md) and
  [overtime and match options spec](2026_11_12_11_overtime_and_match_options_spec.md).
- **Play** and **Training** start the same arena in a different mode (spec 07).
- [Play with friends spec](2026_11_12_14_play_with_friends_spec.md) — the host sends the match
  settings (match length, overtime, bot count and level) to friends when the room starts;
  friends mirror the host's match.
- Per-account progress: trophies per fighter, total trophies, credits, unlocked fighters,
  active hacks with expiry dates; accounts kept in sync across tabs; the
  [Fighter studio, saves and music spec](2026_11_14_17_fighter_studio_saves_and_music_spec.md)
  made sure every choice is kept.
- [Trophies spec](2026_11_12_08_trophies_spec.md) — trophies per match (+10 for a win, never
  below the last Prestige level); Prestige every 1000 total trophies.
- [Unlock and upgrade spec](2026_11_12_09_unlock_and_upgrade_spec.md) and
  [skins shop spec](2026_11_12_10_skins_shop_spec.md) — credits: earning, paying, prices;
  refusal when there are not enough.
- [Hack codes spec](2026_11_12_05_hack_codes_spec.md) — hack codes are checked and applied to
  the account; timed hacks last 72 hours (3 days, [bug fixes spec](2026_11_14_16_bug_fixes_spec.md));
  the QR page (password `M6D2`) prints every code. There is no per-code "already used" record
  today.
- Five languages (English, Deutsch, Schwiizerdütsch, Español, Italiano) — spec
  [15](2026_11_13_15_accounts_fighters_and_languages_spec.md).

**New:**
- Several original worlds, each in three sizes, and a world choice before Play, Training and
  a friends' room.
- World coins: earned per 500 trophies, spent to unlock worlds and sizes.
- World-coin hack codes that each account can use once every 30 days.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and product questions |
| [ideas.md](../../../.specs/features/ideas.md) | Where this request came from |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–17) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.

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
- ~~**S24 — Documentation:** The README and `docs/architecture.md` describe worlds, sizes,
  world coins, prices and the world-coin codes.~~ (replaced for the Godot game by S25: it names
  the documents of the Python + Svelte game)
- **S25 — Documentation (Godot):** `hack_star_godot/README.md` and
  `hack_star_godot/docs/architecture.md` describe worlds, sizes, world coins, prices and the
  world-coin codes.

### Open questions

_None — answered on 2026-11-16._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
