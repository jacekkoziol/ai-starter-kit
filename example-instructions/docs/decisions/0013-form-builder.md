---
status: accepted
---

# Our own form builder

Forms use `o_form_with` and its builder, `Objects::FormBuilder`, not simple_form or another form gem. Each field is an object partial with BEM classes, like the other objects, so the views and styles of fields follow the rules of every other object. The builder is based on the one in ExampleCo's Crave. Errors follow the GOV.UK Design System: an error summary at the top of the form, linked to the fields, and "(optional)" on the fields that are not required. How to build a form is in `docs/forms.md`.

## Considered options

- **simple_form:** its wrappers are set up in its own configuration, outside the object partials, and it is one more gem to keep up to date.
- **Our builder as the default for every form:** Devise's views and gems that call `f.text_field` would get our fields, which they do not expect. `o_form_with` is used explicitly instead.

## Consequences

- Rails' `field_with_errors` wrapper is turned off for the whole app (`config.action_view.field_error_proc`), because the fields show their own errors.
