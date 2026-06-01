# Onboarding — 15 minutes to a working second brain

## 1. Make it yours (5 min)
Run the guided setup:
```
./setup.sh
```
Answer the prompts (name, timezone, language, primary use, style). Press Enter to skip any question; skipped fields keep a `{{placeholder}}` you can fill later. In a hurry? `./setup.sh --quick` skips everything and gives you a working vault now — re-run it anytime to personalize.

Prefer editing by hand? Find and replace these tokens in `AGENTS.md` and `03_Resources/context/_owner.md`: `{{owner_name}}`, `{{primary_use}}`, `{{timezone}}`, `{{language}}`, `{{style_prefs}}`. Find leftovers with:
```
grep -rn "{{owner_name}}\|{{primary_use}}\|{{timezone}}\|{{language}}\|{{style_prefs}}" .
```

## 2. Choose your areas (5 min)
PARA is the framework; the areas are yours. Create a folder in `02_Areas/` only for areas you actually have. Examples:
- Consultant: `clients`, `marketing`, `operations`
- Lawyer: `active-cases`, `clients`, `practice`
- Designer: `clients`, `portfolio`, `craft`

See `02_Areas/_README.md` for more.

## 3. Set up Obsidian (2 min)
Open the folder as a vault. Install Tasks + Dataview and enable core Templates (see `docs/plugin-setup.md`). Open `dashboard.md` and confirm the task views render (they show 0 tasks until you add some).

## 4. Connect your agent (2 min)
Open the vault in Claude Code, Codex, or Antigravity. Test: ask "What is the structure of this vault?" You should get a coherent PARA answer. See `docs/multi-agent-setup.md` for how the AGENTS.md / symlink setup works.

## 5. First capture (1 min)
Create today's note in `Daily/` and your first contact in `03_Resources/people/`. The vault is now live.

---
Stuck, or want CRM workflows, custom agent skills, and a done-for-you setup? The pro package includes a live setup session. [Get in touch](#).
