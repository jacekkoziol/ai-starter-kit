# Worktrees

Claude creates worktrees in `/workspaces/sample-volume/worktrees`, branched from the current commit, with the Node packages, gems and test databases set up and a link to the main checkout's `.env.local`.

## Development database

Each worktree has its own development and test databases, named after it. To set up the development database:

1. Copy the main worktree's with `bin/copy-database --main-worktree`, or another worktree's with `bin/copy-database <worktree name>`. Add `--force` to replace a database that already exists.
2. Copy the source checkout's Active Storage files too: `cp -R <source checkout>/storage/. storage/`.
3. Run `bin/rails db:migrate` to apply this branch's migrations.

When the task needs seed data, use `bin/rails db:prepare` or `bin/setup` instead: they create the database and load the seeds.

## Removing a worktree

1. Drop the test databases that `bin/ci` created, one set for each of its four RSpec processes, with `bin/rails 'parallel:drop[4]'`. Then drop the development database with `bin/rails db:drop`.
2. `git worktree remove` it and delete its branch. Worktrees made for subagents stay until you do this.

Gems are shared by every checkout, so keep them all installed: `bundle clean` would remove gems that other checkouts use.
