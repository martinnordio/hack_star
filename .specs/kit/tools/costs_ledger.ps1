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

function Read-Settings([string] $path) {
    if (Test-Path $path) { return Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json }
    return $null
}
$project = Read-Settings (Join-Path $Root '.specs/spec-nx.json')
$local = Read-Settings (Join-Path $Root '.specs/spec-nx.local.json')
$hasProject = $project -and $project.PSObject.Properties['cost'] -and $project.cost
$hasLocal = $local -and $local.PSObject.Properties['cost'] -and $local.cost
if (-not $hasProject -and -not $hasLocal) { Write-Output 'Cost tracking is off: no cost block in .specs/spec-nx.json.'; return }
$cost = @{}
foreach ($block in @($(if ($hasProject) { $project.cost }), $(if ($hasLocal) { $local.cost }))) {
    if ($block) { foreach ($p in $block.PSObject.Properties) { $cost[$p.Name] = $p.Value } }
}
if ($cost.ContainsKey('enabled') -and -not $cost['enabled']) { Write-Output 'Cost tracking is off: cost.enabled is false.'; return }
$currency = if ($cost['currency']) { $cost['currency'] } else { 'USD' }

if (-not $CostsLink -and (Test-Path (Join-Path $Root 'stages/COSTS.md'))) { $CostsLink = '../stages/COSTS.md' }
if (-not $CostsLink) {
    $kit = if ($project -and $project.PSObject.Properties['kit_dir'] -and $project.kit_dir) { "$($project.kit_dir)".TrimEnd('/') } else { '.specs/kit' }
    if ($kit.StartsWith('.specs/')) { $CostsLink = $kit.Substring(7) + '/COSTS.md' }
    elseif ($kit -eq '.' -or $kit -eq '') { $CostsLink = '../COSTS.md' }
    else { $CostsLink = '../' + ($kit -replace '^\./', '') + '/COSTS.md' }
}

function Format-Tokens([double] $n) {
    if ($n -ge 1e6) { return ($n / 1e6).ToString('0.00', $inv) + ' M' }
    return ([math]::Round($n / 1000)).ToString('#,0', $inv) + ' k'
}
function Format-Cell($v) {
    if ($null -eq $v) { return 'N/A' }
    return '~' + (Format-Tokens $v[0]) + $dot + '~' + $currency + ' ' + ([math]::Round($v[1], 2)).ToString('0.00', $inv)
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
        $n = Get-Tokens $cells[$head['Tokens']]
        if ($null -eq $n) { continue }
        $money = [regex]::Match($cells[$head['Cost']], '([A-Z]{3})\s*([0-9]+(?:\.[0-9]+)?)')
        $cr = [regex]::Match($cells[$head['Cost']], '([0-9][0-9,]*(?:\.[0-9]+)?)\s*credits?')
        $value = if ($money.Success) { [double]::Parse($money.Groups[2].Value, $inv) } else { 0.0 }
        $credits = if ($cr.Success) { [double]::Parse($cr.Groups[1].Value.Replace(',', ''), $inv) } else { 0.0 }
        $cur = if ($money.Success) { $money.Groups[1].Value } else { $currency }
        $spec.tracked = $true
        $stage = $cells[$head['Stage']]
        $key = if (@('requirements', 'plan', 'implementation', 'review', 'pr') -contains $stage) { $stage } else { 'other' }
        if (-not $spec.stages.Contains($key)) { $spec.stages[$key] = @(0.0, 0.0, 0.0) }
        $s = $spec.stages[$key]; $s[0] += $n; $s[1] += $value; $s[2] += $credits
        if ($head.ContainsKey('Note') -and $stage -eq 'implementation') {
            $step = [regex]::Match($cells[$head['Note']], 'Step (\d+)')
            if ($step.Success) { $model = if ($head.ContainsKey('Model')) { $cells[$head['Model']] } else { '' }; $spec.steps += , @($step.Groups[1].Value, $n, $value, $credits, $cur, $model) }
        }
    }
    $specs += $spec
}

$grand = @(0.0, 0.0, 0.0)
$rows = @()
foreach ($spec in $specs) {
    if ($spec.tracked) {
        $t = @(0.0, 0.0, 0.0)
        foreach ($v in $spec.stages.Values) { for ($i = 0; $i -lt 3; $i++) { $t[$i] += $v[$i] } }
        for ($i = 0; $i -lt 3; $i++) { $grand[$i] += $t[$i] }
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
    ('**All specs: ~' + (Format-Tokens $grand[0]) + $dot + '~' + $currency + ' ' + ([math]::Round($grand[1], 2)).ToString('0.00', $inv) + ' (' + (Format-Credits $grand[2]) + ')**'), '',
    '| Spec | Status | Requirements | Plan | Implementation | Review | PR | Other | Total |',
    '|------|--------|--------------|------|----------------|--------|----|-------|-------|')
$out += $rows
$out += "| **All specs** | | | | | | | | **$(Format-Cell $grand)** |"
$stepRows = New-Object System.Collections.ArrayList
foreach ($spec in $specs) { foreach ($st in $spec.steps) { [void]$stepRows.Add(@($spec.title, $st)) } }
if ($stepRows.Count) {
    $out += '', '## Implementation by Step', '', '| Spec | Step | Model | Tokens | Cost |', '|------|------|-------|--------|------|'
    foreach ($r in $stepRows) {
        $st = $r[1]
        $out += "| $($r[0]) | $($st[0]) | $($st[5]) | ~$(Format-Tokens $st[1]) | ~$($st[4]) $(([math]::Round($st[2], 2)).ToString('0.00', $inv)) ($(Format-Credits $st[3])) |"
    }
}
$text = ($out -join "`n") + "`n"
if ($DryRun) { Write-Output $text.TrimEnd("`n"); return }
[IO.File]::WriteAllText((Join-Path $specsDir 'costs.md'), $text, (New-Object Text.UTF8Encoding $false))
Write-Output ("Wrote .specs/costs.md: {0} specs, ~{1}, ~{2} {3}" -f $specs.Count, (Format-Tokens $grand[0]), $currency, ([math]::Round($grand[1], 2)).ToString('0.00', $inv))
