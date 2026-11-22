# Bug Fixes Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-22
> **Branch:** `feature/godot-mvp`
> **Issue:** #33
> **Moved from:** [2026_11_14_bug_fixes_spec.md](../../../.specs/features/done/2026_11_14_bug_fixes_spec.md) (#17)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_14_bug_fixes_spec.md (requirements only) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked against specs 01–08; S4, S6, S16, S22 revised; S1–S3, S7–S15, S20, S21 moved to spec 15 (S16's CREATOR part too, its HYPERCHARGE part to spec 12, S19's bought things to specs 09 and 10, added there at the end of Part 1); S19 correct by design (a test); S23 (English), S24 (documentation, Godot), S25 (what worked before) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-22 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #33 created (no parent) |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 4.12 M (216 k in · 3.86 M cached · 43 k out) | CHF 2.27 (271 credits) | Part 2 written (5 Steps: reasoning, standard, standard, reasoning, light); also the requirements revision, the moved statements in specs 09, 10, 12 and 15, and the issue (`usage.ps1 -AgentName s16-lead` from 08:20:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.17 M (69 k in · 2.08 M cached · 23 k out) | CHF 1.02 (121 credits) | Step 1 done (`usage.ps1 -AgentName s16-step1` from 08:20:24) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 2.52 M (71 k in · 2.43 M cached · 20 k out) | CHF 0.52 (62 credits) | Step 2 done (`usage.ps1 -AgentName s16-steps2-3` from 08:41) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 877 k (7 k in · 867 k cached · 2 k out) | CHF 0.11 (13 credits) | Step 3 done (`usage.ps1 -AgentName s16-steps2-3` from 08:52) |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 2.36 M (69 k in · 2.26 M cached · 23 k out) | CHF 1.06 (127 credits) | Step 4 done (`usage.ps1 -AgentName s16-step4` from 08:54) |
---

# Part 1 · Requirements

## Context

This spec collects the bugs that players report (mostly Mattia and his friends) so they are fixed
together in one branch. Each reported bug gets its own group of statements below; new bugs are
added with `REQUIREMENTS: 2026_11_14_16_bug_fixes_spec.md — <bug>` until the plan is written.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_14_bug_fixes_spec.md) (#17).
- [Accounts, fighters and languages spec](2026_11_13_15_accounts_fighters_and_languages_spec.md) —
  the created fighter, its price and its lock: creating is free the first time, every change
  costs 500 C, only the CREATOR code unlocks it.
- [Hack codes spec](done/2026_11_12_05_hack_codes_spec.md) and
  [unlock and upgrade spec](2026_11_12_09_unlock_and_upgrade_spec.md) — INFINITY (unlimited
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

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

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
  [2026_11_13_15_accounts_fighters_and_languages_spec.md](2026_11_13_15_accounts_fighters_and_languages_spec.md).~~
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
  [spec 15](2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-22: the
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

### Open questions

_None. The S0 check 2026-11-22 raised no new question: the statements kept take the spec's own
wording; the moved statements keep the spec's answers for spec 15 (CREATOR, prices, the
maximum of 15)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Timed hack rules and save file version 3 | reasoning (Claude Opus 5.5) — a new saved format with a migration that starts the 3 days, checks of every field and a clock (D1, D2) | ✅ Done | [→ Step 1](#step-1--timed-hack-rules-and-save-file-version-3) |
| **2** | Hacks turn off by themselves | standard (Claude Sonnet 5.5) — `GameState` keeps the end times, checks them and keeps the chosen fighter usable; the match keeps its fighter (D3, D4) | ✅ Done | [→ Step 2](#step-2--hacks-turn-off-by-themselves) |
| **3** | Time left on the hack screen | standard (Claude Sonnet 5.5) — one text per row of an existing screen, refreshed, checked on screenshots (D5) | ✅ Done | [→ Step 3](#step-3--time-left-on-the-hack-screen) |
| **4** | Progress across tabs | reasoning (Claude Opus 5.5) — a storage shared by the browser's tabs, a revision, reloading at the front and merging on write (D6, D7) | ✅ Done | [→ Step 4](#step-4--progress-across-tabs) |
| **5** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks and updating two documents | ⬜ Not started | [→ Step 5](#step-5--final-check-readme-and-architecture) |

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
> `hack_star_godot/.specs/guidelines/gdscript.md` ([AGENTS.md](../../../AGENTS.md)). Each
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
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/docs/architecture.md`: Game rules (the hack durations and texts of
      `Hacks`, `save_data.gd` version 3, `save_store.gd`), Screens (the hack screen's time left;
      `MatchArena` keeps its fighter), the `GameState` session state (`hack_until`, `clock`,
      `expire_hacks`, `progress_changed`, `sync_from_store`, the revision and the merge),
      *Saved progress* (version 3, the migration of versions 1 and 2, `localStorage` on the web
      and its migration), Tests (the new files).
- [ ] `hack_star_godot/README.md`: the hack table with how long each code lasts (3 days or for
      ever; entering again starts a new 3 days; the durations equal the server's), the time left
      on the hack screen, what happens when a code turns off (what stays; locked fighters and the
      chosen fighter), the game in two tabs, and where the progress is saved on the web
      (`localStorage` of the address) and how to start fresh; the sentence "The hacks do not
      expire yet (spec 16)" removed.
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); PowerShell scripts that changed parse with
      `[System.Management.Automation.Language.Parser]::ParseFile`; `git diff --stat` of this spec
      shows nothing in `server/` or `ui/`.
- [ ] Re-check the MVP flow (`tests/test_mvp_flow.gd` passes: home → hack → fighter → match →
      result → home → a fresh load) and write the result into Notes.
- [ ] Note in Notes what stays with the author (Deferred Items): the device play-test (iPad and
      phone: the hack screen with the time left, touch) and, if Step 4 could not do it, the
      two-tab browser check.

### Notes
_Add the `Done` line here when the Step is finished._

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Creating and changing a fighter with INFINITY, the new fighter at once, the creator's title and button, created fighters usable at once, prices, place in the list, one fighter without CREATOR and more with it, not enough credits, the CREATOR text, created fighters with friends, the maximum of 15, CREATOR lasting 3 days, created fighters waiting for CREATOR, the first created fighter staying (S1–S3, S7–S15, S16's CREATOR part, S20, S21) | Accounts, created fighters and CREATOR come with spec 15; moved there as its S25–S40 (S0) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Created fighters and their credits across tabs (S4's created-fighter part) | Created fighters come with spec 15; moved there as its S28 | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| HYPERCHARGE lasting 3 days (S16's HYPERCHARGE part) | The HYPERCHARGE code comes with spec 12; moved there as its S11 | [12 Super and Hypercharge](2026_11_12_12_super_and_hypercharge_spec.md) |
| Fighters and power levels bought with a code stay when it turns off (S19's bought part) | Nothing is bought before spec 09; moved there as its S13 | [09 Unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) |
| Skins bought with a code stay when it turns off (S19's bought part) | Skins are bought from spec 10; moved there as its S13 | [10 Skins shop](2026_11_12_10_skins_shop_spec.md) |
| The merge rule for credits across tabs (D7 keeps the writing tab's credits) | Credits change with play only from spec 09; that spec decides how two tabs' credits combine | [09 Unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) |
| Translations of the new text (the time left) | English only (S23) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Play-test on a real iPad and phone (the hack screen with the time left, touch) and the part of the two-tab browser check Step 4 could not drive (a match won in tab 1, then both the hack and the trophies after a reload) | Needs a person with the devices and a browser (spec 03, D6) | the author, before the MVP pull request |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked; `tools/test.ps1`, `tools/lint.ps1`, `tools/check_tools.ps1` and `tools/export_web.ps1` pass; `hack_star_godot/README.md` / `docs/architecture.md` updated
- [ ] Review · review page written; no Blocking finding open
- [ ] Spec closed · moved to `hack_star_godot/.specs/features/done/`
- [ ] Pull request · one pull request for the whole MVP branch at the end (not per spec)
