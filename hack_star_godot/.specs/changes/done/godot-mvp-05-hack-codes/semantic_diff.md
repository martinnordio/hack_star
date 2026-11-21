### Semantic diff — spec 05 Hack Codes (#29)
Hack screen, three hacks, the first save file, QR page, camera scanning and the local web setup with `/api` · checks 7 pass · 2 n/a · 0 fail · findings 8 (0 blocking, 2 should-fix, 6 nit)

**Review here first:** [review page](https://github.com/martinnordio/hack_star/raw/feature/godot-mvp/hack_star_godot/.specs/review/2026-11-21_godot-mvp-05-hack-codes.html)
— download it and open it in a browser

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| ui | Home: **Hack** button, credits ∞ | modified | S1, S4 |
| ui | Fighter list and screen: "Power 7 / 11" or "/ 22", locks follow the hacks | modified | S5, S6, S12 |
| ui | Hack screen (type, scan, feedback, active hacks, reset) | added | S1–S3, S7–S9, S13, S14 |
| ui | QR page with savable images | added | S10, S11, S13 |
| output | Hack rules (`Hacks`) | added | S2–S6, S11, S12 |
| data-format | Save file `user://hack_star_save.json` | added | S8, S9 |
| output | Server client `HackServer` (ok / unknown / no_server) | added | S2, S7, S11, S13 |
| output | QR encoder `QrCode` | added | S10 |
| output | Local web setup: `/api` forwarded, 502 without server | added | S13, S15 |
| command | `tools/serve_web.ps1` (`-ApiUrl`, `-Https`) | modified | S15 |
| command | `tools/export_web.ps1` (copies `web/*.js`) | modified | S3 |
| config | Autoload `HackServer`; Web preset head include, virtual keyboard | modified | S3, S13, S15 |
| dependency | `cryptography` 50.0.2 (certificate only); jsQR 1.4.0 in the web export | modified | S3, S15 |

`server/` and `ui/` unchanged.

**Top findings:**
- QR codes made on `localhost` link to `localhost`, so a phone's camera app cannot open them. Needs a plan decision.
- A failed save of the active hacks is silent. Fix now.
- A redeem answer other than 200 or 404 (for example 422) shows "Can't reach the hack server". Needs a plan decision.
