---
name: aikit-update-kit
description: Upgrade this project's vendored AI/ kit to a newer version — replace the methodology files while PRESERVING the project's filled PROJECT.md + reference/*.md, then health-check with aikit-project-profile-sync. Use when the kit's home repo has published a newer Kit version than the one in this project's AGENT-INSTRUCTIONS.md header.
---

# Update the vendored kit

> Pulls a newer snapshot of the `AI/` kit into a project that already uses it, **without losing the
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
- The kit's **home repo** (wherever your team vendors `AI/` from) — its changelog / release notes for
  what changed between your version and the latest. If you don't know the source, **ask the user**;
  don't guess a URL.
- [`PROJECT.md`](../../PROJECT.md) + [`reference/`](../../reference/) — the filled content you must
  preserve through the update.

## Procedure

1. **Establish a clean baseline.** Ensure the working tree is committed so the update lands as one
   reviewable diff. Never update over uncommitted changes.
2. **Get the new snapshot.** Obtain the target version's `AI/` from the kit's source. Note its Kit
   version so you can confirm the jump.
3. **Replace the methodology files** (these are kit-owned, safe to overwrite): `AGENT-INSTRUCTIONS.md`,
   `README.md`, `skills/_SKILL-TEMPLATE.md`, every `skills/aikit-*/`, and the `reference/`, `skills/`,
   `templates/` layer-guide `README.md`s — plus any **new** files the version adds.
4. **Reconcile the filled profile — do NOT blanket-overwrite** `PROJECT.md` or `reference/*.md`. They
   hold this project's Role, commands, conventions, and `fill:`-marked answers. For each **new or
   renamed managed slot / fillable field** the new version introduces, splice the new scaffolding
   (with its `fill:` marker) into your filled doc and leave existing answers intact. When unsure
   whether a block is kit scaffolding or a project answer, keep the project answer and flag it.
5. **Run [`aikit-project-profile-sync`](../aikit-project-profile-sync/SKILL.md).** It health-checks the
   merged kit (pointer wired, no leftover placeholders, references resolve, `fill:` markers valid,
   index↔folder parity) and re-validates `fill:auto` values against the repo. Fix what it flags.
6. **Confirm the version.** The session-start handshake should now read the new `v{version}` (from the
   updated `AGENT-INSTRUCTIONS.md` header).
7. **Review the full diff and commit** per the project's version-control policy (§2.6). Summarize what
   changed and any slots you had to reconcile by hand.

## Verify

- [ ] `AGENT-INSTRUCTIONS.md` header shows the **new** Kit version.
- [ ] `PROJECT.md` + `reference/*.md` keep every prior project answer; new slots added with markers.
- [ ] `aikit-project-profile-sync` reports healthy (no leftover placeholders, links resolve, markers valid).
- [ ] The diff is reviewable and committed; nothing under `AI/` references the kit's home-only files.

## Anti-patterns

- ❌ Overwriting a filled `PROJECT.md` / `reference/*.md` with the new version's blank scaffold — that
  silently deletes the project's answers.
- ❌ Updating without then running `aikit-project-profile-sync` (drift goes unnoticed).
- ❌ Updating over a dirty tree, so the change isn't a clean reviewable diff.
- ❌ Renaming or stripping the `aikit-` prefix on kit skills — the command name *is* the folder name, so
  it breaks discovery and the kit-vs-project distinction this reconcile relies on (see `skills/README.md`).
- ❌ Bumping the Kit version or tagging downstream — versioning is the kit home repo's job.
