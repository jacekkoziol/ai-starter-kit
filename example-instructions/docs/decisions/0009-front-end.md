---
status: accepted
---

# Turbo, Stimulus and ERB partials; no Tailwind

The app stays server-rendered inside the Rails monolith, and back-end work has to start before the designs are final. We use Hotwire (Turbo and Stimulus) with ERB partials and helpers, built by Vite with npm packages, Action Text with the Lexxy editor instead of Trix, and no Tailwind or ViewComponent; the CSS approach is chosen by the front-end developer.

## Considered options

- **Tailwind and ViewComponent:** the team prefers plain partials and CSS.
- **importmap:** Vite gives access to npm packages and, if wanted, Sass or PostCSS.

## Consequences

Partials are tested through request specs rather than in isolation.
