# Multi Agents Research

This repository is an exploration of multi-agent workflows for different development environments.

The goal is to test practical agent ecosystems that are:

- transparent for the user
- cost-aware
- easy to install and share
- explicit about model routing
- safe enough for local development
- adaptable to different tools and runtimes

## Environments

Current experiments:

- [OpenCode](./opencode/README.md): a transparent planning and orchestration setup using hidden workers and cost-aware model selection.

Future experiments can live in their own folders, for example:

- `claude-code/`
- `codex/`
- `cursor/`
- `aider/`
- `custom-mcp/`

## Repository Philosophy

Each environment should be self-contained and include:

- install instructions
- agent definitions
- global or project rules
- model routing strategy
- permissions strategy
- notes about expected workflow

The root of the repository stays tool-agnostic. Tool-specific implementation details belong inside each environment folder.
