# AI Starter Kit

A portable, stack-agnostic operating manual + skills that make any AI coding agent work
predictably on any project — vendored into your repo as a single [`AI/`](AI/) folder.

## What is this?

This repository is the **home of the kit**. The [`AI/`](AI/) folder is the product: you copy it into
your own repo, point your agent at it, and it defines *how* the agent approaches work — not *what*
your project is. Everything outside `AI/` here exists to build and maintain that folder.

The kit is deliberately small enough to load every session, and it's the open
[Agent Skills](https://agentskills.io) format under the hood — so its skills are portable across the
many agents that support it, not tied to any one tool.

## What's in the repo

| Path | What it is |
| --- | --- |
| [`AI/`](AI/) | **The kit** — the only thing vendored downstream. Portable manual, per-project profile, reference docs, skills, and templates. |
| [`AI/README.md`](AI/README.md) | Human guide to *using* the kit on a project (the full setup). |
| [`MAINTAINING.md`](MAINTAINING.md) | How to *evolve* the kit — prime directives, invariants, consistency checks (home-only). |
| [`CHANGELOG.md`](CHANGELOG.md) | Release history; the kit follows SemVer (home-only). |
| [`maintenance/`](maintenance/) | Home-only periodic upkeep — checklists for time-triggered chores (e.g. re-verifying runtime setup facts) + a last-run ledger. Never vendored. |
| [`AGENTS.md`](AGENTS.md) | Entry pointer for an agent working *in this repo* (`CLAUDE.md` symlinks to it). |
| [`LICENSE`](LICENSE) | MIT. |

## Use it in your project

1. Copy the [`AI/`](AI/) folder into your repo's root.
2. Wire the one-line pointer from your agent's root instructions, and make the skills discoverable.
3. Run the bootstrap skill to fill the project profile from your codebase.

Those are the headlines — **follow [`AI/README.md`](AI/README.md) for the exact, current steps.**

## Where to go next

| I want to… | Read |
| --- | --- |
| Adopt / use the kit on a project | [`AI/README.md`](AI/README.md) |
| Understand the agent's operating rules | [`AI/AGENT-INSTRUCTIONS.md`](AI/AGENT-INSTRUCTIONS.md) |
| Evolve or maintain the kit itself | [`MAINTAINING.md`](MAINTAINING.md) |
| Keep the kit's per-runtime setup facts current | [`maintenance/verify-runtime-wiring.md`](maintenance/verify-runtime-wiring.md) |
| See what changed between versions | [`CHANGELOG.md`](CHANGELOG.md) |

## License

[MIT](LICENSE).
