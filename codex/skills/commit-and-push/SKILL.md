---
name: commit-and-push
description: Handle commit and publish requests when the user asks to commit code and push/publish changes, including phrases such as "commit and push this code" or "publish this stack".
---

# Commit And Push

## Workflow

1. Stage and commit with `oco`.
2. Submit with `gt submit --no-interactive --stack --publish`.
3. Report the resulting submit status to the user.

## Guards

- Do not create branches in this skill; use `create-branch` for branch creation.
- Do not use `git add`, `git commit`, or `git push` unless the user explicitly requests plain git commands.
- If there is no valid branch context for submission, stop and ask to run branch creation first.
- If any command fails, stop and report the error output without fallback.
