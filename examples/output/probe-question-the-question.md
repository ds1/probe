# Probe: Question the Question

**Source:** `examples/sample-decision.md` — "Decision: Adopt LaunchDarkly for feature flags"
**Probe:** Meta / question-the-question
**Date:** 2026-08-26

---

## Summary

The memo asks "should we adopt LaunchDarkly?" but the problem it describes is "we cannot change a flag without a redeploy." Those are not the same question. The first is a vendor selection; the second is a runtime-configuration problem with a wide range of answers, most of them smaller than a flag platform. The memo collapses that range to a binary (LaunchDarkly vs. build-it-all-ourselves), then argues the build side from both directions at once so that the vendor wins by default. It never establishes how much the current pain actually costs, so there is no way to tell whether $1,440/year plus integration and lock-in is a bargain or an over-purchase for a team running 8 flags.

The recommendation might still be right. But the memo as written cannot show that, because it answers a question it never justified asking.

---

## 1. Embedded assumptions in the framing

### 1.1 The title is the answer, not the question

> "Decision: Adopt LaunchDarkly for feature flags"

The heading names a vendor before the Context section has stated a problem. The memo is structured as a justification for a conclusion already reached, and every later section inherits that shape. Compare the problem as actually stated:

> "Every flag change needs a redeploy, which slows down releases and makes it impossible to turn a feature off quickly if it misbehaves in production."

That is two distinct problems: (a) deploy-coupled configuration and (b) no fast kill switch. Neither requires a dashboard, percentage rollouts, or per-user targeting. The memo lists those three as the benefits of LaunchDarkly, but none of them corresponds to the pain described. The features being bought are not the features that were missing.

### 1.2 "Proper feature flags" is doing unexamined work

> "The team wants proper feature flags."

"Proper" smuggles in the conclusion. It implies the current approach is improper rather than merely limited, and it implies there is a single well-defined thing called "proper feature flags" that a vendor sells. The sentence also reveals the memo's actual origin: a team preference. That is a legitimate input, but it is presented as though it were a requirement.

### 1.3 The authority claim replaces the evidence

> "This is the industry standard and every serious engineering org uses it."

This sentence carries more argumentative weight than anything else in the memo, and it is unfalsifiable. It is also the kind of statement that, if true, would make the decision trivial and the memo unnecessary. Its presence suggests the author does not have a stronger reason and knows it. Strip it out and ask what remains of the case for this specific vendor over any other: only the three listed features, none of which are unique to LaunchDarkly.

### 1.4 "Flag volume will only grow" is a forecast presented as a fact

> "Flag volume will only grow as we scale, so getting on a real platform now is the right move before it becomes unmanageable."

Eight flags. Twelve engineers. Whether flag volume grows depends on release cadence, product surface, and whether anyone is deleting stale flags. The memo assumes growth and uses that assumption to justify acting now. It also introduces "real platform" as another loaded term alongside "proper" and "serious," a pattern of using status words where numbers should be.

---

## 2. Scope: why these two options?

The memo evaluates exactly two alternatives: LaunchDarkly, and "building our own." This is the narrowest possible framing of a crowded space, and it is narrowed in a way that guarantees the outcome.

### 2.1 The build option is described inconsistently so it can lose

> "Building our own would be free since we already have the infrastructure."

> "We considered building in-house but it would take too long and we would have to maintain it forever. LaunchDarkly is cheaper than an engineer's time."

These two sentences, four lines apart, contradict each other. The first says build costs nothing; the second says it costs more than the vendor. Neither is quantified. "Too long" has no estimate. "Maintain it forever" has no annual figure. "An engineer's time" has no hourly rate or hour count. The build option is not actually being evaluated; it is being invoked so that it can be dismissed.

### 2.2 The excluded middle is where the real answer probably lives

Between "pay LaunchDarkly" and "build a flag platform from scratch" sit at least four categories the memo never names:

- **Runtime-readable config with no new system.** Move the 8 flags from environment variables to a source the running app can poll or be signaled to reload: a database table, a config file in object storage, a key-value store you already run. This directly solves both stated problems (no redeploy; fast off-switch) and is the kind of change that fits inside the "one sprint" migration the memo already budgets.
- **Other hosted vendors.** The memo names one. There are several with different pricing models, some with free tiers that would cover 8 flags and 12 seats. Not naming any of them means the price comparison is against nothing.
- **Open-source, self-hosted flag services.** These give the dashboard and targeting features without per-seat billing or third-party dependency in the request path. "We already have the infrastructure" is an argument the memo makes for building, then never applies to hosting.
- **A vendor-neutral SDK layer.** Standards like OpenFeature exist specifically so the flag-evaluation call site does not depend on which backend is behind it. If the memo is right that this decision is a long-term lock-in ("maintain it forever" is the phrase used for the build path, but it applies to a vendor integration too), the memo should ask whether to insulate against that.

None of these need to win. The point is that a decision memo that proposes to lock a dependency should show it looked at the field and explain why the field narrowed to one.

### 2.3 The scope of "the main app" is a quiet limit

> "We will add the LaunchDarkly SDK to the main app"

