# Multi Agents Research

This repository is an exploration of multi-agent workflows for different development environments.

In plain language: this is a setup that lets you talk to your coding assistant normally, while a small agent system decides whether the task needs a quick answer, a plan, or delegated work.
The goal is to make AI-assisted development feel simpler for the human while keeping model cost, context size, and implementation risk under control.

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

## Cost Metrics

The repository defines the model-routing policy and includes initial pilot measurements.

Current status:

- Routing strategy: implemented and configured with direct OpenAI model IDs.
- Real token/model routing measurements: first pilots collected.
- Baseline comparison against a single strong model: not collected yet.

Pilot run, 2026-04-26:

| Scope | Sessions | Messages | Input | Output | Cache read | Cost |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| OpenCode project stats | 7 | 29 | 79.6K | 9.9K | 194.3K | $0.21 |
| Five titled test sessions | 5 | - | 61.9K | 6.3K | 155.6K | $0.16 |

The first test sessions covered a simple explanation, README summary, measurement planning, routing review, and LinkedIn-readiness review. They proved that measurement works, but initially used the previously configured default model.

After configuring OpenAI in OpenCode, follow-up tests confirmed:

- default `build` model: `openai/gpt-5.4-mini`
- delegated planning model: `openai/gpt-5.4`
- direct OpenAI execution: working
- explicit planner invocation: working

Worker-routing pilot:

| Worker | Calls | Input | Output | Heavy model avoided |
| --- | ---: | ---: | ---: | --- |
| `worker-lite` | 3 | 3.4K | 111 | Yes |
| `worker-standard` | 4 | 12.3K | 575 | Yes |
| `worker-heavy` | 0 | 0 | 0 | - |

In this pilot, 15.7K worker input tokens and 686 worker output tokens were handled without calling `worker-heavy`. Because heavier models normally have higher per-token prices, routing simple and medium work to `worker-lite` and `worker-standard` is the expected cost-saving mechanism.

Detailed report: [Model Routing Efficiency Report](./opencode/reports/model-routing-efficiency-2026-04-26.md).

The intended measurement is:

- compare the actual routed workflow against a hypothetical "strong model for everything" workflow
- record model used, task type, approximate input/output tokens, and estimated cost
- publish only measured savings once there are enough representative sessions

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
