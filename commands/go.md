---
description: Run all six lenses in parallel and synthesize the findings
argument-hint: <input> [output-directory] [--out <dir>]
---

# Probe: Full Analysis

Run six independent lens agents against one input, then synthesize their findings. Each lens prompt lives in its own agent under `agents/`; this command only parses arguments, launches, and reports.

## Arguments

`$ARGUMENTS` holds the input and, optionally, an output directory. Parse it in this order:

1. If `--out <dir>` appears anywhere, that is the output directory. Remove it before the next step.
2. If what remains starts with a quoted string, the quoted string is the input path. Otherwise, if the first whitespace-delimited token is an existing file, that token is the input path, and a second token (when present and no `--out` was given) is the output directory.
3. If neither matched, the entire remaining text is the input, to be analyzed directly as pasted text.
4. If no output directory was given, use `./probe-output/`. Create it if it does not exist.

Paths that contain spaces must be quoted.

## Step 1: launch the six lenses in parallel

Use the Agent tool to launch all six subagents in a single message so they run concurrently. They share no context with each other or with you.

| `subagent_type` | writes |
|---|---|
| `probe:clarify-thinking` | `probe-clarify-thinking.md` |
| `probe:challenge-assumptions` | `probe-challenge-assumptions.md` |
| `probe:evidence-basis` | `probe-evidence-basis.md` |
| `probe:alternative-viewpoints` | `probe-alternative-viewpoints.md` |
| `probe:implications-consequences` | `probe-implications-consequences.md` |
| `probe:question-the-question` | `probe-question-the-question.md` |

If the `probe:`-prefixed agent types are not available (the files were installed by script rather than as a plugin), use the same name without the prefix.

Give every agent the same launch prompt, varying only the output file name:

- **Source**: the input path to read, or the full pasted text.
- **Output**: `<output-dir>/<file from the table>`.
- **Grounding**: if the source cites function names, constants, file paths, or schema columns, add: "Verify any specific code claims against the actual code at the cited paths; do not take the source's claims about its own codebase at face value."

## Step 2: synthesize

When all six have finished, launch `probe:synthesis` (or `synthesis`) with **Directory**: `<output-dir>`. It reads the lens files present and writes `probe-synthesis.md`.

## Step 3: report

Reply with the synthesis agent's executive summary and final verdict, the output directory, and the list of files written. Do not paste the evaluations inline.
