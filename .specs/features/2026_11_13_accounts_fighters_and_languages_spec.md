# Accounts, Create a Fighter, New Fighters and Languages Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-13
> **Last updated:** 2026-11-13
> **Branch:** `feature/accounts-fighters-and-languages`
> **Issue:** #15

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written; revised: open questions answered (rename, full reset, re-create cost, CREATOR, exact password, language per account, new fighters invented) |
| 2026-11-13 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #15 created |

---

# Part 1 · Requirements

## Context

Mattia and his friends share one device and want their own progress, a fighter they design
themselves, more and better-looking fighters and skins, and the game in their own language.
Parents want to start over (reset) and to keep the printed QR codes away from the kids. All of
it is in one spec, as the user asked.

The QR password and the hack codes are visible in the public source on GitHub and through
`GET /api/hacks`: the password keeps kids from printing the codes, it is not real security —
agreed as enough.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- Progress is saved in the browser (`ui/src/lib/progress.ts`, `localStorage`, version 3):
  credits, trophies per fighter, power levels, unlocked fighters, skins, active hack codes. It is
  already kept after closing the game, but there is only **one** progress per browser. A new
  player starts with 500 credits and sample trophies.
- The Settings screen (`ui/src/lib/SettingsScreen.svelte`, F8) has bot level and number of
  bots, saved per device (`options.ts`).
- 10 fighters with 5 types (`server/src/hack_star_server/fighters.py`, F9), built in 3D from
  simple shapes (`ui/src/lib/models/fighters3d.ts`, ~35 lines each) with portraits
  (`portraits.ts`); Blaze, Rocko and Turbo are unlocked at the start. The gallery page
  (`/?gallery`) shows them all.
- Each fighter has 1–2 skins besides the default; the shop sells them by rarity with a skin of
  the day (F7, `ShopScreen.svelte`, `game/shop.ts`).
- 4 hack codes (`hacks.py`: INFINITY, OPENSESAME, POWER22, HYPERCHARGE), typed or scanned
  (F2, F10). The print page `/?qr` (`QrPage.svelte`) shows every code as a QR code, with no
  password. The codes are also returned by `GET /api/hacks`.
- Play with friends (F11, `FriendsScreen.svelte`, `net/room.ts`) sends each player's fighter
  id, skin and power to the others.
- All text is in English, written directly in the components; the Info page has the game
  vocabulary (`vocabulary.ts`).

**New:**
- Up to 5 accounts per device, each with its own progress; switching between them.
- Resetting an account to the start (credits, trophies, fighters, power levels, skins).
- A fighter the player designs, locked until a new hack code is entered.
- A password before the QR codes are shown.
- 3 more skins for every fighter; 5 new fighters with much better graphics.
- The game in English, German, Swiss German, Spanish and Italian.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

### Accounts

- **S1 — Create an account:** The player can add an account by typing a name of 1–16
  characters. A name that is empty or already used (ignoring upper/lower case) is refused with a
  message saying why.
- **S2 — Up to 5 accounts:** A device holds at most 5 accounts; trying to add a sixth shows
  "You can have up to 5 accounts" and adds nothing.
- **S3 — Switch account:** The home screen shows the name of the current account. The player can
  switch to another account from the home screen in at most two taps; afterwards credits,
  trophies, fighters, power levels, skins, active hack codes and the created fighter (S10) are
  those of the chosen account.
- **S4 — Keep everything:** All accounts, their progress and the account used last are still
  there after the browser is closed and the game is opened again on the same device and browser.
- **S5 — Existing progress:** The first time the new version starts, the progress already saved
  on the device becomes the first account, named "Player 1"; nothing is lost. A brand-new
  account starts like a new player today (500 credits, the start fighters of S15 unlocked) but
  with 0 trophies.

### Reset

- **S6 — Reset coins and trophies:** Settings has a button to reset the coins and trophies.
  After the player confirms, the current account has 0 credits, every fighter has 0 trophies
  (so no Prestige badges), only the start fighters (S15) are unlocked, every fighter is back to
  power level 1 and only the default skins are owned and worn. The account's name, language,
  active hack codes and created fighter (with 0 trophies) are kept. Cancelling changes nothing;
  other accounts are not changed.

### Create a fighter

