# Project Profile

> The project-specific **"what"** that the generic manual ([AGENT-INSTRUCTIONS.md](AGENT-INSTRUCTIONS.md))
> binds to. The manual says *how to work*; this file says *what this project is*. Keep it short and
> current — the agent reads it at session start. Fill the `TODO`s; delete rows that don't apply.

## Role

> The agent's project-specific identity and mandate — its seniority, domain, and mission on THIS
> project. The generic "you are a senior engineer" stance lives in
> [AGENT-INSTRUCTIONS.md](AGENT-INSTRUCTIONS.md) §0; this **sharpens** it for this codebase and names
> the project's defining tension (what to match exactly, what to overwrite, what to preserve). One
> short paragraph. Delete this section if the generic stance is enough.
>
> Example: "You are a senior frontend developer adapting a starter theme to a target design spec.
> The starter is scaffolding, not the deliverable — match the spec exactly and overwrite base styles
> that diverge; don't preserve starter defaults for their own sake."

<!-- To Remove: START — concrete Role examples for reference. Delete this whole block once you've written your Role above (aikit-project-profile-bootstrap removes it automatically). -->
> **Example (WordPress + Chisel):** "You are a senior WordPress developer adapting the Chisel starter
> theme to a target spec. The starter is scaffolding, not the deliverable — match the spec exactly and
> overwrite base styles that diverge; don't preserve starter defaults for their own sake."
>
> **Example (Angular):** "You are a senior Angular developer building features in an existing app.
> Match the project's module/component conventions, reuse shared services and components before
> creating new ones, and keep state and data-access in the established services — don't bypass them
> with ad-hoc calls in components."
<!-- To Remove: End -->

- TODO — one paragraph: `You are a {seniority} {domain} developer/engineer` working on {the mandate},
  plus the key mental model to hold (what to match exactly, what to overwrite, what NOT to preserve).  <!-- fill:user -->

## Response economy

> How verbose the agent is in conversation — token economy. One of `standard` | `concise` | `terse`,
> defined in [AGENT-INSTRUCTIONS.md](AGENT-INSTRUCTIONS.md) §9. Set during bootstrap; override any time
> in chat ("be terse" / "go standard").

- **Mode:** `concise`  <!-- standard | concise | terse -->  <!-- fill:user -->

## Overview

- **What this project is:** TODO — one paragraph: the product, who uses it, the shape of the codebase.  <!-- fill:auto · harvested instruction sources (README / CONTRIBUTING / agent docs) -->
- **Stack & versions:** TODO — language(s), framework(s), runtime/tooling versions.  <!-- fill:auto · dependency manifest + pinned-runtime files -->

## Commands

The agent's verification (AGENT-INSTRUCTIONS.md §7) is only as good as these. State whether the agent
runs them itself or asks you to.

| Action | Command | Who runs it |
| --- | --- | --- |
| Install deps | `TODO` | <!-- fill:auto · package scripts / Makefile / CI --> |
| Dev / run | `TODO` | <!-- fill:auto · package scripts / Makefile / CI --> |
| Build | `TODO` | <!-- fill:auto · package scripts / Makefile / CI --> |
| Test | `TODO` | <!-- fill:auto · package scripts / Makefile / CI --> |
| Lint | `TODO` | <!-- fill:auto · package scripts / Makefile / CI --> |
| Format | `TODO` | <!-- fill:auto · package scripts / Makefile / CI --> |

## Integrations & tools (MCP, CLIs, services)

> External capabilities the agent should prefer over improvising — plus any **mandated** channel and
> what to do if a required tool is missing.

- **Available:** TODO — MCP servers / tools (see `.mcp.json`), CLIs, service integrations.  <!-- fill:auto · tool config (.mcp.json / editor MCP) -->
- **Mandated channels:** TODO — e.g. "all DB/content writes go through {tool}; never raw SQL / manual edits."  <!-- fill:user -->
- **If a mandated tool is missing:** STOP and ask — don't improvise a raw fallback (AGENT-INSTRUCTIONS.md §5.2).

## Version control

> The agent's git behavior for code changes. Push / PR / deploy are always stop-and-ask
> (AGENT-INSTRUCTIONS.md §5.2).

- **Branch:** TODO — e.g. never commit to `{main}`; branch as `{prefix}/{ticket}-{slug}`.  <!-- fill:user -->
- **Commit:** TODO — e.g. one commit per completed phase, after verify.  <!-- fill:user -->
- **PR:** TODO — who opens it, target branch.  <!-- fill:user -->

## Conventions

Details in [reference/coding-conventions.md](reference/coding-conventions.md). Headlines:

- TODO — the few rules that matter most.  <!-- fill:auto · linter & formatter configs -->

## Layout

Details in [reference/file-locations.md](reference/file-locations.md). Headlines:

- **Edit here:** TODO — where project code lives.  <!-- fill:auto · file tree -->
- **Never edit:** TODO — vendor / generated / core layers and what regenerates them.  <!-- fill:auto · file tree + .gitignore -->

## Locked decisions

Settled architectural choices the agent should treat as given (don't relitigate):

- TODO.  <!-- fill:user -->

## Project-specific rules

> Free-form house rules the agent must follow on THIS project that don't fit the sections above —
> e.g. "feature-flag all new UI", "run the formatter before every commit", "every new endpoint needs
> an integration test". Keep them short; move anything detailed into a [reference/](reference/) doc and
> link it. **Record them here, never in [AGENT-INSTRUCTIONS.md](AGENT-INSTRUCTIONS.md)** — the manual is
> replaced wholesale by `aikit-update-kit`, while this file is preserved. **Append-only:** new rules
> surface over time, so keep this section and the placeholder below even once filled — it's their
> durable, update-safe home.

<!-- Add each rule as its own bullet as it emerges; keep the placeholder bullet so there's always a spot. -->

- _Add project-specific rules here as they emerge._  <!-- fill:user -->

## Glossary (optional)

- **TODO term** — TODO meaning.
