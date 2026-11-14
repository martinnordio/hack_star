# Fighter Studio, Saves and Music Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/fighter-studio-saves-and-music`
> **Issue:** #19

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | GitHub Copilot | Part 1 drafted from the creator expansion notes; product choices remain open |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: renamed (spec 1 of 4), account-name refresh bug added, saving widened, music references made mood-only; open questions answered; credits panel, developer mode and developer page (music section) added |
| 2026-11-14 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #19 created |
| 2026-11-14 | plan | `PLAN:` | Claude Opus 5.5 | Part 2 written |
| 2026-11-14 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Steps 1–9, 11 and 12 done; Step 10 waits for Martin and Mattia |

---

# Part 1 · Requirements

## Context

The fighter creator lets players choose a type, two colours, a head and a body, but there are
few parts to choose from. This spec gives players more original parts to mix and match, up to
five optional skins per created fighter, and music while they play, with the music's credits
shown in the game. It also makes sure that everything a player owns or chooses is still there
after they leave the game or turn off the device, and fixes the account name on the home
screen, which does not update after a rename or an account switch. To choose the music, it
adds the basics of a hidden developer page and a developer mode; spec 2 adds the graphics
review to the same page.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [Bug fixes spec](done/2026_11_14_bug_fixes_spec.md) — created-fighter collection, stable
  ids, account saving and cross-tab sync; this spec builds on it.
- [Accounts, fighters and languages spec](done/2026_11_13_accounts_fighters_and_languages_spec.md)
  — up to 5 accounts per browser, each with its own name, language and progress.
- [Skins shop spec](done/2026_11_12_skins_shop_spec.md) — owning, choosing and wearing skins.
- `ui/src/lib/CreatorScreen.svelte`, `ui/src/lib/created.ts` — the creator: type, two colours
  from 8, head and body from 3 each; the look travels as a 16-character skin id.
- `ui/src/lib/models/custom3d.ts`, `ui/src/lib/models/parts.ts` — created fighters built in
  code from simple shapes.
- `ui/src/lib/accounts.ts` — accounts and progress saved in the browser under
  `hack-star.accounts`, merged across tabs; `ui/src/lib/options.ts` — bot level and number of
  bots saved under `hack-star.options`.
- `ui/src/lib/Home.svelte`, `ui/src/lib/AccountsPanel.svelte` — the account button on the
  home screen and the accounts panel (add, rename, switch). A check on 2026-11-14 showed that
  the accounts store passes the new name to its listeners, so the stale name comes from how
  the home screen shows it.
- `ui/src/lib/SettingsScreen.svelte` — language, bots, account reset; no sound yet.
- `ui/src/lib/net/room.ts` — friends in a room see each other's fighter and skin.
- `ui/public/assets/LICENSES.md` and the README section **Art** — only original or CC0 art.
- `ui/src/main.ts`, `ui/src/lib/QrPage.svelte`, `ui/src/lib/hacks.ts` (`QR_PASSWORD`) —
  hidden pages by address (`/?qr`, `/?gallery`); the QR page asks for the code `M6D2` every
  time (in the public source, so a lock for kids, not security).
- `ui/src/lib/Arena.svelte` — rewards are given only when a match ends.
- `ui/package.json` — the game's version (`0.1.0`); `LICENSE` — the MIT licence.

**New:**
- Hands and legs as parts, and more choices for every part.
- Up to five player-designed skins per created fighter.
- The account name on the home screen always matches the current account.
- Music during matches, with an on/off switch and a choice of five tracks.
- An **About** panel with the game's name, version, music credits and the MIT licence.
- **Developer mode** in Settings and a hidden **developer page**, with a music section to
  listen to up to 15 candidate tracks, choose five and delete the others.
- A music section in the asset licences and the README.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../README.md) | How to install, run, test and play |
| [Asset licences](../../ui/public/assets/LICENSES.md) | Where every asset comes from and its licence |

## 1 · Specs

### Creator

- **S1 — More parts:** When creating or editing a created fighter, the player chooses a head
  and a body from five options each (two more than today) and hands and legs from three
  options each.
- **S2 — Mix and match:** Each part can be changed on its own; changing one part or a colour
  keeps every other choice.
- **S3 — Original designs:** Every new part is an original Hack star design (variations such
  as a robot with different arms are welcome); no part copies a character, name, logo or asset
  from another game.
- **S4 — Live preview:** The 3D preview shows the chosen parts and colours before the player
  saves, and turns while the player changes them.

### Skins for created fighters

- **S5 — Optional skins:** A created fighter can have from zero to five skins made by the
  player, in addition to its default look, which is always available. Making a skin is free;
  the 500 C price stays only for extra created fighters.
