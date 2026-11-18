---
status: accepted
---

# Authentication with Devise

Account setup, sessions, email changes and 2FA are where security mistakes are most costly, and the team knows Devise well. We use Devise with `devise-two-factor` and `devise_invitable` instead of writing authentication ourselves; we still own the active-sessions table, 2FA enforcement by role and the audit hooks, and each needs specs.

## Considered options

- **Authentication written on the Rails 8 generator:** less to learn, but every security detail is ours to get right.
- **Clerk:** reviewed; a one-day spike would decide if it is reconsidered.
