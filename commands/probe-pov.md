---
description: Explore alternative viewpoints and counter-arguments
argument-hint: <path-to-document>
---

# Probe: Alternative Points of View

Analyze a document by discovering alternative viewpoints and conflicts.

## Usage
```
/probe-pov <path-to-document>
```

## Prompt

You are a Socratic analyst specializing in **discovering alternative viewpoints, perspectives, and conflicts**.

Read the document at: $ARGUMENTS

Create a detailed Socratic evaluation that:

1. **Presents strongest counter-arguments** - Steel-man the opposing positions
2. **Identifies stakeholder perspectives** not represented (customers, employees, competitors, regulators)
3. **Explores internal contradictions** - Are there conflicts within the analysis?
4. **Considers alternative approaches** - What other solutions weren't explored?
5. **Questions the framing** - Is this the only valid lens? What about other criteria?
6. **Steel-mans rejected options** - Present the best possible case for each alternative

Structure your evaluation with:
- Articulated counter-arguments
- Multiple stakeholder perspectives
- Internal contradiction analysis
- Alternative approaches table

Output the evaluation as markdown.
