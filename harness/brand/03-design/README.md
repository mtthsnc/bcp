# 03 — Design

The visual system as **truth**: design tokens, type, color, spacing, and logo rules. This section defines the decisions; the binaries that embody them live elsewhere.

## What goes here
- **Tokens** — color, type scale, spacing, radius, elevation
- **Type** — families, weights, usage rules
- **Color** — palette with hex values and intended roles
- **Logo rules** — clear space, minimum size, do/don't

## Tokens vs. binaries
Define the *values and rules* here as truth (with the frontmatter contract). **Binaries — logo files, fonts, icon sets — do not live here.** They live in `/assets` and are catalogued and referenced from `06-assets`. This section says "brand blue is `#1B3A2F`"; `06-assets` points at the actual logo files that use it.

## How to author
- One concern per file (e.g. `example-tokens.md`, `logo-rules.md`).
- Express token sets as a markdown table or YAML-in-body so they're machine-readable.
- Every file carries the truth frontmatter contract, and every set gets a `**Why:**`.
