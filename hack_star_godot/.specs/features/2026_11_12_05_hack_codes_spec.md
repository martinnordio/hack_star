# Hack Codes Spec

> **Author:** Martin Nordio and Mattia Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/godot-mvp`
> **Issue:** #29
> **Moved from:** [2026_11_12_hack_codes_spec.md](../../../.specs/features/done/2026_11_12_hack_codes_spec.md) (#3)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../.specs/kit/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | move | Claude Sonnet 5.5 | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | included in [02](done/2026_11_21_02_move_specs_to_godot_spec.md) | moved from 2026_11_12_hack_codes_spec.md (requirements only) |
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | included in the plan row | included in the plan row | Part 1 revised: S0 checked; S1, S3, S4, S6, S10, S11, S12 revised; S13 (no server), S14 (English), S15 (web game reaches the server) added; no open questions; branch `feature/godot-mvp` |
| 2026-11-21 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | included in the plan row | included in the plan row | issue #29 created (no parent) |
| 2026-11-21 | plan | `PLAN:` | Claude Opus 5.5 | 3.39 M (129 k in · 3.23 M cached · 37 k out) | CHF 1.70 (202 credits) | Part 2 written (9 Steps: standard, standard, standard, standard, reasoning, standard, standard, reasoning, light); also the requirements revision and the issue (`usage.ps1 -AgentName s05-lead` from 17:25:44) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | 914 k (88 k in · 816 k cached · 10 k out) | CHF 0.33 (40 credits) | Step 1 done (`usage.ps1 -AgentName s05-steps1-4` 17:25:44–17:35:03) |

---

# Part 1 · Requirements

## Context

Hack codes are what makes Hack star different from Brawl Stars: by typing a secret code or
scanning a QR code, a player gets unlimited credits, all fighters unlocked, and power levels up
to 22 instead of 11. This is F2 in the
[MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) and the "hack codes" part
of [overall_req.md](../../../.specs/overall_req.md).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- How the Python + Svelte game did it: [original spec](../../../.specs/features/done/2026_11_12_hack_codes_spec.md) (#3).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — S1–S3 (browser,
  screens, input) and S9 (progress kept on the device) apply here too; the Godot technology,
  the architecture document `hack_star_godot/docs/architecture.md` and how to run the game
  (S12–S14).
- [MVP and architecture spec](done/2026_11_12_03_mvp_and_architecture_spec.md) — its open question
  "Server for rooms and hack codes" decides whether the hack codes need a server in the Godot game.
- [Basic UI spec](done/2026_11_12_04_basic_ui_spec.md) — credits on the home screen (S1), fighter list
  with locks and power levels (S4), the fighter screen with skins (S7); the UI foundation of
  the Godot game (S12).
- Checked 2026-11-21 (S0) in the code: the home screen (`scenes/home.tscn`) has **Play**,
  **Fighters** and **Info** and shows "Credits: 500"; the fighter list and the fighter screen
  show "Power: <n>"; locked fighters cannot be selected (`GameState.select`); skins have no
  locks yet (spec 10); screens change through the autoload `Screens` and every Back goes home;
  `GameState` holds the session and **nothing is saved** — the save file (one JSON in
  `user://`, one autoload) is planned for spec 05 or 08 (`docs/architecture.md`, *Saved
  progress*). Nothing is bought with credits yet (spec 09, 10). The Godot game does not call
  any server yet; `tools/serve_web.ps1` only serves `build/web/` on port 8060.
- The existing FastAPI server (`server/src/hack_star_server/hacks.py`, `app.py`):
  `GET /api/hacks` lists the hacks, `POST /api/hacks/redeem` returns the hack of a code (any
  letter case, spaces trimmed) or 404 "Unknown code". It already knows `INFINITY`,
  `OPENSESAME`, `POWER22` and the later codes `HYPERCHARGE` (spec 12) and `CREATOR` (spec 17),
  with durations added by spec 16. Spec 03 decided that the Godot game uses this server,
  unchanged, at `/api` on the address the page came from (D3 of spec 03); the local tool that
  serves the web export and forwards `/api` is built by this spec.

**New:**
- A hack screen to enter or scan codes, the three hack effects, the first saved data of the
  Godot game (the active hacks), the QR page, and the local web setup that reaches the server.

| Document | Purpose |
|----------|---------|
| [overall_req.md](../../../.specs/overall_req.md) | Overall game idea and planned specs |

