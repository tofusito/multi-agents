---
name: documentation
description: Technical documentation workflow for capturing work done — decisions, commands, issues, and resolutions — into structured Markdown notes saved to an Obsidian vault.
compatibility: opencode
version: "1.0.0"
metadata:
  audience: workers
  domain: documentation
---

## Workflow

1. **Determine output folder** — use a short descriptor or project name (e.g. `multi-agents`, `claude-api-refactor`). Ask if unclear.
2. **Extract from conversation** — goal, actions taken, decisions, problems, dynamic values, repos, branches.
3. **Fill gaps from git** — only if conversation lacks detail: `git log`, `git diff`, recent commits.
4. **Write** using the template below.
5. **Save** to `~/writer/<folder-name>/<descriptive-name>.md`. Create folder if needed.

## Document template

```markdown
---
tags: [#report, #<project>]
date: YYYY-MM-DD
status: active
---

# <Short description>

**Date:** YYYY-MM-DD | **Repos:** `<repos>` | **Context:** <brief context>

## Summary
One paragraph: what was done, key outcome, critical decisions.

## What Was Done
### 1. <First logical step>
**What:** description
**Why:** reason
**How:** commands run, files changed

### 2. <Next step>
...

## Dynamic Values
| Placeholder | Value | How to obtain |
|---|---|---|
| model id | `claude-sonnet-4-6` | anthropic docs |

## Issues Encountered
| # | Issue | Root Cause | Resolution |
|---|---|---|---|

## Replication Checklist
- [ ] Step 1 — with exact commands
- [ ] Step 2

## References
- Repo: https://github.com/...
- Docs: ...
```

## Rules

- Conversation content first, git history second
- Never skip the replication checklist — it is the most valuable part for future reference
- Flag gaps honestly as "needs confirmation" rather than guessing
- Do not push documents to any remote
- Keep dynamic values (model IDs, config values, resource names) in their own table so they are easy to find when replicating
