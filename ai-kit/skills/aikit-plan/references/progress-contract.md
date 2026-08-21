# Progress contract — `ai-progress/v2`

> The **persisted-file format** for progress tracking: layout, naming, frontmatter, the status model,
> per-file contracts, and the templates to copy. Load this when **creating, structurally amending,
> validating, closing, or reopening** an effort — **not** on an ordinary cold resume (§4.4 reads three
> files and needs none of this), unless a file's format proves missing, invalid, or unclear.
>
> **Layer split.** [`AGENT-INSTRUCTIONS.md`](../../../AGENT-INSTRUCTIONS.md) §4 owns the always-loaded
> behavior (when to track, the read path, the single-status-surface rule). [`SKILL.md`](../SKILL.md) owns
> the **procedures** (create, start/finish a phase, block, re-scope, close). This file owns the
> **format** — and restates neither. Project-specific artifact retention comes from
> [`PROJECT.md`](../../../PROJECT.md) → Version control.

## 1. Model

**Effort** — one goal with one lifecycle. `kind: task` (a delivery goal) or `kind: epic` (a
coordination goal linking child efforts). **Tasks and epics use the same folder shape.**

**Phase** — an ordered, reviewable part of one effort: same owner, same lifecycle, contributing to the
same outcome. It uses the effort's lifecycle and the **standard per-phase plan gate** (§2.4), and needs no
*independent* acceptance gate, pull request, release, or close-out summary.

**Child effort** — its own effort folder with `parent:` set. Create one *instead of* another phase when the
work needs an **independent lifecycle**: its own owner, its own acceptance gate, its own blocked/cancelled
state, its own pull request or release, or its own `SUMMARY.md`. The ordinary per-phase plan gate and a
temporary phase blocker don't qualify — every phase has both.

Effort folders stay **physically flat** under `ai-progress/`. Hierarchy is expressed only through
`parent:`, at most two semantic levels (`epic → child effort`). Never nest effort folders.

## 2. Layout

The folder tree is in §4.1 of the manual; what it doesn't say is **when** each path comes into being:

| Path | When to create |
| --- | --- |
| `INDEX.md` | With the first tracked effort. |
| `ROADMAP.md` · `LOG.md` · `phases/` | Always, for every tracked effort. |
| A phase file | Only when that phase reaches its review gate. |
| `SUMMARY.md` | Only when the effort becomes `done` or `cancelled`. |
| `artifacts/` · `scripts/` | On demand. |
| `archive/closed-YYYY.md` | When `Recently closed` exceeds 10 entries. |

**Never create** `PLAN.md`, `reports/`, or `utils/` inside an effort: `ROADMAP.md` is the plan spine,
reports are one kind of artifact, and executable helpers belong in `scripts/`.

## 3. Naming

**Effort folder** — prefer a stable external identifier: `PROJ-142-checkout-rebuild/`,
`GH-381-api-rate-limits/`, `EPIC-12-platform-modernization/`. With no stable ID, use the creation date:
`20260818-checkout-rebuild/`. **Never use repository-global sequential prefixes** (`01-`, `02-`) —
parallel branches allocate the same number and collide on merge. **Never rename an effort folder after
creation** (it breaks every existing link) — the pre-merge collision repair below is the sole exception.

**Effort IDs are unique within `ai-progress/`.** An external identifier is used as-is (`id: PROJ-142`);
without one, the ID is the **whole folder name** — date *and* slug (`id: 20260818-checkout-rebuild`). A
bare date isn't unique, and `id:` travels without its folder: `parent:` names a parent by ID alone and a
finding ID embeds it (`FND-{effort-id}-…`), so two same-day efforts would be indistinguishable in both.
Before creating an effort, confirm no existing `ROADMAP.md` carries that `id:`. Date-only IDs written
under earlier kit versions stay valid — never rewrite one. Two *existing* efforts sharing one date-only ID
is an **ambiguous** state, not a valid one: surface it and ask, because `parent:` and finding references
may resolve to either. Never guess which, and never rewrite them unasked.

**Colliding date fallbacks.** A date fallback narrows the sequential-prefix collision window but doesn't
close it: two branches can create the same `{date}-{slug}` independently — same day, same goal, same
obvious slug — and neither branch's `INDEX.md` can see the other, so git surfaces it as an **add/add
conflict at merge**, not at creation. Resolve by intent:

