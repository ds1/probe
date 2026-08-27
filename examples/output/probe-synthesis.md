# Probe Synthesis: "Adopt LaunchDarkly for feature flags"

**Source:** `examples/sample-decision.md` (Proposed, Platform team, 2026-08-20)
**Lenses consolidated:** clarify-thinking, challenge-assumptions, evidence-basis, alternative-viewpoints, implications-consequences, question-the-question (all six ran)

## 1. Executive summary

The memo correctly identifies one real problem (flipping a flag requires a redeploy, so there is no fast kill switch) and then jumps to one vendor without showing the work in between. All six lenses independently converge on the same three faults: the problem is never measured, the alternatives space is collapsed to a false binary (LaunchDarkly vs. build-everything-from-scratch), and the cost section contradicts itself while omitting the buy side's own engineer time, likely pricing tier, lock-in, and data-handling exposure. The recommendation may still be right, but the memo as written cannot show it; it is not ready to approve.

## 2. Critical findings

| # | Lens | Key finding |
|---|------|-------------|
| 1 | Clarify thinking | The requirement drifts from "toggle at runtime" (Context) to "full targeting platform" (Proposal) without acknowledgment. "Proper" and "real" are conclusions disguised as descriptions; the reasoning chain is sound only from step 1 to step 2 and asserts everything after. |
| 2 | Challenge assumptions | The conclusion needs four unshown things to all be true: redeploys are slow and unfixable, $10/seat covers the listed features, a minimal build is genuinely expensive, and flag count will grow. Each is plausible; none is demonstrated; the memo requires all of them. |
| 3 | Evidence basis | No citations, measurements, or dated inputs anywhere. The only first-hand facts are "flags need a redeploy" and "8 flags." The load-bearing sentence ("cheaper than an engineer's time") compares one unstated number to another. |
| 4 | Alternative viewpoints | At least five credible options were never named (hot-reloadable config store, self-hosted open source, cheaper or already-paid-for SaaS, LaunchDarkly behind OpenFeature, fixing the deploy pipeline). No perspective outside the Platform team appears; privacy, on-call, and exit cost are the most consequential absences. |
| 5 | Implications and consequences | Reversibility decays with success: direct SDK calls plus dashboard-only targeting rules turn a one-day rollback at month 1 into a quarter of work by month 18, with the renewal negotiation happening on the vendor's terms. The kill switch also becomes dependent on vendor availability and unspecified SDK defaults. |
| 6 | Question the question | The title names the answer before the Context states the problem. The memo asks "should we adopt LaunchDarkly?" when the problem it describes is "what is the smallest change that gives us a production off-switch without a redeploy?" |

## 3. Evidence quality

**What holds up.** Two claims are first-hand and credible: env-var flags currently require a redeploy, and there are 8 of them. The implicit timing argument (act at 8 flags rather than 80) is reasonable in shape. "Maintain it forever" is an honest acknowledgment of the real reason to buy rather than build.

**What does not.** Every other claim is inference, recollection, or assertion:

- **Pricing.** "$10 per seat per month" has no source, tier, date, or contract term. Three lenses independently flag that hosted flag platforms price per-user targeting on a usage dimension (contexts, MAU, service connections), which the memo lists as a benefit and then does not price. $1,440/year is a floor, not an estimate.
- **Build cost.** Stated as "free" and as "too long ... forever" within four lines. Neither is quantified. The dismissal only makes sense against a LaunchDarkly clone, not against the minimal fix the stated problem actually requires.
- **Buy cost.** The Rollout section commits a sprint of SDK integration, migration, and training; the Cost section prices that work at zero. Engineer time is charged to one side only.
- **"Industry standard."** Unsourced, unfalsifiable as written, and false as read (several hosted vendors, self-hosted options, and the CNCF OpenFeature standard exist precisely because the market is not consolidated). It is the only argument for this vendor specifically.
- **Growth forecast.** Eight flags is the sole data point. No historical count, roadmap, or threshold for "unmanageable." It supplies urgency, not argument.

