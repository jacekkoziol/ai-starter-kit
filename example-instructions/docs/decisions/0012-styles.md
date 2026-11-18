---
status: accepted
---

# SCSS with design tokens in Ruby

ADR 0009 left the CSS approach open. We use SCSS with the design system of ExampleCo's Next.js template, ITCSS layers and BEM class names from ExampleCo's Rails projects. The design tokens are Ruby constants, generated into Sass, so Ruby and the styles share one copy of breakpoints, colors and sizes. The rules are in `docs/styles.md`.

## Considered options

- **Tokens in TypeScript, as in the template:** Ruby cannot read them, so breakpoints would be kept in two places by hand.
- **CSS Modules, as in the template:** ERB cannot use their generated class names.
