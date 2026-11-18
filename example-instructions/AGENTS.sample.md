# Working on Sample Portal (developers and AI agents)

Sample Portal is the client portal for **SampleSite**, a service that builds WordPress websites for small businesses and then looks after them on a monthly program. The promise is _"real people looking after your website, with AI working behind them"_, so human ownership, approval and communication should be visible everywhere.

Early build: many paths, gems and commands in these documents don't exist yet; the first task that needs one adds it. The proof of concept (the `sample-portal` repo) is a reference only: read and own any code before using it; its docs describe intent, not working features.

**Private messages, staff-only threads and internal tasks reach staff only**, through every channel. How this is enforced is in `CODING_STANDARDS.md`.

## Where to read

- **`CODING_STANDARDS.md`:** before writing or reviewing code.
- **`GLOSSARY.md`:** naming a domain concept in code, issues or text: use its terms, not its `_Avoid_` words.
- **`docs/worktrees.md`:** setting up a worktree's database, or removing a worktree.
- **`docs/merge-requests.md`:** opening a merge request, requesting a review, restacking, adding a gem, npm package or outside service, environments.
- **`docs/decisions/`:** ADRs: the reasons for technical choices, and when to write one.
- **`docs/content-images.md`:** adding, changing or deleting an image of the marketing pages that the content editor will later manage, such as a photo of a person.
- **`docs/personal-data.md`:** storing a new kind of personal data, or adding a processor.

## Workflow

1. **Plan.** Before any implementation, present a very brief plan and wait for the user to confirm it. Start implementing only after they agree. The plan gives:
   - the scope of the slice;
   - the key files or modules;
   - the verification approach;
   - the estimated size of the diff: lines added plus lines removed, in maintainable code only (code, tests and docs that people edit by hand, so not `db/schema.rb` or lockfiles). When unsure, give the larger number;
   - above 1,000 lines, a proposed split into vertical slices. A vertical slice is a complete change through all the layers it needs (for example model, controller and view) that works, and can be reviewed, on its own. Each slice gets its own merge request, stacked with `bin/gs` on the slice it depends on;
   - the open questions;
   - MVP (minimum viable product) simplifications and alternatives, shown apart from the plan: cuts to the plan, or other approaches, with a much smaller diff. Look for them before you present the plan. Each one may break the task's requirements or rules in `CODING_STANDARDS.md`. For each one, give what it breaks and its estimated diff size. Build one only if the user chooses it, and then list what it breaks in the merge request description.
2. **Build.** Implement the smallest complete slice. After a split, build only the first slice. When it is in review, plan the next slice as in step 1.
3. **Verify.** Run the task's required verification. When the task has user-visible behavior and it is reasonable, also run an end-to-end (e2e) check with `agent-browser` before the user review: start this worktree's dev server in the background with `bin/dev`, open the URL `bin/url` prints, and drive the real UI. When an e2e check is not reasonable for the slice, say so.
4. **Report.** Give the e2e steps, so the user can repeat them. For user-visible work, keep the dev server running and report its exact URL. Give the actual size of the diff, counted as in step 1, next to the estimate.

## When something is unclear

**Ask, don't guess.** If the task as given to you does not settle a question, product or technical, stop and ask before deciding. Open product questions are in the issue tracker. Record the answer in the same merge request:

- a rule later work must follow goes in this file, `CODING_STANDARDS.md` or the guide in `docs/` it belongs to;
- a settled domain term goes in `GLOSSARY.md` at once;
- a choice that meets the test in `docs/decisions/README.md` becomes an ADR;
- anything else goes in the merge request description.

## Commands

- Set up: `bin/setup` inside the dev container; 1Password loads the development secrets when the container starts (README, "1Password"). Agents: `bin/setup --skip-server`.
- Run: `bin/dev`. `bin/url` prints the checkout's URL.
- Sign in: `staff@example.com`, `engineer@example.com`, `owner@example.com` or `member@example.com`, password `sample-seed-password` (`db/seeds.rb`). In development, `/_dev/sign-in?email=owner@example.com&return_to=/path` signs in with no password, two-step code or flash.
- All checks: `bin/ci`, the same checks as GitLab CI. A task that adds a tool adds its step to `config/ci.rb` and its command to the `checks` job in `.gitlab-ci.yml` (`audit` for an audit).
- Tests: `bundle exec rspec`, or one file with `bundle exec rspec <path>`. `bin/ci` runs the specs in four processes with `parallel_tests`, each with its own test databases, so a spec must not depend on a file or a service that another process can change. The 95% coverage minimum applies only when `CI` is set (`bin/ci`, GitLab CI). While you work, run only the specs that cover the change. Run `bin/ci` before you report the slice and before you commit later changes.
- Fix style: `bin/rubocop -a`, `pnpm exec stylelint --fix <files>`, `pnpm exec prettier --write <files>`.
- GitLab: `bin/glab` (glab) and `bin/gs` (git-spice), with `GITLAB_TOKEN` from `.env.local`.
- Browser: `agent-browser`, pinned in `mise.toml`, drives the dev container's Chromium. `agent-browser --help` lists the commands.
- Images: Pillow (`PIL`) in `python3`, for example to read screenshot pixels.
- Commit with the Lefthook pre-commit hooks enabled; they run Brakeman and fix and re-stage style.

## Communication style

- Use simple, controlled English. Follow principles similar to ASD-STE100, but do not claim formal compliance.
- Use short, clear sentences. Put one main idea in each sentence when practical.
- Prefer common words, active voice, and concrete verbs.
- Use the same term consistently for the same thing.
- Avoid idioms, metaphors, filler, and unnecessary jargon.
- Define uncommon abbreviations and technical terms on first use.
- In final answers, put the result first. Then give only the necessary explanation.
- Keep commands, code, file paths, identifiers, product names, and error messages exact.
- Do not remove necessary details or qualifications to make the text simpler.

## Git

Stage, unstage, commit and push only when asked. The user may stage files while you work: if any file is staged, leave the index as it is, report it, and keep working in the working tree.

Commit messages have no issue number (`#13` or `[#13]`). Only the merge request title has one (`docs/merge-requests.md`).

## Definition of done

- The acceptance criteria are met (ask for them if you were not given them).
- Every rule in `CODING_STANDARDS.md` that applies to the change is met.
- `bin/ci` is green.
- The audit records, activity feed entries and notifications the change calls for are written.
- `.env.example`, README, runbooks and `docs/personal-data.md` are updated if affected.
- The decisions taken during the task are recorded as in "When something is unclear".
