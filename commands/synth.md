---
description: Synthesize the lens evaluations in a directory into one summary
argument-hint: [directory-containing-evaluations]
---

# Probe: Synthesis

Consolidate whatever lens evaluations exist in a directory into `probe-synthesis.md`. The synthesis template lives in the `synthesis` agent; this command only launches it.

## Arguments

`$ARGUMENTS` is the directory holding `probe-*.md` lens files. If it is empty, use `./probe-output/`. Quote paths that contain spaces.

## Run

Use the Agent tool with `subagent_type: "probe:synthesis"`. If that agent type is not available (the files were installed by script rather than as a plugin), use `synthesis`.

Launch prompt: **Directory**: the directory from the arguments.

The agent tolerates a partial set of lenses. It names the missing ones in the synthesis rather than inventing findings for them, and stops if none are present.

## Reply

Relay the agent's executive summary, final verdict, and any lenses it reported missing, plus the path of `probe-synthesis.md`.
