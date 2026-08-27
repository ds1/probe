# Implications and Consequences: Adopt LaunchDarkly for feature flags

**Source:** `examples/sample-decision.md` (Proposed, Platform team, 2026-08-20)
**Lens:** What follows if this recommendation is accepted as written, what happens downstream, and what it costs to be wrong.

## Summary

The memo identifies a real problem ("Every flag change needs a redeploy ... impossible to turn a feature off quickly if it misbehaves in production") and proposes a plausible solution. But the recommendation is justified with a cost figure that is internally inconsistent and probably wrong, describes a rollout that hard-wires a vendor into the main app with no abstraction layer, and does not address the operational consequences of moving production behaviour changes out of the deploy pipeline. The decision is cheap to make and cheap to reverse this quarter; it becomes expensive to reverse roughly in proportion to how successful it is.

Five load-bearing findings:

1. The kill-switch goal now depends on a third party's availability and the SDK's fallback behaviour, which the memo does not specify.
2. The cost section contradicts itself and models a per-seat-only price; per-user targeting on hosted flag platforms typically carries a usage-based component the memo does not account for.
3. "Add the LaunchDarkly SDK to the main app" with no wrapper turns a reversible trial into a lock-in as flag count grows, which the memo itself predicts ("Flag volume will only grow").
4. Real-time toggling removes flag changes from code review, CI, and deploy audit. The memo treats this as pure upside; it is also a new production change surface with no stated governance.
5. Per-user targeting means user attributes leave the organisation's boundary. The memo does not mention data handling, and the evaluation of alternatives ("industry standard and every serious engineering org uses it") is not an evaluation.

## Consequence chains

### Chain 1: Kill switch becomes vendor-dependent

The memo's core motivation is fast disable in production. Adopting a hosted flag service means:

- SDK added to the main app -> flag evaluation at runtime reads from LaunchDarkly (streamed or polled) -> if LaunchDarkly is unreachable at startup, the SDK serves whatever default the code passes -> if defaults were written as "current on state" (the natural thing when migrating flags that are currently on), an outage at the vendor means the misbehaving feature **cannot be turned off** by the dashboard and the team is back to a redeploy, now with an extra dependency to debug.
- If defaults are written as "off", a vendor outage during a cold start silently disables features.

Neither is catastrophic, but the memo claims the change "unblocks ... safer rollouts" without stating the failure mode. The discipline required (deliberate default per flag, relay proxy or local bootstrap for server-side, a runbook for "LD is down") is the actual cost of the kill-switch guarantee, and it is absent.

### Chain 2: Cost model is wrong in both directions

The memo says:

> "LaunchDarkly is $10 per seat per month. We have 12 engineers, so $120/month, or $1,440/year. Building our own would be free since we already have the infrastructure."

and two sentences later:

> "LaunchDarkly is cheaper than an engineer's time."

These cannot both be true. If building in-house is free, LaunchDarkly is not cheaper. The second statement is the honest one; the first should be deleted, and the in-house cost should be estimated, even roughly, so the comparison is real.

On the vendor side, the figure assumes seats are the only lever. The memo also wants "percentage rollouts, and per-user targeting". Hosted flag platforms generally price the per-user features on a usage basis (monthly contexts or MAU, service connections, experimentation add-ons), with plan minimums and annual contracts at the tier that includes targeting. The exact numbers need to be verified against a current quote, but the direction of error is clear: $1,440/year is a floor, not an estimate. Downstream:

- Budget approved at $1,440 -> real invoice arrives at a multiple of that -> either a second approval cycle mid-migration or a downgrade to a tier without the features that justified the choice.
- "Flag volume will only grow as we scale" is offered as a reason to adopt now. It is also the statement that both cost drivers (seats and evaluated contexts) grow with the business. The memo cites growth as a benefit and never as a cost.

### Chain 3: Reversibility decays with success

The rollout is:

> "add the LaunchDarkly SDK to the main app, migrate our existing 8 environment-variable flags over a sprint"

No wrapper, no internal interface, no mention of a vendor-neutral layer (e.g. OpenFeature). Consequences over time:

- Month 1: 8 flags, direct SDK calls at 8 call sites. Reversing is a day of work.
- Month 6: 40 flags, some with per-user targeting rules that live only in the dashboard. Reversing means rebuilding the targeting semantics somewhere else, not just swapping a client.
- Month 18: flags used for operational config, A/B tests, and entitlements because the dashboard is there and it is easy. The flag service is now load-bearing infrastructure. Reversing is a quarter, and the renewal negotiation happens with that leverage on the vendor's side.

The memo's own forecast ("before it becomes unmanageable") is the mechanism of lock-in. This is not an argument against adopting; it is an argument that the abstraction decision has to be made in the first sprint, because it cannot be retrofitted cheaply.

### Chain 4: A new production change path with no governance

Today a flag change is a redeploy: it goes through code review, CI, and the deploy log. The memo frames this purely as friction. After adoption:

- Any seat holder can change production behaviour from a browser, with no review and no CI.
- Incident timelines now have two axes (what was deployed, what was toggled). Unless flag-change events are exported to the same place as deploy and error logs, "what changed?" becomes harder to answer, not easier.
- "train the team on the dashboard" is the only governance mentioned. Who is allowed to flip a flag in production, whether a second approver is required for high-blast-radius flags, and whether toggles are announced anywhere are all undefined.

The memo says 12 engineers get seats. In practice product, QA, and support will want to toggle things too. Either seat count grows (cost) or credentials get shared (the audit trail is lost, which defeats the point of the dashboard).

### Chain 5: Flag sprawl becomes the next problem

Environment variables are annoying enough to create friction against adding flags. A dashboard removes that friction. Without a lifecycle policy (owner, expiry date, cleanup ticket at 100% rollout):

