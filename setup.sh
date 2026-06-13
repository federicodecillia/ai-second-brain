#!/usr/bin/env bash
set -euo pipefail

# Guided personalization for ai-second-brain.
# Usage:
#   ./setup.sh          full interactive (each question skippable with Enter)
#   ./setup.sh --quick  skip all questions, leave placeholders, just fix symlinks
#
# Two modes: a personal brain (one owner) or a shared company/team brain
# (company identity + people + per-person task assignment + a sales pipeline).
# Team mode is documented in docs/company-brain.md.

QUICK=false
[[ "${1:-}" == "--quick" ]] && QUICK=true

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

AGENTS="AGENTS.md"
OWNER="03_Resources/context/_owner.md"
COMPANY_FILE="03_Resources/context/_company.md"

# Replace a literal {{token}} with a value across one file (literal, regex-safe).
subst() {
  local file="$1" token="$2" value="$3" content
  [[ -f "$file" ]] || return 0
  content="$(cat "$file")"
  content="${content//"$token"/$value}"
  printf '%s\n' "$content" > "$file"
}

# Substitute a token in both AGENTS.md and _owner.md, only if a value was given.
maybe_subst() {
  local token="$1" value="$2"
  [[ -z "$value" ]] && return 0
  subst "$AGENTS" "$token" "$value"
  subst "$OWNER" "$token" "$value"
}

# Ask a question; return the answer (empty on skip or in --quick mode).
ask() {
  local prompt="$1" answer=""
  $QUICK && { printf ''; return 0; }
  read -r -p "$prompt (Enter to skip): " answer || true
  printf '%s' "$answer"
}

# First word of a name, lowercased, alnum only -> used as person tag + filename.
slugify_first() {
  echo "$1" | awk '{print $1}' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9'
}

echo "Personalizing your second brain..."
$QUICK && echo "(quick mode: skipping questions, leaving placeholders for later)"

# --- Mode: personal (default) or team/company ---
TEAM=false
if ! $QUICK; then
  read -r -p 'Set up as a [p]ersonal or [t]eam/company brain? (personal): ' MODE || true
  case "$(echo "${MODE:-}" | tr '[:upper:]' '[:lower:]')" in
    t|team|company|c|2) TEAM=true ;;
  esac
fi

# --- Collect answers ---
if $TEAM; then
  COMPANY_NAME="$(ask 'Company name')"
  MEMBERS="$(ask 'Team members, comma-separated (e.g. Alex Rivera, Sam Lee)')"
  PRIMARY_USE="$(ask 'What the team uses this vault for (one line)')"
else
  OWNER_NAME="$(ask 'Your name')"
  PRIMARY_USE="$(ask 'Primary use of this vault (one line)')"
fi
TIMEZONE="$(ask 'Your timezone (e.g. Europe/Rome)')"
LANGUAGE="$(ask 'Preferred language (e.g. English)')"
STYLE_PREFS="$(ask 'Output style preferences (one line)')"

if ! $TEAM; then
  # ===== Personal mode: token substitution on the shipped files (unchanged) =====
  maybe_subst "{{owner_name}}" "$OWNER_NAME"
  maybe_subst "{{primary_use}}" "$PRIMARY_USE"
  maybe_subst "{{timezone}}" "$TIMEZONE"
  maybe_subst "{{language}}" "$LANGUAGE"
  maybe_subst "{{style_prefs}}" "$STYLE_PREFS"
