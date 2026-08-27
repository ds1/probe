# Probe

A set of Claude Code slash commands that examine and sharpen a concept from six
critical angles. Point them at a decision, a proposal, a research write-up, or a
page of raw notes; six lenses run in parallel and synthesize an actionable verdict.

Live at [probe.md](https://probe.md).

Authored by Dan Schmitz (github.com/@ds1) & Claude.

## What it does

Each lens is an independent agent asking a different critical question. The lens
prompts live once, in [`agents/`](agents/); the commands parse arguments and launch them,
so a full run and a single-lens run apply identical prompts.

| Command | Purpose |
|---------|---------|
| `/probe:go` | **Full analysis** - launches 6 parallel agents and synthesizes findings |
| `/probe:clarify` | Clarify thinking and trace origin of ideas |
| `/probe:assume` | Challenge hidden assumptions |
| `/probe:evidence` | Examine evidence quality and sources |
| `/probe:pov` | Explore alternative viewpoints |
| `/probe:implications` | Trace implications and consequences |
| `/probe:meta` | Question the question itself |
| `/probe:synth` | Synthesize existing evaluation files |

## Installation

Pick one path. Both provide the same `/probe:*` commands; installing both gives you
duplicates.

### Recommended: as a Claude Code plugin

This repo is a Claude Code plugin marketplace. Inside Claude Code, run:

```
/plugin marketplace add ds1/probe
/plugin install probe@schmitz
```

You get versioned, updatable commands, invoked as `/probe:go`,
`/probe:assume`, and so on. To update later, run `/plugin` and update when a new
version is published.

### Alternative: one command (global)

Copies the command files into `~/.claude/commands/probe/` (invoked the same way:
`/probe:go`, `/probe:clarify`, etc.) and the lens agents into `~/.claude/agents/`.

**macOS / Linux / WSL / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/ds1/probe/master/install.sh | bash
```

**Windows PowerShell:**

```powershell
irm https://raw.githubusercontent.com/ds1/probe/master/install.ps1 | iex
```

### From a clone

```bash
git clone https://github.com/ds1/probe.git
cd probe
./install.sh          # macOS / Linux / WSL / Git Bash
# or on Windows:  .\install.ps1
```

### Manual copy

Global (all projects):

```bash
mkdir -p ~/.claude/commands/probe ~/.claude/agents
cp probe/commands/*.md ~/.claude/commands/probe/
cp probe/agents/*.md ~/.claude/agents/
```

```powershell
New-Item -ItemType Directory -Force $env:USERPROFILE\.claude\commands\probe, $env:USERPROFILE\.claude\agents
Copy-Item probe\commands\*.md $env:USERPROFILE\.claude\commands\probe\
Copy-Item probe\agents\*.md $env:USERPROFILE\.claude\agents\
```

Or project-level, so the commands ship with a specific repo:

```bash
mkdir -p YOUR_PROJECT_ROOT/.claude/commands/probe YOUR_PROJECT_ROOT/.claude/agents
cp probe/commands/*.md YOUR_PROJECT_ROOT/.claude/commands/probe/
cp probe/agents/*.md YOUR_PROJECT_ROOT/.claude/agents/
```

## Usage

### Full analysis

Run all six lenses in parallel:

```
/probe:go path/to/input.md ./output-directory
/probe:go "path with spaces/input.md" --out ./output-directory
/probe:go Here is an idea I have been kicking around... --out ./output-directory
```

The input is a file path or pasted text. The output directory is optional and
defaults to `./probe-output/`; give it as a second argument after a file path, or
with `--out <dir>` anywhere (the only way to set it for pasted text). Quote paths
that contain spaces.

This will:
1. Launch 6 specialized analysis agents in parallel
2. Each agent writes its evaluation to the output directory
3. Create a synthesis document consolidating all findings

**Output files:**
- `probe-clarify-thinking.md`
- `probe-challenge-assumptions.md`
- `probe-evidence-basis.md`
- `probe-alternative-viewpoints.md`
- `probe-implications-consequences.md`
- `probe-question-the-question.md`
- `probe-synthesis.md` (consolidated findings)

### Individual lenses

Run a specific type of analysis:

```
/probe:clarify path/to/input.md       # Clarify thinking
/probe:assume path/to/input.md        # Challenge assumptions
/probe:evidence path/to/input.md      # Examine evidence
/probe:pov path/to/input.md           # Alternative viewpoints
/probe:implications path/to/input.md  # Trace consequences
/probe:meta path/to/input.md          # Question the question
```

With no output directory the evaluation is returned in the conversation. Add one
(`--out ./dir`, or a second argument after a file path) and the lens writes its
canonical file, `probe-<lens>.md`, there instead.

### Synthesize existing evaluations

Run any lenses you want with the same output directory, then consolidate:

```
/probe:assume path/to/input.md --out ./output-directory
/probe:evidence path/to/input.md --out ./output-directory
/probe:synth ./output-directory
```

The synthesis works from whichever lens files are present. Missing lenses are named
in the synthesis, not invented.

## The six lenses

### 1. Clarify Thinking
*"What do you mean by...?" / "What is the source of this idea?"*

- Identifies key claims needing clarification
- Questions definitions and terminology
- Traces origin of conclusions
- Examines reasoning chains
- Highlights ambiguities

### 2. Challenge Assumptions
*"What are you assuming here?" / "What if you were wrong?"*

- Identifies hidden assumptions
- Questions foundational premises
- Challenges comparison methodology
- Tests robustness of conclusions

### 3. Evidence Basis
*"What evidence supports this?" / "What would disprove this?"*

- Audits sources for bias and reliability
- Identifies unsupported assertions
- Evaluates evidence quality
- Assesses completeness

### 4. Alternative Viewpoints
*"What is the counter-argument?" / "Who would disagree?"*

- Presents strongest counter-arguments
- Identifies unrepresented perspectives
- Explores internal contradictions
- Steel-mans rejected options

### 5. Implications & Consequences
*"What follows from this?" / "What are the long-term effects?"*

- Traces first and second-order implications
- Identifies unintended consequences
- Explores consequences of being wrong
- Maps downstream effects

### 6. Question the Question
*"Is this the right question?" / "What question should we ask instead?"*

- Examines the framing
- Challenges scope and timing
- Identifies questions not asked
- Proposes alternative framing

## Synthesis document structure

The synthesis consolidates findings into an actionable format:

1. **Executive Summary** - Bottom-line assessment
2. **Critical Findings Table** - Key insight from each evaluation
3. **Evidence Quality Assessment** - Source reliability and gaps
4. **Assumption Risk Matrix** - What happens if assumptions are wrong
5. **Unexplored Alternatives** - Options not considered
6. **Hidden Costs & Consequences** - Unaddressed implications
7. **The Meta-Question** - Is the document asking the right question?
8. **Validate Before Proceeding** - Checklist of what to check, measure, or decide first
9. **Questions for the People Who Decide** - Addressed to the roles the input actually
   implies; omitted when the author is the only decider
10. **Final Verdict** - Ready to act on, ready with named conditions, or not ready

The template is a maximum, not a quota. The synthesis matches the register of the
input: a page of raw notes gets a different synthesis than a board memo.

## Use cases

- **Technical proposals** - Evaluate architecture decisions
- **Business cases** - Challenge ROI assumptions
- **Research papers** - Assess evidence quality
- **Strategy documents** - Explore alternatives
- **RFCs/ADRs** - Rigorous review before adoption
- **Vendor evaluations** - Identify bias and gaps

## Example walkthrough

See [`examples/`](examples/) for a complete run against a realistic decision doc
(a proposal to adopt a paid feature-flag SaaS). It includes the
[input](examples/sample-decision.md), all six [lens outputs](examples/output),
and the [synthesis](examples/output/probe-synthesis.md), so you can see exactly
what the probe produces, and what it catches, before running your own.

## The decision-probe loop (where the depth is)

The six lenses are the engine. The real power is running them as a disciplined loop around a decision you are about to lock. [`docs/methodology.md`](docs/methodology.md) covers:

- **When to probe** - schema/money/audit changes, cross-system contracts, dependency locks; and when to skip (anything reversible in under a day).
- **Scan for an existing decision first** - if a prior ADR already owns the ground, your write-up is an amendment, not a peer.
- **Ground the agents in the code** - when a doc cites function names or constants, tell each agent to verify against the actual code. This catches code-fact bugs that reasoning-from-prose misses (a real probe caught a doc claiming a `3 * X` multiplier where the code used `4 * X`).
- **Read the synthesis cold** - write your concessions and pushback before touching the original, then respond once with a unified summary.
- **After the probe** - when to write a v2, when to escalate a thin result, and the spirit-conflict scan for shape-similar prior decisions.

The premise: a probe is cheap next to the cost of locking a wrong architectural choice and only discovering it after you have built on top of it.

## Requirements

- Claude Code CLI
- Something to analyze: a file path (markdown, text, or other readable format) or pasted text

## License

MIT License - See [LICENSE](LICENSE) file.

## Contributing

Contributions welcome. Feel free to:
- Add new lenses (an agent in `agents/` plus a thin command in `commands/` that launches it)
- Improve existing prompts (edit the agent; the commands carry no lens text)
- Share interesting use cases

When releasing, bump the version in both `.claude-plugin/plugin.json` and
`.claude-plugin/marketplace.json` (they must match; `/plugin` updates key off the
marketplace version) and add a [CHANGELOG](CHANGELOG.md) entry.

## Acknowledgments

Rooted in a long tradition of examining ideas by asking what they assume, what
supports them, and what they leave out.
