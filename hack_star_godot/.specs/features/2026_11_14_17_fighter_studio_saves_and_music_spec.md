# Fighter Studio, Saves and Music Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/fighter-studio-saves-and-music`
> **Moved from:** [2026_11_14_1_fighter_studio_saves_and_music_spec.md](../../../.specs/features/done/2026_11_14_1_fighter_studio_saves_and_music_spec.md) (#19)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_14_1_fighter_studio_saves_and_music_spec.md (requirements only) |

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
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_14_1_fighter_studio_saves_and_music_spec.md) (#19).
- [Bug fixes spec](2026_11_14_16_bug_fixes_spec.md) — created-fighter collection, stable
  ids, account saving and cross-tab sync; this spec builds on it.
- [Accounts, fighters and languages spec](2026_11_13_15_accounts_fighters_and_languages_spec.md)
  — up to 5 accounts per browser, each with its own name, language and progress; the
  creator (type, two colours from 8, head and body from 3 each).
- [Skins shop spec](2026_11_12_10_skins_shop_spec.md) — owning, choosing and wearing skins.
- [Overtime and match options spec](2026_11_12_11_overtime_and_match_options_spec.md) — bot
  level and number of bots saved in the Settings.
- [Play with friends spec](2026_11_12_14_play_with_friends_spec.md) — friends in a room see
  each other's fighter and skin.
- [First match spec](2026_11_12_07_first_match_spec.md) — rewards are given only when a match
  ends.
- [Hack codes spec](2026_11_12_05_hack_codes_spec.md) — the QR page asks for a code every time
  (a lock for kids, not security).
- The Settings have language, bots and account reset; no sound yet. There is no music in the
  repository (spec 01, D13: music goes to the git-ignored `hack_star_godot/assets/music/`).
- The game's licence is the MIT licence ([LICENSE](../../../LICENSE)); only original or CC0 art.

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
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and product questions |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–16) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.

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
  the shipped tracks (up to ten). Music is on the first time; the choice is saved on this device for all its
  accounts, and kept as in S10.
- **S19 — When it plays:** With music on, the chosen track plays during every match —
  against bots, in Training and with friends — starting when the match starts and stopping
  when it ends or the player leaves it. It pauses while the tab is hidden and goes on when the
  tab is shown again and the match is still running. With music off, the game is silent.
- **S20 — Choosing the tracks:** On the developer page (S25), the team listens to up to 15
  candidate tracks and marks up to ten that ship; they are chosen only after listening and
  after their licences are checked (S22). Players never see or hear the other candidates, and
  their files are not part of the game players download.
- **S21 — Moods:** The five tracks cover different moods, for example big-drum anthemic
  pop-rock, a funky dance groove, and classic arcade or chiptune game music. These are
  styles only: no track imitates a specific artist or song.
- **S22 — Music rights:** Every candidate and shipped track is made for the project, or is
  under CC0, or under CC BY with its version (e.g. CC BY 3.0) with its credit shown as in S23. Licences that
  forbid commercial use (NC) or changes (ND), or ask for share-alike (SA), are never used. No track copies or samples an
  existing recording, melody or lyrics.

### About and credits

- **S23 — About panel:** Settings opens an **About** panel showing the game's name and
  version, the credits of every shipped track (title linked to its source, author or the
  exact credit the source asks for, and the licence linked to its official Creative Commons
  page), a note that the tracks are unchanged and not under the MIT licence, and the MIT licence with its copyright line (© 2026 Martin Nordio and Mattia
  Nordio). The credits are read from the developer's local track list, so they always match
  the tracks in the build.

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
- ~~**S31 — Documentation:** The README and `docs/architecture.md` describe the new parts,
  skins, saving, music, the About panel, developer mode and the developer page.
  `ui/public/assets/LICENSES.md` gets a music section with each shipped track, its author,
  source and licence, and how a new track is checked. The README section **Art** keeps its
  current text and gains one sentence on music (for example "Music is made for the project or
  uses a free licence (CC0 or CC BY, credited in the game's About panel); see
  ui/public/assets/LICENSES.md.").~~ (replaced for the Godot game by S35: it names the
  documents and paths of the Python + Svelte game)
- ~~**S32 — No music in the repository (added while implementing):** The repository contains
  no music and offers none: tracks, their lists and choices stay on each developer's computer
  and are never committed. `ui/public/assets/LICENSES.md` names no tracks; it lists the
  recommended licences and what each needs, and says that whoever adds a track must check
  its licence on its source page and is responsible for it. This replaces the shipped tracks
  and the repository credits of S20, S22 and S31.~~ (replaced for the Godot game by S36: it
  names a path of the Python + Svelte game)
- **S33 — Up to ten tracks and licence links (added while implementing):** Up to ten tracks
  can be chosen instead of five; a CC BY licence must name its version; the About panel and
  the developer page link each licence to its official page, and the developer page shows the
  credit a source asks for. The developer page has its own dark, scrolling background.
- ~~**S34 — Music tools only on this computer (added while implementing):** Every request of
  the developer page's music tools (list, play, choose, unchoose, delete) is answered only for
  the computer that runs `npm run dev`; other devices on the Wi-Fi get a refusal (review
  finding 1).~~ (replaced for the Godot game by S37: it names the Python + Svelte game's
  development server)
- **S35 — Documentation (Godot):** `hack_star_godot/README.md` and
  `hack_star_godot/docs/architecture.md` describe the new parts, skins, saving, music, the About
  panel, developer mode and the developer page. The README has a section on art and music: music
  is made for the project or uses a free licence (CC0 or CC BY, credited in the game's About
  panel), where the local music folder is, the recommended licences and how a new track is
  checked.
- **S36 — No music in the repository (Godot):** The repository contains no music and offers
  none: tracks, their lists and choices stay on each developer's computer, in the git-ignored
  `hack_star_godot/assets/music/` (spec 01, D13), and are never committed. No document of the
  repository names tracks; it lists the recommended licences and what each needs, and says that
  whoever adds a track must check its licence on its source page and is responsible for it.
  This replaces the shipped tracks and the repository credits of S20, S22 and S31.
- **S37 — Music tools only on this computer (Godot):** Every action of the developer page's
  music tools (list, play, choose, unchoose, delete) works only on the developer's own computer
  that runs the Godot game from the project folder; on other devices, for example an iPad on the
  same Wi-Fi, they are refused.

### Open questions

- **Q1 (Martin) — music tools in Godot:** The developer page's music tools list, choose and delete
  files in `hack_star_godot/assets/music/`. A game exported for the web cannot change files on
  the computer, and Godot only imports music that is inside the project. How do the tools work?
  Suggestion: the developer page runs from the Godot editor or a desktop run on the developer's
  computer, where it can read and delete files in the music folder; the web export has no music
  tools, but plays the tracks the developer has chosen on that computer.
  The answer changes S24/S25 (developer mode "in this browser", the page by address `/?dev`) and
  S26/S27 (candidate files kept in the project, the list kept in the repository — already in
  conflict with S36).

_Answered on 2026-11-14 (original spec): candidate tracks come from both sources: made by us
with a free tool, and free-music libraries under CC0 or CC BY._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
