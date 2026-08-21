# Findings workflow — out-of-scope observations

> How an out-of-scope discovery gets captured, expanded, triaged, and promoted **without** silently
> widening approved scope or polluting the committed work queue. Load this when capturing, expanding,
> triaging, dismissing, or promoting a finding — not when writing ordinary progress files (that's
> [`progress-contract.md`](progress-contract.md)).
>
> The escalate-versus-record fork itself is always loaded, in
> [`AGENT-INSTRUCTIONS.md`](../../../AGENT-INSTRUCTIONS.md) §2.5.

A finding is a **candidate observation**, not accepted work. It becomes work only when someone commits
to it (rung 3).

## 1. The promotion ladder

Use the first rung that preserves enough information.

| Rung | Shape | Use when |
| --- | --- | --- |
| **0. Escalate** | The existing stop-and-ask (§5.2) / blocker / re-scope procedure (§4.3) | The current delivery may be unsafe, incorrect, materially unverifiable, or inconsistent with its done criteria |
| **1. Capture** | One line in `FINDINGS.md` | Safely deferrable, and a concise observation carries it |
| **2. Expand** | A pointer in `FINDINGS.md` + `findings/{finding-id}.md` | Evidence, affected locations, or prior investigation must be preserved |
| **3. Accept** | The project's issue tracker / backlog, or a `queued` effort | Someone has committed to addressing it |

Never create a detail file just because a finding exists — rung 2 is **earned**. Never jump to a `queued`
effort without explicit acceptance: `queued` means *committed but not started*, not merely noticed.

## 2. Rung 0 — escalate instead of deferring

§2.5's test decides this: *would a reasonable reviewer, once informed, consider the planned delivery
unsafe, incorrect, materially unverifiable, or inconsistent with its done criteria?* **Yes, or materially
uncertain → escalate.** Typical triggers: exposed secrets or credentials · a security or privacy
vulnerability · production or personal data exposure · data-corruption or data-loss risk · a defect that
invalidates the done criteria · a failure making required verification unreliable · a regression this
implementation introduced · a compliance issue affecting this delivery.

**"Out of scope" is never a reason to knowingly deliver unsafe or incorrect work.** Escalating means
surfacing it and using the existing blocker or re-scope path — not quietly fixing it either (§8).

## 3. Rung 1 — capture

One line, in `FINDINGS.md` under `## Open`:

```text
finding-id · kind/confidence · location or source — observation
```

A suggested action may be appended when it's obvious; **don't design a solution at capture time.**

**Kinds** — five, deliberately. Don't expand the taxonomy until real use demands it.

| Kind | Meaning |
| --- | --- |
| `defect` | Confirmed incorrect behavior, output, structure, contract, or implementation |
| `debt` | Maintainability, design, coupling, complexity, or engineering-practice concern |
| `risk` | Potential future failure, or a material security, privacy, accessibility, performance, operational, or compatibility concern |
| `test-gap` | Important behavior or failure mode lacks appropriate verification |
| `docs` | Documentation missing, misleading, inconsistent, or obsolete |

Accessibility and performance need no separate kinds: a *confirmed* failure is a `defect`, a *possible*
one a `risk`; maintainability is a form of `debt`. Never record a bare preference as a finding — there
must be a concrete reason the current state is costly, risky, or deficient.

**Confidence** is orthogonal — `confirmed` (directly verified in code, tests, output, or observed
behavior) · `likely` (strong evidence, not fully verified) · `suspected` (needs investigation). Never
present a preference or an unverified hypothesis as a confirmed defect — the same honesty rule as §7's
"never claim verified when nothing ran."

## 4. Rung 2 — expand

Promote when one line no longer preserves enough: more than one or two locations · reproduction steps · an
investigation that shouldn't be repeated · evidence to link · constraints to explain · someone unfamiliar
with the originating effort must act on it later.

**Promotion procedure:** create `findings/` if absent → create the detail file from
[`finding.template.md`](../assets/finding.template.md) → move the locations, evidence, impact, reasoning,
and suggested disposition into it → **reduce the inbox line to a pointer** (id · kind/confidence · short
label · link). Do not leave the expanded description duplicated in the inbox.

A detail file carries YAML frontmatter — `id`, `kind`, `confidence`, `created` — so `findings/` stays
greppable during triage (`kind: defect`). Deliberately **no `status:`** (the inbox's `Open` /
`Recently triaged` sections own lifecycle state, and a second surface would drift) and **no `schema:`**
(findings have no legacy shape; `ai-progress/v2` already versions the contract). No `source:` either — the
ID encodes what provenance it has (the phase segment is optional, and a repo-level finding encodes a date
instead), and the `Source` blockquote carries the clickable origin.

**Authority transitions with the rung.** At rung 1 the inline entry *is* the finding. At rung 2 the
detail file — frontmatter included — becomes authoritative, and the inbox line is a derived router entry
that restates `kind/confidence` as a bounded summary. Same projection pattern as `INDEX.md` →
`ROADMAP.md` and the phase table → phase file: when a derived entry disagrees, fix the derived entry.

