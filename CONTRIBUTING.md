# Contributing to this BCP

Whether you're improving the template or filling in a real brand, the same rules apply.

## Setup

```bash
pip install pre-commit            # plus shellcheck (apt-get install shellcheck or a release binary)
pre-commit install && pre-commit install --hook-type pre-push
./scripts/brand-check.sh && ./tests/run.sh
```

## The rules that matter

See [AGENTS.md](AGENTS.md) for the full contracts. In short:

- **Every truth is cited and dated** (`source` + `date` frontmatter). No exceptions.
- **Append-only; supersede, don't overwrite.** Changing a truth or decision means a new entry with
  `supersedes:` and the old one marked `status: superseded`.
- **Skills pull from Brand Truth; output traces back to it.**
- **The gate is law** — `./scripts/brand-check.sh` before every commit, `./tests/run.sh` before push.
- **No hardcoded home/user paths.**

## Adding a skill

`harness/skills/<name>/SKILL.md` with frontmatter `name` (== directory) + `description` ("Use when…",
≤ 1024). Body: Overview → Procedure → Common mistakes → Guardrails, plus a "Pulls from:" line naming
the brand sections it reads. Then `./install.sh` to wire it.

## Commits

- Prefixes: `feat:`, `fix:`, `docs:`, `truth:`, `decision:`, `chore:`.
- Update [CHANGELOG.md](CHANGELOG.md) under "Unreleased" for protocol/tooling changes.
- CI (Brand Check + tests) must be green.
