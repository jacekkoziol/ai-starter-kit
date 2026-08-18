---
name: aikit-plan
description: Stand up and maintain progress tracking — one ai-progress/ effort folder per goal (ROADMAP + LOG + gate-authored phase files, plus a close-out SUMMARY) at the repo root — so multi-step work survives context compaction, new sessions, and handoffs. Invoke when starting a non-trivial effort, starting/finishing a phase, hitting or clearing a blocker, re-scoping, resuming cold, or closing work as done or cancelled. Behavior lives in AGENT-INSTRUCTIONS.md §4; the file format lives in references/progress-contract.md with copy-me templates in assets/; this skill walks the doing.
---

# Plan + progress

> The **procedures**. [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) §4 owns the behavior (layout,
> hard rules, cold-resume path, phase ordering); [`progress-contract.md`](references/progress-contract.md)
> owns the **format** (frontmatter, sections, naming, status consistency, validation). Open the contract
> when you write or amend a file — don't restate it, don't guess a section name.
>
> **Every progress file starts as a copy** of its template in [`assets/`](assets/) — `INDEX`, `ROADMAP`,
> `LOG`, `phase`, `SUMMARY` (contract §11 maps each to its destination). Copy, fill in, delete what
> doesn't apply; never retype one from memory.

## When to use

Before building anything **non-trivial** (§0 "Scale ceremony"); when starting a phase, finishing an item
or phase, hitting or clearing a blocker, re-scoping, or discovering a new goal; at session start (cold
resume, §4.4 — the §0 check routes here when an effort is in flight) and session end; and when closing an
effort as `done` or `cancelled`.

Also read [`PROJECT.md`](../../PROJECT.md) — the **Role** (whose judgment frames scope), the
build/test/lint commands a verification phase runs, and **Version control → Progress artifacts**.

## Procedures

### Create an effort

1. Confirm the work is **non-trivial** (§0). Trivial edits and read-only questions get no effort.
2. Read `ai-progress/INDEX.md` and check whether this goal already has an `Active`, `Blocked`, or
   `Queued` effort — **resume it instead of creating a duplicate**.
3. Read the relevant code and `reference/` docs before scoping (§2.1).
4. **Lock scope with the user** (§2.2): outcome, **done-when** criteria, in scope, out of scope, locked
   decisions, dependencies. Batch genuine open choices as questions; never invent answers.
5. Pick a **stable ID and slug** (contract §3) — external ticket ID preferred, creation date otherwise.
6. Create `{id}-{slug}/` by copying `assets/ROADMAP.template.md` and `assets/LOG.template.md` into it,
   plus an empty `phases/`; add a row to `INDEX.md` (copying `assets/INDEX.template.md` on a project's
   first effort).
7. Write **ordered phase rows only** — do not pre-author phase files. Order them to prevent rework (§4.5).
8. Append the first `LOG.md` line.
9. Starting immediately? Author only the first phase file and go to **Start a phase**. Otherwise leave
   `status: queued` with every row `[ ]`.

### Resume (cold start)

Follow §4.4 exactly: `INDEX.md` → the chosen `ROADMAP.md` → the **one** `[~]` phase file. Don't reopen
completed phase files; leave `LOG.md`, `SUMMARY.md`, `artifacts/`, and `scripts/` cold unless the current
state fails to explain *why* something happened. For closed work, read `SUMMARY.md` first.

**Legacy shapes** (`task-{slug}.md`, `{effort}-ROADMAP.md`, `{effort}/phase-NN-*.md`, or a roadmap with
no `schema:`) are still valid. Resume them **in place, in their existing shape**; never migrate one
without being asked (contract §9).

### Start a phase

1. Confirm prerequisite phases are `[x]` or explicitly waived.
2. Row to `[~]`; effort `status: active`.
3. Author that phase file from `assets/phase.template.md` — and only that one.
4. Append a `LOG.md` line.
5. **Present the plan and stop for approval (§2.4).** Build only on an explicit go, or a standing
   pre-authorization from the user.

### Implement an approved phase

Follow the approved checklist, flipping items as you finish them (never batched). Keep changes inside the
phase's scope. If reality diverges materially, **update the plan before continuing** rather than going
off-script; record scope or decision changes in the roadmap and the log. Generated evidence goes to
`artifacts/`, reproducible helpers to `scripts/`. Never smuggle in unrelated work.

### Finish a phase

1. Account for every checklist item — done, or explicitly noted as not done.
2. Run the phase's verification (`PROJECT.md` Commands). **Record actual results honestly**; if nothing
   automated exists, say what you did instead (§2.6).
3. Re-read the diff against the plan.
4. Row to `[x]`, replacing its target with a **concise actual outcome** (HARD RULE, §4.2 rule 2).
5. Append a `LOG.md` line; sync the `INDEX.md` row if the effort's state changed.

### Blocker, and clearing it

Row to `[!]`, effort `status: blocked`, and record in the phase file: what's blocked, the cause, the
**exact unblock condition**, and any safe parallel work. Log it; move the `INDEX.md` entry to `Blocked`.
Never invent a scope-changing, costly, security-sensitive, or irreversible workaround (§5.2). When
cleared: row back to `[~]`, `status: active`, update the phase notes, log it, move the index entry back.

### Re-scope

Decide first whether the work still serves the **same outcome**. If yes: update the roadmap's scope,
decisions, dependencies, or follow-ups; log the change; amend affected phase plans; insert
`phase-NNa-{slug}.md` if new work is needed — **never renumber** (§4.2 rule 5). If it has its own
outcome or lifecycle, create a **new effort** (or a child effort with `parent:` set) instead.

### End a session

Update checkboxes, confirm roadmap status and the phase table agree, append **one** concise `LOG.md`
line — even for a no-progress session where you only inspected or attempted work — sync the `INDEX.md`
row, and leave an explicit next action and blocker state.

### Close as done

Confirm every required phase is `[x]` and the done-when criteria are met (or record accepted
limitations). Run the applicable final verification. Set `status: done`, write `SUMMARY.md` from
`assets/SUMMARY.template.md`, append the final log line, and move the `INDEX.md` row to `Recently
closed` — archiving the oldest row when that list passes 10.

### Close as cancelled

Set `status: cancelled`, leave incomplete phase statuses **accurate** (don't fake completion), and write
`SUMMARY.md` (same template) explaining why it stopped and what was retained, reverted, or left
incomplete. Log it and move the index row to `Recently closed`.

### Reopen

Prefer a **new related effort** when the goal is new. Reopen the original only when closure was premature
or its done-when criteria were never met: `status: active`, add a new phase without renumbering old ones,
log the reason, move the index row back to `Active`, and regenerate `SUMMARY.md` only when it closes again.

## Verify

Walk the contract's **validation checklist** (§10) — it's the full gate. The failures this skill most
often catches:

- [ ] Effort `status:` and the phase table agree (contract §5); at most one `[~]`.
- [ ] Every `[x]` row carries an **actual** one-line outcome, not its original target.
- [ ] No phase file carries a status field; no future phase was pre-authored.
- [ ] Every `{placeholder}` from the template was replaced; dates absolute; no phase renumbered.

## Anti-patterns

Defer to §8 and §4; the ones this skill most often prevents:

- ❌ A second status surface — a status field in a phase file, or treating `INDEX.md`/`SUMMARY.md` as
  authoritative.
- ❌ Pre-authoring every phase file instead of one per gate.
- ❌ A `[x]` row still showing its planned target instead of what actually happened.
- ❌ Migrating a legacy effort unasked, or renaming an effort folder.
- ❌ Appending an unrelated goal as extra phases (new goal → new effort + index row).
