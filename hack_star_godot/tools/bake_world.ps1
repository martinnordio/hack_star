<#
.SYNOPSIS
Bakes Glimmer Isles: writes scenes\worlds\glimmer_isles\baked.tscn from scatter_source.tscn.

.DESCRIPTION
Imports the project, then runs tools\bake_world.gd with Godot (headless). It rebuilds every
ProtonScatter of the source scene on the main thread with its fixed seed and saves the props as
plain MultiMeshInstance3D nodes, without any addon reference (spec 09, D12). Run it after
changing scatter_source.tscn or the props in props\, then run tools\test.ps1 and commit
baked.tscn. Exit code 1 if Godot fails or the bake does not finish.
#>
#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'godot.ps1')

$projectRoot = Split-Path -Parent $PSScriptRoot
$godot = Find-Godot
if (-not $godot) {
    Write-Host 'Godot not found. Run tools\check_tools.ps1 for the install command (or set $env:GODOT).'
    exit 1
}

Write-GodotVersionWarning $godot

Push-Location -LiteralPath $projectRoot
try {
    & $godot --headless --path . --import
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Godot import failed (exit code $LASTEXITCODE)."
        exit 1
    }
    # Windows PowerShell 5.1 turns Godot's stderr lines into terminating errors under 'Stop'.
    $ErrorActionPreference = 'Continue'
    $output = & $godot --headless --path . -s res://tools/bake_world.gd 2>&1 |
        ForEach-Object { $_.ToString() }
    $exitCode = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    $output | ForEach-Object { Write-Host $_ }
    if ($exitCode -ne 0 -or -not ($output -match '^bake: saved ')) {
        Write-Host "Bake failed (Godot exit code $exitCode)."
        exit 1
    }
}
finally {
    Pop-Location
}
Write-Host 'Bake OK: scenes\worlds\glimmer_isles\baked.tscn'
exit 0
