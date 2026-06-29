---
name: sync-project-profile
description: Re-validate the installed AI/ kit against the codebase — health-check that the kit is wired and consistent (root pointer, no leftover TODO/`<!-- To Remove -->`, valid mode, references resolve, index↔folder parity) AND correct drift: re-validate each `fill:auto` value against its cited evidence source and propose evidence-backed updates; re-ask `fill:user` values. Run periodically after the kit has been bootstrapped.
---

# Sync Project Profile

Keeps an already-bootstrapped `AI/` kit **healthy** and **in sync**. Bootstrap fills the blanks once
and (by [`bootstrap-project-profile`](../bootstrap-project-profile/SKILL.md) contract rule 5) never
re-touches a filled value — so nothing re-validates the profile as the codebase evolves. This skill
closes that gap. It assumes the kit was already bootstrapped: the persistent `fill:` markers on every
managed slot are its **field inventory**: `<!-- fill:user -->` (a judgment/preference slot — re-ask,
never auto-change) and `<!-- fill:auto · «source» -->` (evidence-backed — re-validate against «source»
and propose updates).

This skill adds **no new behavioral rules**; it applies the manual's existing ones (§1 read-before-write
/ trust-repo-over-recollection, §5.2 stop-and-ask, §7 verify-honestly) to the kit's own config.

## When to use

- **Periodically / after codebase change** — dependencies, scripts, tooling, or layout moved and you
  want the profile re-checked and re-aligned to the repo.
- **Health audit** — confirm the kit is actually wired and internally consistent (pointer, no stray
  scaffolding, references resolve, indexes match folders).
- Trigger phrases: "sync the project profile", "is the AI kit still accurate / still wired", "check the
  kit for drift".
- **Not** for first adoption or a full post-stack-change refresh — that's
  [`bootstrap-project-profile`](../bootstrap-project-profile/SKILL.md) (the *first* fill). This skill is
  the *keep-it-healthy + in-sync* counterpart.

## Read first

