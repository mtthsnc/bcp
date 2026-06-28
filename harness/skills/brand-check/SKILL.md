---
name: brand-check
description: Use when scoring or auditing a produced output against the brand before it ships, and whenever you want evidence to flow back into Brand Truth. Triggers on "is this on-brand", "score this output", "review the landing page", "check before we ship", "audit against the guidelines". Scores against config.brandCheck dimensions with cited violations, writes the score to the trace, and feeds recurring conflicts back into Brand Truth via 09-loops.
---

# brand-check — score an output against Brand Truth and feed the loop

## Overview
This skill is the qualitative half of Brand Check (the machine half is `scripts/brand-check.sh`). It scores a produced output against the documented truths and refusals, citing the specific id each violation breaks, then feeds evidence back: it writes the score into the output's trace and logs the run to `harness/brand/09-loops`. A score is evidence — only a human approves changes to Brand Truth.

Pulls from: reads the output and its `trace.md` in `harness/output`, plus all of `harness/brand`; writes to the output's trace and `harness/brand/09-loops`; proposes additions to `harness/brand/01-imprint`–`03-design` and `harness/brand/08-decisions`.

## Procedure
1. Load the output and its `trace.md` from `harness/output/<slug>/`; read the `sources:` it claims.
2. Score against each dimension in `config.brandCheck.scoreDimensions` (e.g. voice, design, accuracy) 0–100, listing specific violations — each one pointing at the exact truth or `type: refusal` id it breaks.
3. Compare the result to `config.brandCheck.passThreshold` to decide pass or fail.
4. Write the score back into the output's `trace.md` under `brand_check:` (per-dimension scores, pass/fail, cited violations).
5. Append a loop entry to `harness/brand/09-loops` capturing the score and any RECURRING conflict between the output and the truth.
6. When a conflict recurs, propose a new truth or `type: refusal` (for `01-imprint`–`03-design`) and a dated entry in `harness/brand/08-decisions` — proposals for human approval, not direct writes to the truths.

## Common mistakes
- A "vibes" score with no cited violations.
- Not writing the score back into the output's trace.
- Failing to feed recurring conflicts back into Brand Truth.
- Scoring against personal taste instead of the documented truths and refusals.

## Guardrails
- Every violation cites the specific truth or refusal id it breaks.
- Always update both the output's trace and the `09-loops` log.
- Recurring conflicts must become a proposed truth/refusal plus a dated decision in `08-decisions`.
- The score is evidence; the human approves any change to Brand Truth.
