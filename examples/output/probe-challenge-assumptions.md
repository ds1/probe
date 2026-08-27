# Challenge Assumptions: "Adopt LaunchDarkly for feature flags"

**Source:** `examples/sample-decision.md` (Proposed, Platform team, 2026-08-20)
**Lens:** hidden assumptions, unexamined premises, comparison fairness, robustness

## Summary

The memo argues for a vendor by describing a pain ("every flag change needs a redeploy"), asserting a norm ("every serious engineering org uses it"), and comparing the vendor's list price against a single unpriced alternative ("building our own"). The direction it points at, dynamic flags instead of env-var checks, may well be correct. But the memo does not establish that; it establishes a preference. Almost every load-bearing claim is asserted rather than measured, and the one comparison it makes is between a real number and a guess. The recommendation survives only if several unstated things happen to be true.

The findings below are ordered by how much of the conclusion rests on them.

---

## 1. The diagnosed problem may not be the flag mechanism

> "Every flag change needs a redeploy, which slows down releases and makes it impossible to turn a feature off quickly if it misbehaves in production."

This sentence carries the whole memo, and it bundles two assumptions:

**(a) That env-var flags inherently require a redeploy.** They do not. Whether a flag change is a "redeploy" depends on the deploy pipeline and runtime, not on the flag being an env var. Many platforms reload config on restart in seconds; some hot-reload without one. If the team's redeploy is slow, that is a property of the pipeline.

**(b) That "quickly" is not achievable today.** No number is given. How long does a redeploy actually take? Ten minutes? Forty? If the honest answer is "about eight minutes, and we have never needed faster," the case for a platform is much weaker than the sentence implies.

Probing questions:

- What is the current wall-clock time from "decide to flip" to "flag is live in production"? Has this been measured, or is "impossible to turn off quickly" a feeling?
- Has there been an incident where a feature misbehaved and the redeploy time caused measurable harm? If yes, that incident belongs in the memo. If no, the urgency is speculative.
- If the pipeline were fast (say, a sub-minute config reload), would the team still want a flag platform? If the answer is "yes, for percentage rollouts," then that is the real requirement and the memo should lead with it.

If (a) is the actual bottleneck, LaunchDarkly does not fix slow deploys; it routes around them for the one class of change that is a flag flip, and leaves every other production change just as slow. The memo's closing claim, "this unblocks faster releases," would then be true for flags only and misleading as a general statement.

## 2. "The team wants proper feature flags" is a desire presented as a requirement

> "The team wants proper feature flags."

Nothing in the memo converts this want into a specification. "Proper" is doing a lot of work. The Proposal section lists three capabilities, "a dashboard for toggling flags in real time, percentage rollouts, and per-user targeting," but never says which of these are needed versus nice-to-have, or what problem each one solves for this team.

Probing questions:

- Which of the current 8 flags would benefit from percentage rollout today? Which need per-user targeting? If the answer is "none yet," those features are being bought for a hypothetical future.
- Who, specifically, needs to flip flags? If it is only engineers, a dashboard for non-engineers is not a requirement. If it is product or support, the seat count in the Cost section is wrong (see Finding 4).
- Would a database table, an admin endpoint, and a short-TTL cache satisfy the real-time toggle need? That is a few days of work, not "forever."

Per-user targeting in particular deserves scrutiny it does not get. It means sending user attributes to a third party. The memo does not mention privacy, data residency, or what attributes would leave the building. For a team whose user data has any compliance surface, that is a decision in its own right, not a bullet point.

## 3. "Industry standard" is an appeal to popularity, and a false one

> "This is the industry standard and every serious engineering org uses it."

This is unfalsifiable as written and false as read. Plenty of serious engineering organizations use Unleash, Flagsmith, GrowthBook, Statsig, Split, ConfigCat, or something homegrown; several large ones built their own precisely because vendor pricing scales badly with users. The sentence also carries a status threat: if you disagree, you are not serious. That is a rhetorical move, not evidence.

More importantly, even if it were true, "everyone uses it" does not tell this team whether it fits their scale (8 flags, 12 engineers, one app). The tools that large organizations converge on are often exactly the wrong tools for small ones.

Probing question: name three organizations of comparable size and stage that adopted LaunchDarkly at 8 flags and would make the same call again. If nobody can, drop the sentence and make the argument on merits.

## 4. The cost comparison is between a list price and a guess, and it contradicts itself

> "LaunchDarkly is $10 per seat per month. We have 12 engineers, so $120/month, or $1,440/year. Building our own would be free since we already have the infrastructure."

> "We considered building in-house but it would take too long and we would have to maintain it forever. LaunchDarkly is cheaper than an engineer's time."

Several problems compound here.

**The alternative is priced two different ways in adjacent paragraphs.** Building is "free" in the first, and "too long" plus "forever" in the second. Both cannot be true. Neither is quantified. What would the build actually take: one engineer for a week? Two for a month? Without a number, "cheaper than an engineer's time" is unfalsifiable.

**The vendor price is likely the wrong tier.** The $10-per-seat figure matches an older entry tier. The vendor has moved toward pricing on service connections and monthly context (user) volume, and per-user targeting, one of the three capabilities the memo wants, is precisely what drives context volume. Verify against a current quote for the tier that actually includes percentage rollouts and per-user targeting. If the real number is two or three times the memo's, the comparison shifts.

**The seat count assumes only engineers use the dashboard.** If product managers, support, or QA will toggle flags (which is the usual reason to want a dashboard at all), they need seats. The memo's own framing, "train the team on the dashboard," suggests a broader audience than 12 engineers.

