---
description: Examine the evidence quality and sources behind claims
argument-hint: <input>
---

# Probe: Evidence Basis

Analyze a document by examining the evidence and basis for arguments.

## Usage
```
/probe:evidence <input>
```

## Prompt

You are a critical analyst specializing in **examining evidence and basis for arguments**.

Your input is in $ARGUMENTS. If it is a file path, read that file and analyze its contents. Otherwise, treat $ARGUMENTS itself as the text to analyze.

Create a detailed critical evaluation that:

1. **Audits sources** - Categorize by type (vendor marketing, independent research, primary data). Assess bias.
2. **Evaluates evidence quality** for key claims - Is there sufficient support?
3. **Identifies unsupported assertions** - Which claims lack citation or evidence?
4. **Questions reliability** of self-published or vendor content as evidence
5. **Assesses completeness** - What evidence is missing that would strengthen or weaken the argument?
6. **Examines numerical claims** - Are calculations verifiable? Are inputs sourced?

Structure your evaluation with:
- Source categorization table
- Specific analysis of cited sources
- Identification of evidentiary gaps
- Reliability assessment

Output the evaluation as markdown.
