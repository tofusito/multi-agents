#!/usr/bin/env bash
# distribute.sh — sync agents, skills, and commands to OpenCode and/or Claude Code
#
# Usage:
#   ./distribute.sh                 # install for both OpenCode and Claude Code
#   ./distribute.sh --opencode-only
#   ./distribute.sh --claude-only
#
# Model overrides (env vars):
#   MODEL_LITE   default: github-copilot/claude-haiku-4.5
#   MODEL_STANDARD  default: github-copilot/claude-sonnet-4.6
#   MODEL_HEAVY    default: github-copilot/claude-opus-4.6
#   LANGUAGE      default: Spanish

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Model IDs — override via env vars if needed
# Use the provider prefix your OpenCode is configured with (e.g. github-copilot/, openai/)
MODEL_LITE="${MODEL_LITE:-github-copilot/claude-haiku-4.5}"
MODEL_STANDARD="${MODEL_STANDARD:-github-copilot/claude-sonnet-4.6}"
MODEL_HEAVY="${MODEL_HEAVY:-github-copilot/claude-opus-4.6}"
LANGUAGE="${LANGUAGE:-Spanish}"

OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

install_opencode=true
install_claude=true

for arg in "$@"; do
  case "$arg" in
    --opencode-only) install_claude=false ;;
    --claude-only)   install_opencode=false ;;
    --help|-h)
      echo "Usage: ./distribute.sh [--opencode-only | --claude-only]"
      echo ""
      echo "Env var overrides:"
      echo "  MODEL_LITE   (default: github-copilot/claude-haiku-4.5)"
      echo "  MODEL_STANDARD  (default: github-copilot/claude-sonnet-4.6)"
      echo "  MODEL_HEAVY    (default: github-copilot/claude-opus-4.6)"
      echo "  LANGUAGE      (default: Spanish)"
      exit 0
      ;;
  esac
done

# ── Helpers ────────────────────────────────────────────────────────────────────

replace_placeholders() {
  local content="$1"
  content="${content//\{\{MODEL_LITE\}\}/$MODEL_LITE}"
  content="${content//\{\{MODEL_STANDARD\}\}/$MODEL_STANDARD}"
  content="${content//\{\{MODEL_HEAVY\}\}/$MODEL_HEAVY}"
  content="${content//\{\{LANGUAGE\}\}/$LANGUAGE}"
  printf '%s' "$content"
}

strip_frontmatter() {
  # Remove leading YAML frontmatter (--- ... ---) from file content
  local content="$1"
  if [[ "$content" =~ ^--- ]]; then
    content=$(printf '%s' "$content" | awk 'BEGIN{count=0} /^---/{count++; if(count<=2)next} count>=2{print}')
  fi
  printf '%s' "$content"
}

# ── OpenCode install ───────────────────────────────────────────────────────────

install_opencode_agents() {
  mkdir -p "$OPENCODE_DIR/agents"
  local count=0
  for src in "$REPO_ROOT/agents/"*.md; do
    [[ -f "$src" ]] || continue
    local name
    name=$(basename "$src")
    local content
    content=$(< "$src")
    content=$(replace_placeholders "$content")
    printf '%s\n' "$content" > "$OPENCODE_DIR/agents/$name"
    echo "  ✓ agents/$name"
    ((count++)) || true
  done
  [[ $count -gt 0 ]] || echo "  (no agents found in agents/)"
}

install_opencode_skills() {
  mkdir -p "$OPENCODE_DIR/skills"
  local count=0
  for skill_dir in "$REPO_ROOT/skills/"/*/; do
    [[ -d "$skill_dir" ]] || continue
    local skill_name
    skill_name=$(basename "$skill_dir")
    local src="$skill_dir/SKILL.md"
    [[ -f "$src" ]] || continue
    mkdir -p "$OPENCODE_DIR/skills/$skill_name"
    cp "$src" "$OPENCODE_DIR/skills/$skill_name/SKILL.md"
    echo "  ✓ skills/$skill_name/SKILL.md"
    ((count++)) || true
  done
  [[ $count -gt 0 ]] || echo "  (no skills found in skills/)"
}

install_opencode_commands() {
  local src_dir="$REPO_ROOT/opencode/commands"
  [[ -d "$src_dir" ]] || return
  mkdir -p "$OPENCODE_DIR/commands"
  local count=0
  for src in "$src_dir/"*.md; do
    [[ -f "$src" ]] || continue
    local name
    name=$(basename "$src")
    local content
    content=$(< "$src")
    content=$(replace_placeholders "$content")
    printf '%s\n' "$content" > "$OPENCODE_DIR/commands/$name"
    echo "  ✓ commands/$name"
    ((count++)) || true
  done
  [[ $count -gt 0 ]] || echo "  (no commands found in opencode/commands/)"
}

install_opencode_agents_md() {
  local src="$REPO_ROOT/opencode/AGENTS.md"
  [[ -f "$src" ]] || return
  local content
  content=$(< "$src")
  content=$(replace_placeholders "$content")
  printf '%s\n' "$content" > "$OPENCODE_DIR/AGENTS.md"
  echo "  ✓ AGENTS.md"
}

# ── Claude Code install ────────────────────────────────────────────────────────

install_claude_commands() {
  local src_dir="$REPO_ROOT/claude/commands"
  [[ -d "$src_dir" ]] || return
  mkdir -p "$CLAUDE_DIR/commands"
  local count=0
  for src in "$src_dir/"*.md; do
    [[ -f "$src" ]] || continue
    local name
    name=$(basename "$src")
    local content
    content=$(< "$src")
    content=$(replace_placeholders "$content")
    # Claude Code commands have no frontmatter — strip it if present
    content=$(strip_frontmatter "$content")
    printf '%s\n' "$content" > "$CLAUDE_DIR/commands/$name"
    echo "  ✓ commands/$name"
    ((count++)) || true
  done
  [[ $count -gt 0 ]] || echo "  (no commands found in claude/commands/)"
}

# ── Main ───────────────────────────────────────────────────────────────────────

echo "=== multi-agents distribute ==="
echo "LANGUAGE=$LANGUAGE"
echo "LITE=$MODEL_LITE"
echo "STANDARD=$MODEL_STANDARD"
echo "HEAVY=$MODEL_HEAVY"
echo ""

if $install_opencode; then
  echo "→ OpenCode ($OPENCODE_DIR)"
  install_opencode_agents
  install_opencode_skills
  install_opencode_commands
  install_opencode_agents_md
  echo ""
fi

if $install_claude; then
  echo "→ Claude Code ($CLAUDE_DIR)"
  install_claude_commands
  echo ""
fi

echo "Done."
