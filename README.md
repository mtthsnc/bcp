# BCP — Brand Context Protocol

A brand written down as something usable by **people and machines** — a small, portable, git-native
standard for everything that makes a brand itself, in a form a person and an AI agent can both read
and produce from. Plain Markdown + a little YAML in git. **No login, no lock-in: a brand inside
someone else's tool is rented, not owned.**

This repo is a **reusable template** — clone it per business, fill in `harness/brand/`, and your
agents produce on-brand work with a trace back to the source. Modeled on
[Wild's Brand Context Protocol](https://craft.wild.as/bcp); built with the same portable-skill +
conformance-gate conventions as the rest of this stack, so it runs on **pi and Claude Code**.

> Status: **v0.1** — full faithful structure, an illustrative "Northwind" brand to show the shape,
> three skills, and a green Brand Check gate. Replace Northwind with your brand to begin.

## The four parts

| Part | Where | What it is |
|---|---|---|
| **Brand Truth** | `harness/brand/` | The single source: voice, design, beliefs, and **refusals** (what the brand never does). Every truth is cited + dated; append-only. |
| **Skills** | `harness/skills/` | Contracts. A skill names what it needs, pulls the right Brand Truth, and produces work. |
| **Output** | `harness/output/` | Deliverables — on-brand by construction, each carrying a **trace** back to the truths + skill that made it. |
| **Brand Check** | `scripts/brand-check.sh` + the `brand-check` skill | Scoring + feedback. Machine half = the conformance gate; qualitative half = the skill that scores output and feeds learnings back. |

Brand Truth is not static: every output generates evidence (scores, recurring conflicts), and that
evidence flows back as sharper rules and new refusals (`harness/brand/09-loops` → `08-decisions`).

## Structure

```
harness/brand/00-source … 09-loops   the Brand Truth (10 sections; see each README)
harness/skills/{brand-truth, landing-page, brand-check}/SKILL.md
harness/output/                      deliverables + traces
harness/config.json                  your brand name + paths + brand-check dimensions
assets/                              binary brand assets (logos, fonts)
scripts/brand-check.sh               the Brand Check conformance gate
AGENTS.md  CLAUDE.md→AGENTS.md        instructions for agents & humans
install.sh / uninstall.sh  tests/  docs/  .github/
```

## Skills (the starting set)

- **`brand-truth`** — build/extend the single source: stakeholder interview → distill cited, dated
  truths and refusals. Append-only; supersede, never overwrite.
- **`landing-page`** — a contract skill: pull voice + design + lens + architecture, produce a page
  into `harness/output/` with a trace, then hand off to `brand-check`.
- **`brand-check`** — score an output against Brand Truth with cited violations, write the score to
  the trace, and feed recurring conflicts back into the brand.

## Quickstart

```bash
git clone <this repo> my-brand && cd my-brand
$EDITOR harness/config.json          # set brand.name (replace REPLACE_ME)
./install.sh                         # wire skills into pi (.pi/skills) and Claude (.claude/skills)
./scripts/brand-check.sh             # the gate — green on the shipped template
```

Then run your agent from the repo root (it reads `AGENTS.md`/`CLAUDE.md` automatically) and drive
the `brand-truth` skill to replace the Northwind examples with your brand. On pi: `/skill:brand-truth`;
in Claude Code the skill auto-invokes or via its skill menu.

## Develop

The skills are the product; everything else is thin wiring. See [AGENTS.md](AGENTS.md) for the
golden rules and the frontmatter contracts, [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the
design, and [docs/AUTHORING.md](docs/AUTHORING.md) for how to fill in your brand. Before committing:

```bash
./scripts/brand-check.sh   # contracts: truths cited+dated, decisions append-only, outputs traced
./tests/run.sh             # install topology + gate-on-template
```

## License

MIT © mtthsnc. See [LICENSE](LICENSE).
