---
id: FND-{effort-id}-{phase-id}-{slug}
kind: defect            # defect | debt | risk | test-gap | docs
confidence: confirmed   # confirmed | likely | suspected
created: {YYYY-MM-DD}
---

# {short label}

> Source: [{effort-id} / {phase-id}](../{id}-{slug}/phases/phase-NN-{slug}.md)

<!-- A rung-2 finding: this file is authoritative for the finding, and its FINDINGS.md entry is only a
     pointer. No status field here — the inbox section (Open / Recently triaged) owns lifecycle state.
     Delete any section below that doesn't apply; don't keep empty boilerplate. -->

## Observation

{What is actually wrong or questionable. Factual — no solution design here.}

## Why it was out of scope

{Which approved scope this sat outside, and what handling it would have expanded.}

## Affected locations

- `{path/to/file.ext:line}`

## Evidence

<!-- Link large evidence from the originating effort's artifacts/ — never paste raw output here. -->
- {what was observed, reproduced, or measured}
- [{audit or report}](../{id}-{slug}/artifacts/{file})

## Why it matters

{The concrete consequence of leaving this alone. Not a preference — a cost, risk, or deficiency.}

## Suggested disposition

{Own effort, fold into planned maintenance, file in the tracker, or dismiss with rationale. Omit this
section entirely when no useful recommendation is known yet.}
