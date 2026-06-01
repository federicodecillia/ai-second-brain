# Multi-agent setup — one repo, three agents

How this repo stays usable by Claude Code, OpenAI Codex, and Google Antigravity (and any agent that follows the agents.md standard).

## TL;DR
- One canonical file: `AGENTS.md`
- Symlink aliases: `CLAUDE.md → AGENTS.md`, `GEMINI.md → AGENTS.md`
- Tool-specific config goes in dedicated dirs (`.claude/`, `.codex/`), never duplicated in the canonical file

## Why AGENTS.md
- Open standard backed by OpenAI (Codex), Google (Gemini CLI, Antigravity), Cursor, Aider, Replit
- Claude Code recognizes it as a fallback for CLAUDE.md
- One source of truth: zero drift between agents

## The 3 rules
1. **Agent-neutral in the canonical file.** No "Claude must..."; write procedures as prose any agent can run.
2. **Do not list skills/plugins prescriptively.** Each agent auto-discovers its own. Replicate the skill's logic as prose, not its name.
3. **Keep it under 100 lines.** Model compliance drops past that.

## Setup (3 commands)
```
git mv CLAUDE.md AGENTS.md      # if starting from an existing CLAUDE.md
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md
```
(This repo already ships set up this way.)

## Verify
- `readlink CLAUDE.md` returns `AGENTS.md`; same for `GEMINI.md`
- Open each agent and ask "What is the structure of this vault?" — answers should match

## Limits
- Symlinks are not clean on Windows: use Git Bash / WSL, or copy the files and keep them in sync.
- Claude skills are a Claude-only accelerator; other agents run the same logic from the prose in `AGENTS.md`.
