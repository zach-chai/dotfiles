---
name: git-operations
description: Handle git branch creation, staging, committing, and publishing when the user asks for git operations such as add/stage/commit/push or starting a branch.
---

# Git Operations

## Scenario Selection

1. Check repo state with `git status --short` and identify whether there are staged or unstaged changes.
2. Choose exactly one scenario below based on the user request and repo state.
3. Run only the steps in the selected scenario.

## Scenarios

### Scenario A: Create Branch Only (No Local Changes)

Use when the user asks to create a branch and there are no staged or unstaged changes.

1. Require an explicit branch name.
2. Run `gt create <branch_name> --no-interactive`.
3. Report the created branch name and command status.

### Scenario B: Create Branch and Commit Current Changes

Use when the user asks to create a branch and also commit current code changes.

1. Stage changes first with `git add` (for example `git add .`).
2. Run `gt create --no-interactive --ai` to generate the branch name and commit.
3. Report branch creation and commit status.

### Scenario C: Commit and Publish on Existing Branch

Use when the user asks to commit/push without requesting new branch creation.

1. Stage changes with `git add` if needed.
2. Commit with `oco -y`.
3. Submit/publish with `gt submit --no-interactive --stack --publish`.
4. Report commit and submit status.

## Guards

- Do not use `git checkout -b` or `git switch -c` unless the user explicitly requests plain git.
- Do not use `git commit` or `git push` unless the user explicitly requests plain git commands.
- When branch creation with no changes is requested but no branch name is provided, stop and ask for the branch name.
- If any command fails, stop and report the error output without fallback.
