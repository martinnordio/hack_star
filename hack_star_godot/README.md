# Hack star (Godot)

This folder holds the Godot version of Hack star: a re-implementation with the
[Godot Engine](https://godotengine.org/) 4.7.2, for the browser only (desktop, iPad and phone).
It is the first basic game so far: a home screen, a fighter list with six fighters (each with
its skins), a fighter screen, an info page with the words of the game, a 3D canyon arena where
your fighter runs and shoots at three target dummies (with bushes to hide in), and the hack
codes: a hack screen to type or scan a code, the three hacks, and a QR code page. The hack codes are checked by the FastAPI server in `server/`. The first match is there too: a "last fighter standing" fight in the canyon against bots, with health, healing, a timer and a result. A win gives trophies, with Prestige levels, and the trophies and the chosen fighter are saved between visits. The first playable version (F0–F5 of the feature list) is complete. The Python + Svelte game in the rest of the repository is unchanged; see the [root README](../README.md).

## Layout

| Folder | What |
|--------|------|
| `project.godot` | The Godot project (open this file in the editor) |
| `scenes/` | Screens and objects (`.tscn`) with their scripts |
| `game/` | Pure rules (movement, fighters, Prestige, rarity, sample progress, vocabulary, hacks, save file, QR code) without scenes |
| `tests/` | Automated tests (GUT) |
| `docs/` | The architecture: where each part lives and what comes next ([architecture](docs/architecture.md)) |
| `addons/gut/` | GUT 9.7.1, the test tool, with its licence |
| `tools/` | PowerShell scripts for the checks, export and serving |
| `web/` | Browser scripts copied into the web export: the camera QR scanner and jsQR (with its licence) |
| `build/` | Web export (created by the scripts, git-ignored) |
| `.specs/` | Specs of this game (see [Specs](#specs)) |

Read [docs/architecture.md](docs/architecture.md) before you work on a spec, and keep it up to
date in the spec that changes it. The hack codes come from the FastAPI server in `server/` of
the repository, the same server as the Svelte game (rooms will too); the Godot game does not
have its own.

## Install on Windows

Run the commands in PowerShell, from the `hack_star_godot` folder.

1. **Godot 4.7.2** (the standard build, no .NET):

   ```powershell
   winget install --id GodotEngine.GodotEngine --version 4.7.2 -e
   ```

   winget does not add a `godot` command to the PATH. The scripts find Godot in the winget
   folder. If Godot is somewhere else, point the scripts to it (this session only):

   ```powershell
   $env:GODOT = "C:\path\to\Godot_v4.7.2-stable_win64_console.exe"
   ```

2. **Export templates 4.7.2** (needed for the web export). Either:

   - in the Godot editor, open **Editor > Manage Export Templates > Download and Install**; or
   - download the file and extract three files from it:

     ```powershell
     $tpz = "$env:USERPROFILE\Downloads\Godot_v4.7.2-stable_export_templates.tpz"
     Invoke-WebRequest -Uri "https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz" -OutFile $tpz
     $templates = "$env:APPDATA\Godot\export_templates\4.7.2.stable"
     New-Item -ItemType Directory -Force -Path $templates | Out-Null
     Add-Type -AssemblyName System.IO.Compression.FileSystem
     $zip = [System.IO.Compression.ZipFile]::OpenRead($tpz)
     foreach ($name in 'version.txt', 'web_nothreads_release.zip', 'web_nothreads_debug.zip') {
         $entry = $zip.Entries | Where-Object { $_.FullName -eq $name }
         [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, (Join-Path $templates $name), $true)
     }
     $zip.Dispose()
     Remove-Item $tpz
     ```

3. **uv** from [docs.astral.sh/uv](https://docs.astral.sh/uv/) (the server uses it too; the
   iPad server runs with it). Then the lint tool, gdtoolkit 4.5.0:

   ```powershell
   uv tool install gdtoolkit==4.5.0
   ```

4. **GUT 9.7.1** (the test tool) is already in `addons/gut/`. Nothing to install.

5. Check that everything is in place:

   ```powershell
   .\tools\check_tools.ps1
   ```

   Each line says OK or what to install. The last line is `All pinned tools OK.`

   If PowerShell says that scripts are disabled, allow local scripts once:
   `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.

The versions are fixed in [tools/versions.json](tools/versions.json) for everybody.

## Run in the editor

1. Start Godot and choose **Import**; select `hack_star_godot\project.godot`; then **Import & Edit**.
2. Press **F5** (Run Project). The home screen plays a short entrance (a click, a touch or a key
   skips it) and then shows your fighter, trophies, credits, **Hack star**, **Play**, **Training**,
   **Fighters**, **Info** and **Hack**. The hack codes need the server running, see
   [Run the hack server and the web game](#run-the-hack-server-and-the-web-game).
3. **Play** starts a match (see [How to play a match](#how-to-play-a-match)). **Training** opens the
   arena with three target dummies. **Fighters** lists the six fighters with their trophies, power
   level and Prestige; open one to see its skins, choose a skin and press **Select** to make it
   the home fighter. **Info** explains the words of the game. **Hack** opens the hack screen
   (see [Hack codes](#hack-codes)). Every screen has **Back** (top-left) that returns to the home
   screen.

## How to play a match

Press **Play** on the home screen. The match is in the same canyon as Training, without the
dummies: your fighter and three bots, each at its own start point.

1. **Countdown:** "3", "2", "1", then "FIGHT!". Nobody moves or shoots during the countdown.
2. **Fight:** shoot the bots (controls below). Every fighter has a health bar above it: green
   for you, red for the bots. A shot takes off part of the health bar and shows the damage
   number. A fighter that is not hit and does not shoot for 3 seconds slowly gets its health back.
3. **Bots:** they walk around, go for the nearest opponent they can see and shoot at it. They
   fight each other too. On "easy" they react late, miss more often and shoot more slowly. A bot
   in a bush is hard to see: it only sees you in a bush within 2.5 m, and a bot in a bush turns see-through, like you.
4. **Knock-out:** a fighter with no health left is knocked out and leaves the arena. The label
   top-right shows "Fighters left".
5. **Timer:** 2:00 at the top of the screen, red in the last 10 seconds.
6. **Result:** after the match the result screen shows **Victory!** (you are the last one
   standing), **Defeat** with your place (for example "You finished 3rd") when you are knocked
   out, or **Time's up!** (a draw) when the time runs out with bots still in. **Play again**
   starts a new match; **Home** goes home. **Back** in a match goes home at any time, with no
   result.

A match changes no credits or unlocks, and the hacks change nothing in a match. The trophies
change as described in [Trophies and Prestige](#trophies-and-prestige). The match settings (match
length, number of bots, bot level, health, healing, bush sight, trophies per win and per
defeat) are the values at the top of `game/match_settings.gd`; change a value there and the next
match uses it.

## Trophies and Prestige

Every match changes the trophies of the fighter you played with (the home fighter):

| Result | Trophies |
|--------|----------|
| Victory (the last fighter standing) | +10 |
| Defeat (you are knocked out) | 0 |
| Time's up (a draw) | 0 |

The result screen shows the change, the count "trophies / next Prestige" and a bar from the
last Prestige to the next one; the count goes up from the old total. A fighter reaches a new
**Prestige** level at every 1000 trophies (Prestige 1 at 1000, Prestige 2 at 2000, and so on); a
new Prestige is celebrated on the result screen, and the home screen, the fighter list and the
fighter screen show a Prestige badge from 1000 trophies. A defeat never takes a fighter below its
last Prestige. The numbers are `trophies_per_win` and `trophies_per_defeat` in
`game/match_settings.gd`; the Prestige size is `TROPHIES_PER_LEVEL` in `game/prestige.gd`.

The trophies of each fighter are saved with the match (see **Saved** below), so they are there
after a reload.

## Commands

Run them from the `hack_star_godot` folder.

| Command | What it does |
|---------|--------------|
| `.\tools\check_tools.ps1` | Checks the pinned versions of Godot, the export templates, gdtoolkit and GUT |
| `.\tools\test.ps1` | Runs the GUT tests headless (without the editor); fails if a test fails. Use it, not the editor's GUT panel: only this script sets the pre-run hook (`tests/pre_run_hook.gd`) that keeps the tests off your save file |
| `.\tools\lint.ps1` | Runs `gdlint` and `gdformat --check` on `game/`, `scenes/` and `tests/` |
| `.\tools\export_web.ps1` | Exports the game for the web into `build\web\` |
| `.\tools\serve_web.ps1` | Serves `build\web\` on port 8060 and forwards `/api` to the hack server; options in [Run the hack server and the web game](#run-the-hack-server-and-the-web-game) |

## Run the hack server and the web game

The hack codes are checked by the FastAPI server in `server/` (the same server as the Svelte
game). Run it in its own PowerShell window, from the `server` folder of the repository:

```powershell
cd ..\server
uv run hack-star-server
```

It listens on port 8180. Keep it running. Then, in the `hack_star_godot` folder:

```powershell
.\tools\export_web.ps1
.\tools\serve_web.ps1
```

`serve_web.ps1` serves the web export on port 8060 and forwards every `/api` request to the
server, so the page and the server share one address and the game needs no setup. It prints the
addresses to open: this computer (`http://localhost:8060`) and, for an iPad or a phone on the
same Wi-Fi, `http://<this computer's IPv4 address>:8060`. It runs until you press Ctrl+C.

| Option | Default | What |
|--------|---------|------|
| `-Port <n>` | `8060` | The port of the web game |
| `-ApiUrl <url>` | `http://127.0.0.1:8180` | Where the hack server listens; `/api` requests go there |
| `-Https` | off | Serves `https://` with a self-signed certificate, made once into `build\cert\` (git-ignored). The camera of the browser needs `https://` on an iPad or a phone; the browser warns once, so accept the certificate |

Without the server the game says "Can't reach the hack server" and `/api` answers 502. Windows
may ask to allow Python through the firewall on private networks.

## Hack codes

On the home screen, **Hack** opens the hack screen. Type a code and press **Use code** (or Enter), or
press **Scan QR code** and point the camera at a QR code (in the browser). The server checks the
code; any letter case and spaces around it are fine.

| Code | Hack | Effect |
|------|------|--------|
| `INFINITY` | Unlimited credits | Credits never run out (the home screen shows ∞) |
| `OPENSESAME` | Unlock everything | Every fighter and every skin is unlocked |
| `POWER22` | Power 22 | Power levels go up to 22 instead of 11 (shown as "Power 7 / 22") |

A hack never changes trophies, unlocks or power levels; turning all hacks off brings the normal
rules back. The hacks do not expire yet (spec 16), and the codes `HYPERCHARGE` and `CREATOR` say
"Unknown code" until their specs (12 and 17) add them. Nothing is bought with credits yet (specs 09
and 10), and power levels do not change matches yet (spec 09).

**QR codes:** open the QR page from the Wi-Fi address of this computer
(`http://<this computer's IPv4 address>:8060`), not from `localhost`: the game puts the address
of the page into every QR code, and a phone cannot open `localhost`. The **QR codes** button on the hack screen opens a page with a QR code for each
code. Scan it with the camera app or with **Scan QR code** in the game: the link opens the game
with the code, which is redeemed once. **Save image** saves the picture as a PNG (a download in
the browser, or a file in the user folder on the computer), for printing.

**Saved:** the progress and the active hacks, in one file, `hack_star_save.json`: the trophies,
power levels, unlocked fighters, credits, the chosen fighter and skins, and the hacks. The game
saves each change at once. The file is in the browser's storage for this address (so on the same
device and browser only); on the computer, in `%APPDATA%\Godot\app_userdata\Hack star\`. To clear
the hacks only, press **Turn all hacks off** on the hack screen and confirm. To start fresh (the
sample progress, no hacks), delete that file while the game is closed, or in the browser clear
the site's data for this address.

## Play on an iPad or a phone

1. Connect the iPad and the computer to the same Wi-Fi.
2. Start the server (see [Run the hack server and the web game](#run-the-hack-server-and-the-web-game)),
   then on the computer: `.\tools\export_web.ps1`, then `.\tools\serve_web.ps1 -Https`. It prints
   an address such as `https://192.168.1.20:8060`.
3. If Windows asks, allow Python through the firewall on private networks.
4. On the iPad, open that address in Safari and accept the self-signed certificate once. Without
   `-Https` the page works, but the in-game camera does not (the browser needs `https://`); typing
   a code still works.
5. Check landscape and portrait, the touch joystick, that the frames per second label (top-right)
   shows 30 or more, and a hack code typed and scanned.

## Controls

- **Computer:** WASD or the arrow keys move the fighter. The mouse aims: the fighter turns
  towards the pointer and a left click fires; hold the button to keep firing (the shots come
  with a short cool-down).
- **iPad and phone:** the left touch joystick (bottom-left) moves the fighter. The right stick
  (bottom-right) aims and fires: drag it past the dead zone to fire that way, or tap it to fire at
  the nearest dummy in range (straight ahead when none is in range; in a match, the nearest bot).
  A thin line on the ground shows the aim while the stick is dragged. Both sticks appear only on a touch screen.
- **Dummies:** in Training three straw dummies stand in the arena. A shot takes off part of the health bar
  and shows the damage number; a dummy that breaks apart comes back with full health after 5 s.
- **Bushes:** in a cactus patch the fighter turns see-through, so you can look at the ground
  and the cacti behind it. Shots stop at the rocks and walls, and at the dummies and fighters.
- **Back** (top-left) returns to the home screen.
- **Entrance:** a click, a touch or a key (for example Space) skips the entrance of the home screen.
- **Frame rate:** the label top-right shows the frames per second of the arena.

## Resources outside the folder

| Resource | Where it lives | In git? |
|----------|----------------|---------|
| Art | None: the fighter and arena are built in code from simple shapes | Yes, in the scripts |
| Fonts | None: Godot's default font | Built into Godot |
| Music (later) | `assets/music/` in this folder; Godot only imports files inside the project | No, git-ignored |

Music is never committed. Only tracks with a CC0 or CC BY licence may be used, with the rules
in [ui/public/assets/LICENSES.md](../ui/public/assets/LICENSES.md). Every file with a licence
is listed in [LICENSES.md](LICENSES.md).

## Specs

The ordered list of the specs is [.specs/features/README.md](.specs/features/README.md). The MVP
is specs 03–08, and the order follows the feature list. Work through it from the first spec
that is not closed: **S0** (check each statement against the game as built so far),
`REQUIREMENTS:` if a statement does not fit, then `PLAN:` → `IMPLEMENT:` → `REVIEW:` →
`CLOSE:` with the root kit's commands. The Godot specs live in `hack_star_godot/.specs/`, not in
the root `.specs/` (see [AGENTS.md](../AGENTS.md)).

Specs of this game are in `hack_star_godot/.specs/features/`. The rule for them is in
[AGENTS.md](../AGENTS.md): a new Godot spec goes into `hack_star_godot/.specs/features/`, and
its reviews, changes and costs go into `hack_star_godot/.specs/`, never into the root `.specs/`.
The root kit's prompts are used, with the GDScript rules in
`hack_star_godot/.specs/guidelines/gdscript.md` and the Godot checks above instead of
`pytest` or `npm`.

Costs are measured from the repository root, with the kit's scripts. The cost list is built
like this:

```powershell
cd ..
.specs\kit\tools\costs_ledger.ps1 -Root hack_star_godot -CostsLink ../../.specs/kit/COSTS.md
```

For a stage's cost, run `.specs\kit\tools\usage.ps1` from the same folder.

`hack_star_godot/.specs/spec-nx.json` holds only a copy of the root `cost` block. Keep the two
`cost` blocks equal when you change them.

## Licence and disclaimer

Hack star is open source under the [MIT licence](../LICENSE), © 2026 Martin Nordio and Mattia
Nordio. The licences of the third-party parts (the Godot Engine and GUT) are in
[LICENSES.md](LICENSES.md).

Hack star is an independent fan project. It is not affiliated with, endorsed, sponsored or
approved by Supercell, and it contains no Supercell code, art, sound or other content. All
trademarks belong to their owners.
