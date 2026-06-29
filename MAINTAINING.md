# Maintaining the AI kit

> Instructions for an AI agent (or human) **changing the `AI/` kit itself** — adding or editing rules,
> fields, skills, reference docs, or templates.
>
> **This file is not part of the kit.** It lives *outside* `AI/` on purpose: the `AI/` folder gets
> vendored into other repos, and this guide must never ride along — it belongs only in the kit's home
> repo (sibling to `AI/`). It's also distinct from [`AI/AGENT-INSTRUCTIONS.md`](AI/AGENT-INSTRUCTIONS.md),
> which tells an agent how to *use* the kit on a project; this tells you how to *evolve* the kit.
>
> **Before changing anything,** read [`AI/AGENT-INSTRUCTIONS.md`](AI/AGENT-INSTRUCTIONS.md) and
> [`AI/README.md`](AI/README.md) so you know the current shape.

## Session-start handshake

Open your **first reply** in any session working in this repo with one line confirming this guide
loaded — emitted *only because you actually read it*, which is what makes its presence meaningful, so
never fabricate it:

`✅ MAINTAINING.md loaded — maintaining the AI kit; honoring its prime directives & invariants.`

Emit it once per session, in every response mode. (Mirrors the kit's own session-start handshake in
[`AI/AGENT-INSTRUCTIONS.md`](AI/AGENT-INSTRUCTIONS.md), which confirms the *vendored* kit loaded — this one
confirms the *maintenance* guide loaded.)

## Prime directives

1. **Stay lean — every addition must earn its place.** The kit's value is that it's short enough to
   load every session. Default to *no* change; prefer trimming. Add only what fixes a real,
   demonstrated failure — reject nice-to-haves. "Do not oversize" is the standing constraint.
2. **Keep the portable manual stack- and tool-agnostic.** `AGENT-INSTRUCTIONS.md` must contain nothing
   project-, stack-, or vendor-specific (no WordPress, no Chisel, no single tool). Project specifics
   live in `PROJECT.md`; the manual references them only generically.
3. **Honor the "how vs what" split — decide the layer before you write.** Portable behavior →
   `AGENT-INSTRUCTIONS.md`. Per-project config/knobs → `PROJECT.md`. Descriptive project facts →
   `reference/`. Repeatable procedures → `skills/`. Copy-me scaffolds → `templates/`.
4. **Single source of truth — don't duplicate.** State each rule once, in its owning layer, and
   reference it elsewhere by `§N`. The manual is canonical for behavior; the README explains for
   humans; reference holds project facts. A rule restated in two places drifts.
5. **Dogfood the kit.** Maintain it *using* its own loop — understand → scope → plan → get the user's
   sign-off → implement → verify — and apply its honesty, gate, and verification rules to your changes.
6. **Adversarially check new behavioral rules.** Before shipping any rule that constrains the agent,
   try to rules-lawyer it: can it be read to skip the gate, hide a risk/failure, alter code, be
   dishonest, or weaken another HARD RULE? Close the loophole in the fewest words.

## Layout

```
AI/                       # THE KIT — this is what gets copied into other repos
  AGENT-INSTRUCTIONS.md   #   portable behavioral manual (§0–§9) — stack/tool-agnostic
  PROJECT.md              #   per-project profile + knobs (Role, Response economy, Commands,
                          #     Integrations, Version control, …) — the only place knobs live
  README.md               #   human guide (what it is, Setup, how to extend)
  reference/              #   descriptive project facts (the "what") + index
  skills/                 #   repeatable procedures (folder-per-skill: {name}/SKILL.md) + index
  templates/              #   literal copy-me scaffolds + index
MAINTAINING.md            # this file — stays OUTSIDE AI/, never vendored downstream
ai-progress/              # runtime work-tracking, created per project at the root — not part of the kit
```

## When you change X, also touch Y (keep in sync)

