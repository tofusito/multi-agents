# Multi Agents

An exploration of multi-agent workflows for development environments.

In plain language: this is a setup that lets you talk to your coding assistant normally, while a small agent system decides whether the task needs a quick answer, a plan, or delegated work.
The goal is to make AI-assisted development feel simpler for the human while keeping model cost, context size, and implementation risk under control.

## Architecture

The repo is organized in three layers:

```
multi-agents/
├── agents/          # Tool-agnostic agent definitions (model placeholders)
├── skills/          # Reusable knowledge modules loaded on demand
├── opencode/        # OpenCode-specific config (AGENTS.md, commands, opencode.json)
├── claude/          # Claude Code-specific config (CLAUDE.md, commands)
└── distribute.sh    # Sync agents, skills, and commands to OpenCode / Claude Code
```

### Agents

Six hidden workers + two visible orchestration agents:

| Agent | Model | Role |
|-------|-------|------|
| `worker-lite` | Haiku | Cheap read-only work — file lookup, log reading, summaries |
| `worker-standard` | Sonnet | Normal implementation, debugging, tests, refactors |
| `worker-heavy` | Opus | Architecture, security, subtle bugs, high-risk decisions |
| `planner` | Sonnet | Creates plans for user approval before execution |
| `orchestrator` | Sonnet | Executes approved plans by delegating to the cheapest capable worker |
| `agent-manager` | Haiku | Creates and updates agents, skills, and global config |

### Skills

Domain knowledge loaded on demand — no model or permissions, pure content:

| Skill | Use for |
|-------|---------|
| `git-workflow` | Branch naming, conventional commits, PR rules, gh CLI |
| `code-review` | Per-change analysis, review checklist, LGTM/Block verdict |
| `documentation` | Structured Markdown notes saved to Obsidian vault |
| `claude-api` | Claude API patterns, prompt caching, tool use, cost optimization |
| `agent-creator` | Design and write new agent files |
| `skill-creator` | Design and write new skill files |

### Request routing

```
User request
    ↓
Trivial (1 step)      → Primary agent answers directly
Moderate (2-3 steps)  → worker-lite (reads) + worker-standard (writes)
Complex               → @planner → user approval → @orchestrator → workers
```

## Install

```bash
# First time (OpenCode config + AGENTS.md)
./opencode/scripts/install.sh

# Sync agents, skills, and commands (run after any change)
./distribute.sh

# OpenCode only or Claude Code only
./distribute.sh --opencode-only
./distribute.sh --claude-only
```

### Model overrides

The default models use GitHub Copilot. Override via env vars:

```bash
# Example: use OpenAI models instead
MODEL_LITE=openai/gpt-4o-mini MODEL_STANDARD=openai/gpt-4o MODEL_HEAVY=openai/o3 ./distribute.sh
```

Default model IDs:

| Placeholder | Default |
|-------------|---------|
| `{{MODEL_LITE}}` | `github-copilot/claude-haiku-4.5` |
| `{{MODEL_STANDARD}}` | `github-copilot/claude-sonnet-4.6` |
| `{{MODEL_HEAVY}}` | `github-copilot/claude-opus-4.6` |

### Claude Code

Copy or symlink `claude/CLAUDE.md` into your project:

```bash
cp claude/CLAUDE.md /path/to/your-project/CLAUDE.md
```

The slash commands in `claude/commands/` are synced to `~/.claude/commands/` by `distribute.sh`.

## Cost Metrics

The repository defines a cost-aware model-routing policy and tracks routing efficiency.

Pilot result, 2026-04-26:

| Worker | Calls | Input | Output | Heavy model avoided |
| --- | ---: | ---: | ---: | --- |
| `worker-lite` | 3 | 3.4K | 111 | Yes |
| `worker-standard` | 4 | 12.3K | 575 | Yes |
| `worker-heavy` | 0 | 0 | 0 | — |

77% cost reduction vs. all-Sonnet baseline on multi-step tasks.
Detailed report: [Model Routing Efficiency Report](./opencode/reports/model-routing-efficiency-2026-04-26.md).

## Environments

- [opencode/](./opencode/README.md) — OpenCode environment with OpenAI models (first pilot)
- `agents/` + `skills/` — Tool-agnostic layer, uses Claude models via `distribute.sh`
