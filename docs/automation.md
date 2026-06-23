# Automation — put the brain on autopilot

The whole point of a second brain is that it gets sharper while you ignore it. You do that by running [maintenance.md](../maintenance.md) on a schedule: it empties `00_Inbox/`, writes a digest to `digest.md`, and runs a health check. You wake up to a vault that filed itself.

Setup is one line, and the [guided onboarding](onboarding.md) offers to do it for you (it asks frequency, day, and time). This page is the reference if you want to set it up yourself or change it later.

**Default:** weekly, Sunday, 08:00. Capturing a lot? Switch to daily.

Pick the path that matches your tool. They all run the *same* `maintenance.md`.

---

## Easiest — let your agent schedule it (Claude)
Open the vault and say:

> Set up a scheduled task that runs the instructions in `maintenance.md` every Sunday at 08:00. Confirm when it's done.

Claude Code's scheduling does the rest. To change it later: *"reschedule my maintenance task to daily at 7am"*. To check or remove it: *"list my scheduled tasks"*.

## Claude Desktop — the Schedule tab
In Claude Desktop, sidebar → **Schedule** → **+ New task**:

```
Frequency:  Weekly, Sunday, 08:00
Folder:     your vault
Prompt:     Run the instructions in maintenance.md.
```

## Any agent — local cron / launchd (fully offline)
For Codex, Gemini, or a headless Claude run, schedule the agent's CLI from your OS. Cron timing:

```
0 8 * * 0    # weekly, Sunday 08:00
0 8 * * *    # daily, 08:00
```

Example crontab entry (Claude Code, adapt the command for your CLI):
```
0 8 * * 0  cd /path/to/your/vault && claude -p "Run the instructions in maintenance.md" >> .maintenance.log 2>&1
```
`crontab -e` to add it. On macOS a `launchd` agent is the more reliable equivalent. The run needs to execute where your agent is already authenticated and with **write access to the vault** (see the safety note below).

## No scheduler? Manual still compounds
If none of the above fits, just say *"run maintenance.md"* once a week. The loop works the same — it's only the reminder that's manual. Add a recurring task in `routines.md` so the Tasks plugin nudges you.

---

## Safety: keys, not prompts
A scheduled run is **unattended**. Don't trust instructions like "don't delete anything" to keep it safe — text is a suggestion, not a guardrail, and a buggy run or a malicious note in your inbox can ignore it. Set the boundary at the **permission level**:

- Give the run **write access to the vault only** — that's all `maintenance.md` needs.
- Keep any connected service (calendar, email, Slack) **read-only and scoped**. The agent can read your calendar and draft a reply; it can't send or delete without you.

This doesn't reduce what the brain does for you. It just means a mistake can't do anything irreversible.