**Author position.** The Platform team would own either solution and has a legitimate incentive to externalize maintenance. That makes the unquantified build estimate the least trustworthy number in the memo, not because of bad faith but because it comes from the party most motivated to inflate it.

## 4. Assumption risk matrix

| Assumption | Confidence | Impact if wrong |
|------------|------------|-----------------|
| Redeploy latency is slow, inherent to env-var flags, and not fixable at the pipeline level | Low (no number given) | Primary motivation largely evaporates; what remains is a want for rollouts/targeting, a smaller and differently shaped requirement |
| A minimal in-house fix (config table, cached read, admin toggle) would "take too long" | Low (no estimate; dismissal sized against a full platform) | The central trade-off resolves the other way for years; the budgeted sprint could deliver the fix instead of the migration |
| $10/seat covers dashboard, percentage rollouts, and per-user targeting with no usage-based component | Low | Real cost is a multiple of the memo's figure; budget re-approval mid-migration, or downgrade to a tier without the features that justified the choice |
| Direct SDK calls are acceptable (no abstraction layer needed) | Not considered | Exit cost grows from a day to a quarter within 6-18 months; renewal leverage shifts to the vendor |
| SDK behaviour when the vendor is unreachable is acceptable by default | Not considered | Kill switch fails at the moment it matters, or features silently disable on cold start; the platform introduces a failure mode env vars did not have |
| Flag count will grow and a platform will make it manageable | Low | If hygiene keeps count near 8-15, urgency disappears; if it does not, the dashboard accelerates sprawl rather than containing it |
| Only the 12 engineers need seats | Medium-Low ("train the team on the dashboard" implies broader use) | Seat cost rises, or credentials get shared and the audit trail the dashboard was supposed to provide is lost |
| Per-user targeting has no data-handling implications | Not considered | User attributes leave the organisation's boundary without a data-processing review; a lead-time item that delays "this quarter" if found late |
| The 8 env-var "flags" are all runtime toggles rather than per-environment config | Not considered | Migrating environment config into a flag platform is a category error that makes environments harder to reason about |

## 5. Unexplored alternatives

The memo compares one vendor against a caricature of building. The excluded middle, where several lenses agree the real answer probably lives:

1. **Hot-reloadable config with no new system.** Move the 8 flags to a source the running app can poll or reload (database table with short-TTL cache, parameter store, Consul/etcd). Directly solves both stated problems, fits inside the sprint already budgeted, sends no user data anywhere. Gives up dashboard, rollouts, and targeting.
2. **Self-hosted open source** (Unleash, Flagsmith, GrowthBook, others). Dashboard, rollouts, targeting, audit log, no per-seat licence, data stays in-house, several speak OpenFeature. Costs an ops burden the memo would need to size. The memo's own "we already have the infrastructure" argument applies here and is never used.
3. **Lower-cost or already-paid-for SaaS** (ConfigCat, Flagsmith cloud, Statsig, PostHog flags if PostHog is in use). Often free or cheap at 12 seats; marginal cost may be zero if a current vendor bundles flags.
4. **LaunchDarkly behind an abstraction** (OpenFeature or a thin internal interface). Keeps the recommendation but caps exit cost. This is the one alternative that is compatible with approving the memo, and it must be decided in sprint one because it cannot be retrofitted cheaply.
5. **Fix the deploy pipeline.** If redeploys are slow enough that flags feel necessary for a kill switch, every hotfix is also slow. Addresses the root cause for all changes, not just flagged ones. Larger project; does not give runtime toggles.
6. **Run a two-week trial against written criteria first.** Eight flags is small enough to afford it. Criteria: kill-switch latency, local-dev and CI story, failure mode when the service is down, exit cost, all-in price at 3x scale.

## 6. Hidden costs and consequences