- [`../../AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) — **§1** (don't invent from memory; read
  before you write; trust the repo over recollection — the basis for re-validating against evidence, not
  memory), **§5.2** (stop and ask on costly/irreversible — the basis for ask-don't-auto-change), **§7**
  (every reference resolves; verify honestly; never claim "verified" when nothing ran — the basis for the
  references-resolve checks and the no-suppression rule).
- [`../bootstrap-project-profile/SKILL.md`](../bootstrap-project-profile/SKILL.md) — its detection
  **steps** (3 stack, 4 commands, 4.5 integrations, 5 conventions, 6 file locations, 10 root-pointer) and
  its **contract** (esp. rule 3 commands-are-sacred, rule 5 don't-overwrite-human-edits). This skill
  **cites** those steps for the per-field mechanics rather than duplicating them.
- The `fill:` markers across [`../../PROJECT.md`](../../PROJECT.md) and
  [`../../reference/`](../../reference/) — the inventory of managed slots and their kind/evidence source.

## The contract (non-negotiable)

1. **Re-validate against evidence, not memory.** Re-derive every `fill:auto` value from the *same
   evidence source its marker cites* (§1) — never from recollection of what the project "usually" is.
2. **Propose, never silently overwrite — preserve human edits at sync time.** Even a re-validated
   `fill:auto` value is **proposed at the gate** with its evidence citation and applied only on the
   user's go-ahead; a human may have refined an auto field, so this upholds bootstrap contract rule 5 at
   sync time.
3. **`fill:user` fields are asked, never auto-changed.** For judgment/preference slots
   (response-economy mode, mandated channels, Role mandate, version-control policy, locked decisions)
   only check presence/validity and **surface suspected drift as a question** (§5.2). Never edit them.
4. **Commands are sacred.** Never propose a fabricated command — only one found **verbatim** in its
   source (bootstrap contract rule 3).
5. **Never suppress a failed health check.** Report every failure with its specifics (which file, which
   broken reference / orphan / invalid value). Report the unwired-pointer and broken-command failures
   **loudly** — they make the kit silently inert or make "verified" a lie (§7).
6. **Preserve the markers.** Re-validating or correcting a slot **never** removes its `fill:` marker (or
   any guidance blockquote / HARD-RULE framing / structure). The markers are the inventory the next sync
   depends on.

## Procedure

### 1. Inventory the managed slots

```bash
grep -rn "fill:" AI/PROJECT.md AI/reference/*.md
```

Enumerate every managed field and its kind: `fill:user` (ask) vs `fill:auto · «source»` (re-validate
against `«source»`). This list drives both dimensions below.

### 2. HEALTH dimension — structural integrity first

Run all checks; **collect every failure with its specifics — don't stop at the first.**

- **Root pointer wired / kit active** (mirrors bootstrap step 10, README Setup step 2): find the
  auto-loaded entry file at the repo root (`CLAUDE.md` / `AGENTS.md` / `.cursorrules` /
  `.github/copilot-instructions.md`, plus any subdirectory entry file the tool actually loads), grep it
  for a pointer to `AI/AGENT-INSTRUCTIONS.md`, and resolve that relative path **from the entry file's own
  directory** to confirm the target exists. A pointer that doesn't resolve fails silently → the whole
  methodology is inert.
- **No leftover `<!-- To Remove -->` blocks:** `grep -rn "To Remove" AI/` → expect none (bootstrap steps
  3.5 / 7 delete them).
- **No stray un-annotated `TODO` / `{placeholder}`:** `grep -rn "TODO" AI/` (and scan for `{…}` braces);
  every remaining hit must be an intentionally-deferred slot annotated `confirm with owner` (bootstrap
  contract rule 2). A raw `TODO` = a managed slot never filled.
- **Role filled:** the `fill:user` slot under `PROJECT.md` `## Role` holds real content, not
  `TODO`/`{placeholder}`. (Presence only; content is user judgment, re-checked by asking in step 3.)
- **Mode is a valid value:** the `## Response economy` Mode is exactly one of `standard | concise |
  terse` (§9). Reject anything else, including blank.
- **References resolve — commands:** for each `PROJECT.md` Commands-table entry, confirm it still exists
  **verbatim** in whichever evidence source the project has (package scripts / Makefile / Taskfile / CI),
  using a stack-agnostic existence check. **Do not run side-effecting commands** (mirrors bootstrap
  Verify + contract rule 3).
- **References resolve — file paths:** every path named in `file-locations.md` (and any path cited as a
  `fill:auto` evidence source) exists in the repo.
- **References resolve — internal links:** every relative Markdown link and `@import` inside `AI/`
  resolves relative to its linking file's directory.
- **References resolve — `§N` cross-refs:** every `§N` inside `AI/` maps to a real heading in
  `AGENT-INSTRUCTIONS.md`.
- **Index ↔ folder parity (skills):** bidirectionally set-compare `AI/skills/*/SKILL.md` against the rows
  in `AI/skills/README.md` — every SKILL.md has a row and every row points at a real SKILL.md.
- **Index ↔ folder parity (reference):** same, `AI/reference/*.md` (excluding `README.md`) against
  `AI/reference/README.md`.

### 3. DRIFT dimension — content alignment (only meaningful once health passes)

For each `fill:auto` field, re-read its **cited** evidence source (the same source bootstrap used) and
diff against the documented value; draft an evidence-backed **proposed** update:

- **Stack & versions** → re-read the dependency manifest + pinned-runtime files (bootstrap step 3).
- **Commands table** → re-extract Install/Dev/Build/Test/Lint/Format **verbatim** from the cited source,
  cross-check order against CI (step 4). Flag renamed/removed/added scripts; never fabricate (rule 4).
  The command string is `auto` (propose); the "Who runs it" column is judgment → **ask**.
- **Integrations → Available** → re-read the cited tool config (step 4.5); diff configured servers/CLIs.
- **Conventions / `coding-conventions.md`** → re-locate the cited linter/formatter/style configs
  (step 5); confirm each still exists and any "deviates from stock" note still matches; re-confirm
  pre-commit/CI HARD-RULE enforcers exist. Propose which config IS the source of truth; **ask** before
  changing a rule a human hand-edited beyond the config.
- **Layout / `file-locations.md`** → rebuild the depth-limited tree + re-read `.gitignore` (step 6);
  confirm each documented path still exists and each generated/never-edit entry still matches.
- **Decision ladders** → re-check against the repo's current patterns (step 7); propose, the user confirms.

For each `fill:user` field, **presence/validity check only** and prepare a *question* if drift is
suspected (e.g. the re-derived stack no longer matches the seniority/domain the Role asserts; a tool
backing a mandated channel disappeared from config; a locked decision visibly contradicts re-detected
evidence). **Never rewrite a `fill:user` field.** Write nothing yet.

### 4. GATE — present, wait for approval (§2.4 / §5.2)

Present **one** report: (a) health failures, each with its fix or "tell the user to add the pointer
line"; (b) proposed `fill:auto` updates, each with its evidence citation; (c) `fill:user` questions.
**Wait for explicit approval.** Auto fields are proposals, not silent writes; user fields are questions,
never edits.

### 5. Apply on go-ahead

Write the approved `fill:auto` corrections and fold in the user's answers for `fill:user` fields —
**preserving every `fill:` marker, guidance blockquote, HARD-RULE framing, and structure**. Leave
anything unconfirmed annotated `confirm with owner`.

### 6. Verify & report (§7)

Re-run the health checks to confirm failures are resolved and **all markers are still present**. Deliver
an honest summary: what re-validated clean, what was corrected (with evidence), what the user must still
decide, and any health failure left open (e.g. an unwired pointer the user must add).

## Verify

- [ ] Health checks re-run clean, or every remaining failure is reported with its specifics (no
      suppression — §7).
- [ ] Every applied change was **proposed at the gate** and approved; no `fill:user` field was auto-edited.
- [ ] Every proposed/applied `fill:auto` value is backed by its **cited** evidence source; no command was
      fabricated (verbatim from source only).
- [ ] Every managed slot still carries its `fill:` marker; blockquotes / HARD-RULE framing / structure intact.
- [ ] Honest summary delivered — re-validated clean, corrected (with evidence), open for the user.

## Anti-patterns

- ❌ Silently overwriting a filled value instead of proposing it at the gate (breaks contract rule 2 / bootstrap rule 5).
- ❌ Auto-changing a `fill:user` field instead of asking (mode, mandated channels, Role, version-control, locked decisions).
- ❌ Re-deriving a value from memory rather than from its cited evidence source (§1).
- ❌ Proposing a build/test/lint command not found verbatim in its source.
- ❌ Suppressing or softening a failed health check — especially an unwired pointer or a broken command.
- ❌ Stripping a `fill:` marker (or a guidance blockquote) while correcting its slot.
