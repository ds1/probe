# Evidence Basis Probe: "Adopt LaunchDarkly for feature flags"

**Source:** `examples/sample-decision.md` (Platform team, 2026-08-20, status Proposed)
**Probe:** Evidence and basis for arguments

## Summary

The memo contains no citations, no measurements, and no dated inputs. Every claim rests on one of three things: the team's own experience of the current pain, an unsourced recollection of vendor pricing, or a generalization about the industry. The problem statement (env-var flags require a redeploy) is credible on its face and is the only part of the memo that would survive a request for evidence. The cost analysis is internally contradictory, the "industry standard" claim is asserted rather than shown, and the decision is framed as a binary (LaunchDarkly vs. build) with no evidence that any other option was examined.

## Source categorization

| Claim | Location | Source type | Bias / reliability |
|---|---|---|---|
| Env-var flags need a redeploy; can't turn a feature off quickly | Context | Team experience (first-hand) | Credible but unquantified; no redeploy time, no incident cited |
| "The team wants proper feature flags" | Context | Team experience | Interested party; no indication of how many people or which roles |
| Dashboard, percentage rollouts, per-user targeting | Proposal | Vendor feature list (restated) | Accurate but non-differentiating; every flag product offers these |
| "Industry standard and every serious engineering org uses it" | Proposal | Unsupported generalization | No source; falsifiable as stated |
| $10 per seat per month | Cost | Vendor pricing (recalled, undated, unlinked) | Unverifiable from the memo; LaunchDarkly has repriced and restructured tiers several times |
| 12 engineers, therefore 12 seats | Cost | Author inference | Assumes seat count equals headcount; no evidence this matches the vendor's licensing unit |
| "Building our own would be free" | Cost | Author assertion | Contradicted two sentences later |
| "Would take too long ... maintain it forever" | Cost | Author inference | No hours, no scope, no comparison to SDK integration and migration effort |
| "Cheaper than an engineer's time" | Cost | Inference with neither side quantified | Rhetorical, not evidentiary |
| 8 existing flags; migration fits in a sprint | Rollout | Team knowledge (flag count) + estimate (duration) | Flag count is plausible primary data; sprint estimate is unsupported |
| "Flag volume will only grow as we scale" | Rollout | Inference / forecast | No roadmap, growth rate, or historical trend cited |

No independent research, third-party benchmark, trial result, or primary measurement appears anywhere in the memo.

## Specific analysis of cited claims

### 1. The pricing figure is unsourced, undated, and probably the wrong unit

> "LaunchDarkly is $10 per seat per month. We have 12 engineers, so $120/month, or $1,440/year."

The arithmetic is correct given its inputs; the inputs are the problem. No pricing page, quote, or date is given. LaunchDarkly's pricing has historically mixed per-seat charges with usage-based charges (monthly active users or "contexts" for client-side SDKs, service connections, experimentation add-ons), and the public tiers have been restructured more than once. A memo dated August 2026 quoting a round $10/seat figure with no link reads as recalled from an old pricing page or a blog post.

Two specific risks the memo does not surface:

- **Per-user targeting is the feature most likely to trigger usage-based charges.** The memo lists it as a benefit and then prices only seats. If the app evaluates flags client-side for end users, the cost line is incomplete.
- **Seat count is asserted, not derived.** "12 engineers" may be right for people who commit code; it says nothing about whether product, QA, or support need dashboard access, or whether read-only roles are billed.

The number to fix the analysis is a dated quote from the vendor for this team's actual usage shape, not a correction to the multiplication.

### 2. The build-vs-buy comparison contradicts itself and quantifies neither side

> "Building our own would be free since we already have the infrastructure."

followed immediately by

> "We considered building in-house but it would take too long and we would have to maintain it forever. LaunchDarkly is cheaper than an engineer's time."

The first sentence says build costs nothing; the second says it costs more than the vendor. Both cannot be true, and neither is supported. There is no estimate of build hours, no scope (a Redis-backed boolean flag service with a small admin page is a very different project from a full targeting engine), no loaded engineer rate, and no estimate of the ongoing maintenance the memo says would last "forever." The vendor side is equally unestimated: SDK integration, migration of the 8 flags, dashboard training, and the operational cost of a new external dependency are all listed as work in the Rollout section but priced at zero in the Cost section.

"Cheaper than an engineer's time" is the load-bearing sentence of the whole memo, and it compares an unstated number to another unstated number.

