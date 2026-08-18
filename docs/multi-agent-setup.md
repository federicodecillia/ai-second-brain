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
- `readlink CLAUDE.md` returns `AGENTS.md`; same for `GEMINI.md` (on Windows without symlinks, `head -1 CLAUDE.md` shows the AGENTS.md title instead)
- Open each agent and ask "What is the structure of this vault?" — answers should match

## On Windows
A git clone on Windows does not create symlinks: `CLAUDE.md` and `GEMINI.md` arrive as one-line text files containing `AGENTS.md`, and many Windows filesystems refuse symlinks outright. `setup.sh` handles both cases — it recreates the symlink where the filesystem allows it, and otherwise makes `CLAUDE.md` / `GEMINI.md` **real copies** of `AGENTS.md` and tells you so.

If you got copies, they can drift: after editing `AGENTS.md`, ask your agent to copy it over the two aliases again. Codex reads `AGENTS.md` directly, so it is unaffected either way.

## Limits
- Claude skills are a Claude-only accelerator; other agents run the same logic from the prose in `AGENTS.md`.
