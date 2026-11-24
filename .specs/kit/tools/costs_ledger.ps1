<#
.SYNOPSIS
  Rebuild .specs/costs.md (tokens and cost of every spec) from the Stage logs of the specs.
.EXAMPLE
  ./costs_ledger.ps1
  ./costs_ledger.ps1 -CostsLink ../stages/COSTS.md -DryRun
#>
param(
    [string] $Root = '.',
    [string] $CostsLink,
    [switch] $DryRun
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$inv = [Globalization.CultureInfo]::InvariantCulture
$dash = [string][char]0x2014
$dot = ' ' + [char]0x00B7 + ' '

# The kit's, the project's and the developer's settings, the later winning (settings.ps1).
. (Join-Path $PSScriptRoot 'settings.ps1')
$settings = Get-SpecNxSettings -Root $Root
foreach ($w in $settings.Warnings) { [Console]::Error.WriteLine("warning: $w") }
$costBlock = Get-SpecNxValue $settings 'cost'
if ($costBlock -isnot [System.Collections.IDictionary]) { Write-Output 'Cost tracking is off: no cost block in the settings (.specs/spec-nx.json).'; return }
$cost = @{}
foreach ($k in $costBlock.Keys) { $cost[$k] = $costBlock[$k] }
if ($cost.ContainsKey('enabled') -and -not $cost['enabled']) { Write-Output 'Cost tracking is off: cost.enabled is false.'; return }
$currency = if ($cost['currency']) { $cost['currency'] } else { 'USD' }

if (-not $CostsLink -and (Test-Path (Join-Path $Root 'stages/COSTS.md'))) { $CostsLink = '../stages/COSTS.md' }
if (-not $CostsLink) {
    $kitDir = Get-SpecNxValue $settings 'kit_dir'
    $kit = if ($kitDir) { "$kitDir".TrimEnd('/') } else { '.specs/kit' }
    if ($kit.StartsWith('.specs/')) { $CostsLink = $kit.Substring(7) + '/COSTS.md' }
    elseif ($kit -eq '.' -or $kit -eq '') { $CostsLink = '../COSTS.md' }
    else { $CostsLink = '../' + ($kit -replace '^\./', '') + '/COSTS.md' }
}

function Format-Tokens([double] $n) {
    if ($n -ge 1e6) { return ($n / 1e6).ToString('0.00', $inv) + ' M' }
    return ([math]::Round($n / 1000)).ToString('#,0', $inv) + ' k'
}
# A cell holds @(tokens, amount, credits, estimated, measured, included): estimated numbers get '~'.
function Format-Cell($v) {
    if ($null -eq $v) { return 'N/A' }
    if (-not $v[3] -and -not $v[4]) { return $(if ($v[5]) { 'included' } else { 'N/A' }) }
    $tilde = if ($v[3]) { '~' } else { '' }
    return $tilde + (Format-Tokens $v[0]) + $dot + $tilde + $currency + ' ' + ([math]::Round($v[1], 2)).ToString('0.00', $inv)
}
function Add-Cell($into, $from) {
    for ($i = 0; $i -lt 3; $i++) { $into[$i] += $from[$i] }
    for ($i = 3; $i -lt 6; $i++) { $into[$i] = $into[$i] -or $from[$i] }
}
function Format-Credits([double] $n) {
    $r = [math]::Round($n)
    return $r.ToString('0', $inv) + $(if ($r -eq 1) { ' credit' } else { ' credits' })
}
function Get-Tokens([string] $text) {
    $m = [regex]::Match($text, '([0-9][0-9,]*(?:\.[0-9]+)?)\s*([kM])')
    if (-not $m.Success) { return $null }
    $f = if ($m.Groups[2].Value -ceq 'M') { 1e6 } else { 1e3 }
    return [double]::Parse($m.Groups[1].Value.Replace(',', ''), $inv) * $f
}

$specsDir = (Resolve-Path (Join-Path $Root '.specs')).Path
$files = @()
foreach ($d in (Join-Path $specsDir 'features'), (Join-Path $specsDir 'features/done')) {
    if (Test-Path -LiteralPath $d) { $files += Get-ChildItem -LiteralPath $d -Filter '*_spec.md' -File }
}
$names = [string[]]($files | ForEach-Object { $_.Name })
$order = [string[]]($files | ForEach-Object { $_.FullName })
if ($files.Count) { [Array]::Sort($names, $order, [StringComparer]::Ordinal) }

$specs = @()
foreach ($path in $order) {
    $lines = [IO.File]::ReadAllLines($path, [Text.Encoding]::UTF8)
    $titleLine = $lines | Where-Object { $_.StartsWith('# ') } | Select-Object -First 1
    $title = if ($titleLine) { $titleLine.Substring(2).Trim() } else { [IO.Path]::GetFileName($path) }
    $title = $title -replace '\s+Spec$', ''
    $statusLine = $lines | Where-Object { $_.Contains('**Status:**') } | Select-Object -First 1
    $status = if ($statusLine) { ($statusLine -split '\*\*Status:\*\*', 2)[1].Trim() } else { '' }
    $status = ($status -split (' ' + $dash + ' '))[0]
    $slash = $path.Replace('\', '/')
    $rel = $slash.Substring($slash.LastIndexOf('/.specs/') + 8)
    $spec = @{ title = $title; status = $status; path = $rel; stages = [ordered]@{}; steps = @(); tracked = $false }
    $head = $null
    foreach ($line in $lines) {
        if ($line.StartsWith('| Date | Stage |')) {
            $cells = $line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }
            $head = @{}
            for ($i = 0; $i -lt $cells.Count; $i++) { $key = ($cells[$i] -split ' ')[0]; if (-not $head.ContainsKey($key)) { $head[$key] = $i } }
            if (-not $head.ContainsKey('Tokens') -or -not $head.ContainsKey('Cost')) { $head = $null }
            continue
        }
        if ($null -eq $head) { continue }
        if (-not $line.StartsWith('|')) { $head = $null; continue }
        $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
        if ($cells.Count -le ($head.Values | Measure-Object -Maximum).Maximum -or $cells[0] -match '^[-: ]*$') { continue }
        $stage = $cells[$head['Stage']]
        $key = if (@('requirements', 'plan', 'implementation', 'review', 'pr') -contains $stage) { $stage } else { 'other' }
        # A row whose numbers are counted in another spec ("included in <spec>", COSTS.md).
        if ($cells[$head['Tokens']] -match '^included in' -or $cells[$head['Cost']] -match '^included in') {
            $spec.tracked = $true
            if (-not $spec.stages.Contains($key)) { $spec.stages[$key] = @(0.0, 0.0, 0.0, $false, $false, $false) }
            $spec.stages[$key][5] = $true
            continue
        }
        $n = Get-Tokens $cells[$head['Tokens']]
        if ($null -eq $n) { continue }
        $estimated = $cells[$head['Tokens']].StartsWith('~') -or $cells[$head['Cost']].StartsWith('~')
        $money = [regex]::Match($cells[$head['Cost']], '([A-Z]{3})\s*([0-9]+(?:\.[0-9]+)?)')
        $cr = [regex]::Match($cells[$head['Cost']], '([0-9][0-9,]*(?:\.[0-9]+)?)\s*credits?')
        $value = if ($money.Success) { [double]::Parse($money.Groups[2].Value, $inv) } else { 0.0 }
        $credits = if ($cr.Success) { [double]::Parse($cr.Groups[1].Value.Replace(',', ''), $inv) } else { 0.0 }
        $cur = if ($money.Success) { $money.Groups[1].Value } else { $currency }
        $spec.tracked = $true
        if (-not $spec.stages.Contains($key)) { $spec.stages[$key] = @(0.0, 0.0, 0.0, $false, $false, $false) }
        Add-Cell $spec.stages[$key] @($n, $value, $credits, $estimated, (-not $estimated), $false)
        if ($head.ContainsKey('Note') -and $stage -eq 'implementation') {
            $step = [regex]::Match($cells[$head['Note']], 'Step (\d+)')
            if ($step.Success) { $model = if ($head.ContainsKey('Model')) { $cells[$head['Model']] } else { '' }; $spec.steps += , @($step.Groups[1].Value, $n, $value, $credits, $cur, $model, $estimated) }
        }
    }
    $specs += $spec
}

$grand = @(0.0, 0.0, 0.0, $false, $false, $false)
$rows = @()
foreach ($spec in $specs) {
    if ($spec.tracked) {
        $t = @(0.0, 0.0, 0.0, $false, $false, $false)
        foreach ($v in $spec.stages.Values) { Add-Cell $t $v }
        Add-Cell $grand $t
        $parts = foreach ($x in 'requirements', 'plan', 'implementation', 'review', 'pr', 'other') {
            if ($spec.stages.Contains($x)) { Format-Cell $spec.stages[$x] } else { $dash }
        }
    } else {
        $t = $null
        $parts = @('N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A')
    }
    $rows += "| [$($spec.title)]($($spec.path)) | $($spec.status) | $($parts -join ' | ') | $(Format-Cell $t) |"
}

$today = (Get-Date).ToString('yyyy-MM-dd', $inv)
$out = @('# Cost of the specs', '',
    "> Estimate $dash see [COSTS.md]($CostsLink). **All costs are estimates and may be wrong.** Rebuilt by",
    "> ``costs_ledger`` from the Stage logs on $today; do not edit by hand.", '',
    ('**All specs: ' + (Format-Cell $grand) + ' (' + (Format-Credits $grand[2]) + ')**'), '',
    '| Spec | Status | Requirements | Plan | Implementation | Review | PR | Other | Total |',
    '|------|--------|--------------|------|----------------|--------|----|-------|-------|')
$out += $rows
$out += "| **All specs** | | | | | | | | **$(Format-Cell $grand)** |"
if ($grand[3] -and $grand[4]) {
    $out += '', "> This list mixes measured and estimated (``~``) numbers; they come from different methods $dash see [COSTS.md]($CostsLink)."
}
$stepRows = New-Object System.Collections.ArrayList
foreach ($spec in $specs) { foreach ($st in $spec.steps) { [void]$stepRows.Add(@($spec.title, $st)) } }
if ($stepRows.Count) {
    $out += '', '## Implementation by Step', '', '| Spec | Step | Model | Tokens | Cost |', '|------|------|-------|--------|------|'
    foreach ($r in $stepRows) {
        $st = $r[1]
        $tilde = if ($st[6]) { '~' } else { '' }
        $out += "| $($r[0]) | $($st[0]) | $($st[5]) | $tilde$(Format-Tokens $st[1]) | $tilde$($st[4]) $(([math]::Round($st[2], 2)).ToString('0.00', $inv)) ($(Format-Credits $st[3])) |"
    }
}
$text = ($out -join "`n") + "`n"
if ($DryRun) { Write-Output $text.TrimEnd("`n"); return }
[IO.File]::WriteAllText((Join-Path $specsDir 'costs.md'), $text, (New-Object Text.UTF8Encoding $false))
Write-Output ("Wrote .specs/costs.md: {0} specs, {1}" -f $specs.Count, (Format-Cell $grand))
