# Implications & Consequences: Adopt LaunchDarkly

## First-order consequences

- A new recurring cost that grows with headcount, not with usage. At 12 engineers
  it is $1,440/year; at 30 it is $3,600/year, whether or not flag usage changed.
- A new runtime dependency in the request path. If the SDK or the vendor has an
  outage, the failure mode of flag evaluation (fail-open? fail-closed? last-known
  value?) becomes a production concern the document never specifies.
- An SDK integrated into the main app, which is a dependency that must be kept
  current and audited.

## Second-order consequences

- **Lock-in accrues.** Once targeting rules, rollout history, and flag definitions
  live in the vendor, leaving later means migrating all of it. The switching cost
  is lowest today and rises with every flag added. The document treats adoption as
  reversible; it is progressively less so.
- **Flag sprawl.** Making flags cheap to create tends to increase how many exist.
  Without a lifecycle policy (who removes a flag after a rollout completes), a
  platform can accumulate hundreds of stale flags, which is its own maintenance
  burden, just of a different shape than the one the build option was faulted for.
- **Data relationship.** Per-user targeting means user identifiers flow to the
  vendor. That is a new subprocessor for privacy review and possibly for customer
  contracts.

## Consequences of being wrong

If flag volume does not grow and targeting is never needed, the org pays annually
and forever for a platform whose distinctive features go unused, having also spent
a sprint migrating and training. The reversal cost (rip out the SDK, rebuild
toggling) is now higher than if it had built the minimal version first.

## What the document does not plan for

No exit criteria, no fail-mode spec for flag evaluation, no flag-lifecycle policy,
and no reversal trigger stating what would make the team walk this back. A
decision that is hard to reverse should carry the trigger that reverses it.
