---
name: domain-modeling
description: Sharpen the domain language and keep GLOSSARY.md current. Use when a domain term is unclear, disputed or missing from GLOSSARY.md, or when editing GLOSSARY.md.
---

# Domain modeling

This skill is for changing the domain language. To borrow terms, reading `GLOSSARY.md` is enough.

## While you work

- **Conflict:** when someone uses a term in a way that conflicts with `GLOSSARY.md`, say so at once: "The glossary defines a lead as the record before the first payment, but you seem to mean the project. Which is it?"
- **Vague word:** when a word is vague or has two meanings, propose one precise term: "By 'client', do you mean the organization or a client user?"
- **Scenario:** test a definition against concrete edge cases until its boundaries are exact: "A care project's first payment fails. Is it still a lead?"
- **Code:** when someone says how something works, check the code. Name any contradiction between the words and the code before you change either.
- **Decision:** the user chooses the canonical term. Propose one, then wait for the answer.

## Update GLOSSARY.md

- Write each term into `GLOSSARY.md` as soon as it is settled, following the structure the file already has.
- **One term:** when several words name the same thing, pick the best one and list under `_Avoid_` the others that people actually use.
- **Short definition:** one or two sentences that say what the thing is, not how the code stores it.
- **Product terms only:** general programming terms, and Stripe's terms that the product gives no meaning of its own, stay out.
- Rewrite or remove the terms a change replaces. The glossary gets shorter as often as it gets longer.
- When a term replaces a word that had two meanings, record it under "Flagged ambiguities".
- When a term changes, list the places in code and docs that still use the old word, and ask whether to rename them in this merge request.
- `GLOSSARY.md` holds terms only. A rule goes in `CODING_STANDARDS.md`, a decision that meets the test in `docs/decisions/README.md` in an ADR (offer it; do not write it unasked), and an open question in the issue tracker or the merge request.

Done when every term settled in the session is in `GLOSSARY.md`, and no entry holds implementation detail.
