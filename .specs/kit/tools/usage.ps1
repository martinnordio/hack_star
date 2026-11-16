<#
.SYNOPSIS
  Tokens and cost of a time range of the AI chat, by the method of COSTS.md.
.EXAMPLE
  ./usage.ps1 -Since "2026-11-16 08:55" -Model "Claude Opus 5.5"
  ./usage.ps1 -Since 2026-11-16T07:55:00Z -Until 2026-11-16T08:10:00Z -Model "Claude Opus 5.5" -Json
#>
param(
    [Parameter(Mandatory)] [string] $Since,
    [Parameter(Mandatory)] [string] $Model,
    [string] $Until,
    [string] $Transcript,
    [string] $Root = '.',
    [int] $ContextCap = 200000,
    [switch] $Json
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$inv = [Globalization.CultureInfo]::InvariantCulture

function Read-Settings([string] $path) {
    if (Test-Path $path) { return Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json }
    return $null
}
function To-Utc([string] $text) {
    $d = [datetime]::Parse($text.Trim(), $inv, [Globalization.DateTimeStyles]::AssumeLocal)
    return $d.ToUniversalTime().ToString("yyyy-MM-dd'T'HH:mm:ss.fff'Z'", $inv)
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

$sinceUtc = To-Utc $Since
$untilUtc = if ($Until) { To-Utc $Until } else { '9999' }

if (-not $Transcript) {
    $found = @()
    $bases = @($env:APPDATA, (Join-Path $HOME '.config'), (Join-Path $HOME 'Library/Application Support')) | Where-Object { $_ }
    foreach ($b in $bases) {
        foreach ($app in 'Code', 'Code - Insiders') {
            $dir = Join-Path $b "$app/User/workspaceStorage"
            if (Test-Path -LiteralPath $dir) {
                $found += Get-ChildItem -LiteralPath $dir -Directory | ForEach-Object {
                    $t = Join-Path $_.FullName 'GitHub.copilot-chat/transcripts'
                    if (Test-Path -LiteralPath $t) { Get-ChildItem -LiteralPath $t -Filter *.jsonl -File }
                }
            }
        }
    }
    $slug = (Resolve-Path $Root).Path -replace '[^A-Za-z0-9]', '-'
    $claude = Join-Path $HOME ".claude/projects/$slug"
    if (Test-Path -LiteralPath $claude) { $found += Get-ChildItem -LiteralPath $claude -Filter *.jsonl -File }
    if (-not $found) { throw 'No chat transcript found; pass -Transcript <file>.' }
    $Transcript = ($found | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
}

$Transcript = (Resolve-Path -LiteralPath $Transcript).Path
$lines = [IO.File]::ReadAllLines($Transcript, [Text.Encoding]::UTF8)
$vscode = $lines.Count -gt 0 -and $lines[0].StartsWith('{"type":"session.start"')

function Get-Stamp([string] $raw) {
    $i = $raw.LastIndexOf('"timestamp":"')
    if ($i -lt 0) { return '' }
    return $raw.Substring($i + 13, $raw.IndexOf('"', $i + 13) - $i - 13)
}
function Get-Size([string] $raw) {
    $s = $raw.IndexOf('"data":'); $e = $raw.LastIndexOf(',"id":"')
    if ($s -lt 0 -or $e -le $s) { return 0 }
    return [math]::Floor(($e - $s - 7) / 4)
}
function Get-Num([string] $raw, [string] $key) {
    $m = [regex]::Match($raw, '"' + $key + '":(\d+)')
    if ($m.Success) { return [long]$m.Groups[1].Value }
    return 0
}

$t = @{ requests = 0; input = [long]0; cached = [long]0; output = [long]0 }
if ($vscode) {
    $base = if ($cost.ContainsKey('base_tokens')) { [long]$cost['base_tokens'] } else { 35000 }
    $context = [long]$base; $previous = $null
    foreach ($raw in $lines) {
        $kind = if ($raw.StartsWith('{"type":"')) { $raw.Substring(9, $raw.IndexOf('"', 9) - 9) } else { '' }
        $ts = Get-Stamp $raw
        $n = [long](Get-Size $raw)
        $inside = ([string]::CompareOrdinal($ts, $sinceUtc) -ge 0) -and ([string]::CompareOrdinal($ts, $untilUtc) -lt 0)
        if ($kind -eq 'assistant.turn_start') {
            if ($context -gt $ContextCap) { $context = [long]$base; $previous = $null }
            if ($inside) {
                $c = if ($null -ne $previous) { $previous } else { 0 }
                $t.requests++; $t.cached += $c; $t.input += $context - $c
            }
            $previous = $context
        } elseif ($kind -eq 'assistant.message' -and $inside) {
            $t.output += $n
        }
        $context += $n
    }
} else {
    $seen = @{}
    foreach ($raw in $lines) {
        if (-not $raw.Contains('"type":"assistant"') -or -not $raw.Contains('"usage"')) { continue }
        $ts = Get-Stamp $raw
        if ([string]::CompareOrdinal($ts, $sinceUtc) -lt 0 -or [string]::CompareOrdinal($ts, $untilUtc) -ge 0) { continue }
        $m = [regex]::Match($raw, '"id":"(msg_[^"]+)"')
        if ($m.Success) {
            if ($seen.ContainsKey($m.Groups[1].Value)) { continue }
            $seen[$m.Groups[1].Value] = $true
        }
        $t.requests++
        $t.input += (Get-Num $raw 'input_tokens') + (Get-Num $raw 'cache_creation_input_tokens')
        $t.cached += Get-Num $raw 'cache_read_input_tokens'
        $t.output += Get-Num $raw 'output_tokens'
    }
}

function Get-Prices {
    $sid = [IO.Path]::GetFileNameWithoutExtension($Transcript)
    $models = Join-Path (Split-Path (Split-Path $Transcript -Parent) -Parent) "debug-logs/$sid/models.json"
    if ($vscode -and (Test-Path -LiteralPath $models)) {
        foreach ($m in (Get-Content -LiteralPath $models -Raw -Encoding UTF8 | ConvertFrom-Json)) {
            if (@("$($m.name)".ToLower(), "$($m.id)".ToLower()) -notcontains $Model.ToLower()) { continue }
            if (-not $m.billing -or -not $m.billing.token_prices) { continue }
            $tp = $m.billing.token_prices; $d = $tp.default
            $batch = if ($tp.batch_size) { $tp.batch_size } else { 1000000 }
            $scale = 1000000 / $batch
            $cw = if ($null -ne $d.cache_write_price) { $d.cache_write_price } else { $d.input_price }
            return @{ input = $d.input_price * $scale; cache_write = $cw * $scale; cached = $d.cache_read_price * $scale; output = $d.output_price * $scale }
        }
    }
    if ($cost['prices']) {
        foreach ($p in $cost['prices'].PSObject.Properties) {
            if ($p.Name.ToLower() -ne $Model.ToLower()) { continue }
            $v = $p.Value
            $cw = if ($null -ne $v.cache_write) { $v.cache_write } else { $v.input }
            return @{ input = $v.input; cache_write = $cw; cached = $v.cached; output = $v.output }
        }
    }
    throw "No price for `"$Model`": add it to cost.prices in .specs/spec-nx.json."
}

$pr = Get-Prices
$credits = ($t.input * $pr.cache_write + $t.cached * $pr.cached + $t.output * $pr.output) / 1000000
$usd = $credits / 100
$currency = if ($cost['currency']) { $cost['currency'] } else { 'USD' }
$rate = if ($cost['rate']) { [double]$cost['rate'] } else { 1.0 }
$localAmount = $usd * $rate
$share = if ($cost['monthly_credits']) { $credits / [double]$cost['monthly_credits'] * 100 } else { $null }
$total = $t.input + $t.cached + $t.output
$source = if ($vscode) { 'estimated' } else { 'measured' }

if ($Json) {
    [ordered]@{
        source = $source; transcript = $Transcript; model = $Model
        requests = $t.requests; input = $t.input; cached = $t.cached; output = $t.output; total = $total
        credits = [math]::Round($credits, 4); usd = [math]::Round($usd, 4); currency = $currency
        local = [math]::Round($localAmount, 4)
        share_percent = $(if ($null -ne $share) { [math]::Round($share, 4) } else { $null })
        plan = $cost['plan']
    } | ConvertTo-Json -Compress
    return
}

function Format-Tokens([double] $n) {
    if ($n -ge 1e6) { return ($n / 1e6).ToString('0.00', $inv) + ' M' }
    return ([math]::Round($n / 1000)).ToString('#,0', $inv) + ' k'
}
$tilde = if ($vscode) { '~' } else { '' }
$dot = ' ' + [char]0x00B7 + ' '
Write-Output ("Tokens: {0}{1} ({2} in{3}{4} cached{3}{5} out)" -f $tilde, (Format-Tokens $total), (Format-Tokens $t.input), $dot, (Format-Tokens $t.cached), (Format-Tokens $t.output))
$planText = if ($null -ne $share) { ', ' + $share.ToString('0.0', $inv) + ' % of ' + $(if ($cost['plan']) { $cost['plan'] } else { 'the plan' }) } else { '' }
$creditsRounded = [math]::Round($credits)
$creditsWord = if ($creditsRounded -eq 1) { 'credit' } else { 'credits' }
Write-Output ("Cost: {0}{1} {2} ({3} {4}{5})" -f $tilde, $currency, ([math]::Round($localAmount, 2)).ToString('0.00', $inv), $creditsRounded.ToString('0', $inv), $creditsWord, $planText)
Write-Output ("Source: {0} from {1}{2}{3} requests" -f $source, $Transcript, $dot, $t.requests)
