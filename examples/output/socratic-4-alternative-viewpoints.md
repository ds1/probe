# Alternative Viewpoints: Adopt LaunchDarkly

## The framing excludes the middle

The document presents a binary: buy LaunchDarkly, or build a full platform
in-house "forever." This is a false dichotomy that hides the options most teams
this size actually pick.

**Option A: Open-source feature flags (Unleash, Flagsmith, GrowthBook).**
Self-hosted or with a low-cost managed tier, these give runtime toggling,
percentage rollouts, and targeting without per-seat SaaS pricing or hard vendor
lock-in. This is the strongest unrepresented option and it is not mentioned at
all.

**Option B: A minimal runtime flag store.**
Flags in a database table or a hosted key-value/config service, read at request
time, with a tiny internal admin page. Covers the actual stated pain (no
redeploy, instant kill switch) in days, not "forever." Maintenance is small
because the surface is small.

**Option C: A managed config service you may already pay for.**
If the stack already includes a provider with remote config (many cloud and
mobile platforms do), the toggling capability may be a feature away rather than a
new vendor.

## The counter-argument to buying

A cost-conscious engineer would argue: you have 8 flags and 12 people. You do not
have a feature-flag scale problem; you have a "changing a flag needs a redeploy"
problem. Solve that directly. Adopting a per-seat SaaS platform with capabilities
you cannot yet name is buying for a future headcount and flag volume you have not
demonstrated.

## Who would disagree with the proposal

- **Finance:** a recurring per-seat cost that scales with hiring, versus a
  one-time build, deserves a real comparison.
- **Security/compliance:** sending user-targeting data to a third party is a new
  data-processing relationship that the proposal does not acknowledge.
- **A future maintainer:** vendor lock-in and an SDK dependency are their own kind
  of "maintain it forever," just relocated.

## Steel-man of the buy case (so it is judged fairly)

If the team genuinely needs per-user targeting soon for a specific product bet,
wants non-engineers running rollouts, and values not owning the system, a mature
SaaS is a reasonable buy. The proposal should make that case explicitly rather
than resting on "industry standard."
