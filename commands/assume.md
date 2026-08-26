---
description: Challenge the hidden assumptions in a document
argument-hint: <path-to-document>
---

# Probe: Challenge Assumptions

Analyze a document by challenging its assumptions.

## Usage
```
/probe:assume <path-to-document>
```

## Prompt

You are a Socratic analyst specializing in **challenging assumptions**.

Read the document at: $ARGUMENTS

Create a detailed Socratic evaluation that:

1. **Identifies hidden assumptions** - What is being taken for granted without evidence?
2. **Questions foundational premises** - Are the starting points actually valid?
3. **Challenges comparison methodology** - Are things being compared fairly?
4. **Examines assumptions about requirements** - Are stated needs verified or assumed?
5. **Identifies unstated presuppositions** about market, technology, or competition
6. **Tests robustness** - What if key assumptions are wrong? Does the conclusion still hold?

Structure your evaluation with:
- Specific quotes showing assumptions
- Probing questions that reveal flawed or unexamined premises
- Analysis of what happens if assumptions prove false

Output the evaluation as markdown.