else
  # ===== Team mode: scaffold company identity, team profiles, dashboard, pipeline =====
  echo "  team mode: building company identity + per-person views + sales pipeline"
  [[ -z "$COMPANY_NAME" ]] && COMPANY_NAME="Our company"

  # Build team line, per-person dashboard sections, unassigned filters, profiles.
  TEAM_LINE=""; DASH_SECTIONS=""; UNASSIGNED=""
  mkdir -p 03_Resources/context/team
  if [[ -n "$MEMBERS" ]]; then
    IFS=',' read -ra MARR <<< "$MEMBERS"
    for raw in "${MARR[@]}"; do
      name="$(echo "$raw" | sed 's/^ *//;s/ *$//')"
      [[ -z "$name" ]] && continue
      slug="$(slugify_first "$name")"
      [[ -z "$slug" ]] && continue
      printf -v seg '%s (`#%s`)' "$name" "$slug"
      [[ -n "$TEAM_LINE" ]] && TEAM_LINE+=" · "
      TEAM_LINE+="$seg"
      DASH_SECTIONS+="## Tasks — $name"$'\n''```tasks'$'\n'"not done"$'\n'"tags include #$slug"$'\n'"sort by due"$'\n'"sort by priority"$'\n''```'$'\n\n'
      UNASSIGNED+="tags do not include #$slug"$'\n'
      cat > "03_Resources/context/team/$slug.md" <<'PROF'
---
type: person
relationship: team
tags: [person, team]
updated:
---

# {{NAME}}

## Role
> Interview gap: what does {{NAME}} own by default (sales, delivery, product, admin)?

## Bio (one line)
> Interview gap: who is {{NAME}}, in one line.

## How to assign work
Tag tasks with `#{{SLUG}}`. They show up in "Tasks — {{NAME}}" on the dashboard.
PROF
      subst "03_Resources/context/team/$slug.md" "{{NAME}}" "$name"
      subst "03_Resources/context/team/$slug.md" "{{SLUG}}" "$slug"
      echo "    team member: $name (#$slug)"
    done
  fi
  [[ -z "$TEAM_LINE" ]] && TEAM_LINE="the team"
  [[ -z "$UNASSIGNED" ]] && UNASSIGNED="# (add per-person 'tags do not include #name' lines)"$'\n'

  # Company context replaces single-owner identity.
  rm -f "$OWNER"
  cat > "$COMPANY_FILE" <<'CO'
---
type: context
scope: company
updated:
---

## For future agents
Identity of {{COMPANY}}: the lens for every other note. Human-owned: do not overwrite; propose changes or interview the team. Refresh quarterly.

## What {{COMPANY}} is (one line)
{{PRIMARY_USE}}

## Offering / services
> Interview gap: what you sell, typical packages, indicative pricing.

## Ideal customer (ICP)
> Interview gap: who the ideal client is (sector, size, buyer role, need).

## Values & decision criteria
> Interview gap: what you optimize for, your hard nos, how you pick projects.

## Goals (this year)
> Interview gap: 3-5 goals with rough milestones.

## Who does what
> Interview gap: default split of roles across the team.
CO
  subst "$COMPANY_FILE" "{{COMPANY}}" "$COMPANY_NAME"
  subst "$COMPANY_FILE" "{{PRIMARY_USE}}" "${PRIMARY_USE:-> Interview gap: what the team uses this vault for.}"

  # Team-aware operating manual (overwrites the single-owner AGENTS.md).
  cat > "$AGENTS" <<'AG'
# Operating Manual — {{COMPANY}} Company Brain

> Read this file before operating in the vault. Keep it under 100 lines: details live in each project's notes and in `docs/`.

## Vault identity
- **Type:** company brain (shared), operated by a team via AI agents.
- **Team:** {{TEAM_LINE}}. All are owners/operators.
- **Model:** PARA (Tiago Forte) + project folders + natural-language task capture + a lightweight sales pipeline. AI-first, "always bet on text".
- **Primary use:** {{PRIMARY_USE}}
- **Context for strategic questions:** `MEMORY.md` (key facts) + `03_Resources/context/_company.md` (company identity) + `03_Resources/context/team/` (the people). Read them before strategic questions.
- **Language:** {{LANGUAGE}}. **Timezone:** {{TIMEZONE}}.

