# Clarify Thinking: Adopt LaunchDarkly

## Key claims needing clarification

**"The team wants proper feature flags."**
Which part of the team, and wanting what specifically? "Proper feature flags"
bundles at least four distinct capabilities: runtime toggling without redeploy,
percentage rollouts, per-user targeting, and a non-engineer-facing dashboard. The
document treats these as one thing. They have very different costs and very
different in-house difficulty. Runtime toggling is a config-store lookup;
per-user targeting is a real system. Which capabilities are actually required
versus nice-to-have is never stated.

**"This is the industry standard and every serious engineering org uses it."**
What is the source of this claim? It reads as a social-proof assertion, not an
evaluation. "Industry standard" is doing persuasive work that "meets our specific
requirements" should be doing instead.

**"Building our own would be free."**
What is meant by "free"? The reasoning traces the cost of the SaaS license but
treats the build option's cost as zero because "we already have the
infrastructure." That conflates license cost with total cost. Free of a license
fee is not free of engineering and maintenance time, which the very next
paragraph admits ("maintain it forever") without folding back into the number.

## Ambiguities

- "Flag volume will only grow" - grow from 8 flags to what, over what horizon? The
  conclusion ("getting on a real platform now is the right move") depends entirely
  on this unquantified trajectory.
- "Too long" for the in-house build is never sized. Too long relative to what
  deadline?

## Reasoning chain

The argument is: redeploys are slow -> we want flags -> LaunchDarkly is the
standard -> it is cheaper than an engineer's time -> adopt it. The weak link is
the jump from "we want flags" straight to one named vendor, with no step that
defines the requirement or compares it against the option space.
