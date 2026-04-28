# Multi Agents for OpenCode

Personal OpenCode agent setup for cost-aware, transparent task orchestration.

The goal is simple: ask OpenCode a normal question and let it decide when to plan, delegate, and use cheaper or stronger models.

## Design

Default visible workflow:

- `build`: default OpenCode agent used for normal interaction.
- `planner`: visible subagent for explicit planning requests.

Hidden internal workflow:

- `orchestrator`: executes approved plans and routes work to workers.
- `agent-manager`: manages OpenCode agents, skills, `AGENTS.md`, and config.
- `worker-lite`: low-cost worker for discovery, logs, lookup, and small summaries.
- `worker-standard`: medium worker for normal implementation, debugging, and verification.
- `worker-heavy`: stronger worker for difficult reasoning and high-risk tasks.

## Model Routing

- Easy/default: `openai/gpt-5.4-mini`
- Medium: `openai/gpt-5.4`
- Strong/heavy: `openai/gpt-5.5`

The hidden workers are assigned models by expected difficulty. `worker-heavy` is not used by default.

Routing and cost-efficiency reports live in [`reports/`](./reports/).

This configuration expects OpenAI models to be available in OpenCode. If you use another provider, update `opencode.json` and the agent `model` fields before installing.

## Planning Flow

For simple requests, OpenCode should answer or act directly.

For moderately complex requests:

1. Invoke `planner`.
2. Present the plan to the user in Spanish.
3. Wait for approval.
4. Send the approved plan to `orchestrator`.
5. Let `orchestrator` route subtasks to the cheapest capable worker.

If the user explicitly asks for a plan, `planner` should be used directly.

## Language Rules

- User-facing conversation: Spanish.
- Generated documentation: English.
- Generated code, comments, tests, README files, runbooks, ADRs, and config comments: English.

## Repository Layout

```text
opencode/
├── AGENTS.md
├── agents/
│   ├── agent-manager.md
│   ├── orchestrator.md
│   ├── planner.md
│   ├── worker-heavy.md
│   ├── worker-lite.md
│   └── worker-standard.md
├── opencode.json
├── reports/
│   └── model-routing-efficiency-2026-04-26.md
├── scripts/
│   └── install.sh
└── skills/
    └── opencode-agent-creator/
        └── SKILL.md
```

## Install

From this `opencode/` directory:

```bash
./scripts/install.sh
```

Or from the repository root:

```bash
./opencode/scripts/install.sh
```

This copies:

- `AGENTS.md` to `~/.config/opencode/AGENTS.md`
- `opencode.json` to `~/.config/opencode/opencode.json`
- `agents/*.md` to `~/.config/opencode/agents/`
- `skills/*` to `~/.config/opencode/skills/`

The script creates timestamped backups for existing target files before overwriting them.

## Usage

Start OpenCode normally:

```bash
opencode
```

Ask normal questions. For explicit planning:

```text
@planner create a plan to refactor this feature
```

For agent/config changes, ask normally; the rules should route the task to `agent-manager`.

## Notes

This setup is intended for local development. Review permissions before using it in repositories with sensitive credentials, irreversible local state, or shared team workflows.
