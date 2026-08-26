# Example walkthrough

A complete run of `/probe:start` against a realistic decision doc, so you can see
what the six lenses and the synthesis actually produce before you run your own.

## The input

[`sample-decision.md`](sample-decision.md) is a proposal to adopt a paid
feature-flag SaaS. It looks reasonable on a first read, but it carries the flaws
probes are built to surface: a bundled requirement, an undated price, an
"in-house is free" comparison it contradicts in its own next sentence, a false
build-or-buy binary that hides the middle options, and a recommendation resting on
an unquantified "flag volume will only grow."

## The command

```
/probe:start examples/sample-decision.md examples/output
```

## The output

Six independent lens evaluations plus a consolidated synthesis, all in
[`output/`](output):

| File | Lens | What it caught |
|------|------|----------------|
| [`probe-1-clarify-thinking.md`](output/probe-1-clarify-thinking.md) | Clarify Thinking | "Proper feature flags" bundles four different capabilities; the requirement is never defined |
| [`probe-2-challenge-assumptions.md`](output/probe-2-challenge-assumptions.md) | Challenge Assumptions | Cost is loaded asymmetrically onto build; the case rests on an unquantified growth assumption |
| [`probe-3-evidence-basis.md`](output/probe-3-evidence-basis.md) | Evidence Basis | Every number is unsourced or self-contradicting |
| [`probe-4-alternative-viewpoints.md`](output/probe-4-alternative-viewpoints.md) | Alternative Viewpoints | False binary; open-source and a minimal flag store are missing |
| [`probe-5-implications-consequences.md`](output/probe-5-implications-consequences.md) | Implications | Recurring cost scales with headcount; lock-in rises with every flag; fail mode unspecified |
| [`probe-6-question-the-question.md`](output/probe-6-question-the-question.md) | Question the Question | It answers "which vendor?" before settling "do we need a platform yet?" |
| [`probe-synthesis.md`](output/probe-synthesis.md) | Synthesis | Verdict, risk matrix, and a validate-before-proceeding checklist |

## The point

None of these findings required domain expertise in feature flags. They came from
asking, systematically, the questions an author stops asking once they have
decided what they want to do: what exactly do we need, what is the source of that
number, what is the option you did not list, and are you even asking the right
question. That is the whole value of the loop, and why it catches what author
review misses.

Read the synthesis first, then walk back into whichever lens raised the finding
you want to pressure-test.
