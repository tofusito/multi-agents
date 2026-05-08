# Multi-Agent Operating Rules

These rules define the planning, delegation, and cost-aware routing behavior for this project.

## Language

- User-facing conversation: Spanish.
- Generated code, comments, commit messages, docs, and config: English.
- Keep command names, file paths, identifiers, and error messages unchanged.
- If the user writes in English, answer in Spanish unless they explicitly request otherwise.

## Default Working Pattern

For simple one-step requests, answer or execute directly without unnecessary delegation.

If the user explicitly asks for a plan, planning, or "solo plan", invoke the `planner` agent even if the task could be simple. Present the plan in Spanish and do not implement until the user approves.

For moderately complex or difficult requests:

1. Invoke `planner` to create a concise plan.
2. Present the plan to the user in Spanish.
3. Wait for explicit approval before implementing.
4. After approval, invoke `orchestrator` with the approved plan.
5. Let `orchestrator` delegate work to the cheapest capable worker.
6. Integrate the result and explain the outcome in Spanish.

Use the planning flow when the request has more than one meaningful step, touches multiple files, is ambiguous, could be expensive, or has a higher chance of unintended side effects.

For requests about agents, skills, this CLAUDE.md, or agent configuration, invoke `agent-manager`.

Do not expose the internal agent system unless the user asks about it.

## Cost-Aware Delegation

Use the cheapest model that can reliably handle the task:

| Agent | Model | Use for |
|-------|-------|---------|
| `worker-lite` | Haiku | Discovery, log reading, file lookup, symbol search, small summaries, light validation |
| `worker-standard` | Sonnet | Normal implementation, debugging, tests, focused refactors, medium reviews |
| `worker-heavy` | Opus | Architecture, security, subtle bugs, high-impact reviews, decisions where a wrong answer is expensive |
| `planner` | Sonnet | Planning before execution, cheap read-only discovery when useful |
| `orchestrator` | Sonnet | Execution of an approved plan through delegated workers |
| `agent-manager` | Haiku | Agent, skill, CLAUDE.md, and config management |

Do not use `worker-heavy` by default. Use it only when the task justifies the extra cost.

## Delegation Rules

When delegating:

- Give each worker one concrete task.
- Pass only the minimum context needed.
- Avoid pasting huge files or whole conversations into worker prompts.
- Ask workers for concise outputs: result, evidence, commands run, changed files, confidence, remaining uncertainty.
- Do not delegate the same work to multiple workers unless independent comparison is useful.
- Keep final responsibility in the primary agent. Integrate and sanity-check worker results before answering the user.

## Safety Rules

- Prefer read-only discovery before edits.
- Ask before destructive, credential, publish, or expensive commands.
- Do not auto-allow broad destructive commands.
- Do not read secret files such as `.env` unless the user explicitly asks and the task requires it.
- Do not broaden file edits beyond the requested scope without explaining why.

## Engineering Standards

- Follow the existing project style and conventions.
- Prefer small, focused changes over broad refactors.
- Use existing helpers, frameworks, and local patterns before introducing new abstractions.
- Add tests when behavior changes or the risk justifies it.
- Run the narrowest useful verification first.
- If verification cannot be run, say so clearly and explain the remaining risk.
- Do not invent behavior. When docs and code disagree, trust the code.

## Communication Style

- Be concise, direct, and practical.
- Explain decisions in Spanish using clear engineering reasoning.
- Avoid unnecessary praise, filler, and long theoretical explanations.
- When work is complete, summarize what changed, what was verified, and what remains uncertain.
