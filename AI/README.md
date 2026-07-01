# `/AI` — how this works (for you, the human)

**A drop-in operating manual that gives any AI coding agent the discipline of a senior engineer** — a
clear way of working, **analyze → clarify → plan → gate → build → verify**, that gets your sign-off on
a plan before it writes code and leaves a trail that survives context resets and hand-offs. It's a
single `AI/` folder of plain Markdown — a stack-agnostic methodology plus a short per-project profile —
that works with Claude Code, Cursor, Copilot, or anything that auto-loads a root instruction file; no
plugin, nothing to install.

This README is the **human's guide** — what the kit is, how to set it up, and how to grow it. The
agent's own manual is [`AGENT-INSTRUCTIONS.md`](AGENT-INSTRUCTIONS.md); fill the per-project specifics
in [`PROJECT.md`](PROJECT.md). Copy the whole `AI/` folder into any repo to reuse it.

## What's in here

| Path | Audience | Purpose |
| --- | --- | --- |
| [AGENT-INSTRUCTIONS.md](AGENT-INSTRUCTIONS.md) | the **AI agent** | The portable operating manual: how to approach any task — analyze → clarify → plan → gate → build → verify. Stack-agnostic. |
| [PROJECT.md](PROJECT.md) | the **AI agent** | The project-specific "what": the agent's **Role** (persona/mandate), **response-economy mode**, stack, **commands**, conventions, layout, locked decisions. Fill it per project. |
| [reference/](reference/) | the **AI agent** | The "what" — descriptive docs (conventions, decision ladders, file locations) the agent reads *before* building. |
| [skills/](skills/) | the **AI agent** | The "how" — ordered procedures for recurring tasks. One folder per skill. |
| [templates/](templates/) | the **AI agent** | Literal scaffolds to copy verbatim. |
| [README.md](README.md) | **you** | This file. The mental model, the folder map, and how to extend. |

### Folder map

```
AI/
  AGENT-INSTRUCTIONS.md   # the portable "how to work" manual (stack-agnostic)
  PROJECT.md              # the project "what" — Role, stack, commands, conventions  ← fill per project
  README.md               # this file (for you)
  reference/              # the "what": facts/constraints, read before building
    README.md             #   layer guide + index
    coding-conventions.md #   naming, layers, single-source-of-truth (project-fillable)
    decision-ladders.md   #   project-specific "which approach?" ladders
    file-locations.md     #   where each kind of file goes
  skills/                 # the "how": step-by-step procedures
    README.md             #   layer guide + index
    _SKILL-TEMPLATE.md    #   copy → skills/{name}/SKILL.md
    aikit-plan/
      SKILL.md            #   create/maintain ai-progress/ (procedure for §4)
    aikit-implement-from-design/
      SKILL.md            #   tool-agnostic design → code (procedure for §3/§4.5/§7)
    aikit-update-kit/
      SKILL.md            #   upgrade the vendored kit, preserving filled PROJECT.md + reference/*.md
    aikit-project-profile-bootstrap/
      SKILL.md            #   first-adoption skill: fill PROJECT.md + reference/*.md from the repo
    aikit-project-profile-sync/
      SKILL.md            #   health + drift check: keep PROJECT.md + reference/*.md healthy & in sync
  templates/              # literal code/scaffold to copy
    README.md             #   layer guide + index
    design-tool-skill.md  #   scaffold a downstream design-tool → code skill (e.g. Figma)

ai-progress/              # ← lives at the PROJECT ROOT, not here. Agent-maintained live work
                          #   tracking (INDEX + roadmaps + phase files). See AGENT-INSTRUCTIONS.md §4.
```

> **Why `ai-progress/` is at the project root, not in `AI/`:** `AI/` is the *methodology* (stable,
> committed once, rarely changes). `ai-progress/` is *live work* the agent rewrites constantly and
> that devs check often — it stays visible at the root. Keep the two separate.

