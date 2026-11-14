# Fighter Studio, Saves and Music Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/fighter-studio-saves-and-music`

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | GitHub Copilot | Part 1 drafted from the creator expansion notes; product choices remain open |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: renamed (spec 1 of 4), account-name refresh bug added, saving widened, music references made mood-only; open questions answered; credits panel, developer mode and developer page (music section) added |

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

_Written by the plan stage once Part 1 is agreed._
