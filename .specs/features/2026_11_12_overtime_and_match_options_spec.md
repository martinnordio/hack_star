# Overtime and Match Options Spec

> **Author:** Martin Nordio
> **Status:** 🟦 Requirements agreed (defaults where Mattia's answer is open)
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/overtime-and-match-options`

---

# Part 1 · Requirements

## Context

Mattia's feedback ([overall_req.md](../overall_req.md), "Feedback from Mattia"): matches stay
2 minutes against 3 bots that also fight each other, but the **bot level should be chosen in a
configuration**, and when time runs out with bots still in, **the match goes on for another
minute without walls**. This is F8 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md).

**Already in the repository** (reuse, don't rebuild):
- [First match spec](done/2026_11_12_first_match_spec.md): `game/match.ts` (countdown, timer,
  results), `game/settings.ts` (`SETTINGS`, `BOT_LEVELS` easy/medium/hard, `?level=` in the
  address for developers), `game/arena.ts` walls, `game/bots.ts`.
- [Trophies spec](done/2026_11_12_trophies_spec.md) and
  [unlock and upgrade spec](done/2026_11_12_unlock_and_upgrade_spec.md): rewards for the
  "time's up" result.
- `progress.ts`: saved progress (version 3).

**New:**
- A **Settings** screen for the player (bot level, number of bots), saved on the device.
- **Overtime**: one more minute in which the walls disappear.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and Mattia's answers |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

- **S1 — Confirmed defaults:** A match lasts 2 minutes, against 3 bots, and bots also fight each
  other (Mattia confirmed; no change).
- **S2 — Settings screen:** A **Settings** button on the home screen opens a screen where the
  player picks the **bot level** (Easy, Medium, Hard) and the **number of bots** (1 to 5). The
  default is Easy and 3 bots.
- **S3 — Settings saved:** The choice is saved on the device at once and used by every match
  (not Training) until changed. Older saved progress keeps working.
- **S4 — Settings shown:** The match countdown shows the chosen level (for example "Hard · 3 bots").
- **S5 — Overtime:** When the 2 minutes end and more than one fighter is still in, the match is
  not over: a big **"OVERTIME!"** banner appears and the timer shows one more minute.
- **S6 — No walls:** At the start of overtime every wall and cactus bush in the arena breaks
  apart with an effect and is gone for the rest of the match, so nobody can hide.
- **S7 — Overtime end:** If only one fighter is left during overtime, the normal result follows
  (victory or defeat). If more than one fighter is still in when overtime ends, the result is a
  **draw** with the "time's up" rewards.
- **S8 — Settings in one place:** The overtime length and the "no walls" rule are settings next
  to the others in `SETTINGS`.
- **S9 — Screen sizes and documentation:** The Settings screen works on desktop, iPad and phone
  in both orientations; README, `docs/architecture.md` and the Info vocabulary ("Overtime") are
  updated.

### Open questions

- **Q1 (Mattia):** "Then it is a draw **but** …" — the sentence was not finished. Until he
  answers, a draw after overtime gives the same as "time's up" today (0 trophies, 20 credits).
  Possible ideas: the fighter with the most health wins; the storm closes in; the fighters
  still in share the trophies.
- **Q2 (Mattia):** Should harder bots give more trophies or credits? Default: no, the same.

<!-- spec-nx:plan -->
