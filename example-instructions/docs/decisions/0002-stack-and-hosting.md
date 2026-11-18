---
status: accepted
---

# Rails monolith on PostgreSQL, deployed with Dokku on Hetzner

A small team runs the app for a few hundred client organizations at launch, with low running costs and a long maintenance horizon. We build one Rails 8.x app on PostgreSQL, with Solid Queue, Solid Cache and Solid Cable instead of Redis, and deploy it from GitLab CI to Dokku on Hetzner, because ExampleCo already runs its apps this way and its devops team looks after the servers and backups.

## Considered options

- **Redis** for jobs, cache and Action Cable: one more service to run and pay for; the Solid adapters on PostgreSQL are enough at this scale.
- **Kamal:** ExampleCo's deployment and devops support are built around Dokku.

## Consequences

Four databases to run (app, queue, cache, cable) on one Dokku PostgreSQL service, provided and backed up by devops. Deploys go through CI only, so a failing check blocks every deploy.
