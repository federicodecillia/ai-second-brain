# Plugin setup

This vault needs only a minimal set of Obsidian plugins.

## Core (built-in, just enable)
- **Templates** (Settings -> Core plugins): powers the `{{date}}` / `{{title}}` tokens in `03_Resources/templates/`. Set the template folder to `03_Resources/templates`.

## Community (install once)
1. **Tasks** (`obsidian-tasks-plugin`): aggregates `- [ ]` tasks with emoji metadata into the views in `dashboard.md`.
2. **Dataview** (`dataview`): powers the queries in area MOCs and project/person notes.

Install: Settings -> Community plugins -> Browse -> search the name -> Install -> Enable.

> **Cloning a vault that already lists these plugins?** When you open a vault whose `.obsidian/community-plugins.json` names Tasks and Dataview, Obsidian downloads them for you — but does **not** turn them on. You still have to **enable** them: Settings -> Community plugins -> toggle **Tasks** and **Dataview** on (and make sure Restricted Mode is off).

## Troubleshooting
- **`dashboard.md` / `pipeline.md` show raw ```` ```tasks ```` / ```` ```dataview ```` code blocks instead of tables/lists** → the plugin is installed but **not enabled**. Settings -> Community plugins -> toggle Tasks / Dataview on.
- **Views are empty** → that's normal until you have matching notes (tasks with a `📅`/tag, or sales notes with a `status` field).

Everything else is optional. Add what you need; the vault works with just these.
