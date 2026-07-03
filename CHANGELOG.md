# Changelog

All notable changes to the **AI kit** (the vendored `ai-kit/` folder) are recorded here. This file is
**home-only** — it lives beside [`MAINTAINING.md`](MAINTAINING.md) and never vendors downstream.

The kit follows [Semantic Versioning](https://semver.org/): **MAJOR** = breaking (forces a downstream
re-bootstrap or breaks a `§N` reference), **MINOR** = additive/backward-compatible, **PATCH** =
wording/clarification/fixes. The canonical version is the **Kit version** line at the top of
`ai-kit/AGENT-INSTRUCTIONS.md`; the §0 session-start handshake echoes it. See
[`MAINTAINING.md` → "Versioning & releases"](MAINTAINING.md) for the bump discipline.

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
