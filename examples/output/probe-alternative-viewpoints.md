# Alternative Viewpoints: "Adopt LaunchDarkly for feature flags"

Source: `examples/sample-decision.md` (Proposed, Platform team, 2026-08-20)

This is a one-page team memo, so the evaluation is scoped to match. The memo makes a reasonable observation (redeploying to flip a flag is painful) and then jumps to a specific vendor without showing the middle of the argument. Most of what follows is about that missing middle.

## 1. The strongest counter-arguments

### "The problem stated does not require the solution proposed"

The Context section defines the problem precisely: "Every flag change needs a redeploy, which slows down releases and makes it impossible to turn a feature off quickly if it misbehaves in production." That is a *kill-switch latency* problem. The Proposal then buys "percentage rollouts, and per-user targeting", neither of which the Context asks for. A hot-reloadable config source (a database table with a short-TTL cache, a parameter store, Consul/etcd) fixes the stated problem with none of the new capabilities and none of the new vendor. If the team actually wants gradual rollouts and targeting, the memo should say so in Context; right now the proposal is larger than its own justification.

### "The memo concedes the build case and then dismisses it"

Cost says: "Building our own would be free since we already have the infrastructure." The next paragraph says building "would take too long and we would have to maintain it forever." Both cannot be true in the strong form stated. But the more damaging reading is the charitable one: if the infrastructure already exists, a minimal flag table plus an admin endpoint is a few days of work, not a platform. "Maintain it forever" describes an eight-row config table the same way it describes a bespoke targeting engine, and those are not the same burden. The memo never sizes the build option, so "too long" is an assertion, not an estimate.

### "The buy side has hidden engineer time too"

The memo frames the trade as "$1,440/year" versus "an engineer's time", as if only the build path consumes engineers. But Rollout commits to "add the LaunchDarkly SDK to the main app, migrate our existing 8 environment-variable flags over a sprint, and train the team on the dashboard." That is a sprint of engineer time on the buy side, plus ongoing time for SDK upgrades, flag hygiene, and access management. The comparison omits the integration cost of the option it recommends while charging it fully to the option it rejects.

### "The price is uncited and structurally incomplete"

"$10 per seat per month" appears with no source, tier name, or contract term. Commercial flag vendors, LaunchDarkly included, have historically priced on more than seats: usage dimensions (monthly active contexts / client-side users, service connections, experimentation events) are typically separate line items, and list prices change. Even if $10/seat is correct for some tier today, a memo that says "Flag volume will only grow as we scale" should also expect the bill to grow with it. Finance would want the actual quote and the renewal terms, not a back-of-envelope multiplication.

### "Industry standard" is doing the work that evidence should do

"This is the industry standard and every serious engineering org uses it." This is an appeal to popularity, and it is also not accurate: many organizations use Unleash, Flagsmith, GrowthBook, Statsig, Split, ConfigCat, PostHog's flags, or homegrown systems, and the OpenFeature spec exists precisely because there is no single standard. The sentence is a tell that vendor selection happened before the analysis did.

## 2. Perspectives not represented

| Perspective | What they would ask that the memo does not answer |
|---|---|
| **Finance / procurement** | What tier? Annual or monthly? Usage-based components? Price at 2x and 5x current scale? What does exit cost? |
| **Security / privacy** | "Per-user targeting" means shipping user attributes to a third party. Which attributes? Is a DPA needed? Any data-residency constraint? Who audits flag changes? |
| **SRE / on-call** | What happens when the vendor is down or the SDK fails to initialize: what are the default values, and who decided them? A new external dependency in the app's startup path is a new failure mode. |
| **Future maintainers** | Will flags be called through the vendor SDK directly, or behind an internal interface (e.g. OpenFeature)? Direct calls in a codebase make the vendor very hard to leave. The memo also assumes a platform *manages* flag sprawl; in practice it makes creating flags cheap and removing them optional. |
| **Product / QA** | How do flags behave in local dev, CI, and staging? Does every test run need vendor connectivity? Does the test matrix double per flag? |
| **Non-engineers (PM, support)** | Will they get seats to toggle or inspect flags? If yes, the seat count and cost change. If no, the "dashboard" is still engineer-only and the release-speed benefit is smaller than implied. |
| **The team itself** | "The team wants proper feature flags." Was the team asked what *proper* means, or was this a proxy for "not env vars"? |
| **The author in 18 months** | Renewal quote in hand, 150 flags, 40 of them stale, and a question from leadership about why a flag config lives outside the company. Would this memo have prepared them? |

