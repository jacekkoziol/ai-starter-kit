# Changelog

All notable changes to the **AI kit** (the vendored `ai-kit/` folder) are recorded here. This file is
**home-only** — it lives beside [`MAINTAINING.md`](MAINTAINING.md) and never vendors downstream.

The kit follows [Semantic Versioning](https://semver.org/): **MAJOR** = breaking (forces a downstream
re-bootstrap or breaks a `§N` reference), **MINOR** = additive/backward-compatible, **PATCH** =
wording/clarification/fixes. The canonical version is the **Kit version** line at the top of
`ai-kit/AGENT-INSTRUCTIONS.md`; the §0 session-start handshake echoes it. See
[`MAINTAINING.md` → "Versioning & releases"](MAINTAINING.md) for the bump discipline.

## [2.10.0] — 2026-08-19

> **The effort lifecycle becomes a closed graph.** Four consecutive validation rounds found the same
> defect shape — a status made legal in one surface without every way into and out of it being defined.
> `blocked` with no `[!]` row was legal from 2.6.0, got a creation path in 2.9.0, and a clearing path only
> in 2.9.1. This adds the surface where that gap is visible instead of latent.

### Added

- **`progress-contract.md` §5.1 — legal transitions.** Every effort-status change is now one of ten
  enumerated transitions with its triggering procedure: creation into `queued` or `active`; `queued` →
  `active` / `blocked` / `cancelled`; `active` → `blocked` / `done` / `cancelled`; `blocked` → `active`
  (a phase to resume or start) / `queued` (effort-level blocker cleared with no phase started) /
  `cancelled`; and reopen from `done` / `cancelled`, restoring a still-standing blocker at its original
  level. **No other transition is legal**, and the closing rule states the invariant the table exists for:
  a state that can be entered but not left — or left but not entered — is the defect.
- **A validation-checklist item** — every status change since the last entry was a legal transition.
- **A maintenance rule tying it down** (home-only): adding an effort status or lifecycle state now
  requires its rows in §5.1 in *both* directions, its phase-table expectation in §5, and the procedure
  performing each transition in the skill. Adding a state without an exit is what the last four rounds
  kept catching by hand.

`ai-progress/v2` is unchanged — §5.1 documents transitions among statuses the schema already permits and
forbids none that were previously in use.

## [2.9.1] — 2026-08-19

> **Clearing an effort-level blocker.** 2.9.0 made effort-level blockers creatable and resumable but
> defined *clearing* only for the phase-level case — the one lifecycle hole a fourth validation pass found,
> plus five prose inconsistencies it left behind. No structural change.

### Fixed

- **Unblocking now branches by level.** 2.9.0 added `status: blocked` with no `[!]` row and the facts in
  the roadmap's `Dependencies`, then told the agent to clear it by moving a row back to `[~]` and updating
  "the phase notes" — neither of which exists in that case. Clearing now says: **phase-level** → `[!]` to
  `[~]`, `status: active`, update the phase notes; **effort-level** → resolve the `Dependencies` facts and
  restore `queued` (no phase started yet) or `active`, explicitly *without* activating a phase, since
  starting one is still *Start a phase* with its gate.
- **Reopen restores a blocker at its original level.** It said "one `[!]` and `status: blocked`", which
  silently converts a preserved effort-level blocker into a phase-level one — and a reopened effort may
  have no phase to attach it to.
- **The skill's abbreviated Verify matched the old rule.** It still read "at most one `[~]`" after the
  contract moved to "at most one phase in flight — `[~]` or `[!]`, never both." The full contract gate
  caught the bad state either way, so this was a stale summary rather than an escape.
- **`phase.template.md` asked for three of the four blocker facts** — what's blocked, cause, unblock
  condition — omitting *safe parallel work*, which the procedure requires and the roadmap template already
  carried for the effort-level case.
- **One placeholder survived in a guidance comment.** 2.9.0's invariant reserves `{…}` for fill slots, but
  `finding.template.md`'s `id:` line still carried `FND-{YYYYMMDD}-{slug}` in its inline comment — the very
  pattern the invariant forbids. (It hid because the verification scan only inspected `<!-- -->` blocks,
  not YAML `#` comments.) Now prose.
- **A findings provenance claim was too strong.** *"The ID encodes the effort and phase"* justified having
  no `source:` field — but the phase segment is optional and a repo-level finding encodes a date instead.
  It now says the ID encodes what provenance it has, with the `Source` blockquote carrying the origin.
- **The README's "reads only three things"** is now "at most three": an effort blocked between phases has
  no phase in flight, so resume reads two. Matches §4.4 exactly.

## [2.9.0] — 2026-08-19

> **Blocked efforts, and the seams around them.** A third validation pass against 2.8.1 found seven
> cross-file inconsistencies. The important one: cold resume had no answer for a *blocked* effort, and
> read as an instruction to start the next phase straight past the blocker. The rest are seams the v2
> refactor left — a started phase that nothing links to, an archived row whose link breaks on the way
> down, a log field that assumes a phase exists before one does. Additive; `ai-progress/v2` unchanged.

### Fixed

- **Cold resume is state-aware, and never walks past a blocker.** §4.4 said to open the `[~]` phase and,
  "with no phase active," to start the next `[ ]` row. A blocked effort has `[!]`, not `[~]` — so the
  literal reading was *start a new phase and leave the blocker behind*. (2.8.0 introduced that imperative
  while fixing a different vagueness in the same sentence.) Resume now branches on roadmap state:
  `[~]` → that file · `[!]` → that file **and its unblock condition** · `blocked` with no `[!]` → the
  roadmap's effort-level blocker · nothing in flight **and not blocked** → *Start a phase* · closed →
  `SUMMARY.md`. The skill carries it as a table. §0's "pick up the next phase" and the README's "resume
  the next phase" are corrected to match — both could send an agent past an active or blocked phase.
- **Effort-level blockers have a procedure.** The contract has always allowed a blocked effort with no
  `[!]` row, but the blocker procedure only handled the phase-level case, so the allowed state had no way
  to be created. Blocking between phases (or before the first) now records the same four facts — what's
  blocked, cause, exact unblock condition, safe parallel work — in the roadmap's `Dependencies`.
- **Starting a phase now links it and moves the router row.** Steps 1–5 set `[~]`, authored the file, and
  logged — but never replaced that row's `Not authored yet` with a link, and never moved a queued effort's
  `INDEX.md` entry to `Active`. The result was a phase in flight that the roadmap didn't link and the
  router still called queued, contradicting contract §8's projection rule.
- **Phase-versus-child-effort no longer contradicts the plan gate.** The contract defined a phase as work
  needing "no separate review gate" while the manual gives *every* phase one, which read as making every
  phase eligible to be a child effort. The distinction is now the **independent lifecycle** — own owner,
  acceptance gate, blocked/cancelled state, pull request, release, or `SUMMARY.md` — with the ordinary
  per-phase plan gate and a temporary phase blocker explicitly excluded, since every phase has both.
