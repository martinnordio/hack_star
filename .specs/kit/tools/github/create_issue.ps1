<#
.SYNOPSIS
  Create a GitHub issue whose description is a spec summary (in the spec-summary block), and
  optionally make it a sub-issue of a parent issue. Its type and the person it is assigned to
  come from the parameters or the settings (work_items.type, .assigned_to); by default it is
  assigned to you (@me), and work_items.assigned_to = null leaves it unassigned. Every field is
  checked before the issue is created; the dry run lists them with where they come from.
  Prints the new issue number.
.EXAMPLE
  ./create_issue.ps1 -Title "Login page" -SummaryFile summary.md -Parent 12 -DryRun
  ./create_issue.ps1 -Title "Login page" -SummaryFile summary.md -Type Feature -AssignedTo octocat -DryRun
#>
param(
    [Parameter(Mandatory)] [string] $Title,
    [Parameter(Mandatory)] [string] $SummaryFile,
    [int] $Parent,
    [string] $Type,
    [string] $AssignedTo,
    [switch] $Unassigned,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
. (Join-Path $PSScriptRoot '..\spec_summary.ps1')
. (Join-Path $PSScriptRoot '..\settings.ps1')

$settings = Get-SpecNxSettings -Root (git rev-parse --show-toplevel | Out-String).Trim()
foreach ($w in $settings.Warnings) { [Console]::Error.WriteLine("warning: $w") }

# A field from the parameter, else from the settings; with the place it comes from.
function Resolve-Field([string] $given, [string] $key) {
    if ($given) { return @{ value = $given; from = 'parameter' } }
    $v = Get-SpecNxValue $settings $key
    $src = Get-SpecNxSource $settings $key
    if ($v) { return @{ value = "$v"; from = "$key in $src" } }
    return @{ value = $null; from = $src }
}

$repoInfo = (gh repo view --json owner,isInOrganization,nameWithOwner | Out-String) | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'gh could not read this repository.' }
$owner = $repoInfo.owner.login

$typeField = Resolve-Field $Type 'work_items.type'
if ($typeField.value) {
    if (-not $repoInfo.isInOrganization) {
        throw "The issue type '$($typeField.value)' ($($typeField.from)) cannot be set: issue types exist only in organizations, and '$owner' is a user account."
    }
    $types = @(gh api "orgs/$owner/issue-types" --jq '.[].name')
    if ($LASTEXITCODE -ne 0) { throw "gh could not read the issue types of '$owner'." }
    $match = $types | Where-Object { $_ -eq $typeField.value }
    if (-not $match) { throw "The issue type '$($typeField.value)' ($($typeField.from)) is not a type of '$owner': $($types -join ', ')." }
}

$assigned = Resolve-Field $AssignedTo 'work_items.assigned_to'
if ($Unassigned -or (-not $assigned.value -and $assigned.from -like '* (removed)')) {
    $assigned = @{ value = $null; from = $(if ($Unassigned) { 'parameter -Unassigned' } else { "work_items.assigned_to = null in $($assigned.from -replace ' \(removed\)$', '')" }) }
} elseif (-not $assigned.value -or $assigned.value -eq '@me') {
    $login = (gh api user --jq .login | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or -not $login) { throw 'gh could not find the signed-in user; set work_items.assigned_to, or null to leave the issue unassigned.' }
    $assigned = @{ value = $login; from = $(if ($assigned.value) { $assigned.from } else { 'default: you (@me)' }) }
} else {
    # Windows PowerShell 5.1 turns stderr of a native command into an error with Stop; probe with Continue.
    $canAssign = & { $ErrorActionPreference = 'Continue'; gh api "repos/$($repoInfo.nameWithOwner)/assignees/$($assigned.value)" --silent 2>&1 | Out-Null; $LASTEXITCODE -eq 0 }
    if (-not $canAssign) { throw "'$($assigned.value)' ($($assigned.from)) cannot be assigned issues in $($repoInfo.nameWithOwner)." }
}

$body = Set-SpecSummary -Body '' -Summary (Read-Utf8 $SummaryFile)
if ($Parent) {
    $parentTitle = (gh issue view $Parent --json title --jq .title | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "gh could not read the parent issue #$Parent" }
}
if ($DryRun) {
    Write-Output "Would create issue '$Title' in $($repoInfo.nameWithOwner) with:"
    Write-Output "  Parent:      $(if ($Parent) { "#$Parent '$parentTitle' (as a sub-issue)" } else { '-' })"
    Write-Output "  Type:        $(if ($typeField.value) { "$($typeField.value)   ($($typeField.from))" } else { '-' })"
    Write-Output "  Assigned to: $(if ($assigned.value) { "$($assigned.value)   ($($assigned.from))" } else { "-   ($($assigned.from))" })"
    Write-Output 'Description:'
    Write-Output $body
    return
}
$tmp = New-TemporaryFile
try {
    Write-Utf8 $tmp.FullName $body
    $create = @('issue', 'create', '--title', $Title, '--body-file', $tmp.FullName)
    if ($assigned.value) { $create += @('--assignee', $assigned.value) }
    $url = (gh @create | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw 'gh could not create the issue.' }
} finally {
    Remove-Item $tmp -ErrorAction SilentlyContinue
}
$number = [int]($url -replace '^.*/', '')
if ($typeField.value) {
    gh api -X PATCH "repos/$($repoInfo.nameWithOwner)/issues/$number" -f "type=$($typeField.value)" --silent
    if ($LASTEXITCODE -ne 0) { throw "Created issue #$number, but could not set its type '$($typeField.value)'." }
}
if ($Parent) {
    $id = (gh api "repos/{owner}/{repo}/issues/$number" --jq .id | Out-String).Trim()
    gh api -X POST "repos/{owner}/{repo}/issues/$Parent/sub_issues" -F "sub_issue_id=$id" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Created issue #$number, but could not add it under #$Parent." }
}
Write-Output $number
