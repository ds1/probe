---
description: Run all six Socratic lenses in parallel and synthesize the findings
argument-hint: <input> <output-directory>
---

# Probe: Full Socratic Analysis

Launch 6 parallel Socratic evaluation agents to analyze a document, then synthesize findings.

## Usage
```
/probe:go <input> <output-directory>
```

## Arguments
- `$ARGUMENTS` - Path to document to analyze and output directory (space-separated)

## Prompt

You are orchestrating a comprehensive Socratic analysis. Parse the arguments to get:
1. The document path (first argument)
2. The output directory (second argument)

### Step 1: Launch 6 Parallel Analysis Agents

Use the Task tool to launch 6 subagents in parallel. Each agent should:
- Read the source document
- Apply their specialized Socratic questioning technique
- Write their evaluation as a markdown file to the output directory

**Agent 1: Clarify Thinking** -> `probe-clarify-thinking.md`
Examine arguments by asking: "What do you mean by...?", "What is the source of this idea?", "How did you come to this conclusion?"
- Identify key claims needing clarification
- Question definitions and terminology
- Trace origin of conclusions (primary research vs. inference)
- Examine reasoning chains
- Highlight ambiguities

**Agent 2: Challenge Assumptions** -> `probe-challenge-assumptions.md`
Ask: "What are you assuming here?", "How do you know this is true?", "What if you were wrong?"
- Identify hidden assumptions
- Question foundational premises
- Challenge comparison methodology
- Test robustness of conclusions

**Agent 3: Evidence Basis** -> `probe-evidence-basis.md`
Ask: "What evidence supports this?", "Is this evidence sufficient?", "What would disprove this?"
- Audit sources for bias and reliability
- Identify unsupported assertions
- Evaluate evidence quality for key claims
- Assess completeness of evidence

**Agent 4: Alternative Viewpoints** -> `probe-alternative-viewpoints.md`
Ask: "What is the counter-argument?", "Who would disagree?", "What are other ways to look at this?"
- Present strongest counter-arguments
- Identify unrepresented stakeholder perspectives
- Explore internal contradictions
- Steel-man rejected options

**Agent 5: Implications & Consequences** -> `probe-implications-consequences.md`
Ask: "What follows from this?", "What are the consequences?", "What are the long-term effects?"
- Trace first and second-order implications
- Identify unintended consequences
- Explore consequences of being wrong
- Map downstream effects

**Agent 6: Question the Question** -> `probe-question-the-question.md`
Ask: "Is this the right question?", "What does this question assume?", "What question should we ask instead?"
- Examine the framing of the research question
- Challenge scope and timing
- Identify questions not asked
- Propose alternative framing

### Step 2: Create Synthesis Document

After all 6 agents complete, read all 6 evaluation files and create `probe-synthesis.md` in the output directory that consolidates:

1. **Executive Summary** - Bottom-line assessment in 2-3 sentences

2. **Critical Findings Table** - One row per evaluation summarizing the key insight:
   | # | Evaluation | Key Finding |
   |---|------------|-------------|

3. **Evidence Quality Assessment** - Summary of source reliability and gaps

4. **Assumption Risk Matrix** - Key assumptions and what happens if they're wrong

5. **Unexplored Alternatives** - Options the original document didn't consider

6. **Hidden Costs & Consequences** - Implications not addressed in the original

7. **The Meta-Question** - Is the original document asking the right question?

8. **Decision Framework** - What should be validated before proceeding

9. **Stakeholder Questions** - Key questions for CEO, CTO, CFO, Product

10. **Final Verdict** - Assessment of whether the recommendation is ready for action

The synthesis should be actionable - providing a clear checklist of what needs validation before the recommendation can be confidently accepted or rejected.

## Methodology: the decision-probe loop

The six lenses are the engine. This is the loop that makes them earn their cost on real decisions. A two-minute probe is cheap next to the cost of locking a wrong architectural choice and discovering it after you have built on top of it. The probe catches what author review misses: bundled decisions, confidence calibrated to a future you cannot see yet, claims asserted but never measured, options that were never put on the table.

### When to probe

Probe a decision before you lock it when it:
- changes a schema, a money flow, or an audit trail
- sets a cross-system contract (an API shape, an SDK surface, a versioning boundary)
- locks in a dependency (a vendor, a framework, a test stack)
- is the kind of thing you would write down as a numbered, hard-to-reverse decision (an ADR)

Skip it for reversible work: implementation PRs, bug fixes, copy edits, refactors that do not change behavior, anything you could undo in under a day.

### The loop

0. **Scan for an existing decision first.** Before drafting, search your decision log (an ADR folder, a DECISIONS.md, whatever you keep) for the nouns of the capability and their synonyms. If a prior decision already owns this ground, your draft is an AMENDMENT to it: cite it in the first paragraph and keep or explicitly amend its invariants by name. It is never a peer. (A real probe once spent all six of its sharpest findings pointing out that a draft had silently re-decided something an existing decision already governed.)

1. **Draft the write-up.** Lead with what is blocked and how reversible each option is. Calibrate to the current state, not an imagined future; handle the future with written reversal triggers instead of guesses. Anchor every number with its source: measured, estimated, vendor-cited (with a date), or industry-comparison.

2. **Invoke the probe** on that draft: `/probe:go <input> <output-dir>`. The six agents run independently, with no shared context with you or each other.

3. **Ground the agents in the code when the doc cites code.** If the write-up references specific function names, constant values, file paths, or schema columns, add to each agent's launch prompt: "verify any specific code claims against the actual code at the cited paths; do not take the doc's claims about its own codebase at face value." Without this, agents reason from the prose and miss code-fact bugs. This is not hypothetical: with grounding on, a probe caught a doc claiming a `3 * X` multiplier where the code actually used `4 * X`, a bug the author's own review had read straight past.

4. **Read the synthesis cold.** Write down where the probe was right (concessions) and where it overcorrected (pushback) before you touch the original.

5. **Respond once.** Bring the original recommendation, a five-to-ten-line probe summary, your updated thinking, and a path to the revised doc into a single message. One synthesis of the loop, not three fragments.

### After the probe

- **Load-bearing gaps found:** write a v2 of the doc calibrated on the corrections. Do not silently auto-rewrite; surfacing the concessions is itself part of the decision.
- **Thin synthesis because the doc was thin:** escalate with the partial result rather than re-probing. Re-probing shallow input just burns runs.
- **Spirit-conflict scan.** Before you commit to a paid dependency or a cross-cutting change, look through the decision log for shape-similar prior calls. One often encodes a constraint that should carry over (a "no paid X before revenue" rule on the data side should make you suspicious of paid X on the infra side too).

### Why it earns its cost

Run the same doc through a probe you triggered deliberately and one triggered automatically and the findings overlap about 85 to 90 percent, with the same verdict; the differences show up only on the depth axis. The quality holds regardless of what triggered it, and it repeatedly finds real bugs that author review shipped past.