**Migration and integration cost is omitted entirely.** "Migrate our existing 8 environment-variable flags over a sprint" is a cost. So is SDK integration, fallback handling, and the ongoing tax of keeping the SDK current. The build alternative is charged for maintenance "forever"; the buy alternative is charged for nothing beyond the subscription.

**Only two options are compared.** The memo frames the choice as LaunchDarkly versus build-from-scratch. That is a false dichotomy. Self-hosted open-source flag servers exist, sit between the two in cost and effort, and are not mentioned. A comparison that excludes the middle of the option space is not a comparison.

Probing questions:

- What would a one-week build (DB table, admin toggle, cached lookup, audit log) actually cost, and what would it lack that this team needs in the next twelve months?
- What is the quote for the tier that includes the three named features, at the realistic seat count, at projected user volume?
- Why was no self-hosted or open-source option evaluated?

## 5. "Flag volume will only grow" is asserted, and growth may be a smell rather than a destiny

> "Flag volume will only grow as we scale, so getting on a real platform now is the right move before it becomes unmanageable."

Two assumptions: that flag count grows with scale, and that growth is good or at least inevitable. Neither is argued.

Well-run flag practices treat flags as short-lived: created for a rollout, removed when the rollout finishes. Under that discipline, flag count stays roughly flat regardless of company size. A steadily growing flag count usually indicates flags that were never cleaned up, which a vendor dashboard makes easier to tolerate, not easier to fix. "Before it becomes unmanageable" presupposes that 8 flags are on a trajectory toward unmanageability; nothing in the memo shows that trajectory.

Probing questions:

- Of the current 8 flags, how many are permanent operational toggles versus temporary rollout gates that should already have been deleted?
- What is the flag count expected to be in twelve months, and on what basis?
- Does the platform team have, or plan, a flag-retirement practice? If not, the platform will accelerate the problem it claims to prevent.

## 6. The memo treats real-time toggling as pure upside and ignores the risk it introduces

> "It gives us a dashboard for toggling flags in real time"

A production toggle in a dashboard is a production change with no code review, no CI, and no deploy gate. Today, flipping a flag requires the same review path as any other change; that is friction, but it is also a safety property the memo proposes to remove without saying so.

Unstated presuppositions:

- That whoever has dashboard access should be able to change production behavior instantly.
- That the audit trail, approval workflow, and environment separation will be adequate by default.
- That the SDK's behavior when the vendor is unreachable (default values, stale cache, startup latency) is acceptable for this app, and that someone has thought about what "flag service down" does to the main app.

None of these are addressed. "Train the team on the dashboard" is the only nod to operational change, and it treats the change as a UI-familiarity problem rather than a governance one.

## 7. There is no exit, and the memo does not notice it is a dependency lock

> "We will add the LaunchDarkly SDK to the main app"

SDK calls spread through a codebase. Once flag evaluation is `ldClient.variation(...)` in dozens of places, switching vendors or moving in-house is a refactor, not a config change. The memo does not mention an abstraction layer (a thin internal interface, or a vendor-neutral standard such as OpenFeature) that would keep the vendor swappable. For a decision that would land as a logged dependency choice, the absence of any reversibility discussion is itself a finding.

Probing questions:

- If the price doubles at renewal, what is the exit path and what does it cost?
- Will flag evaluation go through an internal wrapper, or will the vendor SDK be called directly?

---

## Robustness: what happens if the key assumptions are wrong

| If this is false... | ...then |
|---|---|
| Redeploy is actually slow and inherent (Finding 1) | If redeploy is fast or could be made fast, the primary motivation largely evaporates; what remains is a want for percentage rollouts, which is a smaller, differently-shaped requirement. |
| $10/seat covers the needed features (Finding 4) | If the real tier costs 2-3x, or scales with users, the "cheaper than an engineer" claim inverts at modest scale, and the build or self-host options become the cheap ones. |
| Building is "too long" (Finding 4) | If a minimal in-house solution is a week of work, the memo's central trade-off (subscription versus engineer time) resolves the other way for years. |
| Flag count will grow (Finding 5) | If flag count stays near 8-15 with reasonable hygiene, the "before it becomes unmanageable" urgency disappears and any lightweight solution suffices indefinitely. |
| Only engineers need seats (Finding 4) | If product and support need access, seat cost rises and the governance questions in Finding 6 become sharper. |
| Vendor availability is a non-issue (Finding 6) | If the SDK's offline behavior is not designed for, the platform introduces a new production failure mode the env-var approach did not have. |

The conclusion is not robust. It survives only if redeploys are genuinely slow and unfixable, the entry tier genuinely includes the needed features at the stated price, the in-house build is genuinely expensive, and flag volume genuinely grows. Each of those is plausible; none is shown; and the memo needs all of them.

## What would make this a decision rather than a preference

The memo does not need to change its recommendation. It needs to earn it. Concretely:

1. **Measure the current pain.** Redeploy time in minutes, number of times in the last six months a slow flag flip mattered, and what it cost.
2. **State the requirement, not the want.** Which of real-time toggle, percentage rollout, and per-user targeting are needed in the next twelve months, and for which flags.
3. **Price all three options honestly.** A current vendor quote at the right tier and realistic seat and user counts; a self-hosted open-source option with hosting and maintenance estimated; a minimal in-house build with an actual engineer-day estimate. Include migration cost on every branch.
4. **Address the risks the memo currently omits.** Third-party user data, dashboard governance, SDK offline behavior, and vendor lock-in with a named mitigation (wrapper or OpenFeature).
5. **Delete the appeal to popularity.** "Every serious engineering org uses it" weakens the memo by signaling that the author reached for status when evidence was available.

If, after that work, LaunchDarkly still comes out ahead, the memo will say so with numbers and the team will know what it is buying and why. Right now it knows what it wants.
