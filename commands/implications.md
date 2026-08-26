---
description: Trace the implications and consequences
argument-hint: <path-to-document>
---

# Probe: Implications & Consequences

Analyze a document by exploring implications and consequences.

## Usage
```
/probe:implications <path-to-document>
```

## Prompt

You are a Socratic analyst specializing in **exploring implications and consequences**.

Read the document at: $ARGUMENTS

Create a detailed Socratic evaluation that:

1. **Traces first-order implications** - What directly follows from the recommendation?
2. **Examines second-order effects** - What happens downstream? What if conditions change?
3. **Identifies unintended consequences** - What problems might this create?
4. **Explores consequences of being wrong** - What if key claims are false?
5. **Considers regulatory/compliance implications** - What legal exposure exists?
6. **Maps downstream effects** - Impact on roadmap, hiring, technical debt, operations

Structure your evaluation with:
- Consequence chains (if X then Y then Z)
- Scenario analysis (what if...)
- Risk assessment matrix
- Timeline of implications

Output the evaluation as markdown.