## 5. Rung 3 — accept

Destination is the project's issue tracker or backlog (whatever `PROJECT.md` specifies), or a new
`queued` effort. Either way the destination becomes authoritative for planned work, and the finding
leaves `## Open` — remaining briefly under `Recently triaged` as a pointer to where it went.

A promoted effort **backlinks** in its roadmap `Source` section: the finding, and the originating effort.
Provenance survives after the disposition scrolls away.

## 6. Dismissals — promote only durable ones

Ask: **is this dismissal an intentional decision a future agent is likely to challenge or rediscover?**
If no, let it expire from `Recently triaged`. If yes, record the *decision* where it will be seen:

| Dismissal | Home |
| --- | --- |
| Durable and **project-wide** | `PROJECT.md` → Locked decisions |
| Durable but **specific to one effort** | That effort's `ROADMAP.md` → Locked decisions |
| **Ephemeral** | Stays under `Recently triaged` and scrolls away |

Don't promote every dismissal — a locked decision must be intentional, durable, likely to recur, and
important enough to shape future implementation. That's what keeps `PROJECT.md` from becoming a dump of
every rejected finding.

## 7. `FINDINGS.md`

A bounded, cold-path triage inbox — **not** an accepted backlog. Every unresolved candidate stays under
`## Open`; dispositions go under `## Recently triaged`, capped at **10** and ordered **newest first**, so
"the oldest" is the last row (drop it past the cap; git history keeps older ephemeral ones). No findings
archive by default, no accepted work under `Open`, no finding counts, and **no link from `INDEX.md`** —
the router stays efforts-only, and §4 already names this path. Scaffold: [`FINDINGS.template.md`](../assets/FINDINGS.template.md).

A growing inbox is a triage problem, not a reason to build a deeper hierarchy.

## 8. Finding IDs

Source-derived, so provenance reads off the ID. The phase segment is optional:

| Found | Form | Example |
| --- | --- | --- |
| During a phase | `FND-{effort-id}-{phase-id}-{slug}` | `FND-PROJ-142-P03-invalid-markup` |
| In an effort, outside a phase (scoping, roadmap authoring, close-out, review) | `FND-{effort-id}-{slug}` | `FND-PROJ-142-shared-service-coupling` |
| Outside any tracked effort | `FND-{YYYYMMDD}-{slug}` | `FND-20260818-build-script-portability` |

Uppercase `FND-` prefix, concise lowercase ASCII kebab-case slug. No repo-global numeric counter, and never
renumber. **A linked ID is stable — rename one only through an authorized collision repair**, of which
there are exactly two:

- **A true finding-ID collision** — suffix the later ID (`FND-PROJ-142-P03-invalid-markup-a`). Two branches
  can each link this ID before either can see the other, so the suffix lands on an ID already in use.
- **A contract §3 effort-collision repair** — re-key the finding with its repaired source effort ID.
  Otherwise the embedded effort ID names the *other* effort in the collision, and provenance reads off the
  ID as a falsehood rather than merely going stale.

Outside those two repairs, never rename an ID once linked.

## 9. Relationship to effort follow-ups

| Destination | Holds |
| --- | --- |
| `FINDINGS.md` | Candidate observations, not yet accepted as work |
| `ROADMAP.md` → `Deferred / follow-ups` | Scope decisions and future work tied to **this effort's outcome** |
| Issue tracker / `queued` effort | Accepted work |
| `SUMMARY.md` → `Open follow-ups` | Links to accepted or intentionally retained follow-ups at closure |

A minor observation may live only in `FINDINGS.md`. A significant one may be *linked* from the roadmap's
`Deferred / follow-ups` — never copied into it.

**Before closing an effort:** no meaningful finding may stay stranded inside a completed phase file, a log
line, or a closed roadmap. Confirm critical ones were escalated, evidence is linked, significant ones are
triaged, accepted follow-ups are linked from `SUMMARY.md`, and unresolved candidates sit in `FINDINGS.md`.

## 10. Validation checklist

- [ ] Critical findings were escalated (rung 0), not deferred.
- [ ] Deferrable findings were captured without expanding approved scope, and nothing was silently fixed.
- [ ] Every finding ID is stable, unique, and source-derived; an effort-derived one truthfully names its
      current source effort, and any rename went through an authorized collision repair (workflow §8,
      contract §3).
- [ ] Kind and confidence are factual — no preference or hypothesis presented as `confirmed`.
- [ ] Rung-1 findings fit one concise entry; rung-2 findings have exactly one pointer and one detail file.
- [ ] Expanded detail is not duplicated in `FINDINGS.md`; the detail file says why it was deferred.
- [ ] Large evidence is linked from `artifacts/`, not pasted.
- [ ] No uncommitted candidate appears as a `queued` effort; promoted work links to its authority.
- [ ] `Recently triaged` holds at most 10 entries; durable dismissals were promoted to a Locked decision.
- [ ] No finding is stranded only inside closed work; `FINDINGS.md` is not in the cold-resume path.
- [ ] No secrets, personal, production, or unapproved client data were retained in finding evidence.
