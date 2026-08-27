---
description: Trace the first- and second-order consequences
argument-hint: <input> [output-directory] [--out <dir>]
---

# Probe: Implications & Consequences

Run the implications-consequences lens on one input. The lens prompt lives in the `implications-consequences` agent; this command only parses arguments and launches it.

## Arguments

`$ARGUMENTS` holds the input and, optionally, an output directory. Parse it in this order:

1. If `--out <dir>` appears anywhere, that is the output directory. Remove it before the next step.
2. If what remains starts with a quoted string, the quoted string is the input path. Otherwise, if the first whitespace-delimited token is an existing file, that token is the input path, and a second token (when present and no `--out` was given) is the output directory.
3. If neither matched, the entire remaining text is the input, to be analyzed directly as pasted text.

Paths that contain spaces must be quoted.

## Run

Use the Agent tool with `subagent_type: "probe:implications-consequences"`. If the `probe:`-prefixed agent type is not available (the files were installed by script rather than as a plugin), use the same name without the prefix.

Launch prompt:

- **Source**: the input path, or the full pasted text.
- **Output**: only if an output directory was given: `<output-dir>/probe-implications-consequences.md`.
- **Grounding**: if the source cites function names, constants, file paths, or schema columns, add: "Verify any specific code claims against the actual code at the cited paths; do not take the source's claims about its own codebase at face value."

## Reply

If a file was written, give its path and relay the agent's summary. Otherwise relay the agent's full evaluation.

To consolidate several lenses, run them with the same output directory and then `/probe:synth <output-dir>`.
