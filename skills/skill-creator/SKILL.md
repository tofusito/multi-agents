---
name: skill-creator
description: Create or update skills (SKILL.md files) with correct frontmatter, naming rules, and well-structured content for OpenCode and Claude Code.
compatibility: opencode
version: "1.0.0"
metadata:
  audience: agent-manager
  workflow: skill-design
---

## What is a skill

A **skill** is a reusable instruction set that an agent loads on demand. Unlike agents, skills have no model, permissions, or lifecycle — they are pure content injected into the active agent's context when called.

Use a skill when:
- The behavior is reusable across multiple agents.
- The instructions are too long or specific to live in the agent prompt.
- The content should only be loaded when relevant, not on every message.
- You want to share domain knowledge without creating a full agent.

Use an agent instead when:
- The task requires a different model, temperature, or permission set.
- The behavior needs to run independently with its own tool access.

## File placement

One folder per skill, one `SKILL.md` inside it. Folder name must match the `name` field in frontmatter.

| Scope | Path |
|-------|------|
| Global (all projects) | `~/.config/opencode/skills/<name>/SKILL.md` |
| Project-local | `.opencode/skills/<name>/SKILL.md` |

In this repo, skills live at `skills/<name>/SKILL.md` and are synced by `distribute.sh`.

## Frontmatter spec

```yaml
---
name: my-skill-name          # required — must match directory name
description: One sentence.   # required — 1-1024 chars, specific enough for discovery
compatibility: opencode
version: "1.0.0"
metadata:
  audience: workers
  workflow: release
---
```

## Naming rules

- 1–64 characters
- Lowercase alphanumeric with single hyphen separators only
- No `--`, no leading/trailing `-`
- Must match the directory name exactly

Valid: `git-workflow`, `code-review`, `claude-api`
Invalid: `Git-Workflow`, `code--review`, `-starts-dash`

## Description rules

- 1–1024 characters
- Specific enough for the agent to choose the right skill
- One-sentence action statement: what the skill does and when to use it

Good: `Create consistent release notes from merged PRs following the team versioning scheme.`
Bad: `Helps with releases.`

## Body content

Free-form Markdown. Structure it so the loading agent can act immediately.

Recommended sections:
```markdown
## What I do
Bullet list of concrete actions this skill enables.

## When to use me
Conditions that should cause an agent to load this skill.

## Workflow / Steps
Numbered steps if the skill describes a process.

## Templates
Paste-ready templates.

## Rules
Non-negotiable rules when this skill is active.
```

## Creation workflow

1. Confirm the skill name is valid (lowercase, no consecutive hyphens, matches directory).
2. Write frontmatter: `name`, `description`, `compatibility`, `version`, optional `metadata`.
3. Write the body. Lead with "What I do" and "When to use me".
4. Place at `skills/<name>/SKILL.md`. `distribute.sh` will sync it.
5. Tell the user how to verify it loaded.

## Review checklist

Before finishing, verify:

- [ ] Directory name matches `name` frontmatter exactly.
- [ ] `name` is lowercase alphanumeric with single hyphens only.
- [ ] `description` is specific, actionable, and ≤ 1024 characters.
- [ ] Body leads with what the skill does and when to use it.
- [ ] No secrets, credentials, or environment-specific values are hardcoded.
- [ ] File is spelled `SKILL.md` (all caps).
- [ ] File is at `skills/<name>/SKILL.md`, not inside `opencode/` or `agents/`.
