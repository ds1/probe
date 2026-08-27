# The decision-probe loop

The six lenses are the engine. This is the loop that makes them earn their cost on real decisions. A probe is cheap next to the cost of locking a wrong architectural choice and discovering it after you have built on top of it. The probe catches what author review misses: bundled decisions, confidence calibrated to a future you cannot see yet, claims asserted but never measured, options that were never put on the table.

This document is for you, the person running the probe. The commands themselves carry only the instructions the model needs.

## When to probe

Probe a decision before you lock it when it:

- changes a schema, a money flow, or an audit trail
- sets a cross-system contract (an API shape, an SDK surface, a versioning boundary)
- locks in a dependency (a vendor, a framework, a test stack)
- is the kind of thing you would write down as a numbered, hard-to-reverse decision (an ADR)

Skip it for reversible work: implementation PRs, bug fixes, copy edits, refactors that do not change behavior, anything you could undo in under a day.

## The loop

0. **Scan for an existing decision first.** Before drafting, search your decision log (an ADR folder, a `DECISIONS.md`, whatever you keep) for the nouns of the capability and their synonyms. If a prior decision already owns this ground, your draft is an amendment to it: cite it in the first paragraph and keep or explicitly amend its invariants by name. It is never a peer. A real probe once spent all six of its sharpest findings pointing out that a draft had silently re-decided something an existing decision already governed.

1. **Draft the write-up.** Lead with what is blocked and how reversible each option is. Calibrate to the current state, not an imagined future; handle the future with written reversal triggers instead of guesses. Anchor every number with its source: measured, estimated, vendor-cited (with a date), or industry comparison.

2. **Invoke the probe** on that draft:

   ```
   /probe:go path/to/draft.md --out ./probe-output
   ```

   The six agents run independently, with no shared context with you or with each other.

3. **Ground the agents in the code when the doc cites code.** The commands already tell each agent to verify code claims when the source cites function names, constants, file paths, or schema columns. If your draft leans on such claims, make sure they are stated precisely enough to be checked. Without grounding, agents reason from the prose and miss code-fact bugs. This is not hypothetical: with grounding on, a probe caught a doc claiming a `3 * X` multiplier where the code actually used `4 * X`, a bug the author's own review had read straight past.

4. **Read the synthesis cold.** Write down where the probe was right (concessions) and where it overcorrected (pushback) before you touch the original.

5. **Respond once.** Bring the original recommendation, a five-to-ten-line probe summary, your updated thinking, and a path to the revised doc into a single message. One synthesis of the loop, not three fragments.

## After the probe

- **Load-bearing gaps found:** write a v2 of the doc calibrated on the corrections. Do not silently auto-rewrite; surfacing the concessions is itself part of the decision.
- **Thin synthesis because the doc was thin:** escalate with the partial result rather than re-probing. Re-probing shallow input just burns runs.
- **Spirit-conflict scan.** Before you commit to a paid dependency or a cross-cutting change, look through the decision log for shape-similar prior calls. One often encodes a constraint that should carry over (a "no paid X before revenue" rule on the data side should make you suspicious of paid X on the infra side too).

## Why it earns its cost

Run the same doc through a probe you triggered deliberately and one triggered automatically and the findings overlap about 85 to 90 percent, with the same verdict; the differences show up only on the depth axis. The quality holds regardless of what triggered it, and it repeatedly finds real bugs that author review shipped past.