### 3. "Industry standard" is a claim about the world with no evidence attached

> "This is the industry standard and every serious engineering org uses it."

This is the memo's only argument for choosing LaunchDarkly specifically (as opposed to any hosted flag product), and it is asserted, not shown. As written it is false: many large engineering organizations run in-house flag systems, and a vendor-neutral flag API standard (OpenFeature, under the CNCF) exists precisely because the market is not consolidated on one vendor. The claim also does the work that a comparison of alternatives should have done. If the author has a survey, an analyst report, or a list of peer companies in mind, it should be cited; if not, the sentence should be removed and replaced with the actual selection criteria.

### 4. The problem statement is credible but unmeasured

> "Every flag change needs a redeploy, which slows down releases and makes it impossible to turn a feature off quickly if it misbehaves in production."

This is the strongest part of the memo because it describes something the team observes directly. It would be stronger with three numbers the team almost certainly has: how long a redeploy takes, how many flag changes happen per week or sprint, and whether there has been an incident where a slow kill switch mattered. "Impossible to turn off quickly" means something different if a redeploy is 4 minutes versus 45. Without the redeploy time, a reader cannot tell whether this is a real operational risk or an inconvenience.

### 5. The growth forecast is an assumption presented as a fact

> "Flag volume will only grow as we scale, so getting on a real platform now is the right move before it becomes unmanageable."

Eight flags is the only data point. There is no historical count (how many flags a year ago?), no roadmap reference, and no threshold for "unmanageable." The forecast may well be right, but it is being used to justify urgency ("this quarter") and it has no support.

## Evidentiary gaps

Evidence that is absent and would materially change the strength of the argument, in rough order of impact:

1. **Any alternative other than "build."** No mention of other hosted vendors or of self-hostable open-source options (Unleash, Flagsmith, GrowthBook, and others exist in this space). A decision to lock in a vendor without listing what was rejected, and why, cannot be evaluated.
2. **A dated vendor quote** for this team's usage shape (seats, plus whatever usage-based dimension applies to client-side per-user targeting).
3. **A scoped build estimate** (even a rough one: hours to a minimal flag service that covers the 8 current flags, plus hours per year to maintain) so the "cheaper than an engineer's time" sentence has two numbers in it.
4. **Redeploy time and flag-change frequency**, which turn the problem statement from anecdote into measurement.
5. **Any incident or near-miss** where a slow kill switch caused or prolonged an outage. If none exists, the "misbehaves in production" scenario is hypothetical and should be labeled as such.
6. **Exit cost and lock-in.** Nothing about what happens to the 8 (or 80) flags if the vendor is dropped, whether the SDK will be wrapped behind an internal interface or a neutral API, or what data leaves the network when per-user targeting is used.
7. **A trial or proof of concept.** The memo asks to "sign up ... this quarter and start the migration." There is no evidence the SDK has been tried against the main app.
8. **Basis for "a sprint."** The migration estimate has no decomposition and no reference to comparable past work.

## Reliability assessment

**Author position.** The Platform team is an interested party in a specific way: it would own either solution, and buying externalizes the maintenance burden the memo explicitly wants to avoid ("maintain it forever"). That is a legitimate preference, but it means the build estimate is coming from the party with the strongest incentive to inflate it, and it should be stated with numbers so others can check it.

**Vendor-derived content.** The feature list in the Proposal (dashboard, percentage rollouts, per-user targeting) and the price in the Cost section are the only externally sourced content, and both trace back to the vendor with no independent confirmation. The feature list is accurate but does not distinguish LaunchDarkly from any competitor; the price is the memo's only hard number and it is unverified.

**Internal consistency.** The Cost section contradicts itself on whether building is free. The Rollout section lists real work (SDK integration, migration, training) that the Cost section prices at zero. These are not evidence problems so much as signs the memo was written to a conclusion.

**What holds up.** The existence of the problem (redeploy-gated flags) and the current flag count (8) are first-hand and plausible. Everything downstream of those two facts is inference or assertion.

## Bottom line

The memo makes a reasonable case that the team should have runtime feature flags. It makes no evidenced case for LaunchDarkly in particular, no evidenced case that buying beats building, and no evidenced case for urgency. The three sentences a reviewer should push back on are: "This is the industry standard and every serious engineering org uses it," "Building our own would be free," and "LaunchDarkly is cheaper than an engineer's time." Each is presented as a fact; none is supported; the last two contradict each other.
