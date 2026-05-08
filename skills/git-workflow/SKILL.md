---
name: git-workflow
description: General Git and GitHub workflow conventions — branch naming, commit format, push workflow, PR size rules, and gh CLI usage.
compatibility: opencode
version: "1.0.0"
metadata:
  audience: workers, orchestrator
  domain: git
---

## Branch naming

Pattern: `<type>/<short-description>`

- Types: `feature`, `fix`, `refactor`, `docs`, `chore`
- short-description: lowercase, hyphen-separated

Examples:
```
feature/add-oauth-support
fix/token-refresh-race-condition
refactor/extract-agent-router
docs/update-multi-agent-guide
```

If the project uses ticket IDs: `<type>/<TICKET-ID>/<short-description>`

## Commit format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): Short description
```

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix or correction |
| `chore` | Maintenance, tooling |
| `refactor` | Code change, no feature/fix |
| `docs` | Documentation only |
| `test` | Adding/updating tests |
| `ci` | CI/CD pipeline changes |
| `perf` | Performance improvement |

Rules:
- Subject line < 72 characters
- Imperative mood: "Add feature" not "Added feature"
- Never commit or push without user confirmation

## Push workflow

Always sync with the base branch before pushing:

```bash
git fetch origin
git merge origin/main   # or rebase for local branches
git push origin <branch>
```

Never push directly to main/master.

## Commit gate

Always show before committing or pushing:
1. Proposed commit message
2. Files staged

Wait for explicit approval before running `git commit` or `git push`.

## GitHub — gh CLI

Prefix with `GH_PAGER=cat` to avoid pager blocking:
```bash
GH_PAGER=cat gh pr list
GH_PAGER=cat gh pr view <number>
```

Use `--json` for data extraction. Use `gh pr create` with `--title` and `--body`.

## PR size

If a PR exceeds any threshold, propose splitting:
- > 400 lines changed
- > 10 files changed
- Mixes unrelated concerns

Split by logical concern, not by file count.

## Safety rules

- Never merge without explicit user confirmation
- Never push to main/master directly
- Never force push (`git push --force`)
- Always use conventional commit titles for PRs
