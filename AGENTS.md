# Operating Manual — {{owner_name}}'s Second Brain

> Read this file before operating in the vault. Keep it under 100 lines: details live in each project's `references/`.
> Running this as a shared **company brain** (a team, task assignment, a sales pipeline)? See `docs/company-brain.md`.

## Vault identity
- **Owner:** {{owner_name}}
- **Model:** PARA (Tiago Forte) + project folders and natural-language task capture. AI-first, "always bet on text".
- **Primary use:** {{primary_use}}
- **Context on the owner:** `MEMORY.md` (key facts) + `03_Resources/context/_owner.md` (values, goals, criteria). Read them for strategic questions.
- **Language:** {{language}}. **Timezone:** {{timezone}}.

## Structure (PARA)
```
01_Projects/   initiatives WITH a deadline
02_Areas/      ongoing responsibilities (no number prefixes)
03_Resources/  reusable reference
  templates/   note templates
  people/      contacts (by relationship type)
  context/     owner identity (_owner.md)
09_Archive/    completed / inactive / historical
Daily/         daily notes YYYY-MM-DD (they live HERE, not in root)
hub.md         tasks without a project · routines.md recurring · dashboard.md (Tasks view) · MEMORY.md · index.md (MOC)
```
Anti-overcomplication rule: do NOT create empty folders/files. An area grows only with real content.
Naming rule: pick one folder style (snake_case or kebab-case) and stay consistent; notes use kebab-case.

## Capture workflow
When the owner pastes or dictates raw information (a note, a meeting, an idea), file it into PARA:
1. **Pick the bucket.** Deadline + defined outcome -> `01_Projects/`. Ongoing responsibility -> the right folder in `02_Areas/`. Reusable reference -> `03_Resources/`. A person -> `03_Resources/people/`.
2. **Update status/fields** in the note's frontmatter when relevant.
3. **Log dated entries** for anything conversational: `### [YYYY-MM-DD] <channel> | <summary>` + bullets.
4. **Add a line to today's `Daily/`** linking what changed.
5. **Never invent data.** If unsure, leave it blank and add `> TODO: ask {{owner_name}} ___`.
Example: pasted meeting notes about an ongoing client -> update that area note, append a dated log entry, link it from today's Daily.

## Tasks
- Capture: the owner writes in natural language; the agent creates the line in the right file (a project/area file, or `hub.md`).
- Emoji metadata: `📅 YYYY-MM-DD` due · `⏫`/`🔺` high priority · `🔽` low · `🔁 every week` recurring · `✅ YYYY-MM-DD` done. Few tags.
- The Tasks plugin aggregates them into views (Today / Overdue / by file) in `dashboard.md`.

## People & contacts
Contacts live in `03_Resources/people/`, grouped by relationship type (clients, prospects, collaborators, suppliers — create subfolders as you accumulate real contacts). Every contact should link to at least one area/project (and vice versa). When you create or update a contact, check links both ways. A weekly link-hygiene routine lives in `routines.md`.

## Context engine (for strategic questions)
Read `03_Resources/context/_owner.md` (values, decision criteria, goals) + `MEMORY.md`. They are the lens on the owner. Human-owned files: do not overwrite; propose changes or interview (stubs are marked `> Interview gap: ...`).

## Output style
{{style_prefs}}
Example: concise, direct, no filler. Bullets/headers for complex output, plain text for short answers.

## Agent capabilities
This file is read by Claude Code, OpenAI Codex, Google Antigravity and any agent that follows the agents.md standard. The rules above apply to all of them.
Add your own automations here. If you use Claude Code skills, put them in `.claude/skills/` and the agent will auto-discover them; describe their logic in prose above so other agents can do the same manually.

---
*Built on PARA (Tiago Forte) + Karpathy's LLM-Wiki / append-and-review pattern. agents.md standard: AGENTS.md canonical + CLAUDE.md/GEMINI.md symlinks. See docs/philosophy.md.*
