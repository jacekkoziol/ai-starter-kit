# `example-instructions/`: a sample project's AI setup (home-only)

> **Home-only, never vendored.** Like `MAINTAINING.md` and `BACKLOG.md`, this folder lives outside
> `ai-kit/` and must never be copied downstream. It is **reference material, not instructions**: nothing
> here applies to work in this repo.

An anonymized snapshot (taken 2026-11-18) of the AI-instruction files of a real project that does
**not** use this kit: a Rails monolith on GitLab with stacked merge requests, git worktrees for
parallel agent sessions, and an automated review bot. [`BACKLOG.md`](../BACKLOG.md) cites these files
as the source of several proposals, so they can be checked without access to the original project.

## Rules for this folder

- **Snapshot: don't edit the content.** Fix only anonymization slips. To refresh it, replace the whole
  folder and update the date above.
- **Anonymized.** Product, company and host names are replaced with `Sample` / `ExampleCo` /
  `example.com` placeholders. Environment files, secrets and credentials were never copied. The seeded
  development accounts in `AGENTS.sample.md` are placeholders from the project's seed file.
- **Kept inert on purpose.** Agent runtimes load `AGENTS.md`, `.agents/`, `.claude/` and `.mcp.json`
  automatically, even in subfolders for some runtimes. Those files are renamed here, so no tool picks
  them up as live instructions, skills, hooks or MCP servers:

| Original path in the project | Copy here |
| --- | --- |
| `AGENTS.md` | [`AGENTS.sample.md`](AGENTS.sample.md) |
| `.agents/skills/` (also exposed as `.claude/skills` via a symlink) | [`_agents/skills/`](_agents/skills/) |
| `.claude/settings.json`, `.claude/hooks/` | [`_claude/`](_claude/) |
| `.mcp.json` | [`mcp.json`](mcp.json) |

Every other file keeps its original path. **Paths inside the copied files are the originals** (for
example `.agents/skills/...`). Read them through the table above.

## What's here

| Path | What it shows |
| --- | --- |
| `AGENTS.sample.md` | The root agent file: a short "where to read" router, the plan → build → verify → report workflow with diff-size estimates and slice splits, commands, communication style, git rules, Definition of done. |
| `CODING_STANDARDS.md`, `GLOSSARY.md` | Project rules and the domain glossary (`_Avoid_` lists, flagged ambiguities). |
| `_agents/skills/review-mr-feedback/` | A skill that answers merge-request review threads, with a script that normalizes the threads (`threads.sh` + `threads.jq`). |
| `_agents/skills/domain-modeling/` | A skill that keeps the glossary current. |
| `_claude/` | Runtime settings and hooks: session start, worktree create/remove, worktree setup script. |
| `bin/gs`, `bin/glab`, `bin/url` | CLI wrappers (pinned versions, token loading) and the per-worktree URL helper. |
| `docs/` | The guides the root file routes to: worktrees, merge requests (stacking and automated review), ADRs (`decisions/`), content images, personal data. |
| `lefthook.yml`, `mcp.json` | Pre-commit hooks and the MCP server list. |

**Not copied:** the project's human `README.md` (dev-container and infrastructure details), topic guides
that hold only product rules (styles, forms, emails, marketing pages), runbooks, generated docs, and all
environment files.
