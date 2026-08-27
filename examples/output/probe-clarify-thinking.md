# Probe: Clarify Thinking — "Adopt LaunchDarkly for feature flags"

**Source:** `examples/sample-decision.md` (Proposed, Platform team, 2026-08-20)
**Lens:** clarity of key terms, origin of claims, soundness of the reasoning chain

## Summary

The memo identifies one concrete problem (flag changes require a redeploy) and jumps to one concrete vendor. The distance between those two points is filled with undefined terms ("proper feature flags", "a real platform", "industry standard"), an alternatives space collapsed to two options, and a cost section that contradicts itself within four lines. The conclusion may still be right, but the memo as written does not show the work that would let a reader tell.

---

## 1. The problem is stated once, then quietly replaced

> "Every flag change needs a redeploy, which slows down releases and makes it impossible to turn a feature off quickly if it misbehaves in production."

This is the only requirement the Context section actually states: **runtime toggling without a deploy**. The Proposal then lists what LaunchDarkly offers:

> "a dashboard for toggling flags in real time, percentage rollouts, and per-user targeting."

Only the first item addresses the stated problem. Percentage rollouts and per-user targeting are not traced back to any pain the team has. They appear because the vendor has them, not because the memo established a need.

**Questions:**
- What does "quickly" mean here, and what is the current redeploy time? If a redeploy takes four minutes, the framing "impossible to turn a feature off quickly" is doing a lot of rhetorical work. If it takes forty minutes with a change-approval gate, the case is much stronger. The memo never says.
- Is the constraint the env-var *mechanism* or the deploy *pipeline*? A hot-reloadable config file, a row in the existing database, or a small remote-config endpoint all remove the redeploy without adopting a SaaS platform. Were any of these considered?
- Are percentage rollouts and per-user targeting requirements, or nice-to-haves? If requirements, where did they come from?

**Assessment:** The requirement drifts from "toggle at runtime" (Context) to "full targeting platform" (Proposal) without acknowledgment. This is the central clarity failure; everything downstream inherits it.

---

## 2. "Proper" and "real" are load-bearing but undefined

> "The team wants proper feature flags."

> "getting on a real platform now is the right move"

Both adjectives imply a standard the current setup fails to meet, but the standard is never named. Eight environment-variable checks *are* feature flags; they have the properties the memo says are missing (runtime toggle) only if you define "proper" as "toggleable without redeploy". If that is the definition, say so, and then the question becomes "what is the cheapest thing that gives us runtime toggles?", which is a different question from "which vendor should we buy?"

**Questions:**
- What is the minimum property set that makes a flag "proper"? Runtime toggle? Audit log? Targeting? SDK in every service?
- Who is "the team" in "the team wants"? The author is the Platform team. Is this the platform team reporting its own preference, or a documented ask from product engineers?

**Assessment:** "Proper" and "real" function as conclusions disguised as descriptions. They presuppose that anything short of a hosted platform is improper, which is the thing the memo is supposed to argue.

---

## 3. The authority claim has no source and is unfalsifiable as written

> "This is the industry standard and every serious engineering org uses it."

**Origin:** No citation, no survey, no named peer. This is vendor-positioning language reproduced as fact. The phrase "every serious engineering org" is also structured so that any counterexample can be dismissed as not serious.

**Questions:**
- Which comparable organizations does the author actually know use LaunchDarkly, and how does the author know?
- The same sentence could be written about several other flag platforms and about at least one open-source option. What would make the claim false?
- Even if universally true, why does it bear on *this* team's decision? The memo does not connect "others use it" to "it fits our constraints".

**Assessment:** Unsound as evidence. It should be either replaced with specific, checkable comparisons or removed. As it stands it signals that the alternatives analysis was not done.

---

## 4. The cost section contradicts itself

Within four consecutive sentences:

> "Building our own would be free since we already have the infrastructure."

> "We considered building in-house but it would take too long and we would have to maintain it forever."

> "LaunchDarkly is cheaper than an engineer's time."

Sentence one says in-house is free. Sentences two and three say it costs engineer time, indefinitely. Both cannot be true. The most charitable reading is that "free" means "no licence fee", but that is exactly the cost the memo then says matters most, so the word "free" is misleading in context.

The comparison is also asymmetric. The build path is charged for engineer time ("too long", "maintain forever") but the buy path is not, even though the Rollout section commits a full sprint to SDK integration, migration of eight flags, and training. That is engineer time too. Neither side is quantified.

**Questions:**
- Where does "$10 per seat per month" come from, and which tier is it? Does that tier include the percentage rollouts and per-user targeting the Proposal lists, or are those on a higher tier? Does pricing scale on anything other than seats (evaluations, contexts, environments)?
- Why 12 seats? Do all 12 engineers need dashboard access, or do a few need to toggle and the rest only need the SDK?
- What is the estimate for "too long"? Days? Quarters? The memo asks the reader to accept a comparison with one side stated in dollars and the other side stated as an adjective.
- What does "maintain it forever" mean for a runtime-toggle mechanism of eight booleans? Is the maintenance burden being imagined for the minimal solution or for a LaunchDarkly clone?

