# Synthesis: Adopt LaunchDarkly

## Executive summary

The proposal jumps from a real but narrow pain (changing a flag requires a
redeploy, and there is no fast kill switch) straight to buying a specific per-seat
SaaS platform, skipping the requirements and options steps in between. Its cost
case is built on an undated list price and an "in-house is free" comparison that
the document contradicts in its own next sentence. As written, it is not ready to
action: it should first define the required capability and price the cheapest
option that delivers it.

## Critical findings

| # | Lens | Key finding |
|---|------|-------------|
| 1 | Clarify Thinking | "Proper feature flags" bundles four distinct capabilities of very different cost; the requirement is never defined. |
| 2 | Challenge Assumptions | Accounting is asymmetric: all "forever" cost is loaded onto build, none onto buy; the whole case rests on an unquantified growth assumption. |
| 3 | Evidence Basis | Every quantitative and comparative claim is unsourced or self-contradicting; the one number rests on an undated list price. |
| 4 | Alternative Viewpoints | False binary. Open-source flags and a minimal runtime flag store, the options teams this size usually pick, are absent. |
| 5 | Implications | New recurring cost that scales with headcount, a runtime dependency with an unspecified fail mode, and lock-in that rises with every flag. |
| 6 | Question the Question | It answers "which vendor?" before settling "do we need a platform yet?" and mis-scopes a small pain as a platform decision. |

## Evidence quality

Low. There is no requirements list, no confirmed pricing quote for the tier that
includes the named features, and no in-house estimate beyond "too long." The
central "flag volume will only grow" claim, which the recommendation depends on,
is speculation stated as fact.

## Assumption risk matrix

| Assumption | Confidence | Impact if wrong |
|-----------|-----------|-----------------|
| Flag volume grows well beyond 8 | Low, unsourced | High: the "get on a platform now" case collapses |
| $10/seat is the real, stable price | Low, undated | Medium: true cost and tier may be higher |
| We need targeting / rollouts, not just toggling | Unstated | High: a days-long build would suffice |
| Adoption is reversible | Implied, false | Medium: lock-in rises with every flag added |

## Unexplored alternatives

1. Open-source feature flags (Unleash, Flagsmith, GrowthBook), self-hosted or
   low-cost managed.
2. A minimal runtime flag store (DB or hosted config, read at request time) with a
   small admin page, covering the exact stated pain in days.
3. Remote config from a provider already in the stack.

## Hidden costs and consequences

Recurring cost that scales with hiring rather than usage; a new runtime dependency
whose flag-evaluation fail mode is unspecified; a new data-processing relationship
once user targeting sends identifiers to the vendor; flag sprawl absent a lifecycle
policy; and progressively rising switching cost.

## The meta-question

Not "which feature-flag vendor should we buy?" but "do we need to buy one yet, and
what is the cheapest thing that fixes the actual pain?" Settle the prior question
first.

## Decision framework: validate before proceeding

- [ ] Write the requirement: which capabilities are must-have (toggling? rollouts?
      targeting? non-engineer dashboard?) versus nice-to-have.
- [ ] Get a real quote for the tier that includes the must-haves, with a date.
- [ ] Spike the minimal runtime flag store; record how long it actually took.
- [ ] Quantify current and projected flag count and release frequency.
- [ ] Specify the flag-evaluation fail mode and a flag-lifecycle policy for
      whichever option wins.
- [ ] Write the reversal trigger: what would make us walk this back.

## Stakeholder questions

- **CTO:** are we buying for the pain we have, or for a scale we are assuming?
- **CFO:** is a per-seat cost that grows with headcount the right shape versus a
  one-time build?
- **Security:** does user-targeting data leaving our systems need review?
- **Product:** is there a concrete near-term need for per-user targeting, or is
  this speculative?

## Final verdict

Not ready to action as written. The pain is real and worth fixing this quarter,
but the decision should be reframed around the required capability and the
cheapest option that delivers it. Recommend a one-day spike of the minimal flag
store plus a dated vendor quote, then decide with numbers on both sides.