- **One contract-load rule, stated identically in all three layers.** 2.8.1 fixed only the contract's own
  header; the manual still said "load it when you write the files" and the skill "when you write **or
  amend** a file" — and flipping a checkbox is an amendment, so the 240-line contract still rode along on
  routine work. All three now name the same five triggers and exclude cold resume and content updates.
- **`LOG.md`'s third field is `context`, not `phase`.** *Create an effort* appends the first log line
  before any phase exists, so the format demanded a value the effort didn't have yet — likewise for
  effort-level blockers, reopening, and close-out. `context` takes a phase ID when one is in flight and
  `effort` or `close-out` otherwise. Backward compatible: a phase ID is a valid context, so entries
  written under 2.6–2.8.1 stay correct and no schema bump is needed.
- **Archiving a closed row rewrites its link.** Moving a row from `INDEX.md` into `archive/closed-YYYY.md`
  puts it one directory deeper, so `effort/SUMMARY.md` must become `../effort/SUMMARY.md` — a literal move
  left a broken link. The year file and month heading come from the effort's close date. Reopening now
  removes the closed row from **whichever** surface holds it, including the archive, instead of assuming
  `Recently closed`. `Recently closed` and `Recently triaged` are both stated to run **newest first**, so
  "drop the oldest" names an unambiguous row.
- **Guidance comments no longer collide with the placeholder rule.** The contract required every
  `{placeholder}` be replaced *and* that guidance comments be kept — but those comments contained
  placeholders, so a correctly finished file failed its own validation. `{…}` is now reserved for fill
  slots, a retained comment must carry none, and `finding.template.md`'s source-selection block (which
  necessarily leaves two unused forms behind) says to delete itself once a form is chosen.

### Added

- **`[~]` is not proof its gate was passed.** The marker covers both "awaiting approval" and "approved,
  building," so after a compaction an agent could resume and build straight through the §2.4 plan gate.
  Resume now says: if neither this session nor `LOG.md` records the approval, re-present the plan and
  wait. *Start a phase* records the approval in its next log line so a later session can find it.

### Changed

- **README accuracy pass.** "Anything beyond a one-liner" → the manual's §0 ceremony test (a one-line
  schema change can be non-trivial). "If one disagrees, the roadmap wins" → correct the derived file from
  whichever file owns that fact (the phase file owns the active plan, not the roadmap). "Status is one set
  of markers" now distinguishes the phase marker surface from effort status in frontmatter. "Commit this
  folder" is qualified for `local-only` mode, where `ai-progress/` is excluded alongside `ai-kit/`.

## [2.8.1] — 2026-08-19

> **`aikit-project-profile-sync`'s health check told the truth about the wrong things.** A skills audit
> after 2.8.0 found that two of its checks now misfire against the `ai-progress/v2` file layout — one
> producing 17 false failures, the other silently resolving references to the wrong section. Both are
> corrections to existing check definitions; no structure changes.

### Fixed

- **The internal-link health check no longer flags copy-me scaffolds.** It required every relative link
  inside `ai-kit/` to resolve from where the file sits — but template links are written for the **copy
  destination**, so they can't. 2.6.0–2.8.0 grew `aikit-plan/assets/` from nothing to seven templates,
  taking the check from 3 unresolved links to **20**, all false. That collided with the skill's own
  contract rule 5 (*"never suppress a failed health check"*): an agent was obliged to report 20 broken
  links, and "fixing" any of them would have broken the template. The check now excludes `templates/`,
  any skill's `assets/*.template.md`, and `_SKILL-TEMPLATE.md` — the same exclusion the kit's own
  maintenance link check has always carried, and it now says why.
- **`§N` cross-references have one stated convention.** A **bare** `§N` means a section of
  `AGENT-INSTRUCTIONS.md`; one **qualified by its document** (`contract §11`, `findings workflow §9`)
  means that document's own section. `SKILL.md` already wrote it that way; `progress-contract.md` did not,
  leaving five bare self-references. Four resolved to a real but *wrong* manual section — `§5` to
  Decision-making instead of the contract's Status model, `§7` to Before-completing instead of File
  contracts, `§8` (twice) to Anti-patterns instead of `INDEX.md` — which fails silently rather than
  loudly. The fifth, `§11`, pointed at a manual section that doesn't exist. All five are now qualified,
  as is the one bare `§10` in `SKILL.md`, and the sync check states the rule it applies.

### Notes

- Verified clean in the same audit and unchanged here: `aikit-update-kit` (its "replace every
  `skills/aikit-*/`" step already carries the new `references/` and `assets/` subfolders, and its
  never-migrate-`ai-progress/` note covers the schema question), `aikit-switch-visibility` (path-level
  only — the v2 restructure is invisible to it), skills and templates index↔folder parity, and the new
  **Progress artifacts** knob's pickup by sync's marker inventory.
- Deliberately not changed: `aikit-switch-visibility` says nothing about the Progress-artifacts policy
  when it stages `ai-progress/`. `.gitignore` enforces that policy and `git add` respects it, so there is
  no live defect to fix.

## [2.8.0] — 2026-08-19

> **Correction release for the `ai-progress/v2` refactor.** An external validation pass against 2.6.0 +
> 2.7.0 found twelve places where two surfaces disagreed — the contract said one thing, a template or a
> procedure another. No architecture changed: the layer split, the hot/cold read path, the uniform effort
> folder, and the findings ladder all stand. What changed is that the surfaces now agree.

### Changed

- **The progress contract no longer loads on an ordinary cold resume.** Its trigger said "creating,
  *resuming*, or closing" — pulling 233 lines of format detail into every resume and undoing one of the
  refactor's main reasons for existing. It now loads when **creating, structurally amending, validating,
  closing, or reopening**, and explicitly *not* on a resume unless a file's format proves broken.
- **§2.5's discovered-work HARD RULE gains a middle branch.** It read "work that serves this phase's goal
  → record it as a **new phase**," which was self-contradictory (work serving *this* phase becoming a
  *different* one) and fought the skill's own "update the plan before continuing." Now a three-way sort:
  inside the phase's goal *and* approved scope → **amend the phase plan**, re-presenting the gate when
  material; separately reviewable but serving this effort → **a new phase**; outside approved scope → the
  existing escalate-or-record test, unchanged. The child-effort test stays in §4.3 and the contract rather
  than being restated here. The anti-smuggling clause is untouched — amending a written plan isn't silent.
- **Roadmap sections are required, not conditional.** The contract demanded "all seven required sections"
  while its template guidance invited deleting an empty `Dependencies`. Now: all seven always present, an
  empty one reads `None.`, and `Child efforts` (epic-only) is the single deletable section.
- **`INDEX.md` gets exactly one legal annotation.** The contract banned "status commentary"; the template
  shipped `— {what it waits on}` on blocked rows. The mutable blocker note is gone (the roadmap owns it);
  a closed row's immutable `— done` / `— cancelled` stays and is now documented as the sole exception.
