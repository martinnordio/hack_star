# Shared by the scripts in tools\: dot-source it (. (Join-Path $PSScriptRoot 'godot.ps1')).

function Find-Godot {
    <#
    .SYNOPSIS
    Finds the Godot console executable: $env:GODOT, else `godot` on the PATH, else the winget package folder.
    Returns $null when it is not found.
    #>
    [CmdletBinding()]
    param()

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
