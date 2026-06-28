# Authoring your brand

How to turn this template into a real brand. The fictional **Northwind** examples show the shape —
replace them as you go.

## 0. Set up

```bash
$EDITOR harness/config.json     # set brand.name (replace REPLACE_ME), tagline, owner
./install.sh                    # wire the skills into pi + Claude
```

Delete or keep the `example-*.md` files as reference; the gate ignores nothing, so once you edit an
example into a real truth, update its `id` and `source`.

## 1. Capture raw input → `00-source`

Run the `brand-truth` skill (or do it by hand). Drop stakeholder interviews, the existing brand
audit, and an asset inventory into `harness/brand/00-source/`. Note where each came from and when.
Nothing here is "truth" yet — it's evidence.

## 2. Distill cited, dated truths

Pull claims out of `00-source` into the right section, each as a truth with the contract frontmatter:

| Put it in | When it's about |
|---|---|
| `01-imprint` | positioning, beliefs, mission — who the brand *is* |
| `02-voice` | tone, lexicon, do/say — **and refusals** (`type: refusal`: what it never says/does) |
| `03-design` | design tokens, type, color, spacing, logo rules |
| `04-lenses` | how truth adapts per audience/context (B2B vs consumer, web vs print) |
| `05-architecture` | naming, IA, product/brand architecture |
| `06-assets` | asset usage rules (binaries live in `assets/`) |
| `07-runtime` | how an agent should consume all this at generation time |

Every truth needs a `source` and a `date`. **Write your refusals early** — they're the sharpest,
most useful part of a brand for an agent.

## 3. Govern with decisions

When you make a meaningful brand choice, record it in `08-decisions/` (dated, append-only). To change
an earlier truth or decision, **supersede** it: add a new entry with `supersedes: <id>` and set the
old one's `status: superseded`. Never edit in place — the history is the point.

## 4. Produce and check

Use a contract skill like `landing-page` to produce a deliverable into `harness/output/<slug>/` with
a `trace.md`. Then run the `brand-check` skill to score it against your truths/refusals; the score is
written back into the trace and logged to `09-loops`.

## 5. Close the loop

`brand-check` logs recurring conflicts to `09-loops`. When the same conflict keeps appearing, that's
a signal: add a new truth or refusal (`01`–`03`) and a dated decision (`08-decisions`). The brand
gets sharper every cycle. *The spec is the easy part; taste is the whole job.*

## Keep the gate green

`./scripts/brand-check.sh` enforces the contracts. If it fails, it tells you which file is missing a
`source`, a `date`, or a trace. Run it before every commit.
