# verify-runtime-wiring — are the kit's per-runtime setup facts still current?

> **Home-only chore** (see [`README.md`](README.md)). Cadence: **~weekly**, or whenever you edit the
> wiring facts. Record the run in the [ledger](README.md#ledger) when done.

## Why this exists

[`AI/AGENT-INIT.md`](../AI/AGENT-INIT.md) and [`AI/README.md`](../AI/README.md) tell each AI runtime
where to put the kit's root pointer and how to make its skills discoverable. Those are **external facts
about fast-moving tools** — every one of the five named runtimes changed its skills story within a few
months of first writing. Nothing in the repo *breaks* when they drift; the docs just quietly go wrong
and mislead adopters. This chore re-checks them against the current official docs.

## What the kit currently claims — verify each

For every runtime, confirm the **root instruction file**, the **skills directory** (and any shared alias
like `.agents/skills`), whether it **follows symlinks**, and that it still reads the same `SKILL.md`
(`name` + `description`) the kit ships:

| Runtime | Claimed root file | Claimed skills dir | Official docs to re-check |
| --- | --- | --- | --- |
| Claude Code | `CLAUDE.md` / `AGENTS.md` | `.claude/skills` (follows symlinks) | Claude Code docs → Skills |
| Codex | `AGENTS.md` | `.agents/skills` (follows symlinks) | <https://developers.openai.com/codex/skills> · <https://developers.openai.com/codex/guides/agents-md> |
| Gemini CLI | `GEMINI.md` | `.gemini/skills` / `.agents/skills` | <https://geminicli.com/docs/cli/skills/> |
| Cursor | `AGENTS.md` / `.cursor/rules` | `.cursor/skills` | <https://cursor.com/docs/skills> |
| GitHub Copilot | `.github/copilot-instructions.md` / `AGENTS.md` | `.github/skills` / `.agents/skills` | <https://docs.github.com/en/copilot/concepts/agents/about-agent-skills> · <https://code.visualstudio.com/docs/agent-customization/agent-skills> |

## Checklist

1. **Re-verify each row** against its docs above. Flag any change to root file, skills dir, alias, or
   symlink-following. The symlink caveat matters most: the kit claims *only Codex documents
   symlink-following* — if another runtime now documents it (or Codex stops), that line must change.
2. **Scan for new runtimes** worth naming — ones that adopted the `SKILL.md` standard and currently fall
   under the generic "Other" rows.
3. **Confirm the surfaces still agree.** These mirror the same facts and must not drift apart:
   - [`AI/AGENT-INIT.md`](../AI/AGENT-INIT.md) — the §1 runtime table and the §3 symlink snippet + caveat.
   - [`AI/README.md`](../AI/README.md) — the intro runtime list, Setup step 2's root-file list, and
     Setup step 3's skills table + symlink caveat.
   - Nothing else should hardcode these facts.
4. **Check the canonical-home URL still resolves** — the callout at the top of
   [`AI/skills/aikit-update-kit/SKILL.md`](../AI/skills/aikit-update-kit/SKILL.md).
5. **If anything drifted, fix it** in `AGENT-INIT.md` + `README.md` together, run the relevant
   [`MAINTAINING.md`](../MAINTAINING.md) consistency checks, and — because these edits touch vendored
   `AI/` — **bump the Kit version** (MINOR for a new runtime/fact, PATCH for a correction) and add a
   `CHANGELOG.md` entry.
6. **Record the run:** set this task's *Last run* in the [ledger](README.md#ledger) to today's real
   date. Update it even if nothing changed — the facts were confirmed current.