## 3. Internal contradictions

1. **Free and expensive at once.** "Building our own would be free" sits one paragraph above "we would have to maintain it forever." The memo needs to pick a build-option size and cost it honestly.
2. **Small now, unmanageable soon.** The team has "8 environment-variable flags" and the memo argues for a platform "before it becomes unmanageable." Eight flags is not close to unmanageable, and the growth claim ("Flag volume will only grow") is unsupported. A platform that lowers the cost of creating flags is at least as likely to *cause* the sprawl it is justified by.
3. **Speed problem, feature answer.** Context is about redeploy latency; Proposal is about targeting and rollout percentages. If the redeploy is slow, that slowness also hurts every non-flag change, and a flag vendor does nothing for those.
4. **Engineer time counted on one side only.** See section 1; a sprint of integration is engineer time the memo does not charge to the buy option.
5. **"This quarter" with no gate.** Recommendation says "Sign up for LaunchDarkly this quarter and start the migration" with no trial, pilot, success criteria, or condition under which the team would stop. A proposal that is confident it is right should be able to say what would prove it wrong.

## 4. Alternative approaches not explored

| Option | Best case for it | What it gives up | Fits the stated problem? |
|---|---|---|---|
| **Hot-reloadable config** (DB table + cached read, or SSM/Consul/etcd) | Directly fixes "needs a redeploy". Days of work on infrastructure the memo says already exists. No new vendor, no user data leaves the system. | No UI unless you build one; no percentage rollouts or targeting out of the box. | Yes, exactly. |
| **Self-hosted open source** (Unleash, Flagsmith, GrowthBook) | Dashboard, rollouts, targeting, audit log, no per-seat license, data stays in-house. Several support OpenFeature. | You run and upgrade it; self-hosting has an ops cost the memo would need to size. | Yes, plus the extras. |
| **Lower-cost or bundled SaaS** (ConfigCat, Flagsmith cloud, Statsig, PostHog flags if PostHog is already in use) | Same category of product, often with a free or cheap tier at 12 seats. If the team already pays a vendor that includes flags, the marginal cost may be zero. | Smaller ecosystems; still a third party. | Yes. |
| **LaunchDarkly behind an abstraction** (OpenFeature or a thin internal interface) | Keeps the recommendation but caps exit cost: flags are called through one interface and the provider is swappable. | Slight indirection; must be enforced in review. | Yes, and it addresses the lock-in concern the memo ignores. |
| **Fix the deploy pipeline instead** | If a redeploy is slow enough that flags feel necessary for a kill switch, every hotfix is also slow. Faster deploys plus infra-level canary/rollback helps all changes, not just flagged ones. | Does not give runtime toggles; harder, larger project. | Partially; addresses the root cause rather than the symptom. |
| **Do nothing yet, define criteria first** | Eight flags is a small enough number that the team can afford a two-week trial of one or two options against written criteria (kill-switch latency, local-dev story, failure mode, exit cost, all-in price at 3x scale). | Delays the decision by a sprint. | N/A; it is the process that would produce a defensible answer. |

## 5. Questioning the framing

The memo frames this as **build vs. buy**, then collapses the buy side to a single vendor and the build side to a caricature. Two other framings produce different recommendations:

- **Reversibility.** The cheapest decision is not the one with the lowest monthly fee; it is the one that is cheapest to undo. A config table or an OpenFeature-fronted vendor is cheap to undo. SDK calls scattered through the main app are not. The memo never uses the word.
- **What is the flag system *for*?** If the answer is "kill switches and dark launches", the bar is low and many options clear it. If the answer is "experimentation and per-customer entitlements", that is a different product category with different privacy and data implications, and the memo should say so. Right now the memo borrows the ambition of the second while justifying with the needs of the first.

## Summary of load-bearing findings

1. The stated problem (redeploy to flip a flag) is solved by any hot-reloadable config; the proposal buys much more than the problem requires and never justifies the extra.
2. The cost comparison is one-sided: build is called both "free" and "forever", buy omits its own sprint of integration and any usage-based or renewal pricing, and the $10/seat figure has no source.
3. No perspective outside the platform team appears; privacy (user attributes to a third party), on-call (new startup dependency and default-value behavior), and exit cost (SDK lock-in) are the three most consequential absences.
4. Several credible alternatives (self-hosted OSS, cheaper or already-paid-for SaaS, LaunchDarkly behind OpenFeature, a plain config store) were not considered, and the recommendation has no trial, criteria, or stop condition.
