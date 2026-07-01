# Changelog

All notable changes to the **AI kit** (the vendored `AI/` folder) are recorded here. This file is
**home-only** — it lives beside [`MAINTAINING.md`](MAINTAINING.md) and never vendors downstream.

The kit follows [Semantic Versioning](https://semver.org/): **MAJOR** = breaking (forces a downstream
re-bootstrap or breaks a `§N` reference), **MINOR** = additive/backward-compatible, **PATCH** =
wording/clarification/fixes. The canonical version is the **Kit version** line at the top of
`AI/AGENT-INSTRUCTIONS.md`; the §0 session-start handshake echoes it. See
[`MAINTAINING.md` → "Versioning & releases"](MAINTAINING.md) for the bump discipline.

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
  instant rollback* (no physical `AI.bak/` copy needed); (2) an explicit **"never delete project-owned
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
  `AI/skills/`). Recommends a single whole-folder Claude Code symlink (`.claude/skills` → `AI/skills`),
  so every skill under `AI/skills/` — shipped `aikit-*` and project-authored alike — and any added
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
- **Skill `aikit-update-kit`** — downstream procedure to upgrade a vendored `AI/` kit to a newer
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
