# Coding Conventions (project)

> The **generic** conventions (match the neighbors, single source of truth, reuse the helper layer,
> tokenize repeated values, no hidden hacks, touch only what the task needs) live in
> [`../AGENT-INSTRUCTIONS.md` §6](../AGENT-INSTRUCTIONS.md). This file records the conventions specific
> to **this** project. Fill the `TODO`s; delete what doesn't apply.

## Languages & style

- TODO — language(s) + version, and the style guide / linter config that is the **source of truth**
  (the agent adheres to the config, not to assumptions).
- TODO — formatter, and whether the agent runs it or you do.

## Naming

- TODO — file naming, identifier casing, component/class/module prefixes, test naming.

## Layers / boundaries

- TODO — "edit here" vs "never edit" (vendor / generated / core).
- TODO — generated files that must not be hand-edited, and what regenerates them.

## Single source of truth

- TODO — where shared constants / tokens / config / types live, and the accessor to use instead of
  hardcoding or re-declaring.

## HARD RULES

List conventions whose violation causes silent failures or production bugs. The agent treats these as
non-negotiable.

- TODO.

---

→ routes to skill: _(add one in [../skills/](../skills/) when a recurring procedure emerges)_
