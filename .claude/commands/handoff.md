---
description: Create a HANDOFF.md in the current directory capturing full context for the next agent to continue this task
---

## Context Snapshot

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`
- Recent commits on this branch: !`git log --oneline -10`
- Unstaged and staged diff: !`git diff HEAD`

## Your Task

Write a file called `HANDOFF.md` in the current working directory. This file must allow a completely fresh agent — with zero prior context — to pick up exactly where you left off and finish the task.

Write it as a clear, honest narrative from one engineer handing off to another. Do not pad or over-structure it. Be direct and specific.

The document MUST cover these areas (use your own judgment on section naming and flow):

### 1. The Goal
What is the original task? What does "done" look like? Include any constraints or requirements the user specified.

### 2. What Was Tried
Walk through your attempts chronologically. For each significant attempt:
- What approach did you take and why?
- What was the outcome?
- If it failed, include the actual error messages or unexpected behavior.

### 3. Dead Ends
Explicitly call out approaches that did NOT work so the next agent doesn't waste time repeating them. Explain *why* they failed, not just that they did.

### 4. What Worked
What progress has been made? What's already in place and should be kept?

### 5. Current State
- What is the codebase state right now?
- Which files were created, modified, or are relevant?
- Are there any uncommitted changes, temp files, or half-finished pieces?
- Include the git state from the context snapshot above — branch, modified files, and a summary of the diff.

### 6. What Remains
Describe what still needs to happen to complete the task. Write this as a narrative — the next agent should understand the path forward, not just a checklist.

### 7. Key Files
List the most important files the next agent should read first, with a one-line explanation of why each matters.

## Rules

- Be brutally honest. If something is broken, say so. If you're unsure about something, say so.
- Include actual error messages, command outputs, or code snippets when they help explain the situation.
- Do NOT include generic boilerplate, motivational language, or filler.
- The quality bar: if you read this file cold, could you finish the task without asking any questions? If not, add more detail.
- Write the file and confirm to the user what was captured.
