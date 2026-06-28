# 06 — Assets

**Usage rules and pointers, not the files themselves.** The binary assets — logos, wordmarks, icon sets, fonts — live in the top-level `assets/` directory at the repo root. This section documents **how those assets may and may not be used**, and references each binary by relative path.

## What goes here
- Logo clear-space, minimum-size, and placement rules
- Color and background pairings (which logo lockup on which background)
- Don'ts: distortions, recolors, drop shadows, unapproved lockups
- Type rules: which font files are canonical and where they live
- Relative-path pointers into `assets/` (e.g. `../../../assets/logo.svg`)

## How to author
- One truth per asset or rule set, with the required **truth frontmatter**. README is exempt.
- Always reference the actual binary by relative path so the rule and the file stay linked.
- State the rule, then add a `**Why:**` line.
- Never paste binary data here. If an asset is missing from `assets/`, note it and add a source/decision to track it.

## What happens next
Runtime (`07`) tells agents to pull these rules before placing a logo or choosing a typeface. Changes to canonical assets are logged in `08-decisions`.
