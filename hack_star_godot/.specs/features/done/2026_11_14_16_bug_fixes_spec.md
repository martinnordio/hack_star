# Bug Fixes Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed again on feature/godot-mvp
> **Created:** 2026-11-21
> **Last updated:** 2026-11-22
> **Branch:** `feature/godot-mvp`
> **Issue:** #33
> **Moved from:** [2026_11_14_bug_fixes_spec.md](../../../../.specs/features/done/2026_11_14_bug_fixes_spec.md) (#17)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_14_bug_fixes_spec.md (requirements only) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked against specs 01–08; S4, S6, S16, S22 revised; S1–S3, S7–S15, S20, S21 moved to spec 15 (S16's CREATOR part too, its HYPERCHARGE part to spec 12, S19's bought things to specs 09 and 10, added there at the end of Part 1); S19 correct by design (a test); S23 (English), S24 (documentation, Godot), S25 (what worked before) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-22 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #33 created (no parent) |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 4.12 M (216 k in · 3.86 M cached · 43 k out) | CHF 2.27 (271 credits) | Part 2 written (5 Steps: reasoning, standard, standard, reasoning, light); also the requirements revision, the moved statements in specs 09, 10, 12 and 15, and the issue (`usage.ps1 -AgentName s16-lead` from 08:20:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.17 M (69 k in · 2.08 M cached · 23 k out) | CHF 1.02 (121 credits) | Step 1 done (`usage.ps1 -AgentName s16-step1` from 08:20:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.52 M (71 k in · 2.43 M cached · 20 k out) | CHF 0.52 (62 credits) | Step 2 done (`usage.ps1 -AgentName s16-steps2-3` from 08:41) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 877 k (7 k in · 867 k cached · 2 k out) | CHF 0.11 (13 credits) | Step 3 done (`usage.ps1 -AgentName s16-steps2-3` from 08:52) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.36 M (69 k in · 2.26 M cached · 23 k out) | CHF 1.06 (127 credits) | Step 4 done (`usage.ps1 -AgentName s16-step4` from 08:54) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | 2.04 M (106 k in · 1.91 M cached · 24 k out) | CHF 0.07 (8 credits) | Step 5 done (`usage.ps1 -AgentName s16-step5` from 09:03) |
| 2026-11-22 | review | `REVIEW:` + `CODE REVIEW:` | Claude Opus 5.5 | 10.93 M (184 k in · 10.68 M cached · 68 k out) | CHF 3.69 (441 credits) | semantic diff written (7 record blocks, checks 7 pass · 2 n/a · 0 fail, [review page](../../review/2026-11-21_godot-mvp-16-bug-fixes.html)); code review: Approve, 0 Blocking · 3 Should-fix · 2 Nit (`usage.ps1 -AgentName s16-review` from 2026-11-22 09:07:26) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.24 M (171 k in · 2.06 M cached · 15 k out) | CHF 0.65 (78 credits) | review fixes #2, #3, #4, #5 and the decision D9 (#1, accepted as a known limitation); commit `Fix review findings (#33)` (`usage.ps1 -AgentName s16-close` 2026-11-22 09:21:55–09:41:07) |
| 2026-11-22 | implementation | `CLOSE:` | Claude Sonnet 5.5 | 702 k (14 k in · 683 k cached · 5 k out) | CHF 0.13 (15 credits) | spec closed (`usage.ps1 -AgentName s16-close` from 2026-11-22 09:41:07) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 328 k (179 k in · 144 k cached · 5 k out) | CHF 0.43 (51 credits) | spec runner (coordination) (`usage.ps1 -AgentName s16-runner` from 2026-11-22 08:20:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 526 k (0 k in · 525 k cached · 1 k out) | CHF 0.11 (13 credits) | orchestrator (main chat) (`usage.ps1 -Agent main` from 2026-11-22 08:20:24) |
| 2026-11-22 | pr | `PR:` | Claude Haiku 5.5 | 1.20 M (88 k in · 1.09 M cached · 21 k out) | CHF 0.03 (3 credits) | pull request opened (one PR for the MVP, #34; `usage.ps1 -AgentName mvp-pr` from 08:20:24) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: spec reopened in place for the author's bug reports (issue #33 kept); S26–S32 added (scan only where it works — Godot 4.7 has no camera on Windows; how to scan on this computer; Space shoots at the nearest target; only Space and touch shoot; How to play; controls hint at the start; documentation); no open questions |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 1.60 M (112 k in · 1.47 M cached · 19 k out) | CHF 1.03 (123 credits) | re-planned: author's bug reports — Steps 1–5 kept; Steps 6–10 added (standard, standard, standard, standard, light), D10–D15 (`usage.ps1 -AgentName s16b-lead` from 2026-11-22 10:04:46) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.99 M (96 k in · 2.88 M cached · 14 k out) | CHF 0.56 (67 credits) | Step 6 done (`usage.ps1 -AgentName s16b-steps6-9` 2026-11-22 10:09:00–10:28:40) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.66 M (48 k in · 2.60 M cached · 17 k out) | CHF 0.46 (55 credits) | Step 7 done (`usage.ps1 -AgentName s16b-steps6-9` 2026-11-22 10:29:08–10:36:23) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.48 M (21 k in · 2.45 M cached · 9 k out) | CHF 0.33 (39 credits) | Step 8 done (`usage.ps1 -AgentName s16b-steps6-9` 2026-11-22 10:36:43–10:40:52) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.29 M (24 k in · 2.25 M cached · 10 k out) | CHF 0.32 (38 credits) | Step 9 done (`usage.ps1 -AgentName s16b-steps6-9` 2026-11-22 10:41:11–10:45:57) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | 2.27 M (100 k in · 2.15 M cached · 17 k out) | CHF 0.04 (4 credits) | Step 10 done: all Godot checks exit 0, README and architecture updated (`usage.ps1 -AgentName s16b-step10` from 10:46:26) |
| 2026-11-22 | review | `REVIEW:` + `CODE REVIEW:` | Claude Opus 5.5 | 8.00 M (192 k in · 7.76 M cached · 54 k out) | CHF 3.02 (360 credits) | author's reports (Steps 6–10): semantic diff written (6 record blocks, checks 6 pass · 3 n/a · 0 fail, [review page](../../review/2026-11-22_godot-mvp-16-bug-fixes-2.html)); code review: Approve, 0 Blocking · 3 Should-fix · 2 Nit (`usage.ps1 -AgentName s16b-review` from 2026-11-22 10:04:46) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 3.64 M (169 k in · 3.44 M cached · 25 k out) | CHF 0.85 (102 credits) | review fixes (author's reports, findings 1–5); commit `Fix review findings (#33)` (`usage.ps1 -AgentName s16b-close` 2026-11-22 10:04:46–11:35:15) |
| 2026-11-22 | implementation | `CLOSE:` | Claude Sonnet 5.5 | 504 k (13 k in · 489 k cached · 2 k out) | CHF 0.08 (10 credits) | spec closed again (`usage.ps1 -AgentName s16b-close` from 2026-11-22 11:35:15) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 263 k (139 k in · 119 k cached · 5 k out) | CHF 0.34 (41 credits) | spec runner (coordination) (`usage.ps1 -AgentName s16b-runner` from 2026-11-22 10:04:46) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 1.09 M (1 k in · 1.09 M cached · 2 k out) | CHF 0.23 (27 credits) | orchestrator (main chat) (`usage.ps1 -Agent main` from 2026-11-22 10:04:46) |
| 2026-11-22 | pr | `PR:` | Claude Haiku 5.5 | 556 k (60 k in · 485 k cached · 11 k out) | CHF 0.02 (2 credits) | pull request updated (#34: summary and semantic diff of the reopened spec; `usage.ps1 -AgentName s16b-pr` from 2026-11-22 10:04:46) |
---

## Cost summary

This feature used 57.80 M tokens, CHF 17.35 (2069 credits) — measured, see [COSTS.md](../../../../.specs/kit/COSTS.md).

| Stage | Models | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|--------|------------|---------------------------|
| requirements | Claude Opus 5.5 | included in plan | included in plan | 0 % |
| plan | Claude Opus 5.5 | 5.72 M | CHF 3.30 (394 credits) | 20.7 % |
| implementation | Claude Opus 5.5, Claude Sonnet 5.5, Claude Haiku 5.5 | 31.95 M | CHF 7.31 (871 credits) | 45.8 % |
| review | Claude Opus 5.5 | 18.93 M | CHF 6.71 (801 credits) | 42.2 % |
| pr | Claude Haiku 5.5 | 1.20 M | CHF 0.03 (3 credits) | 0.2 % |
| **Total** | | **57.80 M** | **CHF 17.35 (2069 credits)** | **108.9 %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (CHF) | Share of Copilot Business |
|------|-------|--------|------------|---------------------------|
| Step 1 | Claude Opus 5.5 | 2.17 M | CHF 1.02 (121 credits) | 6.4 % |
| Step 2 | Claude Sonnet 5.5 | 2.52 M | CHF 0.52 (62 credits) | 3.3 % |
| Step 3 | Claude Sonnet 5.5 | 877 k | CHF 0.11 (13 credits) | 0.7 % |
| Step 4 | Claude Opus 5.5 | 2.36 M | CHF 1.06 (127 credits) | 6.7 % |
| Step 5 | Claude Haiku 5.5 | 2.04 M | CHF 0.07 (8 credits) | 0.4 % |
| Review fixes | Claude Sonnet 5.5 | 2.24 M | CHF 0.65 (78 credits) | 4.1 % |
| CLOSE | Claude Sonnet 5.5 | 702 k | CHF 0.13 (15 credits) | 0.8 % |
| Spec runner (coordination) | Claude Sonnet 5.5 | 328 k | CHF 0.43 (51 credits) | 2.7 % |
| Orchestrator (main chat) | Claude Opus 5.5 | 526 k | CHF 0.11 (13 credits) | 0.7 % |
| Step 6 | Claude Sonnet 5.5 | 2.99 M | CHF 0.56 (67 credits) | 3.5 % |
| Step 7 | Claude Sonnet 5.5 | 2.66 M | CHF 0.46 (55 credits) | 2.9 % |
| Step 8 | Claude Sonnet 5.5 | 2.48 M | CHF 0.33 (39 credits) | 2.1 % |
| Step 9 | Claude Sonnet 5.5 | 2.29 M | CHF 0.32 (38 credits) | 2.0 % |
| Step 10 | Claude Haiku 5.5 | 2.27 M | CHF 0.04 (4 credits) | 0.2 % |
| Review fixes (author's reports) | Claude Sonnet 5.5 | 3.64 M | CHF 0.85 (102 credits) | 5.4 % |
| CLOSE (author's reports) | Claude Sonnet 5.5 | 504 k | CHF 0.08 (10 credits) | 0.5 % |
| Spec runner (author's reports) | Claude Sonnet 5.5 | 263 k | CHF 0.34 (41 credits) | 2.2 % |
| Orchestrator (author's reports) | Claude Opus 5.5 | 1.09 M | CHF 0.23 (27 credits) | 1.4 % |
| **Total implementation** | | **31.95 M** | **CHF 7.31 (871 credits)** | **45.8 %** |

# Part 1 · Requirements

## Context

This spec collects the bugs that players report (mostly Mattia and his friends) so they are fixed
together in one branch. Each reported bug gets its own group of statements below; new bugs are
added with `REQUIREMENTS: 2026_11_14_16_bug_fixes_spec.md — <bug>` until the plan is written.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../../.specs/features/done/2026_11_14_bug_fixes_spec.md) (#17).
- [Accounts, fighters and languages spec](../2026_11_13_15_accounts_fighters_and_languages_spec.md) —
  the created fighter, its price and its lock: creating is free the first time, every change
  costs 500 C, only the CREATOR code unlocks it.
- [Hack codes spec](2026_11_12_05_hack_codes_spec.md) and
  [unlock and upgrade spec](../2026_11_12_09_unlock_and_upgrade_spec.md) — INFINITY (unlimited
  credits: paying does not take credits).
- Progress is saved per account (spec 15): in the Python game each open browser tab kept its
  own copy in memory and wrote the whole save on every change.
- Checked 2026-11-22 (S0) in the Godot code (specs 01–08 built; no accounts, created fighters,
  shop, rooms, languages or music — specs 09–15, 17, 18): the hacks are `infinite_credits`
  (INFINITY), `unlock_all` (OPENSESAME) and `power22` (POWER22) (`game/hacks.gd` rules,
  `Hacks.spend` leaves the credits with INFINITY, but nothing is bought yet); HYPERCHARGE and
  CREATOR answer "Unknown code" (`HackServer` keeps only the three known ids). The hacks never
  expire: `GameState.active_hacks` is a list of ids, saved as `"hacks": [ids]` in
  `user://hack_star_save.json` (`SaveData` version 2, spec 08 D3), and `activate_hack` refuses an
  id that is already on. The server already sends `duration_seconds` with every hack
  (`server/src/hack_star_server/hacks.py`: 72 h for INFINITY, OPENSESAME, HYPERCHARGE, CREATOR;
  none for POWER22); the game does not read it. The hack screen lists the active hacks by name
  only. `GameState` saves the whole progress on every change and reads the file only once, at
  game start; on the web `user://` is the browser's IndexedDB, copied into each tab's memory when
  the tab starts, so two tabs do not see each other's changes and the last one to save wins
  (the reported bug 4 can happen in Godot; a QR link opens the game with `?hack=` in a new tab,
  spec 05 D9). **Turn all hacks off** (`reset_hacks`) leaves a fighter chosen through OPENSESAME
  chosen although it is locked again, and **Play** plays it; `MatchArena` reads
  `GameState.selected_fighter` again at the end of a match to give the trophies. A hack never
  writes into the progress (`unlock_all` does not add to `unlocked`; spec 08 D4).
- Checked 2026-11-22 for the author's reports (S26–S32, after the first close): the camera scan
  exists only in the web export — `QrScanner` (`scenes/ui/qr_scanner.gd`) fails at once with
  `not_web` elsewhere, and the hack screen then says "Camera not available — type the code"
  only after **Scan QR code** is pressed; Godot 4.7's own camera (`CameraServer`/`CameraFeed`)
  is implemented only on Linux, Android, macOS and iOS, so a desktop run on Windows (editor F5,
  `godot --path .`) has no webcam at all. Shooting with the keyboard does not exist: the arena
  (`scenes/arena.gd`, inherited by `MatchArena`) fires with a left mouse click (held: keeps
  firing) at the mouse's ground point and with the touch aim stick (a drag, or a quick tap that
  fires at the nearest target in range through `Combat.nearest_target`, else straight ahead,
  `_tap_direction`); the input map (`project.godot`) has only the four move actions. Space is
  `ui_accept` and presses a focused button. The Info page (`scenes/info.gd`) lists only the
  words of `Vocabulary`; no screen explains the controls or the goal of a match; the README's
  *Controls* says the mouse aims and a left click fires.

**What was found while checking bug 1** (2026-11-14, headless browser on the Python + Svelte
game's dev server):
1. With INFINITY in a single tab, creating a fighter works and the button says "free"; the
   reported "need more credits" message could **not** be reproduced that way.
2. After **Create**, the Fighters screen does **not** show the new fighter and still shows the
   "➕ Create a fighter" card until the page is reloaded (with or without INFINITY).
3. Tapping that card again opens the creator titled "Create a fighter", but the button says
   "💾 Save changes · 500 C": the second try costs 500 C. Without INFINITY and with fewer than
   500 C this shows "Need … more C" — matching what was reported.
4. In the user's open browser tabs, one tab still showed "Player 1" with 680 C while the saved
   game had switched to "Mattia" without hacks: tabs do not see each other's changes, and the
   last tab to save wins. Opening a hack QR code with the camera opens a **new** tab, so a hack
   entered there can be missing (or overwritten) in the tab the kid goes back to.
5. The created fighter shows 🔒 💻 and "Locked: enter a hack code…" even with INFINITY, by
   design (only CREATOR unlocks it); a kid may read it as "not enough credits".

**New:**
- Fixes for the bugs that can happen in the Godot game as built (S4, S16–S18, S22), each with a
  test that fails before the fix, and a test for what is correct by design (S19); the bugs of
  created fighters move to spec 15 (S0).
- Reopened 2026-11-22 for three bugs the author reported after trying the game (S26–S32): no
  camera when scanning in the desktop run, no way found to shoot with the keyboard, and no
  instructions on how to play.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../../.specs/overall_req.md) | Overall game idea and planned specs |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–08) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. For each bug: can it happen in the Godot game?
  If not, the statement describes the correct behaviour so it is still tested, not a fix.
  _(revised 2026-11-22: specs 09–15, 17 and 18 are not built in Godot yet.)_ — checked
  2026-11-22: a bug whose feature is built in Godot is kept (S4, S16, S17, S18, S22, revised
  where needed); a bug whose feature comes with a later spec is moved there as a statement of
  the correct behaviour, added at the end of that spec's Part 1 (S1–S3, S7–S15, S20, S21 and the
  CREATOR part of S16 to spec 15; the HYPERCHARGE part of S16 to spec 12; the bought things of
  S19 to specs 09 and 10); S19 cannot go wrong in Godot by design and is tested; S6 revised;
  S23 (English), S24 (documentation, Godot) and S25 (what worked before) added; no open
  questions.

### Bug 1 — "INFINITY is on, but I cannot create a fighter"

Reported 2026-11-14: after entering INFINITY, creating a new fighter says there are not enough
credits, although the ∞ is shown. Details: on a desktop browser, INFINITY was typed (not scanned)
by an account with 0 C. Trying again later, creating worked, so the first failure is not
reproduced; but the created fighter did not appear as a normal fighter to select, and it could
not be played.

- ~~**S1 — Free with INFINITY:** While INFINITY is active, creating a fighter and saving changes to
  it never show "Need … more C"; the button shows "free" and the save works, whatever the
  saved credit count is (including 0).~~ (moved to spec 15: created fighters come with spec 15,
  its S25)
- ~~**S2 — New fighter shows at once:** Right after **Create**, the Fighters screen shows the new
  fighter's card and no longer shows the "Create a fighter" card, without reloading the page.~~
  (moved to spec 15: created fighters come with spec 15, its S26)
- ~~**S3 — Creator screen agrees with itself:** The creator shows "Create a fighter" with a free
  **Create** button only when the account has no created fighter; otherwise it shows "Change
  your fighter" with **Save changes** and its price. Title and button never disagree.~~ (moved
  to spec 15: the creator comes with spec 15, its S27)
- **S4 — Hacks and progress across tabs:** When the web game is open in two tabs on the same
  device and browser (for example a hack QR code opened in a new tab), a hack, trophies or a
  choice (fighter, skin) gained in one tab is not lost because of the other tab, and the other
  tab shows it at the latest when it comes back to the front (it does not have to update while
  hidden). _(revised 2026-11-22: the Godot game has no accounts and nothing that changes
  credits yet; the created fighter across tabs moved to spec 15, its S28.)_
- ~~**S5 — Same rules as before:** Without INFINITY, the first creation stays free and every
  change costs 500 C; only the CREATOR code unlocks the created fighter.~~ (removed: the created
  fighter is now usable at once — see S7 and S8)
- **S6 — Devices:** S4, S16–S19 and S22 work on desktop, iPad and phone, with touch and with
  mouse; the hack screen with the time left (S18) fits the five screen sizes of the other
  screens. _(revised 2026-11-22: the other statements it named moved to spec 15.)_
- ~~**S7 — Created fighter is usable at once:** Right after it is created, the created fighter has no
  lock: its card in the Fighters list looks like the other unlocked fighters, it can be selected,
  then shows on the Home screen and is played in matches, Training and with friends — no hack
  code needed. This changes S10/S11 of
  [2026_11_13_15_accounts_fighters_and_languages_spec.md](../2026_11_13_15_accounts_fighters_and_languages_spec.md).~~
  (moved to spec 15: created fighters come with spec 15, its S29)
- ~~**S8 — Prices stay:** Without INFINITY, the first creation stays free and every change costs
  500 C; the created fighter keeps its trophies and power level when it is changed.~~ (moved to
  spec 15: created fighters come with spec 15, its S30)
- ~~**S9 — Place in the list:** In the Fighters list, the created fighter's card comes right after
  the last unlocked fighter and before the locked ones (with 3 unlocked fighters, it is the 4th
  card).~~ (moved to spec 15: created fighters come with spec 15, its S31)
- ~~**S10 — One fighter without CREATOR:** Without the CREATOR code, an account can create one
  fighter; once it exists, the "Create a fighter" card is gone and only **Change** is offered.~~
  (moved to spec 15: accounts, created fighters and CREATOR come with spec 15, its S32)
- ~~**S11 — More fighters with CREATOR:** With the CREATOR code active, the "Create a fighter" card
  stays in the Fighters list, and each extra fighter created costs credits (free with INFINITY).
  Every created fighter has its own name, look, trophies and power level, is usable at once (S7),
  and can be changed on its own (S8).~~ (moved to spec 15: CREATOR comes with spec 15, its S33)
- ~~**S12 — Not enough credits:** Without enough credits for an extra fighter, the creator says how
  many credits are missing and nothing is created.~~ (moved to spec 15: created fighters come
  with spec 15, its S34)
- ~~**S13 — Code text:** In the hack list and on the printable QR page, CREATOR says it lets you create
  more fighters (in all five languages), no longer that it unlocks the created fighter.~~ (moved
  to spec 15: CREATOR and the languages come with spec 15, its S35)
- ~~**S14 — Playing with friends:** Each created fighter looks the same on friends' devices as on the
  player's own device.~~ (moved to spec 15: created fighters come with spec 15, after playing
  with friends of spec 14, its S36)

### Hack codes that expire

Added 2026-11-14 together with the CREATOR change.

- ~~**S15 — Price and maximum:** Each extra created fighter costs 500 C (free with INFINITY). An
  account has at most 15 created fighters; at 15, the "Create a fighter" card is not shown.~~
  (moved to spec 15: created fighters come with spec 15, its S37)
- **S16 — Codes last 3 days:** INFINITY and OPENSESAME stay active for 3 days after they are
  entered, then turn off by themselves. Entering a 3-day code again while it is active starts a
  new 3 days. Codes already active when this version first opens get their 3 days from that
  moment. _(revised 2026-11-22: HYPERCHARGE is not in the Godot game yet — moved to spec 12, its
  S11; CREATOR moved to spec 15, its S38.)_
- **S17 — Codes that last for ever:** POWER22 never turns off. Each code is either a 3-day code or
  a for-ever code, so future codes can be either.
- **S18 — Time left:** The hack screen shows, for each active code, how long it stays active (days
  and hours) or that it lasts for ever.
- **S19 — What you did stays:** What was gained or chosen while a code was active stays after the
  code turns off (trophies, power levels, the fighters unlocked without the code, the chosen
  skins), except S22. _(revised 2026-11-22: correct by design in the Godot game — a hack never
  writes into the progress (spec 08, D4) — so this is a test, not a fix; nothing can be bought or
  upgraded yet: what was bought or upgraded with a code moved to spec 09, its S13, and spec 10,
  its S13; changes to created fighters to spec 15, its S30.)_
- ~~**S20 — Created fighters wait for CREATOR:** When CREATOR turns off, the extra created fighters
  (all but the first) stay in the Fighters list, keep their trophies and power, but cannot be
  selected, played or changed; their card and detail say they are active again when the CREATOR
  code is entered. Entering CREATOR again makes them usable and changeable. If one of them was
  selected, the Home screen shows another usable fighter.~~ (moved to spec 15: CREATOR and
  created fighters come with spec 15, its S39)
- ~~**S21 — First created fighter stays:** The first created fighter (S10), created without CREATOR,
  stays usable whether CREATOR is active or not; only additional created fighters become inactive
  when CREATOR expires (S20).~~ (moved to spec 15: created fighters come with spec 15, its S40)
- **S22 — OPENSESAME is not for ever:** When OPENSESAME turns off (after its 3 days, S16, or with
  **Turn all hacks off**), the fighters that were not unlocked without it are locked again. If
  the chosen fighter is locked again, the Home screen shows another usable fighter, and only
  usable fighters can be played; a match that is running when the code turns off ends with the
  fighter it started with and gives that fighter its trophies. _(revised 2026-11-22: in the
  Godot game nothing is bought yet; **Turn all hacks off** leaves a locked fighter chosen and
  playable today.)_
- **S23 — Language:** All new text (the time left, the for-ever line) is in English;
  translations come with
  [spec 15](../2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-22: the
  Godot game has no languages yet.)_
- **S24 — Documentation (Godot):** `hack_star_godot/README.md` and
  `hack_star_godot/docs/architecture.md` describe how long each code lasts, the time left on
  the hack screen, what happens when a code turns off, and how the progress is kept across
  tabs. _(added 2026-11-22: as in specs 03–08.)_
- **S25 — What worked before:** Home, the fighter list, the fighter screen, the info page, the
  hack screen with its codes typed and scanned, the QR page, Training, the match, the result
  screen with its trophies and the saved progress work as before; a save file of specs 05 and
  08 keeps its progress and its hacks (S16). _(added 2026-11-22: the hacks and the save file
  are shared with specs 05 and 08.)_

### Author's reports after the first close

Reported 2026-11-22 by the author after trying the game on Windows (desktop run and browser).

- **S26 — Scanning where there is no camera:** In a run of the game that cannot scan (the
  desktop run on a computer: the Godot editor's F5 or `godot --path .`), the hack screen does not
  offer a scan that can only fail: **Scan QR code** is disabled (or replaced) and a hint says
  that camera scanning works in the browser version and that the code can be typed here (for
  example "Camera scanning works in the browser version — type the code here"; English). The web
  export keeps scanning with the camera as before; the hint fits the five screen sizes of the
  other screens. _(added 2026-11-22, author's report: Godot 4.7's camera (`CameraServer`,
  `CameraFeed`) works only on Linux, Android, macOS and iOS — there is no webcam on Windows —
  and the game's scanner is the browser's camera, so the desktop run cannot scan.)_
- **S27 — How to scan on this computer:** `hack_star_godot/README.md` explains how to scan a
  hack QR code on this computer: open the browser version at `http://localhost:8060`
  (`tools/serve_web.ps1`; the browser allows the camera on `localhost`), or with `-Https` on a
  phone or an iPad; and that the desktop run cannot scan (S26). _(added 2026-11-22, author's
  report.)_
- **S28 — Space shoots:** In a match and in Training, pressing Space fires a shot, and holding
  Space keeps firing at the normal rate (the same cool-down as before). The shot aims at the
  nearest target in range — the nearest bot still in the match, the nearest dummy still standing
  in Training — and straight ahead in the direction the fighter faces when none is in range.
  Space never presses **Back** or another button of the arena, and nothing fires while the
  player may not act (the countdown, after the end). _(added 2026-11-22, author's report: the
  author could not find how to shoot, "before it was Space".)_
- **S29 — Only Space and touch shoot:** A mouse click in the match or in Training no longer
  fires (only Space does with the keyboard); **Back** still works with a click. Touch is
  unchanged: the left joystick moves, the right stick fires where it is dragged, a quick tap
  fires at the nearest target in range. _(added 2026-11-22, author's report.)_
- **S30 — How to play in the game:** A "How to play" section is reachable from the home screen
  and says, in a few short lines (English): the controls (keyboard: WASD or the arrow keys move,
  Space shoots; touch: the left joystick moves, the right side aims and shoots; **Back** returns
  home), the goal of a match (be the last fighter standing before the timer ends; a fighter that
  does not shoot and is not hit heals), Training (practice on dummies), trophies and Prestige,
  and hack codes. It is readable at the five screen sizes, with mouse and touch. _(added
  2026-11-22, author's report.)_
- **S31 — Controls hint at the start:** When a match or Training starts, a short hint of the
  controls (keyboard: move and Space to shoot; on a touch screen: the two sticks) shows on
  screen and fades away by itself after a few seconds; it covers neither the countdown nor
  **Back**, and does not block moving, shooting or the sticks. It fits the five screen sizes.
  _(added 2026-11-22, author's report.)_
- **S32 — Documentation (author's reports):** `hack_star_godot/README.md` *Controls* and *How
  to play a match* describe Space shooting at the nearest target (no mouse click), the touch
  controls, the "How to play" section and the start hint; *Hack codes* says where scanning works
  (S27); `hack_star_godot/docs/architecture.md` is updated where these changes affect it (the
  arena's input, the hack screen, the Info page). Everything of S25 still works. _(added
  2026-11-22, author's report.)_

### Open questions

_None. The S0 check 2026-11-22 raised no new question: the statements kept take the spec's own
wording; the moved statements keep the spec's answers for spec 15 (CREATOR, prices, the
maximum of 15). The author's reports (S26–S32) leave the choices to the plan (where "How to
play" lives, the wording of the hints)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

_First close (2026-11-22, Steps 1–5); the spec was reopened the same day for the author's
reports (S26–S32, Steps 6–10) and closed again; its summary is the *Reopened 2026-11-22*
paragraph below._

**Built:** INFINITY and OPENSESAME now turn off by themselves 3 days after they are entered (entering one again starts a new 3 days); POWER22 lasts for ever (`Hacks` durations, the server's numbers). The hack screen shows each active code with its time left ("Unlimited credits · 2 days 23 hours left", "Power 22 · Lasts for ever"). What was gained stays when a code turns off; a fighter that only OPENSESAME unlocked is locked again, the Home screen then shows another usable fighter (also after **Turn all hacks off**), and a running match keeps the fighter it started with and gives it its trophies. The save file is version 3 (each hack with its end time and a revision; versions 1 and 2 give their hacks 3 days from the first start) and, on the web, lives in `localStorage` shared by the browser's tabs (`SaveStore`): each save merges a newer save of another tab, and a tab coming to the front shows the others' hacks, trophies and choices. No server call, nothing in `server/` or `ui/` changed.

**Differs from the plan:** The code review (Approve, 0 Blocking · 3 Should-fix · 2 Nit) was handled: finding 2 (the fighter screen refreshes its trophies and Prestige badge on `progress_changed`, with a test), 3 (tests for the 30 s timer, the focus notification and the page becoming visible or hidden; the visibility check is the small `_page_is_visible()` so a test can replace it), 4 (README wording) and 5 (the Definition of Done line) are fixed; finding 1 (a hack turned off in one tab can come back when another unsynced tab saves) is accepted as a known limitation, decision D9, in the README, the architecture and Deferred Items. The garbled sentence about where the web save lives in the README was repaired. The match part of the two-tab browser check and the device play-test stay with the author (Deferred Items). Nothing else differs.

**Files:** `hack_star_godot/game/` (`hacks`, `save_data`, `save_store`), `hack_star_godot/scenes/` (`autoload/game_state`, `hack_screen`, `fighter_screen`, `match_arena`, home and the fighter list), `hack_star_godot/tests/` (`test_hack_times`, `test_save_data_v3`, `test_hack_expiry`, `test_hack_time_rows`, `test_save_tabs` and adjusted files), `hack_star_godot/docs/architecture.md`, `hack_star_godot/README.md`; this spec, now in `done/`, its change record in `changes/done/` and the review page in `review/`.

**Reopened 2026-11-22 (the author's bug reports, S26–S32, Steps 6–10):** The scan button is enabled only where scanning works (the web export; the desktop run shows a hint instead, because Godot 4.7 has no camera feed on Windows, D10), and the Hack screen says how to scan on this computer. Space (held to keep firing) and the right stick shoot at the nearest target in range or straight ahead; the mouse no longer shoots or aims (`Combat.ground_point` and its tests were removed). The Info page has a "How to play" section whose numbers come from the rules (`ControlsHelp.how_to_play()`), and Training and every match show a short controls hint that fades by itself, clear of the countdown, the timer, "Fighters left" and **Back** at the five sizes (on a touch screen it names only the sticks and stands above them). The code review (Approve, 0 Blocking · 3 Should-fix · 2 Nit) was fixed in full: the architecture lists `test_save_tabs.gd` again (finding 1); the Stage log of the spec was rewritten with proper line breaks so the table and the Cost summary heading render (2); the touch hint has a test seam, `Arena.touch_controls`, and the five-size test runs with it, which led to a shorter touch hint that grows upwards to its text (3); Move and Shoot stand on their own lines, so no "·" ends a line (4); the Implementation line is ticked (5). **Differs from the plan:** the touch hint no longer repeats the keyboard line (it would not fit under the countdown at 844×390) and "More in Info" is only on the keyboard hint; the hint's place without a touch screen and `how_to_play()` as a function are explained in the Step Notes. **Files:** `hack_star_godot/game/` (`controls_help`, `combat`), `hack_star_godot/scenes/` (`arena`, `hack_screen`, `info`, `ui/qr_scanner`), `hack_star_godot/tests/` (`test_arena_space`, `test_controls_help`, `test_controls_hint`, `test_hack_screen_scan` and adjusted files), `hack_star_godot/docs/architecture.md`, `hack_star_godot/README.md`, the review page `review/2026-11-22_godot-mvp-16-bug-fixes-2.html` and its change record.## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Timed hack rules and save file version 3 | reasoning (Claude Opus 5.5) — a new saved format with a migration that starts the 3 days, checks of every field and a clock (D1, D2) | ✅ Done | [→ Step 1](#step-1--timed-hack-rules-and-save-file-version-3) |
| **2** | Hacks turn off by themselves | standard (Claude Sonnet 5.5) — `GameState` keeps the end times, checks them and keeps the chosen fighter usable; the match keeps its fighter (D3, D4) | ✅ Done | [→ Step 2](#step-2--hacks-turn-off-by-themselves) |
| **3** | Time left on the hack screen | standard (Claude Sonnet 5.5) — one text per row of an existing screen, refreshed, checked on screenshots (D5) | ✅ Done | [→ Step 3](#step-3--time-left-on-the-hack-screen) |
| **4** | Progress across tabs | reasoning (Claude Opus 5.5) — a storage shared by the browser's tabs, a revision, reloading at the front and merging on write (D6, D7) | ✅ Done | [→ Step 4](#step-4--progress-across-tabs) |
| **5** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks and updating two documents | ✅ Done | [→ Step 5](#step-5--final-check-readme-and-architecture) |
| **6** | Scan button only where scanning works | standard (Claude Sonnet 5.5) — one check of the platform, a disabled button and a hint on an existing screen, checked on screenshots (D10) | ✅ Done | [→ Step 6](#step-6--scan-button-only-where-scanning-works) |
| **7** | Space shoots, the mouse no longer | standard (Claude Sonnet 5.5) — an input action, a held key firing through the existing `fire` and tap-aim, the mouse code removed, tests adjusted (D11, D12) | ✅ Done | [→ Step 7](#step-7--space-shoots-the-mouse-no-longer) |
| **8** | How to play on the Info page | standard (Claude Sonnet 5.5) — one text source and a section at the top of an existing page, checked on screenshots (D13, D14) | ✅ Done | [→ Step 8](#step-8--how-to-play-on-the-info-page) |
| **9** | Controls hint at the start | standard (Claude Sonnet 5.5) — one HUD label with a fade in the arena (and so in the match), placed clear of the countdown, Back and the sticks, checked on screenshots (D15) | ✅ Done | [→ Step 9](#step-9--controls-hint-at-the-start) |
| **10** | Final check, README and architecture (author's reports) | light (Claude Haiku 5.5) — running the checks and updating two documents | ✅ Done | [→ Step 10](#step-10--final-check-readme-and-architecture-authors-reports) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

> **Godot spec:** this spec lives in `hack_star_godot/.specs/`. Every stage writes its files
> there (`changes/`, `review/`, `costs.md`, `features/done/`), never in the root `.specs/`;
> the checks are `hack_star_godot/tools/check_tools.ps1`, `test.ps1`, `lint.ps1`,
> `export_web.ps1` (all exit 0) and the guideline is
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../../AGENTS.md)). Each
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0. Nothing in `server/` or `ui/`
> changes (D1: the server already sends the durations). `gdlint` allows at most 20 public
> tests per file: new tests go into new files where a file would pass 20 (`test_hack_screen.gd`
> has 15, `test_game_state.gd` and `test_game_state_save.gd` 11, `test_hacks.gd` 10,
> `test_screen_sizes.gd` 16). The tests never touch the player's save file (spec 08, D7).
> **Looks are checked on real screenshots:** a windowed Godot run with a temporary capture
> script (saved under `%TEMP%`, viewed, then removed, never committed), at 1280×720 and 390×844
> unless the Step says otherwise.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **How long a hack lasts is a pure rule** in `Hacks` (`game/hacks.gd`): `DAY_SECONDS` 86400, `TIMED_SECONDS` 3 × 86400, `FOREVER` 0; `duration_seconds(hack_id)` (INFINITY `infinite_credits` and OPENSESAME `unlock_all` → `TIMED_SECONDS`, POWER22 `power22` → `FOREVER`), `is_timed(hack_id)`, `until_for(hack_id, now)` (now + duration, or `FOREVER`), `is_expired(until, now)` (`until != FOREVER and until <= now`) and `time_left_text(until, now)`: "Lasts for ever", "2 days 5 hours left", "1 day left", "5 hours left", "Less than 1 hour left" (whole hours, rounded down). A new hack is a 3-day or a for-ever hack by its entry in `duration_seconds`. The numbers are the server's `duration_seconds` (`server/src/hack_star_server/hacks.py`, 72 h or none); the game does not read them from the server because the migration (D2) and a game start without the server need them; the two must stay equal (README). | S16, S17, S18: the rules testable without a scene (architecture, *Game rules*); no server change. |
| D2 | **Save file version 3** (still written only by `GameState` through `SaveData`): `{"version": 3, "revision": n, "hacks": [{"id": "infinite_credits", "until": 1764000000}, {"id": "power22", "until": 0}], "progress": {…as version 2…}}`; `until` is the Unix time in seconds when the hack turns off, 0 for ever. `SaveData.VERSION` = 3; `to_json(hacks: Dictionary[String, int], progress, revision)`; `from_json(text, now) -> {"hacks": Dictionary[String, int], "progress": Dictionary, "revision": int}`. Reading: **versions 1 and 2** give each known hack `Hacks.until_for(id, now)` (S16: the 3 days start at the first start of this version) and their progress as today; **version 3**: known ids only, once each; a for-ever hack gets 0 whatever was saved; a timed hack needs a whole `until` > 0 and is cut to `now + duration` when it lies further ahead (an edited file or a clock set back); an already expired one is kept (`GameState` turns it off, D3); `revision` is a whole number ≥ 0, else 0; a missing, broken, non-object or newer file gives nothing, as before. | S16, S25: a spec 05 or 08 file keeps its hacks and progress; one format for the hacks with their end time. |
| D3 | **`GameState` turns hacks off by themselves:** `hack_until: Dictionary[String, int]` next to `active_hacks` (which stays the list the screens read); `clock: Callable` (default `Time.get_unix_time_from_system`, as whole seconds; tests set it). `activate_hack(id)` turns a hack on with `Hacks.until_for(id, now)`; for a 3-day hack that is already on it starts a new 3 days and returns true (S16); a for-ever hack already on changes nothing (false, as today). `expire_hacks()` removes every hack whose `until` has passed, then runs D4, saves and emits the new signal `progress_changed` when something changed. It runs in `load_saved()`, when the game comes to the front (D7), and every `EXPIRY_CHECK_SECONDS` = 30 s from a `Timer` child of `GameState` (so a hack also turns off while the game stays open on one screen). `reset_hacks()` empties both and runs D4. Home, the fighter list, the fighter screen and the hack screen connect `progress_changed` to their refresh. A hack never writes into the progress (spec 08, D4): trophies, power levels, `unlocked`, credits and skins stay when it turns off (S19). | S16, S17, S19, S22: one owner of the hacks and the file (spec 05 D5, spec 08 D4). |
| D4 | **The chosen fighter stays usable:** `GameState._keep_usable_selection()` — when `is_unlocked(selected_fighter)` is false (OPENSESAME turned off by itself or with **Turn all hacks off**), the chosen fighter becomes `SampleProgress.SELECTED_FIGHTER` when it is unlocked, else the first unlocked fighter in `Fighters.ids()` order, with its saved skin; `viewed_fighter` follows when it showed the old one. **The match keeps its fighter:** `MatchArena` stores the player's fighter and skin when the match starts and uses them at the end (`award_trophies`, `last_result`), instead of reading `GameState.selected_fighter` again; a hack turning off during a match changes nothing in it. | S22: today a locked fighter stays chosen and playable after **Turn all hacks off**, and the trophies would go to another fighter if the choice changed during a match. |
| D5 | **Time left on the hack screen:** each row of the active-hacks list reads "<name> · <time left>" (`Hacks.display_name` and `Hacks.time_left_text`, e.g. "Unlimited credits · 2 days 23 hours left", "Power 22 · Lasts for ever"); the list is refreshed when the screen opens, after a code, after **Turn all hacks off**, on `progress_changed` and once a minute while the screen is open (a `Timer`). English only (S23). No new colours or fonts: the theme of spec 04. | S18, S23; the screen sizes of spec 04 (S6). |
| D6 | **One store the browser's tabs share:** a small `SaveStore` (`game/save_store.gd`, `read() -> String`, `write(text)`) used by `GameState.load_saved()` and `save()`. On the desktop and in the tests it reads and writes `save_path` (`user://…`, as today). In the web export it uses the page's `localStorage` (key `hack_star_save`, through `JavaScriptBridge`), which every tab of the same address reads and writes at once; `user://` on the web is the browser's IndexedDB copied into each tab's memory at its start, so a tab never sees another tab's later saves. **Migration:** a web start with no `hack_star_save` key reads the old `user://hack_star_save.json` once and writes it to the key; the old file is left as it is. | S4: the reported bug 4 can happen in Godot (each tab keeps its own copy and the last to save wins). |
| D7 | **Revision, reload at the front, merge on write:** every save writes `revision` + 1 of the revision the tab last read or wrote. **Reload:** when the game comes to the front (`NOTIFICATION_APPLICATION_FOCUS_IN`, and on the web also the page's `visibilitychange` to visible through a `JavaScriptBridge` callback), `GameState.sync_from_store()` reads the store; when its revision is newer than the tab's, it lays the stored hacks and progress over the tab's state (as `load_saved`, the hacks replaced), runs D3/D4 and emits `progress_changed`. **Merge on write:** when `save()` finds a newer revision in the store (another tab wrote since this tab last read), it first merges the stored save into memory — hacks: union, with the later `until`; `unlocked`: union; trophies and power levels per fighter: the higher; credits, the chosen fighter and skins: this tab's (credits do not change with play before spec 09) — then writes. A match keeps its fighter (D4). | S4: nothing gained in one tab is lost by another, and the other tab shows it when it comes to the front; a hidden tab does not have to update. |
| D8 | **Tests:** `test_hacks.gd` or a new `test_hack_times.gd` (durations, `until_for`, `is_expired`, every `time_left_text` form); a new `test_save_data_v3.gd` (round trip with `until` and `revision`; versions 1 and 2 give each hack `now + duration` and keep their progress; a for-ever hack gets 0; an `until` too far ahead is cut; unknown ids, doubles, wrong types dropped; newer, broken → nothing); a new `test_hack_expiry.gd` (a fake clock: INFINITY and OPENSESAME off after 3 days and not before, POWER22 never; entering again starts a new 3 days; the timer and `load_saved` turn an expired hack off; `progress_changed` emitted; trophies, power levels, `unlocked`, credits and skins unchanged (S19); a fighter chosen through OPENSESAME is replaced after it turns off and after **Turn all hacks off**; a match that started with it gives it its trophies); `test_hack_screen.gd` or a new file (the rows with their time left, the refresh after the clock passes the end); `test_screen_sizes.gd` or a new file (the hack screen with three timed rows at the five sizes); a new `test_save_tabs.gd` (two `GameState` objects on one test file: a hack from one tab is kept when the other writes, and shown after the other's `sync_from_store()`; an older store revision changes nothing; the merge rules of D7; the migration of D6 with a fake web store). The two-tab check in a real browser is done in Step 4 when a browser can be driven, else it stays with the author (Deferred Items). | Every kept statement checked by a test that fails before the fix, S19 by a test of the correct behaviour, the looks by screenshots; the device play-test stays with the author (spec 03, D6). |

| D9 | **Known limitation, accepted (code review finding 1):** a hack turned off in one tab (**Turn all hacks off**) can come back when another tab, which has not synced since, saves, because D7 merges hacks as a union. Fixing it needs a per-hack removal marker (a tombstone with a time) in the save; Part 1 does not need it (S4 asks that nothing gained is lost; **Turn all hacks off** in a single tab works, and S22 holds there). Documented in the README (*Known limitation (two tabs)*) and in `docs/architecture.md`; recorded in Deferred Items. | S4 and S22 meet only with two visible windows; the simplest choice that meets Part 1 is to accept it. |
| D10 | **Scan only where it works (author's report 1):** `QrScanner.can_scan() -> bool` (static; `OS.has_feature("web")`, the only build that has the browser's camera and `web/qr_scanner.js`). The hack screen reads it once in `_ready`: without it, **Scan QR code** stays disabled (also after `_set_busy(false)`) and a new label `ScanHint` under it says "Camera scanning works in the browser version — type the code here" (English, the `MESSAGE_COLOR`, wrapped, centred); with it, nothing changes (the hint is hidden; the camera messages of spec 05 D8 stay, `not_web` included as a fallback). A test seam: the hack screen's `can_scan: bool` set from `QrScanner.can_scan()` before `_ready` reads it, so a test can show both sides. No native camera: Godot 4.7's `CameraServer` has no Windows feed, and a desktop QR decoder would be a new dependency for a run the kids do not use. | S26: the desktop run cannot scan; the web export keeps its scanner (spec 05). |
| D11 | **Space is the `shoot` action:** a new input action `shoot` in `project.godot` (physical Space). `Arena._process` fires while `Input.is_action_pressed("shoot")` (and `read_player_input`): `fire(_aim_direction())`; the cool-down in `fire_from` (`Combat.COOLDOWN`) keeps the normal rate, `fire` already refuses while `player_can_act()` is false (the match's countdown and end). `_aim_direction()` is today's `_tap_direction()` renamed and shared by the tap and Space: the nearest of `tap_targets()` in `Combat.SHOT_RANGE` (`Combat.nearest_target`; the bots still in the match in `MatchArena`, the dummies still standing in Training), else the fighter's facing (`-global_basis.z`). **Space never presses a button:** the arena's **Back** gets `focus_mode = FOCUS_NONE` (a click and a touch still press it), so `ui_accept` on Space has no focused button in the arena; the home screen's entrance skip on any key stays. Tests drive the action with `Input.action_press("shoot")` / `action_release` (or `Input.parse_input_event` of a Space key) and a test clock where needed. | S28: one way to shoot with the keyboard, the same aim as the tap. |
| D12 | **The mouse no longer shoots:** the mouse part of `Arena._unhandled_input` (`_mouse_held`, `_mouse_position`, `_fire_at_mouse`) is removed; `Combat.ground_point` (used only by the mouse) is removed with its two tests in `test_combat.gd`. The touch sticks (`TouchJoystick`, `AimJoystick`, `_on_aim_released`, the aim line) do not change. The tests that fired with a mouse click (`test_arena.gd`, `test_match_arena.gd`) become tests that a click fires nothing and that Space fires; `test_an_emulated_mouse_click_does_not_fire` stays meaningful (a click fires nothing at all). | S29; the touch controls stay as they are (S25). |
| D13 | **One source for the help texts:** a new pure `ControlsHelp` (`game/controls_help.gd`, like `Vocabulary`): `KEYBOARD_HINT` ("Move: WASD or arrow keys · Shoot: Space"), `TOUCH_HINT` ("Move: left stick · Shoot: drag or tap the right stick"), and `HOW_TO_PLAY`, a list of `{"title", "text"}` sections — *Controls* (keyboard; touch; **Back**), *Match* (last fighter standing wins; the timer, a draw when it ends; heal by not shooting and not being hit), *Training* (practise on three dummies; they come back), *Trophies and Prestige* (+10 for a win; a Prestige every 1000), *Hack codes* (**Hack** on home: type a code, or scan it in the browser version). English only (S23); the texts must stay true to `MatchSettings`, `Combat` and `Prestige` (the numbers are read from them where a number is shown). | S30, S31: the Info page and the start hint say the same; testable without a scene. |
| D14 | **"How to play" at the top of the Info page** (the smallest good option: no new screen, no new home button, the five home layouts unchanged): `info.gd` adds a heading "How to play" and one row per `ControlsHelp.HOW_TO_PLAY` section (title in the `WordLabel` style, text wrapped, as the words) before a heading "Words" and the vocabulary rows; the page title stays "Info", the home button stays **Info**. The README and the start hint (D15) point to it ("More in Info"). | S30: reachable from the home screen in one tap, readable at the five sizes with the existing scroll. |
| D15 | **Start hint in the arena HUD:** a `Label` `ControlsHint` in `arena.tscn`'s `Hud` (so Training and the match, which inherits the scene, both get it): `ControlsHelp.KEYBOARD_HINT`, plus `TOUCH_HINT` on a second line when `DisplayServer.is_touchscreen_available()` (as the sticks, `TouchJoystick._ready`), plus "More in Info"; anchored bottom-centre above the sticks' height, at most 60 % of the screen width, wrapped, `mouse_filter = IGNORE` (it never takes a click or a touch). Shown at once when the scene starts, fully visible for `HINT_SECONDS` = 5, then a tween fades it out over `HINT_FADE_SECONDS` = 1 and hides it (in a match this covers the countdown and the start of the fight; the countdown label stays in the centre). | S31: seen at every start without a setting; never in the way. |

---

## Step 1 — Timed hack rules and save file version 3

### Goal
How long each hack lasts, when it ends and the time-left text are pure rules, and the save file
keeps each hack with its end time and a revision; older files keep their hacks, which get their
3 days from the first start of this version (S16, S17, S18, S25).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `Hacks` after D1 (durations, `until_for`, `is_expired`, `time_left_text`).
- [x] `SaveData` version 3 after D2 (`to_json(hacks, progress, revision)`, `from_json(text, now)`,
      the migration of versions 1 and 2, the checks of `until` and `revision`).
- [x] Keep `GameState` working with the new `SaveData` (pass the clock's now, keep
      `active_hacks` as the list of ids; the hacks are still never turned off here — Step 2);
      update the callers and the tests of `SaveData` (`test_save_data.gd`, `test_save_data_v2.gd`).
- [x] Tests (D8): the hack time rules and `test_save_data_v3.gd`.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; a spec 08 save file (version 2) loads
      with its hacks and progress.

### Notes
Started: 2026-11-22 08:35
**Done (2026-11-22 · ~5 min · Claude Opus 5.5)** — `Hacks` has the time rules of D1 (`DAY_SECONDS`, `HOUR_SECONDS`, `TIMED_SECONDS`, `FOREVER`, `duration_seconds`, `is_timed`, `until_for`, `is_expired`, `time_left_text`); `SaveData` writes version 3 (`to_json(hacks, progress, revision)`, `from_json(text, now)`: versions 1 and 2 give each hack `until_for(id, now)`, version 3 checks ids, doubles, `until` (for ever → 0, too far ahead → cut, expired kept) and `revision`); `GameState` keeps `hack_until` next to `active_hacks`, a `clock` (`now()`), and the file's revision (+1 on each save) — hacks still never turn off (Step 2); callers and tests of `SaveData` updated; new `test_hack_times.gd` (4) and `test_save_data_v3.gd` (10). `tools/test.ps1` 357/357 passed (exit 0), `tools/lint.ps1` exit 0, `tools/check_tools.ps1` exit 0; a version 2 file loads with its hacks and progress (`test_save_data_v3`, `test_save_data_v2`, `test_game_state_save`). suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.17 M · CHF 1.02 (121 credits)

---

## Step 2 — Hacks turn off by themselves

### Goal
INFINITY and OPENSESAME turn off by themselves after 3 days (POWER22 never), entering a code
again starts a new 3 days, what was gained stays, and a fighter locked again is never the chosen
or the played one (S16, S17, S19, S22).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `GameState` after D3: `hack_until`, `clock`, `activate_hack` (a new 3 days), `expire_hacks`,
      the 30 s `Timer`, `progress_changed`; `reset_hacks` and `load_saved` updated.
- [x] `GameState._keep_usable_selection()` after D4, run after a hack turns off and after
      **Turn all hacks off**.
- [x] `MatchArena` keeps the fighter and skin it started with (D4).
- [x] Home, the fighter list and the fighter screen refresh on `progress_changed` (the ∞ and the
      locks change at once).
- [x] Tests (D8): `test_hack_expiry.gd` (with a fake clock), S19 and S22 included.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; with a fake clock 3 days ahead, home
      shows the real credits and a usable fighter (a test).

### Notes
Started: 2026-11-22 08:41
**Done (2026-11-22 · ~10 min · Claude Sonnet 5.5)** — `GameState` keeps `hack_until` and a 30 s `ExpiryTimer`; `expire_hacks()` turns off every hack whose time has passed (also in `load_saved`), keeps the chosen fighter usable (`_keep_usable_selection`: the sample fighter, else the first unlocked; the viewed fighter follows), saves and emits `progress_changed`; `activate_hack` on a timed hack that is on starts a new 3 days, a for-ever one changes nothing; `reset_hacks` also keeps the selection usable; `MatchArena` keeps the fighter and skin it started with; home, the fighter list and the fighter screen refresh on `progress_changed`; new `test_hack_expiry.gd` (13 tests, fake clock: S16, S17, S19, S22, home after 3 days, a match keeps its fighter); `test_game_state` adjusted (a timed code entered again is accepted). `tools/test.ps1` 370/370 passed (exit 0), `tools/lint.ps1` and `tools/check_tools.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.52 M · CHF 0.52 (62 credits)

---

## Step 3 — Time left on the hack screen

### Goal
The hack screen shows for each active code how long it stays on, or that it lasts for ever, in
English, and fits the five screen sizes with mouse and touch (S6, S18, S23).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `hack_screen.gd` after D5: rows "<name> · <time left>", refreshed on open, after a code,
      after **Turn all hacks off**, on `progress_changed` and once a minute.
- [x] Tests (D8): the rows and their refresh; the hack screen with three rows at the five sizes.
- [x] Look check on screenshots: the hack screen with INFINITY, OPENSESAME and POWER22 active at
      1280×720 and 390×844 (and 844×390): every row readable, nothing cut or overlapping.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-22 08:52
**Done (2026-11-22 · ~3 min · Claude Sonnet 5.5)** — Each row of the active-hacks list reads "<name> · <time left>" (`Hacks.display_name` + `Hacks.time_left_text` from `GameState.hack_until`); the list refreshes when the screen opens, after a code, after **Turn all hacks off**, on `progress_changed` and every 60 s (`RefreshTimer`). New `test_hack_time_rows.gd` (5: the rows, the minute refresh, a hack turning off, all hacks off, three rows at the five sizes); `test_hack_screen` uses a fake clock. Look checked on real windowed screenshots (INFINITY, OPENSESAME, POWER22 active, "1 day 19 hours left" the longest row) at 1280×720, 390×844 and 844×390: every row readable, centred, nothing cut or overlapping (capture code removed). `tools/test.ps1` 375/375 passed (exit 0), `tools/lint.ps1` and `tools/check_tools.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 877 k · CHF 0.11 (13 credits)

---

## Step 4 — Progress across tabs

### Goal
In the web game, a hack, trophies or a choice gained in one tab is not lost because of another
tab, and the other tab shows it when it comes back to the front (S4, S6).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/save_store.gd` after D6 (file store; web store on `localStorage`; the one-time
      migration from `user://hack_star_save.json` on the web).
- [x] `GameState` after D7: `revision`, `sync_from_store()` at the front
      (`NOTIFICATION_APPLICATION_FOCUS_IN`, and the page's `visibilitychange` on the web), the
      merge in `save()`, `progress_changed` after a reload.
- [x] Tests (D8): `test_save_tabs.gd` (two `GameState` objects on one test file; the merge rules;
      the migration with a fake web store).
- [x] Browser check, when a browser can be driven from this computer (for example Playwright):
      `tools/export_web.ps1`, `tools/serve_web.ps1` with the hack server, two tabs of the game; a
      code entered in tab 2 (or a QR link `?hack=INFINITY` opened in tab 2); a match won in
      tab 1 → tab 1 shows ∞ when it comes to the front, and both the hack and the trophies are
      there after a reload. Otherwise write in Notes that this check stays with the author
      (Deferred Items).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-22 08:54
**Done (2026-11-22 · ~25 min · Claude Opus 5.5)** — New `SaveStore` (`game/save_store.gd`): the file at `save_path` on the desktop and in the tests, `localStorage` key `hack_star_save` in the web export (through `JavaScriptBridge.get_interface`), a web start without the key copies the old `user://` file to it once and leaves the file. `GameState` reads and writes through it; `save()` merges a newer stored revision first (hacks: union with the later end, expired left out; `unlocked` union; trophies and power levels the higher; credits, choice and skins this tab's), writes revision + 1 and emits `progress_changed` after a merge; `sync_from_store()` (on `NOTIFICATION_APPLICATION_FOCUS_IN` and the page's `visibilitychange` to visible) lays a newer store over the tab, keeps the choice usable, turns expired hacks off and emits `progress_changed`. New `test_save_tabs.gd` (11: two tabs on one file, sync, older revision, merge rules, revisions, the web migration with a fake store, the file store). Browser check (Playwright, headless Chromium, `export_web.ps1` + `serve_web.ps1` + hack server): tab 1 on Home (Credits: 500), `?hack=INFINITY` opened in tab 2 → `localStorage` has `infinite_credits` (revision 1); tab 1 brought to the front shows Credits: ∞ (screenshot); after a reload of tab 1 the hack is still stored. A match won in tab 1 was not driven in the browser (the merge of trophies is covered by `test_save_tabs.gd`); that part stays with the author (Deferred Items). `tools/test.ps1` 386/386 passed (exit 0), `tools/lint.ps1`, `tools/check_tools.ps1` and `tools/export_web.ps1` exit 0. suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · 2.36 M · CHF 1.06 (127 credits)

---

## Step 5 — Final check, README and architecture

### Goal
Everything that worked before still works, all Godot checks pass, and the README and the
architecture describe the timed hacks, the time left and the progress across tabs (S6, S24,
S25, all statements).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `hack_star_godot/docs/architecture.md`: Game rules (the hack durations and texts of
      `Hacks`, `save_data.gd` version 3, `save_store.gd`), Screens (the hack screen's time left;
      `MatchArena` keeps its fighter), the `GameState` session state (`hack_until`, `clock`,
      `expire_hacks`, `progress_changed`, `sync_from_store`, the revision and the merge),
      *Saved progress* (version 3, the migration of versions 1 and 2, `localStorage` on the web
      and its migration), Tests (the new files).
- [x] `hack_star_godot/README.md`: the hack table with how long each code lasts (3 days or for
      ever; entering again starts a new 3 days; the durations equal the server's), the time left
      on the hack screen, what happens when a code turns off (what stays; locked fighters and the
      chosen fighter), the game in two tabs, and where the progress is saved on the web
      (`localStorage` of the address) and how to start fresh; the sentence "The hacks do not
      expire yet (spec 16)" removed.
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); PowerShell scripts that changed parse with
      `[System.Management.Automation.Language.Parser]::ParseFile`; `git diff --stat` of this spec
      shows nothing in `server/` or `ui/`.
- [x] Re-check the MVP flow (`tests/test_mvp_flow.gd` passes: home → hack → fighter → match →
      result → home → a fresh load) and write the result into Notes.
- [x] Note in Notes what stays with the author (Deferred Items): the device play-test (iPad and
      phone: the hack screen with the time left, touch) and, if Step 4 could not do it, the
      two-tab browser check.

### Notes
Started: 2026-11-22 09:03
**Done (2026-11-22 · ~4 min · Claude Haiku 5.5)** — Final check and documents. `hack_star_godot/README.md`: how long each code lasts (INFINITY and OPENSESAME 3 days, POWER22 for ever; entering again starts 3 days; the server's durations), the time left on the hack screen, what happens when a code turns off (what stays, locked fighters and the chosen fighter, a running match), the game in two tabs, and the save on the web (`localStorage`, key `hack_star_save`) and how to start fresh; "The hacks do not expire yet" removed. `docs/architecture.md`: `Hacks` durations and time left, `SaveData` version 3 and the migrations, the new `SaveStore`, the `GameState` session state (`hack_until`, `clock`, `expire_hacks`, `progress_changed`, `sync_from_store`, the revision and the merge), *Saved progress*, the new tests. Checks: `check_tools.ps1`, `lint.ps1` (gdlint and gdformat), `test.ps1` 386/386 passed (including `test_mvp_flow.gd`: home, hack, fighter, match, result, home, fresh load) and `export_web.ps1`, all exit 0. No PowerShell script changed; nothing in `server/` or `ui/`. Deferred: the device play-test and the match part of the two-tab check (Deferred Items). suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · 2.04 M · CHF 0.07 (8 credits)

---

## Step 6 — Scan button only where scanning works

### Goal
In the desktop run the hack screen offers no scan that can only fail: **Scan QR code** is
disabled with a hint to use the browser version or type the code; the web export scans as
before (S26, S6).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `QrScanner.can_scan()` after D10.
- [x] `hack_screen.tscn`: a `ScanHint` label under **Scan QR code**; `hack_screen.gd`: `can_scan`
      read in `_ready`, the button disabled and the hint shown without it (also after a code was
      checked, `_set_busy(false)`), the hint hidden with it.
- [x] Tests: `test_hack_screen.gd` (15 tests; or a new file if it would pass 20) — without the
      scanner the button is disabled after opening and after a code, and the hint shows the text;
      with it (`can_scan = true`) the button works and the hint is hidden; `test_qr_scanner.gd`:
      `can_scan()` is false in the headless test run.
- [x] Look check on screenshots: the hack screen of the desktop run at 1280×720, 390×844 and
      844×390 — the disabled button and the hint readable, nothing cut or overlapping.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-22 10:09
**Done (2026-11-22 · ~20 min · Claude Sonnet 5.5)** — `QrScanner.can_scan()` (static, `OS.has_feature("web")`); the hack screen reads it once into `can_scan` (settable by a test before the screen is added), disables **Scan QR code** without it (also after `_set_busy(false)`) and shows the new `ScanHint` label ("Camera scanning works in the browser version — type the code here", centred, wrapped, `MESSAGE_COLOR`); the web export is unchanged. New `test_hack_screen_scan.gd` (2 tests, a new file because `test_hack_screen.gd` is at the lint limit of 20 public methods with them) and a `can_scan()` test in `test_qr_scanner.gd`; `test_hack_time_rows.gd` now scrolls each row into view (the hint makes the phone-landscape content one line taller than the screen, which scrolls by design). Real screenshots of the windowed desktop run (temporary capture script under `%TEMP%`, not committed) at 1280×720, 390×844 and 844×390: the disabled button and the hint are readable, nothing cut or overlapping. `tools/test.ps1` 393/393 passed (exit 0), `tools/lint.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.99 M · CHF 0.56 (67 credits)

---

## Step 7 — Space shoots, the mouse no longer

### Goal
In a match and in Training, Space (pressed or held) fires at the nearest target in range or
straight ahead, a mouse click fires nothing, and touch works as before (S28, S29).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `project.godot`: the input action `shoot` (physical Space) after D11 (through the editor's
      Input Map or the same `Object(InputEventKey,…)` form as the move actions).
- [x] `scenes/arena.gd`: fire while `shoot` is held (`fire(_aim_direction())`), `_tap_direction`
      renamed `_aim_direction` and used by the tap and Space; the mouse firing removed (D12) and
      `Combat.ground_point` with its tests; the header comment updated; the arena's **Back**
      `focus_mode = FOCUS_NONE` (`arena.tscn`).
- [x] Tests (`test_arena.gd` has 18, `test_match_arena.gd` 9; a new `test_arena_space.gd` if a
      file would pass 20): Space fires at the nearest dummy in range in Training, straight ahead
      when none is in range; holding Space fires again only after `Combat.COOLDOWN`; in a match
      Space aims at the nearest bot, fires nothing during the countdown and after the end; Space
      does not press **Back** (the scene stays); a mouse click fires nothing; the touch tap and
      drag still fire (existing tests kept).
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; a short windowed run of Training
      (Space held near a dummy) shows the shots going to the dummy.

### Notes
Started: 2026-11-22 10:29
**Done (2026-11-22 · ~8 min · Claude Sonnet 5.5)** — New input action `shoot` (physical Space) in `project.godot`. `Arena._process` fires `fire(_aim_direction())` while `shoot` is held and `read_player_input` is on (the cool-down `Combat.COOLDOWN` and `player_can_act()` keep the rate and the countdown/end lock); `_tap_direction` is now `_aim_direction`, shared by the tap and Space (nearest target in range, else straight ahead). The mouse code (`_unhandled_input`, `_mouse_held`, `_mouse_position`, `_fire_at_mouse`) and `Combat.ground_point` with its two tests are removed; the header comment says the mouse does not fire; the arena's **Back** has `focus_mode = FOCUS_NONE` (a click and a touch still press it). Tests: new `test_arena_space.gd` (6: nearest dummy, straight ahead, hold and cool-down, a real Space key event, Space does not press Back, a mouse click fires nothing); `test_match_arena.gd` (countdown test now also holds Space; new test: Space at the nearest bot, nothing after the end); the three mouse-fire tests of `test_arena.gd` replaced by the Space tests; touch tap and drag tests kept. A windowed Training run (temporary capture script under `%TEMP%`, not committed) with Space held next to a dummy shows the shots hitting it (damage number on the dummy). `tools/test.ps1` 395/395 passed (exit 0), `tools/lint.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.66 M · CHF 0.46 (55 credits)

---

## Step 8 — How to play on the Info page

### Goal
The Info page, one tap from home, starts with a short "How to play" section: controls, the
goal of a match, Training, trophies and Prestige, hack codes (S30, S6, S23).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/controls_help.gd` (`ControlsHelp`) after D13.
- [x] `scenes/info.gd` after D14: the heading "How to play", one row per section, then the
      heading "Words" and the vocabulary as before.
- [x] Tests: a new `test_controls_help.gd` (every section has a title and a text; the controls
      name WASD, the arrow keys and Space, and the two sticks; the numbers shown match
      `MatchSettings`, `Prestige` and `Combat`); `test_info.gd` (3 tests): the "How to play"
      rows come first, then all the words.
- [x] Look check on screenshots: the Info page at 1280×720, 390×844 and 844×390 (top and
      scrolled) — every line readable and wrapped, nothing cut.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0 (`test_screen_sizes.gd` keeps passing
      for the Info page).

### Notes
Started: 2026-11-22 10:36
**Done (2026-11-22 · ~5 min · Claude Sonnet 5.5)** — New pure `ControlsHelp` (`game/controls_help.gd`): `KEYBOARD_HINT`, `TOUCH_HINT`, `MORE_IN_INFO` and `how_to_play()` (a function, not a constant, so the numbers are read from `Combat`, `MatchSettings`, `Prestige` and `ArenaLayout`): Controls, Match, Training, Trophies and Prestige, Hack codes. `info.gd` shows the heading "How to play", one row per section (title in the `WordLabel` style, wrapped text), the heading "Words" and the vocabulary rows as before. Tests: new `test_controls_help.gd` (3: sections with title and text, keys and sticks named, numbers equal the rules); `test_info.gd` checks the "How to play" rows first and then every word. Real screenshots of the windowed run (temporary capture script under `%TEMP%`, not committed) of the Info page at 1280×720, 390×844 and 844×390, top and scrolled to the end: every line is readable and wrapped, nothing is cut. `tools/test.ps1` 398/398 passed (exit 0; `test_screen_sizes.gd` keeps passing), `tools/lint.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.48 M · CHF 0.33 (39 credits)

---

## Step 9 — Controls hint at the start

### Goal
When Training or a match starts, a short controls hint shows and fades away by itself, without
covering the countdown or **Back** and without blocking input (S31, S6).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `arena.tscn` / `arena.gd`: the `ControlsHint` label and its fade after D15 (texts from
      `ControlsHelp`).
- [x] Tests (a new `test_controls_hint.gd`): the hint is visible at the start of Training and of
      a match with the keyboard text; after `HINT_SECONDS` + `HINT_FADE_SECONDS` it is hidden;
      it ignores the mouse (`mouse_filter`); in the match it does not overlap the countdown label
      or **Back** at the five sizes (rects); Space fires while it shows.
- [x] Look check on screenshots: Training and a match (during the countdown) at 1280×720,
      390×844 and 844×390, the hint readable and clear of the countdown, the timer, "Fighters
      left" and **Back**; one shot a few seconds later without the hint.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-22 10:41
**Done (2026-11-22 · ~5 min · Claude Sonnet 5.5)** — A `ControlsHint` label in the `Hud` of `arena.tscn` (so Training and the match): `ControlsHelp.KEYBOARD_HINT`, `TOUCH_HINT` on a second line when `DisplayServer.is_touchscreen_available()`, then "More in Info"; `HudLabel` style, 24 px, centred, 60 % of the width, wrapped, `mouse_filter = IGNORE`; shown at once, fully visible for `HINT_SECONDS` (5), faded out over `HINT_FADE_SECONDS` (1) by a tween and hidden. **Differs from D15 in one detail:** without a touch screen the hint stands at the bottom edge (offsets −128 … −24), because the first screenshots showed it covering the player's fighter at the height of the sticks; with a touch screen it stands `HINT_ABOVE_STICKS` (288) above the bottom edge, clear of the sticks, as D15 says (the touch case was not seen on a screenshot: this computer has no touch screen — Deferred Items: play-test on a device). Tests: new `test_controls_hint.gd` (4: Training shows the text, ignores the mouse and is hidden after 6 s; a match shows it over the countdown; clear of Back, FPS, countdown, timer and "Fighters left" and inside the screen at the five sizes in both scenes; Space fires while it shows). Real screenshots of the windowed run (temporary capture script under `%TEMP%`, not committed) of Training and a match during the countdown at 1280×720, 390×844 and 844×390: the hint is readable and clear of the countdown, the timer, "Fighters left" and **Back**; a match shot 6.5 s later shows no hint. `tools/test.ps1` 402/402 passed (exit 0), `tools/lint.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 2.29 M · CHF 0.32 (38 credits)

---

## Step 10 — Final check, README and architecture (author's reports)

### Goal
Everything that worked before still works, all Godot checks pass, and the README and the
architecture describe scanning, Space shooting, "How to play" and the start hint (S27, S32,
S25, S6).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `hack_star_godot/README.md`: *Controls* (Space shoots at the nearest target in range or
      straight ahead, hold to keep firing; no mouse click; touch as before; the start hint);
      *How to play a match* (Space; the "How to play" section on the Info page); *Run in the
      editor* (Info starts with "How to play"); *Hack codes* — **Scan QR code** works only in
      the browser version: on this computer open `http://localhost:8060` (`tools/serve_web.ps1`;
      the browser allows the camera on `localhost`), on a phone or iPad use `-Https`; the
      desktop run (F5, `godot --path .`) shows the hint and the code is typed (Godot 4.7 has
      no webcam on Windows).
- [x] `hack_star_godot/docs/architecture.md`: Screens (the arena's input: Space, no mouse,
      `_aim_direction`, the start hint; the hack screen's `ScanHint`; the Info page's "How to
      play"), Game rules (`ControlsHelp`; `Combat` without `ground_point`), UI foundation
      (camera and QR codes: `can_scan`), Tests (the new files).
- [x] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); PowerShell scripts that changed parse with
      `[System.Management.Automation.Language.Parser]::ParseFile`; `git diff --stat` of Steps
      6–10 shows nothing in `server/` or `ui/`.
- [x] Re-check the MVP flow (`tests/test_mvp_flow.gd` passes) and write the result into Notes.
- [x] Note in Notes what stays with the author (Deferred Items): the play-test of Space and the
      start hint on the computer, touch and the hint on an iPad and a phone, and scanning in the
      browser on `localhost`.

### Notes
Started: 2026-11-22 10:46
**Done (2026-11-22 · ~10 min · Claude Haiku 5.5)** — Final check and documents. Checks, all exit 0: `tools/check_tools.ps1` (all pinned tools OK), `tools/test.ps1` 402/402 passed (includes `tests/test_mvp_flow.gd`: home, hack, fighter, match, result, home), `tools/lint.ps1`, `tools/export_web.ps1` (`build\web\` exported). No PowerShell script changed since Step 5, and `git diff` of Steps 6–10 shows nothing in `server/` or `ui/`. `hack_star_godot/README.md`: *Controls* (Space shoots at the nearest target in range or straight ahead, hold to keep firing; the mouse does not shoot; touch as before; the start hint), *How to play a match* (Space; the Info page's "How to play"), *Run in the editor* (Info starts with "How to play"), *Hack codes* (**Scan QR code** only in the browser: `http://localhost:8060` with `tools\serve_web.ps1`, `-Https` on a phone or iPad; the desktop run shows the hint and the code is typed). `docs/architecture.md`: Screens (arena input and `ControlsHint`, match, Info's "How to play", the hack screen's `ScanHint`), Game rules (`ControlsHelp`; `Combat` without `ground_point`), UI foundation (`can_scan`), Input (Space, no mouse), Tests (the four new test files). Deferred (author, Deferred Items): the play-test of Space and the start hint on the computer, touch and the hint on an iPad and a phone, and scanning in the browser on `localhost`. suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · 2.27 M · CHF 0.04 (4 credits)

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Creating and changing a fighter with INFINITY, the new fighter at once, the creator's title and button, created fighters usable at once, prices, place in the list, one fighter without CREATOR and more with it, not enough credits, the CREATOR text, created fighters with friends, the maximum of 15, CREATOR lasting 3 days, created fighters waiting for CREATOR, the first created fighter staying (S1–S3, S7–S15, S16's CREATOR part, S20, S21) | Accounts, created fighters and CREATOR come with spec 15; moved there as its S25–S40 (S0) | [15 Accounts, fighters and languages](../2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Created fighters and their credits across tabs (S4's created-fighter part) | Created fighters come with spec 15; moved there as its S28 | [15 Accounts, fighters and languages](../2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| HYPERCHARGE lasting 3 days (S16's HYPERCHARGE part) | The HYPERCHARGE code comes with spec 12; moved there as its S11 | [12 Super and Hypercharge](../2026_11_12_12_super_and_hypercharge_spec.md) |
| Fighters and power levels bought with a code stay when it turns off (S19's bought part) | Nothing is bought before spec 09; moved there as its S13 | [09 Unlock and upgrade](../2026_11_12_09_unlock_and_upgrade_spec.md) |
| Skins bought with a code stay when it turns off (S19's bought part) | Skins are bought from spec 10; moved there as its S13 | [10 Skins shop](../2026_11_12_10_skins_shop_spec.md) |
| The merge rule for credits across tabs (D7 keeps the writing tab's credits) | Credits change with play only from spec 09; that spec decides how two tabs' credits combine | [09 Unlock and upgrade](../2026_11_12_09_unlock_and_upgrade_spec.md) |
| Translations of the new text (the time left) | English only (S23) | [15 Accounts, fighters and languages](../2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| A hack turned off in one tab can return when another tab that has not synced saves (the merge of hacks is a union, D7); needs a per-hack removal marker in the save | Known limitation, accepted (D9, code review finding 1); **Turn all hacks off** in a single tab works; documented in the README | a later spec on the save file (for example [15 Accounts, fighters and languages](../2026_11_13_15_accounts_fighters_and_languages_spec.md), accounts) |
| Play-test on a real iPad and phone (the hack screen with the time left, touch) and the part of the two-tab browser check Step 4 could not drive (a match won in tab 1, then both the hack and the trophies after a reload) | Needs a person with the devices and a browser (spec 03, D6) | the author, before the MVP pull request |
| A camera scan in the desktop run (S26) | Godot 4.7's `CameraServer` has no camera feed on Windows, and the scanner is the browser's; the desktop run shows a hint instead (D10) | none planned (a later Godot version with a Windows camera feed) |
| Play-test of the author's reports: Space and the start hint on the computer, touch and the hint on an iPad and a phone, scanning in the browser on `localhost` | Needs a person with the devices and a camera | the author, before the MVP pull request |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-22 | AI assistant (Claude Opus 5.5) | semantic diff | — | [review page](../../review/2026-11-21_godot-mvp-16-bug-fixes.html) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | diff | Approve | 0 Blocking · 3 Should-fix · 2 Nit |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | plan | re-planned | re-planned: author's bug reports (S26–S32; Steps 1–5 kept, Steps 6–10 added) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | semantic diff (Steps 6–10) | — | [review page](../../review/2026-11-22_godot-mvp-16-bug-fixes-2.html) |
| 2026-11-22 | AI assistant (Claude Opus 5.5) | diff (Steps 6–10) | Approve | 0 Blocking · 3 Should-fix · 2 Nit |

### Code review 2026-11-22

Range `235f93c..dfb85cb` (this spec's commits only: the plan commit `383f81c` and Steps 1–5).
Ran: `tools/test.ps1` (386 of 386 passed), `tools/lint.ps1` (OK); record checked with
`change_record.schema.json` (checks 7 pass · 2 n/a · 0 fail). Before | After: real screenshots of
the hack screen from a windowed Godot 4.7.2 run (temporary capture script, removed) at 1280×720
and 390×844, the before side from a temporary worktree at `235f93c` (removed); the time rules, the
save, a hack turning off, **Turn all hacks off**, the end of a match and two tabs on one save from
a temporary headless probe, the same source on both sides, with a fixed clock where the side has
one, saving under `user://review16/` (the player's save file was absent before and after); the
same probe checked finding 1. Good: the time rules are pure and the clock is replaceable, so the
3 days are tested without waiting; `GameState` stays the one owner of the hacks, the choice and
the store; a spec 05 or 08 save keeps its hacks and progress; every field of version 3 is checked
(an `until` too far ahead is cut); the match keeps its fighter; the web store sits behind a small
seam a test fakes; Step 4 drove two tabs in a real browser; nothing in `server/` or `ui/` changed.

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | A hack turned off in one tab comes back when another tab saves before it syncs: `save()` merges the newer store into this tab's memory as a union (`_merge`, `scenes/autoload/game_state.gd:259-271`), so the writing tab's own copy of the hack is written again. Probe: tab A OPENSESAME on, tab B **Turn all hacks off** (stored without it), tab A wins a match without coming to the front → the store and tab B (after `sync_from_store`) have `unlock_all` again; likewise **Turn all hacks off** in a tab whose save merges a newer store that still has the hack. S22 (turned off → locked again) meets S4 / D7 (union); it needs two visible windows (a tab syncs when it is shown). Decide, e.g. keep a hack in the merge only if this tab entered it after its last read, or accept it and say so in the README | code | spec | Should-fix | plan decision — **handled:** accepted as a known limitation (D9); in the README, `docs/architecture.md` and Deferred Items |
| 2 | The fighter screen does not show trophies that arrive from another tab: the trophies label and the Prestige badge are set once in `_ready` (`scenes/fighter_screen.gd:31-32`); `_refresh_hack_state` (43–50), connected to `progress_changed`, updates only the power and **Select**. S4 asks the other tab to show the trophies when it comes back to the front (Home and the fighter list do). Move the two lines into the refresh | code | spec | Should-fix | fix now — **handled:** the two lines moved into the refresh; test `test_trophies_and_prestige_follow_progress_from_another_tab` |
| 3 | No test for the triggers of D3 / D7: the 30 s `ExpiryTimer` of `GameState._ready` (`game_state.gd:51-56`), `NOTIFICATION_APPLICATION_FOCUS_IN` (214–216) and the `visibilitychange` callback; D8 asks "the timer and `load_saved` turn an expired hack off" — only `load_saved` and `expire_hacks()` are tested. Add a test that emits `ExpiryTimer.timeout` and one that sends the focus notification (the web callback stays with the browser check) | code | test | Should-fix | fix now — **handled:** tests for the timer (`test_hack_expiry.gd`), the focus notification and the page becoming visible or hidden (`test_save_tabs.gd`; the visibility check is the small `_page_is_visible()` that the test replaces) |
| 4 | `README.md:235` says "a skin gained in one tab" is kept when another tab saves, but the merge keeps the writing tab's skins (D7), as line 238 says ("Credits and the chosen fighter and skin come from the tab that saved last"). Drop "or a skin" from line 235 | architecture | docs | Nit | fix now — **handled** |
| 5 | Definition of Done: the *Implementation* line is not ticked although all five Steps are ✅ Done and Step 5 ran `tools/check_tools.ps1`, `test.ps1`, `lint.ps1` and `export_web.ps1` (exit 0) and updated README and architecture | spec | docs | Nit | fix now — **handled** |

**Outcome:** Approve — no Blocking finding; findings 2–5 to fix now, 1 needs a plan decision
(runner) before `CLOSE:`.

### Code review 2026-11-22 (author's reports, Steps 6–10)

Range `e175dfe..ccf39a1` (this run's commits only: the plan commit `33fc2c7` and Steps 6–10).
Ran: `tools/test.ps1` (402 of 402 passed), `tools/lint.ps1` (OK); record checked with
`change_record.schema.json` (checks 6 pass · 3 n/a · 0 fail). Before | After: real screenshots of
the hack screen, the Info page and Training at the start from a windowed Godot 4.7.2 run
(temporary capture script, removed) at 1280×720 and 390×844, the before side from a temporary
worktree at `e175dfe` (removed); Space, a left click and **Back**'s focus in Training from a
temporary headless probe, the same source on both sides, saving under `user://review16b/` (never
the player's file). Good: every report became a statement and a Step with a test that fails
before the change; the scan rule is one static check with a test seam (`can_scan`); Space reuses
the tap's aim, the cool-down and the countdown lock, so no rule was added; the mouse code and
`Combat.ground_point` were removed with their tests instead of being left unused; the help texts
read their numbers from the rules and a test keeps them equal; the deviations (the hint's place
without a touch screen, `how_to_play()` as a function) are explained in the Step Notes; nothing in
`server/` or `ui/` and no PowerShell script changed.

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | `docs/architecture.md:322` — Step 10 replaced the description of `test_save_tabs.gd` (two tabs on one save: the merge of hacks, trophies and unlocks, the revision, the sync at the front, the web migration with a fake `localStorage`, `SaveStore` as a file) with the four new test files instead of adding them, so the first round's two-tab tests are no longer documented, and the sentence now runs "…the time left on the hack screen; The controls and the help…". Restore the `test_save_tabs.gd` clause and start the new sentence properly | architecture | docs | Should-fix | fix now — **handled:** restored the test_save_tabs.gd clause in architecture.md |
| 2 | The Stage log is broken: the rows of Steps 6–10 were written with six lone CR line breaks, and `---` plus `## Cost summary` were glued onto the Step 8 and the Step 10 rows (twice). Markdown reads a lone CR as a line end, so the table ends after the Step 8 row, the Step 9 and 10 rows (and the review row below them) render as plain text and the Cost summary heading is gone. Rewrite the rows with CRLF and keep one `---` and one `## Cost summary` below the table | spec | docs | Should-fix | fix now — **handled:** the rows rewritten with CRLF, one separator and one Cost summary heading |
| 3 | The touch branch of the start hint has no test and was not seen: `scenes/arena.gd:80-84` (the `TOUCH_HINT` line, `HINT_ABOVE_STICKS` 288 and the label height `104.0` written in code) runs only when `DisplayServer.is_touchscreen_available()`, which the tests cannot fake, so S31's "on a touch screen: the two sticks" and "covers neither the countdown" are unchecked where the kids play. At 844×390 the touch hint spans y 258–362 of the 650-high content and the countdown 135–255 (3 px apart); a wrapped fourth line grows it upwards into the countdown. Add a seam like `can_scan` (e.g. `touch_controls`, read in `_ready`) and run the five-size test of `test_controls_hint.gd` with it | code | test | Should-fix | fix now — **handled:** touch_controls seam in Arena; the five-size test runs with it; the touch hint names only the sticks, is two lines and grows upwards to its text |
| 4 | In phone portrait (390×844) the keyboard hint wraps as "Move: WASD or arrow keys ·" / "Shoot: Space" (record block controls-hint), leaving the separator at the end of a line; e.g. put the two parts on their own lines in the hint | code | guideline | Nit | fix now — **handled:** the keyboard and touch hints put Move and Shoot on their own lines |
| 5 | Definition of Done: the *Implementation* line is still unticked with "(Steps 1–5 done; reopened for Steps 6–10)" although Steps 6–10 are ✅ Done and Step 10 ran `check_tools.ps1`, `test.ps1` (402/402), `lint.ps1` and `export_web.ps1` (exit 0) and updated README and architecture | spec | docs | Nit | fix now — **handled:** Implementation ticked |

**Outcome:** Approve — no Blocking finding; findings 1–5 to fix now (no plan decision needed) — **all fixed** in Fix review findings (#33).

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked; `tools/test.ps1`, `tools/lint.ps1`, `tools/check_tools.ps1` and `tools/export_web.ps1` pass; `hack_star_godot/README.md` / `docs/architecture.md` updated _(Steps 1–5 done; reopened for Steps 6–10, done; review findings fixed)_
- [x] Review · review page written; no Blocking finding open _(first review; Steps 6–10: [review page](../../review/2026-11-22_godot-mvp-16-bug-fixes-2.html), Approve, 0 Blocking)_
- [x] Spec closed · moved to `hack_star_godot/.specs/features/done/` _(reopened in place 2026-11-22, closed again on feature/godot-mvp)_
- [ ] Pull request · one pull request for the whole MVP branch at the end (not per spec)
