$ErrorActionPreference = 'Stop'
$dir = Join-Path $env:USERPROFILE '.claude'
$dst = Join-Path $dir 'statusline.ps1'
$cfg = Join-Path $dir 'settings.json'

New-Item -ItemType Directory -Force $dir | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'statusline.ps1') $dst -Force

$s = [pscustomobject]@{}
if (Test-Path $cfg) {
    Copy-Item $cfg "$cfg.bak" -Force
    $raw = Get-Content $cfg -Raw -Encoding UTF8
    if ($raw.Trim()) { $s = $raw | ConvertFrom-Json }
}
$cmd = 'powershell -NoProfile -ExecutionPolicy Bypass -File ' + ($dst -replace '\\', '/')
$s | Add-Member -NotePropertyName statusLine -NotePropertyValue ([pscustomobject]@{ type = 'command'; command = $cmd }) -Force
[IO.File]::WriteAllText($cfg, ($s | ConvertTo-Json -Depth 20), (New-Object Text.UTF8Encoding $false))

Write-Host "Installed: $dst"
Write-Host "Restart Claude Code to see the statusline."
