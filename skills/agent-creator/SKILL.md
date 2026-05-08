---
name: agent-creator
description: Create or update agents for OpenCode and Claude Code with conservative permissions, cost-aware model selection, and a short questioning workflow before writing files.
compatibility: opencode
version: "1.0.0"
metadata:
  audience: agent-manager
  workflow: agent-design
---

## When to use me

Use this skill when creating or modifying an agent file (`.md` for OpenCode, or a custom agent for Claude Code SDK).

## Questions first

Before writing a new agent, collect only the information that affects safety or cost:

1. **Purpose** — what job should the agent do?
2. **Scope** — global or this project only?
3. **Mode** — primary, subagent, or all?
4. **Model tier** — lite/cheap, standard, heavy, or inherit?
5. **Write access** — no edits, docs/config only, or broader?
6. **Shell access** — deny, ask, or allow only specific read/test commands?
7. **Network access** — deny, ask, or allow specific tools?

If the user already gave enough information, proceed without asking.

## Design rules

- Split agents by **risk and permission**, not by personality.
- Use `{{MODEL_LITE}}` for low-risk lookup, documentation, simple creation tasks.
- Use `{{MODEL_STANDARD}}` for normal implementation tasks that need reliability.
- Use `{{MODEL_HEAVY}}` for security, architecture, complex review, or broad code changes.
- Default to `temperature: 0.1` for review, planning, security, and config generation.
- Use `steps` for agents that can loop or run investigations.
- Do not give destructive commands automatic approval.
- Deny or require approval for `rm`, `sudo`, `git push`, broad destructive patterns, and secret-reading commands.
- Keep generated agents small, explicit, and easy to audit.

## File placement

| Tool | Global path | Project path |
|------|-------------|--------------|
| OpenCode | `~/.config/opencode/agents/<name>.md` | `.opencode/agents/<name>.md` |
| Claude Code | `~/.claude/agents/<name>.md` | `.claude/agents/<name>.md` |

In this repo, agents live at `agents/<name>.md` and are synced by `distribute.sh`.

## Agent template

```markdown
---
description: One precise sentence describing when to use this agent.
mode: subagent
hidden: true
model: {{MODEL_STANDARD}}
temperature: 0.1
steps: 10
permission:
  edit:
    "*": deny
  bash:
    "*": deny
    "git status*": allow
    "git diff*": allow
    "ls *": allow
    "rg *": allow
  webfetch: ask
  task:
    "*": deny
    "worker-lite": allow
---
You are ...

## Scope
What this agent does.

## Boundaries
What this agent must never do.

## Output
Expected output format.
```

## Creation workflow

1. Decide whether this is an agent, a skill, or both.
2. Ask only the safety/cost questions that remain unanswered.
3. Choose the cheapest model tier that can do the job reliably.
4. Draft the frontmatter: description, mode, model, temperature, steps, permissions.
5. Draft the prompt with concrete duties, non-goals, and expected output format.
6. Write the file.
7. Tell the user the invocation name and the file path.

## Review checklist

Before finishing, verify:

- [ ] Filename matches the intended agent name.
- [ ] Description is specific enough for discovery.
- [ ] Model choice matches risk and expected context size.
- [ ] Edit permissions are no broader than needed.
- [ ] Bash permissions do not auto-allow destructive, credential, or publish commands.
- [ ] The prompt tells the agent when to ask questions and when to proceed.