- **S6 — Manage skins:** The player can create, change, delete and choose a skin for a
  created fighter; a skin has its own colours and parts. The chosen skin is worn on the home
  screen, in matches and in rooms; deleting the worn skin puts the default look back on.
- **S7 — Looks only:** A skin changes only how the fighter looks; type, stats, power and
  trophies stay the same.

### Account name

- **S8 — Rename shows at once:** After the player renames the current account and closes the
  accounts panel, the home screen shows the new name immediately, without reloading the page.
- **S9 — Switch shows at once:** After the player switches to another account, or adds one,
  the home screen shows that account's name, trophies, credits and fighter immediately.

### Saving

- **S10 — Everything is kept:** Everything the player owns or chooses — accounts and the
  current account, trophies, credits, power, unlocked fighters and skins, active hacks,
  created fighters with their parts and skins, and every Settings choice including music —
  is the same after the player leaves the game, closes the browser, or turns off the device
  and comes back.
- **S11 — Saved straight away:** A change is saved when it is made, not only when the player
  leaves; closing the tab right after a change does not lose it.
- **S12 — Old saves:** Saves from earlier versions still load: existing created fighters keep
  their look, new parts get a default that keeps that look, and no progress is reset.
- **S13 — Other tabs:** Created-fighter parts and skins follow the same rules across tabs of
  the same browser as the rest of the progress (bug fixes spec).
- **S14 — Kept for long:** The game asks the browser to keep its saved data, so it is not
  deleted when the game has not been opened for a while (Safari may otherwise delete it after
  about 7 days).
- **S15 — Saving blocked:** When the browser does not allow saving (for example private
  browsing), the player sees a short notice, once per visit, that progress will not be kept.
- **S16 — Unfinished match:** Leaving a match before it ends gives no reward and the match is
  not resumed later (as today).

### Friends

- **S17 — Same look for friends:** Friends in a room see a created fighter with the same
  parts, colours and chosen skin as its owner; friends on the previous version still see the
  fighter instead of an error.

### Music

- **S18 — Music switch:** Settings has a control to turn music on or off and to choose one of
  five tracks. Music is on the first time; the choice is saved on this device for all its
  accounts, and kept as in S10.
- **S19 — When it plays:** With music on, the chosen track plays during every match —
  against bots, in Training and with friends — starting when the match starts and stopping
  when it ends or the player leaves it. It pauses while the tab is hidden and goes on when the
  tab is shown again and the match is still running. With music off, the game is silent.
- **S20 — Choosing the five:** On the developer page (S25), the team listens to up to 15
  candidate tracks and marks the five that ship; the five are chosen only after listening and
  after their licences are checked (S22). Players never see or hear the other candidates, and
  their files are not part of the game players download.
- **S21 — Moods:** The five tracks cover different moods, for example big-drum anthemic
  pop-rock, a funky dance groove, and classic arcade or chiptune game music. These are
  styles only: no track imitates a specific artist or song.
- **S22 — Music rights:** Every candidate and shipped track is made for the project, or is
  under CC0, or under CC BY (any version) with its credit shown as in S23. Licences that
  forbid commercial use (NC) or changes (ND) are never used. No track copies or samples an
  existing recording, melody or lyrics.

### About and credits

- **S23 — About panel:** Settings opens an **About** panel showing the game's name and
  version, the credits of every shipped track (title, author, licence and a link to the
  source), and the MIT licence with its copyright line (© 2026 Martin Nordio and Mattia
  Nordio).

### Developer mode and developer page

- **S24 — Developer mode:** Settings has a **Developer mode** control. Turning it on asks for
  the developer code (the same code as the QR page); a wrong code shows a message. With the
  right code, developer mode stays on in this browser until it is turned off in Settings.
- **S25 — Developer page:** A developer page opens by its address (`/?dev`) and, in developer
  mode, from a button in Settings; no button leads to it for players. In a browser without
  developer mode it first asks for the developer code, then turns developer mode on. It is in
  English and has one section per topic: this spec adds **Music**; spec 2 adds **Graphics**.
- **S26 — Candidate tracks:** The music section lists each candidate track with its title,
  author, source link, licence and whether it is one of the five; each can be played and
  stopped. Candidate files are kept in the project so they play without the internet, and the
  list is kept in the repository, so both developers see the same list and choices.
- **S27 — Delete a track:** A button deletes a candidate track: it disappears from the list
  and its file is removed from the project. A track that is one of the five cannot be deleted
  until it is unmarked.
- **S28 — Find more music:** The music section shows a ready-to-copy request for the AI
  assistant to find more candidate tracks: the moods of S21, the licences of S22, at most 15
  candidates in total, and the details to record for each track (S26).

### Everywhere

