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
7. **Commit only on an explicit go-ahead — ask first.** Once a change is implemented and verified,
   don't commit or push on your own initiative: report that it's ready and **ask whether to commit it
   now or review first**, then act only on the answer — silence isn't approval. Direct commits to
   `main` are fine in *this* home repo (kit maintenance lives on `main`); the vendored *"never commit
   to the default branch directly"* rule (`AGENT-INSTRUCTIONS.md` §2) is about *downstream* use, not
   the work here — but the ask still applies every time.

## Layout

```
AI/                       # THE KIT — this is what gets copied into other repos
  AGENT-INSTRUCTIONS.md   #   portable behavioral manual (§0–§9) — stack/tool-agnostic
  PROJECT.md              #   per-project profile + knobs (Role, Response economy, Commands,
                          #     Integrations, Version control, …) — the only place knobs live
  README.md               #   human guide (what it is, Setup, how to extend)
  reference/              #   descriptive project facts (the "what") + index
  skills/                 #   repeatable procedures (folder-per-skill; kit-shipped: aikit-{name}/SKILL.md) + index
  templates/              #   literal copy-me scaffolds + index
README.md                 # human front-door for the repo (quickstart + doc routing) — home-only, never vendored
MAINTAINING.md            # this file — stays OUTSIDE AI/, never vendored downstream
ai-progress/              # runtime work-tracking, created per project at the root — not part of the kit
```

## The `fill:` marker convention

Every **managed slot** in `AI/PROJECT.md` and `AI/reference/*.md` — a value the project owner or the
agent must supply — carries a persistent HTML-comment marker naming **who fills it** and, for
evidence-backed ones, **the source to re-check it against**:

- `<!-- fill:user -->` — a judgment/preference only the user can set: response-economy mode, mandated
  tool channels, the Role mandate/tension, version-control policy, locked decisions. Bootstrap **asks**;
  `aikit-project-profile-sync` **re-asks / confirms presence**, and **never** auto-changes it.
- `<!-- fill:auto · «evidence source» -->` — evidence-backed and derivable from the repo. The evidence
  clause is a short, **stack-agnostic** category that mirrors `aikit-project-profile-bootstrap`'s detection
  tables — e.g. `dependency manifest`, `package scripts / Makefile / CI`, `tool config (.mcp.json /
  editor MCP)`, `linter & formatter configs`, `file tree`, `file tree + .gitignore`, `harvested
  instruction sources (README / CONTRIBUTING / agent docs)`, `repo's existing patterns`. **Never name a
  stack, framework, or vendor** (no `WordPress` / `Rails` / `React` — the coupling consistency-check #1
  forbids); the cross-stack manifest/config categories bootstrap's own tables use are fine. Bootstrap
  fills it from that source; sync re-validates against it and may **propose** an evidence-backed update
  at the gate.

**Two variants only — no third.** `fill:auto` *always* carries an evidence clause after the middot
separator ` · `; `fill:user` *never* does (the user is the source).

**Placement (deterministic, so the health-check grep and sync can locate the owning slot):** one marker
per managed slot, at the **end of the line** that holds the slot, after its content/placeholder,
separated by two spaces. For a table slot, the marker goes at the end of that row, inside the last cell,
after the cell's content; tag only managed rows, never the header or separator row. The marker sits
*after* the slot it owns (never before, never on its own line), so a filled value still ends with its
marker intact. Where an inline hint comment already exists (e.g. `<!-- standard | concise | terse -->` on
the Mode line), put the `fill:` marker **last**.

**The marker persists after the slot is filled** — unlike `TODO` (the slot's *content*, overwritten so
it vanishes), `{placeholder}` (sub-slot prose, also overwritten), and `<!-- To Remove -->` (disposable
example blocks deleted at bootstrap). That persistence is the point: the marker is simultaneously (a) the
**field inventory** `aikit-project-profile-sync`'s health check walks, (b) the **sync gate** — `auto` = may
propose an evidence-backed change, `user` = must ask — and (c) a hint that drives bootstrap's
detect-vs-ask. `TODO` answers *"is it filled yet?"*; `fill:` answers *"who owns it / how is it
re-validated?"*

