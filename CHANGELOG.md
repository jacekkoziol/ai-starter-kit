# Changelog

All notable changes to the **AI kit** (the vendored `AI/` folder) are recorded here. This file is
**home-only** — it lives beside [`MAINTAINING.md`](MAINTAINING.md) and never vendors downstream.

The kit follows [Semantic Versioning](https://semver.org/): **MAJOR** = breaking (forces a downstream
re-bootstrap or breaks a `§N` reference), **MINOR** = additive/backward-compatible, **PATCH** =
wording/clarification/fixes. The canonical version is the **Kit version** line at the top of
`AI/AGENT-INSTRUCTIONS.md`; the §0 session-start handshake echoes it. See
[`MAINTAINING.md` → "Versioning & releases"](MAINTAINING.md) for the bump discipline.

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
