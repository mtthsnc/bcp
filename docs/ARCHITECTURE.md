# Architecture

BCP is a git repo of Markdown + a little YAML that captures a brand so both humans and AI agents can
read it and produce from it. The design goal: **on-brand by construction, with a trace**, and no
vendor lock-in.

## The loop

1. **Brand Truth** — the single source under `harness/brand/`, split into ten sections
   (`00-source` … `09-loops`). Every truth carries `source` + `date`; refusals (`type: refusal`) are
   first-class. Append-only: to change a truth you supersede it, you never overwrite it — the history
   is the point.
2. **Skills** — `harness/skills/<name>/SKILL.md`, the same portable Agent Skills standard used by the
   rest of the stack. A skill is a *contract*: it states which brand sections it pulls, produces a
   deliverable, and attaches a trace.
3. **Output** — `harness/output/<slug>/`, each with a `trace.md` (`produced_by`, `date`, `sources`,
   `brand_check`). Because output can only draw from Brand Truth, it is on-brand the moment it's made.
4. **Brand Check** — two halves:
   - *Machine* (`scripts/brand-check.sh`): the conformance gate. It enforces the structural
     contracts — truths cited + dated, decisions append-only + dated, skills valid, outputs traced,
     no hardcoded paths.
   - *Qualitative* (`brand-check` skill): scores an output against the documented truths/refusals
     with cited violations, writes the score into the trace, and logs to `09-loops`.

   Evidence flows back: recurring conflicts in `09-loops` become proposed truths/refusals
   (`01`–`03`) and dated decisions (`08-decisions`). Brand Truth sharpens over time.

## Why these contracts

The value is not the folder names — it's that the machine-checkable rules make the brand *trustable*:

- **Cited + dated truths** mean every claim is traceable to a source, and you can see when it was
  decided. The gate rejects an uncited claim, so the brand can't quietly fill with opinion.
- **Append-only / supersede** means decisions accrete with history instead of being silently edited.
- **Output traces** mean every deliverable can be audited back to the exact truths it used.
- **Refusals as truths** make "what we never do" a checkable artifact, not folklore.

See [AGENTS.md](../AGENTS.md) for the exact frontmatter each contract requires.

## Cross-harness, project-scoped

Brand skills belong to *this brand*, so they install **project-scoped**, not globally:

```
harness/skills/<name>  ──symlink──▶  <repo>/.claude/skills/<name>   (Claude Code project skills)
                       ──symlink──▶  <repo>/.pi/skills/<name>       (pi project skills)
```

`install.sh` is idempotent and writes only those symlinks (gitignored; the canonical skills live in
`harness/skills/`). Both harnesses read the repo's `AGENTS.md`/`CLAUDE.md` automatically when run
from the repo root. `BCP_DEST` overrides the wiring location (used by the test harness). pi loads
project skills once you trust the project.

This mirrors the rest of the stack: one source tree, portable `SKILL.md` skills, a conformance gate,
and a sandboxed test suite — so a brand repo is engineered with the same rigor as the code repos.

## Files

| Path | Role |
|---|---|
| `harness/brand/NN-section/` | the ten Brand Truth sections (each has a README + examples) |
| `harness/skills/<name>/SKILL.md` | brand skills (contracts) |
| `harness/output/<slug>/trace.md` | deliverable provenance |
| `harness/config.json` | brand name, paths, `brandCheck` dimensions + threshold |
| `assets/` | binary brand assets, referenced from `06-assets` |
| `scripts/brand-check.sh` | Brand Check conformance gate |
| `install.sh` / `uninstall.sh` | project-scoped skill wiring |
| `tests/run.sh` | install topology + gate-on-template assertions |
