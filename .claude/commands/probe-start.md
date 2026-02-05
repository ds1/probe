# Probe: Full Socratic Analysis

Launch 6 parallel Socratic evaluation agents to analyze a document, then synthesize findings.

## Usage
```
/probe-start <path-to-document> <output-directory>
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

**Agent 1: Clarify Thinking** -> `socratic-1-clarify-thinking.md`
Examine arguments by asking: "What do you mean by...?", "What is the source of this idea?", "How did you come to this conclusion?"
- Identify key claims needing clarification
- Question definitions and terminology
- Trace origin of conclusions (primary research vs. inference)
- Examine reasoning chains
- Highlight ambiguities

**Agent 2: Challenge Assumptions** -> `socratic-2-challenge-assumptions.md`
Ask: "What are you assuming here?", "How do you know this is true?", "What if you were wrong?"
- Identify hidden assumptions
- Question foundational premises
- Challenge comparison methodology
- Test robustness of conclusions

**Agent 3: Evidence Basis** -> `socratic-3-evidence-basis.md`
Ask: "What evidence supports this?", "Is this evidence sufficient?", "What would disprove this?"
- Audit sources for bias and reliability
- Identify unsupported assertions
- Evaluate evidence quality for key claims
- Assess completeness of evidence

**Agent 4: Alternative Viewpoints** -> `socratic-4-alternative-viewpoints.md`
Ask: "What is the counter-argument?", "Who would disagree?", "What are other ways to look at this?"
- Present strongest counter-arguments
- Identify unrepresented stakeholder perspectives
- Explore internal contradictions
- Steel-man rejected options

**Agent 5: Implications & Consequences** -> `socratic-5-implications-consequences.md`
Ask: "What follows from this?", "What are the consequences?", "What are the long-term effects?"
- Trace first and second-order implications
- Identify unintended consequences
- Explore consequences of being wrong
- Map downstream effects

**Agent 6: Question the Question** -> `socratic-6-question-the-question.md`
Ask: "Is this the right question?", "What does this question assume?", "What question should we ask instead?"
- Examine the framing of the research question
- Challenge scope and timing
- Identify questions not asked
- Propose alternative framing

### Step 2: Create Synthesis Document

After all 6 agents complete, read all 6 evaluation files and create `socratic-synthesis.md` in the output directory that consolidates:

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
