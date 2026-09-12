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

Default is no comment. A comment must never only restate the code.

Comments are warranted only for:

- a workaround for an external bug
- a non-obvious external constraint
- a warning against an obvious-looking edit
- a subtle algorithm
- an invariant

Each of these defaults to one concise sentence.

## Current change

!`jj diff 2>/dev/null || git diff`

## Instructions

Check any new or changed comments in the diff against the rules above.

1. List each violation. Quote the offending comment and the rule it breaks.
   If there are none, say so and stop.
2. Fix each violation in the source file. Delete a comment that only
   restates the code. Otherwise, trim or rewrite it to satisfy the rule
   it breaks.
3. Re-run the diff check above. Confirm that none of the listed
   violations remain.
