---
allowed-tools: Bash(git checkout -b:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(gh pr create:*)
description: Commit, push, and open a PR
model: haiku
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`

## Your task

Based on the above changes:
1. Create a new branch if on main (git checkout -b <branch-name>)
2. Create a single commit with an appropriate message (git commit -m "<message>")
3. Push the branch to origin (git push origin <branch-name>)
4. Create a pull request using `gh pr create` (gh pr create --base main --head <branch-name> --title "<title>" --body "<body>")
5. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
