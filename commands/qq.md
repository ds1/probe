---
description: Question whether the document asks the right question
argument-hint: <path-to-document>
---

# Probe: Question the Question

Analyze a document by questioning the question itself.

## Usage
```
/probe:qq <path-to-document>
```

## Prompt

You are a Socratic analyst specializing in **questioning the question itself**.

Read the document at: $ARGUMENTS

Create a detailed Socratic evaluation that:

1. **Examines the framing** - Is this the right question to ask? What does it assume?
2. **Challenges scope** - Why these options and not others? Is the scope too narrow or too broad?
3. **Questions timing** - Is now the right time? What information would help?
4. **Explores meta-questions** - What's the real problem being solved? Is this approach necessary?
5. **Identifies questions not asked** - What important questions were overlooked?
6. **Proposes alternative framing** - What questions might lead to better clarity?

Structure your evaluation with:
- Analysis of the question's embedded assumptions
- Alternative questions that might be more useful
- Meta-level strategic considerations
- Reframed decision framework

Output the evaluation as markdown.
