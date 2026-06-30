---
name: aikit-plan
description: Stand up and maintain phased progress files — an ai-progress/ folder (INDEX + per-effort roadmap + per-phase files) at the repo root — so multi-step work survives /compact, new sessions, and handoffs. Invoke when starting a non-trivial effort, starting/finishing a phase, hitting a blocker, or resuming cold. The canonical layout, hard rules, and templates live in AGENT-INSTRUCTIONS.md §4; this skill walks the doing.
---

# Plan + progress

> The operational procedure for the progress files **defined in
> [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) §4**. §4 is canonical for the layout (§4.1),
> hard rules (§4.2), updating (§4.3), resuming cold (§4.4), phase ordering (§4.5), and the templates
> (§4.6). This skill is the *how-to-do-it*, not a second copy — open §4 for the templates and rules;
> don't restate them here.

## When to use

- **Standing up an effort** — at the start of any **non-trivial** task (per §0 "Scale ceremony"),
  before scoping work, create its progress files. Skip only when the user says so, or the task is
  trivial / pure read-only (§4 "When to create").
- **During work** — when you start a phase, finish a checklist item or phase, hit a blocker, or
  discover new work.
- **At session boundaries** — at session end (log line) and session start (resume cold, §4.4). The
  §0 session-start check routes here when an effort is already in flight.

## Read first

- [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) **§4** — the layout, hard rules, and the four
  templates (`INDEX.md`, `{effort}-ROADMAP.md`, `phase-NN-{slug}.md`, `task-{slug}.md`) you'll copy.
- [`PROJECT.md`](../../PROJECT.md) — the **Role** (whose judgment frames scope) and the
  build/test/lint command the §4.5 verification phase runs.

## Procedure

### Create (first time for an effort/task)

1. Confirm the work is **non-trivial** (§0). Trivial single-file edits and read-only questions get no
   progress file.
2. **Lock scope with the user** before writing — in scope, out of scope, locked decisions (§2.2). Use
   `AskUserQuestion` for genuine open choices; don't invent answers.
3. Ensure `ai-progress/INDEX.md` exists (create it from the §4.6 INDEX template on a project's first
   effort); add one row for this effort/task.
4. **Multi-step effort** → write `{effort-slug}-ROADMAP.md` (Source · Scope · phase table · log) and
   create the `{effort-slug}/` folder. **Phase rows only — do not pre-write phase files.**
   **Single-step task** → write `task-{slug}.md` (plan + summary inline); no roadmap, no folder.
   (Templates: §4.6.)
5. **Order phases to prevent rework** — foundations before dependents (§4.5). Append the first
   session-log line.

### Update mid-work (follow §4.3)

- **Start a phase** → flip its roadmap row to `[~]`, **author `phase-NN-{slug}.md`**, then **pause for
  plan review (§2.4)** before building it.
- **Finish a checklist item** → flip `[ ]`→`[x]` in the phase file immediately; don't batch.
- **Finish a phase** → roadmap row to `[x]` **with its one-line outcome** (mandatory, §4.2 rule 1);
  set the phase file's artifacts; append a session-log line.
- **Blocker** → row to `[!]`; record what's blocked and what unblocks it in the phase file.
- **New work mid-flight** → insert `Phase Na` (new row + new phase file); **never renumber** (§4.2).
- **A whole new goal** → new roadmap/task + INDEX row, not extra phases here.

### Session end

Append one session-log line to the active roadmap/task — even "no progress" — biased toward what's
next; update the INDEX row's state phrase (§4.3, §7).

### Resume cold (session start, follow §4.4)

Read `INDEX.md` → open the active roadmap (Source, Scope, phase table) → open **only** the first
`[~]` (or first `[ ]` after a `[x]`) phase file. Done rows' one-line outcomes mean you don't reopen
completed phase files. Files beat memory.

## Verify

- [ ] Every phase has **exactly one** roadmap row: status + one-line outcome + link; the expanded plan
      lives only in the phase file (§4.2 rule 1).
- [ ] No expanded plans in the roadmap, no checklist parallel to the phase table, one session log
      (§8).
- [ ] Statuses are `[ ] / [~] / [x] / [!]`; dates absolute; phases not renumbered after a re-scope.
- [ ] The `INDEX.md` row exists and reflects current state.

## Anti-patterns

Defer to §8 and §4; the ones this skill most often prevents:

- ❌ One monolithic progress file (use the `ai-progress/` split).
- ❌ Expanded phase plans inside the roadmap; a `[x]` row with no one-line outcome.
- ❌ Pre-writing all phase files up front (author each at its plan-review gate).
- ❌ Appending an unrelated new goal as extra phases (new goal → new roadmap/task + INDEX row).
- ❌ Renumbering phases after a re-scope; relative dates.
