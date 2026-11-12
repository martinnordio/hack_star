<#
.SYNOPSIS
  Put a spec summary into the spec-summary block of a GitHub issue; text outside the block is kept.
.EXAMPLE
  ./update_issue.ps1 -Issue 1 -SummaryFile summary.md -DryRun
#>
param(
    [Parameter(Mandatory)] [int] $Issue,
    [Parameter(Mandatory)] [string] $SummaryFile,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')

$body = (gh issue view $Issue --json body -q .body | Out-String)
if ($LASTEXITCODE -ne 0) { throw "gh could not read issue #$Issue" }
$new = Set-SpecSummary -Body $body.TrimEnd() -Summary (Read-Utf8 $SummaryFile)

if ($DryRun) {
    Write-Output "Would update issue #$($Issue) to:"
    Write-Output $new
    return
}
$tmp = New-TemporaryFile
try {
    Write-Utf8 $tmp.FullName $new
    gh issue edit $Issue --body-file $tmp.FullName
    if ($LASTEXITCODE -ne 0) { throw "gh could not update issue #$Issue" }
} finally {
    Remove-Item $tmp -ErrorAction SilentlyContinue
}
