---
name: check-comments
description: Check the current diff against the code-comment rules below and fix violations
disable-model-invocation: true
allowed-tools: Bash(jj:*), Bash(git:*), Read, Edit
---

## Code comment rules

Default is no comment. In particular, a comment must never only restate
the code.

Comments are only warranted for

- a workaround for an external bug
- a non-obvious external constraint
- a warning against an obvious-looking edit
- a subtle algorithm
- an invariant

A comment in one of these cases defaults to one sentence.

Interface documentation is a separate category, exempt from the previous
defaults. Docstrings and public API comments must describe a contract in full.

## Current change

!`jj diff 2>/dev/null || git diff`

## Instructions

Check any new or changed comments in the diff against the rules above.

1. List each violation found, quoting the offending comment and the rule it
   breaks. If there are none, say so and stop.
2. Fix each violation directly in the source file: delete a comment that
   only restates the code; otherwise trim or rewrite it to satisfy the
   rule it breaks.
3. Re-run the diff check above. Confirm none of the listed violations
   remain.
