# Hack star (Godot)

This folder holds the Godot version of Hack star: a re-implementation with the
[Godot Engine](https://godotengine.org/) 4.7.2, for the browser only (desktop, iPad and phone).
It is the first basic game so far: a start screen and a 3D arena with one fighter. The
Python + Svelte game in the rest of the repository is unchanged; see the [root README](../README.md).

## Layout

| Folder | What |
|--------|------|
| `project.godot` | The Godot project (open this file in the editor) |
| `scenes/` | Screens and objects (`.tscn`) with their scripts |
| `game/` | Pure rules (movement) without scenes |
| `tests/` | Automated tests (GUT) |
| `addons/gut/` | GUT 9.7.1, the test tool, with its licence |
| `tools/` | PowerShell scripts for the checks, export and serving |
| `build/` | Web export (created by the scripts, git-ignored) |
| `.specs/` | Specs of this game (see [Specs](#specs)) |

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
2. Press **F5** (Run Project). The start screen shows **Hack star** and **Play**.
3. **Play** opens the arena. Press **Back** (top-left) to return to the start screen.

## Commands

Run them from the `hack_star_godot` folder.

| Command | What it does |
|---------|--------------|
| `.\tools\check_tools.ps1` | Checks the pinned versions of Godot, the export templates, gdtoolkit and GUT |
| `.\tools\test.ps1` | Runs the GUT tests headless (without the editor); fails if a test fails |
| `.\tools\lint.ps1` | Runs `gdlint` and `gdformat --check` on `game/`, `scenes/` and `tests/` |
| `.\tools\export_web.ps1` | Exports the game for the web into `build\web\` |
| `.\tools\serve_web.ps1` | Serves `build\web\` on port 8060 until you press Ctrl+C |

## Play in a browser

1. `.\tools\export_web.ps1`
2. `.\tools\serve_web.ps1`
3. Open <http://localhost:8060> in a desktop browser.

## Play on an iPad

1. Connect the iPad and the computer to the same Wi-Fi.
2. On the computer: `.\tools\export_web.ps1`, then `.\tools\serve_web.ps1`. It prints an
   address such as `http://192.168.1.20:8060`.
3. If Windows asks, allow Python through the firewall on private networks.
4. On the iPad, open that address in Safari.
5. Check landscape and portrait, the touch joystick, and that the frames per second label
   (top-right) shows 30 or more.

## Controls

- **Computer:** WASD or the arrow keys move the fighter.
- **iPad and phone:** the touch joystick (bottom-left) moves the fighter. It appears only on a
  touch screen.
- **Back** (top-left) returns to the start screen.

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
