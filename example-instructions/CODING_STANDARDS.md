# Coding standards

How code in Sample Portal is written. Read it before writing or reviewing code. Reasons for bigger choices are in the ADRs (`docs/decisions/`); domain terms are in `GLOSSARY.md`.

**Styles:** before writing SCSS, adding classes or an icon to a view, or changing a design token, read `docs/styles.md`.

**Forms:** before building or changing a form, read `docs/forms.md`.

**Emails:** before writing an email, or changing the email layout or an email component, read `docs/emails.md`.

**Marketing pages:** before adding or changing a marketing page or a section type, read `docs/marketing-pages.md`.

## Architecture

A modular monolith: one Rails app, organized in areas that match the business.

| Area | Covers |
| --- | --- |
| Identity | Users, organizations, sign-in, 2FA, invitations |
| Intake | Leads, intake forms, the "create request" flow |
| Projects | Projects, statuses, project team |
| Billing | Stripe, invoices, payments, programs |
| Work | Tasks, quotes, approvals, allowance |
| Conversations | Threads, messages, files, live updates |
| Notifications | Notifiers, email layout, bell |
| Administration | Settings, audit, system jobs, runbooks |
| Content | Marketing pages, section types, and later the content editor |

- One area uses another through its services, never by changing its records directly (Work asks Billing to issue an invoice).
- New modules (for example a partner portal) are added as new areas.

| Path | What |
| --- | --- |
| `app/services/<area>/` | Business actions: `Area::DoThing.call(...)` |
| `app/models/<model>/` | Concerns used by one model, such as `User::TwoFactor` |
| `app/controllers/concerns/` | Concerns of `ApplicationController`, such as `TwoFactorRequirement` |
| `app/policies/` | Action Policy rules and scopes |
| `config/capabilities.rb`, `config/roles.rb` | The capabilities, and the roles that group them |
| `app/notifiers/` | `noticed` notifiers, one per event |
| `app/controllers/` | Thin resource controllers shared by every signed-in role (policies decide what each sees) |
| `app/controllers/admin/` | Admin-only screens |
| `app/controllers/public/` | Public intake forms |
| `app/controllers/dev/` | Development-only screens, such as `/_dev/styleguide` |
| `app/controllers/content/` | The public marketing pages |
| `config/section_types/`, `app/views/content/sections/` | The section types, and the partial of each |
| `app/views/` | ERB views and partials, each with its stylesheet next to it |
| `app/views/objects/` | Reusable partials with no feature knowledge, rendered by `o_<name>` helpers |
| `app/frontend/` | JavaScript and SCSS built by Vite |
| `config/locales/` | All user-facing text |

## Stack

