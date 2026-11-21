<#
.SYNOPSIS
Shared helpers (Find-Godot, Write-GodotVersionWarning) for the scripts in tools\.

.DESCRIPTION
Dot-source it: . (Join-Path $PSScriptRoot 'godot.ps1')
#>


function Get-GodotVersionOf {
    param([string]$Path)
    $line = & $Path --version 2>$null | Select-Object -First 1
    if ($line) { return $line.ToString().Trim() }
    return ''
}

function Find-Godot {
    <#
    .SYNOPSIS
    Finds the Godot console executable. Returns $null when it is not found.

    .DESCRIPTION
    Candidates: $env:GODOT, `godot` on the PATH and the winget package folder. When several are
    installed, the one with the version pinned in tools\versions.json wins; otherwise the first
    candidate is returned (Write-GodotVersionWarning tells about the difference).
    #>
    [CmdletBinding()]
    param()

    if ($env:GODOT -and (Test-Path -LiteralPath $env:GODOT)) {
        return $env:GODOT
    }
    $candidates = @()
    $command = Get-Command godot -ErrorAction SilentlyContinue
    if ($command) {
        $candidates += $command.Source
    }
    $packages = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    if (Test-Path -LiteralPath $packages) {
        $candidates += @(
            Get-ChildItem -Path $packages -Recurse -Filter 'Godot_v*_win64_console.exe' -ErrorAction SilentlyContinue |
                ForEach-Object { $_.FullName }
        )
    }
    if ($candidates.Count -eq 0) {
        return $null
    }
    $pinned = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'versions.json') | ConvertFrom-Json).godot
    foreach ($candidate in $candidates) {
        if ((Get-GodotVersionOf $candidate) -like "$pinned.stable*") {
            return $candidate
        }
    }
    return $candidates[0]
}

function Write-GodotVersionWarning {
    <#
    .SYNOPSIS
    Warns when the Godot at $Path is not the version pinned in tools\versions.json.
    #>
    [CmdletBinding()]
    param([string]$Path)

    $pinned = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'versions.json') | ConvertFrom-Json).godot
    $actual = Get-GodotVersionOf $Path
    if ($actual -notlike "$pinned.stable*") {
        Write-Warning "Godot at $Path is '$actual', but tools\versions.json pins $pinned.stable."
    }
}
