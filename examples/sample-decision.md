# Decision: Adopt LaunchDarkly for feature flags

**Status:** Proposed
**Author:** Platform team
**Date:** 2026-08-20

## Context

We currently gate features with `if` checks on environment variables. Every flag
change needs a redeploy, which slows down releases and makes it impossible to
turn a feature off quickly if it misbehaves in production. The team wants proper
feature flags.

## Proposal

Adopt LaunchDarkly as our feature-flag platform. It gives us a dashboard for
toggling flags in real time, percentage rollouts, and per-user targeting. This is
the industry standard and every serious engineering org uses it.

## Cost

LaunchDarkly is $10 per seat per month. We have 12 engineers, so $120/month, or
$1,440/year. Building our own would be free since we already have the
infrastructure.

We considered building in-house but it would take too long and we would have to
maintain it forever. LaunchDarkly is cheaper than an engineer's time.

## Rollout

We will add the LaunchDarkly SDK to the main app, migrate our existing 8
environment-variable flags over a sprint, and train the team on the dashboard.
Flag volume will only grow as we scale, so getting on a real platform now is the
right move before it becomes unmanageable.

## Recommendation

Sign up for LaunchDarkly this quarter and start the migration. This unblocks
faster releases and safer rollouts.
