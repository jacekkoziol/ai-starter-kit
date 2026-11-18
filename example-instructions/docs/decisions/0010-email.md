---
status: accepted
---

# Email with SendGrid, reply by email with Action Mailbox

The app sends transactional email and turns replies to `reply+<token>@...` addresses into thread messages. We use SendGrid, ExampleCo's usual email provider, for outbound mail (Action Mailer over SMTP) and inbound mail (Inbound Parse posting to Action Mailbox's SendGrid ingress); mailbox code does not depend on the provider, so changing provider later only changes configuration.

## Consequences

Replies by email come after launch (#54); until then, notification emails ask for replies in the portal. Inbound Parse must have "post the raw, full MIME message" enabled, with the ingress password in the URL's basic auth. Anything that cannot be posted is quarantined, so no email is lost.