- **Cancelling an effort runs the same close-out as finishing one.** It previously skipped findings triage
  and the `Recently closed` overflow — a cancelled effort often carries the *most* worth retaining. It now
  reuses **Close as done**'s steps rather than restating them.
- **Reopening cleans up after itself.** It left `SUMMARY.md` in place on a now-active effort — which the
  contract says exists only for closed work, and which a later session could read as current truth. Reopen
  now deletes it (git history keeps the close-out) and normalizes the phase table to exactly one `[~]`
  (or `[!]`) before continuing.
- **The epic child-effort table drops its `Status` column** — the child's own frontmatter owns that, and a
  hand-maintained copy was a second status surface in a kit whose first hard rule forbids exactly that.
  It now records each child's *contribution*, which the parent is genuinely authoritative for.
- **`finding.template.md` supports all three origins** the workflow allows — during a phase, in an effort
  outside any phase, and outside any tracked effort — instead of assuming every finding has both. Its
  ambiguous `{id}-{slug}` placeholder (finding? source effort?) is now `{source-effort-folder}`,
  `{source-phase-file}`, and `{artifact-file}`. `Why it was out of scope` → **`Why it was deferred`**,
  which is true for a finding with no effort to be out of scope *of*; Observation / Why it was deferred /
  Why it matters are marked **required**. For evidence with no originating effort: link an approved
  location or stand up an investigation effort — never invent a global evidence directory.
- **`FINDINGS.template.md` no longer links the workflow.** It pointed at a bare
  `aikit-plan/references/…` path that resolves from nowhere inside `ai-progress/`, and any repaired
  version would have to assume the vendored folder's name and depth. A generated runtime file doesn't need
  its implementation contract — the always-loaded manual and skill discovery already route there.
- **`aikit-plan` is discoverable for findings work.** Its frontmatter `description` and *When to use*
  covered only efforts and phases, so "record this finding" could fail to select the skill that owns the
  ladder. Both now name capture, expand, triage, dismiss, and promote.
- **The skill's template rule covers all seven assets.** It claimed "every progress file starts as a copy"
  while listing five, silently excluding the two findings templates; `archive/closed-YYYY.md` is now named
  as the deliberate non-template exception. Contract §11's table gained the two missing rows.
- **Creating an effort no longer authors the first phase file twice** — *Create* wrote it and then handed
  off to *Start a phase*, which wrote it again. *Create* now simply defers to that procedure.
- **Cold resume tells the truth about queued efforts.** §4.4 said to open "the first `[ ]` you're about to
  start" — a file that by design doesn't exist until its gate. It now routes to *Start a phase*, which
  authors it.
- **`README.md`'s runtime tree shows `FINDINGS.md` and `findings/`**, which 2.7.0 added to the manual's
  tree but not the human-facing one.

### Notes

- Rejected from the same validation pass: **quoting YAML ids** (no parser consumes the frontmatter — the
  schema can state string semantics when one exists) and an **extra rung-3 fallback** (§5 already offers a
  tracker *or* a `queued` effort, gated on explicit acceptance). A **template smoke-test harness** stays
  deferred; the narrow failure it would have caught is now consistency-check #13 instead.
- `ai-progress/v2` is **unchanged** — no persisted file changes shape incompatibly, so nothing downstream
  needs migrating.

## [2.7.0] — 2026-08-18

> **Out-of-scope findings** get a home. An agent that notices invalid markup, a practice violation, or a
> missing test while doing something else now has a third option besides silently fixing it (scope creep)
> or silently dropping it (lost knowledge) — with an escalation path for discoveries that make the current
> delivery unsafe or wrong. Additive: projects that capture no findings gain no files.

### Added

- **`skills/aikit-plan/references/findings-workflow.md`** — the four-rung promotion ladder (**escalate →
  capture → expand → accept**), kinds and confidence, finding IDs, authority transitions, dismissal
  routing, and a validation checklist. Its own reference rather than part of the progress contract,
  because the load trigger differs: capturing or triaging a finding, not writing a progress file (and the
  contract had 25 lines of headroom).
- **Rung 0 — escalate instead of deferring.** The gap this closes: without it, an agent could park a
  security defect or correctness bug in the inbox, continue, and be technically compliant while shipping
  known-broken work. §2.5's existing discovered-work bullet is now a **HARD RULE** carrying the test —
  *would a reasonable reviewer, once informed, consider the planned delivery unsafe, incorrect, materially
  unverifiable, or inconsistent with its done criteria?* Yes or uncertain → stop-and-ask (§5.2) or
  block/re-scope (§4.3). It routes to the *existing* procedures rather than defining a parallel one, and
  states that "out of scope" is never a shield for knowingly shipping unsafe or incorrect work.
- **`ai-progress/FINDINGS.md`** (on demand) — a bounded, cold-path inbox of **candidates, not committed
  work**: all open findings, plus at most 10 `Recently triaged` dispositions. Not linked from `INDEX.md`,
  which stays an efforts-only router, and never in the cold-resume path.
- **`ai-progress/findings/{finding-id}.md`** (earned, not default) — rung-2 detail files with YAML
  frontmatter (`id`, `kind`, `confidence`, `created`) so `findings/` is greppable during triage.
  Deliberately no `status:` (the inbox sections own lifecycle — a second surface would drift) and no
  `schema:` (no legacy shape to discriminate).
- **Source-derived finding IDs** — `FND-{effort}-{phase}-{slug}`, phase segment optional
  (`FND-{effort}-{slug}`), date fallback outside any effort (`FND-{YYYYMMDD}-{slug}`). Provenance reads
  off the ID, so no `source:` field is needed. Never renamed once linked; collisions take a stable suffix.
- **Five kinds** (`defect · debt · risk · test-gap · docs`) with **orthogonal confidence** (`confirmed ·
  likely · suspected`). Accessibility and performance aren't separate kinds — a confirmed failure is a
  `defect`, a possible one a `risk`. Confidence carries the honesty rule: never present a preference or an
  unverified hypothesis as a confirmed defect.
- **Durable dismissals are promoted, ephemeral ones expire** — project-wide decisions to `PROJECT.md` →
  Locked decisions, effort-specific ones to that effort's `ROADMAP.md` → Locked decisions, the rest scroll
  out of `Recently triaged`. Prevents endless rediscovery without turning `PROJECT.md` into a dump of
  every rejected finding.
- **`assets/FINDINGS.template.md`** + **`assets/finding.template.md`** — inbox and detail scaffolds, named
  by the existing cardinality convention (UPPERCASE = one per scope, lowercase = many, as with `phase`).
- Close-out now **triages the effort's findings**: nothing meaningful may stay stranded in a completed
  phase file, a log line, or a closed roadmap.

### Changed

- §4 gained hard rule 9 (findings destination + cold-path behavior) and `FINDINGS.md` in its layout;
  §8 gained three anti-patterns — dropping an out-of-scope observation, parking an escalation-worthy
  finding in the inbox, and listing an untriaged finding as a `queued` effort.
- `progress-contract.md` §9a points at the findings workflow and fixes the boundary: a roadmap's
  `Deferred / follow-ups` may *link* a finding, never copy it.

