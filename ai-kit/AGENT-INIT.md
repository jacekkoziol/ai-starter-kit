# Wire the AI kit into this repo — agent setup (run once)

> **You are an AI coding agent.** A human dropped the `ai-kit/` kit into this repo and pointed you here to
> **set it up**. Do the steps below, then tell the user to reload — that's the whole job. This file is a
> one-time installer, **not** part of the methodology; the working manual,
> [`AGENT-INSTRUCTIONS.md`](AGENT-INSTRUCTIONS.md), loads on its own once step 2 is wired.
>
> Run from the **repo root** (where `ai-kit/` sits). You'll change two things — one root instruction file and
> one symlink — so **state what you'll do and get a quick go-ahead first**, then do it.

## 1. Identify your runtime

You likely know which agent you are; if not, **ask the user**. It picks two paths — root file and skills
directory — from this table; everything else is identical.

| Runtime | Root file it auto-loads (§2) | Skills directory (§3) |
| --- | --- | --- |
| Claude Code | `CLAUDE.md` (or `AGENTS.md`) | `.claude/skills` |
| Codex | `AGENTS.md` | `.agents/skills` |
| Gemini CLI | `GEMINI.md` | `.gemini/skills` (or the `.agents/skills` alias) |
| Cursor | `AGENTS.md` (or `.cursor/rules`) | `.cursor/skills` |
| GitHub Copilot | `.github/copilot-instructions.md` (or `AGENTS.md`) | `.github/skills` (or `.agents/skills`) |
| Other, has a skills dir | the file it auto-loads | that dir |
| Other, no skills dir | the file it auto-loads | — (invoke skills by path) |

Prefer `AGENTS.md` as the cross-tool standard; if several tools share this repo, point each tool's root
file at the kit — see [`README.md` → Setup step 2](README.md).

## 2. Wire the root pointer

Into that root file (create it if absent), add the one-line pointer that tells you to follow
`ai-kit/AGENT-INSTRUCTIONS.md` and emit its load-confirmation every session — the exact line is in
[`README.md` → Setup step 2](README.md). From a subdirectory whose own root file your tool loads, put the
line there and make the relative path reach the kit; **a path that doesn't resolve fails silently.**

## 3. Wire skill discovery

Most runtimes now support the same `SKILL.md` standard the kit ships and auto-discover skills from a
directory. Link that directory to the kit once — from the repo root, using your row's directory:

```bash
mkdir -p .claude && ln -s ../ai-kit/skills .claude/skills    # Claude Code
mkdir -p .agents && ln -s ../ai-kit/skills .agents/skills    # Codex, Gemini, Copilot (shared .agents alias)
mkdir -p .cursor && ln -s ../ai-kit/skills .cursor/skills    # Cursor
```

That exposes every current and future `ai-kit/skills/*` (`/aikit-plan`, `/aikit-project-profile-bootstrap`, …).
Then **confirm they resolve** (e.g. `/skills` / `/skills list`) — only Codex documents symlink-following,
so if the skills don't appear, or the directory already exists with other skills, **don't clobber it**:
use the per-skill fallback in [`README.md` → Setup step 3](README.md). No skills mechanism? Skip this;
invoke skills by path (`follow ai-kit/skills/<name>/SKILL.md`).

## 4. Report, then hand off

Tell the user exactly what changed (which file got the pointer, which symlink you made), then:

> **Reload the session** so the pointer and skills take effect — they're read only at session start.
> Then run `/aikit-project-profile-bootstrap` (Setup step 4) to fill the project profile.
