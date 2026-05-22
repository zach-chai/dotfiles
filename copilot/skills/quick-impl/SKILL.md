---
name: quick-impl
description: Streamlined implementation workflow — branch guard, implement, validate, commit, summarize. Skips live verification and code review. Use when explicitly referenced with /quick-impl.
disable-model-invocation: true
---

# Quick Implementation

Like the `implementation` skill but without live verification and code review steps. Use for small, low-risk changes where speed matters more than full review coverage.

## Workflow

### Step 0: Branch Guard

Check the current branch with `git branch --show-current`.

If the current branch is `main` or `master`, invoke `$git-operations` Scenario A to create a feature branch before writing any code. Derive the branch name from the request (for example `feat/add-user-export`). Do not proceed until the branch is created.

If already on a feature branch, continue to Step 1.

Record the current HEAD SHA before any changes: `git rev-parse HEAD`. Store this as `BASE_SHA`.

### Step 1: Implement

Implement the requested changes.

### Step 2: Code Validation Fix

Launch the `test-runner` agent to verify and fix the changes.

### Step 3: Commit

Use the `$git-operations` skill to stage and commit the changes.

### Step 4: Summary

Report to the user:

- What was implemented
- Validation result (passed / failed + fixed)
- Final commit reference

Keep it brief.

## Guards

- Do not commit if any validation step fails.
