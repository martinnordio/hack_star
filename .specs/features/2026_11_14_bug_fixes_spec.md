# Bug Fixes Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/bug-fixes`
> **Issue:** #17

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written: bug 1 (creating a fighter with INFINITY); revised: report details (desktop, typed code, 0 C), created fighter usable at once (S7, S8 replace S5); card after the unlocked fighters (S9), tabs update when back in front (S4); CREATOR now allows more created fighters (S10–S14); codes expire after 3 days, POWER22 for ever, 500 C and max 15 (S15–S21); OPENSESAME, re-entering and existing codes (S16, S22); no open questions |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | clarified: only additional created fighters become inactive when CREATOR expires (S20–S21) |
| 2026-11-14 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #17 created |
| 2026-11-14 | plan | `PLAN:` | GPT-6 Luna | Part 2 written |
| 2026-11-14 | implementation | `IMPLEMENT:` | GPT-6 Luna | Step 1 done |

---

# Part 1 · Requirements

## Context

This spec collects the bugs that players report (mostly Mattia and his friends) so they are fixed
together in one branch. Each reported bug gets its own group of statements below; new bugs are
added with `REQUIREMENTS: 2026_11_14_bug_fixes_spec.md — <bug>` until the plan is written.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- Created fighter, its price and lock — spec
  [2026_11_13_accounts_fighters_and_languages_spec.md](done/2026_11_13_accounts_fighters_and_languages_spec.md):
  creating is free the first time, every change costs 500 C, only the CREATOR code unlocks it.
  Code: `ui/src/lib/created.ts` (`createCost`, `saveCreated`), `ui/src/lib/CreatorScreen.svelte`,
  `ui/src/lib/FighterList.svelte` (the "Create a fighter" card), `ui/src/App.svelte` (screen title).
- INFINITY (unlimited credits): `ui/src/lib/hacks.ts` (`credits` returns `Infinity`),
  `ui/src/lib/game/economy.ts` (`pay` does not take credits). Unit tests already cover
  "INFINITY makes changing free" (`ui/src/lib/created.test.ts`).
- Progress is saved per account in the browser (`ui/src/lib/accounts.ts`): each open tab keeps
  its own copy in memory and writes the whole save on every change.

**What was found while checking bug 1** (2026-11-14, headless browser on the dev server):
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
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |
| [architecture.md](../../docs/architecture.md) | How the code is organised |
| [README](../../README.md) | How to install, run and play |

