# Example walkthrough

A complete run of `/probe:go` against a realistic decision doc, so you can see
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
/probe:go examples/sample-decision.md --out examples/output
```

## The output

Six independent lens evaluations plus a consolidated synthesis, all in
[`output/`](output):

| File | Lens | What it caught |
|------|------|----------------|
| [`probe-clarify-thinking.md`](output/probe-clarify-thinking.md) | Clarify Thinking | The requirement drifts from "toggle at runtime" to "full targeting platform" without acknowledgment; "proper" and "real" are conclusions disguised as descriptions |
| [`probe-challenge-assumptions.md`](output/probe-challenge-assumptions.md) | Challenge Assumptions | The conclusion needs four unshown things to all be true; each is plausible, none is demonstrated, and the memo requires all of them |
| [`probe-evidence-basis.md`](output/probe-evidence-basis.md) | Evidence Basis | No citations, measurements, or dated inputs; the load-bearing cost sentence compares one unstated number to another |
| [`probe-alternative-viewpoints.md`](output/probe-alternative-viewpoints.md) | Alternative Viewpoints | At least five credible options were never named; no perspective outside the Platform team appears |
| [`probe-implications-consequences.md`](output/probe-implications-consequences.md) | Implications | Reversibility decays with success: a one-day rollback at month 1 becomes a quarter of work by month 18 |
| [`probe-question-the-question.md`](output/probe-question-the-question.md) | Question the Question | The title names the answer before the Context states the problem |
| [`probe-synthesis.md`](output/probe-synthesis.md) | Synthesis | Verdict (not ready), risk matrix, a validate-before-proceeding checklist, and questions for the three parties the memo actually implies |

## The point

None of these findings required domain expertise in feature flags. They came from
asking, systematically, the questions an author stops asking once they have
decided what they want to do: what exactly do we need, what is the source of that
number, what is the option you did not list, and are you even asking the right
question. That is the whole value of the loop, and why it catches what author
review misses.

Read the synthesis first, then walk back into whichever lens raised the finding
you want to pressure-test.
