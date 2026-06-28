# AGENTS.md

Guidance for coding agents (and humans) working **on** a Brand Context Protocol (BCP) repo. For
what it is and how to use it, see [README.md](README.md); for the design,
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md); for how to fill it in, [docs/AUTHORING.md](docs/AUTHORING.md).

## What this repo is

A **Brand Context Protocol**: a brand written down as something usable by people *and* machines — a
small, portable, git-native standard for everything that makes a brand itself, in a form a person
and an AI agent can both read and produce from. It is plain Markdown + a little YAML in git. No
login, no lock-in: **a brand inside someone else's tool is rented, not owned.**

This repo is a **reusable template**. Clone it per business and fill in `harness/brand/`. The four
parts (after Wild's BCP):

1. **Brand Truth** (`harness/brand/`) — the single source: voice, design, beliefs, and **refusals**
   (what the brand will never do). Every truth cites a source and is dated. Append-only.
2. **Skills** (`harness/skills/`) — reusable contracts. A skill names what it needs, pulls the right
   parts of Brand Truth, and produces work. Same portable `SKILL.md` standard as any agent harness.
3. **Output** (`harness/output/`) — deliverables generated from Brand Truth. On-brand by
   construction; every output carries a **trace** back to the truths and skill that made it.
4. **Brand Check** — scoring + feedback. The machine half is `scripts/brand-check.sh` (the
   conformance gate); the qualitative half is the `brand-check` skill. Learnings flow back into
   Brand Truth (new rules, new refusals) and `09-loops/`.

## Golden rules

1. **Every truth is cited and dated.** A claim with no `source` and no `date` is not a truth.
2. **Append-only; supersede, don't overwrite.** To change a truth or decision, add a new entry with
   `supersedes:` and set the old one's `status: superseded`. History is the point.
3. **The gate is law.** `./scripts/brand-check.sh` must pass before any commit; `./tests/run.sh`
   before any push. CI runs both.
4. **Skills pull from Brand Truth; output traces back to it.** A skill body must state which brand
   sections it reads. Every output carries a trace (`produced_by`, `sources`, `date`).
5. **No hardcoded user, home, or project paths.** Use `~/...` or read from `config.json`. A grep for
   a literal home path in tracked files returns nothing.

## Frontmatter contracts (the machine-checkable part)

**Truth** — any `*.md` under `harness/brand/{01-imprint,02-voice,03-design,04-lenses,05-architecture,06-assets,07-runtime}` except `README.md`:

```yaml
---
id: <kebab-unique>          # stable id other files cite
title: <short title>
source: <where this claim came from — interview, audit, founder, data>
date: <YYYY-MM-DD>
status: active              # active | superseded
type: truth                 # truth | refusal  (refusal = something the brand never does/says)
supersedes: <id>            # optional; set when this replaces an earlier truth
---
```
Body: the claim, then a `**Why:**` line giving the reason. `00-source/` is raw input and is exempt
from the truth contract (but should still note where each artifact came from).

**Decision** — `harness/brand/08-decisions/*.md` (except `README.md`):

```yaml
---
id: <kebab-unique>
date: <YYYY-MM-DD>
status: accepted            # accepted | superseded
supersedes: <id>            # optional
---
```
Body: the decision and its rationale. Append-only.

**Output trace** — `harness/output/<deliverable>/trace.md` (or frontmatter on the deliverable):

```yaml
---
produced_by: <skill-name>
date: <YYYY-MM-DD>
sources: [<truth-id>, <truth-id>]   # the Brand Truth ids this output drew from
brand_check: <score 0-100 | pending>
---
```

**Skill** — `harness/skills/<name>/SKILL.md`: frontmatter `name` (== directory, lowercase/numbers/
hyphens, ≤ 64) + `description` starting **"Use when…"** (≤ 1024). Body: Overview → Procedure →
Common mistakes → Guardrails, and a line naming which Brand Truth sections it pulls.

## Layout

```
harness/brand/00-source     raw inputs (interviews, audits, references) — exempt from truth contract
harness/brand/01-imprint    core identity: positioning, beliefs, mission
harness/brand/02-voice      tone, lexicon, do/say — and refusals (never-say)
harness/brand/03-design     design tokens, type, color, spacing, logo rules
harness/brand/04-lenses     audience/context lenses (e.g. B2B vs consumer)
harness/brand/05-architecture  naming, IA, product/brand architecture
harness/brand/06-assets     asset usage rules; binaries live in /assets
harness/brand/07-runtime    how an agent should consume this at generation time
harness/brand/08-decisions  append-only, dated brand decision log
harness/brand/09-loops      Brand Check scores, recurring conflicts, what worked
harness/skills/<name>/SKILL.md   brand skills (contracts)
harness/output/             generated deliverables, each with a trace
harness/config.json         brand config (name + paths)   ·   harness/CLAUDE.md, README.md
assets/                     binary brand assets (logos, fonts)
scripts/brand-check.sh      conformance gate (machine half of Brand Check)
AGENTS.md  CLAUDE.md->AGENTS.md   instructions  ·  install.sh/uninstall.sh  ·  tests/run.sh  ·  docs/
```

## Working here

- **Add a truth:** create a `*.md` in the right `harness/brand/` section with the truth frontmatter.
  Cite the source, date it. To revise, supersede — don't edit in place. Run `./scripts/brand-check.sh`.
- **Add a skill:** `harness/skills/<name>/SKILL.md` with the skill contract; name the brand sections
  it reads.
- **Record a decision:** append a dated entry in `08-decisions/`.
- **Instantiate for a business:** clone, set `name` in `harness/config.json`, run `./install.sh`,
  then drive the `brand-truth` skill to populate `00-source` → `01-imprint`/`02-voice`/`03-design`.

## Commits & PRs

- Conventional-ish prefixes: `feat:`, `fix:`, `docs:`, `truth:`, `decision:`, `chore:`.
- Update [CHANGELOG.md](CHANGELOG.md) under "Unreleased" for changes to the protocol/tooling.
- The gate must be green.
