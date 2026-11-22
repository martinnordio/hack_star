# Accounts, Create a Fighter, New Fighters and Languages Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-22
> **Branch:** `feature/accounts-fighters-and-languages`
> **Moved from:** [2026_11_13_accounts_fighters_and_languages_spec.md](../../../.specs/features/done/2026_11_13_accounts_fighters_and_languages_spec.md) (#15)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_13_accounts_fighters_and_languages_spec.md (requirements only) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in [16](done/2026_11_21_16_bug_fixes_spec.md) | included in [16](done/2026_11_21_16_bug_fixes_spec.md) | S25–S40 added from spec 16 (its S0: bugs whose feature comes with this spec) |

---

# Part 1 · Requirements

## Context

Mattia and his friends share one device and want their own progress, a fighter they design
themselves, more and better-looking fighters and skins, and the game in their own language.
Parents want to start over (reset) and to keep the printed QR codes away from the kids. All of
it is in one spec, as the user asked.

The QR password and the hack codes are visible in the public source on GitHub and through
`GET /api/hacks` (Python + Svelte game; see S0 / spec 03's server question): the password keeps kids from printing the codes, it is not real security —
agreed as enough.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_13_accounts_fighters_and_languages_spec.md) (#15).
- Saved progress per device, from [Trophies](done/2026_11_21_08_trophies_spec.md),
  [Unlock and upgrade](2026_11_22_09_unlock_and_upgrade_spec.md) and
  [Skins Shop](2026_11_22_10_skins_shop_spec.md): credits, trophies per fighter, power levels,
  unlocked fighters, skins, active hack codes. There is only **one** progress per device. A new
  player starts with 500 credits and sample trophies.
- The Settings screen with bot level and number of bots, saved per device, from
  [Overtime and match options](2026_11_22_11_overtime_and_match_options_spec.md).
- The fighters with their rarities, skins and 3D looks from [Basic UI](done/2026_11_21_04_basic_ui_spec.md);
  Blaze, Rocko and Turbo are unlocked at the start. The 4 fighters and the 5 types (Tank,
  Sharpshooter, Speedy, Thrower, Spreader) come from
  [More fighters](2026_11_22_13_more_fighters_spec.md), so there are 10 fighters.
- The Shop with the skin of the day, from [Skins Shop](2026_11_22_10_skins_shop_spec.md).
- The hack codes and the QR codes, from [Hack codes](done/2026_11_21_05_hack_codes_spec.md) and
  [Super and Hypercharge](2026_11_22_12_super_and_hypercharge_spec.md): INFINITY, OPENSESAME,
  POWER22, HYPERCHARGE, typed or scanned, and the printable QR codes with no password.
- Play with friends, from [Play with friends](2026_11_22_14_play_with_friends_spec.md), sends
  each player's fighter id, skin and power to the others.
- All text is in English; the Info page has the game vocabulary.
- [MVP and architecture spec](done/2026_11_21_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are) and how
  to run the game (S12–S14).

**New:**
- Up to 5 accounts per device, each with its own progress; switching between them.
- Resetting an account to the start (credits, trophies, fighters, power levels, skins).
- A fighter the player designs, locked until a new hack code is entered.
- A password before the QR codes are shown.
- 3 more skins for every fighter; 5 new fighters with much better graphics.
- The game in English, German, Swiss German, Spanish and Italian.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–14) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.

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
- **S25 — Free with INFINITY:** While INFINITY is active, creating a fighter and saving changes to
  it never show "Need … more C"; the button shows "free" and the save works, whatever the saved
  credit count is (including 0). _(added from spec 16, 2026-11-22)_
- **S26 — New fighter shows at once:** Right after **Create**, the Fighters screen shows the new
  fighter's card and no longer shows the "Create a fighter" card (unless S33 keeps it), without
  reloading the game. _(added from spec 16, 2026-11-22)_
- **S27 — Creator screen agrees with itself:** The creator shows "Create a fighter" with a free
  **Create** button only when the account has no created fighter (or with CREATOR for an extra
  one, S33); when changing a fighter it shows "Change your fighter" with **Save changes** and its
  price. Title and button never disagree. _(added from spec 16, 2026-11-22)_
- **S28 — Created fighters across tabs:** A created fighter, a change to it and the credits paid
  for it in one tab are not lost because of another tab of the same game, and the other tab
  shows them at the latest when it comes back to the front, as for hacks and trophies
  ([spec 16](done/2026_11_21_16_bug_fixes_spec.md), S4); per account. `(added from spec 16,
  2026-11-22)`
- **S29 — Created fighter is usable at once:** Right after it is created, the created fighter has
  no lock: its card in the Fighters list looks like the other unlocked fighters, it can be
  selected, then shows on the Home screen and is played in matches, Training and with friends —
  no hack code needed. This replaces the lock of S10, CREATOR's unlocking in S11 and the lock
  state in S24. _(added from spec 16, 2026-11-22)_
- **S30 — Prices stay:** Without INFINITY, the first creation is free and every change costs
  500 C; the created fighter keeps its trophies and power level when it is changed, and a change
  made while INFINITY or CREATOR was active stays after the code turns off. `(added from spec 16,
  2026-11-22)`
- **S31 — Place in the list:** In the Fighters list, the created fighter's card comes right after
  the last unlocked fighter and before the locked ones (with 3 unlocked fighters, it is the 4th
  card). _(added from spec 16, 2026-11-22)_
- **S32 — One fighter without CREATOR:** Without the CREATOR code, an account can create one
  fighter; once it exists, the "Create a fighter" card is gone and only **Change** is offered
  (replaces S7 and S9's "the entry opens that fighter"). _(added from spec 16, 2026-11-22)_
- **S33 — More fighters with CREATOR:** With the CREATOR code active, the "Create a fighter" card
  stays in the Fighters list, and each extra fighter created costs credits (free with INFINITY).
  Every created fighter has its own name, look, trophies and power level, is usable at once
  (S29), and can be changed on its own (S30). This replaces S11's "unlocks the created fighter".
  _(added from spec 16, 2026-11-22)_
- **S34 — Not enough credits:** Without enough credits for an extra fighter, the creator says how
  many credits are missing and nothing is created. _(added from spec 16, 2026-11-22)_
- **S35 — Code text:** In the hack list and on the printable QR page, CREATOR says it lets you
  create more fighters (in all five languages), not that it unlocks the created fighter.
  _(added from spec 16, 2026-11-22)_
- **S36 — Playing with friends:** Each created fighter looks the same on friends' devices as on
  the player's own device. _(added from spec 16, 2026-11-22)_
- **S37 — Price and maximum:** Each extra created fighter costs 500 C (free with INFINITY). An
  account has at most 15 created fighters; at 15, the "Create a fighter" card is not shown.
  _(added from spec 16, 2026-11-22)_
- **S38 — CREATOR lasts 3 days:** CREATOR is a 3-day code: it turns off by itself 3 days after it
  is entered, entering it again while it is active starts a new 3 days, and the hack screen shows
  its time left, like INFINITY and OPENSESAME ([spec 16](done/2026_11_21_16_bug_fixes_spec.md),
  S16–S18). _(added from spec 16, 2026-11-22)_
- **S39 — Created fighters wait for CREATOR:** When CREATOR turns off, the extra created fighters
  (all but the first) stay in the Fighters list, keep their trophies and power, but cannot be
  selected, played or changed; their card and detail say they are active again when the CREATOR
  code is entered. Entering CREATOR again makes them usable and changeable. If one of them was
  selected, the Home screen shows another usable fighter. _(added from spec 16, 2026-11-22)_
- **S40 — First created fighter stays:** The first created fighter (S32), created without
  CREATOR, stays usable whether CREATOR is active or not; only the extra created fighters become
  inactive when CREATOR turns off (S39). _(added from spec 16, 2026-11-22)_

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
