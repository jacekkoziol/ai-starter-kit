---
schema: ai-progress/v2
id: {PROJ-142}        # ticket ID, or this folder's full date-and-slug name
kind: task            # task | epic
status: queued        # queued | active | blocked | done | cancelled
parent: null          # null, or the parent effort's id
created: {YYYY-MM-DD}
---

# {Effort name}

<!-- All seven sections below stay, in this order — an empty one reads "None." rather than being deleted.
     `Child efforts` is the single exception: epic-only, deleted for a task. -->

## Source
- Ticket / spec: {link, or one line describing the authoritative request} · Owner: {names or "team"}

## Outcome
- **Goal:** {one sentence}
- **Done when:** {the observable condition that ends this effort}

## Scope
- **In scope:** {what the work covers}
- **Out of scope:** {explicit exclusions}

## Locked decisions
- {settled choice the agent must not relitigate}

## Phases
<!-- One row per phase: status + one-line outcome + link. NO expanded plan here.
     A done row states what ACTUALLY happened, replacing its original target. -->

| ID | State | Target or actual outcome | Plan |
| --- | --- | --- | --- |
| P01 | `[ ]` | {target} | Not authored yet |
| P02 | `[ ]` | {target} | Not authored yet |

## Dependencies
<!-- Also the home for an effort-level blocker (blocked with no [!] phase): what's blocked, the cause,
     the exact unblock condition, and any safe parallel work. -->
- {external or cross-effort dependency, and what it blocks}

## Deferred / follow-ups
- {item} — {why deferred, what unblocks it}

<!-- EPIC ONLY — delete this section for a task. Each child sets `parent:` to this effort's id.
     No status column: the child's own ROADMAP.md frontmatter owns its status, and a copy here drifts. -->
## Child efforts

| Child effort | Contribution to the epic |
| --- | --- |
| [{TASK-31} — {name}](../{TASK-31-slug}/ROADMAP.md) | {what it contributes to the outcome} |
