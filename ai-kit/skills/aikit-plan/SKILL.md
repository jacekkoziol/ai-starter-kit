---
name: aikit-plan
description: Stand up and maintain progress tracking — one ai-progress/ effort folder per goal (ROADMAP + LOG + gate-authored phase files, plus a close-out SUMMARY) at the repo root — so multi-step work survives context compaction, new sessions, and handoffs. Invoke when starting a non-trivial effort, starting/finishing a phase, hitting or clearing a blocker, re-scoping, resuming cold, or closing work as done or cancelled — and when capturing, expanding, triaging, dismissing, or promoting an out-of-scope finding. Behavior lives in AGENT-INSTRUCTIONS.md §4; the file format lives in references/progress-contract.md, the findings ladder in references/findings-workflow.md, with copy-me templates in assets/; this skill walks the doing.
---

# Plan + progress

> The **procedures**. [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) §4 owns the behavior (layout,
> hard rules, cold-resume path, phase ordering); [`progress-contract.md`](references/progress-contract.md)
> owns the **format** (frontmatter, sections, naming, status consistency, validation). Open the contract
> when **creating** a tracking file, **changing its structure**, **validating**, **closing**, or
> **reopening** — not for a cold resume or a routine content update (a checkbox, a log line, a phase
> outcome) that preserves the file's shape. Don't restate it, don't guess a section name.
>
> **Every templated tracking file starts as a copy** of its asset in [`assets/`](assets/) — effort files
> `INDEX`, `ROADMAP`, `LOG`, `phase`, `SUMMARY`, plus findings files `FINDINGS` and `finding` (contract §11
> maps each to its destination). `archive/closed-YYYY.md` is the deliberate exception — it has no template.
> Copy and fill in; never retype one from memory.

## When to use

Before building anything **non-trivial** (§0 "Scale ceremony"); when starting a phase, finishing an item
or phase, hitting or clearing a blocker, re-scoping, or discovering a new goal; at session start (cold
resume, §4.4 — the §0 check routes here when an effort is in flight) and session end; when closing an
effort as `done` or `cancelled` or reopening one; and when **capturing, expanding, triaging, dismissing,
or promoting an out-of-scope finding** (§2.5 decides escalate-versus-record).

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
5. Pick a **stable ID and slug** (contract §3) — external ticket ID preferred, the full `{date}-{slug}`
   folder name otherwise — and confirm no existing effort already carries that `id:`.
6. Create `{id}-{slug}/` by copying `assets/ROADMAP.template.md` and `assets/LOG.template.md` into it,
   plus an empty `phases/`; add a row to `INDEX.md` (copying `assets/INDEX.template.md` on a project's
   first effort).
7. Write **ordered phase rows only** — do not pre-author phase files. Order them to prevent rework (§4.5).
8. Append the first `LOG.md` line.
9. Starting immediately? Go to **Start a phase** — that procedure marks the row `[~]`, authors the phase
   file, and presents the gate. Otherwise leave `status: queued` with every row `[ ]`.

### Resume (cold start)

Follow §4.4: `INDEX.md` → the chosen `ROADMAP.md` → the one phase in flight. Which file that is depends on
the effort's state:

| Roadmap state | Open |
| --- | --- |
| `active`, one `[~]` | That phase file. |
| `blocked`, one `[!]` | That phase file — and its unblock condition. **Don't start another phase.** |
| `blocked`, no `[!]` | The roadmap's effort-level blocker. **Don't start another phase.** |
| Nothing in flight, not blocked | Nothing yet — run **Start a phase** for the next `[ ]` row. |
| `done` / `cancelled` | `SUMMARY.md` first. |

Don't reopen completed phase files; leave `LOG.md`, `SUMMARY.md`, `artifacts/`, and `scripts/` cold unless
the current state fails to explain *why* something happened.

**`[~]` is not proof its gate was passed** — it covers both "awaiting approval" and "approved, building."
If neither this session nor `LOG.md` records the approval, re-present the plan and wait (§2.4).

**Legacy shapes** (`task-{slug}.md`, `{effort}-ROADMAP.md`, `{effort}/phase-NN-*.md`, or a roadmap with
no `schema:`) are still valid. Resume them **in place, in their existing shape**; never migrate one
without being asked (contract §9).

### Start a phase

