---
type: routine
tags: [routine, maintenance, meta]
---

## For future agents
This is the **autopilot routine**: the single set of instructions a scheduled run (or you, on demand) executes to keep the brain organized and compounding. Keep it self-contained so any agent can run it from a cold start.

**How to run it**
- On a schedule (recommended): see [docs/automation.md](docs/automation.md). The schedule only needs to say *"run the instructions in maintenance.md"*.
- On demand, anytime: open the vault with your agent and say *"run maintenance.md"*.

Default cadence: **weekly**. Pick the day/time in setup (default Sunday 08:00). Daily works too if you capture a lot.

---

## The routine

Do these in order. Follow the capture rules in `AGENTS.md`. **Never invent data** — if something is ambiguous, leave it and note it in the digest under "Needs attention".

### 1. Empty the inbox
For each item in `00_Inbox/`:
- File it into the right PARA bucket (project / area / resource / person) per the capture workflow in `AGENTS.md`.
- Add the `[[links]]` that connect it to existing notes (no orphans).
- Add a line to today's `Daily/` note describing what landed where.
- Remove it from `00_Inbox/` once filed. If you genuinely can't place it, leave it and list it in the digest.

### 2. Review the week, then write the digest
First **rescue upward**: if something important is sitting only in this week's `Daily/` notes, promote it into its project or area note (`Daily/` is a scratchpad, not a final home — this is the append-and-review habit).

Then append one dated section to `digest.md` (**newest first**) covering, in a few tight bullets:
- **What changed** this week (from `Daily/` + new or edited notes).
- **Where things stand** on active projects — i.e. where you left off, so next session starts warm.
- **Emergent patterns / connections** worth surfacing (two notes that should link, a recurring theme).
- **Open loops** that need a decision from the owner.

### 3. Health check
Scan the vault and list findings in the digest under "Needs attention":
- **Orphans** — notes that link to nothing or that nothing links to (especially people with no area/project).
- **Stale notes** — untouched for a long time; candidates for archive.
- **Broken `[[links]]`** and **contradictions** between notes.
Fix the safe, obvious cases yourself (add a missing backlink). **Flag** anything that needs judgment — don't guess.

### 4. Keep it auditable
The digest entry **is** the log: it records when the run happened and what it touched. Append-only. Don't delete notes; move clearly-dead ones to `09_Archive/` and say so in the digest.

---

## Safe autopilot (keys, not prompts)
A scheduled run is **unattended** — you're not there to stop a mistake. So don't rely on instructions like "don't delete" to keep you safe; they're suggestions, not guardrails. Control it at the permission level instead: give the run **write access to the vault only**, and keep any connected service (calendar, email) **read-only / scoped**. The agent can still draft an email or propose a deletion — it just can't *send* or *destroy* without you. Same autonomy, smaller blast radius.