Rails 8.1, Ruby 4.0, PostgreSQL. Solid Queue, Solid Cache and Solid Cable in their own databases (production URLs derived from `DATABASE_URL`). Turbo, Stimulus, ERB partials and helpers, Vite with pnpm, SCSS with design tokens in Ruby, Action Text with Lexxy. Devise with `devise-two-factor` and `devise_invitable`. Action Policy. AASM. The `stripe` gem. `noticed`. `paper_trail` writing to `audit_events` (version class `AuditEvent`). SendGrid with Action Mailbox. Active Storage on a Dokku storage mount (S3-compatible storage in #72). Bunny Storage for the visuals, and for content images until the content editor exists (`docs/content-images.md`). Sentry. RSpec and factory_bot.

The `lexxy` gem and the `@37signals/lexxy` npm package stay on the same version; check the release notes when upgrading. `package.json` pins the npm package to an exact version, and `bin/paired-versions`, run by `bin/ci`, checks the gem and npm pairs listed in it.

Rails 8.1 has no Action Text editor adapter, so Lexxy patches the Action Text helpers. To keep the move to a Rails version with the adapter small:

- Views call `rich_textarea` and `rich_textarea_tag`, never the `lexxy_` helpers, which go away with the adapter.
- The upgrade sets `config.action_text.editor = :lexxy` (or loads that Rails version's defaults, if they choose Lexxy), and checks any change we make to the Action Text sanitizer lists: with the adapter, Rails allows Lexxy's markup and Lexxy no longer changes the lists.

## Private data

Private messages, staff-only threads and internal tasks reach staff only, through every channel:

- Every controller action is authorized (`verify_authorized`); lists use policy scopes; IDs in URLs are never trusted.
- Live updates use separate public and staff streams, with permission checked on every subscription.
- Notifiers address only staff for private or internal content.
- Files inherit the visibility of what they are attached to and are downloaded only through the authorized controller, with short-lived URLs, never through Active Storage's default public routes. Files of deleted messages are served to admins only.
- An internal task keeps the internal billing type for its whole life.
- Every channel has visibility specs.

## Code

- **Routes** go in the `:locale` scope of `config/routes.rb`; portal routes also in its `portal` scope (`/en/portal/...`), and the marketing pages, the blog and the intake forms outside it. Paths that are not pages of the app start with an underscore and have no locale: `/_dev`, the health check `/_up`, the built assets in `/_assets` (Propshaft) and `/_vite` (Vite, in production), and the email images in `/_email` (`public/_email`). Links get the locale from `default_url_options`; specs use path helpers.
- **Controllers** authorize, call one service, and render or redirect. Shared screens use one resource controller for every role; only admin-only screens get an `Admin::` namespace, and intake forms a `Public::` one.
- **Services** are called as `Area::DoThing.call(...)` and return the record they changed, or raise a specific error. Invalid input raises `ActiveRecord::RecordInvalid`; its record has the translated field errors. A broken business rule raises the service's own error class. Every path that performs an action calls the same service, so the paths cannot drift apart. A few class methods that share one data format may stay in one service, such as `Identity::TwoStepSignIn` (`start`, `user`, `finish`). A service may return plain secrets that are never stored, such as the recovery codes from `Identity::EnableTwoFactor`.
- **State changes** only through AASM events, each recorded in `state_transitions` with the actor.
- **Concurrency:** a service that changes state locks the record (`with_lock`) and re-checks it. Unique indexes back up every "only one" rule (one invoice per task, one record per Stripe event or payment).
- **Outside calls the action needs** (starting a program in Stripe) run before the local change is saved, with an idempotency key built from our record, so a failure changes nothing and the action can be retried. No transaction or lock is held during the call.
- **Incoming webhooks** check the signature, store each event once (unique provider event id) and return 200. A job processes it: it fetches the object from the provider, acts on its current state rather than the event payload, and marks the event processed only on success.
- **Side effects after commit:** emails, notifications, broadcasts and other outside calls run after the database commit (`ActiveRecord.after_all_transactions_commit` or a job). State history is written inside the transaction.
- **Audit:** `paper_trail` records changes to settings, role assignments, a project's Website Manager and organization details; services write other events (sign-in failures, admin overrides, a lead approval) as `AuditEvent` rows. Both are written inside the transaction. The actor is the signed-in user in a web request; services also take it as `actor:`, for jobs. Audited models change only through methods that run callbacks, in code and in the console, so `paper_trail` records every change.
- **Policies** check capabilities with `can?`, never role names or `users.kind`, except that private content depends on `users.kind` alone. Only policies check capabilities: views and controllers ask the policies.
- **Views** show only the actions the policy allows and leave workflow rules to services and policies; their data comes from the controller.
- **Background jobs** are safe to run twice and let errors raise so they are retried and reported. The queue stores their arguments as plain JSON, so arguments are records, IDs or encrypted values, never secrets or personal data. Encrypt with `ActiveRecord::Encryption.encryptor`, as `DeliverMailJob` does, and keep the previous encryption keys while queued or failed jobs may still use them. `config/initializers/job_arguments.rb` refuses an argument with a key that `filter_parameters` hides, so pass an encrypted value as a plain string or under a key it does not match, such as `ciphertext`, not `encrypted_mail`. The check cannot see a plain string or a custom serializer's object. The same applies to concurrency keys and to `html:` or `content:` given to `broadcast_*_later`.
- **Database:** foreign keys, `NOT NULL` where required, check constraints for enum values, indexes on foreign keys and the filters the real queries use. Write an `IN` list on a string column as `column::text IN (...)`, so `db/schema.rb` dumps the same from migrations and from a schema load. `db/schema.rb` until something it cannot store (sequence, trigger, function, view) is added; that merge request switches to `structure.sql`. Role keys are the exception: they have no check constraint, so adding a role in `config/roles.rb` needs no migration. Enum values, AASM states and events are stored as keys and translated only for display, in `activerecord.enums.<model>.<attribute>.<value>`, read with `Model.human_enum_name(:<attribute>, value)`; not in `activerecord.attributes.<model>/<attribute>` (`spec/i18n_spec.rb` refuses it). Staff are found by `users.kind`.
- **Time:** the app runs in UTC. Rules that depend on dates (for example the monthly allowance) use UTC even once users pick a time zone.
- **Money** in integer cents, USD for now. Show it with `app_money` (`MoneyHelper`): "$1,234.00", or with `zero_cents: false` "$590", as prices in content text show.
- **Settings** through the settings registry: one line in `config/settings.rb`, read with `Setting.get(:key)` (not in an initializer), changed with `Administration::UpdateSetting`. Which values are settings rather than hard-coded is open, so ask.
- **Configuration** only through environment variables, each listed in `.env.example`. A variable production cannot run without is also added to `RequiredEnv::NAMES`, checked at boot.
- **Text** in locale files; `spec/i18n_spec.rb` checks the keys with `i18n-tasks`. The exception is the content of the marketing pages that the content editor will hold: it is written in the page's view (`docs/marketing-pages.md`).
- **Comments** only for a non-obvious "why". Helpers that views share, such as the `o_` helpers, are documented with YARD tags (`docs/styles.md`).
- **Caching** only where measured.

## Payments

- **Idempotency keys** for Stripe calls are built from our record, for example `invoice-123-checkout`. A retry of the same attempt reuses the key. A new attempt after a confirmed failure gets a new key, because Stripe replays the cached error for about 24 hours.
- **Checkout sessions** take cards only. Their metadata carries the project id, the invoice id (if any) and a purpose: `first_payment`, `invoice` or `program`.
- Only a `first_payment` moves a project out of `lead`. Settling any other invoice never changes a lead or a project status.
- Closing a project, declining a lead or voiding an invoice first expires its open Checkout sessions. If one has already completed, the action is refused.
- Product prices (builds and programs) come from Stripe. The hourly rate for task quotes is a setting.

## Security

Target: OWASP ASVS Level 2 basics.

- Strong parameters (`params.expect`), CSRF protection, secure HTTP-only SameSite cookies, `force_ssl` with HSTS, a strict Content Security Policy with nonces, a permissions policy.
- The Content Security Policy allows `style` attributes with `style-src-attr 'unsafe-inline'`: views set custom properties inline, such as the gap of `o_stack`. Scripts and `<style>` elements still need a nonce.
- **Fail closed:** a missing secret (Turnstile, Stripe webhook, OAuth, encryption keys) stops the feature or the boot in production. Code reads secrets with `ENV.fetch` without a default, and never rescues a missing one.
- Rails `rate_limit` on sign-in, two-step verification, password reset, verification and the intake forms, keyed on the real client IP, IPv6 by its /64 (Cloudflare's ranges are trusted proxies, #73).
- Intake forms keep CSRF protection and add Turnstile, a honeypot and rate limits; no cross-site endpoint.
- Secrets and tokens encrypted or hashed; 2FA secrets with Active Record Encryption; lead IPs only as a keyed hash.
- Brakeman warnings are fixed, or accepted in `config/brakeman.ignore` with a reason. `bundler-audit` and `pnpm audit` run daily in GitLab CI and in `bin/ci`; an advisory is ignored only in `config/bundler-audit.yml` or `pnpm-workspace.yaml`, with a reason.
- Passwords, tokens and message bodies are filtered from logs and Sentry.
- Exception messages and log lines never include a secret or personal data; they give the record's id. The filters do not reach them, and failed jobs keep their messages. Wrap an outside library's error that can include URLs, headers or bodies.
- Every account starts with an invitation (from an admin or the intake forms); other sign-in methods only sign in existing accounts.
- Pages keep secret whether an email has an account (Devise `paranoid` mode); the only accepted exception is the intake forms' "please sign in" message.
- Erasure anonymizes a user and keeps non-personal records such as invoices, so records that point to a user keep the reference.

## Tests

- RSpec with factory_bot, shoulda-matchers and WebMock; no real network calls.
- **Coverage at least 95%**; files skipped from coverage are listed in the SimpleCov config with a reason.
- Every policy rule has a spec for the roles it allows and refuses.
- Screens are covered by request specs. Browser tests are low priority.
- Prosopite raises on N+1 queries in specs.
- Examples are grouped by condition in `context` blocks starting with "when", "with" or "without"; each `it` names one outcome.

## Front end

- WCAG 2.2 AA: semantic landmarks, labeled inputs, visible focus, sufficient contrast, touch targets at least 24 × 24 px or spaced so that a 24 px circle centred on each smaller one touches no other target or circle (success criterion 2.5.8), keyboard-operable menus and dialogs with focus trapping.
- **Messages:** after a redirect, set `flash[:notice]` or `flash[:alert]` (or `:info`, `:success`, `:warning`, `:danger`; an array gives one message each). The layout's flash component shows them under the header's bar, over the page, until the user closes them, and announces them to screen readers. The sign-in pages show them in their card. After creating or saving a record, use `record_notice(:created, record)` or `record_notice(:saved, record)` ("The organization was saved."). A message about an action that changes the page in place goes next to that action, with `o_notice`.
- **Images:** resize images only in background jobs: declare each size as a named variant with `preprocessed: true`, and show the original until the variant is processed.
- Every screen works on a phone (about 390 px wide) and a desktop; wide tables scroll inside their own container. Breakpoints and navigation come from the designs.
- Public pages: LCP under 2.5 s, INP under 200 ms, CLS under 0.1. Portal pages: under 200 ms for 95% of requests at launch data volumes.

## Recipes

- **Business action:** a service in `app/services/<area>/` with a spec covering success, refusal and locking.
- **Permission:** a rule in the policy, with a spec for the roles it allows and refuses. When it is something some roles may do and others may not, define a capability in `config/capabilities.rb` (staff-only unless clients may hold it), add it to the roles in `config/roles.rb`, and check it with `can?`.
- **Status or transition:** an AASM event on the model, a service that performs it and records it, specs for allowed and refused cases.
- **Notification:** an `ApplicationNotifier` in `app/notifiers/` with `recipients` (filtered by the record's policy), `staff_only?`, `message` (text in `notifiers.<name>`), `path` (emails build the URL from it), `current_for?` if access or the record can change before the email goes out (the bell checks it too), `actor` from the record (`params[:actor]` loads one user per row), `detail`, `title` and `preview` for the list's row when `message` alone is not enough, and `record_preloads` for the associations those methods read. Deliver it with `with(record:, actor:)` inside the service's transaction; `ApplicationNotifier` sends after the commit. A service that deletes the record also deletes its notifications (`Noticed::Event.where(record:).destroy_all`), so the bell does not count them. Add an email preview; spec the recipients, that the actor is not notified and that clients never get staff-only content.
- **Setting:** define it in `config/settings.rb` with type and default; add it to `docs/runbooks/settings.md`.
- **Shared building blocks** (settings, pagination, money formatting, seed data) are built by the first task that needs them.
