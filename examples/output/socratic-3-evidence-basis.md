# Evidence Basis: Adopt LaunchDarkly

## Sourcing audit

| Claim | Source given | Quality |
|-------|-------------|---------|
| "$10 per seat per month" | none, no date | Unverified, undated vendor list price |
| "industry standard, every serious org uses it" | none | Assertion / social proof |
| "building our own would be free" | inference from "we have the infrastructure" | Unsupported; contradicted in same section |
| "would take too long" | none | Unquantified |
| "flag volume will only grow" | none | Speculation stated as fact |
| "cheaper than an engineer's time" | none | Comparison with no numbers on either side |

## Unsupported assertions

Every quantitative and comparative claim in the document is either unsourced or
self-contradicting. The one concrete number ($1,440/year) is built on the
unverified list price and is compared against a build cost that is asserted to be
zero and simultaneously "forever." There is no evidence offered for the build
estimate at all: no spike, no story-point sizing, no reference to how long a
similar internal tool took.

## What is missing

- No requirements list to evaluate any option against.
- No pricing quote confirming the tier that includes the named features (per-user
  targeting is frequently above the entry tier).
- No estimate for the in-house option beyond "too long."
- No data on current or projected flag count, release frequency, or the cost of
  the incidents the kill switch would have prevented.

## What would disprove the recommendation

A same-day spike showing a runtime flag store (flags in a database or a hosted
config service, read at request time) takes two days to build and covers the
stated pain, at which point the $1,440/year recurring cost buys capabilities no
one has shown they need. The document contains nothing that rules this out.
