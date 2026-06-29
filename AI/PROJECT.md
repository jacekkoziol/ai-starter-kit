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
> Example: "You are a senior WordPress developer adapting the Chisel starter theme to a target spec.
> The starter is scaffolding, not the deliverable — match the spec exactly and overwrite base styles
> that diverge; don't preserve starter defaults for their own sake."

- TODO — one paragraph: `You are a {seniority} {domain} developer/engineer` working on {the mandate},
  plus the key mental model to hold (what to match exactly, what to overwrite, what NOT to preserve).

## Response economy

> How verbose the agent is in conversation — token economy. One of `standard` | `concise` | `terse`,
> defined in [AGENT-INSTRUCTIONS.md](AGENT-INSTRUCTIONS.md) §9. Set during bootstrap; override any time
> in chat ("be terse" / "go standard").

- **Mode:** `concise`  <!-- standard | concise | terse -->

## Overview

- **What this project is:** TODO — one paragraph: the product, who uses it, the shape of the codebase.
- **Stack & versions:** TODO — language(s), framework(s), runtime/tooling versions.

## Commands

The agent's verification (AGENT-INSTRUCTIONS.md §7) is only as good as these. State whether the agent
runs them itself or asks you to.

| Action | Command | Who runs it |
| --- | --- | --- |
| Install deps | `TODO` | |
| Dev / run | `TODO` | |
| Build | `TODO` | |
| Test | `TODO` | |
| Lint | `TODO` | |
| Format | `TODO` | |

## Integrations & tools (MCP, CLIs, services)

> External capabilities the agent should prefer over improvising — plus any **mandated** channel and
> what to do if a required tool is missing.

- **Available:** TODO — MCP servers / tools (see `.mcp.json`), CLIs, service integrations.
- **Mandated channels:** TODO — e.g. "all DB/content writes go through {tool}; never raw SQL / manual edits."
- **If a mandated tool is missing:** STOP and ask — don't improvise a raw fallback (AGENT-INSTRUCTIONS.md §5.2).

## Version control

> The agent's git behavior for code changes. Push / PR / deploy are always stop-and-ask
> (AGENT-INSTRUCTIONS.md §5.2).

- **Branch:** TODO — e.g. never commit to `{main}`; branch as `{prefix}/{ticket}-{slug}`.
- **Commit:** TODO — e.g. one commit per completed phase, after verify.
- **PR:** TODO — who opens it, target branch.

## Conventions

Details in [reference/coding-conventions.md](reference/coding-conventions.md). Headlines:

- TODO — the few rules that matter most.

## Layout

Details in [reference/file-locations.md](reference/file-locations.md). Headlines:

- **Edit here:** TODO — where project code lives.
- **Never edit:** TODO — vendor / generated / core layers and what regenerates them.

## Locked decisions

Settled architectural choices the agent should treat as given (don't relitigate):

- TODO.

## Glossary (optional)

- **TODO term** — TODO meaning.
