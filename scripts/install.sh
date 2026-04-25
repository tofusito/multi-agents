#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"

backup_file() {
  local target="$1"
  if [[ -e "$target" ]]; then
    cp "$target" "$target.bak.$BACKUP_SUFFIX"
  fi
}

install_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  backup_file "$target"
  cp "$source" "$target"
}

mkdir -p "$TARGET_DIR/agents" "$TARGET_DIR/skills"

install_file "$ROOT_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
install_file "$ROOT_DIR/opencode.json" "$TARGET_DIR/opencode.json"

for agent in "$ROOT_DIR"/agents/*.md; do
  install_file "$agent" "$TARGET_DIR/agents/$(basename "$agent")"
done

for skill_dir in "$ROOT_DIR"/skills/*; do
  [[ -d "$skill_dir" ]] || continue
  target_skill="$TARGET_DIR/skills/$(basename "$skill_dir")"
  if [[ -e "$target_skill" ]]; then
    cp -R "$target_skill" "$target_skill.bak.$BACKUP_SUFFIX"
  fi
  rm -rf "$target_skill"
  mkdir -p "$(dirname "$target_skill")"
  cp -R "$skill_dir" "$target_skill"
done

echo "Installed OpenCode multi-agent setup into $TARGET_DIR"
echo "Existing files were backed up with suffix .bak.$BACKUP_SUFFIX"
