---
name: implementation
description: End-to-end code implementation workflow with multi-agent review. Only invoke when explicitly referenced with /implementation.
---

# Implementation

## Workflow

### Step 0: Branch Guard

Check the current branch with `git branch --show-current`.

If the current branch is `main` or `master`, invoke `$git-operations` Scenario A to create a feature branch before writing any code. Derive the branch name from the request (for example `feat/add-user-export`). Do not proceed until the branch is created.

If already on a feature branch, continue to Step 1.

Record the current HEAD SHA before any changes: `git rev-parse HEAD`. Store this as `BASE_SHA` — it will be used as the review diff base in Step 4 regardless of what branch you are on.

### Step 1: Implement

Implement the requested changes.

### Step 2: Verify

Use the `$code-validation-fix` skill to verify and fix the changes.

### Step 3: Commit

Use the `$git-operations` skill to stage and commit the changes.

### Step 4: Code Review (Sub-Agent)

Spawn the `code-reviewer` agent (defined in `agents/code-reviewer.yaml`) with this context filled in from your implementation:

```
**Diff target:** <BASE_SHA..HEAD — the commits made during this implementation; if changes are uncommitted use "uncommitted">

**Original request:** <original request, verbatim or closely paraphrased>

**Key decisions made:**
- <decision and why>

**Constraints observed:**
- <AGENTS.md rules, backwards-compat requirements, patterns deliberately followed>
```

Using `BASE_SHA..HEAD` (the SHA recorded before implementation began) scopes the review to exactly what was changed in this task, even on stacked branches where `main...HEAD` would incorrectly include ancestor work.

Wait for the agent to return a result before proceeding to Step 5.

### Step 5: Incorporate Feedback

For each issue raised by the reviewer, use your full context from the implementation (the original request, decisions made, constraints observed) to judge its validity before acting:

- If the issue is clearly valid: apply a fix. Consider the reviewer's suggested fix, but reason independently — do not copy it blindly.
- If you are not confident the issue is real: skip it and note why.
- If the issue contradicts the original request or a deliberate implementation decision: skip it and note the reason.

### Step 6: Re-verify

Skip this step if Step 5 produced no changes (verification was already done in Step 2).

Otherwise, use the `$code-validation-fix` skill to verify and fix the changes.

### Step 7: Commit

Use the `$git-operations` skill to stage and commit the changes.

### Step 8: Summary

Report to the user:

- What was implemented
- Any review issues found, and whether each was applied or skipped (with reason)
- Final commit reference

Keep it brief.

## Guards

- If the sub-agent review is empty or unparseable, skip Steps 6–7 (changes already verified).
- Do not commit if any verification step fails.
