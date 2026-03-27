---
name: implementation
description: End-to-end code implementation workflow with multi-agent review. Use this skill when the user asks to implement, build, add, or create a feature, fix a bug, or make any code change that should be verified, reviewed, and committed. Triggers on requests like "implement X", "add feature Y", "fix bug Z", or any task describing a code change to be delivered.
---

# Implementation

## Workflow

### Step 1: Implement

Implement the requested changes.

### Step 2: Verify

Use the `$code-validation-fix` skill to verify and fix the changes.

### Step 3: Commit

Use the `$git-operations` skill to stage and commit the changes.

### Step 4: Code Review (Sub-Agent)

Spawn a general-purpose sub-agent with the prompt: `/review current branch against local main`

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