## 1 · Specs

- **S0 — Check with the Godot game:** Before this spec is planned, each statement below is
  checked against the Godot game as built so far (specs 01–04) and the Godot architecture
  (spec 03, `hack_star_godot/docs/architecture.md`); a statement that does not fit — it names
  the Python + Svelte game, a later spec changed the behaviour, or it no longer makes sense —
  is revised with `REQUIREMENTS:` before `PLAN:`. — checked 2026-11-21: S2, S5, S7, S8, S9
  fit; S1, S3, S4, S6, S10, S11, S12 revised (Back of spec 04, the camera in the browser,
  nothing to buy yet, power shown as level and maximum, the QR page in the game, the server's
  later codes, spec 09 instead of F6); S13 (no server), S14 (English) and S15 (the web game
  reaches the server) added; no open questions.
- **S1 — Hack screen:** A **Hack** button, always visible on the home screen, opens a screen
  where the player can type a code or scan a QR code; its **Back** returns to the home screen
  like every other screen (spec 04, S10). _(revised 2026-11-21: Back as in spec 04.)_
- **S2 — Type a code:** A typed code is accepted with uppercase or lowercase letters and
  surrounding spaces.
- **S3 — Scan a QR code:** In the browser on a device with a camera, the player can scan a QR
  code that contains a hack code, and it works exactly like typing it. If the camera cannot be
  used (no camera, permission refused, a page that is not `https://` or `localhost`, or a game
  that does not run in a browser), the screen says so and typing still works. Scanning one of
  the game's QR codes (S10) with the device's own camera app opens the game and applies the
  code too. _(revised 2026-11-21: the Godot game also runs outside a browser, and browsers
  allow the camera only on `https://` or `localhost`; the camera-app way of the original spec
  kept.)_
- **S4 — Unlimited credits:** The "unlimited credits" code shows credits as ∞ wherever the
  game shows credits; once things can be bought with credits (specs 09 and 10), buying does
  not lower the credits while it is active. _(revised 2026-11-21: nothing is bought with
  credits in the Godot game yet.)_
- **S5 — Unlock all:** The "unlock all" code unlocks every fighter and every skin.
- **S6 — 22 power levels:** The "power 22" code raises the maximum power level of every
  fighter from 11 to 22; the fighter list and the fighter screen show each fighter's power
  level with its maximum (for example "Power 7 / 11", "Power 7 / 22"). _(revised 2026-11-21:
  spec 04 shows only the level, so the new maximum is shown next to it.)_
- **S7 — Feedback:** A correct code shows a celebration animation and the name of what it
  unlocked; a wrong code shows "Unknown code" and changes nothing.
- **S8 — Active hacks:** The hack screen lists the hacks that are active, and hacks stay
  active after the browser is closed and opened again.
- **S9 — Reset:** The player can turn all hacks off from the hack screen, after confirming;
  the game goes back to the normal rules.
- **S10 — Printable QR codes:** From the hack screen an adult opens a page with the QR code of
  each hack code of S11, large enough to scan from the screen, and can save each one as an
  image to print or show on another screen. _(revised 2026-11-21: says where the QR codes
  are in the Godot game.)_
- **S11 — The codes:** `INFINITY` gives unlimited credits (S4), `OPENSESAME` unlocks all
  (S5), `POWER22` gives 22 power levels (S6). The codes are the server's, shared with the
  Python + Svelte game; codes the server knows for later specs (`HYPERCHARGE`, spec 12;
  `CREATOR`, spec 17) show "Unknown code" in the Godot game until their spec, and hacks do not
  expire until spec 16. _(revised 2026-11-21: the server already knows later codes and
  durations.)_
- **S12 — Power 22 for now:** Until power levels affect matches
  ([spec 09](2026_11_12_09_unlock_and_upgrade_spec.md)), the power-22 hack changes only what
  the fighter list and fighter screen show. _(revised 2026-11-21: F6 is spec 09 in the
  ordered list.)_
- **S13 — No server:** If the game cannot reach the server to check a code, the hack screen
  says so ("Can't reach the hack server"), changes nothing, and the code can be tried again;
  the active hacks keep working without the server. _(added 2026-11-21: the Godot game calls
  a server for the first time.)_
- **S14 — Language:** All new text is in English; translations come with
  [spec 15](2026_11_13_15_accounts_fighters_and_languages_spec.md). _(added 2026-11-21: the
  Godot game has no languages yet, `docs/architecture.md`.)_
