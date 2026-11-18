# Architecture decisions

Short records of choices that are hard to reverse.

## When to write an ADR

All three must be true:

1. **Hard to reverse:** changing our mind later has a real cost.
2. **Surprising without context:** a reader of the code would wonder why it was done this way.
3. **A real trade-off:** there were genuine alternatives and we picked one for specific reasons.

Otherwise it is not an ADR: rules and conventions go in `AGENTS.md`, `CODING_STANDARDS.md` or a guide in `docs/`, task details in the task, and open product questions in the issue tracker.

## Format

One file per decision, `NNNN-slug.md`, numbered one above the highest existing number.

```md
---
status: proposed
---

# Short title of the decision

1-3 sentences: the context, what we decided, and why.
```

Every ADR has a status:

- `proposed`: recommended, waiting for the team to accept or change it.
- `accepted`: decided by the team.
- `deprecated`: no longer applies.
- `superseded by ADR NNNN`: replaced by a newer decision. To change an accepted decision, write a new ADR and mark the old one superseded.

Optional sections, only when they add something:

- **Considered options:** rejected alternatives worth remembering (for a paid service, include its monthly cost).
- **Consequences:** downstream effects that are not obvious.

| # | Decision | Status |
| --- | --- | --- |
| [0001](0001-record-architecture-decisions.md) | Record decisions as short ADRs, keep code comments sparse | accepted |
| [0002](0002-stack-and-hosting.md) | Rails monolith on PostgreSQL, deployed with Dokku on Hetzner | accepted |
| [0003](0003-authentication.md) | Authentication with Devise | accepted |
| [0004](0004-authorization.md) | Authorization with Action Policy | superseded by ADR 0014 |
| [0005](0005-business-logic-and-side-effects.md) | Service objects, with side effects after commit | accepted |
| [0006](0006-payments.md) | Payments with the `stripe` gem, calling Stripe first | accepted |
| [0007](0007-notifications.md) | Notifications with `noticed` | accepted |
| [0008](0008-audit-log.md) | Audit log in one `audit_events` table | accepted |
| [0009](0009-front-end.md) | Turbo, Stimulus and ERB partials; no Tailwind | accepted |
| [0010](0010-email.md) | Email with SendGrid, reply by email with Action Mailbox | accepted |
| [0011](0011-testing.md) | Testing with RSpec and factory_bot | accepted |
| [0012](0012-styles.md) | SCSS with design tokens in Ruby | accepted |
| [0013](0013-form-builder.md) | Our own form builder | accepted |
| [0014](0014-capabilities-and-roles.md) | Capabilities and roles, checked by Action Policy | accepted |
| [0015](0015-email-html.md) | Email HTML with MJML, compiled by hand | accepted |
