# Originality Review Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/originality-review`
> **Issue:** #22

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written (spec 4 of 4) |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: open questions answered (S10–S13) |
| 2026-11-14 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #22 created |

---

# Part 1 · Requirements

## Context

Hack star started as a game inspired by Brawl Stars, and the game works and is fun. We want to
keep what makes it fun while making it more clearly our own. This spec is a review only: it
lists the game's features, shows which other games have similar ones, and proposes what to
keep and what to change. It is written for a public MIT-licensed repository, so it uses
neutral, factual wording. It changes no game code.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `README.md` and `docs/architecture.md` — the game's features today: 3D matches against bots
  or friends, fighters with types and Supers, Hypercharge, trophies and Prestige badges,
  credits and power levels, a skins shop, hack codes and QR codes, created fighters, accounts
  and five languages.
- README section **Licence and disclaimer** — states that Hack star is an independent fan
  project, not affiliated with or endorsed by Supercell, with no Supercell code, art, sound or
  other content.
- `ui/src/lib/i18n/en.ts` — the words players see; for example "Hypercharge", "Prestige",
  "Trophies" and "Power" appear in the game text.
- `.specs/overall_req.md` — the original idea, which names Brawl Stars as the inspiration.
- `.specs/features/ideas.md` — "Make different worlds" (idea from Mi).

**New:**
- A feature-by-feature comparison with other games, and options to keep or change.
- A short list of recommended changes for future specs.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and product questions |
| [ideas.md](ideas.md) | Ideas collected for later specs |
| [README](../../README.md) | Features, Art, Licence and disclaimer |
| [architecture.md](../../docs/architecture.md) | How the server and the UI are organised |

## 1 · Specs

- **S1 — Feature list:** The review lists every player-visible feature of Hack star today
  (screens, game rules, progression, shop, names of things), each in one line.
- **S2 — Other games:** For each feature, the review names other games with a similar feature
  (at least two where they exist, from more than one genre — for example arena shooters, hero
  shooters, battle royales, mobile strategy games, party fighters) and says whether the
  feature is **common in the genre** or **distinctive to one game**.
- **S3 — Names and words:** The review lists every name and word in the game (fighters, game
  terms, screens) that is the same as, or close to, a distinctive term of another game, and
  proposes at least one alternative for each.
- **S4 — Keep or change:** For each feature, the review proposes keep, adjust or replace, with
  what it keeps of the fun, the effort (small, medium or large) and the risk for existing
  saves and players.
- **S5 — Our own identity:** The review proposes at least three directions that only Hack star
  has, building on what is already ours (hack codes and QR codes, the fighter creator, play
  with friends nearby) and on the ideas in `ideas.md`, such as different worlds.
- **S6 — Short list:** The review ends with the five recommended changes, most valuable first,
  each written as a one-line request for a future `REQUIREMENTS:` command.
- **S7 — Public wording:** The review is factual and respectful about other games: no copied
  text, pictures or logos from them, no claims about their sales or quality, and other games'
  names used only to identify them. It states that it is not legal advice.
- **S8 — Disclaimer check:** The review checks the README disclaimer and the public texts of
  the repository (README, docs, specs) for wording that could suggest a link to another game
  or its owner, and proposes changes; it does not change them.
- **S9 — No game change:** The game's code, assets and texts do not change; the findings are
  written into this spec.
- **S10 — Same kind of game:** The proposals keep Hack star the same kind of game and give it
  its own identity; they do not turn it into a different kind of game.
- **S11 — Game words listed, not renamed:** Game words such as "Hypercharge" are listed with
  alternatives (S3); renaming them is one of the candidates for the short list (S6), not part
  of this spec.
- **S12 — Wording of the original idea:** The review proposes new wording for the sentences
  of `.specs/overall_req.md` that compare the game's look to another game; the file itself is
  not changed.
- **S13 — Worlds:** For the "different worlds" idea, the review describes both options — a
  theme only (arena look and music) and a theme with its own rules — and recommends one.

### Open questions

_None — answered on 2026-11-14._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
