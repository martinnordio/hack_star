#Requires -Version 5.1
<#
.SYNOPSIS
Serves build\web\ on the local network (port 8060) until stopped with Ctrl+C.

.DESCRIPTION
Prints the addresses to open (this computer's IPv4 address for an iPad on the same Wi-Fi, and
localhost), then runs Python's http.server through uv. Run tools\export_web.ps1 first.
Windows may ask to allow Python through the firewall.
#>
[CmdletBinding()]
param(
    [int]$Port = 8060
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$webFolder = Join-Path $projectRoot 'build\web'
if (-not (Test-Path -LiteralPath (Join-Path $webFolder 'index.html'))) {
    Write-Host 'build\web\index.html not found. Run tools\export_web.ps1 first.'
    exit 1
}
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host 'uv not found. See tools\check_tools.ps1.'
    exit 1
}

$addresses = @(
    Get-NetIPConfiguration -ErrorAction SilentlyContinue |
        Where-Object { $_.IPv4DefaultGateway -and $_.IPv4Address } |
        ForEach-Object { $_.IPv4Address.IPAddress }
)
if ($addresses.Count -eq 0) {
    $addresses = @(
        Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
            Select-Object -ExpandProperty IPAddress
    )
}
foreach ($address in $addresses) {
    Write-Host "Open on the iPad (same Wi-Fi): http://${address}:$Port"
}
Write-Host "Open on this computer: http://localhost:$Port"
Write-Host 'Press Ctrl+C to stop.'

Push-Location -LiteralPath $projectRoot
try {
    & uv run --no-project python -m http.server $Port --bind 0.0.0.0 --directory build/web
    if ($LASTEXITCODE -ne 0) {
        Write-Host "The server stopped with exit code $LASTEXITCODE."
        exit 1
    }
}
finally {
    Pop-Location
}
exit 0