- **S15 — Web game reaches the server:** The web export finds the server at the address the
  page came from (spec 03, D3); one documented local command serves the web export with the
  server's `/api` reachable through it, on this computer and on an iPad or phone on the same
  Wi-Fi, also over `https://` so the camera can be used there. The server and the Python +
  Svelte game keep working as before. _(added 2026-11-21: the local setup is this spec's
  job, `docs/architecture.md`, *Same address*.)_

### Open questions

_None. Answered 2026-11-12: the game invents the codes (S11); the Hack button is visible (S1);
power 22 is shown only until F6 (S12). S0 check 2026-11-21 raised no new question: the server
is the existing FastAPI server (decided for the Godot MVP), and the revisions above take the
simplest reading that fits the Godot game._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Hack rules and the saved active hacks | standard (Claude Sonnet 5.5) — pure rules, a small JSON file and tests, fixed by D4 and D5 | ✅ Done | [→ Step 1](#step-1--hack-rules-and-the-saved-active-hacks) |
| **2** | Server connection | standard (Claude Sonnet 5.5) — one autoload with `HTTPRequest` and a test seam, fixed by D1–D3 | ⬜ Not started | [→ Step 2](#step-2--server-connection) |
| **3** | Hack screen: type, feedback, active hacks, reset | standard (Claude Sonnet 5.5) — one screen with the shared UI parts and a short celebration (D6, D7) | ⬜ Not started | [→ Step 3](#step-3--hack-screen-type-feedback-active-hacks-reset) |
| **4** | Hack effects on home, list and fighter screen | standard (Claude Sonnet 5.5) — small changes in three screens through the rules of Step 1 | ⬜ Not started | [→ Step 4](#step-4--hack-effects-on-home-list-and-fighter-screen) |
| **5** | QR code encoder | reasoning (Claude Opus 5.5) — tricky logic: QR versions, Reed–Solomon, masks, checked against a reference | ⬜ Not started | [→ Step 5](#step-5--qr-code-encoder) |
| **6** | QR page with savable images | standard (Claude Sonnet 5.5) — one screen that draws the encoder's matrix (D10) | ⬜ Not started | [→ Step 6](#step-6--qr-page-with-savable-images) |
| **7** | Local web setup: serve the export and forward `/api` | standard (Claude Sonnet 5.5) — a small stdlib proxy and a PowerShell wrapper, fixed by D3 | ⬜ Not started | [→ Step 7](#step-7--local-web-setup-serve-the-export-and-forward-api) |
| **8** | Camera scanning and QR links in the browser | reasoning (Claude Opus 5.5) — JavaScript bridge, camera permissions, an end-to-end browser check with a fake camera | ⬜ Not started | [→ Step 8](#step-8--camera-scanning-and-qr-links-in-the-browser) |
| **9** | Final check, README and architecture | light (Claude Haiku 5.5) — running the checks and updating two documents | ⬜ Not started | [→ Step 9](#step-9--final-check-readme-and-architecture) |

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
> Step ends with `tools/test.ps1` and `tools/lint.ps1` exit 0; a Step that changes a `.ps1`
> also parses it with `[System.Management.Automation.Language.Parser]::ParseFile`. Nothing
> in `server/` or `ui/` changes (D1); the GUT tests never call the network (D2).

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **The existing server checks the codes, unchanged:** `POST /api/hacks/redeem` with `{"code": "…"}` (200 with the hack, 404 "Unknown code") and `GET /api/hacks` (the list for the QR page) of `server/src/hack_star_server/`. The Godot game knows only the three hack ids of S11 (`infinite_credits`, `unlock_all`, `power22`, constants of `Hacks`, D4) and treats a 200 with another id (`hypercharge`, `creator`) as "Unknown code"; it ignores `duration_seconds` (hacks do not expire before spec 16). The codes themselves are not written in the Godot code. | Decided for the Godot MVP (spec 03, S15): one server for both games, so they share the codes; the original spec's D1 (codes only on the server); no Godot-only endpoint, so `cd server; uv run pytest` and the Svelte game are untouched. |
| D2 | **One autoload talks to the server:** `HackServer` (`scenes/autoload/hack_server.gd`, registered in `project.godot`) with `redeem(code)` and `list_hacks()`, both `await`-able, built on `HTTPRequest` with a timeout of 8 s. A result is a `Dictionary` with `status` = `ok` (with `id`, `name`, `code`), `unknown` (404, or an id the game does not know) or `no_server` (no connection, timeout, any other status, broken JSON). Tests replace the transport with `HackServer.fake_responder` (a `Callable` that returns status code and body), so the GUT tests never use the network. | S7, S13: three clear outcomes for the screen; one place for the address and the HTTP details; tests fast and offline. |
| D3 | **Server address and local web setup:** in the web export the base URL is the page's own address (`JavaScriptBridge.eval("location.origin")`) + `/api` (spec 03, D3); elsewhere (editor, desktop run) it is `http://127.0.0.1:8180/api`, where `cd server; uv run hack-star-server` listens. `tools/serve_web.ps1` becomes the local setup: it runs `tools/serve_web.py` (Python standard library only, through `uv run --no-project python`, as today) that serves `build/web/` on port 8060 and forwards every `/api/...` request to `-ApiUrl` (default `http://127.0.0.1:8180`): plain HTTP with `http.client`, WebSocket upgrades (`/api/rooms`, spec 14) as a two-way byte tunnel. `-Https` serves `https://` with a self-signed certificate created once into `build/cert/` (git-ignored) by `uv run --no-project --with cryptography==<pinned> python tools/make_cert.py`; without `-Https` it stays plain HTTP. The server is started in its own window (README). | S15: same origin, so no CORS and no server change; like the Vite proxy of the Svelte game (`ui/vite.config.ts`); HTTPS is needed for the camera on an iPad over Wi-Fi (original spec D6); the stdlib keeps the tool free of new pinned packages except `cryptography`, used only to make the certificate. |
| D4 | **Hack effects are computed, not written into progress:** `game/hacks.gd` (`Hacks`, pure): the ids, `normalize_code(text)` (trim, upper case), `code_from_scan(text)` (a plain code or a link with `?hack=<CODE>`, D9), `is_known(id)`, `credits_text(credits, hacks)` ("∞" with `infinite_credits`), `spend(credits, price, hacks)` (credits unchanged with `infinite_credits`; used by specs 09 and 10), `is_fighter_unlocked(id, unlocked, hacks)`, `is_skin_unlocked(fighter_id, skin_id, hacks)` (true: skins have no locks before spec 10), `max_power(hacks)` (11 or 22) and `power_text(level, hacks)` ("Power 7 / 22"). `GameState` keeps `active_hacks: Array[String]` and uses these rules in `is_unlocked` and `select`; trophies, unlocks and power levels are never changed by a hack. | S4, S5, S6, S9, S12: reset only clears `active_hacks` and the normal rules come back exactly (original spec D2); rules testable without scenes (architecture, *Game rules*). |
| D5 | **The first save file:** `user://hack_star_save.json` = `{"version": 1, "hacks": ["power22", …]}`, read and written only by `GameState` through the pure `game/save_data.gd` (`SaveData.to_json(hacks)`, `SaveData.from_json(text)`: a missing, broken or newer file gives no hacks, unknown ids are dropped). `GameState` loads it in `_ready` and writes it after every `activate_hack` and `reset_hacks`; `GameState.save_path` can be pointed to a test file. Only the active hacks are saved; trophies, unlocks, selections and credits stay session values until spec 08 adds its fields (with `version` for migrations). In the browser `user://` lives in IndexedDB. | S8: the architecture's plan (one JSON in `user://`, one autoload, a `version`); the smallest file that meets this spec; spec 08 extends it. |
| D6 | **Hack screen:** `scenes/hack_screen.tscn` + `.gd`, constant `Screens.HACK`, opened by a **Hack** button in the home screen's button column (always visible, D13 of spec 04 sizes). It has: a title, a `LineEdit` (max 100 characters as the server) with **Use code** (also Enter), **Scan QR code**, a message label, the list "Active hacks" (name of each active hack, or "No hacks active"), **Turn all hacks off** (disabled when none; a themed `ConfirmationDialog` "Turn all hacks off?" with **Turn off** / **Cancel**), **QR codes** (opens the QR page, D10) and the shared Back. While a code is checked the buttons are disabled. Messages: "<name> unlocked!" (S7), "Unknown code" (S7, D1), "Can't reach the hack server. Try again later." (S13), the camera messages of D8. | S1, S2, S7–S9, S13; the shared parts of spec 04 (theme, `Screens`, Back, size tests). |
| D7 | **Celebration:** on a correct code the message pops (a `Tween` on scale and colour) and a `CPUParticles2D` burst of stars plays for at most 2 s, built in code, no asset. | S7 "celebration animation"; `CPUParticles2D` works in the Compatibility renderer on WebGL; nothing to license. |
| D8 | **Camera scanning in the browser through JavaScript:** `web/qr_scanner.js` (own code) opens the back camera with `getUserMedia`, shows a full-screen `<video>` over the game canvas with a **Cancel** button, decodes frames with jsQR and reports the text or a reason (`denied`, `no_camera`, `needs_https`, `cancelled`) to a callback; `web/jsQR.js` is jsQR 1.4.0 (Apache-2.0, the library of the Svelte game, copied from `ui/node_modules/jsqr/dist/jsQR.js`, a row in `LICENSES.md`). `export_presets.cfg` loads both with `html/head_include`; `tools/export_web.ps1` copies `web/*.js` into `build/web/`. In GDScript `scenes/ui/qr_scanner.gd` (`QrScanner`) calls it with `JavaScriptBridge` and emits `scanned(text)` or `failed(reason)`; outside the web export it fails with `not_web`. The scanned text goes through `Hacks.code_from_scan` and the same redeem as typing. Messages: "Camera not available — type the code" (`no_camera`, `not_web`), "Camera permission refused — type the code" (`denied`), "The camera needs https:// — type the code" (`needs_https`). `html/experimental_virtual_keyboard` is turned on so the code can be typed on an iPad or phone. | S3: Godot has no QR decoder, and Safari on iPad has no `BarcodeDetector`, so jsQR as in the Svelte game (its D4); an HTML video overlay avoids sending camera frames into the engine; the virtual keyboard is needed for typing on touch devices. |
| D9 | **A QR code is a link:** its text is `<game address>?hack=<CODE>` (the game address is `location.origin + location.pathname` in the web export, `http://localhost:8060/` elsewhere). When the web game starts with `?hack=` in its address, it opens the hack screen and redeems that code there (same feedback), then removes `?hack=` from the address (`history.replaceState`). The in-game scanner accepts both a link and a plain code. | S3 "with the device's own camera app" and S10: the camera app opens the game directly, also when the in-game camera cannot be used (original spec D3). |
| D10 | **QR images made in GDScript:** `game/qr_code.gd` (`QrCode`, pure) encodes text in byte mode, error correction level M, versions 1–10, with all 8 masks and the standard penalty rules, into a square matrix of booleans; `scenes/ui/qr_image.gd` draws it into an `ImageTexture` (black on white, quiet zone of 4 modules, 8 px per module). The QR page `scenes/qr_page.tscn` + `.gd` (`Screens.QR`, Back goes home) loads `HackServer.list_hacks()`, keeps the three known ids (D1), and shows each with its name, code and QR image (at least 300 px on the screen) and **Save image**: in the web export a PNG download (`JavaScriptBridge.download_buffer`, `hack-<code>.png`), elsewhere a PNG in `user://` with its path shown. Without the server it shows the S13 message. | S10: no new library in the game; works headless for tests; the page shows the codes on screen and saves images to print. The reference check of Step 5 makes sure phones can read them. |
| D11 | **Text in English** in the scenes and in `Hacks` (hack names come from the server). | S14; spec 15 adds the languages. |
| D12 | **Tests:** `test_hacks.gd`, `test_save_data.gd`, `test_qr_code.gd` (rules), `test_game_state.gd` (active hacks, file in a test path), `test_hack_server.gd` (fake responder: 200, 404, unknown id, 500, broken JSON, no connection), `test_hack_screen.gd`, `test_qr_page.gd`, `test_qr_scanner.gd` (not web → `not_web`), and the hack screen and the QR page in `test_screen_sizes.gd` (five sizes, minimum sizes of spec 04 D13, click and touch with `tests/ui_input.gd`). Looks (celebration, QR page) are checked on screenshots from a windowed run saved under `%TEMP%`; the web parts (proxy, camera, download, `?hack=`) by a browser run in Step 8. | Every statement checked; the network and the camera stay out of the GUT tests. |

---

## Step 1 — Hack rules and the saved active hacks

### Goal
The game knows the three hacks, computes their effects from the active hacks and keeps the
active hacks in a save file (S2, S4, S5, S6, S8, S9, S11, S12).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `game/hacks.gd` (`Hacks`) after D4 and `game/save_data.gd` (`SaveData`) after D5.
- [x] `GameState`: `active_hacks`, `activate_hack(id)` (ignores unknown or already active ids),
      `reset_hacks()`, `has_hack(id)`, `save_path`, load in `_ready`, save after each change;
      `is_unlocked` and `select` follow `Hacks.is_fighter_unlocked`; `reset()` also empties
      `active_hacks` in memory without saving (so the tests of spec 04 start from the normal
      rules even if the developer's own file has hacks), and `_ready` loads the file after it.
- [x] Tests: `tests/test_hacks.gd` (normalize " infinity " → "INFINITY"; `code_from_scan` of a
      code and of a link; ∞ text; `spend` with and without the hack; unlock and max power
      with and without hacks; power text), `tests/test_save_data.gd` (round trip; missing,
      broken, newer and unknown ids), `tests/test_game_state.gd` additions (activate, save,
      load again from the test file, reset hacks → normal rules; a locked fighter selectable
      only with `unlock_all`). Every test that changes hacks points `GameState.save_path` to a
      file under `user://test/` and restores it, so the tests never touch the player's file.
- [x] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
Started: 2026-11-21 17:33

**Done (2026-11-21 · ~3m · Claude Sonnet 5.5)** — `Hacks` (rules), `SaveData` (save file) and `GameState` (`active_hacks`, `activate_hack`, `reset_hacks`, `has_hack`, `save_path`, load in `_ready`, save after each change; `reset()` clears the hacks in memory only); `is_unlocked` follows `Hacks.is_fighter_unlocked`. 15 new tests; `tools/test.ps1` 126 passing, exit 0; `tools/lint.ps1` exit 0. suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · 914 k · CHF 0.33

---

## Step 2 — Server connection


### Goal
The game asks the existing server for a hack code and the list of hacks, and tells a correct
code, an unknown code and a missing server apart (S2, S7, S11, S13).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Autoload `HackServer` (`scenes/autoload/hack_server.gd`) after D2 and D3 (base URL by
      platform, `redeem(code)` sends the normalized code, `list_hacks()`), registered in
      `project.godot`.
- [ ] Tests: `tests/test_hack_server.gd` with `fake_responder`: 200 known id → `ok` with name;
      200 `hypercharge` → `unknown`; 404 → `unknown`; 500, broken JSON, no connection →
      `no_server`; the list keeps only the three known ids; the base URL outside the web is
      `http://127.0.0.1:8180/api`.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; once by hand, with
      `cd server; uv run hack-star-server` running, a temporary headless Godot script (outside
      the repository, removed after) redeems ` power22 ` → `ok` "Power 22" and `NOPE` →
      `unknown`, and with the server stopped → `no_server`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 3 — Hack screen: type, feedback, active hacks, reset

### Goal
A **Hack** button on home opens the hack screen, where a typed code is checked with the
server, the result is celebrated or explained, the active hacks are listed and can all be
turned off after confirming (S1, S2, S7, S8, S9, S13, S14).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `Screens.HACK`; **Hack** button on the home screen (after **Info**, same style).
- [ ] `scenes/hack_screen.tscn` + `.gd` after D6 and the celebration after D7; **QR codes**
      and **Scan QR code** are in the scene but hidden until Steps 6 and 8 connect them.
- [ ] Tests: `tests/test_hack_screen.gd` (with `HackServer.fake_responder` and a test save
      path): " opensesame " → "Unlock everything unlocked!", listed as active, saved;
      "NOPE" → "Unknown code", nothing changes; no server → the S13 message, nothing changes;
      Enter submits; reset asks first, Cancel keeps the hacks, **Turn off** clears them and
      the list says "No hacks active"; home has **Hack** and it opens the hack screen; the
      hack screen joins `tests/test_screen_sizes.gd` (inside, minimum sizes, Back and Hack by
      click and touch).
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; screenshots (windowed run, under
      `%TEMP%`) of the hack screen at 1280×720 and 390×844, and during the celebration.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 4 — Hack effects on home, list and fighter screen

### Goal
The active hacks change what the player sees: credits ∞, every fighter unlocked and
selectable, power with its maximum 11 or 22; turning hacks off brings the normal view back
(S4, S5, S6, S9, S12).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Home: credits through `Hacks.credits_text` ("Credits: ∞"; check that the default font
      draws ∞, else write "Credits: Unlimited" and note it).
- [ ] Fighter card and fighter screen: lock state through `GameState.is_unlocked`, power
      through `Hacks.power_text` ("Power 7 / 11" or "Power 7 / 22").
- [ ] Tests: home shows ∞ with `infinite_credits` and the number without; with `unlock_all`
      no card is locked and Select works for Luna; with `power22` card and fighter screen show
      "/ 22", without "/ 11"; after `reset_hacks()` everything is as in spec 04.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; a screenshot of the fighter list
      with all three hacks active.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — QR code encoder

### Goal
The game turns a text of up to about 150 characters into a correct QR code matrix that phone
cameras can read (S10).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `game/qr_code.gd` (`QrCode`) after D10: byte mode, level M, versions 1–10 chosen by
      length, Reed–Solomon error correction (GF(256)), function patterns, format and version
      information, all 8 masks with the penalty rules; `encode(text)` returns the matrix,
      `size` = 17 + 4 × version; a too-long text returns an empty matrix.
- [ ] Reference: generate the matrices of three texts (`INFINITY`,
      `http://localhost:8060/?hack=OPENSESAME` and a 100-character link) once with
      `uv run --no-project --with segno==<pinned> python` (byte mode, level M, no boost of the
      level), save them as `tests/fixtures/qr_*.txt` (one row per line, `1`/`0`) and write the
      command in the test file's header.
- [ ] Tests: `tests/test_qr_code.gd` — the three matrices equal the references; versions and
      sizes; too long → empty.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 6 — QR page with savable images

### Goal
From the hack screen an adult opens the QR page with a large QR code for each hack, which can
be saved as a PNG image (S10, S13).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `scenes/ui/qr_image.gd` and `scenes/qr_page.tscn` + `.gd` after D10 (`Screens.QR`,
      Back goes home; **QR codes** on the hack screen opens it); links after D9.
- [ ] **Save image**: PNG download on the web, a file in `user://` elsewhere (path shown).
- [ ] Tests: `tests/test_qr_page.gd` (fake responder: three rows with name, code and a
      texture of the right size; `hypercharge` from the server not shown; no server → the S13
      message; **Save image** writes a PNG outside the web); the QR page joins
      `tests/test_screen_sizes.gd`.
- [ ] Check: `tools/test.ps1` and `tools/lint.ps1` exit 0; a screenshot of the QR page at
      1280×720 and 390×844, and a phone camera or a QR reader (for example jsQR in Node, or
      `zbarimg` if installed) reads a saved PNG as the link of D9.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 7 — Local web setup: serve the export and forward `/api`

### Goal
One documented command serves the web export and makes the server's `/api` reachable at the
same address, over HTTP or HTTPS, on this computer and on the Wi-Fi (S13, S15).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `tools/serve_web.py` and the new `tools/serve_web.ps1` (`-Port`, `-ApiUrl`, `-Https`)
      after D3; `tools/make_cert.py`; `build/cert/` git-ignored (already under `build/`).
- [ ] If the forward target is down, `/api` answers 502, so the game shows the S13 message.
- [ ] Check: both `.ps1` parse with `[System.Management.Automation.Language.Parser]::ParseFile`;
      with `cd server; uv run hack-star-server` and `tools/serve_web.ps1` running:
      `curl http://localhost:8060/` returns `index.html`, `curl http://localhost:8060/api/hacks`
      returns the server's list, `POST /api/hacks/redeem` with `{"code":"nope"}` returns 404,
      a WebSocket to `ws://localhost:8060/api/rooms` gets an answer to `create`
      (`uv run --no-project --with websockets==<pinned> python -c …`); the same with `-Https`
      and `curl -k https://localhost:8060/api/hacks`; with the server stopped `/api/hacks`
      gives 502. Stop all processes by id afterwards. `tools/test.ps1` and `tools/lint.ps1`
      exit 0.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 8 — Camera scanning and QR links in the browser

### Goal
In the browser the player scans a QR code with the camera, or opens a QR link with the
camera app, and it works like typing; without a camera the screen says why (S3, S7, S15).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `web/qr_scanner.js`, `web/jsQR.js` (jsQR 1.4.0 with its licence header), the
      `html/head_include` and `html/experimental_virtual_keyboard` in `export_presets.cfg`,
      the copy in `tools/export_web.ps1`, after D8; the row for jsQR in `LICENSES.md`.
- [ ] `scenes/ui/qr_scanner.gd` (`QrScanner`) after D8; **Scan QR code** on the hack screen
      uses it and shows the messages of D8.
- [ ] `?hack=` at start after D9 (home or `GameState` checks it once per game start on the
      web, opens the hack screen and redeems).
- [ ] Tests: `tests/test_qr_scanner.gd` (outside the web → `failed("not_web")`); the hack
      screen shows the camera message for each reason and a scanned link redeems its code
      (scanner faked).
- [ ] Check: `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1` exit 0; with the
      server and `tools/serve_web.ps1` running, a temporary Playwright script (outside the
      repository, removed after) in Chromium: typing ` infinity ` shows "Unlimited credits
      unlocked!" and the home shows ∞ after a reload (saved in IndexedDB); with
      `--use-fake-ui-for-media-stream --use-fake-device-for-media-stream
      --use-file-for-fake-video-capture=<a .y4m of the POWER22 QR made from Step 6's PNG>`
      **Scan QR code** redeems Power 22; opening `/?hack=OPENSESAME` redeems it and the
      address no longer has `?hack=`; with the camera permission refused the "refused" message
      shows; **Save image** downloads a PNG. Screenshots under `%TEMP%`.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 9 — Final check, README and architecture

### Goal
Everything that worked before still works, all Godot checks pass, and the README and the
architecture describe hack codes, the save file and the local web setup (all statements).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `hack_star_godot/docs/architecture.md`: Layout (`web/`), Screens (hack screen, QR page,
      **Hack** on home, `?hack=`), Game rules (`Hacks`, `SaveData`, `QrCode`), UI foundation
      (`HackServer`, `QrScanner`, `QrImage`; `GameState` with active hacks), *Saved progress*
      (the file of D5, no longer only planned; spec 08 adds its fields), *Server, hack codes
      and rooms* (the calls are used now; the local setup of D3 replaces "until then"), Art and
      licences (jsQR), Tests.
- [ ] `hack_star_godot/README.md`: the hack screen, the three codes, the QR page, how to run
      the server and `tools/serve_web.ps1` (with `-Https` for the camera on an iPad), what is
      saved and how to clear it (Turn all hacks off).
- [ ] Run `tools/check_tools.ps1`, `tools/test.ps1`, `tools/lint.ps1`, `tools/export_web.ps1`
      (all exit 0); parse every changed `.ps1` with
      `[System.Management.Automation.Language.Parser]::ParseFile`; `cd server; uv run pytest`
      passes (the server is unchanged).
- [ ] `git diff --stat` of this spec shows nothing in `server/` or `ui/`.
- [ ] Note in Notes that the device play-test (iPad and phone: scan with the in-game camera
      over `-Https`, scan with the camera app, typing with the on-screen keyboard) stays with
      the author (spec 03, D6, Deferred Items).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Hacks that expire after 72 hours | The server has durations, but expiry is spec 16's statement (S11) | [16 Bug fixes](2026_11_14_16_bug_fixes_spec.md) |
| `HYPERCHARGE` and `CREATOR` codes | Their effects come with their specs; until then "Unknown code" (S11, D1) | [12 Super and hypercharge](2026_11_12_12_super_and_hypercharge_spec.md), [17 Fighter studio, saves and music](2026_11_14_17_fighter_studio_saves_and_music_spec.md) |
| Buying with unlimited credits | Nothing can be bought yet; `Hacks.spend` is ready (S4, D4) | [09 Unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md), [10 Skins shop](2026_11_12_10_skins_shop_spec.md) |
| Power 22 in matches | Power levels do not affect matches yet (S12) | [09 Unlock and upgrade](2026_11_12_09_unlock_and_upgrade_spec.md) |
| Saving trophies, unlocks, selection and credits | Only the active hacks are saved (D5) | [08 Trophies](2026_11_12_08_trophies_spec.md) |
| Translations of the new text | English only (S14, D11) | [15 Accounts, fighters and languages](2026_11_13_15_accounts_fighters_and_languages_spec.md) |
| Play-test on a real iPad and phone (in-game camera over `-Https`, camera app with a QR link, on-screen keyboard) | Needs a person with the devices (spec 03, D6) | the author, before spec 08 is closed |

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
