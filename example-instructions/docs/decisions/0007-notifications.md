---
status: accepted
---

# Notifications with `noticed`

Notifications go to the in-app bell and by email, with per-user preferences, and must never reach a client for private or internal content. We use `noticed`, with one notifier class per notification type declaring its recipients, message and link, so adding a notification means adding one class and its recipients are easy to check.

## Considered options

- **Our own notifications table and dispatcher:** every event type would be routed through code we maintain.

## Consequences

`noticed` brings two tables (`noticed_events`, `noticed_notifications`). Preferences, the daily digest and the live bell update are built by us.