## [2.6.0] — 2026-08-18

> **`ai-progress/v2`** — one uniform effort folder for tasks and epics alike, current state split from
> history, and the file format moved out of the always-loaded manual into a cold-loaded contract.
> Backward-compatible: existing progress files keep working and are **never migrated automatically**.

### Added

- **`skills/aikit-plan/references/progress-contract.md`** — the canonical **format** contract:
  frontmatter schema, naming, status consistency, per-file contracts, bounded `INDEX.md` rules, legacy
  compatibility, and a validation checklist. Loaded only when writing a progress file, which is what lets
  it be thorough without costing every session.
- **`skills/aikit-plan/assets/*.template.md`** — five copy-me progress files (`INDEX`, `ROADMAP`, `LOG`,
  `phase`, `SUMMARY`), co-located with the skill that consumes them per the Agent-Skills supporting-file
  pattern. The agent **copies** a template instead of retyping a skeleton, and each is normative for its
  section names and order. Consequences: the contract stays ~226 lines, only the one template being used
  is read, and check #10 skips them (their links target the copy destination, as with `templates/`).
- **One folder per effort** — `{id}-{slug}/` holding `ROADMAP.md` + `LOG.md` + `phases/` (+ `SUMMARY.md`,
  `artifacts/`, `scripts/` as needed). Tasks and epics now share **one shape**, so §4's rules no longer
  branch per shape, and an effort's files no longer straddle two locations.
- **`LOG.md`** — append-only history, split out of the roadmap. The roadmap grew unboundedly with session
  lines that §4.4's resume path never reads; bounded record (a phase's one-line outcome) stays in the
  spine, unbounded record moves out.
- **`SUMMARY.md`** — the close-out digest for a ticket or PR, written only when an effort closes. The kit
  previously had no outbound, human-facing artifact.
- **`artifacts/` + `scripts/`** — homes for generated evidence and effort-local helpers. §4.6's phase
  template already said "Artifacts produced" with nowhere to put them.
- **`Outcome` with explicit "Done when"** criteria, and **`cancelled`** as a first-class final status
  (with a summary explaining what was retained or reverted).
- **Child efforts** — an epic links children through `parent:` in their frontmatter while folders stay
  physically flat, capped at `epic → child effort`. Hierarchy without nesting, so no long paths and no
  broken links; §3.3-style criteria (independent gate, owner, blocker, PR, or summary) decide phase vs
  child.
- **`PROJECT.md` → Version control → "Progress artifacts"** (`fill:user`) — per-project retention/commit
  policy for generated output, since it can be large or hold client data. Wired through
  `aikit-project-profile-bootstrap` (7.7 ask-step, Verify item, frontmatter description);
  `aikit-project-profile-sync` picks it up for free, being marker-driven.
- **MAINTAINING:** a "Progress-tracking layers" section fixing which of the four surfaces owns what, plus
  consistency checks **#11** (one progress-schema value) and **#12** (legacy shapes appear only as
  compatibility notes).

### Changed

- **§4 shrank from ~160 to ~93 lines** and now holds only what an agent needs *before* invoking the
  skill — layout, hard rules, the cold-resume path, phase ordering. Procedures moved to
  `aikit-plan/SKILL.md`; the format moved to the contract. §4.6's inline templates are gone.
- **Effort folders are named from a stable external ID** (`PROJ-142-checkout-rebuild/`), or the creation
  date when there is none — never a repo-global `01-`/`02-` counter, which parallel branches allocate
  identically and collide on merge. Folders are never renamed.
- **Hot/cold reading is now explicit.** Resume reads `INDEX.md` → one `ROADMAP.md` → one phase file;
  finished phases, `LOG.md`, `SUMMARY.md`, `artifacts/`, and `scripts/` stay cold. `INDEX.md` is a router
  (links grouped by state, ≤10 recently-closed rows, older ones archived), not a dashboard.
- **§4.2 rule 1 generalized** from "the roadmap is the spine" to **one authoritative location per fact**,
  naming `INDEX.md`/`SUMMARY.md` as derived views that lose to the roadmap. The single phase-status
  surface stays a HARD RULE, extended to forbid a status field in a phase file.
- **§2.3** no longer branches task-vs-effort; **§8** gained anti-patterns for duplicate status, loading
  cold files on resume, unbounded `INDEX.md`, unasked legacy migration, and pasting raw output into
  Markdown.
- **Consistency check #6 now walks `-maxdepth 4`** — at depth 3 a skill's co-located `references/` doc was
  invisible to the folder-map check (verified: 18 files seen vs 19 present).
- `aikit-update-kit` states explicitly that an upgrade **never migrates `ai-progress/`**.

### Compatibility

- Legacy shapes (`task-{slug}.md`, `{effort}-ROADMAP.md`, `{effort}/phase-NN-*.md`, or a roadmap with no
  `schema:`) stay valid and are resumed in place. **No automatic migration** — on kit update or otherwise;
  migrate only on explicit request. `INDEX.md` may link both formats meanwhile.
- New efforts carry `schema: ai-progress/v2`, an axis independent of the Kit version.

## [2.5.0] — 2026-08-17

> Runtime-wiring re-verification run (`maintenance/verify-runtime-wiring`) — every claimed root file,
> skills directory, alias, and symlink fact re-checked against the runtimes' current official docs.

### Added

- **Windsurf named as a supported runtime.** It ships the same `SKILL.md` standard and scans the
  `.agents/skills` alias the kit already recommends, so it needed no new mechanism — just a row in
  `AGENT-INIT.md`'s §1 runtime table (root file `AGENTS.md`, skills dir `.windsurf/skills`) and in the
  README's Setup step 3 table, plus a mention in the README intro list. Previously it fell under the
  generic "Other, has a skills dir" row.

### Changed

- **`.agents/skills` is now the single shared symlink for every non-Claude runtime.** Cursor's docs now
  list `.agents/skills` among its project skill locations, so all five named runtimes (Codex, Gemini
  CLI, Cursor, Copilot, Windsurf) accept the alias. `AGENT-INIT.md` §3 drops its separate
  `.cursor/skills` command — setup is two symlinks instead of three — and the README's step 3 lead-in
  now says a single symlink serves every tool in the table.

### Fixed

- **The symlink caveat named the wrong runtime set.** Both surfaces claimed *"only Codex documents
  symlink-following"*; Claude Code's skills docs now document it too ("A `<skill-name>` entry … can be a
  symlink to a directory elsewhere on disk"). Corrected in `AGENT-INIT.md` §3 and the README's step 3 —
  and both now add the caveat's real teeth: Claude Code documents it for a **single skill entry**, not
  for the whole folder the kit symlinks, which is why the confirm-they-resolve step still matters.
