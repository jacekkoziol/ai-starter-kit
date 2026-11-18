---
status: accepted
---

# Email HTML with MJML, compiled by hand

Emails must show correctly in common email clients. Some clients drop the `<style>` element, and classic Outlook on Windows draws HTML with Word, which needs tables and conditional comments. We write the email layout and the email components in MJML, compile them by hand with `pnx mjml`, and commit the source and the output, so the app needs no MJML package (`docs/emails.md`).

## Considered options

- **ERB with our own tables, and a CSS inliner (`premailer` or `roadie`) when each email is sent:** we would write and keep the Outlook markup ourselves, and the inliner is one more gem.
- **MJML when each email is sent (`mjml-rails` with Node or the `mrml` native gem):** every email would be MJML, with a runtime dependency.
- **Maizzle or Bootstrap Email:** they use Tailwind or Bootstrap classes, which ADR 0009 and ADR 0012 do not use.

## Consequences

The content of each email gets the font and text color from the layout's inline styles, and paragraph margins and link colors from its `<style>` element. A client that drops the `<style>` element shows default margins and link colors. Components that must look the same everywhere, such as the button, keep all their styles inline. The output can drift from its source, because nothing checks it: recompile after each change to the source or to the design tokens it reads.