- **Kill switch becomes vendor-dependent.** If defaults are written as "current on state" (natural when migrating live flags), a vendor outage means the misbehaving feature cannot be turned off from the dashboard; if defaults are "off," a cold-start outage silently disables features. Either is manageable if chosen deliberately. The memo does not choose.
- **A new production change surface with no governance.** Today a flag flip goes through code review, CI, and the deploy log. After adoption, any seat holder can change production behaviour from a browser. Incident timelines gain a second axis ("what was toggled"). Who may flip, whether high-blast-radius flags need a second approver, and where flag-change events are logged are all undefined. "Train the team on the dashboard" treats a governance change as a UI-familiarity problem.
- **Reversibility decays with success.** Month 1: 8 flags, 8 call sites, a day to reverse. Month 6: 40 flags with targeting rules that live only in the dashboard. Month 18: flags used for config, experiments, and entitlements; the flag service is load-bearing and the renewal negotiation happens with leverage on the vendor's side. The memo's own growth forecast is the mechanism of lock-in.
- **Flag sprawl.** Env vars create friction against adding flags; a dashboard removes it. Without ownership, expiry, and cleanup-at-100%, stale flags accumulate and the combinatorial test surface grows. The platform stores the volume; the team still has to manage it.
- **User data leaves the boundary.** Per-user targeting sends identifiers and attributes (plan, region, email domain) to a third party on evaluation or via context sync. That implies a data-processing agreement, a vendor security review, and a decision about which attributes are permitted, all before the first production flag.
- **Budget shock.** Approval at $1,440 followed by an invoice at a multiple, mid-migration, forces absorb / downgrade / stop. Cheap to prevent with a written quote; awkward to fix after signing.
- **Testing surface.** No mention of how flags behave in local dev, CI, and staging, or whether every test run needs vendor connectivity.

## 7. The meta-question

The memo asks: *Should we adopt LaunchDarkly for feature flags?*

The problem it actually describes is a runtime-configuration problem with a wide range of answers, most smaller than a flag platform. The title names the vendor before the Context states the problem, and every section inherits that shape. Two reframings surface from the lenses:

- **Is this a flag problem or a deploy problem?** Read literally, the complaint is that redeploys are slow. Flags reduce how often you redeploy; making redeploys fast helps every change. The memo never asks which is the bottleneck, and buying a platform makes it easier to keep not asking.
- **Is this a tooling need or a team wish?** The memo's honest motivation is "the team wants." That is a legitimate input, but a want-decision is judged on cost and reversibility, not necessity. Judged that way, "$1,440/year plus a sprint for a tool the team wants" is a fair question with a defensible yes. It is just not the question the memo asks.

The question the memo should ask instead:

> We need to change feature-gating behaviour in production without a redeploy, and we need a fast off-switch for misbehaving features. What is the smallest change that gives us both, what would it cost to operate for a year, and what evidence would tell us we have outgrown it and should move to a dedicated flag platform (hosted or self-run)?

