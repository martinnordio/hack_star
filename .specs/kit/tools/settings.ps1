<#
.SYNOPSIS
  The settings of spec-nx in three layers: the kit's (<kit>/.specs/spec-nx.json, when the kit
  is a repository of its own, e.g. a submodule), the project's (.specs/spec-nx.json) and the
  developer's (.specs/spec-nx.local.json). A later layer wins: a key replaces the same key,
  objects are merged key by key, lists are replaced as a whole, null removes the key. Keys that
  describe the generated kit are taken from the project's file only.
  Dot-source it for Get-SpecNxSettings, or run it to show the result.
.EXAMPLE
  ./settings.ps1                  # every setting with the file it comes from
  ./settings.ps1 -Get work_items.area
  ./settings.ps1 -Source work_items.assigned_to   # the file it comes from
  ./settings.ps1 -Json
#>
# No param block: dot-sourcing must not change the caller's variables. Arguments: see below.

$script:SpecNxProjectOnly = @('version', 'spec_nx_version', 'generated', 'kit', 'kit_dir', 'kit_ref', 'kit_files', 'shells')

function ConvertTo-SpecNxHash($value) {
    if ($value -is [System.Management.Automation.PSCustomObject]) {
        $h = [ordered]@{}
        foreach ($p in $value.PSObject.Properties) { $h[$p.Name] = ConvertTo-SpecNxHash $p.Value }
        return $h
    }
    if ($value -is [System.Collections.IList] -and $value -isnot [string]) {
        return , @($value | ForEach-Object { ConvertTo-SpecNxHash $_ })
    }
    return $value
}

function Read-SpecNxFile([string] $path) {
    if (-not $path -or -not (Test-Path -LiteralPath $path)) { return $null }
    $text = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8)
    if (-not $text.Trim()) { return [ordered]@{} }
    try { return ConvertTo-SpecNxHash ($text | ConvertFrom-Json) }
    catch { throw "$path is not valid JSON: $($_.Exception.Message)" }
}

function Merge-SpecNxLayer($into, $from, [string] $file, $sources, [string] $prefix) {
    foreach ($key in @($from.Keys)) {
        $path = if ($prefix) { "$prefix.$key" } else { $key }
        $value = $from[$key]
        if ($null -eq $value) {
            if ($into.Contains($key)) { $into.Remove($key) }
            foreach ($s in @($sources.Keys)) { if ($s -eq $path -or $s.StartsWith("$path.")) { $sources.Remove($s) } }
            $sources[$path] = "$file (removed)"
            continue
        }
        if ($value -is [System.Collections.IDictionary] -and $into.Contains($key) -and $into[$key] -is [System.Collections.IDictionary]) {
            Merge-SpecNxLayer $into[$key] $value $file $sources $path
            continue
        }
        foreach ($s in @($sources.Keys)) { if ($s.StartsWith("$path.")) { $sources.Remove($s) } }
        $into[$key] = $value
        if ($value -is [System.Collections.IDictionary]) {
            foreach ($k in $value.Keys) { $sources["$path.$k"] = $file }
        } else {
            $sources[$path] = $file
        }
    }
}

