# Socratic Probes

A collection of Claude Code slash commands for rigorous Socratic analysis of documents, proposals, and recommendations.

## What It Does

These skills apply the Socratic method to critically examine documents through six specialized lenses:

| Command | Purpose |
|---------|---------|
| `/probe-start` | **Full Analysis** - Launches 6 parallel agents and synthesizes findings |
| `/probe-clarify` | Clarify thinking and trace origin of ideas |
| `/probe-assume` | Challenge hidden assumptions |
| `/probe-evidence` | Examine evidence quality and sources |
| `/probe-pov` | Explore alternative viewpoints |
| `/probe-implications` | Trace implications and consequences |
| `/probe-qq` | Question the question itself |
| `/probe-synthesis` | Synthesize existing evaluation files |

## Installation

### Quickest: one command (global)

Installs all probe commands into `~/.claude/commands`, so they work in every project.

**macOS / Linux / WSL / Git Bash:**

```bash
curl -fsSL https://raw.githubusercontent.com/ds1/socratic-probes/master/install.sh | bash
```

**Windows PowerShell:**

```powershell
irm https://raw.githubusercontent.com/ds1/socratic-probes/master/install.ps1 | iex
```

Then open Claude Code and run `/probe-start`.

### From a clone

```bash
git clone https://github.com/ds1/socratic-probes.git
cd socratic-probes
./install.sh          # macOS / Linux / WSL / Git Bash
# or on Windows:  .\install.ps1
```

### Manual copy

Global (all projects):

```bash
cp socratic-probes/.claude/commands/*.md ~/.claude/commands/
```

```powershell
Copy-Item socratic-probes\.claude\commands\*.md $env:USERPROFILE\.claude\commands\
```

Or project-level, so the commands ship with a specific repo:

```bash
cp -r socratic-probes/.claude YOUR_PROJECT_ROOT/
```

## Usage

### Full Socratic Analysis

Run a comprehensive analysis with 6 parallel agents:

```
/probe-start path/to/document.md ./output-directory
```

This will:
1. Launch 6 specialized analysis agents in parallel
2. Each agent writes its evaluation to the output directory
3. Create a synthesis document consolidating all findings

**Output files:**
- `socratic-1-clarify-thinking.md`
- `socratic-2-challenge-assumptions.md`
- `socratic-3-evidence-basis.md`
- `socratic-4-alternative-viewpoints.md`
- `socratic-5-implications-consequences.md`
- `socratic-6-question-the-question.md`
- `socratic-synthesis.md` (consolidated findings)

### Individual Probes

Run specific types of analysis:

```
/probe-clarify path/to/document.md    # Clarify thinking
/probe-assume path/to/document.md     # Challenge assumptions
/probe-evidence path/to/document.md   # Examine evidence
/probe-pov path/to/document.md        # Alternative viewpoints
/probe-implications path/to/document.md  # Trace consequences
/probe-qq path/to/document.md         # Question the question
```

### Synthesize Existing Evaluations

If you've run individual probes and want to synthesize them:

```
/probe-synthesis ./output-directory
```

## The Six Socratic Lenses

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

## Synthesis Document Structure

The synthesis consolidates findings into an actionable format:

1. **Executive Summary** - Bottom-line assessment
2. **Critical Findings Table** - Key insight from each evaluation
3. **Evidence Quality Assessment** - Source reliability and gaps
4. **Assumption Risk Matrix** - What happens if assumptions are wrong
5. **Unexplored Alternatives** - Options not considered
6. **Hidden Costs & Consequences** - Unaddressed implications
7. **The Meta-Question** - Is the document asking the right question?
8. **Decision Framework** - Validation checklist
9. **Stakeholder Questions** - Questions for CEO, CTO, CFO, Product
10. **Final Verdict** - Ready for action or needs more work?

## Use Cases

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
and the [synthesis](examples/output/socratic-synthesis.md), so you can see exactly
what the probe produces, and what it catches, before running your own.

## The decision-probe loop (where the depth is)

The six lenses are the engine. The real power is running them as a disciplined loop around a decision you are about to lock. `/probe-start` ships with a full methodology section covering:

- **When to probe** - schema/money/audit changes, cross-system contracts, dependency locks; and when to skip (anything reversible in under a day).
- **Scan for an existing decision first** - if a prior ADR already owns the ground, your write-up is an amendment, not a peer.
- **Ground the agents in the code** - when a doc cites function names or constants, tell each agent to verify against the actual code. This catches code-fact bugs that reasoning-from-prose misses (a real probe caught a doc claiming a `3 * X` multiplier where the code used `4 * X`).
- **Read the synthesis cold** - write your concessions and pushback before touching the original, then respond once with a unified summary.
- **After the probe** - when to write a v2, when to escalate a thin result, and the spirit-conflict scan for shape-similar prior decisions.

The premise: a one-to-two-hour probe is cheap next to the cost of locking a wrong architectural choice and only discovering it after you have built on top of it. Run `/probe-start` and read the full methodology inline.

## Requirements

- Claude Code CLI
- A document to analyze (markdown, text, or other readable format)

## License

MIT License - See [LICENSE](LICENSE) file.

## Contributing

Contributions welcome! Feel free to:
- Add new probe types
- Improve existing prompts
- Share interesting use cases

## Acknowledgments

Inspired by the Socratic method of questioning to examine ideas critically and stimulate deeper thinking.
