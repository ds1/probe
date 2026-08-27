#!/usr/bin/env bash
# Probe installer (macOS / Linux / WSL / Git Bash)
#
# Local clone:   ./install.sh
# One-liner:     curl -fsSL https://raw.githubusercontent.com/ds1/probe/master/install.sh | bash
#
# Installing as a Claude Code plugin is the recommended path; see the README.
# Use one install path or the other, not both: both provide the same /probe:* commands.
#
# This script copies the command files into ~/.claude/commands/probe/ (invoked as
# /probe:go, /probe:clarify, and so on) and the lens agents into ~/.claude/agents/
# (named clarify-thinking, synthesis, and so on; the commands fall back to these
# names when the plugin-namespaced ones are absent).
set -euo pipefail

REPO_URL="https://github.com/ds1/probe.git"
CMD_DEST="${HOME}/.claude/commands/probe"
AGENT_DEST="${HOME}/.claude/agents"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required (used to fetch the command files)." >&2
  exit 1
fi

# Find the source files: prefer a local clone next to this script,
# otherwise clone the repo into a temp dir (handles the piped one-liner).
script_dir=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [ -n "$script_dir" ] && [ -d "$script_dir/commands" ] && [ -d "$script_dir/agents" ]; then
  SRC="$script_dir"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Cloning $REPO_URL ..."
  git clone --depth 1 "$REPO_URL" "$tmp" >/dev/null 2>&1
  SRC="$tmp"
fi

mkdir -p "$CMD_DEST" "$AGENT_DEST"
cp "$SRC"/commands/*.md "$CMD_DEST"/
cp "$SRC"/agents/*.md "$AGENT_DEST"/

cmd_count="$(ls "$SRC"/commands/*.md | wc -l | tr -d ' ')"
agent_count="$(ls "$SRC"/agents/*.md | wc -l | tr -d ' ')"
echo "Installed $cmd_count probe commands to $CMD_DEST"
echo "Installed $agent_count probe agents to $AGENT_DEST"
echo "Open Claude Code and run /probe:go <input> to begin."
