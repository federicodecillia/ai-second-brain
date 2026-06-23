# Onboarding — 15 minutes to a working second brain

You have two ways to personalize the vault. Pick one.

- **Fast (form):** run `./setup.sh` and answer a few prompts. Best if you just want it working.
- **Deep (interview):** let your agent interview you, one question at a time. Richer context, because you answer in your own words like you're briefing a new co-founder. It also offers to set up autopilot for you.

Both end in the same place. You can run the interview after the form to go deeper anytime.

## 1a. Fast path — the form (5 min)
```
./setup.sh
```
Answer the prompts (name, timezone, language, primary use, style). Press Enter to skip any; skipped fields keep a `{{placeholder}}` you can fill later. In a hurry? `./setup.sh --quick` skips everything and gives you a working vault now — re-run it anytime.

Prefer editing by hand? Find and replace these tokens in `AGENTS.md` and `03_Resources/context/_owner.md`: `{{owner_name}}`, `{{primary_use}}`, `{{timezone}}`, `{{language}}`, `{{style_prefs}}`. Find leftovers with:
```
grep -rn "{{owner_name}}\|{{primary_use}}\|{{timezone}}\|{{language}}\|{{style_prefs}}" .
```

## 1b. Deep path — let your agent interview you (recommended)
Open the vault with your agent (Claude Code, Codex, or Antigravity) and paste this:

> You are setting up my second brain. Interview me ONE question at a time to build my profile: who I am and what I do, my goals this year, how I want you to talk to me, my strengths and weaknesses, my current projects and areas. Wait for each answer before the next question. When done, fill `AGENTS.md` (owner, primary use, language, timezone, output style) and `03_Resources/context/_owner.md` (values, goals, decision criteria) from my answers — replace the `{{placeholders}}` and the `> Interview gap:` stubs. Then ask whether I want automatic weekly maintenance, and if yes, set it up per `docs/automation.md`.

Answer like it's a real briefing — the more honest the answers, the more the brain knows you. When it finishes, open `AGENTS.md` and `_owner.md` to see your context saved. You never re-explain yourself again.

## 2. Choose your areas (5 min)
PARA is the framework; the areas are yours. Create a folder in `02_Areas/` only for areas you actually have. Examples:
- Consultant: `clients`, `marketing`, `operations`
- Lawyer: `active-cases`, `clients`, `practice`
- Designer: `clients`, `portfolio`, `craft`

See `02_Areas/_README.md` for more.

## 3. Set up Obsidian (2 min)
Open the folder as a vault. Install Tasks + Dataview and enable core Templates (see `docs/plugin-setup.md`). Open `dashboard.md` and confirm the task views render (they show 0 tasks until you add some).

Want the vault on your phone? `docs/mobile-sync.md` sets up free git-based sync to Obsidian iOS (no Obsidian Sync subscription).

On macOS, want to capture via Siri/Apple Reminders and let your agent pull items into the vault? See `docs/reminders-capture.md`.

## 4. Connect your agent (2 min)
Open the vault in Claude Code, Codex, or Antigravity. Test: ask "What is the structure of this vault?" You should get a coherent PARA answer. See `docs/multi-agent-setup.md` for how the AGENTS.md / symlink setup works.

## 5. Turn on autopilot (optional, 2 min)
This is what makes the brain compound. `maintenance.md` empties `00_Inbox/`, writes a weekly digest to `digest.md`, and runs a health check. Schedule it so it happens without you.

If you took the interview path, the agent already offered to do this. Otherwise just say:

> Set up a scheduled task that runs the instructions in `maintenance.md` every Sunday at 08:00.

Change the cadence to taste (daily if you capture a lot). Full reference, including a local-cron path for any agent and the read-only safety rule: `docs/automation.md`.

## 6. First capture (1 min)
Drop something in `00_Inbox/`, or create today's note in `Daily/` and your first contact in `03_Resources/people/`. The vault is now live — the next maintenance run will file the inbox for you.

---
Stuck, or want CRM workflows, custom agent skills, and a done-for-you setup? The pro package includes a live setup session. [Get in touch](https://www.linkedin.com/in/federicodecillia/).
