#!/usr/bin/env bash
# Socratic Probes installer (macOS / Linux / WSL / Git Bash)
#
# Local clone:   ./install.sh
# One-liner:     curl -fsSL https://raw.githubusercontent.com/ds1/socratic-probes/master/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/ds1/socratic-probes.git"
DEST="${HOME}/.claude/commands"

# Find the command files: prefer a local clone next to this script,
# otherwise clone the repo into a temp dir (handles the piped one-liner).
script_dir=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$script_dir" ] && [ -d "$script_dir/.claude/commands" ]; then
  SRC="$script_dir/.claude/commands"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Cloning $REPO_URL ..."
  git clone --depth 1 "$REPO_URL" "$tmp" >/dev/null 2>&1
  SRC="$tmp/.claude/commands"
fi

mkdir -p "$DEST"
cp "$SRC"/probe-*.md "$DEST"/

count="$(ls "$SRC"/probe-*.md | wc -l | tr -d ' ')"
echo "Installed $count probe commands to $DEST"
echo "Open Claude Code and run /probe-start <doc> <output-dir> to begin."
