---
name: review
description: Apply the code-review skill to review staged changes, a branch, or a PR. Outputs per-change verdicts, a checklist, and a final LGTM/Block verdict.
---

Apply the code-review skill and review the following:

$ARGUMENTS

If no PR or branch is specified, review the current staged/uncommitted changes.

Follow the code-review skill methodology:
- Per-change analysis with verdict (✅ / ⚠️ / ❌)
- Every ❌ or ⚠️ flag must include a concrete suggested fix
- Check correctness, security, and best practices
- Escalate to worker-heavy if the changes touch auth, security, or 500+ lines
- Output the review in the standard format (Summary → Changes → Double-Check → Verdict)