function Get-SpecNxSettings {
    <# Returns @{ Values; Sources; Files; Warnings }: the merged settings (ordered hashtable),
       for each key (dotted for objects) the file it comes from, the files read, and warnings. #>
    param([string] $Root = '.', [string] $KitDir)
    $rootPath = (Resolve-Path -LiteralPath $Root).Path
    if (-not $KitDir) { $KitDir = Split-Path $PSScriptRoot -Parent }
    $projectFile = Join-Path $rootPath '.specs/spec-nx.json'
    $localFile = Join-Path $rootPath '.specs/spec-nx.local.json'
    $kitFile = Join-Path $KitDir '.specs/spec-nx.json'
    if ((Test-Path -LiteralPath $kitFile) -and (Test-Path -LiteralPath $projectFile) -and
        ((Resolve-Path -LiteralPath $kitFile).Path -eq (Resolve-Path -LiteralPath $projectFile).Path)) { $kitFile = $null }

    $values = [ordered]@{}; $sources = [ordered]@{}; $files = @(); $warnings = @()
    $project = Read-SpecNxFile $projectFile
    $personal = $project -and $project.Contains('kit') -and $project['kit'] -eq 'personal'
    $layers = @(
        @{ name = 'kit'; file = $kitFile; data = (Read-SpecNxFile $kitFile) },
        @{ name = 'project'; file = $projectFile; data = $project },
        @{ name = 'developer'; file = $localFile; data = (Read-SpecNxFile $localFile) }
    )
    foreach ($layer in $layers) {
        if ($null -eq $layer.data) { continue }
        $files += $layer.file
        $data = [ordered]@{}
        foreach ($k in $layer.data.Keys) {
            $projectOnly = ($script:SpecNxProjectOnly -contains $k) -or ($k -eq 'model' -and -not $personal)
            if ($projectOnly -and $layer.name -ne 'project') {
                if ($layer.name -eq 'developer' -and $k -ne 'version') {
                    $warnings += "'$k' in $($layer.file) is ignored: it describes the generated kit and is set only in $projectFile."
                }
                continue
            }
            $data[$k] = $layer.data[$k]
        }
        Merge-SpecNxLayer $values $data $layer.file $sources ''
    }
    return @{ Values = $values; Sources = $sources; Files = $files; Warnings = $warnings }
}

function Get-SpecNxValue($settings, [string] $key) {
    <# A value by dotted key (work_items.area), or $null. #>
    $v = $settings.Values
    foreach ($part in $key.Split('.')) {
        if ($v -is [System.Collections.IDictionary] -and $v.Contains($part)) { $v = $v[$part] } else { return $null }
    }
    # The comma keeps a list a list (PowerShell would unroll a one-item list).
    return , $v
}

function Get-SpecNxSource($settings, [string] $key) {
    <# The file a key comes from, or '' when it is not set. #>
    if ($settings.Sources.Contains($key)) { return $settings.Sources[$key] }
    foreach ($s in $settings.Sources.Keys) { if ($s.StartsWith("$key.")) { return $settings.Sources[$s] } }
    return ''
}

if ($MyInvocation.InvocationName -ne '.') {
    $ErrorActionPreference = 'Stop'
    [Console]::OutputEncoding = [Text.Encoding]::UTF8
    $Root = '.'; $Get = ''; $Source = ''; $Json = $false
    for ($i = 0; $i -lt $args.Count; $i++) {
        switch ($args[$i]) {
            '-Root' { $Root = $args[++$i] }
            '-Get' { $Get = $args[++$i] }
            '-Source' { $Source = $args[++$i] }
            '-Json' { $Json = $true }
            default { throw "Unknown argument: $($args[$i]). Use -Root <dir>, -Get <key.sub>, -Source <key.sub>, -Json." }
        }
    }
    $s = Get-SpecNxSettings -Root $Root
    foreach ($w in $s.Warnings) { [Console]::Error.WriteLine("warning: $w") }
    if ($Source) { $src = Get-SpecNxSource $s $Source; if ($src) { $src }; return }
    if ($Get) {
        $v = Get-SpecNxValue $s $Get
        if ($null -eq $v) { return }
        if ($v -is [System.Collections.IDictionary] -or ($v -is [System.Collections.IList] -and $v -isnot [string])) { ConvertTo-Json -InputObject $v -Depth 20 -Compress } elseif ($v -is [bool]) { "$v".ToLower() } else { "$v" }
        return
    }
    if ($Json) { $s.Values | ConvertTo-Json -Depth 20; return }
    $rootPath = (Resolve-Path -LiteralPath $Root).Path
    foreach ($key in $s.Sources.Keys) {
        $v = Get-SpecNxValue $s $key
        $text = if ($null -eq $v) { '(removed)' } elseif ($v -is [bool]) { "$v".ToLower() } elseif ($v -is [System.Collections.IList] -and $v -isnot [string]) { '[' + (($v | ForEach-Object { "$_" }) -join ', ') + ']' } else { "$v" }
        $file = $s.Sources[$key] -replace [regex]::Escape($rootPath + [IO.Path]::DirectorySeparatorChar), ''
        '{0} = {1}   ({2})' -f $key, $text, $file
    }
}