Singular. If there is one app, a flag platform's multi-service, multi-environment coordination features are surplus. If there are other services, the memo has understated the integration cost. Either way the phrase deserves a second look.

---

## 3. Timing: why this quarter, and what would we want to know first?

> "Sign up for LaunchDarkly this quarter and start the migration."

No forcing function is named. No upcoming launch, no incident, no contract deadline. The urgency comes entirely from the "before it becomes unmanageable" forecast in 1.4.

Information that would make this decision easy, none of which the memo provides:

- **How often do flags actually change?** If the 8 flags flip a few times a quarter, the redeploy cost is a few redeploys a quarter. If they flip daily, the cost is real. The memo never says.
- **How long is a redeploy?** If a redeploy takes 40 minutes, the problem might be the deploy pipeline, and a flag platform is treating the symptom. If a redeploy takes 3 minutes, "impossible to turn a feature off quickly" is an exaggeration, and the question becomes whether 3 minutes is too slow for the incidents this team actually has.
- **How many incidents needed a fast kill switch, and what did the delay cost?** This is the strongest possible argument for the proposal, and it is absent. One concrete story ("on date X, feature Y misbehaved, and it took Z minutes to redeploy, during which N users were affected") would do more than the entire Proposal section.
- **What is the real LaunchDarkly price for this team?** The memo gives one number ($10/seat/month) with no source, no tier, and no mention of usage-based components. Flag platforms commonly price on some combination of seats, monthly active contexts, and service connections. The memo should confirm the number against a quote, and confirm that all 12 engineers actually need dashboard seats (who is going to flip flags in production? probably not everyone).

A cheap experiment is available: move the 8 flags to a runtime-readable source for one sprint, then measure whether anyone still wants the dashboard. If yes, the vendor decision is now grounded in experience. If no, the team saved the subscription and the lock-in.

---

## 4. Meta-questions: what problem is actually being solved?

### 4.1 Is this a flag problem or a deploy problem?

> "Every flag change needs a redeploy, which slows down releases"

Read literally, the complaint is that redeploys are slow. Feature flags are one way to reduce how often you need to redeploy. Making redeploys fast is another, and it improves every change, not just flag changes. The memo never considers whether the deploy pipeline is the actual bottleneck, and buying a flag platform would make it easier to keep not considering it.

### 4.2 Is this a tooling need or a team wish?

The memo's own account of motivation is "the team wants." That is honest and should not be dismissed; developer experience matters and a team that wants a tool will use it well. But it changes the decision's character. A "want" decision is judged on cost and reversibility, not on necessity. Reframed that way, the question becomes: is $1,440/year plus a sprint of integration a reasonable price for a tool the team wants, given that the cheapest alternative that solves the stated pain costs roughly the same sprint and no subscription? That is a fair question with a defensible yes. It is just not the question the memo asks.

### 4.3 What is being locked, and is anyone tracking it?

The memo treats the build option's "maintain it forever" as a cost and the vendor option's equivalent as invisible. Adopting a hosted flag platform puts a third party in the request path of every gated feature (what does the SDK do when the service is unreachable?), sends user attributes to that third party for targeting (is there a privacy or data-residency implication?), and creates a migration cost if the team later wants out. These are the actual reasons this is a `D-###`-class decision rather than a tooling PR, and the memo does not mention any of them.

---

## 5. Questions the memo did not ask

Not exhaustive; these are the ones whose absence most weakens the case.

1. What is the smallest change that gives us a production off-switch without a redeploy?
2. What does a flag change cost us today, in minutes and in incidents, per month?
3. Who will have permission to flip a flag in production, and how is a flip audited? (This is a governance question that exists regardless of vendor, and it determines how many seats are actually needed.)
4. What happens to gated features when the flag service is unavailable?
5. Do the three features the memo lists (dashboard, percentage rollouts, per-user targeting) map to any current need, or are they speculative?
6. Which of the 8 existing flags are still live, and who owns removing dead ones? If nobody, "flag volume will only grow" is a warning about hygiene, not an argument for a platform.
7. What would make us leave, and what would leaving cost?
8. Who decides this, and what evidence would change the recommendation? The memo has an author and a status but no decision owner and no stated conditions under which it would be withdrawn.

---

## 6. Reframed question

The memo's implicit question:

> Should we adopt LaunchDarkly for feature flags?

A question that would produce a more useful memo:

> We need to change feature-gating behavior in production without a redeploy, and we need a fast off-switch for misbehaving features. What is the smallest change that gives us both, what would it cost to operate for a year, and what evidence would tell us we have outgrown it and should move to a dedicated flag platform (hosted or self-run)?

This version keeps everything the original memo actually established (the pain, the team's preference, the rough budget) and drops what it assumed (the vendor, the binary, the growth forecast, the authority claim). It also turns "adopt LaunchDarkly" from the proposal into one of several candidate answers, which is where it belongs until the comparison has been done.

If, after that comparison, LaunchDarkly still wins, the resulting memo will be short, concrete, and hard to argue with. The current one is short and easy to argue with, which is a different thing.
