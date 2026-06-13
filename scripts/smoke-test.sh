#!/usr/bin/env bash
# Smoke test: simulate brand-new users setting up the vault from a clean clone,
# in BOTH modes — personal (one owner) and team/company.
# Run before every push to main (or before merging a PR to main).
#   bash scripts/smoke-test.sh
# Exit code = number of failed checks (0 = green, ok to push).
set -uo pipefail

SRC="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TMP=$(mktemp -d /tmp/sb-smoke-XXXXXX)
trap 'rm -rf "$TMP"' EXIT

P=0; F=0
ok(){ echo "  PASS  $1"; P=$((P+1)); }
no(){ echo "  FAIL  $1"; F=$((F+1)); }

# Seed a clone: working tree honoring .gitignore, then a .git with a fake remote so
# the detach safety is genuinely exercised (as a real GitHub clone would be).
seed_clone() {
  local dest="$1"; mkdir -p "$dest"
  rsync -a --exclude='.git/' --exclude='.DS_Store' --filter=':- .gitignore' "$SRC"/ "$dest"/ 2>/dev/null
  git -C "$dest" init -q
  git -C "$dest" remote add origin https://github.com/federicodecillia/ai-second-brain.git
  git -C "$dest" add -A && git -C "$dest" -c user.email=t@t -c user.name=t commit -qm seed
}

# ---------- Run 1: personal mode ----------
echo "== personal mode =="
DEST="$TMP/personal"; seed_clone "$DEST"; cd "$DEST"
START=$(date +%s)
printf '%s\n' \
  'p' \
  'Jordan Rivera' \
  'Freelance design studio: client CRM and project tracking' \
  'Europe/Berlin' 'English' 'Concise, bullets, no fluff' \
  'clients,marketing,operations' 'Y' 'n' | bash ./setup.sh >"$TMP/personal-out.txt" 2>&1
ELAPSED=$(( $(date +%s) - START ))

SETUP_LEFT=$(grep -roE '\{\{(owner_name|primary_use|timezone|language|style_prefs)\}\}' \
  "$DEST/AGENTS.md" "$DEST/03_Resources/context/_owner.md" 2>/dev/null | wc -l | tr -d ' ')
[ "$SETUP_LEFT" = 0 ] && ok "setup tokens cleared in AGENTS.md + _owner.md" || no "setup tokens left ($SETUP_LEFT)"
[ "$(readlink "$DEST/CLAUDE.md")" = AGENTS.md ] && ok "CLAUDE.md symlink -> AGENTS.md" || no "CLAUDE.md symlink"
[ "$(readlink "$DEST/GEMINI.md")" = AGENTS.md ] && ok "GEMINI.md symlink -> AGENTS.md" || no "GEMINI.md symlink"
grep -q "Jordan Rivera" "$DEST/AGENTS.md" && ok "AGENTS.md personalized with name" || no "AGENTS.md name"
grep -q "Freelance design studio" "$DEST/03_Resources/context/_owner.md" && ok "_owner.md personalized" || no "_owner.md"
[ -f "$DEST/02_Areas/clients/clients.md" ] && ok "area clients + MOC created" || no "area clients"
[ -d "$DEST/02_Areas/marketing" ] && [ -d "$DEST/02_Areas/operations" ] && ok "extra areas created" || no "extra areas"
[ -z "$(git -C "$DEST" remote -v 2>/dev/null)" ] && ok "DETACH: template remote removed" || no "DETACH: remote STILL present"
[ -d "$DEST/.git" ] && ok "DETACH: fresh git repo initialized" || no "DETACH: missing new .git"
[ -f "$DEST/hub.md" ] && [ -f "$DEST/routines.md" ] && [ -f "$DEST/dashboard.md" ] && ok "key files (hub/routines/dashboard)" || no "key files"
NT=$(ls "$DEST/03_Resources/templates/" 2>/dev/null | wc -l | tr -d ' ')
[ "$NT" -ge 6 ] && ok "universal templates ($NT)" || no "universal templates ($NT, expected >=6)"
[ -d "$DEST/01_Projects/example-project" ] && ok "example project present in 01_Projects" || no "example project missing"
[ ! -d "$DEST/scripts" ] && [ ! -d "$DEST/.github" ] && ok "DETACH: dev/CI infra removed from user vault" || no "DETACH: scripts/ or .github/ still in user vault"

