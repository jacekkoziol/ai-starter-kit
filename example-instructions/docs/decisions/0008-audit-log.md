---
status: accepted
---

# Audit log in one `audit_events` table, with `paper_trail`

Auditing covers row changes (settings, roles, organization details) and events that change no row, such as a failed sign-in or an admin override. We record both in one `audit_events` table. `paper_trail`, with a custom version class `AuditEvent` on that table, records changes to the few models whose field history matters in the same transaction as the change, so changes made outside a service, such as in the console, are recorded too. Services and Warden hooks write the other events as `AuditEvent` rows directly, without an item when there is no record, such as a failed sign-in with an unknown email.

## Considered options

- **`audited`:** does the same job, but has had no release since November 2024 and its last version does not allow Active Record 8.2, so it would block Rails upgrades.
- **Our own `Auditable` concern:** no dependency, but we would rebuild what `paper_trail` already does: skipping secret fields, recording deletes and naming the actor.
- **Only events written by services:** misses changes made in the console or outside the normal path.

## Consequences

- The table has `paper_trail`'s columns (`event`, `item`, `whodunnit`, `object_changes` as JSON) plus IP, user agent and details; `item_id` allows null.
- `version_error_behavior` is `:exception`: by default a failed write on update or destroy is only logged, so a change could be saved without its record.
- `whodunnit` is the signed-in user in a web request (`set_paper_trail_whodunnit`), the `actor:` of a service, or `"console"`.
- `paper_trail` 17 warns on Active Record 8.2 until a release supports it, but does not block the upgrade.