- **Same goal** (the common case) — consolidate into one effort. Keep the earlier folder and **reconcile**
  the two roadmaps into one valid phase sequence rather than concatenating their tables: preserve
  completed outcomes, resolve duplicate phase IDs with the `phase-NNa` suffix rule, leave at most one
  phase in flight (contract §5), interleave both `LOG.md` histories by date, keep every non-duplicate
  artifact and script, then re-run contract §10. Concatenating produces duplicate phase IDs, two `[~]`
  rows, and two versions of one plan — each an invariant violation.
- **Genuinely different goals** — suffix the later folder (`20260818-checkout-rebuild-a/`) and update its
  `id:`, its `INDEX.md` row, every inbound link, and **every child effort whose `parent:` names the old
  ID** — `parent:` is a field, not a link, so no link check catches it. **Re-key its findings too:** an ID
  embedding the old effort ID would otherwise name the *surviving* effort — the one it never came from — so
  `FND-20260818-checkout-rebuild-P01-…` becomes `FND-20260818-checkout-rebuild-a-P01-…`, with its inbox
  entry, detail filename, `Source` link, and inbound references updated. This repair is the sole exception
  to never renaming a linked finding ID ([findings workflow §8](findings-workflow.md)).

Consolidation can also surface **duplicate finding IDs** — both branches minting `FND-{same-effort-id}-…`
under the kept effort. Same observation: consolidate to one finding. Different observations: a true
finding-ID collision rather than a rename, so suffix the later one (findings workflow §8) and update its
inbox pointer, detail filename, and inbound references.

Do all of this before the merge lands. Renaming afterwards breaks links that have already been published.

**Slugs** — lowercase ASCII kebab-case, concise and specific (`checkout-rebuild`, `auth-migration`).
Avoid `fix`, `changes`, `update`, `misc`.

**Phase files** — zero-padded and local to the effort: `phase-01-discovery.md`,
`phase-02-domain-model.md`. Inserting work between referenced phases **never renumbers**; use a stable
suffix: `phase-03a-security-review.md`.

**Artifacts and scripts** — prefix with the producing phase where practical:
`artifacts/p02-api-contract-before.json`, `scripts/p02-compare-api-contracts.py`.

## 4. Frontmatter

`ROADMAP.md` opens with exactly these keys:

```yaml
---
schema: ai-progress/v2
id: PROJ-142
kind: task            # task | epic
status: active        # queued | active | blocked | done | cancelled
parent: null          # null, or a stable parent effort ID
created: 2026-08-18
---
```

**No `updated:` field.** The latest `LOG.md` entry and the git history already carry change timing; a
hand-maintained second timestamp rots silently.

**Schema version.** `ai-progress/v2` is an independent axis from the Kit version — it advances only when
the persisted data contract changes incompatibly, not with every kit release.

## 5. Status

**Phase tokens** (in the roadmap phase table): `[ ]` not started · `[~]` active, including its review
gate · `[!]` blocked · `[x]` complete.

**Effort status** (frontmatter) and phase status describe different levels; both stay, with these
consistency expectations:

| Effort status | Expected phase table |
| --- | --- |
| `queued` | No `[~]` or `[!]`; incomplete phases remain. |
| `active` | Normally exactly one `[~]`. |
| `blocked` | One `[!]`, or an effort-level blocker in the roadmap's `Dependencies` and no `[!]` row. |
| `done` | Every required phase `[x]`. |
| `cancelled` | Any accurate distribution; the reason is explained in `SUMMARY.md`. |

A completed phase row **replaces its planned target with a concise actual outcome** — that one line is
what lets a later session skip the finished phase file. Future rows read `Not authored yet` until their
gate.

### 5.1 Legal transitions

Every status change is one of these; the destination's phase table must match §5 above.

| From | To | Trigger |
| --- | --- | --- |
| — | `queued` · `active` | Create an effort — `active` only if its first phase starts immediately |
| `queued` | `active` | Start a phase |
| `queued` | `blocked` | Blocked before the first phase — effort-level, no `[!]` row |
| `queued` | `cancelled` | Abandoned before any work |
| `active` | `blocked` | Blocked — phase-level `[!]`, or effort-level with no `[!]` |
| `active` | `done` · `cancelled` | Close |
| `blocked` | `active` | Blocker cleared, with a phase to resume or start |
| `blocked` | `queued` | Effort-level blocker cleared, no phase started yet |
| `blocked` | `cancelled` | Closed while blocked |
| `done` · `cancelled` | `active` · `blocked` | Reopen — a still-standing blocker returns at its original level |

**No other transition is legal**, and a new status means new rows here. A state that can be entered but not
left — or left but not entered — is exactly the defect this table exists to surface.

## 6. Source of truth

