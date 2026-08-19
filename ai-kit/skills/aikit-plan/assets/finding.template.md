---
id: FND-{effort-id}-{phase-id}-{slug}   # phase segment optional; FND-{YYYYMMDD}-{slug} outside any effort
kind: defect            # defect | debt | risk | test-gap | docs
confidence: confirmed   # confirmed | likely | suspected
created: {YYYY-MM-DD}
---

# {short label}

<!-- SOURCE — pick the form matching how this was found (workflow §8), fill it in below, then DELETE this
     whole comment. Paths are relative to ai-progress/findings/.

  a) during a phase        Source: [effort-id](../effort-folder/ROADMAP.md) · [phase-id](../effort-folder/phases/phase-file.md)
  b) effort, but no phase  Source: [effort-id](../effort-folder/ROADMAP.md) · no phase — found during scoping / review / close-out
  c) no tracked effort     Source: what you were doing, on a date · `path/to/file.ext`
-->
> Source: [{effort-id}](../{source-effort-folder}/ROADMAP.md) · [{phase-id}](../{source-effort-folder}/phases/{source-phase-file})

<!-- A rung-2 finding: this file is authoritative, and its FINDINGS.md entry is only a pointer. No status
     field here — the inbox sections (Open / Recently triaged) own lifecycle state. Observation, Why it
     was deferred, and Why it matters are REQUIRED; drop the others only when genuinely empty. -->

## Observation

{What is actually wrong or questionable. Factual — no solution design here.}

## Why it was deferred

{What this sat outside: the approved scope it fell beyond, or — with no effort in flight — why it wasn't
addressed on the spot. Name what handling it would have expanded.}

## Affected locations

- `{path/to/file.ext:line}`

## Evidence

<!-- Never paste raw output. Link it from the originating effort's artifacts/. With no originating effort,
     link an already-approved evidence location, or stand up an investigation effort to hold it — never
     invent a global evidence directory. -->
- {what was observed, reproduced, or measured}
- [{audit or report}](../{source-effort-folder}/artifacts/{artifact-file})

## Why it matters

{The concrete consequence of leaving this alone. Not a preference — a cost, risk, or deficiency.}

## Suggested disposition

{Own effort, fold into planned maintenance, file in the tracker, or dismiss with rationale. Omit this
section entirely when no useful recommendation is known yet.}