| Change | Also update |
| --- | --- |
| **New per-project knob / fillable field** (PROJECT.md or reference) | `bootstrap-project-profile` (detect-or-ask step **+** a Verify item **+** the frontmatter `description`), and the relevant README surface (folder map / "What's in here" / "How to extend"). |
| **New behavioral rule** | The right `AGENT-INSTRUCTIONS.md` section; mark **HARD RULE** if it's a guardrail; add an §8 anti-pattern if it's a common mistake. |
| **New recurring procedure** | `skills/{name}/SKILL.md` (folder-per-skill) **+** `skills/README.md` index. |
| **New project-fact category** | `reference/{doc}.md` **+** `reference/README.md` index; route to its skill at the bottom. |
| **New scaffold** | `templates/{file}` **+** `templates/README.md` index. |
| **New manual section** | Append as the next `§N` — **never renumber** existing sections. |
| **Renamed / added / removed file** | The README **folder map** and the **"What's in here"** table. |

The most-missed one: **adding a fillable field without wiring `bootstrap-project-profile`** — then adoption leaves it blank. A new field is only "done" when bootstrap fills-or-asks it and a Verify item guards it.

## Invariants (don't break)

- **Append, never renumber** manual sections. Renumbering breaks every `§N` cross-reference (in the
  manual, PROJECT.md, the skill, and the README) and any past references.
- **Behavioral knobs** (Role, response-economy mode) live **only** in `PROJECT.md`; the manual points
  at them, never embeds them.
- **Mode names are exactly** `standard | concise | terse` — everywhere, no drift.
- **HARD RULEs may be tightened, never weakened** — e.g. economy-never-overrides-substance, secrets,
  reuse-before-building, the plan-review gate.
- **The session-start handshake stays self-verifying** — emitted only because the instruction was
  actually read; never a fabricated banner.
- **All relative links resolve**, and the README folder map matches the real tree.
- **No project / stack / tool terms** in the portable files (`AGENT-INSTRUCTIONS.md`, the README's
  generic parts, the reference/skills/templates guides).
- **`<!-- To Remove -->` blocks are disposable examples** — the only place concrete stack examples may
  appear (in `PROJECT.md`). `bootstrap-project-profile` deletes them on adoption; consistency-check #1
  strips them before grepping.

## Consistency checks (run after any change)

```bash
# 1. Portability — no stack/tool coupling leaked into the kit
#    (concrete examples allowed only inside <!-- To Remove --> blocks; stripped here before grep)
find AI -name '*.md' -exec sed '/To Remove: START/,/To Remove: End/d' {} + \
  | grep -niE "wordpress|wp-content|chisel|gutenberg|timber|theme\.json"          # expect: none

# 2. Manual sections sequential, none renumbered
grep -nE "^## [0-9]" AI/AGENT-INSTRUCTIONS.md                                     # expect: 0..9 in order

# 3. Every cross-reference still resolves (eyeball the §N you touched)
grep -rn "§[0-9]" AI/

# 4. Mode names consistent
grep -rnoE "\`(standard|concise|terse)\`" AI/                                     # expect: only these three

# 5. Fill-in TODOs only where intended (fill-in surfaces, not stray scaffolding)
grep -rl "TODO" AI/ | grep -vE "README|_SKILL-TEMPLATE|bootstrap-project-profile" # expect: PROJECT.md + reference/*

# 6. Folder map matches reality
find AI -maxdepth 2 -type f | sort                                                # compare to README's folder map
```

## Anti-patterns (kit maintenance)

- ❌ Adding words that don't fix a demonstrated failure (bloat).
- ❌ Coupling `AGENT-INSTRUCTIONS.md` to a stack, tool, or this repo.
- ❌ Restating one rule in multiple files instead of referencing it.
- ❌ Adding a fillable field without wiring `bootstrap-project-profile` + a Verify item.
- ❌ Renumbering manual sections after inserting one (insert at the end instead).
- ❌ Letting the README folder map drift from the real files.
- ❌ Weakening a HARD RULE for the sake of brevity.
- ❌ Putting maintenance/meta content inside `AI/` (it would ship into every downstream project).
