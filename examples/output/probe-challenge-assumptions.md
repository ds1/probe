# Challenge Assumptions: Adopt LaunchDarkly

## Hidden assumptions

**Assumption: the cost is $1,440/year.**
This assumes the $10/seat public list price is the price we will pay, that seat
count equals engineer count, and that pricing stays flat. Feature-flag vendors
commonly price by monthly context/MAU or move teams onto a required paid tier for
features like per-user targeting and audit logs. The per-seat number is likely a
floor, not the real cost, and it carries no date, so it may already be stale.

**Assumption: in-house maintenance is unbounded ("maintain it forever") but the
SaaS carries no ongoing cost beyond the license.**
This is asymmetric accounting. The SaaS option also has ongoing cost: SDK
upgrades, an availability dependency, vendor lock-in, and the migration itself.
The document loads all the "forever" cost onto the build option and none onto the
buy option.

**Assumption: redeploy-to-change-a-flag is the actual problem.**
The stated pain is slow releases and no fast kill switch. That is an argument for
runtime toggling, which is the cheapest flag capability to build. It is not by
itself an argument for percentage rollouts or per-user targeting, which is where
a platform earns its keep. The proposal may be solving a $50 problem with a
$1,440 tool.

## Test the robustness

If flag volume does not grow much beyond the current 8 (a real possibility for a
12-person team), does the conclusion still hold? The whole "get on a platform
before it becomes unmanageable" argument collapses, and a small config store or an
open-source library would be sufficient. The recommendation is not robust to its
own central growth assumption being wrong.

## What would change the answer

A required feature (per-user targeting for a specific product need), a compliance
requirement (audit log), or a genuine multi-team scale would each strengthen the
buy case. None of these are asserted. Absent them, the case rests on convenience.
