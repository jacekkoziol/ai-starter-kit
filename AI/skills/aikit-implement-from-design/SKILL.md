---
name: aikit-implement-from-design
description: Translate a visual design source (mockup, screenshot, exported spec, or design-tool reference) into this project's code — tool-agnostic. Extract the design's decisions, map them onto the project's EXISTING tokens and components (reuse first), build structure-before-style, then verify visual parity. Use when implementing a UI/screen/component from a design rather than from prose.
---

# Implement from a design

> The tool-agnostic procedure for turning a visual design into code. It names **no** design vendor —
> to wire a *specific* tool (one with an API/MCP that extracts tokens, components, or code), a project
> authors its own thin skill from [`../../templates/design-tool-skill.md`](../../templates/design-tool-skill.md)
> that feeds this one its extracted decisions. This skill owns the flow; the tool skill owns extraction.
> It references the manual rather than restating it: reuse (§3), phase ordering (§4.5), verification (§7).

## When to use

- Implementing a screen, view, component, modal, or section **from a visual source** — a mockup,
  screenshot, exported design spec, or a design-tool link.
- After scoping the work with [`aikit-plan`](../aikit-plan/SKILL.md) (a multi-section screen is a
  multi-phase effort: one phase per section).

## Read first

- [`PROJECT.md`](../../PROJECT.md) — where the project's **design tokens** (color/space/type scales)
  and **components** live, and the build/preview/test commands.
- [`reference/`](../../reference/) — file locations and conventions for the layer you'll touch.
- [`AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) §3 (reuse), §4.5 (phase ordering), §7 (verify).

## Procedure

1. **Ingest the design — capture every concrete decision, don't eyeball.** List the layout/structure,
   spacing, colors, typography, component instances, **states** (hover/active/focus/empty/error/
   loading), and responsive behavior. Missing a state now means rework later.
2. **Map to what already exists first (§3).** For each value the design needs, find the project's
   existing **token** (don't hardcode a hex/px that already has one) and existing **component** (reuse
   or extend a variant before creating new). Only a genuinely-new shape gets built — modeled on its
   closest sibling. Record gaps where the design needs a token/component that doesn't exist yet.
3. **Build in anti-rework order (§4.5):** foundations/tokens → structure/markup → presentation/styling
   → behavior/interactivity. **Don't style before the structure stabilizes.**
4. **Work section by section.** Flip each `aikit-plan` phase as you go; keep changes scoped to the
   section in flight.
5. **Verify parity, then run §7.** Compare the rendered result to the design source (use the project's
   preview/build), reconcile spacing/type/color against the captured decisions, then run
   build/test/lint and re-read the diff. Report any intentional deviations.

## Specializing to a design tool

If your design lives in a tool with an extraction API/MCP, **don't** put tool calls here — copy
[`../../templates/design-tool-skill.md`](../../templates/design-tool-skill.md) into a project-authored
skill (e.g. `skills/{tool}-to-code/SKILL.md`) that performs step 1's extraction in that tool's terms,
then hands the decisions to this skill. Keeps this procedure vendor-neutral and reusable.

## Verify

- [ ] Tokens **reused**, not hardcoded; new components modeled on the closest sibling (§3).
- [ ] Built structure-before-style; no styling landed before structure stabilized (§4.5).
- [ ] Visual parity checked against the source; deviations called out.
- [ ] Build/test/lint ran (or the lightest real check, per §7); diff matches the plan.

## Anti-patterns

- ❌ Hardcoding a value that already has a design token.
- ❌ Creating a new component when a variant of an existing one fits (§3).
- ❌ Styling pixel-by-pixel before the structure/markup is settled.
- ❌ Embedding a specific design tool's API calls here instead of in a downstream tool skill.
- ❌ Claiming done without a parity check against the source.
