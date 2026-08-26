# Socratic Probes installer (Windows PowerShell)
#
# Local clone:  .\install.ps1
# One-liner:    irm https://raw.githubusercontent.com/ds1/socratic-probes/master/install.ps1 | iex
$ErrorActionPreference = 'Stop'

$repoUrl = 'https://github.com/ds1/socratic-probes.git'
$dest = Join-Path $env:USERPROFILE '.claude\commands'

# Prefer a local clone next to this script; otherwise clone into a temp dir
# (handles the piped one-liner, where $PSScriptRoot is empty).
$src = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot '.claude\commands'))) {
    $src = Join-Path $PSScriptRoot '.claude\commands'
} else {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("socratic-probes-" + [System.Guid]::NewGuid().ToString('N'))
    Write-Host "Cloning $repoUrl ..."
    git clone --depth 1 $repoUrl $tmp 2>&1 | Out-Null
    $src = Join-Path $tmp '.claude\commands'
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item (Join-Path $src 'probe-*.md') $dest -Force

$count = (Get-ChildItem (Join-Path $src 'probe-*.md')).Count
Write-Host "Installed $count probe commands to $dest"
Write-Host "Open Claude Code and run /probe-start <doc> <output-dir> to begin."