# ---------- Run 2: team / company mode ----------
echo "== team mode =="
DEST2="$TMP/team"; seed_clone "$DEST2"; cd "$DEST2"
printf '%s\n' \
  't' \
  'Acme Studio' \
  'Alex Rivera, Sam Lee' \
  'Run the studio together: clients, quotes, projects' \
  'Europe/Berlin' 'English' 'Concise, bullets, no fluff' \
  '' 'Y' 'n' | bash ./setup.sh >"$TMP/team-out.txt" 2>&1

[ -f "$DEST2/03_Resources/context/_company.md" ] && ok "team: _company.md created" || no "team: _company.md missing"
[ ! -f "$DEST2/03_Resources/context/_owner.md" ] && ok "team: single-owner _owner.md removed" || no "team: _owner.md still present"
grep -q "Acme Studio" "$DEST2/03_Resources/context/_company.md" && ok "team: _company.md personalized" || no "team: _company.md not personalized"
[ -f "$DEST2/03_Resources/context/team/alex.md" ] && [ -f "$DEST2/03_Resources/context/team/sam.md" ] && ok "team: per-person profiles (alex, sam)" || no "team: team profiles missing"
grep -q "^- \*\*Team:\*\*" "$DEST2/AGENTS.md" && ok "team: AGENTS.md has Team identity line" || no "team: AGENTS.md Team line"
grep -q "Acme Studio Company Brain" "$DEST2/AGENTS.md" && ok "team: AGENTS.md titled with company" || no "team: AGENTS.md company title"
TEAM_TOKENS=$(grep -roE '\{\{[a-zA-Z_]+\}\}' \
  "$DEST2/AGENTS.md" "$DEST2/dashboard.md" "$DEST2/03_Resources/context/_company.md" 2>/dev/null | wc -l | tr -d ' ')
[ "$TEAM_TOKENS" = 0 ] && ok "team: no leftover tokens in AGENTS/dashboard/_company" || no "team: leftover tokens ($TEAM_TOKENS)"
grep -q "Tasks — Alex Rivera" "$DEST2/dashboard.md" && ok "team: dashboard has per-person section" || no "team: dashboard per-person section"
grep -q "tags include #alex" "$DEST2/dashboard.md" && ok "team: dashboard queries person tag" || no "team: dashboard person tag query"
[ -f "$DEST2/pipeline.md" ] && ok "team: pipeline.md created" || no "team: pipeline.md missing"
[ -f "$DEST2/02_Areas/sales/sales.md" ] && [ -d "$DEST2/02_Areas/sales/quotes" ] && ok "team: sales area + quotes/ created" || no "team: sales area missing"
[ -f "$DEST2/03_Resources/templates/quote.md" ] && ok "team: quote template created" || no "team: quote template missing"
[ "$(readlink "$DEST2/CLAUDE.md")" = AGENTS.md ] && ok "team: CLAUDE.md symlink -> AGENTS.md" || no "team: CLAUDE.md symlink"
[ -d "$DEST2/.git" ] && [ -z "$(git -C "$DEST2" remote -v 2>/dev/null)" ] && ok "team: detached (fresh .git, no remote)" || no "team: detach"

# ---------- Pre-push hygiene on SRC (the real repo) ----------
JUNK=$(git -C "$SRC" ls-files 2>/dev/null | grep -iE \
  '(^|/)(Senza nome|Untitled)\.|(^|/)\.DS_Store$|^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$|(^|/)\.obsidian/(workspace|cache|graph\.json)' || true)
[ -z "$JUNK" ] && ok "no junk files tracked" || no "junk files tracked: $(echo "$JUNK" | tr '\n' ' ')"

echo ""
echo "setup.sh time (personal): ${ELAPSED}s"
echo "RESULT: $P pass / $F fail"
if [ "$F" = 0 ]; then echo "==> GREEN: ok to push"; else echo "==> RED: do not push"; echo "--- personal out ---"; cat "$TMP/personal-out.txt"; echo "--- team out ---"; cat "$TMP/team-out.txt"; fi
exit "$F"
