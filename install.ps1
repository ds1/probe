# Probe installer (Windows PowerShell)
#
# Local clone:  .\install.ps1
# One-liner:    irm https://raw.githubusercontent.com/ds1/probe/master/install.ps1 | iex
#
# Installing as a Claude Code plugin is the recommended path; see the README.
# Use one install path or the other, not both: both provide the same /probe:* commands.
#
# This script copies the command files into ~/.claude/commands/probe/ (invoked as
# /probe:go, /probe:clarify, and so on) and the lens agents into ~/.claude/agents/
# (named clarify-thinking, synthesis, and so on; the commands fall back to these
# names when the plugin-namespaced ones are absent).
$ErrorActionPreference = 'Stop'

$repoUrl = 'https://github.com/ds1/probe.git'
$cmdDest = Join-Path $env:USERPROFILE '.claude\commands\probe'
$agentDest = Join-Path $env:USERPROFILE '.claude\agents'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git is required (used to fetch the command files).'
}

# Prefer a local clone next to this script; otherwise clone into a temp dir
# (handles the piped one-liner, where $PSScriptRoot is empty).
$src = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot 'commands')) -and (Test-Path (Join-Path $PSScriptRoot 'agents'))) {
    $src = $PSScriptRoot
} else {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("probe-" + [System.Guid]::NewGuid().ToString('N'))
    Write-Host "Cloning $repoUrl ..."
    git clone --depth 1 $repoUrl $tmp 2>&1 | Out-Null
    $src = $tmp
}

New-Item -ItemType Directory -Force -Path $cmdDest | Out-Null
New-Item -ItemType Directory -Force -Path $agentDest | Out-Null
Copy-Item (Join-Path $src 'commands\*.md') $cmdDest -Force
Copy-Item (Join-Path $src 'agents\*.md') $agentDest -Force

$cmdCount = (Get-ChildItem (Join-Path $src 'commands\*.md')).Count
$agentCount = (Get-ChildItem (Join-Path $src 'agents\*.md')).Count
Write-Host "Installed $cmdCount probe commands to $cmdDest"
Write-Host "Installed $agentCount probe agents to $agentDest"
Write-Host "Open Claude Code and run /probe:go <input> to begin."