| Information | Authoritative location |
| --- | --- |
| ID, kind, status, parent, creation date | `ROADMAP.md` frontmatter |
| Goal, done criteria, scope, decisions, dependencies | `ROADMAP.md` |
| Phase status + one-line phase outcome | Phase table in `ROADMAP.md` |
| Detailed phase plan and verification | That phase's file |
| Chronological history | `LOG.md` |
| Global routing | `INDEX.md` — derived projection |
| Ticket / pull-request / handoff digest | `SUMMARY.md` — derived close-out |
| Generated evidence and data | `artifacts/` |
| Effort-local executable helpers | `scripts/` |

**Single phase-status surface (HARD RULE).** Phase status lives *only* in the roadmap phase table.
Never add a status field to a phase file.

**Derived files never win.** `INDEX.md` and `SUMMARY.md` are projections. When either disagrees with an
authoritative file, correct the derived file — and never introduce new scope or status that exists only
in a summary.

**Raw output never goes in Markdown.** Command output, stack traces, full diffs, and generated datasets
go to `artifacts/` and are linked, not pasted into a roadmap, log, or summary.

## 7. File contracts

**The templates (contract §11) are normative for section names and order** — every heading they carry is required,
and nothing here repeats that list. What follows is the rules a template can't express.

**`ROADMAP.md`** — `Outcome` carries both a **Goal** and explicit **Done when** criteria. The seven
sections are **always present**; one with no entries reads `None.` rather than being deleted, so the shape
is predictable without conditional interpretation. `Child efforts` is the **only** optional section — epics
add it, tasks don't. No detailed checklists, no session history. Absolute `YYYY-MM-DD` dates only. A
roadmap much past ~150 lines usually holds leaked phase detail or wants child efforts.

**Phase file** — links back to `ROADMAP.md`, carries no status field, uses checkboxes for plan and
verification items, and is authored at its gate — never pre-written for future phases. Split a phase
running much past ~250 lines.

**`LOG.md`** — exists for every effort, including one-session work. Append one line per working session
or meaningful checkpoint:

```text
- YYYY-MM-DD | actor | context | Done: … | Verified: … | Next: … | Blockers: …
```

**`context`** is the phase ID when one is in flight (`P02`, `P03a`), and otherwise what the entry is about
— `effort` (creation, scoping, an effort-level blocker) or `close-out`. It was named `phase` in earlier
kit versions; existing entries stay valid, since a phase ID is a valid context.

Append-only (correct objective typos only). Absolute dates. Record only verification that actually
occurred, name the next concrete action, and write `none` when there is no blocker. Not part of the
default read path — open it only when the current state doesn't explain *why* something happened.

**`SUMMARY.md`** — created only at `done` or `cancelled`, 10–30 lines: final status and close date ·
delivered or retained work · verification performed · relevant artifacts · open follow-ups · a short
ticket or pull-request comment. Report skipped verification honestly. For a cancellation, explain why
the effort stopped and what was retained, reverted, or left incomplete.

**`artifacts/`** — generated evidence: exports, audits, snapshots, inventories, screenshots, comparison
reports, tool logs. Created on demand, phase-prefixed, linked from the producing phase or the summary,
and never loaded into context automatically. Retention and commit behavior follow `PROJECT.md` →
Version control ("Progress artifacts"); the manual's secrets/sensitive-data HARD RULE (§1) applies
regardless of that setting.

**`scripts/`** — effort-local helpers that reproduce analysis, generate artifacts, verify contracts,
compare states, or automate one bounded operation. Document purpose, inputs, outputs, and safe usage.
Production application utilities do not belong here; a helper needed by several efforts graduates to the
repository's shared script location or a skill.

**`archive/closed-YYYY.md`** — old closed *router rows* only. Pick the year file and month heading from the
effort's `SUMMARY.md` close date, and **rewrite the link for the extra directory level** —
`effort/SUMMARY.md` becomes `../effort/SUMMARY.md`, or a literal move leaves a broken link. Never copy
roadmap, log, or summary content into it, and never move an effort folder (that breaks existing links).

## 8. `INDEX.md`

A router, not a dashboard: it stays in the default read path, so it carries only links grouped by state.
Do not duplicate kind, current phase, dates, scope, or status commentary — all of that is in the
roadmap. **One annotation is allowed**: a closed row's final state, `— done` or `— cancelled`, which never
changes again (a reopened effort leaves `Recently closed` entirely). A blocked row gets **no** explanation
— its roadmap owns that, and a second copy drifts. Show every `Active`, `Blocked`, and `Queued` effort;
cap `Recently closed` at 10 and move older rows to the yearly archive — rows run **newest first**, so "the
oldest" is the last one. Use relative links. An effort's section is a projection of its roadmap `status`;
when they disagree, the roadmap wins.

