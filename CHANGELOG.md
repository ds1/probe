# Changelog

All notable changes to this plugin. Versions follow semver and must match in both
`.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`.

## 1.2.0 - 2026-08-26

### Changed
- Marketplace and plugin metadata refreshed for discoverability: lowercase `probe`
  display name, fuller `/probe` descriptions, and owner/author contact details.

### Added
- Expanded `keywords` plus matching `tags`, a `thinking-tools` category, and
  `defaultEnabled` in `plugin.json`.

## 1.1.0 - 2026-08-26

### Changed
- Each lens prompt now lives once, in `agents/`, as a named subagent. `/probe:go` and the
  individual lens commands both launch the same agent, so the full run and the single-lens
  run apply identical prompts. Previously `/probe:go` carried a condensed paraphrase of each lens.
- The synthesis template lives once, in `agents/synthesis.md`, launched by both `/probe:go`
  and `/probe:synth`.
- Synthesis calibrates to the genre of the input. The stakeholder-questions section is included
  only when the input implies deciders beyond the author, and names the roles the input actually
  affects instead of a fixed CEO/CTO/CFO/Product list.
- Argument parsing accepts quoted paths and an explicit `--out <dir>`, so pasted text can have an
  output directory and paths with spaces work.
- The decision-probe methodology moved out of the `/probe:go` prompt into `docs/methodology.md`.
  It was written for the reader, not the model, and was being sent on every run.
- Subagent launches refer to the Agent tool (the name since Claude Code 2.1.63; Task remains an alias).

### Added
- Individual lens commands accept an output directory and write the canonical
  `probe-<lens>.md` file there, so `/probe:synth` can consolidate lenses run one at a time.
- `/probe:synth` tolerates a partial set of lens files: missing lenses are named in the
  synthesis, not fabricated.
- `install.sh` and `install.ps1` install the agents to `~/.claude/agents/` alongside the commands.
- This changelog.
- `examples/output/` regenerated with the 1.1.0 prompts.

## 1.0.0 - 2026-08

- Initial plugin release: `/probe:go`, six lens commands, `/probe:synth`, example run.
