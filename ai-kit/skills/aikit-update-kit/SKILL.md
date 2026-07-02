---
name: aikit-update-kit
description: Upgrade this project's vendored ai-kit/ kit to a newer version — replace the methodology files while PRESERVING all project-owned content (filled PROJECT.md, reference/*.md, custom README index rows, and any project-authored skills/docs/templates), then health-check with aikit-project-profile-sync. Use when the kit's home repo has published a newer Kit version than the one in this project's AGENT-INSTRUCTIONS.md header.
---

# Update the vendored kit

**Canonical home:** <https://github.com/jacekkoziol/ai-starter-kit> — the built-in default update
source. **Forking the kit? Change this one line** (per-project overrides live in `PROJECT.md` → "Kit
source").

> Pulls a newer snapshot of the `ai-kit/` kit into a project that already uses it, **without losing the
> project's answers**. The methodology files (the manual, skills, templates, layer guides) are
> replaced; the project's *filled* profile (`PROJECT.md`, `reference/*.md`) is reconciled, not
> overwritten. Finishes by running [`aikit-project-profile-sync`](../aikit-project-profile-sync/SKILL.md)
> to confirm the merged result is healthy.

## When to use

- The kit's home repo has a **newer Kit version** than the `**Kit version:**` line at the top of this
  project's [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md), and you want to adopt it.
- A teammate asks to "update / re-vendor / bump the AI kit" in this repo.

This is the **downstream** counterpart to the kit's own release flow: a project consuming the kit does
**not** bump the version or tag — the Kit version simply reflects which snapshot you vendored.

## Read first

- [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) header — your **current** Kit version.
- The kit's **source** (resolved in step 2 — the canonical home, or a `PROJECT.md` → "Kit source"
  override) — read its changelog / release notes for what changed between your version and the latest.
  If no source resolves, **ask the user**; don't guess a URL.
- [`PROJECT.md`](../../PROJECT.md) + [`reference/`](../../reference/) — the filled content you must
  preserve through the update.

## Procedure

> **Never delete project-owned content** (the whole point of this skill). Preserve, and carry across
> the update untouched: the filled `PROJECT.md` and `reference/*.md`; **project-authored** (unprefixed)
> skills and their co-located `scripts/`/`references/`/`assets/`; project-authored reference docs and
> templates; project rows in the `skills`/`reference`/`templates` README indexes. `ai-progress/` lives
> at the repo root, outside `ai-kit/` — the update never touches it. Everything else under `ai-kit/` is
> kit-owned and safe to replace (steps 3–5 draw the exact line).

