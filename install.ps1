# Probe installer (Windows PowerShell)
#
# Local clone:  .\install.ps1
# One-liner:    irm https://raw.githubusercontent.com/ds1/probe/master/install.ps1 | iex
#
# Installing as a Claude Code plugin is the recommended path; see the README.
# This script copies the command files into ~/.claude/commands/probe/, where
# they are invoked as /probe:go, /probe:clarify, and so on.
$ErrorActionPreference = 'Stop'

$repoUrl = 'https://github.com/ds1/probe.git'
$dest = Join-Path $env:USERPROFILE '.claude\commands\probe'

# Prefer a local clone next to this script; otherwise clone into a temp dir
# (handles the piped one-liner, where $PSScriptRoot is empty).
$src = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot 'commands'))) {
    $src = Join-Path $PSScriptRoot 'commands'
} else {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("probe-" + [System.Guid]::NewGuid().ToString('N'))
    Write-Host "Cloning $repoUrl ..."
    git clone --depth 1 $repoUrl $tmp 2>&1 | Out-Null
    $src = Join-Path $tmp 'commands'
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item (Join-Path $src '*.md') $dest -Force

$count = (Get-ChildItem (Join-Path $src '*.md')).Count
Write-Host "Installed $count probe commands to $dest"
Write-Host "Open Claude Code and run /probe:go <input> <output-dir> to begin."
