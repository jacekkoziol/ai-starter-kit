# Merge collisions — repairing two efforts that claim one folder

> Load this **only** when a merge brings in an effort folder (or child folder) that another branch
> created with the same name — git shows it as an add/add conflict under `ai-progress/`. Everything else
> about naming lives in [contract §3](progress-contract.md); this is the one repair that may rename an
> effort folder, and it must finish before the merge lands.

A date fallback narrows the sequential-prefix collision window but doesn't close it: two branches can
create the same `{date}-{slug}` independently — same day, same goal, same obvious slug — and neither branch's `INDEX.md` can see the other, so git surfaces it as an **add/add
conflict at merge**, not at creation. Two children given the same `{parent-id}--{slug}` collide the same
way and are repaired the same way. Resolve by intent:

- **Same goal** (the common case) — consolidate into one effort. Keep the earlier folder and **reconcile**
  the two roadmaps into one valid phase sequence rather than concatenating their tables: preserve
  completed outcomes, resolve duplicate phase IDs with the `phase-NNa` suffix rule, leave at most one
  phase in flight (contract §5), interleave both `LOG.md` histories by date, keep every non-duplicate
  artifact and script, then re-run contract §10. Concatenating produces duplicate phase IDs, two `[~]`
  rows, and two versions of one plan — each an invariant violation.
- **Genuinely different goals** — suffix the later folder (`20260818-checkout-rebuild-a/`) and update its
  `id:`, its `INDEX.md` row, every inbound link, and **every child effort whose `parent:` names the old
  ID** — `parent:` is a field, not a link, so no link check catches it. **Re-key its findings too:** an ID
  embedding the old effort ID would otherwise name the *surviving* effort — the one it never came from — so
  `FND-20260818-checkout-rebuild-P01-…` becomes `FND-20260818-checkout-rebuild-a-P01-…`, with its inbox
  entry, detail filename, `Source` link, and inbound references updated. That is one of the authorized
  finding-ID repairs — [findings workflow §8](findings-workflow.md) owns the complete set.

Consolidation can also surface **duplicate finding IDs** — both branches minting `FND-{same-effort-id}-…`
under the kept effort. Same observation: consolidate to one finding, keeping non-duplicate evidence and
inbound references from both. Different observations: a true finding-ID collision, so suffix the later one
([findings workflow §8](findings-workflow.md)) and update its inbox pointer, detail filename, and inbound
references.

Do all of this before the merge lands. Renaming afterwards breaks links that have already been published.
