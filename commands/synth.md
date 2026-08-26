---
description: Synthesize existing Socratic evaluation files into one summary
argument-hint: <directory-containing-evaluations>
---

# Probe: Synthesis

Synthesize findings from existing Socratic evaluation files into a consolidated summary.

## Usage
```
/probe:synth <directory-containing-evaluations>
```

## Prompt

You are synthesizing findings from 6 Socratic evaluations into a comprehensive summary document.

Look in the directory: $ARGUMENTS

Find and read these evaluation files:
- `probe-1-clarify-thinking.md`
- `probe-2-challenge-assumptions.md`
- `probe-3-evidence-basis.md`
- `probe-4-alternative-viewpoints.md`
- `probe-5-implications-consequences.md`
- `probe-6-question-the-question.md`

Create `probe-synthesis.md` in the same directory that consolidates:

1. **Executive Summary** - Bottom-line assessment in 2-3 sentences. What's the verdict?

2. **Critical Findings Table**
   | # | Evaluation | Key Finding |
   |---|------------|-------------|
   | 1 | Clarify Thinking | ... |
   | 2 | Challenge Assumptions | ... |
   | 3 | Evidence Basis | ... |
   | 4 | Alternative Viewpoints | ... |
   | 5 | Implications | ... |
   | 6 | Question the Question | ... |

3. **Evidence Quality Assessment** - Summary of source reliability, bias, and gaps

4. **Assumption Risk Matrix** - Key assumptions ranked by impact if wrong
   | Assumption | Confidence | Impact if Wrong |
   |------------|------------|-----------------|

5. **Unexplored Alternatives** - Options the original document didn't consider

6. **Hidden Costs & Consequences** - Implications not addressed in the original

7. **The Meta-Question** - Is the original document asking the right question? What should it ask instead?

8. **Decision Framework** - Checklist of what must be validated before proceeding
   - [ ] Item 1
   - [ ] Item 2
   - [ ] ...

9. **Stakeholder Questions**
   - **For the CEO:** ...
   - **For the CTO:** ...
   - **For the CFO:** ...
   - **For Product:** ...

10. **Final Verdict** - Is the recommendation ready for action, or does it need more work?

The synthesis should be actionable - providing a clear path forward for decision-makers.
