# Play with Friends Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress (waiting for Mattia's answers)
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/play-with-friends`

---

# Part 1 · Requirements

## Context

Mattia: "the players should have up to 2 friends to play". Today Hack star is single-player
against bots, all in the browser. Playing with friends means each kid plays on their own device
(iPad, phone, computer) in the same match, so the Python server must connect the devices. This
is the biggest change so far; it is F11 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- FastAPI server (`server/`) on port 8180, reachable from other devices on the same Wi-Fi
  (README "play from an iPad or phone").
- Match rules in plain TypeScript (`game/world.ts`, `game/match.ts`, `game/bots.ts`) with no
  drawing inside, and the 3D arena (`ArenaScene.svelte`).
- Saved progress per device (no login) — each kid keeps their own fighters and trophies.

**New:**
- A **room** a player creates and friends join; a shared match between up to 3 devices.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Create a room:** **Play with friends** on the home screen creates a room with a short
  code (4 letters) and a QR code to join.
- **S2 — Join:** A friend joins by typing the code or scanning the QR code. A room holds the host
  and up to **2 friends**; each sees the others' names and fighters.
- **S3 — Start:** The host starts the match; free places are filled with bots so there are
  always 4 fighters (the bot level from the Settings screen).
- **S4 — Same match:** Every device shows the same match: the same fighters, positions, shots,
  health, timer and overtime, with each kid controlling their own fighter.
- **S5 — Smooth:** On the same Wi-Fi, a kid's own fighter reacts at once to their controls, and
  the others move smoothly (no jumping) at 30 frames per second or more.
- **S6 — Rewards:** Each kid gets trophies and credits for their own result, saved on their own
  device; hacks work only on the device that entered them.
- **S7 — Leaving:** If a friend leaves or loses the connection, a bot takes their fighter and the
  match goes on; if the host leaves, the match ends as a draw for the others.
- **S8 — Network:** Works for devices on the same Wi-Fi as the server; nothing is sent outside it.
- **S9 — Documentation:** README (how to play together), `docs/architecture.md` (rooms, how the
  match is shared) and the Info vocabulary ("Room") are updated.

### Open questions

- **Q1 (Mattia):** Are friends on **your team** against bots (like Duo/Trio Showdown), or does
  everyone fight everyone? Default: same team against the bots; the team wins if one of you is
  the last one standing.
- **Q2 (Mattia / Martin):** Only in the same room/Wi-Fi (default), or also over the internet
  from different houses? The internet needs the server online and a login, which is much more work.

<!-- spec-nx:plan -->
