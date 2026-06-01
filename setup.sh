#!/usr/bin/env bash
set -euo pipefail

# Guided personalization for ai-second-brain-starter.
# Usage:
#   ./setup.sh          full interactive (each question skippable with Enter)
#   ./setup.sh --quick  skip all questions, leave placeholders, just fix symlinks

QUICK=false
[[ "${1:-}" == "--quick" ]] && QUICK=true

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

AGENTS="AGENTS.md"
OWNER="03_Resources/context/_owner.md"

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

echo "Personalizing your second brain..."
$QUICK && echo "(quick mode: skipping questions, leaving placeholders for later)"

OWNER_NAME="$(ask 'Your name')"
PRIMARY_USE="$(ask 'Primary use of this vault (one line)')"
TIMEZONE="$(ask 'Your timezone (e.g. Europe/Rome)')"
LANGUAGE="$(ask 'Preferred language (e.g. English)')"
STYLE_PREFS="$(ask 'Output style preferences (one line)')"

maybe_subst "{{owner_name}}" "$OWNER_NAME"
maybe_subst "{{primary_use}}" "$PRIMARY_USE"
maybe_subst "{{timezone}}" "$TIMEZONE"
maybe_subst "{{language}}" "$LANGUAGE"
maybe_subst "{{style_prefs}}" "$STYLE_PREFS"

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

# Detach safety: sever the link to the template so personal data is never pushed upstream.
if ! $QUICK; then
  read -r -p 'Make this your own private repo? Removes the template git remote. [Y/n]: ' DETACH || true
  if [[ "${DETACH:-Y}" =~ ^([Yy]|)$ ]]; then
    rm -rf .git
    git init -q
    echo "  detached: new empty git repo initialized."
  else
    echo "  kept the template remote (you can pull upstream updates)."
  fi
fi

echo ""
echo "Done. Next steps:"
echo "  1. Open this folder as an Obsidian vault."
echo "  2. Install Tasks + Dataview, enable core Templates (docs/plugin-setup.md)."
echo "  3. Open the vault with your agent and ask: 'What is the structure of this vault?'"
$QUICK && echo "  (re-run ./setup.sh anytime to fill the remaining {{placeholders}}.)"
