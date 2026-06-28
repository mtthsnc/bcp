---
name: brand-truth
description: Use when starting a new brand or extending, correcting, or auditing an existing one — turning raw inputs (stakeholder interviews, brand audits, asset inventories) into cited, dated truths and refusals. Triggers on "build the brand", "add a truth", "capture this belief/voice/token", "this is wrong, fix the source of truth", "what does the brand never do". Writes the single source of truth in harness/brand.
---

# brand-truth — build and extend the single source of truth

## Overview
This skill turns raw brand input into a citable, dated, append-only source of truth. It is the only sanctioned way to create or change a truth. Every claim must trace to a real source; opinion is never recorded as fact. Refusals (what the brand never does or says) are first-class truths, not afterthoughts.

Pulls from: reads `harness/brand/00-source`; writes to `harness/brand/01-imprint`, `harness/brand/02-voice`, `harness/brand/03-design`, `harness/brand/04-lenses`, `harness/brand/05-architecture`, and records choices in `harness/brand/08-decisions`.

## Procedure
1. Gather raw input via stakeholder interview, brand audit, or asset inventory. Drop it into `harness/brand/00-source` verbatim, each file noting its origin and date.
2. Distill claims from `00-source` into the right section: positioning and beliefs → `01-imprint`; tone and **refusals** → `02-voice`; design tokens → `03-design`; audience lenses → `04-lenses`; naming and IA → `05-architecture`.
3. Write each claim as a truth with full frontmatter: `id`, `title`, `source` (pointing back to the `00-source` file), `date`, `status: active`, `type: truth` (or `type: refusal`).
4. Capture refusals explicitly in `02-voice` as `type: refusal` — every "we never say X" or "we never do Y" surfaced in the input gets its own truth.
5. Append-only: to change an existing truth, set the old one `status: superseded` and add a new truth with `supersedes: <old-id>`. Never edit a truth in place.
6. Record every significant choice (a positioning call, a superseded truth, a tradeoff) as a dated, append-only entry in `harness/brand/08-decisions`.

## Common mistakes
- Recording uncited claims — a truth with no `source` back to `00-source`.
- Editing a truth in place instead of superseding it.
- Skipping refusals, or burying them inside a voice truth instead of marking `type: refusal`.
- Distilling an opinion as fact without an input that backs it.

## Guardrails
- Every truth cites a `source` and carries a `date`.
- Supersede, never overwrite — old stays as `status: superseded`, new carries `supersedes:`.
- Refusals are first-class: explicit `type: refusal` truths in `02-voice`.
- Never invent a source; if there is no input, gather it into `00-source` first.