The `reference / skills / templates` split is a proven layering: **reference = what, skill = how,
template = copy-me.** The agent reads reference before building, runs a skill to do the work, and
copies a template for boilerplate. Start with just the manual + `PROJECT.md`; grow the other folders
from real friction (see "How to extend").

> **Kit lifecycle:** [`aikit-project-profile-bootstrap`](skills/aikit-project-profile-bootstrap/SKILL.md) does the
> **first fill** of the profile from the repo; [`aikit-project-profile-sync`](skills/aikit-project-profile-sync/SKILL.md)
> later **keeps it healthy and in sync** — re-validating evidence-backed (`fill:auto`) values against the
> codebase and re-asking judgment (`fill:user`) ones.

## The core idea in one breath

> Stop the agent from *typing code first*. Force it to **understand the codebase, confirm what's
> actually wanted, write a plan to a file, get your sign-off, then build — and verify before claiming
> done.**

LLMs are eager. Left alone they pattern-match a plausible-looking solution and start editing. That's
where wrong-but-confident work comes from. This methodology front-loads the cheap steps (reading,
asking, planning) to kill the expensive step (reworking a wrong build). It's the same discipline you'd
expect from a good senior engineer joining your team.

## The five moves it enforces

1. **Analyze** — read the relevant code and docs *before* writing. Map the terrain, inventory what
   already exists. No inventing APIs from memory.
2. **Clarify** — resolve real ambiguity with batched, recommendation-first questions. Lock the
   answers (in/out of scope + decided choices) so they aren't relitigated next session.
3. **Plan** — decompose into ordered **phases**, written to committed progress files that survive
   context resets and handoffs. The plan is the source of truth, not the chat history.
4. **Gate** — the agent **pauses for your approval** of each phase's plan before building it. You
   steer at the cheap moment (a plan) instead of the expensive one (a finished diff).
5. **Verify** — build/test/lint, re-read the diff against the plan, update progress, report honestly.

Two supporting rules do a lot of the heavy lifting:

- **Reuse before building** — extend the sibling that already exists instead of creating a near-duplicate.
- **Simplest thing that works** — a decision ladder from "use what exists" up to "new dependency,"
  stopping at the first rung that satisfies the need; the costly rungs require your say-so.

## How the progress files work

For anything beyond a one-liner, the agent maintains an `ai-progress/` folder at the project root:

```
ai-progress/
  INDEX.md                  # router: every effort/task + status. Read first.
  {effort}-ROADMAP.md       # one per goal: scope, locked decisions, a phase table, a session log
  {effort}/phase-NN-*.md    # the detailed plan for each phase (written when that phase starts)
  task-{slug}.md            # tiny self-contained jobs
```

Why this shape: a new session reads the small `INDEX` + roadmap to learn what's done, and opens only
the one phase it's resuming. Nothing is monolithic, so context stays cheap; the roadmap's one-line
per-phase outcomes mean it rarely has to reopen finished work. Status is a single set of markers
(`[ ] [~] [x] [!]`), dates are absolute, and re-scoping *inserts* phases rather than renumbering — so
the trail never breaks. **Commit this folder** — it's how work hands off between sessions and people.

## Setup

Do this once per repo to make the kit active. The six steps are the same whether this is the kit's
first adoption or you're porting it into another project; each **Porting note** flags the only
differences.

### 1. Drop in the `AI/` folder

Copy the whole `AI/` folder to the **repo root** (where your VCS root and your agent's working
directory are). It's self-contained and references no specific project, so this is a plain copy — no
edits needed yet.

> **Porting note:** copy `AI/` as-is. Do **not** copy the source repo's `ai-progress/` — that's the
> *other* project's live work; a fresh one grows on its own at the new root. Project-specific
> `reference/`, `skills/`, or `templates/` you added for the old stack stay behind unless they
> genuinely apply.

