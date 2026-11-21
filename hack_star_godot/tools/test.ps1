#Requires -Version 5.1
<#
.SYNOPSIS
Runs the GUT tests of the Godot project headless.

.DESCRIPTION
Imports the project, then runs every tests\test_*.gd with GUT. Exit code 1 if Godot fails,
a test fails, or no test ran.
#>
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

Push-Location -LiteralPath $projectRoot
try {
    & $godot --headless --path . --import
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Godot import failed (exit code $LASTEXITCODE)."
        exit 1
    }

    $output = & $godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gprefix=test_ -gexit 2>&1 |
        ForEach-Object { $_.ToString() }
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { Write-Host $_ }

    if ($exitCode -ne 0) {
        Write-Host "Tests failed (Godot exit code $exitCode)."
        exit 1
    }
    $summary = $output | Select-String -Pattern '^\s*Tests\s+(\d+)\s*$' | Select-Object -Last 1
    $count = if ($summary) { [int]$summary.Matches[0].Groups[1].Value } else { 0 }
    if ($count -lt 1) {
        Write-Host 'No test ran.'
        exit 1
    }
    Write-Host "Tests passed: $count."
}
finally {
    Pop-Location
}
exit 0