1. **Snapshot first — how depends on config visibility** (`PROJECT.md` → "Config visibility"). Commit
   or stash any work-in-progress either way.
   - **Shared / tracked** (default): run the update on a **dedicated branch off a clean `main`** (§2.6
     gates direct `main` commits anyway). Clean `main` is your restore point — the update is
     the branch diff, and **not merging = instant rollback**. No physical copy needed; git snapshots
     tracked files losslessly.
   - **Local-only** (kit excluded via `.git/info/exclude`, so **untracked**): git can't snapshot it —
     branches and `main` don't capture untracked files. Take a **physical copy** as the restore point
     (`cp -r ai-kit ai-kit.bak` **outside the repo**, e.g. a scratch dir, so it's never committed) before
     overwriting; review against it in step 8 and delete it once satisfied.
2. **Get the new snapshot — resolve the source first.** The kit's **canonical home** (top of this file)
   is the built-in default. Read `PROJECT.md` → "Kit source": if it names a project override (a fork,
   mirror, or local path), **ask which to use** — the override or the canonical home. (Deliberately
   re-asked on every update, §2.2 notwithstanding: an update pulls outside content into the repo, so
   the user consciously confirms the source each time.) If it's `default` (or absent), use the
   canonical home automatically.
   If neither resolves (e.g. a fork that blanked its home, and no override), **ask the user** — don't
   guess a URL. Obtain the target version's `ai-kit/` from the chosen source and note its Kit version so you
   can confirm the jump.

   > **Folder rename in v2.0.0 (`AI/` → `ai-kit/`).** If your current install predates 2.0.0 its folder is
   > still named `AI/`. Rename it (`git mv AI ai-kit`), then re-point the root pointer's
   > `AI/AGENT-INSTRUCTIONS.md` reference, the skill symlinks (`→ ../ai-kit/skills`), and any local-only
   > `.git/info/exclude` entries — or just re-run [`AGENT-INIT.md`](../../AGENT-INIT.md), which re-derives
   > all of them. Full steps are in the source's 2.0.0 release notes.
3. **Replace the purely kit-owned files** (safe to overwrite — no project content):
   `AGENT-INSTRUCTIONS.md`, `AGENT-INIT.md`, the top-level `README.md`, `skills/_SKILL-TEMPLATE.md`,
   every `skills/aikit-*/`, and the `templates/` scaffolds the new snapshot ships (project-authored
   scaffolds aren't in it and stay) — plus any **new** files the version adds. Replace these **path by path**; **never
   wholesale-wipe a shared directory** (`skills/`, `reference/`, `templates/`) with `rm -rf` / `cp -r` /
   `rsync --delete` — each mixes kit and project files. If a new kit file would land on a path the
   project already authored, **stop and ask** (§5.2) — don't overwrite it. The `reference/`, `skills/`,
   and `templates/` layer-guide `README.md`s are **not** in this list; their `## Index` tables hold
   project rows — reconcile them next.
4. **Reconcile the layer-guide README indexes — do NOT blanket-overwrite** `skills/README.md`,
   `reference/README.md`, or `templates/README.md`. Each `## Index` mixes **kit rows** (pointing at
   kit-shipped skills/docs/templates) with **project rows** (ones this project added). Take the new
   version's prose **and kit rows**, then **carry over every project row unchanged**. A row is
   project-authored when the new snapshot **doesn't ship its target** — for skills, the quick tell is the
   missing `aikit-` prefix. Dropping a project row silently deletes that skill/doc/template's only index
   entry and the description the project wrote for it.
5. **Reconcile the filled profile — do NOT blanket-overwrite** `PROJECT.md` or `reference/*.md`. They
   hold this project's Role, commands, conventions, and `fill:`-marked answers. For each **new or
   renamed managed slot / fillable field** the new version introduces, splice the new scaffolding
   (with its `fill:` marker) into your filled doc and leave existing answers intact. When unsure
   whether a block is kit scaffolding or a project answer, keep the project answer and flag it.
6. **Run [`aikit-project-profile-sync`](../aikit-project-profile-sync/SKILL.md).** It health-checks the
   merged kit (pointer wired, no leftover placeholders, references resolve, `fill:` markers valid,
   index↔folder parity) and re-validates `fill:auto` values against the repo. Fix what it flags.
7. **Confirm the version.** The updated `AGENT-INSTRUCTIONS.md` header now carries the new Kit
   version; the session-start handshake echoes it from the **next** session on — don't wait for a
   banner mid-session.
8. **Review, then finalize — per visibility.** **Scan for deletions** — every removed file/line under
   `ai-kit/` must be kit-owned; flag any project-owned deletion before it lands.
   - **Shared / tracked:** review the git diff and commit per the version-control policy (§2.6).
   - **Local-only:** git shows nothing (the kit is excluded), so review with `diff -r ai-kit.bak ai-kit`; once
     satisfied there's nothing to commit — delete the backup copy.
   Summarize what changed and any slots you reconciled by hand.

## Verify

- [ ] `AGENT-INSTRUCTIONS.md` header shows the **new** Kit version.
- [ ] `PROJECT.md` + `reference/*.md` keep every prior project answer; new slots added with markers.
- [ ] The `skills`/`reference`/`templates` README indexes keep every **project-authored** row; only kit rows were replaced.
- [ ] **Nothing project-owned vanished** — every project-authored skill, reference doc, template, and co-located resource that existed pre-update still exists (shared: `git diff main` shows deletions only of kit files; local-only: `diff -r` against the `ai-kit.bak` copy).
- [ ] `aikit-project-profile-sync` reports healthy (no leftover placeholders, links resolve, markers valid).
- [ ] The diff is reviewable and committed; nothing under `ai-kit/` references the kit's home-only files.

## Anti-patterns

- ❌ Overwriting a filled `PROJECT.md` / `reference/*.md` with the new version's blank scaffold — that
  silently deletes the project's answers.
- ❌ Blanket-overwriting a layer-guide README (`skills`/`reference`/`templates`) — deletes the project's
  own `## Index` rows and the descriptions it wrote for its custom skills/docs/templates.
- ❌ Updating without then running `aikit-project-profile-sync` (drift goes unnoticed).
- ❌ Updating over a dirty tree, so the change isn't a clean reviewable diff.
- ❌ Updating straight on `main` instead of a branch — you forfeit the clean-`main` restore point (§2.6, §5.2).
- ❌ Trusting a git branch / clean `main` as the snapshot for a **local-only** (untracked, `.git/info/exclude`)
  kit — git doesn't track it, so nothing is captured; take a physical `ai-kit.bak` copy outside the repo instead.
- ❌ Wholesale-wiping a shared directory (`rm -rf` / `rsync --delete` of `skills/`, `reference/`,
  `templates/`) — nukes project-authored skills, reference docs, templates, and co-located resources at once.
- ❌ Renaming or stripping the `aikit-` prefix on kit skills — the command name *is* the folder name, so
  it breaks discovery and the kit-vs-project distinction this reconcile relies on (see `skills/README.md`).
- ❌ Bumping the Kit version or tagging downstream — versioning is the kit home repo's job.