- Flags are created freely -> stale flags accumulate -> dead code paths persist behind flags nobody remembers -> the combinatorial test surface grows -> "safer rollouts" is undermined by the tool that was supposed to deliver it.

The memo's phrase "before it becomes unmanageable" assumes the platform manages the volume. The platform stores the volume; the team still has to manage it.

### Chain 6: User data leaves the boundary

"per-user targeting" means the app sends user identifiers and, in practice, attributes (plan, region, account age, email domain) to the vendor on every evaluation or via context sync. That implies:

- A data-processing agreement and a vendor security review before the first production flag, not after.
- A decision about what attributes are permitted in targeting contexts (hashed IDs versus raw emails, for instance).
- If the product has any regulatory exposure over user data, the flag platform is now in scope for it.

The memo does not mention any of this. It is not a blocker, but it is a lead-time item that will delay "this quarter" if discovered late.

## Scenario analysis

**What if the real price is 3-5x the memo's figure?**
Likely. The migration is already under way when the invoice arrives. Options are: absorb it (the decision was made on wrong numbers), downgrade (lose targeting, which was half the justification), or stop (sunk sprint). Cheap to prevent: get a written quote for the tier that includes the features listed, at 12 seats and projected context volume, before signing.

**What if LaunchDarkly has an extended outage during an incident?**
Depends entirely on SDK default and bootstrap decisions that the memo does not make. If made deliberately, it is a non-event. If made accidentally, the team discovers the kill switch does not work at the moment it matters.

**What if the team wants to leave in two years?**
With direct SDK calls at every site and targeting rules living in the dashboard, exit cost is a quarter or more. With an internal interface from day one, exit cost is roughly the size of the adapter plus re-creating rules. The difference is one design decision in sprint one.

**What if "would take too long" is wrong?**
The in-house alternative is dismissed in one sentence with no estimate. A minimal kill-switch (a flags table, a cached read with a short TTL, an admin page) is days of work, not months, and would solve the stated problem for 8 flags. It would not give percentage rollouts or per-user targeting. The memo never says whether those are needed now or wanted eventually. If they are eventual, the decision is being made for hypothetical future requirements at present recurring cost.

**What if "industry standard" is doing the work of an evaluation?**
"This is the industry standard and every serious engineering org uses it" is an appeal to popularity, not a comparison. Several hosted and self-hosted alternatives exist, and a vendor-neutral SDK standard exists specifically so the choice can be deferred. If the memo is approved on this sentence, the org has chosen its most expensive option by default and cannot later show that it chose deliberately.

**What if the 8 existing flags are not really feature flags?**
Environment-variable "flags" often turn out to be per-environment configuration (different behaviour in staging vs production) rather than runtime toggles. Migrating config into a flag platform is a category error that makes environments harder to reason about. The sprint should start by classifying the 8, not migrating them.

## Risk assessment

| Risk | Likelihood | Impact | Reversibility | Note |
|---|---|---|---|---|
| Actual cost materially exceeds $1,440/yr | High | Medium | Easy to fix before signing, awkward after | Get a quote for the tier with targeting |
| Kill switch fails during vendor outage | Low-Medium | High (at the worst moment) | Easy if defaults are chosen deliberately | Currently unaddressed |
| Vendor lock-in via direct SDK calls | High over 12+ months | Medium-High | Hard after ~6 months | One sprint-one design choice prevents it |
| Ungoverned production toggles | High | Medium | Moderate | Define roles and export change events |
| Flag sprawl / stale flags | High | Medium (slow compounding) | Moderate | Lifecycle policy from the start |
| User attributes sent to vendor without review | Medium | Depends on data exposure | Easy if caught early | Lead-time item for "this quarter" |
| In-house option dismissed without estimate | Certain (it already was) | Low-Medium | N/A | Decision quality, not runtime risk |

## Timeline of implications

**This quarter (adoption):** Sign-up, SDK in main app, 8 flags migrated. Hidden work: default-value policy, wrapper or no wrapper, DPA/security review, who gets seats. If these are skipped, the quarter finishes on time and the debt is invisible.

**Months 3-6:** Flag count grows past the original 8. First invoice reflects actual tier and usage. First "who flipped that?" incident. Team either adds process now or normalises ad-hoc toggling.

**Months 6-12:** Targeting rules accumulate in the dashboard. Non-engineers want seats. Flags start being used as config and for experiments. The decision is now effectively irreversible at low cost.

**Month 12 (renewal):** Negotiation happens with the vendor holding the leverage the memo built for them. Any price change is absorbed because the alternative is a quarter of migration work.

## What the memo gets right

The problem statement is sound and the timing argument (act while there are 8 flags, not 80) is the strongest sentence in the document. The acknowledgement that in-house means "maintain it forever" is correct and is the real reason to buy rather than build. None of the findings above argue against adopting a flag platform. They argue that the recommendation as written commits the team to consequences it has not priced.

## Minimum changes that would alter the consequence profile

These are the smallest edits that change what follows from approval, offered as questions the memo should answer rather than as a plan:

- Replace "$10 per seat ... $1,440/year" with a written quote for the tier that includes percentage rollouts and per-user targeting, at 12 seats and expected context volume, and delete "Building our own would be free."
- State the SDK fallback policy (default per flag, bootstrap/relay for server-side) as part of the rollout, since it is the mechanism that makes the kill switch actually work.
- Decide in sprint one whether flag evaluation goes through an internal interface. This is the single choice that determines whether the decision stays reversible.
- Name who may change production flags and where flag-change events are logged.
- Add flag ownership and expiry to the migration, so "manageable" is a property of the process rather than a hope about the tool.
- Either name the alternatives considered or remove "industry standard" as the justification.
