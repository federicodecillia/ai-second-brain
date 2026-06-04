# AI Second Brain Starter

A second brain that any AI agent (Claude Code, Codex, Gemini/Antigravity) can operate. Built on PARA, ready in 15 minutes.

## Why this exists
- **PARA structure** (Tiago Forte): organize by actionability, not topic.
- **AI-first**: notes are written and maintained with an agent, following Karpathy's LLM-Wiki / append-and-review pattern.
- **Multi-agent**: one canonical `AGENTS.md` (with `CLAUDE.md` / `GEMINI.md` symlinks) means every agent reads the same rules. See `docs/philosophy.md`.

## Quickstart
```
git clone https://github.com/federicodecillia/ai-second-brain.git my-second-brain && cd my-second-brain && ./setup.sh
```
Then: install the two Obsidian plugins (`docs/plugin-setup.md`) and open the vault with your agent. Full guide: `docs/onboarding.md`. Want it on your phone? `docs/mobile-sync.md` (free, no Obsidian Sync).

## What's inside
```
01_Projects/  02_Areas/  03_Resources/{templates,people,context}  09_Archive/  Daily/
AGENTS.md (+CLAUDE.md/GEMINI.md)  hub.md  routines.md  dashboard.md  index.md  MEMORY.md
setup.sh  docs/
```

## Customize / go pro
Adapt areas and templates to your field: `docs/customization.md`. Want CRM workflows, custom skills, and a done-for-you setup? [Get in touch](https://www.linkedin.com/in/federicodecillia/).

## License & credits
MIT. Built on [PARA](https://fortelabs.com/blog/para/) by Tiago Forte and the [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) / [append-and-review](https://karpathy.bearblog.dev/the-append-and-review-note/) pattern by Andrej Karpathy. Multi-agent via the agents.md standard.
Author: Federico De Cillia.
