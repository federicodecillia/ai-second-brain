# Use it as a company brain (team mode)

This vault works for one person out of the box. It also runs as a **shared company brain** for a small team: assign tasks to each other, see project status, and track a sales pipeline (prospects → quotes → clients). This page is the complete guide.

`./setup.sh` can set most of this up for you — pick **company/team** when it asks for the mode. This page documents what that produces (and how to do it by hand).

## What changes vs. personal mode

| Concept | Personal mode | Team mode |
|---|---|---|
| Identity | one owner (`_owner.md`) | company + people (`_company.md` + `context/team/`) |
| Tasks | just tasks | tasks **assigned** with a person tag (`#alex`, `#sam`) |
| Dashboard | one set of views | **per-person** sections + unassigned |
| Sales | — | lightweight pipeline: `status` field + `pipeline.md` |

Everything else (PARA, capture workflow, daily notes, people, templates) is identical.

## 1. Identity: company + people

Team mode replaces the single `03_Resources/context/_owner.md` with:
- `03_Resources/context/_company.md` — what the company is, offering, ICP, values, goals. The lens for strategic questions.
- `03_Resources/context/team/<name>.md` — one profile per teammate (role, how to assign them work).

In `AGENTS.md`, the identity line becomes a team:
```
- **Team:** Alex Rivera (`#alex`) · Sam Lee (`#sam`). Both are owners/operators.
```
and the context-engine line points to `_company.md` + `context/team/` instead of `_owner.md`.

## 2. Assign tasks with a person tag

Capture stays natural language; the agent writes the task line and tags the assignee:
```
- [ ] send the ACME proposal 📅 2026-06-20 ⏫ #sam
```
- `#alex` / `#sam` = assignee (first name, lowercase). No tag = unassigned.
- All the usual emoji metadata still applies (`📅` due, `⏫`/`🔽` priority, `🔁` recurring, `✅` done).

## 3. Per-person dashboard

`dashboard.md` gains a section per teammate plus an unassigned bucket. Each is a Tasks query:
```tasks
not done
tags include #alex
sort by due
sort by priority
```
Unassigned uses one `tags do not include #<name>` line per teammate (the Tasks plugin ANDs them):
```tasks
not done
tags do not include #alex
tags do not include #sam
sort by due
```

## 4. Lightweight sales pipeline

Track deals without a separate CRM. Two ideas only: a **status field** and a **cockpit**.

- Every contact (`03_Resources/people/...`) and every quote carries `status:` in frontmatter — one of `lead · prospect · quote · client · lost`.
- Quotes are one note each in `02_Areas/sales/quotes/` (template `03_Resources/templates/quote.md`), with `client / amount / currency / valid_until / status / project`.
- `pipeline.md` groups everything by stage with Dataview. To advance a deal, change its `status`.
- A won quote → create a project in `01_Projects/` and link it from the quote's `project:` field.

Requires the **Dataview** plugin (alongside Tasks). `pipeline.md` ships ready to use; the key views:
```dataview
TABLE WITHOUT ID file.link AS Quote, client AS Client, amount AS Amount, status AS Stage
FROM "02_Areas/sales/quotes"
WHERE status != "lost"
SORT status ASC
```

## 5. Working as a team (conventions)

- **One git remote, both push.** Put the vault in a private repo (e.g. a GitHub org). `setup.sh` offers to create + push it for you (`gh repo create`), or do it manually. Both teammates get write access.
- **Pull before you work, push when you stop.** Plain git; markdown merges are usually trivial. Mobile sync still works (`docs/mobile-sync.md`).
- **Daily notes are personal-ish but shared.** Each entry is dated and attributed in prose; conflicts are rare because you append.
- **Keep `_company.md` current.** Review it quarterly together — it's what makes the agent's strategic answers good.

## Do it by hand (no setup.sh)

1. `git mv 03_Resources/context/_owner.md 03_Resources/context/_company.md` and rewrite it for the company.
2. Create `03_Resources/context/team/<name>.md` per teammate.
3. In `AGENTS.md`: change the `Owner:` line to `Team:` and point the context-engine line to `_company.md`.
4. Replace the views in `dashboard.md` with the per-person blocks above.
5. Create `pipeline.md`, `02_Areas/sales/`, and `03_Resources/templates/quote.md` from the snippets above (or ask your agent: "scaffold the team sales pipeline").

That's the whole thing. Start with identity + assignment; add the pipeline when you actually have deals to track.
