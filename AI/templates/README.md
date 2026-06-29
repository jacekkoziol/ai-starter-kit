# Templates — literal scaffolds to copy

Code / markup / config skeletons the agent copies verbatim and fills in. Where a [skill](../skills/)
is a *procedure*, a template is the *artifact* it produces. Keep them minimal and current — a stale
template is worse than none, because the agent trusts it.

## When to add one

When a kind of file always starts from the same boilerplate (a component file, a test file, a config
block). Capture the canonical starting point once.

## How to add one

1. Drop the skeleton in `templates/{kind}.md` (or `.txt` / the real extension), with `TODO` /
   `{placeholder}` markers where the agent fills in.
2. Reference it from the skill that uses it.
3. Add a row to the index below.

## Index

| Template | For |
| --- | --- |
| _(none yet — add files here as patterns stabilize)_ | |
