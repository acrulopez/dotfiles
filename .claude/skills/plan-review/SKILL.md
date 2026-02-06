---
name: plan-review
description: Orchestrates an iterative plan-review workflow where a planner creates a plan and a reviewer provides feedback until consensus
disable-model-invocation: false
allowed-tools: Task, Read, Write, Edit, Glob, Bash
---

# Iterative Plan-Review Workflow

You orchestrate a collaborative workflow between a planner and reviewer agent.

## Workflow Steps

### 1. Initialize
Parse the task description from $ARGUMENTS and set up the workflow:
- Create working directory: `.claude/workflows/plan-review-{timestamp}/`
- Initialize files:
  - `task.md` - Original task description
  - `plan-v1.md` - Will contain initial plan (initially empty, planner will write to it)
  - `feedback-v1.md` - Will contain reviewer feedback (initially empty, reviewer will write to it)
  - `conversation.md` - Tracks the full dialogue

### 2. Planning Phase
- Use Task tool to spawn `planner` subagent with subagent_type="planner"
- Provide the task context and full path to the plan file where it should write
- Prompt format: "Read the task description from: {taskFilePath}\n\nCreate a detailed implementation plan and write it to: {planFilePath}\n\n{Previous feedback if iteration > 1}"
- Wait for completion (run_in_background: false)

### 3. Review Phase
- Use Task tool to spawn `reviewer` subagent with subagent_type="reviewer"
- Provide the plan file path and feedback file path
- Prompt format: "Read the implementation plan from: {planFilePath}\n\nProvide your structured review feedback and write it to: {feedbackFilePath}\n\nRemember to include your verdict at the end: APPROVE | REQUEST_CHANGES | NEEDS_DISCUSSION"
- Wait for completion (run_in_background: false)

### 4. Iteration Loop
After each review:
- Read the feedback file to extract the reviewer's verdict
- Update conversation.md with the iteration summary
- Decision logic:
  - If verdict is **APPROVE**: Present final plan to user, show conversation.md link, end workflow successfully
  - If verdict is **REQUEST_CHANGES** or **NEEDS_DISCUSSION**:
    - Check iteration count (max 5 iterations)
    - If max reached: Present current plan, explain iterations exhausted, ask user for guidance
    - Otherwise: Increment version number, create new plan-v{N}.md and feedback-v{N}.md files
    - Spawn planner again with context: original task + all previous feedback history
    - Spawn reviewer again with the new plan
    - Repeat loop

### 5. Output
When workflow completes successfully:
- Present the final approved plan content to the user
- Provide full path to conversation.md showing complete dialogue history
- Summarize: number of iterations completed, key improvements made between versions

### 6. Error Handling
If a subagent fails:
- Log the error to conversation.md with timestamp
- Present error to user with context (which agent, which iteration)
- Ask user: "Would you like to: (1) Retry this step, (2) Skip to next iteration, or (3) Abort workflow?"
- Wait for user decision before proceeding

## Implementation Details

### Task Tool Usage
Spawn planner:
```
Task({
  subagent_type: "planner",
  description: "Create implementation plan",
  prompt: "Read the task from: {taskPath}\n\n{feedback_context}\n\nWrite your plan to: {planPath}",
  run_in_background: false
})
```

Spawn reviewer:
```
Task({
  subagent_type: "reviewer",
  description: "Review implementation plan",
  prompt: "Read the plan from: {planPath}\n\nWrite your structured feedback to: {feedbackPath}\n\nInclude verdict: APPROVE | REQUEST_CHANGES | NEEDS_DISCUSSION",
  run_in_background: false
})
```

### Verdict Extraction
Read the feedback file and search for the last line matching pattern: `Verdict:\s*(APPROVE|REQUEST_CHANGES|NEEDS_DISCUSSION)`

### Conversation Log Format
```markdown
# Plan-Review Session
**Started:** {timestamp}
**Task:** {brief description}

---

## Iteration 1
**Plan:** [plan-v1.md]({relative_path})
**Feedback:** [feedback-v1.md]({relative_path})
**Verdict:** REQUEST_CHANGES

Key feedback points:
- {summary of main concerns}

---

## Iteration 2
**Plan:** [plan-v2.md]({relative_path})
**Feedback:** [feedback-v2.md]({relative_path})
**Verdict:** APPROVE

---

## Final Outcome
✅ Approved after 2 iterations

**Key improvements:**
- {improvement 1}
- {improvement 2}

**Final plan:** [plan-v2.md]({relative_path})
```

## Usage
Invoke with: `/plan-review "Your task description here"`

Example: `/plan-review "Add user authentication to the Express API"`

## Configuration
- **Max iterations:** 5 (prevents infinite loops)
- **Subagent model:** Inherits from agent definitions (sonnet)
- **Working directory:** `.claude/workflows/plan-review-{timestamp}/`

## Success Criteria
The workflow succeeds when:
1. Reviewer provides APPROVE verdict
2. All iteration artifacts are preserved in workflow directory
3. Conversation.md contains complete history
4. User receives final approved plan

The workflow fails gracefully when:
1. Max iterations reached without approval (user gets latest plan + conversation history)
2. Subagent error occurs (user is prompted for next action)
3. User interrupts workflow (all artifacts preserved, can resume manually)
