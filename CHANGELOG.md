# Changelog

All notable changes to this BCP template are documented here. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/); versions follow semver.

## [Unreleased]

### Added
- Initial Brand Context Protocol template, modeled on [Wild's BCP](https://craft.wild.as/bcp).
- Full `harness/brand/` structure (`00-source` … `09-loops`), each section with a README and an
  illustrative "Northwind" example carrying the truth/decision/loop frontmatter contracts.
- Three skills: `brand-truth` (build the single source), `landing-page` (produce a traced
  deliverable), `brand-check` (qualitative scoring + loop feedback).
- `scripts/brand-check.sh` conformance gate: truths cited + dated, decisions append-only + dated,
  skills valid, outputs traced, no hardcoded paths.
- Project-scoped `install.sh` / `uninstall.sh` wiring skills into `.claude/skills` + `.pi/skills`;
  `tests/run.sh` sandbox suite; CI.
- `AGENTS.md` (contracts + golden rules), `docs/ARCHITECTURE.md`, `docs/AUTHORING.md`.

### Planned
- A worked example output (landing page + trace) and a brand-check score in `09-loops`.
- Optional Tempest `/brand-init` generator to scaffold/update a brand repo from the dev stack.
