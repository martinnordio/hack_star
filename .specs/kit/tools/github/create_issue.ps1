<#
.SYNOPSIS
  Create a GitHub issue whose description is a spec summary (in the spec-summary block), and
  optionally make it a sub-issue of a parent issue. Prints the new issue number.
.EXAMPLE
  ./create_issue.ps1 -Title "Login page" -SummaryFile summary.md -Parent 12 -DryRun
#>
param(
    [Parameter(Mandatory)] [string] $Title,
    [Parameter(Mandatory)] [string] $SummaryFile,
    [int] $Parent,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')

$body = Set-SpecSummary -Body '' -Summary (Read-Utf8 $SummaryFile)
if ($Parent) {
    gh issue view $Parent --json number | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "gh could not read the parent issue #$Parent" }
}
if ($DryRun) {
    $under = if ($Parent) { " as a sub-issue of #$Parent" } else { '' }
    Write-Output "Would create issue '$Title'$under with:"
    Write-Output $body
    return
}
$tmp = New-TemporaryFile
try {
    Write-Utf8 $tmp.FullName $body
    $url = (gh issue create --title $Title --body-file $tmp.FullName | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw 'gh could not create the issue.' }
} finally {
    Remove-Item $tmp -ErrorAction SilentlyContinue
}
$number = [int]($url -replace '^.*/', '')
if ($Parent) {
    $id = (gh api "repos/{owner}/{repo}/issues/$number" --jq .id | Out-String).Trim()
    gh api -X POST "repos/{owner}/{repo}/issues/$Parent/sub_issues" -F "sub_issue_id=$id" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Created issue #$number, but could not add it under #$Parent." }
}
Write-Output $number
