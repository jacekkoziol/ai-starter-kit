---
status: accepted
---

# Capabilities and roles, checked by Action Policy

Staff need more than one fixed set of rights (an admin may also be an engineer; a designer may need fewer rights than a developer), and we want to add a role without changing the policies. So `config/capabilities.rb` lists the capabilities as `resource.action` keys, `config/roles.rb` groups them into roles, and one `role_assignments` table gives a role to a user everywhere, in one organization or in one project. Policies stay Action Policy rules, but they check capabilities with `can?`, never role names: the catalog says who may do something, the policies say when.

## Considered options

- **Fixed roles in the policies** (ADR 0004): every new role changes every policy that names a role.
- **rolify or role_fu:** rolify has had no release since 2023 and keeps grants in a join table without a model, so `paper_trail` cannot record them; role_fu is pre-1.0 with one maintainer and has no Action Policy adapter. Both duplicate what our own table does with real foreign keys.
- **Roles that admins edit in the portal:** nobody asked for it; it can be added later without changing the policies, because they check capabilities only.
- **One table per kind of user or per scope:** a role can apply to any user, everywhere, in one organization or in one project, so one table keeps one validation, one audit trail and one query per request.
- **A generated permissions document:** it would show who may do something but not when, so it could mislead; `config/roles.rb` is short enough to read.

## Consequences

- `users.kind` alone decides who sees private messages, team-only threads and internal tasks; no role changes that. A capability is either staff-only or open to clients, and `can?` refuses a staff-only one to a client user, whatever their roles say.
- There are no rules that deny: a user's capabilities in a place are the union of the roles that apply there.
- Staff acting for a client is not a capability of its own: the actor recorded with every change shows it.
- Role keys have no check constraint, so adding a role is one line. A stored role missing from `config/roles.rb` gives no capabilities and is reported to Sentry.
- A refused action answers like a missing page (404), so it does not tell whether a record exists.
