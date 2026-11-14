# Shared by the git-host tools: put a text between named markers of a description
# ([//]: # (spec-summary:start) ... [//]: # (spec-summary:end), the same for semantic-diff).
# Azure DevOps drops HTML comments from work items; older <!-- name:start --> markers are still found.
# Works in Windows PowerShell 5.1 and PowerShell 7.

function Set-MarkedBlock {
    param([string]$Body, [string]$Name, [string]$Text)
    $block = "[//]: # ($($Name):start)`n`n$($Text.Trim())`n`n[//]: # ($($Name):end)"
    if (-not $Body -or -not $Body.Trim()) { return $block }
    $pairs = @(
        @("[//]: # ($($Name):start)", "[//]: # ($($Name):end)"),
        @("<!-- $($Name):start -->", "<!-- $($Name):end -->")
    )
    foreach ($pair in $pairs) {
        $start = $Body.IndexOf($pair[0])
        $end = $Body.IndexOf($pair[1])
        if ($start -ge 0 -and $end -gt $start) {
            $before = $Body.Substring(0, $start).TrimEnd()
            $after = $Body.Substring($end + $pair[1].Length).TrimStart()
            if ($before) { $before += "`n`n" }
            if ($after) { $after = "`n`n" + $after }
            return $before + $block + $after
        }
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