This keeps what the memo established (the pain, the team's preference, a rough budget) and drops what it assumed (the vendor, the binary, the growth forecast, the authority claim). "Adopt LaunchDarkly" becomes one candidate answer, which is where it belongs until the comparison has been done.

## 8. Validate before proceeding

Measure the problem:

- [ ] Current wall-clock time from "decide to flip" to "flag live in production," in minutes.
- [ ] How often flags change per sprint or month.
- [ ] Any incident in the last six months where slow kill-switch latency caused or prolonged harm; if none, label the "misbehaves in production" scenario as hypothetical.
- [ ] Classify the 8 existing flags: runtime toggle vs. per-environment config; live vs. stale; permanent operational vs. temporary rollout gate.

State the requirement:

- [ ] Define "proper feature flags" as a property list. Mark each of runtime toggle, dashboard, percentage rollout, per-user targeting, audit log as required-now, needed-within-12-months, or speculative, with the flag or use case that drives it.
- [ ] Identify who actually needs to flip flags in production (engineers only, or product/QA/support too).

Price all options honestly:

- [ ] A dated, written vendor quote for the tier that includes the listed features, at the realistic seat count and projected context/MAU volume, with renewal terms.
- [ ] An engineer-day estimate for the minimal in-house fix (runtime-reloadable store for 8 flags, cached read, admin toggle, audit log), compared against the sprint already budgeted for SDK integration and migration.
- [ ] At least two alternatives beyond "LaunchDarkly" and "build from scratch" (self-hosted OSS, cheaper or bundled SaaS), each with a one-line reason it loses if it does.
- [ ] Charge integration, migration, training, and ongoing SDK maintenance to the buy side.

Address the omitted risks:

- [ ] SDK fallback policy: default value per flag, bootstrap or relay for server-side, runbook for "flag service is down."
- [ ] Decide whether flag evaluation goes through an internal interface or OpenFeature. This must be settled before the first SDK call is written.
- [ ] Which user attributes would be sent for targeting, and whether a data-processing agreement or security review is required.
- [ ] Who may change production flags, whether high-impact flags need a second approver, and where flag-change events are logged alongside deploy and error logs.
- [ ] Flag lifecycle policy: owner, expiry, cleanup ticket at 100% rollout.

Fix the memo:

- [ ] Delete "Building our own would be free" and "This is the industry standard and every serious engineering org uses it"; replace with numbers and named alternatives.
- [ ] Name the decision owner and the conditions under which the recommendation would be withdrawn.
- [ ] Consider the cheap experiment: move the 8 flags to a runtime-readable source for one sprint, then ask whether anyone still wants the dashboard.

## 9. Questions for the people who decide

The memo is authored by the Platform team, asks for spend approval "this quarter," and commits engineers across the main app to a new dependency. That implies at least three parties beyond the author.

**For whoever approves the spend:**
- Is $1,440/year the quoted price for the tier that includes the three features the memo lists, at the seat count and user volume this team will actually have? What is the renewal term?
- What is the exit cost at month 12 if the price changes, and has anything been done to cap it?
- Was the minimal in-house fix priced in engineer-days before it was dismissed?

**For the Platform team (technical owner):**
- What is the redeploy time today, and is the bottleneck the flag mechanism or the deploy pipeline?
- Will flag evaluation go through an internal interface or OpenFeature, or will the vendor SDK be called directly at every site?
- What does a gated feature do when the flag service is unreachable at startup, and who decided that per flag?
- Which of the 8 flags are actually runtime toggles, and which are per-environment config that should not migrate?

**For the engineers and on-call who will live with it:**
- Who is allowed to flip a production flag from the dashboard, and how will you know what was toggled when an incident timeline needs reconstructing?
- How do flags behave in local dev and CI? Does every test run need vendor connectivity?
- Is there a flag-retirement practice, or will the dashboard make it easier to accumulate flags nobody owns?

**For whoever owns user-data and privacy questions:**
- Per-user targeting sends user attributes to a third party. Which attributes, under what agreement, and does this bring the flag platform into scope for any regulatory exposure the product already has?

## 10. Final verdict

**Not ready.** The memo establishes that redeploy-gated flags are painful and that there are 8 of them; everything else is inference, recollection, or vendor framing. Six independent lenses converged on the same faults with no dissent: an unmeasured problem, a false binary that excludes the middle of the option space where the answer probably lives, a cost comparison that contradicts itself and charges engineer time to only one side, and silence on the four things that make this a logged dependency decision rather than a tooling PR (vendor-dependent kill switch, ungoverned production toggles, SDK lock-in, user data leaving the boundary). None of this argues against a flag platform; a 12-engineer team plausibly should not build one, and the timing instinct is right. But approving on the current text would mean choosing the most expensive and least reversible option by default, on the strength of an unsourced price and an appeal to popularity. Answer the first three checklist groups (measure, state the requirement, price all options) and decide the abstraction and fallback questions in sprint one; if LaunchDarkly still wins after that, the resulting memo will be short, concrete, and hard to argue with.
