# 05 — Architecture

Naming, information architecture, and product/brand architecture. This section holds the **rules that govern names and structure**: how products, sub-brands, and features relate to the master brand, and how we name new things consistently.

## What goes here
- Brand architecture model (e.g. branded house vs. house of brands)
- Naming conventions for products, features, releases, and SKUs
- Capitalization, hyphenation, and trademark/™ rules
- Information architecture: how navigation, taxonomy, and content are organized

## How to author
- One truth per file, with the required **truth frontmatter** (see repo contract). README files are exempt.
- State the rule as a claim, then add a `**Why:**` line giving the reason.
- Cite where the rule came from in `source:` (often a decision in `08-decisions` or a source in `00-source`).
- Prefer concrete patterns and examples over abstract principles.

## What happens next
Naming and structure decisions that change over time are logged in `08-decisions`. Runtime (`07`) tells agents when to pull these rules — e.g. before generating a product name or page hierarchy.
