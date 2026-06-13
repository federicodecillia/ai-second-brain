# AI Second Brain

[![smoke test](https://github.com/federicodecillia/ai-second-brain/actions/workflows/smoke.yml/badge.svg)](https://github.com/federicodecillia/ai-second-brain/actions/workflows/smoke.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**A second brain any AI agent can operate.** One canonical `AGENTS.md` rulebook: Claude Code, Codex, and Gemini/Antigravity all read the same rules and maintain the same vault. Built on PARA. Plain markdown + git, no database, no subscription. Ready in 15 minutes.

Works as a **personal** brain or a shared **company brain** — a team, task assignment, and a lightweight sales pipeline. `setup.sh` asks which; the company setup is documented in [`docs/company-brain.md`](docs/company-brain.md).

<!-- TODO: demo GIF here — 60s: clone → ./setup.sh → ask the agent "what should I do today?" -->

## What your agent can do with it

Once set up, you talk to your vault in plain language:

- *"Log this meeting with Anna: she approved the budget, next review in July"* → filed in the right area, dated entry, linked from today's daily note
- *"What should I do today?"* → reads your task dashboard: overdue, due today, priorities
- *"Add a task: send the proposal to Marco by Friday, high priority"* → a properly tagged task line in the right file, visible in the dashboard
- *"What do I know about ACME Corp?"* → pulls the note, linked people, and past dated entries
- *"Start a project for the website redesign, deadline end of September"* → project folder with MOC + tasks, linked to its area

The agent follows the same written rules every time, whichever agent you use.

## Why this exists
- **PARA structure** ([Tiago Forte](https://fortelabs.com/blog/para/)): organize by actionability, not topic.
- **AI-first**: notes are written and maintained with an agent, following Karpathy's LLM-Wiki / append-and-review pattern.
- **Multi-agent**: one canonical `AGENTS.md` (with `CLAUDE.md` / `GEMINI.md` symlinks) means every agent reads the same rules. See `docs/philosophy.md`.

## Quickstart
```
git clone https://github.com/federicodecillia/ai-second-brain.git my-second-brain && cd my-second-brain && ./setup.sh
```
`setup.sh` asks **personal or company/team**, personalizes the vault (name(s), language, your areas), detaches it into your own repo, and can publish it to GitHub for you (`gh repo create`, private by default — personal or org). Then: install the two Obsidian plugins (`docs/plugin-setup.md`) and open the vault with your agent. Full guide: `docs/onboarding.md` · company brain: `docs/company-brain.md`.

On your phone too: `docs/mobile-sync.md` syncs the vault to Obsidian iOS via git, free (no Obsidian Sync subscription). Capture via Siri/Apple Reminders: `docs/reminders-capture.md`.

## What's inside
```
01_Projects/  02_Areas/  03_Resources/{templates,people,context}  09_Archive/  Daily/
AGENTS.md (+CLAUDE.md/GEMINI.md)  hub.md  routines.md  dashboard.md  index.md  MEMORY.md
setup.sh  docs/
```
Plus an example project showing the conventions, six universal note templates, and a smoke-tested setup (CI runs the full new-user flow on every change).

## Customize / go pro
Adapt areas and templates to your field: `docs/customization.md`. Want CRM workflows, custom agent skills, and a done-for-you setup? [Get in touch](https://www.linkedin.com/in/federicodecillia/).

## License & credits
MIT. Built on [PARA](https://fortelabs.com/blog/para/) by Tiago Forte and the [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) / [append-and-review](https://karpathy.bearblog.dev/the-append-and-review-note/) pattern by Andrej Karpathy. Multi-agent via the [agents.md](https://agents.md) standard.
Author: Federico De Cillia.
