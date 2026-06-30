# Decision Ladders (project)

> The **generic** ladders — "reuse before building" (§3) and "simplest thing that works" (§5.1) — and
> the "stop and ask" triggers (§5.2) live in [`../AGENT-INSTRUCTIONS.md`](../AGENT-INSTRUCTIONS.md).
> This file records ladders specific to **this** project: the recurring "which approach do I use?"
> decisions, written as **stop-at-first-match** rungs from cheapest/most-reversible to heaviest.

## How to write one

> **\<decision name\>** — for \<what kind of need\>. Walk down; stop at the first rung that fits.
>
> 1. \<cheapest, most reversible option\> — when \<condition\>.
> 2. \<next\> — when \<condition\>.
> 3. \<heaviest; may need your sign-off\> — only when \<condition\>.

Mark the rung that crosses into "STOP and ask" (new dependency, migration, irreversible change) so the
agent surfaces it instead of silently choosing it.

<!-- To Remove: START — sample ladder for reference. Delete this whole block once you've written your real ladders below (aikit-project-profile-bootstrap removes it). -->
## Example (replace with your own)

> **Add data access** — for reading/writing persisted data. Stop at the first match.
>
> 1. Reuse an existing query/repository method — if one already returns what you need.
> 2. Add a method to the existing repository — if the entity already has one.
> 3. New repository for a new entity — model it on the closest existing one.
> 4. New table / schema change / migration — **STOP and ask** (touches persisted data; §5.2).
<!-- To Remove: End -->

## Project ladders

- TODO — add your project's real decisions here (e.g. "new endpoint vs extend", "new component vs
  variant", "new config key vs reuse").  <!-- fill:auto · repo's existing patterns -->
