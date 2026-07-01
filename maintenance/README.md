# `maintenance/` — periodic upkeep for the kit (home-only)

> **Home-only, never vendored.** Like [`MAINTAINING.md`](../MAINTAINING.md) and
> [`CHANGELOG.md`](../CHANGELOG.md), this folder lives *outside* `AI/` and must never be copied
> downstream — it's chores for keeping *this* home repo's kit current, not part of the kit itself.

Some upkeep isn't triggered by a code change — it's *time*-triggered, because the kit encodes **external
facts** (like how each AI runtime wires up) that drift as those tools evolve. Each such chore is a
checklist file here; the **ledger** below records how often it should run and when it last did.
[`MAINTAINING.md`](../MAINTAINING.md)'s session-start step reads this ledger and reminds the user when a
task is overdue.

## Ledger

| Task | Cadence | Last run | Notes |
| --- | --- | --- | --- |
| [`verify-runtime-wiring`](verify-runtime-wiring.md) | 1 week | 2026-07-01 | Runtime facts (root files, skills dirs, symlink support) re-verified against current docs at kit v1.8.0. |

**Updating a last-run date is a claim that you actually ran the task** — set it to the *real* current
date only after completing that task's checklist, never in advance (the same self-verifying discipline
as the session-start handshakes). Leave it `never` for a task that hasn't run yet.

## Adding a periodic chore

1. Write `maintenance/{task}.md` — a short checklist: which external facts/sources to re-check, what to
   compare them against in the kit, and what to update. Bump the Kit version + add a `CHANGELOG.md`
   entry **only if** a fix touches vendored `AI/` content (home-only edits don't bump).
2. Add a row to the ledger above (task · cadence · last run · notes).
3. That's it — the session-start nudge picks it up automatically from the ledger.
