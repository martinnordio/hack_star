# Shared by the git-host tools: put a text between named markers of a description
# (<!-- spec-summary:start --> ... <!-- spec-summary:end -->, the same for semantic-diff).
# Works in Windows PowerShell 5.1 and PowerShell 7.

function Set-MarkedBlock {
    param([string]$Body, [string]$Name, [string]$Text)
    $startMarker = "<!-- $($Name):start -->"
    $endMarker = "<!-- $($Name):end -->"
    $block = "$startMarker`n$($Text.Trim())`n$endMarker"
    if (-not $Body -or -not $Body.Trim()) { return $block }
    $start = $Body.IndexOf($startMarker)
    $end = $Body.IndexOf($endMarker)
    if ($start -ge 0 -and $end -gt $start) {
        return $Body.Substring(0, $start) + $block + $Body.Substring($end + $endMarker.Length)
    }
    return $Body.TrimEnd() + "`n`n" + $block
}

function Set-SpecSummary {
    param([string]$Body, [string]$Summary)
    Set-MarkedBlock -Body $Body -Name 'spec-summary' -Text $Summary
}

function Set-SemanticDiff {
    param([string]$Body, [string]$Text)
    Set-MarkedBlock -Body $Body -Name 'semantic-diff' -Text $Text
}

function Read-Utf8 {
    param([string]$Path)
    [IO.File]::ReadAllText((Resolve-Path $Path).Path, [Text.Encoding]::UTF8)
}

function Write-Utf8 {
    param([string]$Path, [string]$Text)
    [IO.File]::WriteAllText($Path, $Text, (New-Object Text.UTF8Encoding $false))
}