## Structure (PARA)
```
01_Projects/   client engagements WITH a deadline + internal initiatives
02_Areas/      ongoing responsibilities (sales, + others as they get real content)
03_Resources/  reusable reference
  templates/   note templates (incl. quote.md)
  people/      contacts by relationship (clients/ prospects/ collaborators/ suppliers/)
  context/     _company.md (company identity) + team/ (one profile per person)
09_Archive/    completed / inactive / historical
Daily/         daily notes YYYY-MM-DD (they live HERE, not in root)
hub.md  routines.md  dashboard.md (task cockpit)  pipeline.md (sales cockpit)  MEMORY.md  index.md (MOC)
```
Anti-overcomplication: do NOT create empty folders/files. An area grows only with real content.
Naming: folders snake_case, notes kebab-case. Stay consistent.

## Capture workflow
When a team member pastes or dictates raw info (a note, a meeting, an idea), file it into PARA:
1. **Pick the bucket.** Deadline + defined outcome -> `01_Projects/`. Ongoing responsibility -> `02_Areas/`. Reusable reference -> `03_Resources/`. A person -> `03_Resources/people/<relationship>/`. A quote -> `02_Areas/sales/quotes/`.
2. **Update status/fields** in frontmatter (sales notes carry a `status:` — see Pipeline).
3. **Log dated entries** for anything conversational: `### [YYYY-MM-DD] <channel> | <summary>` + bullets.
4. **Add a line to today's `Daily/`** linking what changed.
5. **Never invent data.** If unsure, leave blank and add `> TODO: ask the team ___`. Never invent amounts on a quote.

## Tasks & assignment
- Capture in natural language; the agent writes the task line in the right file (project/area, loose -> `hub.md`, recurring -> `routines.md`).
- **Assign with a person tag:** `#<firstname>` (e.g. the tags in the Team line above). No tag = unassigned.
- Emoji metadata: `📅 YYYY-MM-DD` due · `⏫`/`🔺` high priority · `🔽` low · `🔁 every week` recurring · `✅ YYYY-MM-DD` done.
- The Tasks plugin aggregates everything into `dashboard.md` (per-person + overdue + today). Don't write tasks in the dashboard.

## Sales pipeline (lightweight)
- A contact lives in `03_Resources/people/<relationship>/`; a quote lives in `02_Areas/sales/quotes/`.
- Each sales note carries `status:` in frontmatter: `lead · prospect · quote · client · lost`.
- `pipeline.md` groups every sales note by `status` (Dataview). To advance a deal, change its `status`.
- A **won** quote → create a project in `01_Projects/` and link it from the quote's `project:` field.

## People & contacts
Contacts in `03_Resources/people/`, grouped by relationship (clients/ prospects/ collaborators/ suppliers/). Every contact links to at least one area/project (and vice versa). Check links both ways. Weekly link-hygiene routine in `routines.md`.

## Context engine (for strategic questions)
Read `03_Resources/context/_company.md` + `MEMORY.md` + `03_Resources/context/team/`. Human-owned files: do not overwrite; propose changes or interview the team (stubs are `> Interview gap: ...`).

## Output style
{{STYLE_PREFS}}

## Agent capabilities
Read by Claude Code, OpenAI Codex, Google Antigravity and any agent following the agents.md standard. Claude Code skills go in `.claude/skills/`; describe their logic in prose here so other agents can run it manually.

---
*Built on PARA (Tiago Forte) + Karpathy's LLM-Wiki / append-and-review pattern. agents.md standard: AGENTS.md canonical + CLAUDE.md/GEMINI.md symlinks. See docs/philosophy.md and docs/company-brain.md.*
AG
  subst "$AGENTS" "{{COMPANY}}" "$COMPANY_NAME"
  subst "$AGENTS" "{{TEAM_LINE}}" "$TEAM_LINE"
  subst "$AGENTS" "{{PRIMARY_USE}}" "${PRIMARY_USE:-run the company together}"
  subst "$AGENTS" "{{LANGUAGE}}" "${LANGUAGE:-English}"
  subst "$AGENTS" "{{TIMEZONE}}" "${TIMEZONE:-your timezone}"
  subst "$AGENTS" "{{STYLE_PREFS}}" "${STYLE_PREFS:-Concise, direct, no filler. Bullets/headers for complex output, plain text for short answers.}"

  # Per-person task cockpit.
  cat > dashboard.md <<'DASH'
