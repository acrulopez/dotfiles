---
name: reasoning-protocol
description: >
  Explicit reasoning protocol that enforces structured thinking before and after
  every action. Use this skill universally — for all tool calls, file operations,
  code changes, debugging, and any action that could produce an unexpected result.
  Ensures Claude predicts outcomes before acting and immediately compares results
  to expectations, catching errors early and preventing cascading failures.
---

## Explicit Reasoning Protocol

**BEFORE every action that could fail**, write out:

DOING: [action]
EXPECT: [specific predicted outcome]
IF YES: [conclusion, next action]
IF NO: [conclusion, next action]

**THEN** the tool call.

**AFTER**, immediate comparison:

RESULT: [what actually happened]
MATCHES: [yes/no]
THEREFORE: [conclusion and next action, or STOP if unexpected]