### 2. Wire the root pointer (the load-bearing step — everything depends on it)

Most AI coding tools auto-load one root instruction file at session start — `CLAUDE.md`, `AGENTS.md`,
`.cursorrules`, or `.github/copilot-instructions.md`. **Starting fresh (no such file yet)? Prefer
`AGENTS.md`** — it's the emerging cross-tool standard most agents read — and for Claude Code create
`CLAUDE.md` as a **symlink** to it (`ln -s AGENTS.md CLAUDE.md`), so both load one file you maintain in
a single place. Add this one line to that root file (create it if none exists):

> For how to approach any coding task, follow `AI/AGENT-INSTRUCTIONS.md`, and open each session with
> the one-line load-confirmation it specifies.

**If your agent's working directory is the repo root**, that's it — use the path exactly as above.

**If you work from a subdirectory** (a theme, package, or service whose own `CLAUDE.md`/`AGENTS.md` is
the file your tool auto-loads), put the pointer line in *that* file and make the path reach the root
kit — e.g. `follow ../../AI/AGENT-INSTRUCTIONS.md` (match the `../` depth to your layout). A path that
doesn't resolve from the working directory fails **silently**.

**If more than one agent tool is used on the same repo** (e.g. Claude Code, Cursor, and Copilot each
auto-load a *different* file), point each tool's entry file at the kit. Either add the pointer line to
each, or symlink them to the canonical `AGENTS.md` (as above) so there's a single source to maintain.
The kit stays one `AI/` folder; only the thin pointer is shared.

Without this line, **no agent ever loads the kit and the whole methodology is silently inert** — this
is the single most common setup failure.

### 3. Wire skill discovery (so the kit's skills are invocable)

The kit holds **all** its skills under `AI/skills/` — the shipped `aikit-*` ones **and** any you author
later (`_SKILL-TEMPLATE.md` → `skills/{name}/SKILL.md`). Most agent runtimes auto-discover skills only
from **their own** directory — not from `AI/skills/` — so without this step the agent has the skill
*files* but can't invoke them (e.g. `/aikit-plan` won't exist, and neither will
`/aikit-project-profile-bootstrap` for the next step).

Point your runtime's skill-discovery at the kit. **Claude Code** reads `.claude/skills/` and follows
symlinks, so link the whole folder once — every current and future skill under `AI/skills/` then
resolves with no re-linking:

```bash
# from the repo root; won't clobber an existing .claude/skills (see fallback below)
[ -e .claude/skills ] && echo ".claude/skills exists — see fallback" || { mkdir -p .claude && ln -s ../AI/skills .claude/skills; }
```

That makes `/aikit-plan`, `/aikit-project-profile-bootstrap`, your own `skills/{name}/` — all of them —
available, and any skill added to `AI/skills/` later appears automatically. Commit the `.claude/skills`
symlink so teammates get it (Claude Code shows a one-time trust prompt on first load). Working from a
subdirectory whose own `.claude/` your tool loads? Create the link there and match the `../` depth
(e.g. `ln -s ../../AI/skills .claude/skills`).