## 9. Legacy compatibility

New efforts use `schema: ai-progress/v2`. Earlier shapes — `task-{slug}.md`, `{effort}-ROADMAP.md`,
`{effort}/phase-NN-{slug}.md` — remain valid where they already exist. **Never migrate legacy work
automatically:** resume it in its existing shape, let `INDEX.md` link both formats, and treat a missing
`schema` as legacy. Migrate only on explicit request or when a material restructure justifies it,
preserving old paths and references.

## 9a. Out-of-scope findings

Safely deferrable observations noticed during an effort don't belong to it. They use the promotion ladder
in [`findings-workflow.md`](findings-workflow.md) — `FINDINGS.md` plus optional `findings/{id}.md` detail
files. Findings are **candidates, not committed efforts**: they never appear as `queued` efforts in
`INDEX.md`, they stay outside the cold-resume path, and `INDEX.md` doesn't link them. A roadmap's
`Deferred / follow-ups` may *link* a significant finding, never copy it (contract §7).

## 10. Validation checklist

- [ ] `INDEX.md` routes to the effort; `Recently closed` holds at most 10 rows; no row carries commentary
      beyond a closed row's `done` / `cancelled` (contract §8).
- [ ] The effort folder has a stable ID and slug, no other effort's `id:` duplicates it, and no merged
      path was renamed (contract §3).
- [ ] Any non-null `parent:` names exactly one existing epic, and no hierarchy runs deeper than two
      levels (contract §1).
- [ ] `ROADMAP.md` frontmatter is valid `ai-progress/v2`, with no `updated:` field.
- [ ] All seven roadmap sections exist, empty ones reading `None.`; `Outcome` states Goal and Done when.
- [ ] Effort status and the phase table agree (contract §5); **at most one phase is in flight — `[~]` or
      `[!]`, never both**, and a blocked effort may have neither.
- [ ] Every status change since the last entry was a legal transition (contract §5.1).
- [ ] Every authored phase file has exactly one roadmap row; no future phase was pre-authored.
- [ ] Every `[x]` row carries an actual one-line outcome, not its original target.
- [ ] The active phase file has plan and verification checklists, and no status field.
- [ ] Completed checkboxes reflect work actually done and verification actually run.
- [ ] `LOG.md` has a current entry; dates are absolute; referenced phases were not renumbered.
- [ ] `SUMMARY.md` exists only for a closed effort and introduces no new scope or status.
- [ ] Large output lives in `artifacts/`, linked — not pasted into Markdown.
- [ ] Artifacts and scripts carry no secrets or unapproved sensitive data.
- [ ] Relative links resolve, and a cold-start agent can name the next action.

## 11. Templates

Copy the file, then fill it in — don't retype a skeleton from memory. They live beside the skill in
[`../assets/`](../assets/):

| Template | Copy to |
| --- | --- |
| [`INDEX.template.md`](../assets/INDEX.template.md) | `ai-progress/INDEX.md` |
| [`ROADMAP.template.md`](../assets/ROADMAP.template.md) | `{effort-folder}/ROADMAP.md` |
| [`LOG.template.md`](../assets/LOG.template.md) | `{effort-folder}/LOG.md` |
| [`phase.template.md`](../assets/phase.template.md) | `{effort-folder}/phases/phase-NN-{slug}.md` |
| [`SUMMARY.template.md`](../assets/SUMMARY.template.md) | `{effort-folder}/SUMMARY.md` (only at close) |
| [`FINDINGS.template.md`](../assets/FINDINGS.template.md) | `ai-progress/FINDINGS.md` (on first capture) |
| [`finding.template.md`](../assets/finding.template.md) | `ai-progress/findings/{finding-id}.md` (rung 2 only) |

The templates are **normative for section names and order**. When you copy one:

- Replace every `{placeholder}` — an unreplaced placeholder is an unfinished file. `{…}` is reserved for
  slots you must fill, so **a guidance comment you keep must contain none**: a comment that still shows one
  is either stale or should have been deleted with the block it describes.
- **`Child efforts` (epic-only) is the one deletable section.** Every other roadmap section, and every
  `INDEX.md` state heading, stays and reads `None.` when empty — predictable shape beats conditional
  interpretation.
- Keep the guidance comments while the file is young; strip them once the file is established and the
  content speaks for itself.
- `archive/closed-YYYY.md` has no template: it's a heading per month plus the router rows moved out of
  `INDEX.md` (contract §8).