---
type: dashboard
tags: [dashboard, tasks, meta]
---

## For future agents
Task cockpit (Tasks plugin). Aggregates every `- [ ]` with its emoji metadata and person tag. Don't write tasks here — write them in the right file (project/area, loose -> [[hub]], recurring -> [[routines]]) and assign with a `#name` tag. Requires the Tasks plugin.

> [!info] `📅` due · `⏫`/`🔺` high · `🔽` low · `🔁` recurring · `✅` done · `#name` assignee

## 🔴 Overdue
```tasks
not done
due before today
sort by due
```

## 📅 Today and next 7 days
```tasks
not done
due before in 8 days
due after yesterday
sort by due
sort by priority
```

{{PERSON_SECTIONS}}## ⚪ Unassigned
```tasks
not done
{{UNASSIGNED_FILTERS}}sort by due
sort by priority
```

## ✅ Recently completed (last 14 days)
```tasks
done
done after 14 days ago
sort by done reverse
```
DASH
  subst dashboard.md "{{PERSON_SECTIONS}}" "$DASH_SECTIONS"
  subst dashboard.md "{{UNASSIGNED_FILTERS}}" "$UNASSIGNED"

  # Sales cockpit.
  cat > pipeline.md <<'PIPE'
---
type: dashboard
tags: [dashboard, sales, pipeline, meta]
---

## For future agents
Sales cockpit (Dataview plugin). Reads `status:` from contacts (`03_Resources/people/`) and quotes (`02_Areas/sales/quotes/`). Advance a deal by changing its `status` in the note — don't write here. Stages: `lead · prospect · quote · client · lost`. Requires the Dataview plugin.

> Won quote → create a project in `01_Projects/` and link it from the quote's `project:` field.

## 🧲 Contacts in pipeline (lead → prospect)
```dataview
TABLE WITHOUT ID file.link AS Contact, status AS Stage, file.folder AS Folder, last_interaction AS "Last touch"
FROM "03_Resources/people"
WHERE status AND status != "client" AND status != "lost"
SORT status ASC
```

## 📄 Open quotes
```dataview
TABLE WITHOUT ID file.link AS Quote, client AS Client, amount AS Amount, currency AS Cur, valid_until AS "Valid until", status AS Stage
FROM "02_Areas/sales/quotes"
WHERE status != "lost" AND status != "client"
SORT valid_until ASC
```

## 💰 Open quote value
```dataview
TABLE WITHOUT ID sum(rows.amount) AS "Open total"
FROM "02_Areas/sales/quotes"
WHERE status != "lost" AND status != "client"
GROUP BY currency
```

## ✅ Active clients
```dataview
TABLE WITHOUT ID file.link AS Client, file.folder AS Folder
FROM "03_Resources/people/clients"
WHERE status = "client"
SORT file.name ASC
```
PIPE

  # Sales area + quote template.
  mkdir -p 02_Areas/sales/quotes
  cat > 02_Areas/sales/sales.md <<'SALES'
---
type: moc
tags: [moc, area, sales]
---

# Sales

From first conversation (lead) to active client. Overview in [[pipeline]].

## Overview
- Contacts live in `03_Resources/people/` with a `status` field.
- Quotes live in `02_Areas/sales/quotes/`, one note each (template `03_Resources/templates/quote.md`).
- Stages: `lead · prospect · quote · client · lost`. Advance = change `status`.
- Won quote → a project in `01_Projects/`, linked from the quote's `project:` field.

## Open sales tasks
```tasks
not done
path includes 02_Areas/sales
sort by due
```
SALES
  cat > 03_Resources/templates/quote.md <<'QT'
---
date: {{date}}
type: quote
tags: [quote, sales]
client:
amount:
currency:
status: quote
valid_until:
project:
owner:
---

# {{title}}

## Summary
> One or two lines: what it proposes, to whom, for what need.

## Scope / line items
- item — amount

## Terms
- Valid until: 📅
- Payment terms:
- Notes:

