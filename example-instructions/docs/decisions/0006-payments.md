---
status: accepted
---

# Payments with the `stripe` gem, calling Stripe first

Payments cover build checkout, Care and Growth subscriptions with a commitment, and paid-task invoices, and billing is where data-integrity bugs cost the most. We use the `stripe` gem directly, with our own `invoices` table as the source of truth for numbering and status. In multi-step flows we call Stripe first when the local record depends on its result, with an idempotency key, so every step is safe to repeat.

## Considered options

- **The `pay` gem:** its models would own the billing state; we want our own numbering and statuses.
- **A fake payment gateway for development:** rejected so that no bypass can reach production; development uses Stripe test mode and the Stripe CLI.

## Consequences

Developers need a Stripe test account and the Stripe CLI. An invoice cannot be marked paid without Stripe, except by the audited admin "mark paid" action. Moving invoices to Stripe Invoicing (an open question) would change this ADR.
