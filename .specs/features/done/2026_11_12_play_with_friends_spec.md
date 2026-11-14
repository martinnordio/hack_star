# Play with Friends Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ✅ Done (with defaults for Mattia's open answers)
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/play-with-friends`
> **Issue:** [#12](https://github.com/martinnordio/hack_star/issues/12)

---

# Part 1 · Requirements

## Context

Mattia: "the players should have up to 2 friends to play". Today Hack star is single-player
against bots, all in the browser. Playing with friends means each kid plays on their own device
(iPad, phone, computer) in the same match, so the Python server must connect the devices. This
is the biggest change so far; it is F11 in the
[MVP and architecture spec](2026_11_12_mvp_and_architecture_spec.md).

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
| [overall_req.md](../../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../../docs/architecture.md) | How the code is organised |
| [README](../../../README.md) | How to install, run and play |

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
| **2** | Rooms on the server | ✅ Done | [→ Step 2](#step-2--rooms-on-the-server) |
| **3** | Friends screen and lobby | ✅ Done | [→ Step 3](#step-3--friends-screen-and-lobby) |
| **4** | Shared match | ✅ Done | [→ Step 4](#step-4--shared-match) |
| **5** | Final check and documentation | ✅ Done | [→ Step 5](#step-5--final-check-and-documentation) |

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
- [x] Record the start time in Notes below.
- [x] `rooms.py`: `RoomManager` (codes, members with fighter and look, host, max 3, started flag); WebSocket `/api/rooms` in `app.py`; messages validated, 64 KB limit.
- [x] Relay: `start` and `state` from the host to friends, `input` from friends to the host; `left` when a friend goes, `closed` when the host goes.
- [x] Vite proxy forwards WebSockets.
- [x] Check: `pytest` — create gives a code, join shows both members, 4th device refused, unknown code refused, input reaches only the host, state reaches only friends, friend leaving → `left`, host leaving → `closed` and the room is gone.

### Notes
Started: 2026-11-12 13:57

A member is `{fighter, skin, power, hyper}` (fighter checked against the catalogue, power 1–22); players are shown as "Player 1–3" with their fighter, so no names are sent. Also: a started room cannot be joined until the host sends `lobby` (back to the room); friends cannot send `state` or `start`; at most 100 rooms. First run: a friend leaving a room its host had already closed crashed the handler — fixed.

Later (2026-11-12): the room tests sometimes hung. The test client gave each socket its own event loop and could cancel a handler when its socket's context closed, before it told the others; the tests now share one event loop (as on the real server) and close sockets explicitly. 10 runs in a row passed.

**Done (2026-11-12 · ~3m)** — `pytest` 27 passed (9 new in `tests/test_rooms.py`); browser: a WebSocket through the Vite proxy created room "ZKJF".

---

## Step 3 — Friends screen and lobby

### Goal
Kids create or join a room and see who is in it (S1, S2).

### Tasks
- [x] Record the start time in Notes below.
- [x] `lib/net/room.ts`: room connection (connect, create, join, send, events).
- [x] Home: **Friends** button; `FriendsScreen.svelte`: Create room / Join (code or Scan QR); lobby with the code, a QR code (`?room=CODE` link), members with portraits, **Start** for the host, "Waiting for the host…" for friends, **Leave**.
- [x] A `?room=CODE` link opens the game joining that room.
- [x] Check (browser, two pages): create on one, join on the other with the code; both lobbies list both fighters; leaving updates the other.

### Notes
Started: 2026-11-12 14:00

Home's side buttons are now 3 per row (7 buttons). The Start button says how many players and bots will play. Start itself is wired in Step 4. First browser try: joining from a link joined again whenever the code box or the progress changed (the join ran in a Svelte effect that tracked them), leaving two extra connections in the room; fixed by joining once on mount and dropping any connection that a newer create/join replaced.

**Done (2026-11-12 · ~4m)** — `npm test` 120 passed (2 new in `net/room.test.ts`), `svelte-check` 0 errors; browser with two pages: page 1 created room LCNG (QR shown, "START · 1 player + 3 bots"); page 2 opened `?room=LCNG` → both lobbies list Player 1 👑 and Player 2 ("you" on each), host button "2 players + 2 bots"; page 2 left and rejoined by typing "lcng" → still exactly 2 players.

---

## Step 4 — Shared match

### Goal
The same match plays on every device (S3–S7).

### Tasks
- [x] Record the start time in Notes below.
- [x] `lib/net/shared.ts`: `HostMatch` (runs the `Match`, applies friends' inputs, sends snapshots) and `GuestMatch` (mirror world: applies snapshots, glides fighters, moves shots, replays events; sends own position, shots and Supers).
- [x] Arena: plays a shared match (`MatchLike`), each device follows its own fighter, teammates' bars blue, result for the team, rewards saved on each device; "Back to room" after the match.
- [x] Leaving: a friend who leaves becomes a bot; if the host leaves, friends get a draw.
- [x] Check: `vitest` with two matches joined by a fake connection (positions, shots, damage and result reach the friend; a friend's shot hurts a bot; leaving); browser with two pages: the friend's fighter moves on the host's screen and the host's on the friend's.

### Notes
Started: 2026-11-12 14:04

The start message carries every fighter's id, type, look, power and HYPERCHARGE hack, so each device builds the same fighters. Friends start along the bottom of the arena next to the host (`teamArena`): at the top spawn the cliffs hid a friend's view. A friend's own dash follows the host's position for a moment, and the host ignores the friend's position during and just after it.

Browser check: only the visible page of the shared browser runs its animation frames, so the two sides were checked one at a time against a scripted other side. (1) Host page visible, a scripted friend (Rocko) on its own WebSocket: the lobby showed "Player 2 Rocko · ⚡ 4"; after START the host's world moved Rocko to x 6 as the friend sent, bots hurt Rocko (5120 → 3447 health in the friend's snapshot), and the friend received 122 snapshots in ~6 s (~20 per second). (2) Friend page visible, a scripted host (Kira) sending snapshots: the friend's screen showed Kira gliding and the host's shot, Super 60%, its own Blaze moved at once (x 0 → 3.6) and the host received the positions and a shot; when the host closed, the friend got "TIME'S UP" with "Back to the room". A real two-device match is left for the final check on two devices.

**Done (2026-11-12 · ~15m)** — `npm test` 129 passed (8 new in `net/shared.test.ts`, 1 new team spawn test), `svelte-check` 0 errors; browser checks above with no page errors.

---

## Step 5 — Final check and documentation

### Goal
Everything works on every screen size; the documentation explains playing together (S9).

### Tasks
- [x] Record the start time in Notes below.
- [x] Friends screen and lobby checked at 390×844, 844×390, 1024×768, 1440×900.
- [x] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [x] README (how to play together), `docs/architecture.md` (rooms, shared match), Info vocabulary ("Room", "Teammate").

### Notes
Started: 2026-11-12 14:19

Still to try by hand: a real match on two or three devices on the same Wi-Fi (the browser checks used one real side and one scripted side, see Step 4).

**Done (2026-11-12 · ~4m)** — browser at the four sizes: home's 7 side buttons (3 per row) fit without touching PLAY, the name plate or the top bar; Friends screen and lobby (code, QR, 3 player slots, START) with no sideways scrolling; `pytest` 27 passed, `npm test` 129 passed, `svelte-check` 0 errors, `npm run build` OK; README, architecture (with a message diagram) and vocabulary updated.

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
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted — no git host yet: merged locally into `master`