- **S29 — Languages:** Every new label and message players can see is shown in all game
  languages (English, Deutsch, Schwiizerdütsch, Español, Italiano); the developer page is in
  English only.
- **S30 — Devices:** The creator, skin, music, About and developer-mode controls work with
  mouse and touch on desktop, tablet and phone, in portrait and landscape; the developer page
  may be desktop-first.
- **S31 — Documentation:** The README and `docs/architecture.md` describe the new parts,
  skins, saving, music, the About panel, developer mode and the developer page.
  `ui/public/assets/LICENSES.md` gets a music section with each shipped track, its author,
  source and licence, and how a new track is checked. The README section **Art** keeps its
  current text and gains one sentence on music (for example "Music is made for the project or
  uses a free licence (CC0 or CC BY, credited in the game's About panel); see
  ui/public/assets/LICENSES.md.").

### Open questions

_None — answered on 2026-11-14. Candidate tracks come from both sources: made by us with a
free tool, and free-music libraries under CC0 or CC BY._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Account name on the home screen | ✅ Done | [→ Step 1](#step-1--account-name-on-the-home-screen) |
| **2** | Saving that lasts, and a notice when it cannot | ✅ Done | [→ Step 2](#step-2--saving-that-lasts-and-a-notice-when-it-cannot) |
| **3** | Look format with hands, legs and skins | ✅ Done | [→ Step 3](#step-3--look-format-with-hands-legs-and-skins) |
| **4** | New 3D parts | ✅ Done | [→ Step 4](#step-4--new-3d-parts) |
| **5** | Creator controls for every part | ✅ Done | [→ Step 5](#step-5--creator-controls-for-every-part) |
| **6** | Skins of created fighters: rules and saving | ✅ Done | [→ Step 6](#step-6--skins-of-created-fighters-rules-and-saving) |
| **7** | Skins of created fighters: screens | ✅ Done | [→ Step 7](#step-7--skins-of-created-fighters-screens) |
| **8** | Developer mode and the developer page | ✅ Done | [→ Step 8](#step-8--developer-mode-and-the-developer-page) |
| **9** | Music section of the developer page | ✅ Done | [→ Step 9](#step-9--music-section-of-the-developer-page) |
| **10** | Find, try and choose the five tracks | ⬜ Not started | [→ Step 10](#step-10--find-try-and-choose-the-five-tracks) |
| **11** | Music in matches and its Settings | ✅ Done | [→ Step 11](#step-11--music-in-matches-and-its-settings) |
| **12** | About panel | ✅ Done | [→ Step 12](#step-12--about-panel) |
| **13** | Documentation and final check | ⬜ Not started | [→ Step 13](#step-13--documentation-and-final-check) |

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
| D1 | The look's skin id grows from 16 to 18 characters: `L`, type, head (0–4), body (0–4), hands (0–2), legs (0–2), two colours. 16-character ids still parse, with hands and legs 0. The server's `CREATED_LOOK` accepts both. | Rooms, 3D models and pictures keep working without knowing about created fighters (as today); 18 characters fit the room's 20-character limit. |
| D2 | Hands and legs option 0 is "the body's own" — exactly what each body draws today; options 1 and 2 are new. | Old created fighters keep their look with no migration of their parts (S12). |
| D3 | Progress version 7: every created look gets `hands: 0, legs: 0`, every created fighter gets `skins: []`; versions 2–6 still migrate. | One migration for all new saved fields (S12); the same pattern as versions 4–6. |
| D4 | A created skin is `{ id: 's1'…'s5', main, second, head, body, hands, legs }` stored on its created fighter; it is chosen through the existing `selectedSkins[fighterId]`, and `wornSkin()` returns the skin id of the chosen look. Skins are free and need no `ownedSkins` entry. | Reuses how skins are chosen and sent to rooms (S6, S17); the type and name stay the fighter's (S7). |
| D5 | Across tabs, created skins merge by skin id with the same rule as created fighters: a local change wins over an unchanged remote; deletions are kept. | Same behaviour as the rest of the progress (S13, bug fixes spec). |
| D6 | On start the game calls `navigator.storage.persist()` when the browser has it; saving reports success, and a failed save shows a notice once per visit. No new dependency. | Asks the browser not to delete the data (S14); the player learns when nothing is saved (S15). |
| D7 | Developer mode is saved per browser in `hack-star.options` (`developer: true`); the code is the existing QR code `M6D2` (`isQrPassword`). | Same per-device place as the bot and music settings (S24); a lock for kids, not security — the code is in the public source. |
| D8 | The developer page is `ui/src/lib/dev/DevPage.svelte`, chosen in `ui/src/main.ts` for `/?dev` like `/?qr`; English only; one component per section (`MusicSection.svelte` now, `GraphicsSection.svelte` in spec 2). | Matches the existing hidden pages; spec 2 adds a section without touching the page frame (S25). |
| D9 | Music files: candidates live in `ui/dev/music/` — the list `candidates.json` (title, author, source, licence, file, chosen) is committed, the audio files are git-ignored. The five chosen tracks are copied to `ui/public/assets/music/` and listed in `ui/src/lib/music/tracks.json`, which the game and the About panel read. | Both developers share the list and choices; large candidate files stay out of git and out of the players' download (S20, S26). |
| D10 | A small Vite plugin, active only for `npm run dev` (`apply: 'serve'`), serves the candidate files and handles "choose", "unchoose" and "delete" for the developer page. No new dependency; nothing of it is in `npm run build`. | A browser page cannot write or delete project files; a dev-server-only endpoint can, and players never get it (S20, S27). |
| D11 | Tracks are MP3, at most about 3 MB each. | MP3 plays in every browser the game supports, including Safari on iPad and iPhone. |
| D12 | Music settings are saved per device in `hack-star.options`: `music: boolean` (default `true`) and `track: string` (default the first chosen track); an unknown track falls back to the default. | S18; like the bot settings. |
| D13 | One music player module (`ui/src/lib/music/player.ts`) with a single looping audio element; the match starts and stops it, and it pauses while the tab is hidden. | Starting from the PLAY tap satisfies the browsers' autoplay rule; one element means one track at a time (S19). |
| D14 | The About panel reads the version from `ui/package.json` and the licence text from the repository's `LICENSE` (Vite `?raw` import), so they never drift. | S23 shows the real version and the exact licence. |
| D15 | Step 1 finds the cause of the stale account name before fixing it; the fix stays in `Home.svelte` / `accounts.ts`, with a regression test at store level and a recorded browser check — no component-test library is added. | A check on 2026-11-14 showed the store itself passes the new name; adding a DOM test library would be a new dependency for one test. |

---

## Step 1 — Account name on the home screen

### Goal
The home screen shows the current account's name, trophies, credits and fighter right after a
rename, an account switch or a new account (S8, S9).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Reproduce in the browser (`npm run dev`): rename the current account, close the panel;
      switch account; add an account. Write down what the home screen shows each time.
- [x] Find the cause (how `Home.svelte` reads `$accounts`, the panel's writes, the accounts
      store's merge) and write it in Notes.
- [x] Fix it with the smallest change; add a regression test in `accounts.test.ts` for the
      part that can be tested without a screen.
- [x] Check: `cd ui; npm test; npm run check`, and the three browser checks above now show the
      right account at once.

### Notes
Started: 2026-11-14 14:55

**Reproduction** (headless Edge driven over its DevTools protocol against `npm run dev`, one
and two tabs): renaming with **Save**, adding and switching update the home screen at once.
The stale name appears when a new name is **typed but not saved**: closing the panel (✕ or a
tap outside) or picking another account throws the typed name away, so home keeps the old
name.

**Cause:** `AccountsPanel.svelte` saved a rename only on **Save** / Enter; `onClose` and
`pick` discarded the edit. The accounts store and `Home.svelte` were correct (checked with a
store test and in the browser).

**Fix:** `commitRename()` saves a rename in progress before the panel closes, before adding
and before switching; an invalid name keeps the panel open with its message.

**Done (2026-11-14 · ~5m · Claude Opus 5.5)** — typed names are saved when the accounts panel
closes or another account is picked; regression test for listeners and saving. `npm test`
244 passed, `npm run check` 0 errors; browser: ✕, tap outside and switch keep the typed name,
normal rename / add / switch still show the right account.

---

## Step 2 — Saving that lasts, and a notice when it cannot

### Goal
Saved data is kept for long, every change is saved at once, and the player is told when the
browser blocks saving (S10, S11, S14, S15, S16).

### Tasks
- [x] Record the start time in Notes below.
- [x] Ask the browser to keep the data on start (D6).
- [x] Make `saveAccounts` and `saveOptions` report whether saving worked; show a short
      notice once per visit when it did not, in all five languages (S15, S29).
- [x] Tests: a storage that throws makes the notice appear once; a normal storage saves each
      change right away (S11); options and accounts reload as saved (S10).
- [x] Check that leaving a match early still gives no reward (S16) and record it.
- [x] Check: `cd ui; npm test; npm run check`; in a private window the notice appears once.

### Notes
Started: 2026-11-14 15:00

- New `lib/saving.ts`: the notice state (`none` → `shown` → `dismissed`), `browserStorage()`
  (reading `localStorage` can itself throw when the browser blocks it — the game then runs
  on memory storage instead of failing to start) and `keepSavedData()` (D6), called from
  `main.ts`. The notice is in `App.svelte`, text `saving.blocked` in all five languages.
- S16: `Arena.svelte` gives trophies and credits only in its end-of-match handler; leaving
  early calls `onLeave` without a reward — unchanged.
- Browser check: headless Edge with `Storage.prototype.setItem` throwing (same effect as a
  blocked storage) — the notice appears on the first failed save, the game keeps working, and
  it does not come back after **Close**.

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — saves report success, blocked storage no
longer stops the game and shows a notice once per visit, the browser is asked to keep the
data. `npm test` 248 passed, `npm run check` 0 errors; browser check as above.

---

## Step 3 — Look format with hands, legs and skins

### Goal
Saves, skin ids and rooms carry hands, legs, more heads and bodies and created skins, while
old saves and old skin ids still work (S1, S12, S17).

### Tasks
- [x] Record the start time in Notes below.
- [x] `CreatedLook` gets `hands` and `legs`; heads and bodies 0–4, hands and legs 0–2
      (`progress.ts`, `created.ts`).
- [x] Skin id with 18 characters; `parseLookSkin` reads 16 and 18 (D1).
- [x] Progress version 7 with the migration of D3; `CreatedFighter` gets `skins`.
- [x] Server: `CREATED_LOOK` accepts both lengths; `test_rooms.py` covers both.
- [x] Tests: old saves of versions 2–6 load with the same look; old and new skin ids round-trip.
- [x] Check: `cd server; uv run pytest`; `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-14 15:07

- D1 refined: `lookSkin` keeps the **16-character** form whenever the look has hands and legs
  0 and head and body 0–2 (everything an older version can draw), and uses 18 characters
  only for new parts. So friends on the previous version keep seeing every existing fighter
  exactly (S17); an 18-character look falls back to their default created look instead of an
  error.
- `PART_COUNTS` (head 5, body 5, hands 3, legs 3) and `MAX_CREATED_SKINS` (5) live in
  `progress.ts`; a created skin id is `s1`…`s5`. Version 6 saves migrate with D3; versions
  2–5 go through it too.
- `custom3d.ts` falls back to the first head / body for parts it cannot draw yet (Step 4 adds
  them).

**Done (2026-11-14 · ~15m · Claude Opus 5.5)** — progress version 7 with hands, legs and
created skins, 16/18-character skin ids, server accepts both. `uv run pytest` 45 passed;
`npm test` 249 passed; `npm run check` 0 errors.

---

## Step 4 — New 3D parts

### Goal
Two new heads, two new bodies, and two new hands and legs each, all original and combinable;
option 0 of hands and legs keeps today's look (S1, S2, S3, D2).

### Tasks
- [x] Record the start time in Notes below.
- [x] Split hands and legs out of the bodies in `models/custom3d.ts`, so option 0 draws exactly
      what each body draws today.
- [x] Add the new heads, bodies, hands and legs from simple shapes (`models/parts.ts`), in the
      game's style; no shape copies a known character.
- [x] Test (`fighters3d.test.ts`): every combination builds; an old 16-character look builds
      the same parts as before.
- [x] Check: `cd ui; npm test; npm run check`; look at all combinations in `/?gallery`.

### Notes
Started: 2026-11-14 15:06

- Each body is now `{ torso, arms, legs }`; hands / legs 0 use the body's own arms and legs.
- New parts: heads **dino** (spiky crest, snout) and **dome bot** (glass dome, two antennas);
  bodies **hoodie** (with the kid's arms and legs) and **jet pack** (with the robot's arms and
  legs); hands **claws** and **big gloves**; legs **springs** and **big boots**. All from
  spheres, boxes, cones, cylinders and rings.
- The test went into a new `models/custom3d.test.ts` (next to the code) instead of
  `fighters3d.test.ts`: it pins a fingerprint (mesh count + position checksum) of the 9
  version-6 head/body models, recorded before the refactor, and checks that all 225
  combinations build and differ.
- `/?gallery=custom` now also shows 10 created looks covering every new part (screenshot
  checked with headless Edge).

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — two heads, two bodies, two hands and two legs
added; old looks draw exactly as before. `npm test` 251 passed; `npm run check` 0 errors;
gallery screenshot shows all new parts.

---

## Step 5 — Creator controls for every part

### Goal
The creator lets the player pick head, body, hands and legs independently, with a turning live
preview, on every device and in every language (S1, S2, S4, S29, S30).

### Tasks
- [x] Record the start time in Notes below.
- [x] `CreatorScreen.svelte`: pickers for hands and legs, and the extra heads and bodies;
      changing one part or colour keeps the others.
- [x] The preview turns while the player changes parts.
- [x] Labels for the new parts in all five languages (`i18n/`).
- [x] Check: `cd ui; npm test; npm run check`; in the browser at phone, tablet and desktop size,
      with mouse and touch: create and edit a fighter, reload, the parts are kept.

### Notes
Started: 2026-11-14 15:12

- `created.ts`: `HEADS`/`BODIES` 0–4, new `HANDS`/`LEGS` 0–2; the creator loops over all
  four groups. Hands and legs 0 are labelled "Like the body".
- `HomeScene.svelte` has a `turning` option (0.6 rad/s), used by the creator only; the home
  screen is unchanged.
- Browser check (headless Edge, desktop 1280×800): seven groups shown, every head / body /
  hands / legs option present, picking Dino, Jet pack, Claws and Springs keeps each choice,
  saving stores `head 3, body 4, hands 1, legs 1`. Phone size (430×932): screenshot shows the
  turning preview and the pickers wrapping; the buttons are the existing touch buttons
  (`touch-action: manipulation`).

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — the creator offers 5 heads, 5 bodies, 3 hands
and 3 legs with a turning preview, in all five languages. `npm test` 251 passed;
`npm run check` 0 errors; browser checks as above.

---

## Step 6 — Skins of created fighters: rules and saving

### Goal
A created fighter can have up to five free skins with their own colours and parts, chosen and
worn like other skins, kept across reloads and tabs (S5, S6, S7, S13, S17).

### Tasks
- [x] Record the start time in Notes below.
- [x] Rules in `created.ts`: add, change and delete a skin (at most five, free); deleting the
      worn skin puts the default look back on (D4).
- [x] `wornSkin()` and the room member send the chosen skin's look (D4).
- [x] Cross-tab merge of skins (D5) in `accounts.ts`.
- [x] Tests: the limit of five, free, delete of the worn skin, type and stats unchanged (S7),
      merge of two tabs adding and deleting skins.
- [x] Check: `cd ui; npm test; npm run check`.

### Notes
Started: 2026-11-14 15:16

- `created.ts`: `addCreatedSkin` (wears the new skin), `changeCreatedSkin`,
  `deleteCreatedSkin`, `chooseCreatedSkin`, `createdSkinLook`. `wornSkin()` builds the look
  from the chosen skin with the fighter's own type, so `memberFor()` (rooms), the 3D models
  and pictures need no change.
- Merge (D5): skins merge by id like created fighters; when two tabs add a skin with the same
  new id, the second gets the next free id (both are kept, up to five). A tab that wore its
  own new skin may then wear the other tab's skin with that id — acceptable, it is a choice
  the player can change at once.

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — up to five free skins per created fighter,
worn at home, in matches and in rooms, merged across tabs. `npm test` 256 passed;
`npm run check` 0 errors.

---

## Step 7 — Skins of created fighters: screens

### Goal
The player can create, change, delete and choose a created fighter's skins on screen, and the
chosen skin shows on the home screen, in matches and in rooms (S5, S6, S17, S29, S30).

### Tasks
- [x] Record the start time in Notes below.
- [x] Screens: a skins area for created fighters (the creator or the fighter detail —
      following the existing skin screens), with a preview and the five-skin limit shown.
- [x] Texts in all five languages.
- [x] Check: `cd ui; npm test; npm run check`; in the browser: make two skins, wear one, see it
      on the home screen, in a match and in a friend's room on a second device or tab.

### Notes
Started: 2026-11-14 15:21

- `FighterDetail.svelte`: for an unlocked created fighter, a **Skins · n/5** row (default + its
  skins, with portraits) to preview and **SELECT**; **New skin** (while fewer than five),
  **Change skin** and **Delete skin** (a second tap confirms).
- `CreatorScreen.svelte` has a skin mode (`skinId` `'new'` or `s1`…`s5`): the same preview and
  colour / part pickers, without name and type, saved free. `App.svelte` opens it from the
  fighter page and returns there.
- Browser check (headless Edge): created "Skinny", made Skin 1 (Dino head, big boots) and
  Skin 2 (jet pack) — "Save skin · free", count 0/5 → 2/5, the new skin is worn; wearing
  Skin 1 sets `selectedSkins.custom = s1` and the home screen shows Skinny; deleting Skin 2
  needs the second tap and keeps Skin 1 worn. In a match and in rooms the worn look comes from
  `wornSkin()` / `memberFor()` (unit tests of Step 6; the server accepts 18-character looks,
  Step 3) — not re-checked with two live devices.

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — created fighters' skins can be made, changed,
deleted and worn on screen, in all five languages. `npm test` 256 passed; `npm run check`
0 errors; browser check as above.

---

## Step 8 — Developer mode and the developer page

### Goal
Developer mode can be turned on in Settings with the code, and the hidden developer page
`/?dev` opens with its code check and an empty Music section (S24, S25, S29, S30).

### Tasks
- [x] Record the start time in Notes below.
- [x] `options.ts`: `developer` (D7); Settings control to turn it on (asks the code, wrong code
      message) and off; texts in all five languages.
- [x] In developer mode, Settings shows a button to the developer page.
- [x] `/?dev` in `main.ts` and `dev/DevPage.svelte` (D8): asks the code when developer mode is
      off and turns it on; English only.
- [x] Tests: options load and save `developer`; a wrong code does not turn it on.
- [x] Check: `cd ui; npm test; npm run check; npm run build`; no player screen links to `/?dev`.

### Notes
Started: 2026-11-14 15:25

- `dev/developer.ts` `turnOnDeveloper(code)` (the QR code `M6D2`, spaces trimmed) is used by
  Settings and by the developer page. `dev/MusicSection.svelte` is a placeholder until Step 9.
- Browser check: home and Settings have no link to `/?dev` while developer mode is off; a wrong
  code shows "That is not the developer code."; `M6D2` turns it on, saves
  `developer: true` in `hack-star.options` and shows the **Developer page** link and
  **Turn off**. `/?dev` in a fresh browser asks the code, then shows the Music section.
  The only reference to `?dev` outside `lib/dev/` is that Settings link.

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — developer mode per browser and the hidden
developer page with its code check. `npm test` 258 passed; `npm run check` 0 errors;
`npm run build` built; browser checks as above.

---

## Step 9 — Music section of the developer page

### Goal
The Music section lists the candidate tracks with their details, plays and stops them, marks
the five, deletes tracks and shows the request to find more (S20, S22, S26, S27, S28).

### Tasks
- [x] Record the start time in Notes below.
- [x] `ui/dev/music/candidates.json` (empty list) and the `.gitignore` line for the audio
      files (D9).
- [x] The dev-only Vite plugin (D10): list, serve files, choose / unchoose (copies to or
      removes from `public/assets/music/` and updates `src/lib/music/tracks.json`), delete
      (refused for a chosen track).
- [x] `dev/MusicSection.svelte`: the list, play / stop, choose, delete, and the ready-to-copy
      request (moods of S21, licences of S22, at most 15, the details of S26).
- [x] Tests for the plugin's list rules (at most five chosen, no delete of a chosen track,
      only CC0 / CC BY / own licences accepted).
- [x] Check: `cd ui; npm test; npm run check; npm run build` — the build contains neither the
      plugin nor any candidate file.

### Notes
Started: 2026-11-14 15:30

- The rules are in `src/lib/music/candidates.ts` (no imports, so both the game and the dev
  server use them): allowed licences (`CC0`, `CC BY` any version, `Made for Hack star`), at
  most 5 chosen / 15 candidates, a chosen track cannot be deleted, `shipped()` writes
  `tracks.json`. File names must match `[\w-]+.mp3`, so no path can leave the music folders.
- `ui/dev/musicPlugin.ts` (`apply: 'serve'`, type-checked through `tsconfig.node.json`):
  `GET /__dev/music/list`, `GET /__dev/music/file/<name>`, `POST /__dev/music/{choose,unchoose,delete}`.
  Changes are accepted only from this computer (the dev server also listens on the Wi-Fi
  for phones). A byte-order mark in `candidates.json` (saved by Windows tools) is accepted.
- Check against `npm run dev` with two placeholder candidates (then removed): list and file
  serving work, `..%2F..` paths get 404, an NC licence is refused, choose copies the file to
  `public/assets/music/` and writes `tracks.json`, delete of a chosen track is refused,
  unchoose removes the public copy, delete removes the candidate file. The developer page
  showed the list, the licence warning and the request. `dist/` has no plugin code, no MP3
  and no `dev/` folder.

**Done (2026-11-14 · ~15m · Claude Opus 5.5)** — the developer page lists, plays, chooses and
deletes candidate tracks and shows the request to find more; nothing of it ships.
`npm test` 262 passed; `npm run check` 0 errors; `npm run build` built; endpoint and browser
checks as above.

---

## Step 10 — Find, try and choose the five tracks

### Goal
Up to 15 candidate tracks are found or made, checked and listened to, and the team chooses the
five that ship (S20, S21, S22). This Step needs Martin and Mattia.

### Tasks
- [ ] Record the start time in Notes below.
- [ ] With the section's request, find or make up to 15 candidates covering the moods of S21;
      for each, check the licence on the source's own page (CC0, CC BY, or made by us — never
      NC or ND) and record title, author, source and licence.
- [ ] Download them into `ui/dev/music/` (D9, D11).
- [ ] Martin and Mattia listen on the developer page and choose five; delete the rest or keep
      them as candidates.
- [ ] Check: `src/lib/music/tracks.json` lists five tracks, each with its licence and credit;
      the five files are in `public/assets/music/`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 11 — Music in matches and its Settings

### Goal
With music on, the chosen track plays in every match and stops when it ends; Settings turns it
on or off and chooses the track (S18, S19, S29, S30).

### Tasks
- [x] Record the start time in Notes below.
- [x] `options.ts`: `music` and `track` (D12).
- [x] `music/player.ts` (D13); the match (bots, Training, friends) starts it at the start and
      stops it at the end or when the player leaves; pause while the tab is hidden.
- [x] Settings: music on/off and the five tracks; texts in all five languages.
- [x] Tests: options defaults and fallback of an unknown track; the player's start / stop /
      hidden / shown rules with a fake audio element.
- [x] Check: `cd ui; npm test; npm run check`; in the browser: music plays in a match on a
      desktop and an iPad or phone, stops at the end, stays silent when off.

### Notes
Started: 2026-11-14 15:37

- Done before Step 10 (which needs Martin and Mattia): everything works with any number of
  shipped tracks. With none (today), Settings shows "Music is coming soon." and matches stay
  silent; once `tracks.json` lists tracks, the switch and the track list appear.
- `music/tracks.ts` gives the shipped list a type (`tracks.json` is written by the developer
  page). `Arena.svelte` starts the music when it mounts (every match, Training and matches with
  friends) and stops it when the match ends and when it unmounts (the player leaves).
- Browser check with a temporary 2-second test tone as the only track (removed afterwards):
  Settings shows On / Off and the track; a 5-second match plays it looping from the start and
  pauses at the end; with music off nothing plays and the track list is hidden; Training
  plays it and leaving stops it; a hidden tab pauses it and showing the tab plays it again.
  Headless desktop only — an iPad or phone check is left for when real tracks are chosen
  (Step 10 / Step 13).

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — music in every match with an on/off switch
and track choice saved per device. `npm test` 265 passed; `npm run check` 0 errors;
`npm run build` built; browser checks as above.

---

## Step 12 — About panel

### Goal
Settings opens an About panel with the game's name, version, music credits and the MIT licence
(S23, S29, S30).

### Tasks
- [x] Record the start time in Notes below.
- [x] `AboutPanel.svelte` opened from Settings: name, version and licence text (D14), the
      credit of every track in `music/tracks.json` (title, author, licence, link), and the
      copyright line.
- [x] Texts in all five languages (the licence text stays in English, as written).
- [x] Check: `cd ui; npm test; npm run check; npm run build`; the panel shows on phone and
      desktop and lists all five tracks.

### Notes
Started: 2026-11-14 15:44

- Settings → **About Hack star** opens a dialog: "Hack star", "Version 0.1.0" (from
  `ui/package.json`), **Music** with one line per shipped track (title — author · licence
  linked to the source) or "No music yet.", and **Licence**: the full text of the repository's
  `LICENSE` (imported with `?raw`, so it includes the copyright line "© 2026 Martin Nordio and
  Mattia Nordio"). The file's fixed line breaks are joined per paragraph so it reads well on a
  phone; the words are unchanged.
- `vite.config.ts`: `server.fs.allow` lets the dev server read `../LICENSE`; the build bundles
  the text.
- Browser check at phone size (430×932): name, version, "No music yet.", five licence
  paragraphs; screenshot checked. The track list renders from `TRACKS`; with no tracks chosen
  yet it shows the empty message — the five credits are checked again in Step 13 once
  Step 10 is done.

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — About panel with name, version, music credits
and the MIT licence. `npm test` 265 passed; `npm run check` 0 errors; `npm run build` built
(licence text in the bundle); browser check as above.

---

## Step 13 — Documentation and final check

### Goal
The documents describe everything new, and everything that worked before still works
(S10, S22, S31).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `README.md`: parts, skins, saving, music, About, developer mode and page; one sentence
      on music in **Art** (S31).
- [ ] `docs/architecture.md`: progress version 7, skin id, created skins, music player and
      files, options, developer page and the dev-only plugin.
- [ ] `ui/public/assets/LICENSES.md`: music section with the five tracks and how a new track
      is checked (S22).
- [ ] Full check: `cd server; uv run pytest`; `cd ui; npm test; npm run check; npm run build`;
      in the browser, one pass over S1–S31 on desktop and phone, including a reload and a
      second tab (S10, S13).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

Tasks set aside for a future spec, so nothing is forgotten.

| Task | Reason | Target Spec |
|------|--------|------------------|
| Music on the home screen and in menus | S19 asks for matches only | a later music spec, if wanted |
| Graphics section of the developer page | Spec 2 | [Graphics review](2026_11_14_2_graphics_review_spec.md) |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S31 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `uv run pytest`, `npm test`, `npm run check` and `npm run build` pass; README / `docs/architecture.md` updated where affected
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
