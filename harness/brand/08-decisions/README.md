# 08 — Decisions

The brand decision log. ADR-style (Architecture Decision Record), **append-only and dated**. When the brand changes direction, you record the decision here — you do not quietly edit a truth and lose the history.

## What goes here
- A dated record for every meaningful brand decision: voice shifts, naming-model changes, asset swaps, refusal additions
- The rationale and the alternatives considered
- Links to the truths the decision creates, changes, or supersedes

## How to author
- One file per decision, numbered: `example-0001-<slug>.md`, `example-0002-<slug>.md`, …
- Use the **decision frontmatter**: `id`, `date`, `status` (`accepted`, `superseded`, `rejected`).
- Body: state the decision, then the rationale.
- **Append-only.** Never edit or delete a past decision. To reverse one, write a new decision and set the old one's `status: superseded` (the only permitted edit), noting the superseding id.

## What happens next
Accepted decisions become or amend truths in `01`–`06`. Recurring conflicts surfaced in `09-loops` are resolved by writing a new decision here.