**Assessment:** The cost reasoning is not sound. It uses "free" and "cheaper" in incompatible senses, counts engineer time on only one side, and quantifies nothing except a licence figure of unstated origin.

---

## 5. The alternatives space is binary

The memo considers exactly two options: LaunchDarkly, or building from scratch. It does not mention:

- Other hosted flag vendors.
- Open-source, self-hostable flag servers.
- A vendor-neutral SDK layer that would let the team defer or later change the vendor choice.
- The minimal in-house fix (runtime config store, no dashboard) sized to the stated problem rather than to a platform.

**Questions:**
- Was "build in-house" evaluated as "build a LaunchDarkly equivalent" or as "make the eight existing flags reloadable"? These are very different projects, and the memo's dismissal only makes sense against the first.
- If the team is worried about "maintain it forever", has it weighed that against the reverse: being unable to leave a vendor once flag evaluation is wired through every code path?

**Assessment:** Presenting a false dichotomy is the mechanism by which the undefined "proper" (finding 2) and the unsourced "industry standard" (finding 3) become a recommendation. Widening the alternatives set is the single change that would most improve the memo.

---

## 6. The growth projection has no basis stated

> "Flag volume will only grow as we scale, so getting on a real platform now is the right move before it becomes unmanageable."

**Origin:** Inference, not observation. The current count is eight. The memo does not say how many flags were added last quarter, how many the roadmap implies, or at what count env-vars stop working.

**Questions:**
- "Unmanageable" at what number? Twenty? Two hundred?
- "Will only grow" assumes flags are never retired. Is stale-flag cleanup part of the plan? A platform does not remove that problem; it can make it easier to accumulate.
- Why "now"? What is the cost of deciding at 25 flags instead of 8, given the migration is described as a single sprint either way?

**Assessment:** Plausible but unexamined. It functions as urgency rather than as an argument.

---

## 7. The benefit claim conflates two things

> "This unblocks faster releases and safer rollouts."

"Safer rollouts" follows from a kill switch and is supported by the Context. "Faster releases" does not obviously follow. The Context says flag changes slow releases because they need a redeploy. Moving flags out of the deploy removes *one* reason to redeploy; it does not make the release pipeline itself faster.

**Question:** Is flag toggling actually the bottleneck on release cadence, or is it one of several? If the deploy pipeline is the real constraint, the memo is solving an adjacent problem and describing it as the main one.

---

## Terminology consistency

| Term | Uses | Consistent? |
|---|---|---|
| "feature flags" | env-var `if` checks (Context); LaunchDarkly platform (Proposal) | No. The word covers both the current state and the goal state, which hides that the current state already *is* flags. |
| "free" / "cheaper" | in-house is free; in-house costs engineer time; vendor is cheaper than engineer time | No. Incompatible senses within one section. |
| "proper" / "real" | qualifier on flags and platform | Undefined in both uses. |
| "the team" | wants proper flags; will be trained on dashboard | Ambiguous whether this is the author (Platform team) or the engineers as a whole. |
| "quickly" / "too long" | turn-off speed; build duration | Neither is given a number. |

---

## Reasoning chain, reconstructed

1. Flag changes require a redeploy. *(stated, unquantified)*
2. Therefore we need runtime-toggleable flags. *(reasonable)*
3. Therefore we need "proper" flags / a "real platform". *(unargued leap; "proper" undefined)*
4. LaunchDarkly is the industry standard. *(asserted, unsourced)*
5. Building our own is free but also takes too long and costs forever. *(self-contradictory)*
6. Therefore adopt LaunchDarkly. *(follows only if steps 3 to 5 hold)*

The chain is sound from 1 to 2. Step 3 is where the memo stops arguing and starts asserting. Steps 4 and 5 supply the appearance of support for step 3 but do not survive inspection.

---

## Overall assessment

The recommendation may be correct; hosted flag platforms exist because runtime toggling with targeting is genuinely useful, and a 12-engineer team plausibly should not build one. But the memo does not establish that. It establishes that redeploying to flip a flag is painful, then adopts vendor framing for everything after that.

**Before this proceeds, the author should be able to answer:**

1. What is the current redeploy time, and what target time would count as "quickly"?
2. Define "proper feature flags" as a property list. Which properties are required now, and which are speculative?
3. What is the estimate, in engineer-days, for the *minimal* in-house fix (runtime-reloadable config for eight flags)? Compare it to the sprint already budgeted for LaunchDarkly integration.
4. What is the source of "$10 per seat", which tier is it, and does that tier include the features the Proposal lists?
5. Name at least two alternatives beyond "LaunchDarkly" and "build from scratch", and say why they lose.
6. What does per-user targeting require the team to send to a third party, and has anyone checked whether that is acceptable?

Answering 1 through 3 would probably either strengthen the memo substantially or change its recommendation. Either outcome is better than the current version.
