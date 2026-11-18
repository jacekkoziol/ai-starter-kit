---
status: accepted
---

# Service objects, with side effects after commit

Business actions change several records and trigger emails, broadcasts and outside calls. A failure must not go unnoticed, and nothing may be sent for a change that was rolled back. We put each action in a plain service object that returns the record it changed or raises a specific error, and calls its side effects directly, with emails, broadcasts and outside calls running after the commit. The rules are in `CODING_STANDARDS.md`.

## Considered options

- **Result objects:** callers can ignore a failure; an exception cannot be ignored.
- **An event bus (`wisper` or our own):** decouples side effects but hides what an action does. Add one later, with the same after-commit rule, if new modules need to react without changing services.

## Consequences

One file shows everything an action does; adding a side effect means editing the service.
