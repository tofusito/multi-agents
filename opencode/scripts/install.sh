#!/usr/bin/env bash
# First-time install of the multi-agents OpenCode setup.
# For subsequent updates, run distribute.sh from the repo root instead.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"

backup_file() {
  local target="$1"
  if [[ -e "$target" ]]; then
    cp -R "$target" "$target.bak.$BACKUP_SUFFIX"
  fi
}

install_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  backup_file "$target"
  cp "$source" "$target"
  echo "  ✓ $(basename "$target")"
}

echo "=== multi-agents: OpenCode first-time install ==="
echo "Target: $TARGET_DIR"
echo ""

# AGENTS.md
install_file "$REPO_ROOT/opencode/AGENTS.md" "$TARGET_DIR/AGENTS.md"

# opencode.json
install_file "$REPO_ROOT/opencode/opencode.json" "$TARGET_DIR/opencode.json"

echo ""
echo "Run distribute.sh from the repo root to sync agents, skills, and commands."
echo "  cd $REPO_ROOT && ./distribute.sh"