- **S7 — Create button:** The fighter list always shows a "Create a fighter" entry.
- **S8 — Design:** The player gives the fighter a name (1–12 characters), picks one of the 5
  types, a main and a second colour (from at least 8 colours each) and a look (at least 3
  different heads and 3 different bodies). A 3D preview shows the fighter while choosing.
- **S9 — Only one:** Each account has at most one created fighter. When it already has one, the
  entry opens that fighter instead of creating a second one. Creating it the first time is free.
- **S10 — Locked:** The created fighter appears in the fighter list with a lock and cannot be
  selected or played until the new hack code (S11) has been entered on that account. Its lock
  says that a hack code is needed. It cannot be unlocked with credits.
- **S11 — New hack code:** The new hack code `CREATOR`, typed or scanned like the others, unlocks the
  created fighter of the current account. It is listed on the QR print page. Entered before a
  fighter is created, it is accepted, and the fighter is unlocked as soon as it is created.
- **S12 — Play with it:** Once unlocked, the created fighter can be selected and played in
  matches, Training and with friends like any fighter of its type: it gets trophies and power
  levels. Friends on other devices see it with its name, colours and look.

### QR codes

- **S13 — Password for the QR codes:** Opening the QR print page first asks for a password. Only
  `M6D2` shows the codes; any other password shows "Wrong password" and no codes. The password
  is asked every time the page is opened. Upper case only: `m6d2` is wrong.

### More skins

- **S14 — Three more skins:** Each of the 15 fighters (the 10 of today and the 5 of S15) gets 3
  new skins, each with its own name, a rarity, and a look that is clearly different from the
  fighter's other skins (other colours and at least one different part). They can be bought in
  the shop at the price of their rarity and can be the skin of the day. The created fighter has
  no skins.

### New fighters

- **S15 — Five new fighters:** 5 new fighters, each with its type's attack and Super:

  | Name | Idea | Type | Rarity | At the start |
  |------|------|------|--------|--------------|
  | Marina | Surfer girl who rides her own wave and splashes water | speedy | Rare | **unlocked** |
  | Drako | Baby dragon with shiny scales who breathes fire waves | spreader | Epic | locked |
  | Spectra | Ghost magician who throws glowing cards | thrower | Epic | locked |
  | Mecha Max | Kid piloting a giant robot suit | tank | Mythic | locked |
  | Zeus Jr. | Little thunder god who shoots lightning bolts | sharpshooter | Legendary | locked |

  The start fighters are Blaze, Rocko, Turbo and Marina; the 4 locked ones are unlocked with
  credits like the others today.
- **S16 — Much nicer graphics:** The 5 new fighters look clearly more detailed and impressive
  than the current ones: compared side by side on the gallery page, each has a more detailed
  body (at least twice as many parts as a current fighter), shiny or glowing materials, and an
  idle animation in which at least 3 parts move. Mattia agrees they look nicer.
- **S17 — Still smooth:** A match with the new fighters still runs smoothly on an iPad (no
  visible stutter), as matches do today.

### Languages

- **S18 — Choose a language:** Settings lets the player choose English, Deutsch,
  Schwiizerdütsch, Español or Italiano. Every text on the screen changes at once, without
  reloading.
- **S19 — Everything translated:** Every text the player sees — menus, buttons, messages,
  results, the Info page with the vocabulary, hack code descriptions, fighter ideas and the new
  screens of this spec — exists in all 5 languages. Names of fighters, skins and hack codes stay
  the same in every language.
- **S20 — Language per account:** Each account has its own language, kept after the game is
  closed; switching account (S3) switches to that account's language. A new account starts with
  the browser's language if it is one of the five (Swiss German for `de-CH`), otherwise English.
  Swiss German is written as Zurich German; mistakes are fixed when found.

### Everywhere

- **S21 — Screens and input:** The new screens (accounts, reset, create a fighter, password,
  language) work on a desktop browser, an iPad and a phone, in portrait and landscape, with touch
  as well as mouse and keyboard.
- **S22 — Keeps working:** Matches, Training, the shop, the existing hack codes and playing with
  friends work as before; friends using different languages or accounts can play together.

- **S23 — Rename, no delete:** The player can rename an account (same rules as S1). Accounts
  cannot be deleted.
- **S24 — Change the created fighter:** The player can change the created fighter's name, type,
  colours and look. Each change costs 500 credits (free with the INFINITY code); with fewer
  credits the change is refused with a message saying how many are missing. The fighter keeps
  its trophies, power level and lock state.

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
