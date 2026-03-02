---
name: create-branch
description: Create branches when the user asks to start new work on a branch or stack branch, including requests such as "create a branch", "start a new branch", or "make a branch".
---

# Create Branch

## Workflow

1. Run `gt create`.
2. Report the created branch name back to the user.
3. Stop after branch creation.

## Guards

- Do not stage files, commit changes, or submit stacks in this skill.
- Do not use `git checkout -b` or `git switch -c` unless the user explicitly requests plain git.
- If `gt create` fails, stop and report the error output without fallback.
