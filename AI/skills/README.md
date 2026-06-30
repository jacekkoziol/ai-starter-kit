# Skills — the "how"

A **skill** is an ordered, repeatable procedure for a recurring task in this project ("add an
endpoint", "create a migration", "scaffold a component"). It assumes its matching
[reference](../reference/) doc has been read, and focuses on **steps + code to copy**, not
description.

## When to add one

When the same multi-step task recurs and the agent keeps doing it slightly differently. Capture the
correct sequence once, then point future work at it.

## Format & discovery

One folder per skill: `skills/{name}/SKILL.md`. This matches the convention agent runtimes use to
**auto-discover** skills (e.g. Claude Code exposes each as a `/{name}` command). Start from
[`_SKILL-TEMPLATE.md`](_SKILL-TEMPLATE.md) — copy it to `skills/{name}/SKILL.md` and fill it in.

A good skill: names its triggers, lists the reference it assumes, gives numbered steps, ends with a
verification checklist and the anti-patterns to avoid.

## Index

| Skill | When to use |
| --- | --- |
| [aikit-plan](aikit-plan/SKILL.md) | Stand up / maintain `ai-progress/` (INDEX + per-effort roadmap + per-phase files) for non-trivial work — at the start of an effort, when starting/finishing a phase, hitting a blocker, or resuming cold. Walks the procedure for `AGENT-INSTRUCTIONS.md` §4. |
| [aikit-implement-from-design](aikit-implement-from-design/SKILL.md) | Translate a visual design source (mockup, screenshot, exported spec, design-tool reference) into code — tool-agnostic: extract decisions → reuse existing tokens/components (§3) → structure-before-style (§4.5) → verify parity (§7). Specialize per tool via `templates/design-tool-skill.md`. |
| [aikit-update-kit](aikit-update-kit/SKILL.md) | Upgrade this project's vendored `AI/` kit to a newer version — replace the methodology files while preserving the filled `PROJECT.md` + `reference/*.md`, then run `aikit-project-profile-sync`. |
| [aikit-project-profile-bootstrap](aikit-project-profile-bootstrap/SKILL.md) | First adoption / refresh — analyze the codebase and fill the `TODO`s in `PROJECT.md` + `reference/*.md` with evidence-backed values. |
| [aikit-project-profile-sync](aikit-project-profile-sync/SKILL.md) | Health-check the installed kit (pointer wired · no stray `TODO`/`<!-- To Remove -->` · valid mode · references resolve · index↔folder parity) **and** correct drift — re-validate each `fill:auto` value against its cited evidence source and propose updates; re-ask `fill:user` values. Run periodically; complements `aikit-project-profile-bootstrap` (the first fill). |
