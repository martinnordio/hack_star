<#
.SYNOPSIS
Lints and format-checks the GDScript of game\, scenes\ and tests\ (never addons\).

.DESCRIPTION
Runs gdlint and `gdformat --check` on the folders that exist. Exit code 1 if either fails.
#>
#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$gdtoolkit = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'versions.json') | ConvertFrom-Json).gdtoolkit
$folders = @('game', 'scenes', 'tests') |
    Where-Object { Test-Path -LiteralPath (Join-Path $projectRoot $_) }

Push-Location -LiteralPath $projectRoot
try {
    foreach ($tool in @('gdlint', 'gdformat')) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            Write-Host "$tool not found. Install: uv tool install gdtoolkit==$gdtoolkit"
            exit 1
        }
    }
    $failed = $false
    if ($folders) {
        & gdlint @folders
        if ($LASTEXITCODE -ne 0) { $failed = $true }
        & gdformat --check @folders
        if ($LASTEXITCODE -ne 0) { $failed = $true }
    }
    else {
        Write-Host 'No game, scenes or tests folder: nothing to lint.'
    }
}
finally {
    Pop-Location
}
if ($failed) {
    exit 1
}
Write-Host 'Lint OK.'
exit 0
