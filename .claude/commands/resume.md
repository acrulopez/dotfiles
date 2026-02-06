---
description: Read HANDOFF.md and continue the task from where the previous agent left off
---

## Handoff Document

!`cat HANDOFF.md 2>/dev/null || echo "ERROR: No HANDOFF.md found in the current directory."`

## Current State Verification

- Current branch: !`git branch --show-current`
- Git status: !`git status --short`

## Your Task

You are a fresh agent picking up a task mid-flight. The previous agent wrote HANDOFF.md (injected above) to get you up to speed.

Follow this process:

### 1. Understand Before Acting

Read the handoff document carefully. Then read every file listed in the "Key Files" section (or equivalent). Do NOT start writing code until you understand:
- What the goal is
- What was already tried and failed (so you don't repeat it)
- What's already in place and working
- What remains to be done

### 2. Verify the Handoff

The handoff may be stale or incomplete. Before trusting it, cross-check:
- Does the git state described in the handoff match the current git status above?
- Do the files mentioned actually exist and contain what the handoff claims?
- Are there any uncommitted changes or new files the handoff didn't mention?

If anything is inconsistent, tell the user what's different and ask how to proceed.

### 3. Present Your Plan

Before writing any code, briefly tell the user:
- What you understand the remaining work to be
- Your approach to completing it
- Any concerns or ambiguities you spotted

Wait for the user to confirm before proceeding.

### 4. Execute

Complete the remaining work. If you encounter something the handoff didn't prepare you for, pause and ask the user rather than guessing.

## Rules

- If HANDOFF.md is missing, stop immediately and tell the user. Do not improvise.
- Do NOT re-do work that the handoff says is already complete — verify it first, then build on it.
- Do NOT repeat approaches that the handoff explicitly marks as dead ends.
- If the handoff is vague or missing critical details, ask the user to fill in the gaps rather than assuming.
