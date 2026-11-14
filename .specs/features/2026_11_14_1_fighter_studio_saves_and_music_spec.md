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
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: renamed (spec 1 of 4), account-name refresh bug added, saving widened to everything the player owns and chooses, statements split one concern each, music references made mood-only |

---

# Part 1 · Requirements

## Context

The fighter creator lets players choose a type, two colours, a head and a body, but there are
few parts to choose from. This spec gives players more original parts to mix and match, up to
five optional skins per created fighter, and music while they play. It also makes sure that
everything a player owns or chooses is still there after they leave the game or turn off the
device, and fixes the account name on the home screen, which does not update after a rename
or an account switch.

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

**New:**
- Hands and legs as parts, and more choices for every part.
- Up to five player-designed skins per created fighter.
- The account name on the home screen always matches the current account.
- Music during matches, with an on/off switch and a choice of five tracks.
- A development-only way to listen to up to 15 candidate tracks.
- A music section in the asset licences and the README.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |
| [README](../../README.md) | How to install, run, test and play |
| [Asset licences](../../ui/public/assets/LICENSES.md) | Where every asset comes from and its licence |

## 1 · Specs

### Creator

- **S1 — More parts:** When creating or editing a created fighter, the player chooses a head,
  a body, hands and legs, each from at least three options.
- **S2 — Mix and match:** Each part can be changed on its own; changing one part or a colour
  keeps every other choice.
- **S3 — Original designs:** Every new part is an original Hack star design (variations such
  as a robot with different arms are welcome); no part copies a character, name, logo or asset
  from another game.
- **S4 — Live preview:** The 3D preview shows the chosen parts and colours before the player
  saves, and turns while the player changes them.

### Skins for created fighters

- **S5 — Optional skins:** A created fighter can have from zero to five skins made by the
  player, in addition to its default look, which is always available.
- **S6 — Manage skins:** The player can create, change and choose a skin for a created
  fighter; the chosen skin is worn on the home screen, in matches and in rooms.
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

### Friends

- **S14 — Same look for friends:** Friends in a room see a created fighter with the same
  parts, colours and chosen skin as its owner; friends on the previous version still see the
  fighter instead of an error.

### Music

- **S15 — Music switch:** Settings has a control to turn music on or off and to choose one of
  five tracks; the choice is kept as in S10.
- **S16 — When it plays:** With music on, the chosen track plays during a match, starts when
  the match starts, and stops when the match ends or the player leaves it. With music off,
  the game is silent.
- **S17 — Trying tracks:** While developing, the team can listen to up to 15 candidate tracks
  in the game and pick the five that ship; players never see or hear the other candidates.
- **S18 — Moods:** The five tracks cover different moods, for example big-drum anthemic
  pop-rock, a funky dance groove, and classic arcade or chiptune game music. These are
  styles only: no track imitates a specific artist or song.
- **S19 — Music rights:** Every shipped track is made for the project or has a licence that
  allows use, change and redistribution with this MIT-licensed game (for example CC0); no
  track copies or samples an existing recording, melody or lyrics.

### Everywhere

- **S20 — Languages:** Every new label and message is shown in all game languages (English,
  Deutsch, Schwiizerdütsch, Español, Italiano).
- **S21 — Devices:** The creator, skin and music controls work with mouse and touch on
  desktop, tablet and phone, in portrait and landscape.
- **S22 — Documentation:** The README and `docs/architecture.md` describe the new parts,
  skins, saving and music. `ui/public/assets/LICENSES.md` gets a music section with each
  shipped track, its source and licence, and how a new track is checked. The README section
  **Art** keeps its current text and gains one sentence on music (for example "Music is made
  for the project or uses a free licence that allows redistribution; see
  ui/public/assets/LICENSES.md.").

### Open questions

- Parts: three options each for hands and legs, and two more each for heads and bodies — or
  other numbers?
- Skins: can a skin change only colours, or also choose other parts?
- Is making a skin free? Proposed: yes; the 500 C price stays for extra created fighters.
- Can a skin be deleted? Proposed: yes; a fighter wearing it goes back to its default look.
- Music on by default, and saved per account or per device? Proposed: on, per device (like the
  bot settings).
- Does music also play in Training and in matches with friends? Proposed: yes, in every match.
- Music when the tab is hidden? Proposed: pause, and resume while the match is still running.
- Where do the 15 candidate tracks come from (made by us with a free tool, or free-licence
  libraries)? Licences other than CC0 (such as CC BY with credit) are allowed only if they
  permit redistribution — accept CC BY?
- Which five tracks ship? Decided after listening to the candidates and checking their
  licences.
- Safari may delete the saved data of a web page that has not been opened for about 7 days.
  Should the game ask the browser to keep its data, and tell the player when the browser
  blocks saving (private browsing)? Proposed: yes, both.
- An unfinished match when the player leaves: lost without reward (as today)?

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
