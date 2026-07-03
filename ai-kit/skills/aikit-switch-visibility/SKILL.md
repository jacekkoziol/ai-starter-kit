---
name: aikit-switch-visibility
description: Switch the installed ai-kit/ kit between shared (committed & pushed with the repo) and local-only (kept on this machine via .git/info/exclude) — untracking/re-tracking the kit, ai-progress/, the kit-only root pointer, and the skills symlinks together, updating PROJECT.md's Config-visibility Mode, and surfacing the team-impact warnings (a pushed kit disappears from the remote when untracked; sharing makes PROJECT.md team-visible). Use when the user wants to flip the kit's Config visibility after adoption.
---

# Switch Config Visibility

Flips an installed kit between **`shared`** and **`local-only`** (`PROJECT.md` → "Config visibility")
— moving **all four kit artifacts together**: `ai-kit/`, `ai-progress/`, the **kit-only** root pointer
file, and the **skills symlinks** (`.claude/skills` / `.agents/skills` / …). Forgetting one leaves a
broken half-state (e.g. a committed symlink pointing into a folder teammates don't have).

## When to use

- The user asks to make the kit local-only ("stop pushing the AI config") or to share a previously
  personal kit with the team.
- **Not** for first adoption — bootstrap step 12 sets the initial mode; this skill changes it later.

## Read first

- [`../../PROJECT.md`](../../PROJECT.md) → "Config visibility" — the Mode field this skill flips.
- [`../../AGENT-INSTRUCTIONS.md`](../../AGENT-INSTRUCTIONS.md) **§5.2** (stop-and-ask) and **§2.6**
  (commit gate) — both apply: every step below that touches the repo goes through them.

## Procedure

### 0. Establish the real current state

Trust git over the field (§1): check what's actually tracked (`git ls-files ai-kit/ | head -3`), what's
excluded (`git check-ignore -v ai-kit/ ai-progress/ .claude/skills`, …), and whether the kit was ever
**pushed**. If `PROJECT.md`'s Mode disagrees with reality, say so — the switch starts from reality,
and the field is corrected below. Inventory the four artifacts: `ai-kit/` · `ai-progress/` · the root
pointer file (**kit-only**, or shared with team content?) · every skills symlink Setup step 3 created.

### To `local-only` (from `shared`)

1. **If the kit was ever pushed: STOP and ask (§5.2).** Untracking creates a commit that **deletes
   the kit from the remote for every teammate** — they lose the manual, profile, and skills on next
   pull. Get explicit confirmation of that team impact before proceeding.
2. **Untrack, keeping the files:** `git rm --cached -r ai-kit/ ai-progress/` (skip paths never
   tracked), plus the root pointer **only if it's kit-only**, plus each skills symlink
   (`git rm --cached .claude/skills`, …).
3. **Exclude:** add the same paths to `.git/info/exclude` (per-clone, never committed) — `ai-kit/`,
   `ai-progress/`, the kit-only pointer, each symlink.
4. **Shared root file?** If the pointer line lives in a team file (an `AGENTS.md` with other
   content), it stays team-visible and **dangles** for teammates without the kit — surface the
   tradeoff and let the user choose: leave it, or move it to a mechanism only this machine loads.
5. **Update the Mode field** → `local-only` (`fill:user` — the user just decided).
6. **Commit the untracking** per the gate (§2.6) — the removal commit is itself team-visible.

### To `shared` (from `local-only`)

1. **Review `(runtime-only)` Integrations entries first:** sharing makes `PROJECT.md` team-visible —
   personal servers documented there may not belong. Ask per entry: keep, drop, or promote into the
   project tool config.
2. **Un-exclude:** remove the kit's lines from `.git/info/exclude`.
3. **Track:** `git add` `ai-kit/`, the pointer, the symlinks (`ai-progress/` joins when it exists).
4. **Update the Mode field** → `shared`.
5. **Commit** per the gate (§2.6), on a branch per the project's version-control policy.

## Verify

- [ ] `git check-ignore` / `git status` confirm the intended end state for **all four artifacts** —
      no half-state (e.g. excluded kit but still-tracked symlink).
- [ ] `PROJECT.md` → Config visibility Mode matches the new reality.
- [ ] The kit's skills still resolve in the runtime (symlinks intact either way).
- [ ] Local-only: nothing kit-related remains tracked · Shared: kit + pointer + symlinks staged/committed.
- [ ] Where applicable, the user explicitly confirmed the pushed-kit removal (→ local-only) or
      reviewed the `(runtime-only)` entries (→ shared).

## Anti-patterns

- ❌ Adding exclude lines while the paths are still tracked — `.git/info/exclude` only affects
  **untracked** files; the switch silently does nothing.
- ❌ Untracking the kit but forgetting the skills symlinks or the kit-only pointer (broken half-state).
- ❌ Untracking a **pushed** kit without the explicit team-impact confirmation (§5.2).
- ❌ Flipping the files but leaving `PROJECT.md`'s Mode field stale.
- ❌ Going shared without reviewing `(runtime-only)` entries first.
