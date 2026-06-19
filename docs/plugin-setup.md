# Plugin setup

This vault runs on a deliberately small set of Obsidian plugins. Here is exactly which ones, and what each unlocks, so you only install what you actually need.

## At a glance

| Plugin | Type | Powers this feature | Needed for |
|---|---|---|---|
| **Tasks** (`obsidian-tasks-plugin`) | Community | The task cockpit in `dashboard.md`: aggregates every `- [ ]` line (with its `📅` due date, priority and `🔁` recurring markers) into Overdue / Today / by-project views. | **Required** for the task dashboard. |
| **Dataview** (`dataview`) | Community | The live tables in area MOCs, people notes and `pipeline.md` (sales): anything that reads `status`, `last_interaction` or other frontmatter fields. | **Required** for area / pipeline views. |
| **Templates** | Core (built-in) | The `{{date}}` / `{{title}}` tokens when you insert a note from `03_Resources/templates/`. | Recommended. |
| **Obsidian Git** (`obsidian-git`) | Community | Auto pull / commit / push to your GitHub remote, on desktop and on iOS. | Only for git sync / mobile. See [mobile-sync.md](mobile-sync.md). |

Without Tasks and Dataview the vault still works as plain markdown; only the generated dashboards stay as raw code blocks until you enable them.

## Install the two community plugins (once)

Settings → **Community plugins** → Browse → search the name → **Install** → **Enable**. Do this for **Tasks** and **Dataview**.

## Enable the core Templates plugin

Settings → **Core plugins** → toggle **Templates** on. Then Settings → Templates → set the template folder to `03_Resources/templates`.

> **Cloned a vault that already lists these plugins?** Obsidian reads `.obsidian/community-plugins.json` and downloads them, but does **not** turn them on. You still have to **enable** each one (Settings → Community plugins → toggle on), and make sure **Restricted Mode is off**.

## Troubleshooting

- **`dashboard.md` / `pipeline.md` show raw ```` ```tasks ```` / ```` ```dataview ```` blocks instead of tables** → the plugin is installed but **not enabled**. Settings → Community plugins → toggle Tasks / Dataview on.
- **A view is empty** → that is normal until you have matching notes (a task with a `📅` or tag, or a note with a `status` field).
- **On a freshly cloned vault the plugins look gone** → plugin *code* is gitignored by design (only the list syncs, which keeps tokens out of git). Reinstall from Browse, then enable. Full detail for the phone in [mobile-sync.md](mobile-sync.md).

Everything else is optional. Add what you need; the vault works with just Tasks + Dataview.
