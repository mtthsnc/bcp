# 07 — Runtime

**Instructions for the agent**, not for humans. This section tells a generating agent how to consume the rest of this repo at generation time: what to load, in what order, which sections matter for which job, and how to prove it stayed on-brand.

## What goes here
- Recommended **load order** for the brand sections
- A job → sections map (e.g. naming a product → pull `05`; writing copy → pull `02`)
- How to attach a **trace**: every output cites the truth/decision ids it relied on
- When to run **brand-check** and what to do with the result

## How to author
- One truth per file, with the required **truth frontmatter**. README is exempt.
- Write rules as imperatives addressed to the agent ("Load X before Y").
- Add a `**Why:**` line for each rule.

## The contract for any agent generating brand output
1. Load the sections in the order given by the load-order truth (imprint → voice → design → lenses → architecture → assets).
2. Pull only the sections relevant to the job, but **always** load `01-imprint` (the non-negotiables).
3. Cite every truth/decision `id` you used in a trace attached to the output.
4. Run `brand-check` before publishing; on a failing score, revise or log the conflict to `09-loops`.
