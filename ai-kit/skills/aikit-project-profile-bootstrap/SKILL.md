---
name: aikit-project-profile-bootstrap
description: Analyze the codebase and replace the TODO placeholders in ai-kit/PROJECT.md and ai-kit/reference/*.md with real, evidence-backed values (role, stack, commands, integrations, version-control policy, conventions, file locations, decision ladders, locked decisions, project-specific rules, glossary). On first adoption it also wires skill discovery (links ai-kit/skills into the runtime's skill dir, per README step 3) so the kit's skills are invocable, and sets config visibility (shared, or local-only via .git/info/exclude). Use once when adopting this ai-kit/ kit in a project, or to refresh it after a major stack change.
---

# Bootstrap Project Profile

Scans the repository and fills the `TODO` placeholders in the `ai-kit/` kit — turning the blank
[`PROJECT.md`](../../PROJECT.md) and [`reference/`](../../reference/) scaffolds into a profile that
reflects *this* codebase, backed by evidence from the repo (not memory).

## When to use

- **First adoption** — you've dropped the `ai-kit/` kit into a project and the profile/reference docs are
  still full of `TODO`s.
- **Refresh** — after a major stack, tooling, or layout change, to bring the docs back in sync.
- Trigger phrases: "fill the TODOs", "bootstrap the project profile", "analyze the codebase and
  populate the AI docs".
- **Not for ongoing upkeep** — after adoption, use [`aikit-project-profile-sync`](../aikit-project-profile-sync/SKILL.md)
  to keep filled values healthy and in sync; this skill is for the **first** fill or a full
  post-stack-change refresh.

## Read first

- [`../../AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) — especially §1 (don't invent from
  memory; read before you write) and §7 (every reference must resolve). The values you write must obey
  it.
- The target files, to see the exact placeholders **and the guidance blockquotes you must preserve**:
  [`PROJECT.md`](../../PROJECT.md) (including its `## Role` section), [`reference/coding-conventions.md`](../../reference/coding-conventions.md),
  [`reference/decision-ladders.md`](../../reference/decision-ladders.md),
  [`reference/file-locations.md`](../../reference/file-locations.md).

## The contract (non-negotiable)

1. **Evidence or nothing.** Every value you write must be backed by a real file, config, or command
   found in the repo. Note the source (path) in the session summary so it's auditable. User-stated
   answers (the mode, policies, per-server confirmations) are their own evidence — cite them as
   "user-confirmed".
2. **Don't guess.** If something can't be determined from the repo, **leave the `TODO`** and annotate
   it `TODO — not found; confirm with owner`. A wrong-but-confident value is worse than a blank.
3. **Commands are sacred.** Never fabricate a build/test/lint command. Copy it **verbatim** from
   `package.json` / `Makefile` / CI. If none exists, leave blank + confirm.
4. **Preserve the scaffolding — including the `fill:` markers.** Keep every guidance blockquote, the
   "generic lives in AGENT-INSTRUCTIONS" framing, the HARD RULE markers, **and the `<!-- fill:user -->` /
   `<!-- fill:auto · «source» -->` markers on managed slots** — they persist after you fill the slot (they
   are the field inventory [`aikit-project-profile-sync`](../aikit-project-profile-sync/SKILL.md) re-validates
   against). Fill the slots only — don't restructure or strip the markers. (Exception: blocks fenced by
   `<!-- To Remove -->` are disposable examples — **delete** them.)
5. **Don't overwrite human edits.** Replace only literal `TODO` / `{placeholder}` markers. If a slot
   already has real content, leave it. Because bootstrap fills blanks once and never re-touches a filled
   value, **re-validating filled values against the evolving codebase is `aikit-project-profile-sync`'s job,
   not this skill's** — run that periodically to catch drift (`fill:auto` proposes evidence-backed
   updates; `fill:user` is re-asked).

## Procedure

### 1. Scope — find every placeholder

Grep the fill-in surfaces so you fill exactly what's blank. The managed files are wherever `fill:`
markers live — by the kit's layering, exactly `PROJECT.md` + `reference/*.md` (a future kit version
adding a marker-bearing surface joins this sweep); the manual/templates/skills hold only scaffold or
prose `TODO`s, not slots:

```bash
grep -rn "TODO" ai-kit/PROJECT.md ai-kit/reference/
```

(Optional, per AGENT-INSTRUCTIONS §4: log this as `ai-progress/task-bootstrap-profile.md`.)

**Ask the response-economy mode** — a user preference, not inferable from code: which of `standard` |
`concise` | `terse` (AGENT-INSTRUCTIONS §9) the user wants the agent to use in conversation. Record it
in `PROJECT.md`'s "Response economy" field when you fill the files (step 8); default `concise` if the
user is indifferent.

### 2. Harvest existing instruction sources first

Cheapest, highest-signal evidence — humans often already wrote this down. Look for and read:

- Agent/contributor docs: `CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `.github/copilot-instructions.md`,
  `CONTRIBUTING.md`, top-level `README*`.
- Architecture decisions: `docs/`, `docs/adr/`, `doc/decisions/`, `*.adr.md`.

Prefer what these state directly over anything you infer.

### 3. Detect stack & versions → `PROJECT.md` Overview

Read whichever manifests exist; each tells you the stack and often pins versions:

| Evidence | Tells you |
| --- | --- |
| `package.json` (`dependencies`, `engines`) | Node/JS/TS stack, frameworks, Node version |
| `composer.json` | PHP stack, framework, PHP version constraint |
| `pyproject.toml` / `requirements.txt` / `Pipfile` | Python stack + libs |
| `go.mod` / `Cargo.toml` / `pom.xml` / `build.gradle` / `*.csproj` / `Gemfile` | Go / Rust / Java / .NET / Ruby stack |
| `.nvmrc`, `.tool-versions`, `Dockerfile`, `.github/workflows/*` | Pinned runtime versions |

### 3.5 Draft the Role → `PROJECT.md` Role

Derive the project-specific persona + mandate for `PROJECT.md`'s `## Role`: **seniority + domain** from
the detected stack (step 3); the **mission and defining tension** from the harvested instruction
sources (step 2 — `CLAUDE.md` / `README` / `CONTRIBUTING`). If a starter or source `CLAUDE.md` already
has a `## Role`, copy it near-verbatim. The mission/tension is usually inferential, not stated as a
rule — write it as a **DRAFT**, surface it at the gate (step 9), and never fabricate. If no evidence
supports a mandate, leave the `TODO` annotated `confirm with owner`.

**Then delete the `<!-- To Remove: START -->…<!-- To Remove: End -->` example block** in the Role
section — those are reference examples, not project content.

### 4. Extract commands → `PROJECT.md` Commands table

- **Primary source:** `package.json` `scripts`, `Makefile` targets, `composer.json` `scripts`,
  `Taskfile.yml`, `justfile`.
- **Cross-check order against CI:** `.github/workflows/*.yml`, `.gitlab-ci.yml`, etc. — CI shows the
  real install → build → test → lint sequence the project actually trusts.
- Map findings to Install / Dev / Build / Test / Lint / Format. Copy **verbatim**. Mark "who runs it"
  as the user for anything long-running or with side effects.

### 4.5 Detect integrations & tools → `PROJECT.md` Integrations

Read tool config (`.mcp.json`, `.cursor/mcp.json`, editor MCP settings) and list the configured MCP
servers / tools under "Available". The **mandated channels** (e.g. "all writes go through {tool}, never
raw SQL") usually aren't in config — harvest them from instruction sources (step 2) or **ask the
user**; never assume. Keep the stop-if-missing rule.

**Then inventory the runtime's live tool surface** — the MCP servers/tools actually available to you
in this session (use your runtime's tool listing; if it can't enumerate, note that and skip). The live
surface is **per-machine evidence, not project evidence** — a globally-configured server your session
sees may be invisible to a teammate's. So for each server visible at runtime but absent from the
project's tool config, **ask the user — one decision per server** (batch the presentation, §2.2):
document it under "Available", or leave it out (personal/global config, not a project fact). For an
accepted server, **offer** to add it to the project's tool config so teammates and future syncs see it
(a repo change — the normal gate applies); if the user wants it documented but *not* in config, record
it with a **`(runtime-only)` tag** — [`aikit-project-profile-sync`](../aikit-project-profile-sync/SKILL.md)
re-asks tagged entries instead of validating them against config. The confirmed list also feeds the
mandated-channels ask above.

### 5. Detect conventions → `reference/coding-conventions.md`

- **Config-as-source-of-truth:** find linter/formatter/style configs and reference them rather than
  restating every rule — `.eslintrc*`, `.prettierrc*`, `.stylelintrc*`, `.editorconfig`, `phpcs.xml`,
  `ruff.toml`/`setup.cfg`, `.golangci.yml`, `.rubocop.yml`, `.clang-format`. Note where each deviates
  from the stock standard.
- **Naming/casing:** infer from the actual file tree and a few representative source files.
- **HARD RULES:** pre-commit enforcement (`.husky/`, `lefthook.yml`, `.git/hooks`, `.pre-commit-config.yaml`),
  protected/"never edit" directories, CI guards that block certain paths.

### 6. Map file locations → `reference/file-locations.md`

- Build a depth-limited tree; identify where components/modules, shared utilities, config/tokens, data
  model, tests, and styles/assets live.
- **Generated / never-edit:** read `.gitignore` and spot `dist/`, `build/`, `vendor/`,
  `node_modules/`, auto-generated barrels/clients — record what regenerates them.

### 7. Draft decision ladders → `reference/decision-ladders.md` (inferential)

- Infer the repo's recurring "which approach?" patterns from how it *already* does things (e.g. data
  access via repositories, component variants vs new components, config keys vs constants).
- Write each as stop-at-first-match rungs; flag the rung that crosses into **STOP and ask** (new
  dependency, migration, irreversible change).
- These are **inferred, not observed-as-rules** — present them as drafts for the user to confirm.
- Then **delete the `<!-- To Remove -->` sample-ladder block** — like the Role examples, it's a
  reference sample, not project content.

### 7.5 Harvest project-specific rules → `PROJECT.md` Project-specific rules

Free-form house rules that don't fit the other sections (a formatter-before-commit rule, a
feature-flag mandate, a required-test rule). Harvest them from the instruction sources read in step 2
(`CONTRIBUTING`, agent docs, ADRs) and **ask the user** for any others. Add each as a bullet,
**keeping the placeholder line** so the section always invites the next rule. These are the owner's
directives, not inferred — add none if there are none rather than inventing rules.

**If the stack produces web UI** (HTML templates, a frontend framework, a component library — from
step 3), **propose** an accessibility rule for the user to confirm: conform to
[WCAG 2.2](https://www.w3.org/WAI/standards-guidelines/wcag/) level AA and follow the ARIA Authoring
Practices ([APG](https://www.w3.org/WAI/ARIA/apg/patterns/)) patterns. On acceptance add it as a rule
bullet; detail can grow into a project-authored `reference/accessibility.md`. Skip it for non-UI stacks.

### 7.7 Ask the user-owned policies → `PROJECT.md` Version control + Locked decisions

Both are `fill:user` — harvest hints first, then **ask; never infer silently**:

- **Version control (Branch / Commit / PR):** harvest hints from `CONTRIBUTING`, CI configs, and the
  repo's branch/PR history (naming patterns, protected branches), then ask the user to set the
  policy — branch naming, commit cadence, who opens PRs and against what.
- **Locked decisions:** propose candidates from the ADRs / instruction sources read in step 2 —
  settled choices the agent must not relitigate; the user confirms which to lock. Add none if there
  are none — never invent.

### 8. Fill the files

Replace each placeholder with its evidence-backed value, preserving structure, guidance blockquotes,
and HARD RULE markers. Where evidence is missing, keep the `TODO` and annotate it (contract rule 2).

**Glossary:** fill it with recurring domain terms harvested from the instruction sources (step 2);
it's optional — delete the section if none apply (per `PROJECT.md`'s "delete rows that don't apply").

### 9. Gate — present before finalizing

Per AGENT-INSTRUCTIONS §2.4: summarize what you found **with citations**, and explicitly surface for
confirmation the least-certain outputs — **the Commands table**, **the inferred decision ladders**,
**the drafted Role** (its mandate/tension is inferred, so the user must confirm it), and **the
proposed Locked decisions** (step 7.7). Apply the user's corrections to the docs, then finish.

### 10. Confirm the kit is wired

Check the repo's root agent-entry file (`CLAUDE.md` / `AGENTS.md` / `.cursorrules` /
`.github/copilot-instructions.md`) for a pointer to `ai-kit/AGENT-INSTRUCTIONS.md`. If none exists or the
pointer is missing, tell the user to add the line — *"For how to approach any coding task, follow
`ai-kit/AGENT-INSTRUCTIONS.md`."* (README adoption step 2). Without it, no agent auto-loads the kit and the
methodology is never used.

### 11. Wire skill discovery (so the kit's skills are invocable)

Make `ai-kit/skills/` discoverable by the agent runtime. Most runtimes auto-discover skills only from
**their own** directory (e.g. Claude Code from `.claude/skills/`), not from `ai-kit/skills/`, so the
`/aikit-*` commands don't exist until it's wired in. Run (or offer to run) the symlink command in
**README adoption step 3** — for Claude Code, one whole-folder link (`.claude/skills` → `ai-kit/skills`)
makes every current and future skill resolve — then have the user commit it. Mind the guard: if a real
`.claude/skills/` already exists, use the per-skill fallback instead of clobbering it. For a runtime
with **no** skill mechanism there's nothing to wire: a skill is invoked by pointing the agent at its
`ai-kit/skills/<name>/SKILL.md`.

### 12. Set kit integration — config visibility + update source

**Config visibility:** ask whether the kit should be **shared** (committed & pushed with the repo — the
default) or **local-only** (kept on this machine, not pushed). Record the answer in `PROJECT.md` →
"Config visibility". If **local-only**, add the kit's paths to `.git/info/exclude` (the per-clone ignore
that's never committed) — `ai-kit/`, `ai-progress/`, and the root pointer file **only if it was created
solely for the kit** (leave it tracked if it also holds team content). This works only while those paths
are **untracked**, so do it before the kit is committed (else `git rm --cached -r` them first). For a
shared kit, do nothing here — it's committed normally in README step 6.

**Update source:** confirm `PROJECT.md` → "Kit source" — leave `default` to update from the kit's
canonical home, or set a fork/mirror/local path if this project vendors the kit from elsewhere.

## Verify

- [ ] `grep -rn "TODO" ai-kit/PROJECT.md ai-kit/reference/` shows only intentionally-unresolved placeholders (each annotated "confirm").
- [ ] Every command in `PROJECT.md` exists **verbatim** in `package.json` / `Makefile` / CI.
- [ ] Every path referenced in `file-locations.md` actually exists in the repo.
- [ ] Guidance blockquotes + the generic-vs-project framing + HARD RULE markers are intact in each file.
- [ ] Ask the user to confirm the command table runs — don't assume (AGENT-INSTRUCTIONS §7).
- [ ] `PROJECT.md`'s `## Role` is filled (or annotated for confirmation) — not left blank.
- [ ] No `<!-- To Remove -->` block remains in any `ai-kit/` file (the Role examples + the sample ladder were deleted).
- [ ] Root agent-entry file points at `ai-kit/AGENT-INSTRUCTIONS.md` (or the user has been told to add it).
- [ ] The kit's skills resolve in the runtime (e.g. `/aikit-plan` in Claude Code), or the runtime has no
      skill mechanism and skills are invoked by `ai-kit/skills/<name>/SKILL.md` path.
- [ ] Every managed slot still carries its `<!-- fill:user -->` / `<!-- fill:auto · «source» -->` marker
      (filling a slot does **not** remove it) — the inventory `aikit-project-profile-sync` and the health check rely on.
- [ ] Response-economy mode in `PROJECT.md` was **asked**, not guessed.
- [ ] Version control (Branch / Commit / PR) was **asked** and recorded (or annotated for confirmation) — not left silently `TODO`.
- [ ] Locked decisions: ADR-derived candidates were **proposed** at the gate; none invented.
- [ ] Glossary filled from harvested terms, or the optional section deleted — not left as bare `TODO`s.
- [ ] Integrations listed in `PROJECT.md`; any **mandated** tool channel was asked, not assumed.
- [ ] The runtime's live tool surface was inventoried (or noted as non-enumerable); every
      runtime-visible server absent from project config was asked about — one decision per server;
      accepted-but-unconfigured entries carry the `(runtime-only)` tag.
- [ ] `PROJECT.md` "Project-specific rules": harvested/asked rules added as bullets (placeholder kept), or none if there are none (never invented).
- [ ] For a UI-producing stack, an accessibility rule (WCAG 2.2 AA + ARIA APG) was **proposed** at the gate; skipped for non-UI stacks.
- [ ] Config visibility was **asked** and recorded in `PROJECT.md`; if local-only, `ai-kit/` (+ `ai-progress/`, kit-only pointer) are in `.git/info/exclude` while still untracked.
- [ ] `PROJECT.md` "Kit source" is present (`default`, or a project override URL/path) for `aikit-update-kit`.

## Anti-patterns

- ❌ Writing any value not backed by a file in the repo (user-confirmed answers are the one
  exception — contract rule 1) — above all, inventing a build/test command.
- ❌ Deleting the blockquote guidance or the "generic lives in AGENT-INSTRUCTIONS" framing.
- ❌ Filling `decision-ladders.md` with generic fluff instead of the repo's actual patterns.
- ❌ Overwriting content a human already filled in (only replace `TODO` markers).
- ❌ Claiming done while `TODO`s remain unannotated, or while commands are unverified.