## 1 · Specs

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
  [2026_11_13_accounts_fighters_and_languages_spec.md](done/2026_11_13_accounts_fighters_and_languages_spec.md).
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

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Timed hack state and expiry rules | ✅ Done | [→ Step 1](#step-1--timed-hack-state-and-expiry-rules) |
| **2** | Created-fighter data and compatibility | ✅ Done | [→ Step 2](#step-2--created-fighter-data-and-compatibility) |
| **3** | Create, select and manage multiple fighters | ✅ Done | [→ Step 3](#step-3--create-select-and-manage-multiple-fighters) |
| **4** | Created fighters in shared rooms | ✅ Done | [→ Step 4](#step-4--created-fighters-in-shared-rooms) |
| **5** | Keep browser tabs in sync | ⬜ Not started | [→ Step 5](#step-5--keep-browser-tabs-in-sync) |
| **6** | Show hack status and time remaining | ⬜ Not started | [→ Step 6](#step-6--show-hack-status-and-time-remaining) |
| **7** | Full regression checks and documentation | ⬜ Not started | [→ Step 7](#step-7--full-regression-checks-and-documentation) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records the
> finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Store each timed hack's expiry in the account's saved progress; represent permanent hacks separately from timed ones. | Expiry follows the account across reloads without adding server-side player accounts. |
| D2 | Treat three days as 72 hours; redeeming an active timed code resets its expiry to 72 hours from that redemption. | This gives the stated re-entry behavior a clear, testable clock rule. |
| D3 | Migrate the current single `createdFighter` into a collection while preserving its existing fighter id and progress; assign stable distinct ids to added fighters. | Existing saves keep their first fighter's trophies, power, skins and selection, while extra fighters can have independent progress. |
| D4 | Keep game progress and code expiry in browser localStorage; synchronize tabs from the same origin and refresh a stale tab when it becomes visible. | Accounts are currently device-local; this fixes stale tabs without introducing online accounts or a dependency. |
| D5 | Extend the existing room member message with a stable created-fighter id, name and look; keep accepting the current `custom` id for older clients. | Friends' browsers need the fighter's appearance without requiring the server to store player saves. |
| D6 | Keep hack duration metadata with the existing server hack definitions and return it through the existing API. | The API remains the source of which code is timed versus permanent, including future codes. |
| D7 | Do not add a package. | Existing localStorage, Svelte stores, FastAPI models and test frameworks cover this behavior. |

---

## Step 1 — Timed hack state and expiry rules

### Goal
Make temporary and permanent hack behavior persist correctly and expire predictably (S16, S17, S19, S22).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Add duration metadata to the server's hack definitions and API response: 72 hours for INFINITY, OPENSESAME, HYPERCHARGE and CREATOR; permanent for POWER22.
- [x] Persist timed-code expiry per account; refresh an active code to 72 hours from each successful re-entry, and keep permanent codes without an expiry.
- [x] Migrate existing progress so previously active timed codes receive 72 hours from the first load after this version is installed; preserve purchased fighters, skins and power levels.
- [x] Derive active hack effects from current time so expired codes stop affecting credits, unlocks, power and Hypercharge; ensure OPENSESAME does not leave unpurchased fighters unlocked.
- [x] Add focused tests for expiry boundaries, re-entry, permanent POWER22, legacy progress migration and retained purchases; check with `cd ui; npm test` and `cd server; uv run --no-sync pytest`.

### Notes
Started: 2026-11-14 09:56
**Done (2026-11-14 · ~5m · GPT-6 Luna)** — Added server hack durations, v5 expiry persistence/migration and expiry-aware effects. UI tests 228/228, `npm run check` clean, server tests 39/39.
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
### Goal
Replace the one-fighter save model with a collection and retain existing saves and first-fighter behavior (S1, S7, S8, S10, S20, S21).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Migrate the saved single fighter to the first item in the collection, preserving its id and all trophy, power, skin and selected-fighter records.
- [x] Add pure helpers for identifying each created fighter, its look, whether it is usable, and resolving the current fighter when a selected extra fighter becomes inactive.
- [x] Preserve the first fighter's free creation and availability without CREATOR; preserve the 500 C edit price and make INFINITY pay nothing.
- [x] Add tests for old-save migration, first-fighter selection, editing without losing progress, INFINITY at 0 C, and extra-fighter inactivity when CREATOR expires.
- [x] Verify `cd ui; npm test` and `cd ui; npm run check`.

### Notes
Started: 2026-11-14 10:07
**Done (2026-11-14 · ~5m · GPT-6 Luna)** — Migrated v5 saves to the v6 created-fighter collection, preserved first-fighter progress and usability, and added expiry-aware extra-fighter behavior. UI tests 231/231; `npm run check` clean.
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 3 — Create, select and manage multiple fighters

### Goal
Let players create and manage up to 15 individual fighters, with the right availability, cost, order and feedback (S2, S3, S6, S9–S13, S15, S20, S21).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Extend the creator to create an additional fighter only while CREATOR is active; charge 500 C per extra fighter, or 0 with INFINITY, and refuse creation at insufficient credits or the 15-fighter limit.
- [x] Let players open and edit a specific created fighter; retain its own look, trophies and power, and show a useful message when an extra fighter is inactive because CREATOR expired.
- [x] Refresh the Fighters screen immediately after create; order created fighters after the last unlocked standard fighter and before locked standard fighters; place the create card according to CREATOR and the 15-fighter limit.
- [x] Ensure created fighters are selectable while usable, fall back to another usable fighter if an inactive one was selected, and show the selection in Home, matches and Training.
- [x] Update CREATOR descriptions and all new UI messages in English, German, Swiss German, Spanish and Italian.
- [x] Add UI/domain tests for create, edit, ordering, max count, insufficient funds, hack states and title/button agreement; verify `cd ui; npm test` and `cd ui; npm run check`.
- [x] Check create/select/edit and expiry feedback in the browser at desktop, iPad and phone sizes.

### Notes
Started: 2026-11-14 10:12
**Done (2026-11-14 · ~2h · GPT-6 Luna)** — Added multi-fighter creation/editing with CREATOR gating, 500 C pricing, 15-fighter limit, ordering, inactive-state fallback and five-language copy. UI tests 236/236; `npm run check` clean; browser flow verified at desktop, tablet and phone widths without horizontal overflow.
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 4 — Created fighters in shared rooms

### Goal
Transmit each created fighter's identity and appearance so friends see the selected fighter correctly (S6, S14).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Include the stable created-fighter id, name and encoded look in room member data; continue to accept the existing `custom` member shape.
- [x] Update server validation and match setup to accept distinct created-fighter ids and derive their type from the encoded look.
- [x] Add UI and server tests covering two different created fighters in one room, the legacy `custom` id, malformed looks and the propagated display name.
- [x] Verify `cd ui; npm test`, `cd ui; npm run check`, and `cd server; uv run --no-sync pytest`; check a shared match in the browser.

### Notes
Started: 2026-11-14 12:10
**Done (2026-11-14 · ~15m · GPT-6 Luna)** — Added stable created-fighter room IDs, names and encoded looks; retained legacy `custom` support. UI tests 238/238, type check clean, server tests 41/41; browser confirmed two created fighters joining the same live match.
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — Keep browser tabs in sync

### Goal
Prevent stale tabs from losing account progress and refresh them when they become active again (S4).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Synchronize account-store state when another same-origin tab writes the saved accounts.
- [ ] Reconcile the latest saved account state before a stale tab writes, and refresh from storage when the tab becomes visible; keep account selection and progress scoped correctly.
- [ ] Add tests using two account stores over shared storage to verify that hacks, credits and created fighters are retained and become visible when switching back to a tab.
- [ ] Verify `cd ui; npm test` and `cd ui; npm run check`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 6 — Show hack status and time remaining

### Goal
Show players whether each active hack is permanent or when it expires (S6, S13, S16–S18).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Show remaining time for timed hacks in days and hours, and a clear permanent status for POWER22; remove expired codes from the active list.
- [ ] Refresh displayed time at least once per hour while the Hack screen is open, when the page becomes visible, and as the expiry boundary is reached.
- [ ] Translate all new status labels and update the CREATOR description on the hack screen and printable QR page in all five languages.
- [ ] Add tests for permanent, active, expiring and expired display states; verify `cd ui; npm test` and `cd ui; npm run check`.
- [ ] Check the hack list, reset flow, typed code and scanned-code flow in the browser at desktop and phone sizes.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 7 — Full regression checks and documentation

### Goal
Verify all requirements together and document the new save, code-expiry and multiplayer behavior (S1–S22).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Run the full UI suite, type check and production build: `cd ui; npm test`, `cd ui; npm run check`, `cd ui; npm run build`.
- [ ] Run all server tests: `cd server; uv run --no-sync pytest`.
- [ ] Check migration from an existing save, INFINITY with 0 C, create/edit and 15-fighter limit, code expiry and re-entry, OPENSESAME relocking, two-tab refresh, and a shared match with created fighters.
- [ ] Check key flows at desktop, iPad and phone sizes with mouse and touch; confirm existing single-player, shop, account and room behavior still works.
- [ ] Update the README and `docs/architecture.md` with the revised creator, save migration, expiry rules and room-member data.
- [ ] Verify the final diff and rerun any focused test affected by documentation or integration fixes.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|-------------|
| _None._ | _All requested behavior is included in this spec._ | _—_ |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| _YYYY-MM-DD_ | _AI assistant (model) / person_ | _requirements / plan / diff_ | _Approve / Request changes_ | _notes_ |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..Sn testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- [ ] Review · review page and semantic diff written; code review without Blocking findings
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
