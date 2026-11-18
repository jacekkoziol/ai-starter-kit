# Sample Portal

The client portal for SampleSite, where clients and the delivery team run website builds and monthly care for small businesses.

## Language

### Companies

**SampleSite**: The service clients buy: a WordPress website build and monthly care on a program.

**ExampleCo**: The company that runs SampleSite and does its work; its employees in the portal are the staff. _Avoid_: Sample (for a company)

**Organization**: A company that has projects in the portal and client users who act for it. ExampleCo is not an organization; its employees are staff. _Avoid_: client organization, client company, customer, internal organization

### People

**Client user**: A user who belongs to one or more organizations, as an organization owner or organization member in each. _Avoid_: client (for one person)

**Organization owner**: A client user who holds the organization owner role in an organization, which lets them also pay, manage the card and program, approve quotes and request projects. _Avoid_: client owner

**Organization member**: A client user who holds the organization member role in an organization, which lets them request tasks, talk to the team and approve finished work, but not pay. _Avoid_: client member, member (alone)

**Admin**: A staff member who holds the admin role, with full access, including leads, users and payments. _Avoid_: Sample admin

**Staff**: ExampleCo's employees in the portal: everyone who can see private messages, staff-only threads and internal tasks. What else each one may do comes from their roles. _Avoid_: team (for staff in general), ExampleCo user, internal user

