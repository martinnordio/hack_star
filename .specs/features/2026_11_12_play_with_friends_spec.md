# Play with Friends Spec

> **Author:** Martin Nordio
> **Status:** 🟨 In progress (defaults for Mattia's open answers)
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
- **S9 — Documentation:** README (how to play together), `docs/architecture.md` (rooms, how the
  match is shared) and the Info vocabulary ("Room") are updated.

### Open questions

- **Q1 (Mattia):** Are friends on **your team** against bots (like Duo/Trio Showdown), or does
  everyone fight everyone? **Default used:** same team against the bots; shots do not hurt
  teammates; the team wins if one of you is the last one standing.
- **Q2 (Mattia / Martin):** Only in the same room/Wi-Fi, or also over the internet from
  different houses? **Default used:** same Wi-Fi (the internet needs the server online and a
  login, which is much more work).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Teams in the rules | ✅ Done | [→ Step 1](#step-1--teams-in-the-rules) |
| **2** | Rooms on the server | ⬜ Not started | [→ Step 2](#step-2--rooms-on-the-server) |
| **3** | Friends screen and lobby | ⬜ Not started | [→ Step 3](#step-3--friends-screen-and-lobby) |
| **4** | Shared match | ⬜ Not started | [→ Step 4](#step-4--shared-match) |
| **5** | Final check and documentation | ⬜ Not started | [→ Step 5](#step-5--final-check-and-documentation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration>)**`** line to that Step's **Notes**:
>    date, time it took, a one-line summary and the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | The **host's browser runs the match** (the existing TypeScript rules); the server only keeps rooms and passes messages between the devices of a room | No second copy of the rules in Python; the server stays small |
| D2 | One WebSocket per device at `/api/rooms` (the Vite proxy forwards it); JSON messages: `create`, `join`, `start`, `input` (friend → host), `state` (host → friends), `left`, `closed` | Simple, works on the local network without extra libraries |
| D3 | Each friend moves their own fighter on their own device (walls included) and sends the position ~20 times a second; shots and Supers are requests the host carries out | "Reacts at once" (S5) without waiting for the host; on a home Wi-Fi a little trust is fine |
| D4 | The host sends a **snapshot** ~20 times a second (fighters, shots, timer, result and the events since the last one); friends glide the others towards it and move shots in between | Smooth on screen with few messages (S5) |
| D5 | Teams: every fighter has a `team`; humans share team 0, each bot is its own team; shots, explosions and dashes never hurt the same team; the result is for the team | Q1 default; with one human it is exactly today's game |
| D6 | `World.playerId` says which fighter this device controls (the arena follows it); friends' worlds are "mirrors" that only show the snapshots | The 3D arena works the same on every device |
| D7 | Room codes: 4 letters without I and O; at most 3 devices per room; messages over 64 KB are refused; a room disappears when the host leaves | Easy to type; small attack surface even on a home network |
| D8 | After a shared match everybody goes back to the room; the host can start again | Keeps the friends together |

---

## Step 1 — Teams in the rules

### Goal
The rules support humans on one team against bots, and which fighter a device controls (S4, S7, Q1).

### Tasks
- [x] Record the start time in Notes below.
- [x] `World`: `team` per fighter, `playerId`; no damage to the same team (shots, explosions, dash); `pushEvents()`.
- [x] `Bots`: list of human fighters; never target the same team; `addBot(id)` to take over a fighter.
- [x] `Match`: `humans` and per-fighter `powers`; team results (victory when only the team is left; defeat with place when the whole team is out); a `MatchLike` interface for the arena.
- [x] Check: `vitest` — no friendly fire, bots ignore teammates, team victory while one human is out, team defeat place, one human is today's game, `addBot` takes over.

### Notes
Started: 2026-11-12 13:56

The defeat place counts the other teams still in (with one human that is the number of bots left + 1, as before). Shots fly through teammates.

**Done (2026-11-12 · ~3m)** — `npm test` 118 passed (8 new in `game/teams.test.ts`, all earlier tests unchanged), `svelte-check` 0 errors.

---

## Step 2 — Rooms on the server

### Goal
The server creates rooms, lets friends join and passes messages (S1, S2, S7, S8).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `rooms.py`: `RoomManager` (codes, members with fighter and look, host, max 3, started flag); WebSocket `/api/rooms` in `app.py`; messages validated, 64 KB limit.
- [ ] Relay: `start` and `state` from the host to friends, `input` from friends to the host; `left` when a friend goes, `closed` when the host goes.
- [ ] Vite proxy forwards WebSockets.
- [ ] Check: `pytest` — create gives a code, join shows both members, 4th device refused, unknown code refused, input reaches only the host, state reaches only friends, friend leaving → `left`, host leaving → `closed` and the room is gone.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 3 — Friends screen and lobby

### Goal
Kids create or join a room and see who is in it (S1, S2).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `lib/net/room.ts`: room connection (connect, create, join, send, events).
- [ ] Home: **Friends** button; `FriendsScreen.svelte`: Create room / Join (code or Scan QR); lobby with the code, a QR code (`?room=CODE` link), members with portraits, **Start** for the host, "Waiting for the host…" for friends, **Leave**.
- [ ] A `?room=CODE` link opens the game joining that room.
- [ ] Check (browser, two pages): create on one, join on the other with the code; both lobbies list both fighters; leaving updates the other.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 4 — Shared match

### Goal
The same match plays on every device (S3–S7).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `lib/net/shared.ts`: `HostMatch` (runs the `Match`, applies friends' inputs, sends snapshots) and `GuestMatch` (mirror world: applies snapshots, glides fighters, moves shots, replays events; sends own position, shots and Supers).
- [ ] Arena: plays a shared match (`MatchLike`), each device follows its own fighter, teammates' bars blue, result for the team, rewards saved on each device; "Back to room" after the match.
- [ ] Leaving: a friend who leaves becomes a bot; if the host leaves, friends get a draw.
- [ ] Check: `vitest` with two matches joined by a fake connection (positions, shots, damage and result reach the friend; a friend's shot hurts a bot; leaving); browser with two pages: the friend's fighter moves on the host's screen and the host's on the friend's.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 5 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains playing together (S9).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Friends screen and lobby checked at 390×844, 844×390, 1024×768, 1440×900.
- [ ] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [ ] README (how to play together), `docs/architecture.md` (rooms, shared match), Info vocabulary ("Room", "Teammate").

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Everyone against everyone with friends | Waits for Mattia (Q1) | Later spec, if wanted |
| Playing from different houses (internet) | Needs an online server and logins (Q2) | Later spec, if wanted |
| Chat or emotes | Not asked | Later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