> **Fallback — you already have a real `.claude/skills/`** with non-kit skills: don't replace it. Either
> move those skill folders into `AI/skills/` (the kit's model — one home for all skills), or symlink the
> kit's skills in individually:
> ```bash
> mkdir -p .claude/skills
> for d in AI/skills/aikit-*/; do n=$(basename "$d"); [ -e ".claude/skills/$n" ] || ln -s "../../${d%/}" ".claude/skills/$n"; done
> ```
> (Per-skill links need re-running whenever a new skill is added; the whole-folder symlink doesn't.)

> **Other runtimes:** if your tool auto-discovers skills from a directory, link or point it at
> `AI/skills/` the same way; if it has **no** skill mechanism, skip this step — invoke a skill by
> telling the agent to *follow `AI/skills/<name>/SKILL.md`* by path.

### 4. Fill the project profile

The generic manual needs project specifics to bind to. The recommended path is the bundled skill — run
it **after** step 3 (the `/aikit-project-profile-bootstrap` command exists only once skills are wired):

1. Start your agent from the repo root.
2. Invoke the skill — in Claude Code: `/aikit-project-profile-bootstrap`. In tools without slash-commands,
   paste: *"Run the `aikit-project-profile-bootstrap` skill in `AI/skills/`: analyze this codebase and fill
   the TODOs in `AI/PROJECT.md` and `AI/reference/*.md`."*

It scans the repo, fills the `TODO`s with evidence-backed values, then **pauses to ask you** to confirm
the build/test/lint commands, the inferred decision ladders, the drafted Role, and your
response-economy mode (`standard` | `concise` | `terse`). Answer those — they're the parts it can't
safely infer.

Hand-filling is the fallback: open [`PROJECT.md`](PROJECT.md) and work through its `TODO` list (Role,
Overview, Commands, Integrations, Version control, Conventions, Layout, Locked decisions), then the
`reference/*.md` docs.

> **Porting note:** run the skill again on the new repo so every value reflects the new stack, and
> clear any old-project values it didn't overwrite.

### 5. Confirm the kit is active

In a **fresh** session, verify the halves are live before doing real work:

- **The kit announces itself.** A correctly-loaded kit opens its first reply with a one-line
  confirmation — `✅ AI kit v{version} loaded — Role: … · mode: … · build: …`. **That line is your check:** seeing
  it (with a real Role + command) means the pointer (step 2) and profile (step 4) are both live; its
  **absence means the kit didn't load** — the pointer line is missing or sits in a file your tool
  doesn't auto-load. (To double-check, ask: *"Restate your Role and the build command."*)
- **The skills resolve.** In Claude Code, `/aikit-plan` (and the other `aikit-*` skills) should be
  listed/invocable — confirming step 3 wired discovery. If not, the symlinks are missing or sit under a
  `.claude/` your tool doesn't load.
- Run `grep -rn "TODO" AI/` and confirm it returns only intentionally-deferred placeholders (each
  annotated `confirm with owner`), not raw scaffolding `TODO`s.

### 6. Commit

Commit `AI/` (the kit + the filled profile), the root-pointer line, and the `.claude/skills` symlink
from step 3 together. The kit and profile are committed once and rarely change; `ai-progress/` is
created later — at the root, on your first real task — and is committed continuously as live work (see
**How the progress files work**).

**Keeping the kit local-only?** If you'd rather not push the config (`PROJECT.md` → "Config
visibility"), skip committing it — bootstrap adds `AI/`, `ai-progress/`, and the kit-only root pointer
to `.git/info/exclude`, so the kit stays on your machine only. Everything else in setup is unchanged.

**Setup is done when:** the pointer line exists in the auto-loaded entry file · the kit's skills resolve
in your runtime (e.g. `/aikit-plan`) · `PROJECT.md` has no un-annotated `TODO`s and a chosen
response-economy mode · the command table is confirmed to actually run · a fresh agent session restates
the Role and a real build command · all of it is committed. From here, start work with the prompt in
**Start an AI session**.

### Quick reference — what's portable vs per-project

| Copy as-is (portable) | Reset / regrow per project |
| --- | --- |
| `AGENT-INSTRUCTIONS.md`, `README.md` | `PROJECT.md` — re-fill for the new stack |
| `reference/`, `skills/`, `templates/` guide + index files | `reference/*.md` values — re-fill |
| `skills/aikit-*/` (all kit skills), `skills/_SKILL-TEMPLATE.md` | `.claude/skills` symlink — recreate per repo (Setup step 3) |
| | `ai-progress/` — don't copy; regrows at the new root |
| | Project-specific skills/templates you added — leave behind unless they apply |

## Start an AI session

**Launch the agent from the project root** (so it can see `AI/`, the project profile, and
`ai-progress/`). Then paste this at the start of every new session (new project or new conversation),
before asking for any work:

> Read `AI/AGENT-INSTRUCTIONS.md` first and confirm you loaded it with the one-line handshake it
> specifies — it owns how you approach every
> task: analyze → clarify → plan → gate → build → verify, plus the progress-file procedure and the
> per-phase plan-review gate. Follow it. Also read the project profile (`AI/PROJECT.md` / `CLAUDE.md`)
> if one exists, for the **Role** (your persona/mandate), **response-economy mode** (§9), stack,
> conventions, and build/test/lint commands. If `PROJECT.md` is still full of `TODO`s, the kit isn't
> set up — say so and offer to run `aikit-project-profile-bootstrap` before real work.
>
> First check `ai-progress/INDEX.md` — if an effort is already in progress, open its roadmap and
> **resume the next phase** instead of scoping from scratch.
>
> Otherwise, work the task in phases, one at a time, **never chaining**:
>
> 1. **Scope** — restate the task, list what you'll touch and what's out of scope, ask any clarifying
>    questions. **Pause.**
> 2. **Plan** — a phased plan in the progress files, each phase small enough to review/commit on its
>    own. **Pause for approval.**
> 3. **Execute** — one phase at a time, each as three steps with a hard stop between:
>    a. **Expand the phase plan** in its progress file (what you'll do, files/modules/tokens touched,
>       decisions). **Then STOP — write no code.** Wait for my review; I may change the plan.
>    b. On my explicit go-ahead, **build that phase only**, then summarize (what changed, what to
>       verify, what was run). **STOP.**
>    c. Wait for "next" before touching the following phase.
> 4. **Wrap-up** — final summary + follow-ups after the last phase.
>
> If anything is ambiguous, ask before starting — don't guess.

TASK:
[YOUR TASK HERE] — describe what you want.

> **Tip:** keep this prompt handy as a snippet. If your agent auto-loads a root instruction file
> (`CLAUDE.md` / `AGENTS.md` / `.cursorrules`), put the "read `AI/AGENT-INSTRUCTIONS.md`" line there
> so you only need to paste the phase-workflow reminder + task.

## How to extend it

Keep the split that makes this kit work: **a generic "how" + a project-specific "what."**

(Filling the project profile is **Setup** above — step 3. What follows is how the kit grows *after*
setup.)

**1. Grow `reference/`, `skills/`, `templates/` from real friction.** The folders exist with starter
files and layer guides; add to them as the project teaches you what's needed:

- **[reference/](reference/)** = the *what* (file locations, decision ladders, conventions, invariants).
  The agent reads this *before* building so it doesn't miss constraints that examples hide. Write a new
  reference doc when the agent keeps getting the same kind of thing wrong.
- **[skills/](skills/)** = the *how* (ordered procedure + code to copy). Copy `_SKILL-TEMPLATE.md` to
  `skills/{name}/SKILL.md` when a multi-step task recurs.
- **[templates/](templates/)** = literal scaffold to copy verbatim.

Don't build these out up front — start with the manual + `PROJECT.md`, and let the structure grow from
real friction. Each `reference/` doc routes to its `skill`; each `skill` copies from a `template`.

**2. Tune the rules.** Every section in `AGENT-INSTRUCTIONS.md` is editable. Tighten the gate (e.g.
"never push without explicit approval"), adjust the phase-ordering sequence to your domain, or add
anti-patterns you keep hitting. Mark the ones that cause silent failures as **HARD RULE** so they read
as non-negotiable. **But note:** editing the manual forks the portable layer — `aikit-update-kit`
replaces it wholesale, so your edits must be re-applied on each update. Reserve manual edits for genuine
changes to the *methodology*; put anything **project-specific** in `PROJECT.md` → "Project-specific
rules" (or a `reference/` doc), which the manual already loads each session and the updater preserves.
