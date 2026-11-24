<#
.SYNOPSIS
Checks that the pinned Godot tools (tools\versions.json) are installed.

.DESCRIPTION
Finds Godot through $env:GODOT, else `godot` on the PATH, else the winget package folder.
Checks Godot, the web export templates, gdtoolkit (gdlint), GUT and ProtonScatter. GUT lives in
addons\gut, which Step 2 adds together with project.godot: while project.godot does not
exist GUT is reported as pending and does not fail the check; once it exists a missing or
wrong GUT fails. ProtonScatter (addons\proton_scatter) follows the same rules. Exit code 1 if anything is missing or has the wrong version.
#>
#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$versions = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'versions.json') | ConvertFrom-Json
$failed = $false

. (Join-Path $PSScriptRoot 'godot.ps1')

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
        Write-Result 'Godot' $false "found $actual at $godot, need $godotVersion.stable. Install: winget install --id GodotEngine.GodotEngine --version $godotVersion -e"
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

# ProtonScatter (editor-only: places the Glimmer Isles props, baked before the game runs)
$scatterConfig = Join-Path $projectRoot 'addons\proton_scatter\plugin.cfg'
if (Test-Path -LiteralPath $scatterConfig) {
    $line = Select-String -LiteralPath $scatterConfig -Pattern '^version="([^"]+)"' | Select-Object -First 1
    $actual = if ($line) { $line.Matches[0].Groups[1].Value } else { 'unknown' }
    Write-Result 'ProtonScatter' ($actual -eq $versions.protonscatter) "addons\proton_scatter is $actual, need $($versions.protonscatter)"
}
elseif (Test-Path -LiteralPath (Join-Path $projectRoot 'project.godot')) {
    Write-Result 'ProtonScatter' $false "addons\proton_scatter\plugin.cfg missing. Install ProtonScatter $($versions.protonscatter) from the Godot Asset Store into addons\proton_scatter (without demos\ and tests\)"
}
else {
    Write-Host 'pending  ProtonScatter: not in addons/proton_scatter yet'
}

if ($failed) {
    exit 1
}
Write-Host 'All pinned tools OK.'
exit 0