## Links
- Contact: [[ ]]
- Project (if won): [[ ]]

## Log
### [{{date}}] created | draft quote
-
QT
fi

# Optional: create the areas the user names.
if ! $QUICK; then
  read -r -p 'Your main areas, comma-separated (e.g. clients,marketing) (Enter to skip): ' AREAS || true
  if [[ -n "${AREAS:-}" ]]; then
    IFS=',' read -ra ARR <<< "$AREAS"
    for raw in "${ARR[@]}"; do
      area="$(echo "$raw" | tr -d ' ')"
      [[ -z "$area" ]] && continue
      mkdir -p "02_Areas/$area"
      printf '%s\n' "---" "type: moc" "tags: [moc, area]" "---" "" "# $area" "" "## Overview" "" "## Active projects" "" "## Notes" > "02_Areas/$area/$area.md"
      echo "  created area: 02_Areas/$area"
    done
  fi
fi

# Fix symlinks if the clone materialized them as plain files (Windows edge case).
for link in CLAUDE.md GEMINI.md; do
  if [[ ! -L "$link" ]]; then
    rm -f "$link"
    ln -s AGENTS.md "$link"
    echo "  fixed symlink: $link -> AGENTS.md"
  fi
done

# Detach safety: sever the link to the template so personal data is never pushed
# upstream, and drop the template's dev/CI infra you don't need in your own vault.
if ! $QUICK; then
  read -r -p 'Make this your own private repo? Removes the template git remote + dev/CI infra. [Y/n]: ' DETACH || true
  if [[ "${DETACH:-Y}" == [Yy] ]]; then
    rm -rf .git scripts .github
    git init -q
    echo "  detached: removed template dev/CI infra (scripts/, .github/) and initialized a fresh git repo."
  else
    echo "  kept the template remote + dev/CI infra (you can pull upstream updates and run the smoke test)."
  fi
fi

# Optional: publish to GitHub in one step (personal repo or org).
if ! $QUICK; then
  if command -v gh >/dev/null 2>&1; then
    read -r -p 'Publish to GitHub now? Creates a repo and pushes. [y/N]: ' PUB || true
    if [[ "${PUB:-N}" == [Yy] ]]; then
      read -r -p '  Repo as owner/name (e.g. you/my-brain or your-org/team-brain): ' REPO_SLUG || true
      read -r -p '  Visibility [private/public] (private): ' VIS || true
      VIS="$(echo "${VIS:-private}" | tr '[:upper:]' '[:lower:]')"
      [[ "$VIS" == "public" ]] || VIS="private"
      if [[ -n "${REPO_SLUG:-}" ]]; then
        [[ -d .git ]] || git init -q
        if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
          git add -A
          git commit -qm "init: second brain" >/dev/null 2>&1 \
            || echo "  (could not commit — set git user.name/email, then: git add -A && git commit, and re-run publish)"
        fi
        if git rev-parse --verify HEAD >/dev/null 2>&1; then
          gh repo create "$REPO_SLUG" --"$VIS" --source=. --remote=origin --push \
            && echo "  published ($VIS): https://github.com/$REPO_SLUG" \
            || echo "  publish failed — check 'gh auth status', that the owner/org exists, and that the repo name is free."
        fi
      fi
    fi
  else
    echo "Tip: install GitHub CLI (gh) to publish this vault to a private repo in one step."
  fi
fi

echo ""
echo "Done. Next steps:"
echo "  1. Open this folder as an Obsidian vault."
echo "  2. Install Tasks + Dataview, enable core Templates (docs/plugin-setup.md)."
if $TEAM; then
  echo "  3. Open the vault with your agent and ask: 'What is the structure of this vault?'"
  echo "  4. Company brain: fill 03_Resources/context/_company.md + context/team/*. See docs/company-brain.md."
else
  echo "  3. Open the vault with your agent and ask: 'What is the structure of this vault?'"
fi
$QUICK && echo "  (re-run ./setup.sh anytime to fill the remaining {{placeholders}}.)"
