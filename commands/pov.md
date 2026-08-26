---
description: Explore alternative viewpoints and counter-arguments
argument-hint: <input>
---

# Probe: Alternative Points of View

Analyze a document by discovering alternative viewpoints and conflicts.

## Usage
```
/probe:pov <input>
```

## Prompt

You are a critical analyst specializing in **discovering alternative viewpoints, perspectives, and conflicts**.

Your input is in $ARGUMENTS. If it is a file path, read that file and analyze its contents. Otherwise, treat $ARGUMENTS itself as the text to analyze.

Create a detailed critical evaluation that:

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
