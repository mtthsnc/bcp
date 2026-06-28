---
name: landing-page
description: Use when producing a landing page or similar page deliverable (hero, marketing page, splash, microsite) that must be on-brand. Triggers on "make a landing page", "build a page for this launch/audience", "write the hero copy", "produce a marketing page". This is a contract skill — it names what it needs, pulls the right Brand Truth, writes the page into harness/output, and attaches a trace before handing off to brand-check.
---

# landing-page — produce a landing page from Brand Truth

## Overview
This skill is a CONTRACT: it states what it needs, pulls the matching Brand Truth, produces the page into `harness/output/`, and attaches a trace so the output is auditable. Nothing in the page — copy, colors, structure, naming — exists unless a truth backs it. If a needed truth is missing, stop and add it via the `brand-truth` skill rather than inventing one.

Pulls from: reads `harness/brand/02-voice`, `harness/brand/03-design`, `harness/brand/04-lenses`, `harness/brand/05-architecture`, and any relevant `type: refusal` truths; writes to `harness/output`.

## Procedure
1. State the page's goal and audience explicitly — this is the contract's input.
2. SELECT the lens in `harness/brand/04-lenses` that matches that audience; it governs framing and emphasis.
3. Pull the supporting truths: voice from `harness/brand/02-voice`, design tokens from `harness/brand/03-design`, naming and IA from `harness/brand/05-architecture`, plus every relevant `type: refusal`.
4. Draft the page copy and structure strictly within those truths — wording from `02-voice`, palette and type from `03-design`, section names from `05-architecture`, all filtered through the selected lens.
5. Write the page to `harness/output/<slug>/` alongside a `trace.md` with frontmatter `produced_by: landing-page`, `date`, and `sources: [<truth-ids used>]`.
6. Hand off to the `brand-check` skill to score the output; do not call it done until it has been scored.

## Common mistakes
- Inventing copy, colors, or section names not grounded in a truth.
- Ignoring the applicable lens in `04-lenses` and writing for a generic audience.
- Shipping the page without a `trace.md`, or with empty `sources:`.
- Violating a `type: refusal` (a phrase or move the brand never uses).

## Guardrails
- Draw ONLY from Brand Truth — if something is missing, add it via `brand-truth` first.
- Every output carries a trace (`produced_by`, `date`, `sources:`).
- Respect refusals; a refusal outranks a stylistic preference.
- Run `brand-check` before calling the page done.