- **README Setup step 2 listed the legacy `.cursorrules`** while `AGENT-INIT.md` §1 already said
  `.cursor/rules` (Cursor's current form). The two surfaces now agree.

## [2.4.0] — 2026-07-03

### Added

- **New skill `aikit-switch-visibility` — flip the kit between `shared` and `local-only` safely.**
  The old three-line "Switching" note in `PROJECT.md` was incomplete: it missed the **skills
  symlinks** (a committed symlink into an excluded folder = broken for teammates), never said to
  update the Mode field itself, and had no warning that untracking a **pushed** kit deletes it from
  the remote for the whole team (§5.2 stop-and-ask). The skill owns the full both-directions
  procedure — real-state check first (trust git over the field), all four artifacts moved together
  (kit, `ai-progress/`, kit-only pointer, symlinks), the pushed-kit and shared-root-file warnings,
  the Mode-field update, and a `(runtime-only)` entries review when going shared. `PROJECT.md`'s
  note now routes there; skills index row + README folder map updated.

### Changed

- **The 2.3.0 runtime-server offer is Config-visibility-aware.** Kit `shared` → default to offering
  the tool-config add (creating the file if absent); kit `local-only` → default to the
  `(runtime-only)` tag, and touch the tracked (team-visible) tool config only after flagging the
  visibility mismatch and getting an explicit yes. Sync inherits via its "as bootstrap 4.5 does"
  reference.
- **Bootstrap step 12 excludes the skills symlinks too** for a local-only first adoption (they were
  missing from its exclude list — the same half-state bug the new skill fixes for switching), and
  routes later mode changes to `aikit-switch-visibility`.

## [2.3.0] — 2026-07-03

### Added

- **Bootstrap + sync now inventory the runtime's live MCP tool surface** (owner-requested). Tool
  config files (`.mcp.json` etc.) only capture project-scoped servers; ones wired at the user/global
  level were invisible to the Integrations detection. Bootstrap step 4.5 now also enumerates the
  servers the agent can actually reach in-session and asks the user — **one decision per server** —
  whether each belongs in the project profile. Accepted servers can be added to the project tool
  config (offered; the normal gate applies); ones documented without a config entry carry a
  **`(runtime-only)` tag**. The live surface is per-machine evidence, so sync **re-asks** tagged
  entries instead of validating them against config — no cross-machine drift churn. Contract rule 1
  gains the matching clause (user-stated answers are their own evidence, cited "user-confirmed") and
  the first anti-pattern names the exception; a Verify item guards the inventory-and-ask; sync's
  Integrations DRIFT bullet is extended to run the same inventory.

## [2.2.2] — 2026-07-02

Verification pass, final part: `AGENT-INIT.md`, the kit `README.md`, `reference/*`, and `templates/*`.
The whole reference layer and the templates guide verified clean — the findings were in the other
three files.

### Fixed

- **`templates/design-tool-skill.md` — the copied skill no longer silently fails discovery.** The
  template opens with an HTML comment above the YAML frontmatter and never said to remove it; copied
  verbatim (as the templates guide instructs), the frontmatter sat mid-file, which skill discovery
  silently skips. The comment now instructs its own deletion in the copy.
- **`AGENT-INIT.md` — runtime-table headers no longer collide with the `§N` convention.** They said
  `(§2)`/`(§3)` meaning AGENT-INIT's own steps, but kit-wide `§N` means a manual section; now
  "(step 2)"/"(step 3)".
- **Kit `README.md`:** "How to extend" pointed profile-filling at Setup step 3 (it's step 4 — step 3
  is skill discovery); Setup step 4's ask-list gained the 2.2.0 additions (version-control policy,
  locked decisions, config visibility, kit source); step 5's TODO check is scoped to the fill-in
  surfaces like bootstrap/sync (the full-kit sweep always showed scaffold `TODO`s and contradicted
  itself); the session prompt no longer pairs `CLAUDE.md` as the profile (it's the pointer); the
  title path reads `ai-kit/` (was `/ai-kit`).

## [2.2.1] — 2026-07-02

Skill-by-skill verification pass, part 5: `aikit-project-profile-sync` (plus a future-proofing touch
to bootstrap step 1 raised at review).

### Fixed

- **Sync's stray-TODO health check is scoped to the fill-in surfaces — and inventory-derived.** It
  grepped all of `ai-kit/`, so the manual's §0 prose `TODO`, `_SKILL-TEMPLATE`, and the `templates/`
  scaffolds reported false health failures on every run. It now sweeps exactly the files the step-1
  marker inventory lists (today `PROJECT.md` + `reference/*.md`) — a future marker-bearing surface
  joins automatically, and scaffold/prose `TODO`s stay out. Bootstrap step 1 carries the matching
  layering note.
- **Sync's DRIFT list covers the harvested-source fields.** Overview "What this project is" and the
  Glossary (managed since 2.2.0) — both `fill:auto · harvested instruction sources` — had no
  re-validation bullet, so a literal reader never re-checked them. New bullet: re-read the bootstrap
  step-2 sources and diff both.

## [2.2.0] — 2026-07-02

Skill-by-skill verification pass, part 4: `aikit-project-profile-bootstrap` — closing "the most-missed
one" (fields invisible to bootstrap) in the flagship skill itself. MINOR: bootstrap gains detect-or-ask
steps, and the Glossary comes under `fill:` management.

### Added

- **Bootstrap step 7.7 — the user-owned policies are now asked.** Version control (Branch / Commit /
  PR: three `fill:user` slots no step touched — they silently stayed `TODO` while governing §2.6
  behavior) and Locked decisions (step 2 harvested ADRs but nothing routed them to the slot). Hints
  are harvested first; the user sets the policy; candidates are proposed, never invented. Verify items
  added; the gate (step 9) now also surfaces the proposed Locked decisions.
- **The Glossary is a managed slot.** It held `TODO`s with no `fill:` marker (violating the
  every-managed-slot-tagged invariant) and no wiring; now tagged `fill:auto · harvested instruction
  sources`, filled from harvested domain terms in step 8 — or deleted if none apply (it's optional).

### Fixed

- **The TODO sweep is scoped to the fill-in surfaces.** Step 1 and Verify item 1 grepped all of
  `ai-kit/`, matching the manual's §0 prose mention of `TODO` — an eternal false "unresolved
  placeholder". Both now grep `ai-kit/PROJECT.md ai-kit/reference/` (mirroring consistency-check #5).
- Frontmatter `description` reflects the full coverage (version-control policy, locked decisions,
  glossary).

## [2.1.3] — 2026-07-02

Skill-by-skill verification pass, part 3: `aikit-update-kit`.

### Fixed

- **Step 3's kit-owned replace list was incomplete** — `AGENT-INIT.md` and the kit-shipped
  `templates/` scaffolds weren't listed, so a literal updater left the installer and shipped templates
  stale across every future version. Both are now in the list (project-authored scaffolds are
  untouched: they're not in the new snapshot).
- **The step 2 source re-ask is documented as deliberate.** Even with a configured "Kit source"
  override, the updater asks which source to use — by design (§2.2 notwithstanding): an update pulls
  outside content into the repo, so the user consciously confirms the source every time. The rationale
  now lives in the step so it can't be mistaken for an ask-discipline violation and "fixed" away.
- **Small precision fixes.** Step 1's §2.6 paraphrase matches the 2.1.0 rule text (gates, not
  forbids); step 7 no longer implies a mid-session handshake banner (the next session echoes the new
  version); the Verify deletion scan is split by visibility (shared: `git diff main`; local-only:
  `diff -r` against the backup).

## [2.1.2] — 2026-07-02

Skill-by-skill verification pass, part 2: `aikit-implement-from-design` (making the implicit explicit
for weaker models).

### Fixed

- **Verify now checks states + breakpoints.** Step 1 headlines capturing every state ("missing a
  state now means rework later"), but the closing checklist never verified them — a parity check
  against a static mockup passed with only the default view built. New Verify item: every captured
  state and responsive breakpoint implemented and exercised.
- **The per-phase gate is explicit.** Step 4's "flip each `aikit-plan` phase" now routes through that
  skill's Update steps — each phase gates at its start (§2.4) — instead of reading as bare
  status-flipping.
- **Recorded gaps are routed.** Step 2's token/component gaps now explicitly close first as step 3's
  foundations work, and a gap needing a new dependency or pattern is flagged as a §5.2 stop-and-ask
  (design work is exactly where uninvited libraries creep in).

## [2.1.1] — 2026-07-02

Skill-by-skill verification pass, part 1: `aikit-plan` (clarity for weaker models + portability).

### Fixed

- **`aikit-plan` — single-step tasks no longer slip the plan-review gate.** Create gains an explicit
  final step: present the plan and wait for the go (§2.4). Multi-phase efforts still gate per phase at
  Update; a single-step `task-{slug}.md` is gated on its inline plan — previously nothing in the
  skill's numbered steps paused before building.
- **`aikit-plan` — runtime-agnostic phrasing.** The runtime-specific `AskUserQuestion` tool name is
  gone (now: batch questions via the runtime's question tool if it has one, otherwise in chat), as is
  `/compact` in the skill description and manual §4 (now: "context compaction") — the kit's other
  target runtimes have neither.
- **`aikit-plan` — "When to use" no longer contradicts the procedure's order.** It said "before
  scoping work, create its progress files" while Create locks scope first (step 2) and writes the
  files after (steps 3–4).
- **`aikit-plan` — precise cites.** The session-end log-line rule now cites its owner (§4.2 rule 5,
  was §4.3); "before writing" → "before authoring the files" (files, not code).

## [2.1.0] — 2026-07-02

Composition pass on the manual — one broken pointer fixed, three internal tensions resolved, two
thin rules added. Aimed at keeping the manual unambiguous for weaker models as well as frontier ones.

### Fixed

- **§1.5 "Gate before building" pointed at §4.4** (resuming cold) instead of §2.4 (the gate) — the
  manual's most important pointer now lands on the right procedure.

### Added

- **§1.12 — precedence when layers conflict.** Explicit in-chat user instruction (this session) >
  `PROJECT.md` > the manual's defaults; HARD RULEs yield only to an explicit, per-instance user
  instruction — never to inference, silence, or a general preference.
- **§2.4 — unattended-gate rule.** No reviewer available (unattended / non-interactive run) → author
  the plan, mark the effort blocked at the gate, stop; never self-approve. An explicit user
  pre-authorization ("build without waiting for review") counts as the go. Matching §8 anti-pattern
  added.

### Changed

- **The progress folder name is now canonical.** §4.1 said "e.g. `ai-progress/`" while §0/§8 hardcode
  `ai-progress/INDEX.md`; the "e.g." is gone and the reason (the §0 session-start check relies on the
  exact path) is stated in place.
- **Progress-file commits ride the §2.6 commit gate.** §1.4/§4's "write it down, commit it" no longer
  collides with "commit only when asked" — §4 now says plan commits follow §2.6, and `PROJECT.md`'s
  Version-control policy may pre-authorize them.
- **HARD RULE markers added** where the rules were already counted as such: §1.11 (secrets) and the
  §2.4 plan gate.
- **§2.6 default-branch rule aligned with §1.12 precedence:** "never commit to the main/default
  branch" now yields to an explicit `PROJECT.md` Version-control policy.
- **§0 handshake fallback paragraph reformatted to bullets** — scanability only, no semantic change.

## [2.0.0] — 2026-07-01

### Changed

- **BREAKING — the kit folder is renamed `AI/` → `ai-kit/`.** The vendored folder now carries a
  distinctive name so it can't collide with a host repo's own `AI/` directory — the same
  collision-avoidance rationale behind the `aikit-` skill prefix, applied at the directory level. The
  folder is self-documenting and mirrors the repo name (`ai-starter-kit`). Nothing about the kit's
  contents or `§N` structure changed; only the mount point moved. The product is still called **"the AI
  kit"** — only the folder name changed.

  **Migration for a project already on a 1.x kit** (fastest path: re-run
  [`AGENT-INIT.md`](ai-kit/AGENT-INIT.md) from the repo root, which re-derives all of this; or do it
  manually):
  1. Rename the vendored folder: `git mv AI ai-kit` (or a plain rename if it's untracked/local-only).
  2. Re-point the **root pointer** file (`CLAUDE.md` / `AGENTS.md` / `.cursorrules` / …): the
     `read AI/AGENT-INSTRUCTIONS.md` line becomes `read ai-kit/AGENT-INSTRUCTIONS.md`.
  3. Re-point the **skill symlinks**: `.claude/skills` (and any `.agents/skills` / `.cursor/skills`)
     now link to `../ai-kit/skills`.
  4. **Local-only** installs: swap the `AI/` entries in `.git/info/exclude` for `ai-kit/`.

## [1.8.0] — 2026-07-01

### Added

- **`AGENT-INIT.md` — one-command, agent-driven kit setup.** A new agent-facing installer at the top of
  `ai-kit/`: point any agent at it on first adoption and it identifies its runtime, wires the root pointer
  (Setup step 2) and the skills symlink (step 3), then tells the user to reload and run
  `aikit-project-profile-bootstrap`. README §Setup gains a "Fastest path" pointer to it; the manual
  steps remain the fallback and the human explanation of what it wires.
- **Explicit multi-runtime skill-discovery wiring.** README step 3 and `AGENT-INIT.md` now name Codex
  (`.agents/skills`), Gemini CLI (`.gemini/skills` / `.agents/skills`), Cursor (`.cursor/skills`), and
  GitHub Copilot (`.github/skills` / `.agents/skills`) alongside Claude Code — all share the same
  `SKILL.md` Agent-Skills standard the kit ships. `.agents/skills` is called out as a shared alias
  several accept, and the docs flag that only Codex documents symlink-following (verify, else fall back).

## [1.7.1] — 2026-07-01

### Changed

- **Canonical-home URL hoisted to a prominent callout in `aikit-update-kit`.** The kit's default update
  source now sits in a labeled **Canonical home** line directly under the skill's title (with a
  "forking? change this one line" cue), instead of being buried in Procedure step 2. Step 2 now
  references it, so the URL stays single-sourced within the file. No behavior change — per-project
  overrides still live in `PROJECT.md` → "Kit source".

## [1.7.0] — 2026-07-01

### Added

- **Configurable update source with a baked-in default.** `aikit-update-kit` now names the kit's
  canonical home (<https://github.com/jacekkoziol/ai-starter-kit>) as the built-in default, so updates
  run from it automatically. A new `PROJECT.md` "Kit source" field (`fill:user`, default `default`) lets
  a project override it with a fork, mirror, or local path. At update time the skill uses the canonical
  home automatically, **asks which** when an override is set, and asks the user outright if neither
  resolves (unchanged fallback). Bootstrap step 12 now also confirms the field, guarded by a Verify item.

## [1.6.0] — 2026-07-01

### Added

- **Config visibility: shared or local-only.** A project can now keep the `ai-kit/` kit on its machine
  without pushing it. New `PROJECT.md` "Config visibility" field (`fill:user`, default `shared`) records
  the choice plus the reverse steps. `aikit-project-profile-bootstrap` gains a step that asks it and,
  for **local-only**, adds `ai-kit/` / `ai-progress/` / the kit-only root pointer to `.git/info/exclude`
  (the per-clone ignore that's never committed; effective only while untracked), guarded by a Verify
  item. README Setup step 6 notes the option.

### Changed

- **`aikit-update-kit` is now config-visibility-aware.** The v1.4.1 "branch off clean `main`" snapshot
  only protects a *tracked* kit; a local-only kit is **untracked**, which git branches/`main` don't
  capture. The snapshot + review steps now branch on visibility: tracked → branch off `main` / review
  the git diff; local-only → physical `cp -r ai-kit ai-kit.bak` outside the repo / review with `diff -r`, then
  delete the copy. Added a matching anti-pattern.

## [1.5.0] — 2026-07-01

### Added

- **Accessibility (WCAG 2.2 / ARIA) as project-layer guidance** — kept out of the stack-agnostic
  manual and skills because it's web-specific. Two additions: (1) `PROJECT.md` "Project-specific rules"
  now lists `"all UI meets WCAG 2.2 AA + ARIA APG"` among its example house rules; (2)
  `aikit-project-profile-bootstrap` now **proposes** an accessibility rule — conform to WCAG 2.2 level
  AA and follow the ARIA Authoring Practices ([APG](https://www.w3.org/WAI/ARIA/apg/patterns/)) — when
  it detects a UI-producing stack (silent for backend/CLI/infra), guarded by a Verify item. Detail can
  grow into a project-authored `reference/accessibility.md`.

## [1.4.2] — 2026-07-01

### Changed

- **README Setup step 2 now recommends an `AGENTS.md`-first root pointer.** For a project with no agent
  config yet, prefer `AGENTS.md` (the emerging cross-tool standard most agents read) as the canonical
  root file, and symlink `CLAUDE.md → AGENTS.md` for Claude Code so every tool loads one maintained
  source. The multi-tool paragraph now references that canonical file instead of repeating the symlink
  command (single-source).

## [1.4.1] — 2026-07-01

### Changed

- **Hardened `aikit-update-kit` against accidental deletion of project data.** Four additions: (1) run
  the update on a **branch off clean `main`** so `main` is a zero-cost restore point and *not merging =
  instant rollback* (no physical `ai-kit.bak/` copy needed); (2) an explicit **"never delete project-owned
  content" inventory** at the top of the procedure — filled `PROJECT.md`/`reference`, project-authored
  skills + co-located resources, project reference docs + templates, README project-rows, and
  `ai-progress/` (out of scope) — closing the gap where templates and project skills were only
  implicitly preserved; (3) a **path-by-path replace rule** forbidding wholesale directory wipes
  (`rm -rf` / `rsync --delete` of `skills/`/`reference/`/`templates/`) and overwriting a
  project-authored path with a new kit file (stop and ask), plus two matching anti-patterns; (4) a
  **post-update "nothing project-owned vanished" check** + a diff-scan-for-deletions step before commit.

## [1.4.0] — 2026-07-01

### Added

- **Default project rule: Conventional Commits.** `PROJECT.md` "Project-specific rules" now ships with
  "Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for all commit messages"
  as an active default the agent follows once the kit is loaded. It's a normal user-owned rule entry —
  a downstream project can edit or remove it, and `aikit-project-profile-bootstrap` leaves it untouched
  (real content, not a `TODO`).

## [1.3.0] — 2026-07-01

### Added

- **`PROJECT.md` "Project-specific rules" section** — a `fill:user` catch-all home for free-form house
  rules that don't fit the structured sections (e.g. "feature-flag all new UI", "run the formatter
  before every commit"). Because it lives in `PROJECT.md`, it's loaded via the manual's session-start
  read-pointer and preserved by `aikit-update-kit`, so project instructions survive kit updates. Wired
  into `aikit-project-profile-bootstrap` (new harvest step 7.5 + Verify item + frontmatter description).
- **Capture directive in the manual header** — it now lists "project-specific rules" among what
  `PROJECT.md` holds and instructs the agent to **record durable, project-wide rules/preferences in
  `PROJECT.md`** so they persist across sessions. The positive counterpart to the §8 guardrail — it's
  what makes the new section actually get populated instead of sitting empty.

### Changed

- **Guardrail against losing project rules on update.** Added an §8 anti-pattern (project-specific
  rules belong in `PROJECT.md` / `reference/`, not the portable manual) and a caveat in the README
  "How to extend → Tune the rules" note, which previously invited manual edits without flagging that
  `aikit-update-kit` overwrites them.

## [1.2.5] — 2026-07-01

### Changed

- **Made the §2.6 commit gate explicit.** The Phase F hand-off step now tells the agent to **offer** —
  "commit now, or review the diff first?" — and act only on the answer (silence isn't approval) when
  neither the user's ask nor `PROJECT.md`'s Version-control policy has pre-authorized the commit; added
  the matching §8 anti-pattern. Previously §2.6 said only "commit only when the user asks", without the
  proactive review-first offer or the silence-isn't-approval loophole close.

## [1.2.4] — 2026-07-01

### Fixed

- **`aikit-update-kit` no longer clobbers a project's custom README index rows.** Step 3 previously
  listed the `skills/` / `reference/` / `templates/` layer-guide `README.md`s as "safe to overwrite",
  which would delete the `## Index` rows (and curated descriptions) a downstream project adds for its
  own skills/docs/templates. Those three READMEs are now removed from the blanket-overwrite list and get
  a dedicated reconcile step: take the new version's prose + kit rows, then carry over every project row
  unchanged (a row is project-authored when the new snapshot doesn't ship its target; for skills, the
  missing `aikit-` prefix is the tell). Added a matching Verify item and anti-pattern.
- **`aikit-project-profile-sync` now checks `templates` index↔folder parity** too (previously `skills` +
  `reference` only), completing the backstop that catches any index row lost during an update.

## [1.2.3] — 2026-07-01

### Changed

- **Documented per-skill resource bundling** in `skills/README.md` "Format & discovery". The open
  Agent Skills format lets a skill folder carry its own `scripts/` / `references/` / `assets/`
  (referenced one level deep, loaded on demand); the kit's guidance previously described only the
  shared top-level `reference/`. Added the shared-vs-skill-local rule: co-locate a resource owned by
  one skill; keep shared project facts in top-level `reference/` (only those get an index row, a
  `fill:` marker, and `aikit-project-profile-sync` re-validation). Docs-only — no structural change.

## [1.2.2] — 2026-07-01

### Changed

- **Aligned skill-authoring guidance with the open [Agent Skills](https://agentskills.io) spec** —
  no structural change; the kit's folder-per-skill + `SKILL.md` layout was already fully conformant.
  Two point-of-use clarifications: `skills/_SKILL-TEMPLATE.md` now states the runtime's `name`
  constraints (lowercase alphanumerics + hyphens, no leading/trailing/doubled hyphen, ≤64 chars — a
  name that breaks this is silently skipped at discovery), closing a gap where an author could pick an
  invalid name; and `skills/README.md` "Format & discovery" now names the open standard and notes the
  format is portable across the many agents that support it.

## [1.2.1] — 2026-06-30

### Changed

- **Hardened skill-authoring at point-of-use** (`skills/_SKILL-TEMPLATE.md` + `skills/README.md`),
  rather than adding a meta-skill for creating skills (the template + README already carry the
  procedure — a skill would duplicate it and add weight). Closed the two gaps that made the template
  passive: the header note now tells the author to **scan the index first and extend an existing skill
  rather than add a near-duplicate**, and to **set the frontmatter `name:` to the folder name** (the
  folder name *is* the invocable command). The reuse-before-building rule is owned by README "When to
  add one"; the template references it. Pure clarification of existing surfaces — no new artifact.

## [1.2.0] — 2026-06-30

### Added

- **Skill-discovery setup.** New `README.md` adoption step 3, "Wire skill discovery" — makes the kit's
  skills invocable in the host runtime (which auto-discovers skills only from its own dir, not
  `ai-kit/skills/`). Recommends a single whole-folder Claude Code symlink (`.claude/skills` → `ai-kit/skills`),
  so every skill under `ai-kit/skills/` — shipped `aikit-*` and project-authored alike — and any added
  later resolves with no re-linking; includes a guard against clobbering an existing `.claude/skills/`
  and a per-skill fallback for that case. Generic guidance for other runtimes (link the dir, or invoke
  a skill by `SKILL.md` path where there's no skill mechanism).
- **`aikit-project-profile-bootstrap`** now wires skill discovery on first adoption (step 11 + a Verify
  item), deferring the concrete command to README step 3 (single source).
- **Documented the `aikit-` prefix rationale in the vendored kit** (`skills/README.md` → "Naming") — why
  kit skills are prefixed (collision-avoidance) and why they must not be renamed (the command name is the
  folder name; updates reconcile by the prefix). Previously this lived only in the home-only
  `MAINTAINING.md`, invisible downstream where renaming is most tempting. `aikit-update-kit` gains a
  matching anti-pattern, since a kit update is where the rename risk is highest.

### Changed

- `README.md` Setup renumbered to **six** steps (skill discovery inserted as step 3; profile-fill →
  step 4, confirm → step 5 with a "skills resolve" check, commit → step 6 incl. committing the symlinks).
  Corrected step 4's note: the `/aikit-*` command exists once skills are wired (step 3), not merely once
  the pointer is wired.

## [1.1.1] — 2026-06-30

### Fixed

- **Stale handshake example in `README.md`:** the human-facing "your check" banner still read
  `✅ AI kit loaded — …`; updated to `✅ AI kit v{version} loaded — …` to match the canonical §0 form
  (the versioning added in 1.0.0 changed the banner but this copy wasn't updated). Kept `v{version}`
  generic so the manual header stays the single source for the actual number.
- **Single-source drift in `aikit-implement-from-design`:** procedure step 2 restated the §3
  reuse/extend/build-new ladder instead of pointing at it — contradicting the skill's own promise to
  reference, not restate. Replaced with a pointer to "the §3 reuse ladder," keeping the design-specific
  guidance (tokens, no hardcoded hex/px, gap-recording).

_Both found via a deep adversarial prose/skill-internal audit of the 1.1.0 tree._

## [1.1.0] — 2026-06-30

### Added

- **Skill `aikit-implement-from-design`** — tool-agnostic procedure for translating a visual design
  source (mockup, screenshot, exported spec, design-tool reference) into code: extract decisions →
  reuse existing tokens/components (§3) → structure-before-style (§4.5) → verify parity (§7). Names no
  vendor; references the manual rather than restating it.
- **Skill `aikit-update-kit`** — downstream procedure to upgrade a vendored `ai-kit/` kit to a newer
  version, replacing methodology files while preserving the filled `PROJECT.md` + `reference/*.md`,
  then running `aikit-project-profile-sync`. Completes the versioning story (the consumer side).
- **Template `templates/design-tool-skill.md`** — generic scaffold for a downstream, project-authored
  skill that wires one specific design tool (Figma as a `<!-- To Remove -->` worked example) to
  `aikit-implement-from-design`. Tool-specific terms stay downstream; the kit stays vendor-neutral.

### Changed

- **Consistency-check #5** (`MAINTAINING.md`, home-only): widened the exclusion to cover `templates/`,
  since templates legitimately carry `TODO`/`{placeholder}` scaffolding.

## [1.0.1] — 2026-06-30

### Fixed

- **Portability:** removed the WordPress-specific filename `wp-config.php` from `AGENT-INSTRUCTIONS.md`
  §1 rule 11 (secrets) — a concrete stack/vendor term that should never appear in the portable manual.
  Replaced with a stack-agnostic illustration ("any stack's local config").

### Changed

- **Consistency-check #1** (`MAINTAINING.md`, home-only): added `wp-config` to the portability
  wordlist alongside its sibling `wp-content`, which had let the leak above slip past the automated grep.

## [1.0.0] — 2026-06-30

First versioned release — the baseline of the kit as it stands.

### Added

- **Portable manual** `AGENT-INSTRUCTIONS.md` (§0–§9): the understand → clarify → plan → gate → build
  → verify loop, operating principles, reuse rule, decision ladder, planning & progress tracking
  (`ai-progress/`), coding standards, completion checklist, anti-patterns, and response-economy modes.
- **Per-project profile** `PROJECT.md` + `reference/` (coding conventions, decision ladders, file
  locations) with the `fill:` marker convention (`fill:user` / `fill:auto · «source»`).
- **Skills:** `aikit-plan` (stand up / maintain `ai-progress/`), `aikit-project-profile-bootstrap`
  (first fill from the repo), `aikit-project-profile-sync` (health-check + drift correction).
- **Templates** scaffold + per-folder index/README files.
- **Versioning:** introduced this release — the Kit version header, the version in the session-start
  handshake, this changelog, and the bump discipline in `MAINTAINING.md`.
