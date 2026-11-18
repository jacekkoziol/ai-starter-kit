# Merge requests

- Title: `[#<issue>] <What The Merge Request Delivers>`, with the description in title case and no conventional commit prefix.
- The description gives the reason for each new gem, npm package or outside service, and the decisions taken during the task that are not rules or ADRs; the developer copies them to the issue. A paid service needs an accepted ADR with its monthly cost and the free alternative that was rejected.
- Create merge requests with `bin/gs branch submit --draft --title "<title>"`. Then select "Delete source branch", which git-spice cannot do: `bin/glab api --method PUT "projects/:id/merge_requests/<MR>" --field remove_source_branch=true`.
- Use `--draft` only for a branch that has no merge request yet. On an existing merge request, it turns a ready one back into a draft.
- After you submit a branch, update the stack comments of the other merge requests in the stack: `bin/gs upstack submit --branch <lowest branch> --update-only`. The lowest branch is the one based on `develop`. `bin/gs branch submit` updates only the stack comment of its own merge request. `--update-only` creates no merge requests, but it pushes each branch that has a merge request and differs from its remote; `--dry-run` shows what it would do. A stack comment lists only the branches below and above its merge request, not side branches.
- Stacked branches are managed with `bin/gs` (git-spice). A change in a branch below can break a branch above without a conflict, so check the branches above after a restack.
- After a restack that had conflicts is pushed, add a note to each affected merge request: which commits and files had conflicts, and how each was resolved.

## Automated review

- An automated review starts when a merge request is created as ready (not draft), when a draft is marked ready, and when someone adds the `[STCR] Request` label, which the review bot then removes. A draft gets no review until one of these happens.
- The bot runs three reviews in turn: Thermonuclear Review (`[STCR TR]`), Thermonuclear Code Quality Review (`[STCR TCQR]`) and Codex Security (`[STCR CS]`). Each review's label shows `In Progress`, then `Completed`.
- The findings arrive as review threads that start with `[Review]`. `/review-mr-feedback` analyzes and answers them. To review the fixes, add `[STCR] Request` again after pushing them.

## Environments

GitLab CI runs every check on merge requests and on pushes to `develop` and `main`, so a branch gets a pipeline once it has a merge request (a draft is enough). The audits run daily on `develop`. `develop` deploys to dev automatically and `main` to production through a manual job, both only after a green pipeline. Dev and production are Dokku apps on one Hetzner server; migrations run on deploy.
