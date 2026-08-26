# Question the Question: Adopt LaunchDarkly

## The question the document asks

"Should we adopt LaunchDarkly?"

## What that question assumes

It assumes the decision is buy-this-vendor versus not, and it smuggles in three
unexamined premises: that we need a feature-flag *platform* (not just flags), that
the choice is this named vendor versus building from scratch, and that the trigger
for deciding now is real ("before it becomes unmanageable"). By naming a vendor in
the question, it has already skipped the requirements and options steps.

## The better questions

**"What capability do we actually need, and what is the cheapest thing that
delivers it?"**
The stated pain is redeploy-to-toggle and no kill switch. The right first question
is what it costs to fix exactly that, and only that. If the answer is two days of
work, the vendor question is premature.

**"What would have to be true for a paid platform to be the right call?"**
Name the conditions: a concrete need for per-user targeting, non-engineers owning
rollouts, an audit/compliance requirement, or multi-team scale. Then check whether
any of them hold today. This turns a vendor pitch into a decision.

**"What is the reversal cost of each option, and which keeps the most doors open?"**
The minimal build is the most reversible (you can always adopt a platform later
once a real need appears); the SaaS accrues lock-in from day one. If the need is
uncertain, the reversible option is usually the right first move.

## Reframe

The document is really answering "which feature-flag vendor should we buy?" when
the prior question, "do we need to buy one yet?", has not been settled. Answer the
prior question first. The scope is also mis-set: it treats this as a platform
decision when the evidence describes a small, specific pain that may not warrant a
platform at all.
