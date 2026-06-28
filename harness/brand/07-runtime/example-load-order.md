---
id: example-load-order
title: Recommended load and consumption order
source: runtime convention (08-decisions/example-0001-tone-shift.md)
date: 2026-06-28
status: active
type: truth
---

When generating any brand output, load the sections in this order:

1. **01-imprint** — the non-negotiable core (mission, values, refusals). Always load first; never skip.
2. **02-voice** — tone, vocabulary, and phrasing rules for any text.
3. **03-design** — color, type, layout, and visual rules for anything rendered.
4. **04-lenses** — audience/context lenses that adjust emphasis for the specific job.
5. **05-architecture** — naming and structure rules, when naming or organizing.
6. **06-assets** — usage rules + asset pointers, when placing a logo or font.

Job mapping: pull only what the job needs after `01-imprint`. Copywriting → `02` + `04`. Product naming → `05`. Layout/asset placement → `03` + `06`.

Every output must attach a **trace** listing the `id` of each truth, refusal, and decision it relied on, so the output is auditable against its sources.

**Why:** A fixed order loads the non-negotiables before the stylistic and structural rules that depend on them, preventing low-priority guidance from overriding the core; mandatory source citation makes every output verifiable and lets `brand-check` and `09-loops` trace conflicts back to a specific rule.
