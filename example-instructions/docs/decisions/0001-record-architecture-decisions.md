---
status: accepted
---

# Record decisions as short ADRs, keep code comments sparse

Comments that repeat the code go stale and make files longer to read, while the reasons behind bigger choices get lost. We record choices that are hard to reverse as short ADRs in `docs/decisions/` (format in the README), and code comments explain only a non-obvious "why"; anything longer goes in an ADR or a doc linked from the code.
