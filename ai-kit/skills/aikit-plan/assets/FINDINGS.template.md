# Findings

<!--
Candidate out-of-scope observations awaiting triage.

NOT an accepted backlog, and NOT part of the normal cold-resume path. A finding may be escalated,
expanded into its own file under findings/, dismissed, resolved by an approved re-scope, or promoted to
an issue or a queued effort. The agent's manual and its plan skill own that ladder.

Entry format:  finding-id · kind/confidence · location or source — observation · capture date
  kind:        defect | debt | risk | test-gap | docs
  confidence:  confirmed | likely | suspected
-->

## Open

<!-- Every unresolved candidate lives here. A rung-2 finding is reduced to a pointer. Search here and in
     archive/ before adding one — never file a duplicate. -->

- `FND-{effort-id}-{slug}` · {kind}/{confidence} · `{path/to/file.ext:line}` — {what you observed, and
  why it matters in one clause} · {YYYY-MM-DD}
- [`FND-{effort-id}-{phase-id}-{slug}`](findings/FND-{effort-id}-{phase-id}-{slug}.md)
  · {kind}/{confidence} — {short label; detail lives in the linked file} · {YYYY-MM-DD}

## Recently triaged

<!-- At most 10, newest first, each dated; a rung-2 row keeps its link. Past the cap, MOVE the oldest
     row to archive/findings-YYYY.md (month heading from its date; rewrite links as ../) — never drop it.
     Once the first row is archived, add a line below this comment linking the year's archive —
     e.g. "Older triaged findings: [2026 archive](archive/findings-2026.md)." — then delete this comment.
     A durable dismissal is recorded as a Locked decision (project-wide → PROJECT.md;
     effort-specific → that effort's ROADMAP.md) and noted here. -->

- `FND-{effort-id}-{slug}` — promoted to `{TRACKER-ID} — {title}` · {YYYY-MM-DD}
- `FND-{effort-id}-{slug}` — promoted to [{effort-folder}]({effort-folder}/ROADMAP.md) · {YYYY-MM-DD}
- `FND-{effort-id}-{slug}` — resolved by re-scope of [{effort-folder}]({effort-folder}/ROADMAP.md) · {YYYY-MM-DD}
- [`FND-{effort-id}-{phase-id}-{slug}`](findings/FND-{effort-id}-{phase-id}-{slug}.md) — dismissed;
  {reason}. Durable rationale recorded in `PROJECT.md → Locked decisions` · {YYYY-MM-DD}
