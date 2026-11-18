---
status: superseded by ADR 0014
---

# Authorization with Action Policy

Four roles share the same screens, and private messages, team-only threads and internal tasks must never reach a client. We use Action Policy, because its built-in relation scopes, rule aliases and RSpec matchers fit a rule that every list goes through a scope. The policies are the only record of who can do what; there is no separate permission matrix or permissions document.

## Considered options

- **Pundit:** no built-in relation scopes or rule aliases.

## Consequences

Adding a capability means a policy rule and a spec for it. Nothing checks that every rule has a spec, so review does.
