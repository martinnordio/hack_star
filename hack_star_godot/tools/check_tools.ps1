#Requires -Version 5.1
<#
.SYNOPSIS
Checks that the pinned Godot tools (tools\versions.json) are installed.

.DESCRIPTION
Finds Godot through $env:GODOT, else `godot` on the PATH, else the winget package folder.
Checks Godot, the web export templates, gdtoolkit (gdlint) and GUT. GUT lives in
addons\gut, which Step 2 adds together with project.godot: while project.godot does not
exist GUT is reported as pending and does not fail the check; once it exists a missing or
wrong GUT fails. Exit code 1 if anything is missing or has the wrong version.
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$versions = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'versions.json') | ConvertFrom-Json
$failed = $false

function Write-Result {
    param([string]$Name, [bool]$Ok, [string]$Detail)
    if ($Ok) {
        Write-Host ('OK       {0}: {1}' -f $Name, $Detail)
    }
    else {
        Write-Host ('MISSING  {0}: {1}' -f $Name, $Detail)
        $script:failed = $true
    }
}

function Find-Godot {
    if ($env:GODOT -and (Test-Path -LiteralPath $env:GODOT)) {
        return $env:GODOT
    }
    $command = Get-Command godot -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }
    $packages = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    if (Test-Path -LiteralPath $packages) {
        $found = Get-ChildItem -Path $packages -Recurse -Filter 'Godot_v*_win64_console.exe' -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($found) {
            return $found.FullName
        }
    }
    return $null
}

# Godot
$godotVersion = $versions.godot
$godot = Find-Godot
if (-not $godot) {
    Write-Result 'Godot' $false "not found. Install: winget install --id GodotEngine.GodotEngine --version $godotVersion -e (or set `$env:GODOT)"
}
else {
    $actual = (& $godot --version | Select-Object -First 1)
    if ($actual -like "$godotVersion.stable*") {
        Write-Result 'Godot' $true "$actual ($godot)"
    }
    else {
        Write-Result 'Godot' $false "found $actual, need $godotVersion.stable. Install: winget install --id GodotEngine.GodotEngine --version $godotVersion -e"
    }
}

# Web export templates
$templates = Join-Path $env:APPDATA "Godot\export_templates\$godotVersion.stable"
$missingTemplates = @('web_nothreads_release.zip', 'web_nothreads_debug.zip') |
    Where-Object { -not (Test-Path -LiteralPath (Join-Path $templates $_)) }
if ($missingTemplates) {
    Write-Result 'Export templates' $false "missing $($missingTemplates -join ', ') in $templates. Install: Godot editor, Editor > Manage Export Templates > Download and Install"
}
else {
    Write-Result 'Export templates' $true "web_nothreads in $templates"
}

# gdtoolkit
$gdlint = Get-Command gdlint -ErrorAction SilentlyContinue
if (-not $gdlint) {
    Write-Result 'gdtoolkit' $false "gdlint not found. Install: uv tool install gdtoolkit==$($versions.gdtoolkit)"
}
else {
    $actual = (& gdlint --version | Select-Object -First 1)
    if ($actual -match [regex]::Escape($versions.gdtoolkit)) {
        Write-Result 'gdtoolkit' $true "gdlint $($versions.gdtoolkit)"
    }
    else {
        Write-Result 'gdtoolkit' $false "found '$actual', need $($versions.gdtoolkit). Install: uv tool install gdtoolkit==$($versions.gdtoolkit) --force"
    }
}

# GUT
$gutConfig = Join-Path $projectRoot 'addons\gut\plugin.cfg'
if (Test-Path -LiteralPath $gutConfig) {
    $line = Select-String -LiteralPath $gutConfig -Pattern '^version="([^"]+)"' | Select-Object -First 1
    $actual = if ($line) { $line.Matches[0].Groups[1].Value } else { 'unknown' }
    Write-Result 'GUT' ($actual -eq $versions.gut) "addons\gut is $actual, need $($versions.gut)"
}
elseif (Test-Path -LiteralPath (Join-Path $projectRoot 'project.godot')) {
    Write-Result 'GUT' $false "addons\gut\plugin.cfg missing. Install GUT $($versions.gut) from its GitHub release into addons\gut"
}
else {
    Write-Host 'pending  GUT: not in addons/gut yet (added together with project.godot)'
}

if ($failed) {
    exit 1
}
Write-Host 'All pinned tools OK.'
exit 0
