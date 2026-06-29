# Reference — the "what"

Reference docs hold **descriptive facts** about *this* project: file structures, where things go,
naming, decision ladders, invariants, required keys. The agent reads the relevant reference doc
**before building** the thing it owns — pattern-matching off a sibling file silently misses
constraints that only the reference states.

Each doc should route to its **skill** at the bottom (if one exists). Reference answers
*what / which / where*; a [skill](../skills/) answers *how, step by step*.

## When to add one

Write a reference doc when you notice the agent repeatedly getting the same kind of thing wrong, or
when a part of the project has non-obvious rules a newcomer (human or AI) keeps missing. Don't write
them up front — let them grow from real friction.

## How to add one

1. Create `reference/{topic}.md`. State the facts/constraints, not procedure.
2. Mark any rule whose violation causes silent failures as **HARD RULE**.
3. Add a "→ routes to skill: …" line at the bottom if a matching skill exists.
4. Add a row to the index below.

## Index

| Doc | Owns |
| --- | --- |
| [coding-conventions.md](coding-conventions.md) | Naming, layers, style, single-source-of-truth rules. |
| [decision-ladders.md](decision-ladders.md) | Project-specific "which approach?" ladders. |
| [file-locations.md](file-locations.md) | Where each kind of file/artifact goes. |
