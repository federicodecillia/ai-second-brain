#!/usr/bin/env bash
# Smoke test: simulate a brand-new user setting up the vault from a clean clone.
# Run before every push to main (or before merging a PR to main).
#   bash scripts/smoke-test.sh
# Exit code = number of failed checks (0 = green, ok to push).
set -uo pipefail

SRC="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TMP=$(mktemp -d /tmp/sb-smoke-XXXXXX); DEST="$TMP/my-second-brain"; mkdir -p "$DEST"
trap 'rm -rf "$TMP"' EXIT

# 1. Simulate the clone: working tree, honor .gitignore, then seed a .git with a
#    fake remote so the detach safety is genuinely exercised (as a real GitHub clone).
rsync -a --exclude='.git/' --exclude='.DS_Store' --filter=':- .gitignore' "$SRC"/ "$DEST"/ 2>/dev/null
git -C "$DEST" init -q
git -C "$DEST" remote add origin https://github.com/federicodecillia/ai-second-brain.git
git -C "$DEST" add -A && git -C "$DEST" -c user.email=t@t -c user.name=t commit -qm seed

# 2. Run setup.sh as a new user would, with canned answers, timed.
cd "$DEST"
START=$(date +%s)
printf '%s\n' \
  'Jordan Rivera' \
  'Freelance design studio: client CRM and project tracking' \
  'Europe/Berlin' 'English' 'Concise, bullets, no fluff' \
  'clients,marketing,operations' 'Y' | bash ./setup.sh >"$TMP/setup-out.txt" 2>&1
ELAPSED=$(( $(date +%s) - START ))

# 3. Assertions.
P=0; F=0
ok(){ echo "  PASS  $1"; P=$((P+1)); }
no(){ echo "  FAIL  $1"; F=$((F+1)); }

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

echo ""
echo "setup.sh time: ${ELAPSED}s"
echo "RESULT: $P pass / $F fail"
if [ "$F" = 0 ]; then echo "==> GREEN: ok to push"; else echo "==> RED: do not push"; echo "--- setup.sh output ---"; cat "$TMP/setup-out.txt"; fi
exit "$F"
