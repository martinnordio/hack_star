# Play with Friends Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/play-with-friends`
> **Moved from:** [2026_11_12_play_with_friends_spec.md](../../../.specs/features/done/2026_11_12_play_with_friends_spec.md) (#12)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_play_with_friends_spec.md (requirements only) |

---

# Part 1 · Requirements

## Context

Mattia: "the players should have up to 2 friends to play". Today Hack star is single-player
against bots, all in the browser. Playing with friends means each kid plays on their own device
(iPad, phone, computer) in the same match, so the Python server must connect the devices (Python + Svelte game; see S0 / spec 03's server question). This
is the biggest change so far; it is F11 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_play_with_friends_spec.md) (#12).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — the Godot
  architecture document `hack_star_godot/docs/architecture.md` (where the parts are, rooms
  included), how to run the game and play from an iPad or phone on the same Wi-Fi (S12–S14),
  and its open question about the server for rooms.
- [First match spec](done/2026_11_12_07_first_match_spec.md) and
  [overtime and match options spec](2026_11_12_11_overtime_and_match_options_spec.md) — the
  match rules, bots, the number of bots and the bot level in the Settings, overtime.
- Saved progress per device (no login) — each kid keeps their own fighters and trophies (specs
  [08](2026_11_12_08_trophies_spec.md), [09](2026_11_12_09_unlock_and_upgrade_spec.md)).

**New:**
- A **room** a player creates and friends join; a shared match between up to 3 devices.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and Mattia's answers |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–13) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`.
- **S1 — Create a room:** **Play with friends** on the home screen creates a room with a short
  code (4 letters) and a QR code to join.
- **S2 — Join:** A friend joins by typing the code or scanning the QR code. A room holds the host
  and up to **2 friends**; each sees the others' names and fighters.
- **S3 — Start:** The host starts the match; friends take the place of bots, so the match has
  as many fighters as the host's Settings say (default 4: 1 + 3 bots), with at least one bot.
  The bot level is the host's.
- **S4 — Same match:** Every device shows the same match: the same fighters, positions, shots,
  health, timer and overtime, with each kid controlling their own fighter.
- **S5 — Smooth:** On the same Wi-Fi, a kid's own fighter reacts at once to their controls, and
  the others move smoothly (no jumping) at 30 frames per second or more.
- **S6 — Rewards:** Each kid gets trophies and credits for their own result, saved on their own
  device; hacks work only on the device that entered them.
- **S7 — Leaving:** If a friend leaves or loses the connection, a bot takes their fighter and the
  match goes on; if the host leaves, the match ends as a draw for the others.
- **S8 — Network:** Works for devices on the same Wi-Fi as the server; nothing is sent outside it.
- ~~**S9 — Documentation:** README (how to play together), `docs/architecture.md` (rooms, how the
  match is shared) and the Info vocabulary ("Room") are updated.~~ (replaced for the Godot game
  by S10: it names the documents of the Python + Svelte game)
- **S10 — Documentation (Godot):** `hack_star_godot/README.md` (how to play together),
  `hack_star_godot/docs/architecture.md` (rooms, how the match is shared) and the Info
  vocabulary ("Room") are updated.

### Open questions

- **Q1 (Mattia):** Are friends on **your team** against bots (like Duo/Trio Showdown), or does
  everyone fight everyone? **Default used:** same team against the bots; shots do not hurt
  teammates; the team wins if one of you is the last one standing.
- **Q2 (Mattia / Martin):** Only in the same room/Wi-Fi, or also over the internet from
  different houses? **Default used:** same Wi-Fi (the internet needs the server online and a
  login, which is much more work).
- **Q3 (Martin) — server for rooms (Godot):** Rooms need a server that connects the devices. Does
  the Godot game use the existing FastAPI server (`server/`) for them, or something in Godot?
  This is the open question of the
  [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) ("Server for rooms and
  hack codes"); answer it there first. Suggestion: keep the FastAPI server (same rooms and codes
  as the Python game).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
