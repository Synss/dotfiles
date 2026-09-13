---
name: check-comments
description: Check the current diff's implementation comments against the comment rules. Skip docstrings, API doc blocks, and interface definitions.
disable-model-invocation: true
allowed-tools: Bash(jj:*), Bash(git:*), Read, Edit
---

## Scope and exclusions

This skill covers only implementation and block comments inside function
bodies.

The following are out of scope. Do not review, flag, or comment on them:

- language-native docstrings (e.g., Python `"""docstrings"""`)
- API documentation blocks (e.g., Rust `///`, Doxygen `/** ... */`, etc.)
- class, module, or function-level interface definitions

If a file's changes are only docstrings, skip it and report "No
implementation comments found."

## Code comment rules

The rules are the "Code comments" section of the global
`~/.claude/CLAUDE.md`, already in context. Its "Prose" section applies
to the wording of any comment that stays.

## Current change

!`jj diff 2>/dev/null || git diff`

## Instructions

Read each new or changed comment in the diff as its reader: the next
person editing this code, with the code in front of them and none of
today's context. Then check it against the rules above.

1. List each comment the rules do not warrant. Quote it and name the
   rule. If there are none, say so and stop.
2. Fix each one in the source file. Delete a comment that only restates
   the code. Otherwise, trim or rewrite it to satisfy the rule it
   breaks. A comment that fits none of the listed cases but that the
   reader would miss is a gap in the list, not a violation: keep it and
   say so in the report.
3. Re-run the diff check above. Confirm that none of the listed
   comments remain unfixed.
