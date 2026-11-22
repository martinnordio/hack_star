<#
.SYNOPSIS
Serves build\web\ on the local network (port 8060) and forwards /api to the hack server, until
stopped with Ctrl+C.

.DESCRIPTION
Prints the addresses to open (this computer's IPv4 address for an iPad on the same Wi-Fi, and
localhost), then runs tools\serve_web.py (Python standard library only) through uv. The page and
the server's /api share one address, so the web game needs no setup. Start the server first in
its own window: cd server; uv run hack-star-server (port 8180). Without it /api answers 502 and
the game says it cannot reach the hack server. Run tools\export_web.ps1 first. Windows may ask
to allow Python through the firewall.

.PARAMETER Port
The port of the web game (default 8060).

.PARAMETER ApiUrl
Where the hack server listens (default http://127.0.0.1:8180).

.PARAMETER Https
Serves https:// with a self-signed certificate (made once into build\cert\); the browser camera
needs https:// on an iPad or phone. The browser warns once: accept the certificate.
#>
#Requires -Version 5.1
[CmdletBinding()]
param(
    [int]$Port = 8060,
    [string]$ApiUrl = 'http://127.0.0.1:8180',
    [switch]$Https
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
$scheme = if ($Https) { 'https' } else { 'http' }
foreach ($address in $addresses) {
    Write-Host "Open on the iPad (same Wi-Fi): ${scheme}://${address}:$Port"
}
Write-Host "Open on this computer: ${scheme}://localhost:$Port"
Write-Host "The hack server is expected at $ApiUrl (cd server; uv run hack-star-server)."
Write-Host 'Press Ctrl+C to stop.'

$serverArguments = @('tools/serve_web.py', '--port', $Port, '--api-url', $ApiUrl, '--directory', 'build/web')
Push-Location -LiteralPath $projectRoot
try {
    if ($Https) {
        $cryptography = (Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'versions.json') | ConvertFrom-Json).cryptography
        & uv run --no-project --with "cryptography==$cryptography" python tools/make_cert.py --out build/cert @addresses
        if ($LASTEXITCODE -ne 0) {
            Write-Host 'Could not make the certificate.'
            exit 1
        }
        $serverArguments += @('--cert', 'build/cert/cert.pem', '--key', 'build/cert/key.pem')
    }
    & uv run --no-project python @serverArguments
    if ($LASTEXITCODE -ne 0) {
        Write-Host "The server stopped with exit code $LASTEXITCODE."
        exit 1
    }
}
finally {
    Pop-Location
}
exit 0
