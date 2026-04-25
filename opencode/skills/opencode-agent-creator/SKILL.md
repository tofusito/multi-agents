---
name: opencode-agent-creator
description: Create or update OpenCode agents and agent skills with conservative permissions, OpenAI GPT 5.4 mini/5.4/5.5 cost-aware model selection, and a short questioning workflow before writing files.
compatibility: opencode
metadata:
  audience: opencode-users
  workflow: agent-design
---

# OpenCode Agent Creator

Use this skill when creating or modifying OpenCode agents, OpenCode skills, or the permissions/model strategy that connects them.

## Output Targets

Prefer global files unless the user asks for project-local behavior:

- Global agents: `~/.config/opencode/agents/<agent-name>.md`
- Global skills: `~/.config/opencode/skills/<skill-name>/SKILL.md`
- Project agents: `.opencode/agents/<agent-name>.md`
- Project skills: `.opencode/skills/<skill-name>/SKILL.md`

Skill names must be lowercase alphanumeric with single hyphen separators and the folder name must match the `name` frontmatter.

## Questions First

Before writing a new agent, collect only missing information that affects safety or cost:

- Purpose: what job should the agent do?
- Scope: global or this project only?
- Mode: primary, subagent, or all?
- Model tier: easy/default, medium, strong/heavy, or inherit caller model?
- Write access: no edits, docs/config only, OpenCode config only, or broader?
- Shell access: deny, ask, or allow only specific read/test commands?
- Network/MCP access: deny, ask, or allow specific tools?

If the user already gave enough information, proceed without asking.

## Design Rules

- Split agents by risk and permission, not by personality.
- Use `openai/gpt-5.4-mini` for low-risk lookup, documentation, simple creation tasks, and default agent management.
- Use `openai/gpt-5.4` for normal development tasks that need more reliability but are not high-risk.
- Use `openai/gpt-5.5` for security, architecture, complex review, or broad code changes.
- Default to `temperature: 0.1` for review, planning, security, infra, and config generation.
- Use `steps` for agents that can loop or run investigations.
- Do not give destructive commands automatic approval.
- Deny or require approval for `rm`, `sudo`, `git push`, broad destructive commands, publish commands, and secret-reading commands.
- Prefer `permission` over deprecated `tools` for new agents.
- If an agent should load this skill, allow `permission.skill.opencode-agent-creator`.
- If a primary agent should manage other agents, allow `permission.task` only for the subagents it should invoke.

## Agent Template

```markdown
---
description: One precise sentence describing when to use this agent.
mode: primary
model: openai/gpt-5.4-mini
temperature: 0.1
steps: 10
permission:
  edit:
    "*": deny
  bash:
    "*": ask
    "git status*": allow
    "git diff*": allow
    "ls *": allow
    "rg *": allow
  webfetch: ask
  skill:
    "*": ask
    "opencode-agent-creator": allow
---
You are ...
```

Adjust `mode`, `model`, `steps`, and permissions to the user request.

## Creation Workflow

1. Decide whether this is an agent, a skill, or both.
2. Ask only the safety/cost questions that remain unanswered.
3. Choose the cheapest OpenAI model tier that can do the job reliably: `openai/gpt-5.4-mini`, then `openai/gpt-5.4`, then `openai/gpt-5.5`.
4. Draft the frontmatter first: description, mode, model, temperature, steps, permissions.
5. Draft the prompt with concrete duties, non-goals, and expected output format.
6. Write the file.
7. Verify the file path, frontmatter, name constraints, and risky permissions.
8. Tell the user how to invoke it.

## Review Checklist

Before finishing, check:

- The filename matches the intended agent or skill name.
- The description is specific enough for discovery.
- The model choice matches risk and expected context size.
- Edit permissions are no broader than needed.
- Bash permissions do not auto-allow destructive, credential, publish, or expensive commands.
- Skill permissions expose only the needed skills.
- The prompt tells the agent when to ask questions and when to proceed.
