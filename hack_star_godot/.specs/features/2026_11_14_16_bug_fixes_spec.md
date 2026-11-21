# Bug Fixes Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/bug-fixes`
> **Moved from:** [2026_11_14_bug_fixes_spec.md](../../../.specs/features/done/2026_11_14_bug_fixes_spec.md) (#17)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_14_bug_fixes_spec.md (requirements only) |

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
- [Hack codes spec](2026_11_12_05_hack_codes_spec.md) and
  [unlock and upgrade spec](2026_11_12_09_unlock_and_upgrade_spec.md) — INFINITY (unlimited
  credits: paying does not take credits).
- Progress is saved per account (spec 15): in the Python game each open browser tab kept its
  own copy in memory and wrote the whole save on every change.

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
- Fixes for the bugs below, each with a test that fails before the fix.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |
| `hack_star_godot/docs/architecture.md` | How the Godot game is organised (spec 03) |
| [README](../../README.md) | How to open, run, test and export the Godot game |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–15) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. For each bug: can it happen in the Godot game?
  If not, the statement describes the correct behaviour so it is still tested, not a fix.

### Bug 1 — "INFINITY is on, but I cannot create a fighter"

Reported 2026-11-14: after entering INFINITY, creating a new fighter says there are not enough
credits, although the ∞ is shown. Details: on a desktop browser, INFINITY was typed (not scanned)
by an account with 0 C. Trying again later, creating worked, so the first failure is not
reproduced; but the created fighter did not appear as a normal fighter to select, and it could
not be played.

- **S1 — Free with INFINITY:** While INFINITY is active, creating a fighter and saving changes to
  it never show "Need … more C"; the button shows "free" and the save works, whatever the
  saved credit count is (including 0).
- **S2 — New fighter shows at once:** Right after **Create**, the Fighters screen shows the new
  fighter's card and no longer shows the "Create a fighter" card, without reloading the page.
- **S3 — Creator screen agrees with itself:** The creator shows "Create a fighter" with a free
  **Create** button only when the account has no created fighter; otherwise it shows "Change
  your fighter" with **Save changes** and its price. Title and button never disagree.
- **S4 — Hacks and progress across tabs:** When the game is open in two tabs on the same device
  (for example a hack QR code opened in a new tab), a hack, credits or a created fighter gained
  in one tab is not lost because of the other tab, and the other tab shows it at the latest when
  it comes back to the front (it does not have to update while hidden).
- ~~**S5 — Same rules as before:** Without INFINITY, the first creation stays free and every
  change costs 500 C; only the CREATOR code unlocks the created fighter.~~ (removed: the created
  fighter is now usable at once — see S7 and S8)
- **S6 — Devices:** S1–S4 and S7–S22 work on desktop, iPad and phone, with touch and with mouse.
- **S7 — Created fighter is usable at once:** Right after it is created, the created fighter has no
  lock: its card in the Fighters list looks like the other unlocked fighters, it can be selected,
  then shows on the Home screen and is played in matches, Training and with friends — no hack
  code needed. This changes S10/S11 of
  [2026_11_13_15_accounts_fighters_and_languages_spec.md](2026_11_13_15_accounts_fighters_and_languages_spec.md).
- **S8 — Prices stay:** Without INFINITY, the first creation stays free and every change costs
  500 C; the created fighter keeps its trophies and power level when it is changed.
- **S9 — Place in the list:** In the Fighters list, the created fighter's card comes right after
  the last unlocked fighter and before the locked ones (with 3 unlocked fighters, it is the 4th
  card).
- **S10 — One fighter without CREATOR:** Without the CREATOR code, an account can create one
  fighter; once it exists, the "Create a fighter" card is gone and only **Change** is offered.
- **S11 — More fighters with CREATOR:** With the CREATOR code active, the "Create a fighter" card
  stays in the Fighters list, and each extra fighter created costs credits (free with INFINITY).
  Every created fighter has its own name, look, trophies and power level, is usable at once (S7),
  and can be changed on its own (S8).
- **S12 — Not enough credits:** Without enough credits for an extra fighter, the creator says how
  many credits are missing and nothing is created.
- **S13 — Code text:** In the hack list and on the printable QR page, CREATOR says it lets you create
  more fighters (in all five languages), no longer that it unlocks the created fighter.
- **S14 — Playing with friends:** Each created fighter looks the same on friends' devices as on the
  player's own device.

### Hack codes that expire

Added 2026-11-14 together with the CREATOR change.

- **S15 — Price and maximum:** Each extra created fighter costs 500 C (free with INFINITY). An
  account has at most 15 created fighters; at 15, the "Create a fighter" card is not shown.
- **S16 — Codes last 3 days:** INFINITY, OPENSESAME, HYPERCHARGE and CREATOR stay active for 3 days
  after they are entered, then turn off by themselves. Entering a 3-day code again while it is
  active starts a new 3 days. Codes already active when this version first opens get their 3 days
  from that moment.
- **S17 — Codes that last for ever:** POWER22 never turns off. Each code is either a 3-day code or
  a for-ever code, so future codes can be either.
- **S18 — Time left:** The hack screen shows, for each active code, how long it stays active (days
  and hours) or that it lasts for ever.
- **S19 — What you did stays:** What was bought, upgraded or changed while a code was active stays
  after the code turns off (skins, power levels, changes to fighters), except S20 and S22.
- **S20 — Created fighters wait for CREATOR:** When CREATOR turns off, the extra created fighters
  (all but the first) stay in the Fighters list, keep their trophies and power, but cannot be
  selected, played or changed; their card and detail say they are active again when the CREATOR
  code is entered. Entering CREATOR again makes them usable and changeable. If one of them was
  selected, the Home screen shows another usable fighter.
- **S21 — First created fighter stays:** The first created fighter (S10), created without CREATOR,
  stays usable whether CREATOR is active or not; only additional created fighters become inactive
  when CREATOR expires (S20).
- **S22 — OPENSESAME is not for ever:** When OPENSESAME turns off, the fighters that were not bought
  are locked again, as today; bought fighters stay unlocked.

### Open questions

_None. More reported bugs can still be added with `REQUIREMENTS:` before the plan is written._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
