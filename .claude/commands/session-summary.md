---
description: Summarize the current session and write it to .claude/sessions/
---

## Context Snapshot

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Recent commits on this branch: !`git log --oneline -10`
- Unstaged and staged diff: !`git diff HEAD`

## Your Task

Write a session summary file to `.claude/sessions/YYYY-MM-DD_descriptive-name.md`, where:
- `YYYY-MM-DD` is today's date
- `descriptive-name` is a short, kebab-case slug that captures the essence of the session (e.g., `fix-prisma-migration-deadlock`, `add-csv-export-endpoint`, `debug-flaky-ci-tests`)

Create the `.claude/sessions/` directory if it does not exist.

The file must follow this structure:

```
# <Title: concise description of what this session accomplished or addressed>

**Date:** YYYY-MM-DD
**Tags:** `tag1`, `tag2`, `tag3`

## TL;DR

2-3 sentences. What was the problem? What was the outcome? If someone reads nothing else, this should be enough.

## Problem

What triggered this session? Describe the symptom, error, or goal in enough detail that someone encountering the same issue would recognize it. Include actual error messages, stack traces, or reproduction steps if they were part of the session.

## Solution

What was done to resolve or address the problem? Be specific — include commands run, config changes made, code patterns applied. Use code blocks for anything technical. This section should be copy-pasteable by someone facing the same problem.

## What Didn't Work

For each dead end encountered:
- **Approach:** What was tried
- **Why it failed:** The specific reason (not just "it didn't work")

If nothing failed, write "Straight path — no dead ends."

## Key Decisions

Any non-obvious choices made during the session and the reasoning behind them. Skip this section entirely if the session was pure debugging with no design choices.

## Files Changed

List the key files that were created or modified, with a one-line explanation of what changed in each. Use the git context above to be accurate.

## Remaining Work

What is still unfinished or could be improved? If the session fully resolved everything, write "None — fully resolved."
```

### Tags Guidelines

Choose 3-7 tags from the session content. Tags should include:
- **Language/framework** (e.g., `typescript`, `python`, `react`, `dbt`)
- **Tool/service** (e.g., `prisma`, `docker`, `github-actions`, `postgres`)
- **Problem type** (e.g., `bug-fix`, `feature`, `refactor`, `performance`, `config`, `migration`, `flaky-test`)
- **Domain area** if applicable (e.g., `auth`, `api`, `frontend`, `ci-cd`, `database`)

## Rules

- Reflect on the ENTIRE session from the beginning, not just the most recent work.
- Be specific and concrete. Include actual error messages, file paths, and command outputs where they add value.
- The "What Didn't Work" section is the most valuable part for future reference. Do not skip or rush it.
- Do NOT include generic filler, motivational language, or vague statements like "this was a good learning experience."
- Do NOT fabricate or embellish. If you are unsure about something, say so.
- The quality bar: if you encountered this exact problem six months from now, would this document let you solve it in five minutes instead of two hours?
- Write the file and confirm to the user with the file path and a brief summary of what was captured.
