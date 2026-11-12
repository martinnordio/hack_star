# Hack Codes Spec

> **Author:** Martin Nordio
> **Status:** 🟨 In progress
> **Created:** 2026-11-12
> **Last updated:** 2026-11-12
> **Branch:** `feature/hack-codes`

---

# Part 1 · Requirements

## Context

Hack codes are what makes Hack star different from Brawl Stars: by typing a secret code or
scanning a QR code, a player gets unlimited credits, all fighters unlocked, and power levels up
to 22 instead of 11. This is F2 in the
[MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) and the "hack codes" part
of [overall_req.md](../overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- [MVP and architecture spec](done/2026_11_12_mvp_and_architecture_spec.md) — S1–S3 (browser,
  screens, input) and S9 (progress kept on the device) apply here.
- [Basic UI spec](done/2026_11_12_basic_ui_spec.md) — credits on the home screen (S1), fighter list
  with locks and power levels (S4), the fighter screen with skins (S7); progress already has
  `activeHacks` (`ui/src/lib/progress.ts`).

**New:**
- A hack screen to enter or scan codes, and the three hack effects.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S1 — Hack screen:** A **Hack** button, always visible on the home screen, opens a screen
  where the player can type a code or scan a QR code.
- **S2 — Type a code:** A typed code is accepted with uppercase or lowercase letters and
  surrounding spaces.
- **S3 — Scan a QR code:** On a device with a camera, the player can scan a QR code that
  contains a hack code, and it works exactly like typing it. If the camera cannot be used
  (no camera or permission refused), the screen says so and typing still works.
- **S4 — Unlimited credits:** The "unlimited credits" code shows credits as ∞ and lets the
  player unlock things without credits going down.
- **S5 — Unlock all:** The "unlock all" code unlocks every fighter and every skin.
- **S6 — 22 power levels:** The "power 22" code raises the maximum power level of every
  fighter from 11 to 22, and the fighter list shows the new levels.
- **S7 — Feedback:** A correct code shows a celebration animation and the name of what it
  unlocked; a wrong code shows "Unknown code" and changes nothing.
- **S8 — Active hacks:** The hack screen lists the hacks that are active, and hacks stay
  active after the browser is closed and opened again.
- **S9 — Reset:** The player can turn all hacks off from the hack screen, after confirming;
  the game goes back to the normal rules.
- **S10 — Printable QR codes:** An adult can get the QR code of each hack code as an image to
  print or show on another screen.
- **S11 — The codes:** `INFINITY` gives unlimited credits (S4), `OPENSESAME` unlocks all
  (S5), `POWER22` gives 22 power levels (S6).
- **S12 — Power 22 for now:** Until power levels affect matches (F6), the power-22 hack
  changes only what the fighter list and fighter screen show.

### Open questions

_None. Answered 2026-11-12: the game invents the codes (S11); the Hack button is visible (S1);
power 22 is shown only until F6 (S12)._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Hack catalogue and rules | ✅ Done | [→ Step 1](#step-1--hack-catalogue-and-rules) |
| **2** | Hack screen and effects | ✅ Done | [→ Step 2](#step-2--hack-screen-and-effects) |
| **3** | QR codes: scan and print | ⬜ Not started | [→ Step 3](#step-3--qr-codes-scan-and-print) |
| **4** | Final check | ⬜ Not started | [→ Step 4](#step-4--final-check) |

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
| D1 | The server checks codes: `POST /api/hacks/redeem` returns the hack or 404; `GET /api/hacks` lists them for the QR page | The codes are not in the UI code; one place to add hacks |
| D2 | Hack effects are computed from `activeHacks` when shown (credits ∞, unlocked list, max power), not written into the saved trophies/unlocks | Reset (S9) only clears `activeHacks` and the normal rules come back exactly |
| D3 | A QR code contains a link `<game address>/?hack=<CODE>`; opening the game with `?hack=` redeems the code | The iPad/phone camera app can scan it and open the game directly — works even when the in-game camera cannot |
| D4 | In-game scanning: camera via `getUserMedia`, decoding with `jsqr` (new npm dependency, Apache-2.0) | Works in Safari on iPad/iPhone (the built-in `BarcodeDetector` does not exist there) |
| D5 | QR images drawn with `qrcode` (new npm dependency, MIT) on a printable QR page | Small, no server change needed |
| D6 | `npm run dev:https` serves the game over HTTPS with a self-signed certificate (`@vitejs/plugin-basic-ssl`, dev only); `npm run dev` stays HTTP | Browsers allow the camera only on `localhost` or HTTPS; over plain HTTP on the Wi-Fi the screen explains it and D3 still works |

---

## Step 1 — Hack catalogue and rules

### Goal
The server knows the three hacks and checks codes; the UI knows how hacks change what is shown (S2, S4–S6, S11, S12).

### Tasks
- [x] Record the start time in Notes below.
- [x] `server/src/hack_star_server/hacks.py`: `INFINITY` → `infinite_credits`, `OPENSESAME` → `unlock_all`, `POWER22` → `power22`; `GET /api/hacks`, `POST /api/hacks/redeem` (trims spaces, any letter case; 404 "Unknown code").
- [x] `pytest` for valid, lower-case, spaced and unknown codes.
- [x] UI `hacks.ts`: `redeem(code)`, `codeFromScan(text)` (plain code or `?hack=` link), `credits`, `isUnlocked`, `maxPower` from progress + hacks.
- [x] Check: `uv run pytest` and `npm test` pass.

### Notes
Started: 2026-11-12 10:03

Codes longer than 100 characters are refused (422) before they are looked up.

**Done (2026-11-12 · ~3m)** — hack catalogue and redeem endpoint; UI rules. `pytest` 15 passed, `npm test` 20 passed.

---

## Step 2 — Hack screen and effects

### Goal
The player types a code on the Hack screen, sees a celebration, and the effects show everywhere; hacks can be reset (S1, S4–S9, S12).

### Tasks
- [x] Record the start time in Notes below.
- [x] Hack button on the home screen; Hack screen with code field, **Hack!** button, active hacks list, **Reset all hacks** with confirmation.
- [x] Celebration (confetti + big name of the hack); "Unknown code" with a shake for wrong codes.
- [x] Effects: home and fighter screens show ∞ credits; unlock all opens every fighter and skin; power shows `x/22`.
- [x] Check (browser): `opensesame` unlocks Pixel and lets it be selected; ` Infinity ` shows ∞; `POWER22` shows `/22`; `hello` shows "Unknown code"; reload keeps the hacks; reset brings back locks, credits 500 and `/11`.

### Notes
Started: 2026-11-12 10:06

After a reset, a fighter picked with "unlock all" is locked again; home then shows the first unlocked fighter (the saved choice is kept, so it comes back if the hack is entered again).

**Done (2026-11-12 · ~6m)** — browser: `hello` → "Unknown code", no hack saved; `opensesame` → celebration "Unlock everything", Pixel selectable; ` Infinity ` → ∞; `POWER22` → `7/22`; kept after reload; reset → Pixel locked, 500 credits, `7/11`, home shows Blaze. `svelte-check` 0 errors.

---

## Step 3 — QR codes: scan and print

### Goal
Codes can be scanned in the game or with the device camera app, and adults can print the QR codes (S3, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] **Scan QR** on the Hack screen: camera preview, decode with `jsqr`, redeem like a typed code; clear message when the camera is not available or not allowed.
- [ ] Opening the game with `?hack=<CODE>` redeems it and removes it from the address.
- [ ] QR page (`/?qr`, linked from the Hack screen): one QR per hack with its name and code, print-friendly.
- [ ] `npm run dev:https` (D6).
- [ ] Check: a QR image from the QR page decodes back to its link (`npm test`); `/?hack=power22` shows the celebration; without a camera the scan shows the message.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Step 4 — Final check

### Goal
Everything works on all sizes and F0/F1 still work.

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Browser check of home, Hack screen and QR page at 390×844, 844×390, 1024×768, 1440×900.
- [ ] `pytest`, `npm test`, `npm run check`, `npm run build` pass.
- [ ] README: hack codes, QR page, scanning on iPad (camera app, or `dev:https`).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Spending credits (and so "credits never go down") | Nothing costs credits until F6 | Later spec (F6) |
| Power 22 making fighters stronger | Power levels affect matches from F6 (S12) | Later spec (F6) |

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
