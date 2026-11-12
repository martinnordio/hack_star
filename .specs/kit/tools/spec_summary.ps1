# Shared by the git-host tools: put a summary between the spec-summary markers of a description.
# Works in Windows PowerShell 5.1 and PowerShell 7.

$script:SpecSummaryStart = '<!-- spec-summary:start -->'
$script:SpecSummaryEnd = '<!-- spec-summary:end -->'

function Set-SpecSummary {
    param([string]$Body, [string]$Summary)
    $block = "$SpecSummaryStart`n$($Summary.Trim())`n$SpecSummaryEnd"
    if (-not $Body -or -not $Body.Trim()) { return $block }
    $start = $Body.IndexOf($SpecSummaryStart)
    $end = $Body.IndexOf($SpecSummaryEnd)
    if ($start -ge 0 -and $end -gt $start) {
        return $Body.Substring(0, $start) + $block + $Body.Substring($end + $SpecSummaryEnd.Length)
    }
    return $Body.TrimEnd() + "`n`n" + $block
}

function Read-Utf8 {
    param([string]$Path)
    [IO.File]::ReadAllText((Resolve-Path $Path).Path, [Text.Encoding]::UTF8)
}

function Write-Utf8 {
    param([string]$Path, [string]$Text)
    [IO.File]::WriteAllText($Path, $Text, (New-Object Text.UTF8Encoding $false))
}
