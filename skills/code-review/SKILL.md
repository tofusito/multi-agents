---
name: code-review
description: Senior code review methodology — per-change analysis framework, review checklist (correctness, security, best practices), and verdict format for pull request reviews.
compatibility: opencode
version: "1.0.0"
metadata:
  audience: workers, worker-heavy
  domain: code-quality
---

## Per-change analysis

For each logical change, assess:

1. **What changed** — file, lines, nature of change
2. **Why** — inferred intent from PR description and context
3. **Assessment** — one of:
   - ✅ **Best option** — ideal implementation
   - ✅ **Good enough** — acceptable, no action needed
   - ⚠️ **Improvable** — works but has a better alternative
   - ❌ **Problematic** — bug, risk, or violation that must be addressed

4. **Suggested fix** — every flag must include a concrete suggestion

Always read full file context, not just the diff. Understand intent before judging.

## Review checklist

### Correctness
- Logic errors, off-by-one, wrong conditions
- Nil/null/undefined checks missing
- All code paths handled (error cases, empty inputs)
- Return values checked where needed

### Security
- Input validation — SQL injection, XSS, path traversal
- Exposed secrets or credentials in code/logs
- Missing auth checks or authorization bypass
- Dependency vulnerabilities

### Best practices
- Follows repo conventions and naming patterns
- No unnecessary duplication
- Functions/methods have single responsibility
- Error handling is explicit, not silent

### Areas to double-check
- Complex conditional logic
- Shared utilities or helpers modified
- Auth, session, or persistence logic
- Any change that affects more than one system

### Potential issues
- Breaking changes to public interfaces or contracts
- Missing error handling on external calls
- Performance implications (N+1, missing indexes, large payloads)
- Missing tests for new logic paths

## Escalation

Escalate to `worker-heavy` if the PR touches:
- Auth/authorization/session/secret handling
- Core architecture with non-obvious tradeoffs
- Security-sensitive code
- 500+ lines changed

Inform the user before escalating.

## Output format

```
## PR Review: <repo>#<number>

### Summary
One paragraph: what the PR does and overall assessment.

### Changes
#### 1. <File or logical group> — <verdict emoji>
What changed, why, assessment, suggested fix if needed.

#### 2. ...

### Areas to Double-Check
- Specific lines or patterns worth a second look

### Best Practice Suggestions
- Non-blocking improvements

### Verdict
✅ LGTM | ✅ LGTM with nits | ⚠️ Request changes | ❌ Block
```

## Rules

- Be specific: exact file paths, line numbers, variable names
- Every ❌ or ⚠️ flag comes with a concrete suggested fix
- Do not invent issues — if the PR is clean, say so clearly
- Do not push or merge anything
