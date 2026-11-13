# Accounts, Create a Fighter, New Fighters and Languages Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed on feature/accounts-fighters-and-languages
> **Created:** 2026-11-13
> **Last updated:** 2026-11-13
> **Branch:** `feature/accounts-fighters-and-languages`
> **Issue:** #15

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written; revised: open questions answered (rename, full reset, re-create cost, CREATOR, exact password, language per account, new fighters invented) |
| 2026-11-13 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #15 created |
| 2026-11-13 | plan | `PLAN:` | Claude Opus 5.5 | Part 2 written |
| 2026-11-13 | review | `REVIEW:` | Claude Opus 5.5 | semantic diff written |
| 2026-11-13 | implementation | `CLOSE:` | Claude Opus 5.5 | spec closed (visual checks deferred) |
| 2026-11-13 | pr | `PR:` | Claude Opus 5.5 | pull request opened |

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
| [overall_req.md](../../overall_req.md) | Overall game idea and planned specs |
| [architecture.md](../../../docs/architecture.md) | How the code is organised |
| [README](../../../README.md) | How to install, run and play |

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

## Closing summary

**Built:** Up to 5 accounts per device (names, rename, switch from the home screen), each with
its own progress and language; the progress saved before becomes "Player 1". Settings has a
language picker (English, Deutsch, Schwiizerdütsch, Español, Italiano) and a reset of coins and
trophies. Every account can design one fighter (name, type, colours, head, body), unlocked only
by the new code `CREATOR` and playable in matches, Training and with friends; changing it costs
500 credits. The QR print page asks for the password `M6D2`. Five new, more detailed fighters
(Marina free at the start) and 3 more skins for each of the 15 fighters.
**Differs from the plan:** the created fighter's look travels in the skin id (D8, D11); the 45
skins are generated recolours with one extra part (D14); `START_FIGHTERS` is a constant matched
by a server test (D3); the kit gained the implementation and review stages on this branch; the
visual checks of Steps 9–11 are deferred (Deferred Items).
**Files:** `ui/src/lib/accounts.ts`, `progress.ts`, `created.ts`, `i18n/` (5 dictionaries),
`AccountsPanel.svelte`, `CreatorScreen.svelte`, `SettingsScreen.svelte`, `QrPage.svelte`,
`models/heroes3d.ts`, `skins3d.ts`, `custom3d.ts`, `parts.ts`; `server/src/hack_star_server/fighters.py`,
`hacks.py`, `rooms.py`; tests next to them; README, `docs/architecture.md`, `SPEC-NX.md`.

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Accounts: storage, migration, per-account progress | ✅ Done | [→ Step 1](#step-1--accounts-storage-migration-per-account-progress) |
| **2** | Accounts screen: create, rename, switch | ✅ Done | [→ Step 2](#step-2--accounts-screen-create-rename-switch) |
| **3** | Reset in Settings | ✅ Done | [→ Step 3](#step-3--reset-in-settings) |
| **4** | Languages: texts in one place, language per account | ✅ Done | [→ Step 4](#step-4--languages-texts-in-one-place-language-per-account) |
| **5** | Translations: German, Swiss German, Spanish, Italian | ✅ Done | [→ Step 5](#step-5--translations-german-swiss-german-spanish-italian) |
| **6** | Password for the QR codes | ✅ Done | [→ Step 6](#step-6--password-for-the-qr-codes) |
| **7** | Create a fighter and the CREATOR code | ✅ Done | [→ Step 7](#step-7--create-a-fighter-and-the-creator-code) |
| **8** | The created fighter in matches and with friends | ✅ Done | [→ Step 8](#step-8--the-created-fighter-in-matches-and-with-friends) |
| **9** | Five new fighters with nicer graphics | ✅ Done · visual check 🔜 Deferred | [→ Step 9](#step-9--five-new-fighters-with-nicer-graphics) |
| **10** | Three more skins for every fighter | ✅ Done · visual check 🔜 Deferred | [→ Step 10](#step-10--three-more-skins-for-every-fighter) |
| **11** | Everything still works; documentation | ✅ Done · visual check 🔜 Deferred | [→ Step 11](#step-11--everything-still-works-documentation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Accounts live under a new `localStorage` key `hack-star.accounts`: `{ version: 1, current, accounts: [{ id, name, language, progress }] }`, in a new `ui/src/lib/accounts.ts`. The existing `progress` store keeps its API and reads / writes the **current** account's progress | The rest of the game (Arena, Shop, Fighter screens) does not change; one place decides which account is active |
| D2 | On first start, a saved `hack-star.progress` (version 2 or 3) becomes account "Player 1"; the old key is left in place but no longer read | Nothing is lost (S5); keeping the old key makes a rollback to the previous version safe |
| D3 | Progress version 4 adds `createdFighter` (`null` or its look). New accounts start from `startProgress(fighters)`: 500 credits, 0 trophies, the catalogue's `unlocked_at_start` fighters. The sample trophies of today's `defaultProgress()` remain only for migration tests | S5 asks for 0 trophies on new accounts; the start fighters come from one place (the server catalogue), so Marina is included |
| D4 | Reset (`resetProgress`) is a pure function in `progress.ts`: start progress, but keeps `activeHacks` and `createdFighter`; trophies of the created fighter go to 0 | Testable without the UI; matches S6 exactly |
| D5 | Languages without a library: `ui/src/lib/i18n/` with one TypeScript dictionary per language (`en.ts`, `de.ts`, `gsw.ts`, `es.ts`, `it.ts`) and a `t` store derived from the current account's language. Every other dictionary is typed as `Record<keyof typeof en, string>`, so a missing text fails `npm run check` | Five small static dictionaries do not need a dependency; the type check enforces S19 |
| D6 | Texts that come from the server (hack names and descriptions, fighter ideas) are translated in the UI by id (`hack.<id>.description`, `fighter.<id>.idea`); the server stays English and is the fallback | Keeps the API unchanged; friends with other languages still exchange only ids |
| D7 | Swiss German uses the code `gsw` and is chosen for browsers reporting `de-CH`; written as Zurich German | `gsw` is the standard language code for Swiss German |
| D8 | The created fighter has the id `custom` in every account and is **not** in the server catalogue: the UI adds it to the fighter list from the progress (`withCreated(fighters, progress)`). Its look is `{ name, type, main, second, head, body }` with 8 colours, 3 heads and 3 bodies. *Changed while implementing (Step 7): the look travels as the skin id (`lookSkin()`, 16 characters).* | One created fighter per account (S9); no server storage needed |
| D9 | New hack `creator` (`CREATOR`) in `hacks.py`; `isUnlocked(progress, 'custom')` is true only with that hack and a created fighter; `unlock()` refuses `custom` | S10 and S11: the code is the only way to unlock it, also before it is created |
| D10 | Re-creating costs `SETTINGS.recreateCost = 500` and goes through the existing `pay()`, so INFINITY makes it free | One price setting; same rule as every purchase (S24) |
| D11 | Friends: the room `Member` gets an optional `look` (validated on the server: name ≤ 12 characters, known type, colours `#rrggbb`, head and body 0–2); `fighter: "custom"` is accepted only with a look. *Changed while implementing (Step 8): the look is in `skin`; the member gets an optional `name` instead of `look`.* | Friends draw the created fighter correctly (S12); the server still refuses bad data |
| D12 | The QR password is checked in the browser (`QrPage.svelte`), exact match `M6D2`, never stored | Agreed in Part 1: a lock for kids, not security; no server change |
| D13 | Nicer fighters (S16) stay code-built (no downloaded art): new helpers in `parts.ts` for shiny (`MeshStandardMaterial` with metalness / roughness) and glowing (emissive) parts, and a list of animated parts per rig so the idle animation can move several parts. Geometries and materials are shared between copies | No licence or download questions; sharing keeps matches fast on an iPad (S17) |
| D14 | The 45 new skins (3 × 15 fighters) are added to `fighters.py`; each builder gets a colour palette per skin plus at least one extra or changed part. *Changed while implementing (Step 10): `models/skins3d.ts` recolours the default look and adds one accessory per skin.* | The shop, skin of the day and gallery already work from the catalogue |

---

## Step 1 — Accounts: storage, migration, per-account progress

### Goal
Accounts are stored, migrated from today's progress and kept between visits, and the game
reads the current account's progress (S1, S2, S4, S5, S23 — logic only).

### Tasks
- [x] Record the start time in Notes below.
- [x] Progress version 4: `createdFighter` field, migration from version 3 (and 2), `startProgress(fighters)` (D3).
- [x] `ui/src/lib/accounts.ts`: load / save `hack-star.accounts`, migration of `hack-star.progress` into "Player 1" (D1, D2), `addAccount`, `renameAccount`, `switchAccount` with the rules of S1, S2 and S23 (1–16 characters, unique ignoring case, at most 5, no delete).
- [x] The `progress` store reads and writes the current account (D1); switching account changes it everywhere.
- [x] Unit tests (`accounts.test.ts`, `progress.test.ts`): migration keeps everything, name rules, sixth account refused, switching, saved and loaded again.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 16:40

- The start fighters are a constant `START_FIGHTERS` in `progress.ts` instead of being read from
  the catalogue (D3): accounts are loaded before the catalogue arrives. Step 9 adds Marina and a
  server test that the catalogue's `unlocked_at_start` matches it.
- The `progress` store moved to `accounts.ts` (8 screens import it from there); `progress.ts`
  keeps the pure functions, so there is no import cycle.
- Languages (`i18n/languages.ts`) were started here because every account stores one.

**Done (2026-11-13 · ~15m · Claude Opus 5.5)** — accounts store with migration, name rules,
switching and saving; `npm test` 149 passed (accounts 15 new), `npm run check` 0 errors.

---

## Step 2 — Accounts screen: create, rename, switch

### Goal
The player sees the current account on the home screen and creates, renames and switches
accounts (S1, S2, S3, S21, S23).

### Tasks
- [x] Record the start time in Notes below.
- [x] Home: account name button (top bar) opening an accounts panel; switch in at most two taps.
- [x] Accounts panel: list (current marked), add (name field, error messages of S1 and S2), rename.
- [x] Check in the browser at phone, iPad and desktop sizes, touch and mouse: create 5 accounts, a sixth is refused; switch and see other credits and trophies; reload and the last account is still active.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 16:57

- New `AccountsPanel.svelte`; the account chip sits under the trophies on the home screen.
- Browser check (1024×768 and 390×760): 5 accounts, the sixth shows "You can have up to 5
  accounts."; renaming to an existing name shows "That name is already used."; switching shows
  500 credits / 0 trophies on a new account and the old progress on Player 1; after a reload
  the last account is still active.

**Done (2026-11-13 · ~15m · Claude Opus 5.5)** — accounts panel (switch, add, rename) on the
home screen; `npm run check` 0 errors; checked in the browser at desktop and phone size.

---

## Step 3 — Reset in Settings

### Goal
The player resets the current account to the start after confirming (S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] `resetProgress()` (D4) with tests: 0 credits and trophies, start fighters only, power 1, default skins, hacks and created fighter kept; other accounts untouched.
- [x] Settings: "Reset coins and trophies" button with a confirmation; cancelling changes nothing.
- [x] Check in the browser: reset, see 0 credits, no Prestige badges, fighters locked again.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 17:12

- The reset only touches the current account: the progress store writes into it (Step 1), so
  the other accounts are untouched by construction.

**Done (2026-11-13 · ~8m · Claude Opus 5.5)** — `resetProgress()` and the confirm / cancel
button in Settings; `npm test` 150 passed, `npm run check` 0 errors; browser: cancel keeps
everything, confirm saves 0 credits.

---

## Step 4 — Languages: texts in one place, language per account

### Goal
Every text the player sees comes from the English dictionary, and each account has a language
chosen in Settings (S18, S20 — with English only filled).

### Tasks
- [x] Record the start time in Notes below.
- [x] `ui/src/lib/i18n/`: `en.ts`, `t` store from the current account's language, `{name}` placeholders, fallback to English (D5).
- [x] Move every visible text of every screen (including `vocabulary.ts`, results, errors, Arena HUD, QR page) into `en.ts`; server texts by id (D6).
- [x] Account `language`: set for new accounts from the browser language (`de-CH` → `gsw`, D7), else English; Settings: language picker; switching account switches language.
- [x] Tests: language of a new account from the browser language; switching account switches language; placeholders filled.
- [x] Check in the browser: every screen still shows the same English texts.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 17:22

- 264 keys in `ui/src/lib/i18n/en.ts`; `$t(key, params)` and `$tOr(key, fallback)` in the
  components; `vocabulary.ts` and the fighter types (`game/types.ts`: `nameKey`, `aboutKey`,
  `superNameKey`) hold keys instead of English text; room errors are keys, so they also switch
  language. Rarity names and fighter type names are translated too.
- Left as they are on purpose: fighter, skin and code names, the "C" coin icon, the `E` key,
  example codes (`ABCD`), the names of the languages (each in its own language), the QR page's
  `npm run dev` / Network hint (it must match what Vite prints), and the first account name
  "Player 1" (it is saved data, not a label).

**Done (2026-11-13 · ~25m · Claude Opus 5.5)** — every visible text from the English dictionary,
language per account with a picker in Settings; `npm test` 153 passed, `npm run check` 0
errors; browser: Home, Settings, Fighters, Info and a match show the same English texts.

---

## Step 5 — Translations: German, Swiss German, Spanish, Italian

### Goal
All texts exist in all 5 languages (S18, S19).

### Tasks
- [x] Record the start time in Notes below.
- [x] `de.ts`, `gsw.ts` (Zurich German), `es.ts`, `it.ts`, typed against `en.ts` (D5); fighter, skin and code names stay untranslated.
- [x] Test: every dictionary has every key, none empty, same placeholders as English.
- [x] Check in the browser: each language on Home, Fighters, Shop, Info, Settings, Hack, Friends and a match; long German words fit on a phone.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 17:48

- 264 texts per language. Rarities: Standard / Selten / Superselten / Episch / Mythisch /
  Legendär (gsw: Sälte, Supersälte), es Estándar … Legendario, it Standard … Leggendario.
  Super, Hypercharge, Prestige and Showdown stay as kids say them, explained on the Info page.
- Words to look at with Mattia: Swiss German spellings ("Iistellige", "Sälte", "Läbe"), the
  Spreader type ("Streuer" / "Dispersor" / "Ventaglio").

**Done (2026-11-13 · ~20m · Claude Opus 5.5)** — German, Swiss German, Spanish and Italian
dictionaries; `npm test` 157 passed (one completeness test per language), `npm run check` 0
errors; browser at phone size: Settings in German, Home and Shop in Swiss German fit.

---

## Step 6 — Password for the QR codes

### Goal
The QR print page shows the codes only after the password `M6D2` (S13).

### Tasks
- [x] Record the start time in Notes below.
- [x] `QrPage.svelte`: password form first; exact `M6D2` shows the codes, anything else "Wrong password"; not remembered (D12); texts in all 5 languages.
- [x] Test of the check function (`M6D2` yes; `m6d2`, empty, other no).
- [x] Check in the browser: `/?qr`, wrong and right password, reload asks again, Print still works.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 18:10

- The codes are loaded from the server only after the right password, so the page shows no
  code before it.

**Done (2026-11-13 · ~8m · Claude Opus 5.5)** — password form on `/?qr` (`isQrPassword`, exact
`M6D2`); `npm test` 162 passed, `npm run check` 0 errors; browser: `m6d2` → "Wrong password",
0 codes; `M6D2` → 4 codes; after a reload the password is asked again.

---

## Step 7 — Create a fighter and the CREATOR code

### Goal
The player designs one fighter, which stays locked until `CREATOR` is entered, and can change
it later for 500 credits (S7, S8, S9, S10, S11, S24).

### Tasks
- [x] Record the start time in Notes below.
- [x] Server: hack `creator` / `CREATOR` in `hacks.py` (D9); `pytest` for redeem and the list.
- [x] UI rules: `HackId` `creator`; `withCreated()` (D8); `isUnlocked` for `custom` (D9); `unlock()` refuses it; `recreate()` with `SETTINGS.recreateCost` through `pay()` (D10); tests.
- [x] `models/custom3d.ts`: build the created fighter from its look (3 heads, 3 bodies, 2 colours); portrait.
- [x] Creator screen: name, type, colours, head, body, live 3D preview; "Create a fighter" entry in the fighter list; locked card saying a hack code is needed; changing shows the price.
- [x] Check in the browser: create, see it locked, enter `CREATOR`, select it; change it with and without enough credits; `CREATOR` before creating unlocks it at creation; `/?qr` lists the new code.
- [x] Check: `cd server; uv run pytest`; `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 18:20

- **Change to D8 / D11:** the look travels as the fighter's **skin id** (`lookSkin()`: "L" +
  type + head + body + two colours, 16 characters). So pictures, the 3D stage, the arena and
  room members (skin ≤ 20 characters) work unchanged; `buildFighter('custom', skin)` reads the
  look from it (`models/custom3d.ts`). Step 8 only adds the name for friends.
- `CREATED_ID` lives in `progress.ts` so `hacks.ts` needs no import of `created.ts` (no cycle).
- OPENSESAME does not unlock the created fighter; only CREATOR does (S10). The created fighter
  has the rarity Epic (colour of its card) and no skins; `ownsSkin` treats its look as owned.
- `saveCreated()` is both create (free) and change (`SETTINGS.recreateCost` 500).

**Done (2026-11-13 · ~35m · Claude Opus 5.5)** — creator screen with live preview, CREATOR code,
lock, change for 500 C; `npm test` 169 passed (created 7 new), `npm run check` 0 errors,
`pytest` 28 passed; browser: created "Zappy" (locked, "enter a hack code"), change for 500 C;
CREATOR first, then created "Robo" → unlocked, selected, shown on Home.

---

## Step 8 — The created fighter in matches and with friends

### Goal
The unlocked created fighter plays like any fighter of its type, gets trophies and power, and
friends see it (S12).

### Tasks
- [x] Record the start time in Notes below.
- [x] Arena, Training, trophies, power levels and shot colour work with `custom` and its type.
- [x] Rooms: `Member.look` on the server with validation (D11) and `pytest` (good look accepted, bad colour / long name / `custom` without look refused); UI sends and draws the look.
- [x] Check in the browser: a match and Training with the created fighter; two devices (or two windows) in a room, one with the created fighter, both see it with its colours.
- [x] Check: `cd server; uv run pytest`; `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 18:58

- With the look in the skin id (Step 7), the room `Member` only gets an optional `name`; the
  server accepts `fighter: "custom"` only with a look-shaped skin and a name, and a name only
  for the created fighter. Members are sent without empty fields (`exclude_none`).
- The host takes a created fighter's type from its look (`startInfo`), and bots never get the
  created fighter (local matches and rooms). Its shots have its main colour.

**Done (2026-11-13 · ~20m · Claude Opus 5.5)** — created fighter in matches and rooms;
`pytest` 36 passed (8 new room tests), `npm test` 170 passed, `npm run check` 0 errors; two
headless devices: the friend's "Zappy" (red cat, Thrower) shows in the lobby and in the
host's match.

---

## Step 9 — Five new fighters with nicer graphics

### Goal
Marina, Drako, Spectra, Mecha Max and Zeus Jr. are in the game, clearly more detailed than the
current fighters, and matches stay smooth (S15, S16, S17).

### Tasks
- [x] Record the start time in Notes below.
- [x] `fighters.py`: the 5 fighters from S15 (Marina `unlocked_at_start`); `pytest` for 15 fighters and the start set.
- [x] `parts.ts`: shiny and glowing material helpers, animated parts list (D13).
- [x] Builders for the 5 fighters: at least twice the parts of a current fighter, shiny or glowing materials, idle animation moving 3 or more parts; shot colours; gallery; ideas in all 5 languages.
- [ ] Check in the browser: `/?gallery` side by side with the old fighters (screenshot for Mattia); a match with 3 new fighters at iPad size without stutter (frame rate in the browser's performance panel ≥ 30 fps).
- [x] Check: `cd server; uv run pytest`; `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 19:20

- New builders in `models/heroes3d.ts` (ids `marina`, `drako`, `spectra`, `mecha`, `zeus`);
  `parts.ts` got `shiny()`, `glowing()` and `move()` (bob / swing / spin per part).
- `models/fighters3d.test.ts` checks S16 in numbers: each new fighter has at least twice the
  visible parts of an average current fighter, at least 2 own moving parts plus flickers /
  spinners (3 or more), and 5 or more shiny or glowing parts.
- Frame rate: a match with 5 bots in headless Edge at 1024×768 runs at 60 fps.
- **Open:** the side-by-side look in `/?gallery` was not reviewed visually in this session (no
  screenshots left); Mattia should look at the gallery and say whether they look nicer (S16),
  and the frame rate should be checked once on a real iPad (S17).

**Done (2026-11-13 · ~40m · Claude Opus 5.5)** — five new fighters (Marina free) with richer
models; `pytest` 37 passed, `npm test` 180 passed, `npm run check` 0 errors; headless match
60 fps. Visual review by Mattia still open.

---

## Step 10 — Three more skins for every fighter

### Goal
Each of the 15 fighters has 3 new skins with their own look, sold in the shop (S14).

### Tasks
- [x] Record the start time in Notes below.
- [x] `fighters.py`: 45 new skins with names and rarities; `pytest`: every fighter has at least 3 new skins, ids unique per fighter.
- [x] Looks in each builder (D14): other colours and at least one changed part per skin; gallery.
- [ ] Check in the browser: shop lists the new skins at their rarity price, buy and wear one, skin of the day can be a new skin; every new skin in `/?gallery` looks different from the fighter's other skins.
- [x] Check: `cd server; uv run pytest`; `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-13 19:45

- **Change to D14:** instead of a palette in each builder, `models/skins3d.ts` builds the
  default look and changes it: every colour shifted (hue / saturation / lightness) plus one
  extra part (crown, halo, horns, shades, scarf, backpack or cape); Legendary skins also get
  the Legendary glow. The server lists the skins in `MORE_SKINS`.
- Tests: every one of the 45 skins has other colours and more parts than the default look
  (`fighters3d.test.ts`); the server checks 3 more skins per fighter with unique ids.
- Browser (text only): the shop lists 57 skins (12 before + 45), "Candy" (Blaze, Rare) bought
  for 100 C; `/?gallery` renders all skins without errors.
- **Open:** the looks were not reviewed visually (no screenshots left in this session): check
  `/?gallery` once and adjust any skin that looks wrong.

**Done (2026-11-13 · ~25m · Claude Opus 5.5)** — 45 new skins; `pytest` 38 passed, `npm test`
226 passed, `npm run check` 0 errors. Visual review still open.

---

## Step 11 — Everything still works; documentation

### Goal
Everything that worked before still works, on every screen size, and the documents describe
the new parts (S21, S22).

### Tasks
- [x] Record the start time in Notes below.
- [x] Full checks: `cd server; uv run pytest`; `cd ui; npm test; npm run check; npm run build`.
- [ ] Browser at phone, iPad and desktop, portrait and landscape: match, Training, shop, every hack code, play with friends with two accounts in different languages.
- [x] README: accounts, reset, create a fighter, languages, QR password, new fighters.
- [x] `docs/architecture.md`: accounts, i18n, created fighter, room `look`, new helpers in `parts.ts`, how to add a text / language.
- [x] Info page vocabulary for the new words; `.specs/overall_req.md` untouched (user's document); `SPEC-NX.md` features table gets this spec.
- [x] Check: all commands above pass.

### Notes
Started: 2026-11-13 20:10

- Checks: `pytest` 38 passed; `npm test` 226 passed; `npm run check` 0 errors; `npm run build`
  ok (the old "chunk larger than 500 kB" warning only).
- Two headless devices, one in German and one in Spanish: room created and joined, the host
  sees "▶ START · 2 Spieler + 2 Bots", the friend "Esperando a que el Jugador 1 empiece…",
  the match starts on both at 61 fps on the host.
- Info page: new words "Account" and "Created fighter" in all five languages.
- **Open (needs eyes, screenshots ran out in this session):**
  1. Look at every screen at phone, iPad and desktop size, portrait and landscape (accounts
     panel, creator, Settings with languages and reset, QR password) — S21.
  2. Mattia compares the five new fighters with the old ones in `/?gallery` — S16.
  3. Check the 45 new skins in `/?gallery` and fix any that look wrong — S14.
  4. Play one match on a real iPad with new fighters — S17.
  5. A native speaker reads the Swiss German texts (Zurich) — S20.
  Then close the spec (Status ✅, move it to `.specs/features/done/`, fix the link in
  `SPEC-NX.md`) and run `PR:`.

**Done (2026-11-13 · ~20m · Claude Opus 5.5)** — docs (README, architecture, SPEC-NX.md, Info
words) and all automated checks; visual checks listed above are still open.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Accounts shared between devices (cloud sync, login) | Accounts are per device and browser; syncing needs a server store and logins | a future online accounts spec |
| Translated fighter, skin and code names | Agreed: names stay the same in every language | — |
| Visual check: the five new fighters next to the old ones in `/?gallery` (Mattia), and a match on a real iPad (Step 9; S16, S17) | Screenshots could not be reviewed in the implementing session; deferred at CLOSE by the user | before merging pull request for #15 |
| Visual check: the 45 new skins in `/?gallery`; shop, buy and wear one, skin of the day (Step 10; S14) | Same | before merging pull request for #15 |
| Visual check: every screen at phone, iPad and desktop, portrait and landscape; Swiss German read by a native speaker (Step 11; S20, S21) | Same | before merging pull request for #15 |
| Free the cloned 3D materials with the rig (review finding 2) | Memory only, no visible effect | a future 3D clean-up spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-13 | AI assistant (Claude Opus 5.5) | semantic diff | — | [review page](../../review/2026-11-13_feature-accounts-fighters-and-languages.html): 13 record blocks, checks 7 pass · 2 n/a, 5 findings (1 Should-fix: visual checks open; 4 Nit) |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked *(except the visual checks listed in Step 9–11 notes)*
- [x] Review · review page and semantic diff written; code review without Blocking findings
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