**Website Manager**: The member of the project team who is responsible for the project; one per project, chosen by an admin. Only qualified staff may be chosen (#21).

**Project team**: The staff who hold a role in a project, including its Website Manager. _Avoid_: project members

**Two-step verification**: Signing in with a code from an authenticator app after the password. _Avoid_: 2FA, two-factor authentication

**Recovery code**: A single-use code that replaces the authenticator app code at sign-in, for example after a lost phone. _Avoid_: backup code

### Leads and projects

**Request**: What a client submits to get a new project, through an intake form or "New project" in the portal. _Avoid_: submission

**Intake form**: A public form in the portal (Start my website, Build only, Send me my program) that a visitor submits as a request. _Avoid_: public form

**Lead**: The record of a request before its first payment, which an admin approves or declines.

**Approve (a lead)**: An admin's decision to take on a lead and choose its Website Manager; the project stays a lead until the first payment. _Avoid_: accept

**Project**: A build or care engagement with one organization.

**Build project**: A project to build a new website, sold as build with program or build only.

**Program project**: A project to look after an existing website on a program, with no build. _Avoid_: care project, care-only project

**Launch**: The moment a project goes live; for a build with program, it also starts the program.

**Activity feed**: A project's record of what happened, with each entry shown to everyone, staff only or admins only. _Avoid_: history

**Waiting for you**: The part of the client dashboard that lists what a client user must act on: invoices to pay, quotes to approve and work to review.

### Programs and billing

**Program**: The Care Program or the Growth Program: the monthly service a project pays for, from launch for a build with program, or from the first payment for a program project. A build is not a program. _Avoid_: plan, subscription (for the service)

**Build with program**: A build bought together with a program, at the lower build price.

**Build only**: A build bought without a program.

**Subscription**: The Stripe subscription that bills a project's program each month. _Avoid_: program (for the billing record)

**Commitment**: The minimum length of a program, 12 months from its start (which programs it applies to is still open). _Avoid_: minimum term, minimum plan term

**Pay beforehand**: The payment choice where the client pays when submitting the request. _Avoid_: pay now, pay at submission

**Pay after approval**: The payment choice where the client pays once an admin approves the lead.

**First payment**: The payment that moves a project out of `lead`: the build price, or the first program month for program projects.

**Invoice**: A record in the portal of an amount an organization owes for a build, a program month, a paid task or a one-off charge.

### Work

**Task**: A piece of work on a project, with a billing type.

**Billing type**: What decides whether and how a task is paid for and who sees it: included, paid or internal. _Avoid_: task type, type

**Included task**: A small edit within the allowance, with no quote.

**Paid task**: A task that is quoted, approved, invoiced and paid before work starts.

**Internal task**: A staff-only task, never visible to clients.

**Allowance**: The minutes of included work per project per calendar month (60). _Avoid_: small-edit allowance

**Quote**: The price of a paid task that staff send to the organization owners for approval. _Avoid_: estimate (for what the client approves)

**Review**: The step where a client user checks finished work and either approves it or requests changes. _Avoid_: acceptance

**Override**: An admin acting on behalf of a client or skipping a rule; always recorded in the audit log.

### Conversations

**Thread**: A list of messages on a project, optionally about a task. _Avoid_: channel

**General thread**: The thread every project starts with; its first message is the request brief.

**Staff-only thread**: A thread only staff can see. _Avoid_: team-only thread, private thread

**Private message**: A message only staff can see, in any thread. _Avoid_: internal message

**Public message**: A message visible to everyone who can access its thread.

**Inbox**: The staff page that lists the threads of every project they may see, newest first, with the selected thread beside the list.

### Access

**Capability**: Something a role lets its holders do that other users may not, such as approving a quote. Some capabilities only staff may hold. _Avoid_: permission (for one capability), ability

**Role**: A named set of capabilities, such as admin or organization owner. _Avoid_: permission set, group

**Role assignment**: A role given to one user: everywhere, in one organization or in one project. A user's capabilities in a place are those of all the roles that apply there; a role in an organization also applies to its projects.

### Administration

**Deactivation**: Stopping a user from signing in while keeping their account and history. _Avoid_: deletion

**Erasure**: Anonymizing a user's personal data on request, while keeping non-personal records such as invoices. _Avoid_: deletion

**Stopgap**: Something admins cannot yet do in the portal, done by a developer in the console by following a runbook.

**System job**: Work the portal runs in the background, such as sending an email; admins see it in the system jobs dashboard. _Avoid_: job (alone), except in Active Job's own terms such as job arguments

### Content

**Section**: One part of a marketing page, of one section type, such as the hero or the FAQ. _Avoid_: block, module, component, layout, flexible content

**Section type**: A kind of section that developers define in code: its fields and how the website shows it. _Avoid_: template, schema

**Hidden section**: A section that the website does not show; its content stays. _Avoid_: turned off, disabled, unpublished section

**Anchor**: A short name of a section, unique in its page, that a link uses to jump to that section. _Avoid_: section ID, ID

**Price placeholder**: A short code in content text that the website replaces with one of our current prices, for example `{{care_price}}`. _Avoid_: price token, shortcode, variable, merge tag

**Visual**: One of a fixed set of illustrations (the 3D renders) that only developers add, which content picks for an image. Its files are on Bunny Storage. _Avoid_: render, asset, illustration, stock image

## Relationships

- A **Client user** belongs to one or more organizations through **Role assignments**, as **Organization owner** or **Organization member** in each.
- A staff member holds **Role assignments** everywhere, in organizations or in projects, and can hold several **Roles** at once. Staff are not client users of any organization.
- A **Request** creates a **Lead** and a **Project** in `lead`; the project leaves `lead` only with its **First payment**.
- A **Project** belongs to one organization and has one **Website Manager** within its **Project team**.
- A **Build only** project has no **Program**; every other project has one program, billed by one **Subscription**.
- A **Paid task** has at most one **Invoice**.
- A **Thread** belongs to a project and may be about one **Task**.

## Flagged ambiguities

- "Request" was used both for what a client submits to get a project and for a task a client asks for (status `requested`). Resolved: **Request** means the project request; a client's task is a **Task** in `requested`.
- "Staff" was used both for ExampleCo and for its employees in the portal. Resolved: **Staff** means the employees.
- "Team-only thread" used "team" for staff in general, but admins who are not on the project team see these threads too. Resolved: **Staff-only thread**.
- "Channel" was used both for the ways content reaches people (pages, emails, live updates, downloads) and for where a lead came from (`website` or `portal`). Not resolved.
- "Minimum term" and "commitment" named the same thing; the planned code uses `commitment`. Resolved: **Commitment**.
- The proof of concept said "accept" a lead; this app says **Approve**.
- "Organization" was used both for a client's company and for ExampleCo. Resolved: an **Organization** is a client's company; ExampleCo is not an organization.
- Sample and ExampleCo were described as two companies, with admins at Sample and delivery staff ("ExampleCo users") at ExampleCo. Resolved: **ExampleCo** is the only company; every staff member works for it, and their roles say what each does.
- "Care" named both a kind of project and the Care Program. Resolved: the project with no build is a **Program project**; Care means only the Care Program.
- "Plan" (this app) and "Program" (the marketing site: "Growth Program") named the same monthly service, and the layout exploration also called a build a program. Resolved: **Program** means the Care Program or the Growth Program; a build is not a program.