1. Confirm prerequisite phases are `[x]` or explicitly waived.
2. Row to `[~]`; effort `status: active`.
3. Author that phase file from `assets/phase.template.md` — and only that one.
4. **Replace that row's `Not authored yet` with a relative link to the file** you just created.
5. **Move the `INDEX.md` entry to `Active`** if the effort was `Queued` — the router is a projection of
   roadmap status (contract §8).
6. Append a `LOG.md` line.
7. **Present the plan and stop for approval (§2.4).** Build only on an explicit go, or a standing
   pre-authorization from the user. Record the approval in the next `LOG.md` line — a later cold resume
   can't infer it from `[~]`.

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
**exact unblock condition**, and any safe parallel work. **With no phase in flight** — blocked between
phases, or before the first one — set `status: blocked` with **no** `[!]` row and record the same four
things in the roadmap's `Dependencies` instead. Log it; move the `INDEX.md` entry to `Blocked`.
Never invent a scope-changing, costly, security-sensitive, or irreversible workaround (§5.2).

**Clear it at the level it was set:**

- **Phase-level** — `[!]` back to `[~]`, `status: active`, update the phase notes.
- **Effort-level** — resolve the blocker facts in `Dependencies`, then restore the open state: `queued`
  when no phase has started yet, otherwise `active`. **Don't activate a phase just because the blocker
  cleared** — starting one is still *Start a phase*, gate included.

Either way: log the unblock and move the `INDEX.md` entry to the matching section.

### Handle an out-of-scope finding

Full ladder, ID rules, taxonomy, and validation:
[`references/findings-workflow.md`](references/findings-workflow.md).

1. Apply §2.5's test: could the planned delivery be unsafe, incorrect, materially unverifiable, or
   inconsistent with its done criteria? **Yes or uncertain** → surface it now and use the blocker or
   re-scope procedure above. Never park it in the inbox.
2. Otherwise capture one line in `FINDINGS.md` (from `assets/FINDINGS.template.md` on first use) —
   `id · kind/confidence · location — observation`. Don't design a fix at capture time.
3. Expand to `findings/{id}.md` (from `assets/finding.template.md`) **only** when evidence or prior
   investigation must be preserved; then reduce the inbox line to a pointer. Substantial evidence goes to
   the originating effort's `artifacts/`.
4. Keep working within approved scope — never silently fix unrelated code.
5. **Triage** a finding by dismissing it, resolving it via an approved re-scope, or promoting it to a
   tracker issue or a `queued` effort. Durable dismissals become a Locked decision (project-wide →
   `PROJECT.md`; effort-specific → that effort's `ROADMAP.md`).

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
limitations). **Triage the findings this effort produced** — nothing meaningful may stay stranded in a
completed phase file, a log line, or a closed roadmap (findings workflow §9). Run the applicable final
verification. Set `status: done`, write `SUMMARY.md` from
`assets/SUMMARY.template.md`, append the final log line, and move the `INDEX.md` row to `Recently
closed` — archiving the oldest row when that list passes 10.

### Close as cancelled

Set `status: cancelled` and leave incomplete phase statuses **accurate** — never fake completion. Then run
**Close as done**'s close-out steps: triage the findings this effort produced, write `SUMMARY.md`, append
the final log line, and move the `INDEX.md` row to `Recently closed` — archiving the oldest when that list
passes 10. The summary explains why it stopped and what was retained, reverted, or left incomplete.

### Reopen

Prefer a **new related effort** when the goal is new. Reopen the original only when closure was premature
or its done-when criteria were never met:

1. **Delete `SUMMARY.md`** — it exists only for closed work (contract §7); git history keeps the old
   close-out.
2. **Normalize the phase table** to at most one phase in flight — resume an incomplete phase where it
   still represents the work, otherwise insert `phase-NNa` rather than renumbering.
3. Set `status: active` — or, if the original blocker still stands, restore it **at its original level**:
   a phase blocker as one `[!]`, an effort-level one as `status: blocked` with no `[!]` row and the facts
   back in `Dependencies`.
4. Log the reason, then remove the closed router row from **whichever surface holds it** — `Recently
   closed` *or* `archive/closed-YYYY.md` — and add the effort to `Active` or `Blocked`.

## Verify

Walk the contract's **validation checklist** (contract §10) — it's the full gate. The failures this skill most
often catches:

- [ ] Effort `status:` and the phase table agree (contract §5); at most one phase in flight — `[~]` or
      `[!]`, never both.
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
