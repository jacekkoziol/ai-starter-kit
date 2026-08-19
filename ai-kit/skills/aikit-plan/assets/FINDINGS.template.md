# Findings

<!--
Candidate out-of-scope observations awaiting triage.

NOT an accepted backlog, and NOT part of the normal cold-resume path. A finding may be escalated,
expanded into its own file under findings/, dismissed, resolved by an approved re-scope, or promoted to
an issue or a queued effort. The agent's manual and its plan skill own that ladder.

Entry format:  finding-id · kind/confidence · location or source — observation
  kind:        defect | debt | risk | test-gap | docs
  confidence:  confirmed | likely | suspected
-->

## Open

<!-- Every unresolved candidate lives here. A rung-2 finding is reduced to a pointer. -->

- `FND-{effort-id}-{slug}` · {kind}/{confidence} · `{path/to/file.ext:line}` — {what you observed, and
  why it matters in one clause}
- [`FND-{effort-id}-{phase-id}-{slug}`](findings/FND-{effort-id}-{phase-id}-{slug}.md)
  · {kind}/{confidence} — {short label; detail lives in the linked file}

## Recently triaged

<!-- At most 10. Drop the oldest past the cap — git history keeps older ephemeral dispositions.
     A durable dismissal is recorded as a Locked decision (project-wide → PROJECT.md;
     effort-specific → that effort's ROADMAP.md) and noted here. -->

- `FND-{effort-id}-{slug}` — promoted to `{TRACKER-ID} — {title}`.
- `FND-{effort-id}-{slug}` — promoted to [{id}-{slug}]({id}-{slug}/ROADMAP.md).
- `FND-{effort-id}-{slug}` — dismissed; {reason}. Durable rationale recorded in
  `PROJECT.md → Locked decisions`.