**Tag only managed slots** (directive #1, stay lean) — never prose, blockquotes, headings, pre-filled
fixed facts, the fixed *"If a mandated tool is missing: STOP and ask"* line, or `<!-- To Remove -->`
examples. A thing is either a managed slot (gets `fill:`, persists) or a disposable example (gets
`<!-- To Remove -->`, deleted at bootstrap) — never both.

## When you change X, also touch Y (keep in sync)

| Change | Also update |
| --- | --- |
| **New per-project knob / fillable field** (PROJECT.md or reference) | `aikit-project-profile-bootstrap` (detect-or-ask step **+** a Verify item **+** the frontmatter `description`); **tag the new slot with a `fill:` marker** — `fill:user` if it's judgment/preference, `fill:auto · «source»` if it's evidence-backed (so `aikit-project-profile-sync` can re-validate it); and the relevant README surface (folder map / "What's in here" / "How to extend"). |
| **New behavioral rule** | The right `AGENT-INSTRUCTIONS.md` section; mark **HARD RULE** if it's a guardrail; add an §8 anti-pattern if it's a common mistake. |
| **New recurring procedure** (kit-shipped) | `skills/aikit-{name}/SKILL.md` (folder-per-skill; frontmatter `name:` matches the folder) **+** `skills/README.md` index. Kit-shipped skills carry the **`aikit-` prefix** so they can't collide with a host project's own skills once vendored; the generic `{name}` in `_SKILL-TEMPLATE.md` / `skills/README.md` is for *project-authored* skills downstream, which stay unprefixed. |
| **New project-fact category** | `reference/{doc}.md` **+** `reference/README.md` index; route to its skill at the bottom. |
| **New scaffold** | `templates/{file}` **+** `templates/README.md` index. |
| **New manual section** | Append as the next `§N` — **never renumber** existing sections. |
| **Renamed / added / removed file** | The README **folder map** and the **"What's in here"** table. |
| **Any change to vendored `AI/` content** | Bump the **Kit version** in `AGENT-INSTRUCTIONS.md`'s header per semver **+** add a dated `CHANGELOG.md` entry (see §"Versioning & releases"). Changes touching only home-only files (this guide, `CHANGELOG.md`) don't bump. |

The most-missed one: **adding a fillable field without tagging it `fill:` AND wiring `aikit-project-profile-bootstrap`** — then it's invisible to both the health check and sync. A new field is only "done" when it carries a `fill:` marker, bootstrap fills-or-asks it, `aikit-project-profile-sync` can re-validate it, and a Verify item guards it.

## Versioning & releases

The kit follows **Semantic Versioning** (`MAJOR.MINOR.PATCH`). The version is **single-sourced** in the
**Kit version** line at the top of [`AI/AGENT-INSTRUCTIONS.md`](AI/AGENT-INSTRUCTIONS.md) — so it rides
*inside* the vendored `AI/` folder and a downstream copy always records which snapshot it has. The §0
session-start handshake echoes it (`✅ AI kit v1.0.0 loaded — …`), surfacing the live version every
session.

**Bump on every change that alters vendored `AI/` content,** sized by impact:

- **MAJOR** — breaking: renumbered manual sections, a removed/renamed knob or fillable field, or
  anything that forces a downstream re-bootstrap or breaks a `§N` reference.
- **MINOR** — additive and backward-compatible: a new behavioral rule, skill, reference doc, template,
  or fillable field.
- **PATCH** — wording, clarifications, loophole/typo fixes that change no structure.

Changes that touch **only home-only files** (this `MAINTAINING.md`, `CHANGELOG.md`) **don't bump** —
they never vendor, so a downstream copy is unaffected.

Each bump (a) updates the Kit version line, (b) adds a dated entry under the new version to
[`CHANGELOG.md`](CHANGELOG.md) (home root, never vendored), and (c) is git-tagged `vMAJOR.MINOR.PATCH`.
The manual's Kit version and the latest `CHANGELOG.md` entry must always match — consistency-check #9.

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
- **Nothing under `AI/` may reference `MAINTAINING.md` or `CHANGELOG.md`** — both are home-only and never
  vendor, so the reference would dangle in every downstream repo (consistency-check #8 guards this).
  Downstream "how to extend" lives in the vendored `AI/README.md`; `MAINTAINING.md` is the home-only "how
  to evolve" guide and `CHANGELOG.md` the home-only release history.
- **The Kit version is single-sourced** in `AGENT-INSTRUCTIONS.md`'s header and **matches the latest
  `CHANGELOG.md` entry** (consistency-check #9). Bump it on every change to vendored `AI/` content per
  semver; home-only changes don't bump — see §"Versioning & releases".
- **`<!-- To Remove -->` blocks are disposable examples** (Role samples in `PROJECT.md`, the sample
  ladder in `reference/`) — and the only sanctioned home for concrete stack terms. `aikit-project-profile-bootstrap`
  deletes them on adoption; consistency-check #1 strips them before grepping.
- **Every managed slot in `PROJECT.md` / `reference/*.md` carries exactly one well-formed `fill:`
  marker** — `<!-- fill:user -->` or `<!-- fill:auto · «source» -->` (no third variant; `auto` always
  has an evidence clause, `user` never does). Filling a slot **never** removes its marker; markers live
  only on managed slots, never on prose, headings, pre-filled fixed facts, or `<!-- To Remove -->`
  examples. This is what makes the slot inventory (health-checked and synced) trustworthy — see §"The
  `fill:` marker convention".

## Consistency checks (run after any change)

```bash
# 1. Portability — no stack/tool coupling leaked into the kit
#    (concrete examples allowed only inside <!-- To Remove --> blocks; stripped here before grep.
#     ^-anchored so prose that mentions the markers can't start a strip; per-file (\;) so a range
#     can never bleed across files.)
find AI -name '*.md' -exec sed '/^<!-- To Remove: START/,/^<!-- To Remove: End/d' {} \; \
  | grep -niE "wordpress|wp-content|wp-config|chisel|gutenberg|timber|theme\.json"  # expect: none

# 2. Manual sections sequential, none renumbered
grep -nE "^## [0-9]" AI/AGENT-INSTRUCTIONS.md                                     # expect: 0..9 in order

# 3. Every cross-reference still resolves (eyeball the §N you touched)
grep -rn "§[0-9]" AI/

# 4. Mode names consistent
grep -rnoE "\`(standard|concise|terse)\`" AI/                                     # expect: only these three

# 5. Fill-in TODOs only where intended (fill-in surfaces, not stray scaffolding).
#    (`fill:` markers are orthogonal — they carry no `TODO`; check #7 governs them.)
grep -rl "TODO" AI/ | grep -vE "README|_SKILL-TEMPLATE|templates/|aikit-project-profile-bootstrap|aikit-project-profile-sync" # expect: PROJECT.md + reference/*

# 6. Folder map matches reality
find AI -maxdepth 2 -type f | sort                                                # compare to README's folder map

# 7. fill: markers in the managed files are well-formed (see §"The `fill:` marker convention")
grep -rnE "<!-- fill:" AI/PROJECT.md AI/reference/*.md | grep -vE "<!-- fill:user -->|<!-- fill:auto · "  # expect: none
#    (every marker is exactly one of the two forms — `auto` always carries the ` · ` evidence clause,
#    `user` never. Completeness — no managed slot left untagged — is guarded by bootstrap's
#    marker-preservation Verify item, not by grep: a missing marker matches nothing.)

# 8. Vendored files must not reference home-only guides (the ref would dangle downstream)
grep -rnE "MAINTAINING|CHANGELOG" AI/                                             # expect: none (home-only — never vendor)

# 9. Kit version single-sourced and in sync with the changelog
manual_v=$(grep -oE "Kit version:\*\* [0-9]+\.[0-9]+\.[0-9]+" AI/AGENT-INSTRUCTIONS.md | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
log_v=$(grep -oE "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" CHANGELOG.md | head -1 | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")
[ "$manual_v" = "$log_v" ] && echo "in sync: $manual_v" || echo "DRIFT: manual=$manual_v changelog=$log_v"  # expect: in sync
```

## Anti-patterns (kit maintenance)

- ❌ Adding words that don't fix a demonstrated failure (bloat).
- ❌ Coupling `AGENT-INSTRUCTIONS.md` to a stack, tool, or this repo.
- ❌ Restating one rule in multiple files instead of referencing it.
- ❌ Adding a fillable field without wiring `aikit-project-profile-bootstrap` + a Verify item.
- ❌ Renumbering manual sections after inserting one (insert at the end instead).
- ❌ Letting the README folder map drift from the real files.
- ❌ Weakening a HARD RULE for the sake of brevity.
- ❌ Putting maintenance/meta content inside `AI/` (it would ship into every downstream project).
- ❌ Changing vendored `AI/` content without bumping the Kit version + adding a `CHANGELOG.md` entry.
- ❌ Referencing `CHANGELOG.md` (or `MAINTAINING.md`) from inside `AI/` — home-only, dangles downstream.
- ❌ Committing or pushing a change without first asking whether to commit now or review (directive #7) — silence isn't approval.
