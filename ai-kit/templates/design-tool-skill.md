<!-- TEMPLATE — copy to <your-repo>/ai-kit/skills/{tool}-to-code/SKILL.md, fill it in, and DELETE
     this whole comment block in the copy: the `---` frontmatter must be the FIRST thing in the
     file, or skill discovery silently skips it.
     This scaffolds a PROJECT-AUTHORED (unprefixed) skill that wires ONE specific design tool to the
     kit's stack-agnostic `aikit-implement-from-design`. Tool/stack-specific terms ARE fine in the
     copy you make — it lives in YOUR project, not the portable kit. The relative links below are
     written for the copied location (`skills/{tool}-to-code/SKILL.md`), so they resolve once copied. -->

---
name: {tool}-to-code
description: One line — translate {tool} designs into this project's code; name the trigger that should invoke it.
---

# {Tool} → code

> Specializes the kit's [`aikit-implement-from-design`](../aikit-implement-from-design/SKILL.md) for
> **{tool}**. That skill owns the generic flow (ingest → reuse tokens/components → structure-before-
> style → verify parity); this skill owns **how to extract the design's decisions out of {tool}** and
> map them to this project's design system.

## When to use

- TODO — the trigger, e.g. "a {tool} link/URL is provided" or "implement a screen from {tool}".

## Read first

- [`aikit-implement-from-design`](../aikit-implement-from-design/SKILL.md) — the generic design→code flow.
- `ai-kit/PROJECT.md` — this project's design-token + component locations and build/preview commands.

## Procedure

1. **Pull the design context from {tool}.** TODO — the exact tool calls / exports and what each yields.
<!-- To Remove: START (Figma worked example — delete or adapt for your tool) -->
   - Figma MCP: `get_metadata` (node tree + structure), `get_variable_defs` (design tokens:
     color/space/type), `get_design_context` + `get_code_connect_map` (component → code mappings),
     `get_screenshot` (the visual-parity reference). Record the file key and root node id.
<!-- To Remove: End -->
2. **Translate tokens → project tokens.** Map each {tool} variable to the project's existing token
   (reuse first — §3). TODO — your token file(s) and naming convention.
3. **Map components.** TODO — match {tool} components to the project's component layer; note any
   mapping table the tool maintains.
4. **Hand off to `aikit-implement-from-design`** with the extracted decisions; build in §4.5 order.
5. **Verify parity** against the screenshot/spec, then run the project's build/test/lint (§7).

## Verify

- [ ] TODO — tokens mapped (not hardcoded), components reused, parity checked, build/test/lint green.

## Anti-patterns

- ❌ Hardcoding {tool} values that already have project tokens.
- ❌ Re-deriving the generic flow here instead of deferring to `aikit-implement-from-design`.
