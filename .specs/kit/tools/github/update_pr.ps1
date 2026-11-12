<#
.SYNOPSIS
  Put a spec summary into the spec-summary block of the GitHub pull request of the current
  branch; creates the pull request if there is none (needs -Title). Text outside the block is kept.
.EXAMPLE
  ./update_pr.ps1 -SummaryFile summary.md -Title "Login page (#12)" -Issue 12 -Draft -DryRun
#>
param(
    [Parameter(Mandatory)] [string] $SummaryFile,
    [string] $Title,
    [int] $Issue,
    [switch] $Draft,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')

$branch = (git branch --show-current | Out-String).Trim()
if (-not $branch) { throw 'Not on a branch.' }
$summary = Read-Utf8 $SummaryFile

$number = (gh pr list --head $branch --state open --json number --jq '.[0].number' | Out-String).Trim()
if ($LASTEXITCODE -ne 0) { throw 'gh could not list pull requests.' }

if ($number) {
    $body = (gh pr view $number --json body -q .body | Out-String).TrimEnd()
    # A pull request opened by hand may not close the issue yet.
    if ($Issue -and $body -notmatch "(?i)\b(close[sd]?|fix(e[sd])?|resolve[sd]?) #$Issue\b") {
        $body = ("Closes #$Issue`n`n" + $body).TrimEnd()
    }
    $new = Set-SpecSummary -Body $body -Summary $summary
    if ($DryRun) {
        Write-Output "Would update pull request #$($number) to:"
        Write-Output $new
        return
    }
    $command = @('pr', 'edit', $number)
} else {
    if (-not $Title) { throw "No open pull request for '$branch' yet: pass -Title to create one." }
    $closes = if ($Issue) { "Closes #$Issue" } else { '' }
    $new = Set-SpecSummary -Body $closes -Summary $summary
    if ($DryRun) {
        $kind = if ($Draft) { 'draft pull request' } else { 'pull request' }
        Write-Output "Would create a $kind '$Title' from '$branch' with:"
        Write-Output $new
        return
    }
    if (-not (git ls-remote --heads origin $branch)) { throw "Push the branch first: git push -u origin $branch" }
    $command = @('pr', 'create', '--head', $branch, '--title', $Title)
    if ($Draft) { $command += '--draft' }
}

$tmp = New-TemporaryFile
try {
    Write-Utf8 $tmp.FullName $new
    gh @command --body-file $tmp.FullName
    if ($LASTEXITCODE -ne 0) { throw 'gh could not write the pull request.' }
} finally {
    Remove-Item $tmp -ErrorAction SilentlyContinue
}
