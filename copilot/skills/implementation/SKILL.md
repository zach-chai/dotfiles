---
name: implementation
description: End-to-end code implementation workflow with multi-agent review. Only invoke when explicitly referenced with /implementation.
disable-model-invocation: true
---

# Implementation

## Workflow

### Step 0: Branch Guard

Check the current branch with `git branch --show-current`.

If the current branch is `main` or `master`, invoke `$git-operations` Scenario A to create a feature branch before writing any code. Derive the branch name from the request (for example `feat/add-user-export`). Do not proceed until the branch is created.

If already on a feature branch, continue to Step 1.

Record the current HEAD SHA before any changes: `git rev-parse HEAD`. Store this as `BASE_SHA` — it will be used as the review diff base in Step 5 regardless of what branch you are on.

### Step 1: Implement

Implement the requested changes.

### Step 2: Live Verification

Use the `live-verifier` agent to confirm the implemented feature works correctly against the running dev stack. Pass a description of what was implemented and what to verify (the golden path and key edge cases).

If the agent surfaces failures:
- Fix the issue, then re-run live verification.
- If the stack is unreachable and the live-verifier agent was unable to restore it, investigate the error yourself, attempt a fix, and retry live verification. Only skip this step if the issue cannot be resolved — surface the error in the Step 9 summary if skipped.

### Step 3: Code Validation Fix

Launch the `test-runner` agent to verify and fix the changes.

### Step 4: Commit

Use the `$git-operations` skill to stage and commit the changes.

### Step 5: Code Review (Sub-Agent)

Spawn the `code-reviewer` agent with this context filled in from your implementation:

```
**Diff target:** <BASE_SHA..HEAD — the commits made during this implementation; if changes are uncommitted use "uncommitted">

**Original request:** <original request, verbatim or closely paraphrased>

**Key decisions made:**
- <decision and why>

**Constraints observed:**
- <CLAUDE.md rules, backwards-compat requirements, patterns deliberately followed>
```

Using `BASE_SHA..HEAD` (the SHA recorded before implementation began) scopes the review to exactly what was changed in this task, even on stacked branches where `main...HEAD` would incorrectly include ancestor work.

Wait for the agent to return a result before proceeding to Step 6.

### Step 6: Code Review Fix

For each issue raised by the reviewer, use your full context from the implementation (the original request, decisions made, constraints observed) to judge its validity before acting:

- If the issue is clearly valid: apply a fix. Consider the reviewer's suggested fix, but reason independently — do not copy it blindly.
- If you are not confident the issue is real: skip it and note why.
- If the issue contradicts the original request or a deliberate implementation decision: skip it and note the reason.

### Step 7: Re-verify

Skip this step if Step 6 produced no changes (validation was already done in Step 3).

Otherwise, launch the `test-runner` agent to verify and fix the changes.

### Step 8: Commit

Skip this step if Step 6 produced no changes (already committed in Step 4).

Otherwise, use the `$git-operations` skill to stage and commit the review fixes.

### Step 9: Summary

Report to the user:

- What was implemented
- Live verification result (passed / failed + fixed / skipped with reason)
- Any review issues found, and whether each was applied or skipped (with reason)
- Final commit reference

Keep it brief.

## Guards

- If the sub-agent review is empty or unparseable, skip Steps 6–8 (changes already verified and committed).
- Do not commit if any verification step fails.
