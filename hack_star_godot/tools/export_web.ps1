#Requires -Version 5.1
<#
.SYNOPSIS
Exports the game for the web into build\web\.

.DESCRIPTION
Deletes build\web\, runs `godot --headless --export-release "Web" build/web/index.html` and
checks that index.html, a .wasm and a .pck exist. Exit code 1 if Godot fails or a file is missing.
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

$outputFolder = Join-Path $projectRoot 'build\web'
if (Test-Path -LiteralPath $outputFolder) {
    Remove-Item -LiteralPath $outputFolder -Recurse -Force
}
New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null

Push-Location -LiteralPath $projectRoot
try {
    & $godot --headless --path . --import
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Godot import failed (exit code $LASTEXITCODE)."
        exit 1
    }
    & $godot --headless --path . --export-release 'Web' 'build/web/index.html'
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Godot export failed (exit code $LASTEXITCODE). Are the export templates installed?"
        exit 1
    }
}
finally {
    Pop-Location
}

$missing = @()
if (-not (Test-Path -LiteralPath (Join-Path $outputFolder 'index.html'))) { $missing += 'index.html' }
if (-not (Get-ChildItem -LiteralPath $outputFolder -Filter '*.wasm' -File -ErrorAction SilentlyContinue)) { $missing += '*.wasm' }
if (-not (Get-ChildItem -LiteralPath $outputFolder -Filter '*.pck' -File -ErrorAction SilentlyContinue)) { $missing += '*.pck' }
if ($missing.Count -gt 0) {
    Write-Host ('Export incomplete, missing: ' + ($missing -join ', '))
    exit 1
}

Write-Host "Web export OK: $outputFolder"
Get-ChildItem -LiteralPath $outputFolder -File | ForEach-Object {
    Write-Host ('  {0} ({1:N0} bytes)' -f $_.Name, $_.Length)
}
exit 0
