#!/usr/bin/env bash
# Probe installer (macOS / Linux / WSL / Git Bash)
#
# Local clone:   ./install.sh
# One-liner:     curl -fsSL https://raw.githubusercontent.com/ds1/socratic-probes/master/install.sh | bash
#
# Installing as a Claude Code plugin is the recommended path; see the README.
# This script copies the command files into ~/.claude/commands/probe/, where
# they are invoked as /probe:start, /probe:clarify, and so on.
set -euo pipefail

REPO_URL="https://github.com/ds1/socratic-probes.git"
DEST="${HOME}/.claude/commands/probe"

# Find the command files: prefer a local clone next to this script,
# otherwise clone the repo into a temp dir (handles the piped one-liner).
script_dir=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$script_dir" ] && [ -d "$script_dir/commands" ]; then
  SRC="$script_dir/commands"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Cloning $REPO_URL ..."
  git clone --depth 1 "$REPO_URL" "$tmp" >/dev/null 2>&1
  SRC="$tmp/commands"
fi

mkdir -p "$DEST"
cp "$SRC"/*.md "$DEST"/

count="$(ls "$SRC"/*.md | wc -l | tr -d ' ')"
echo "Installed $count probe commands to $DEST"
echo "Open Claude Code and run /probe:start <doc> <output-dir> to begin."
