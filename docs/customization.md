# Customization

## Adapt the areas
| Vertical | Typical areas |
|---|---|
| Consultant / freelance | clients, marketing, operations, learning |
| Lawyer | active-cases, clients, practice, compliance |
| Designer | clients, portfolio, craft, admin |
| Academic | research, teaching, advising, service |

Create only the areas you actually have (anti-overcomplication).

## Adapt the templates
Templates live in `03_Resources/templates/`. Edit any of them to fit your field — e.g. add a `matter_number` field to `person.md` if you are a lawyer, or a `brief` field if you are a designer. The `{{date}}` / `{{title}}` tokens are filled by Obsidian's core Templates plugin when you insert a template.

## Add your own workflows
Write the procedure as plain prose in `AGENTS.md`, in the imperative, so any agent can run it. Example:
> ## Invoice workflow
> When the owner says "log an invoice", append a row to `02_Areas/operations/invoices.md` with date, client, amount, status. Never invent amounts.

Because it is prose, Claude, Codex, and Antigravity all execute it the same way.

## When to go pro
The pro package adds a client CRM pipeline (status-driven Dataview), custom Claude skills, and MCP automations (calendar, email, payments). [Get in touch](#).
