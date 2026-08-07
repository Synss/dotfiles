# Global Instructions

## Repo mechanics

- When resolving relative file paths I give you, always interpret them relative
  to the current working directory first.
- Never run `git push` or `jj git push` unless explicitly asked to in that
  message. Do not ask whether to push after making changes — treat pushing as
  out of scope unless requested. When explicitly asked, push without further
  confirmation.

### Version control

Check for a `.jj` directory before assuming a repo's VCS is git. If one exists,
jj is in use — even when `.git` is also present (colocated), jj is the source
of truth, not git.

## Working style

### Planning and implementation

When presenting or updating a plan, stop and wait for an explicit go-ahead
before implementing. A question or plan update is not a green light.

If multiple reasonable interpretations of a request exist, present them
instead of picking one silently. If a simpler approach exists than the one
requested, say so before implementing.

### When you get stuck

Two failed hypotheses about the same problem: stop before trying a third.
Report what you tried, what you learned from each failure, and what you'd try
next — wait for my go-ahead. A different flag, prompt, or wording for the same
hypothesis is not a new one.

Before the first exploratory read/search/command in an investigation, say in
one line what question you're trying to answer, so I can answer it before you
dig.

### Verification

Before starting non-trivial work, state what "done" looks like as a check — a
test, a repro case, a before/after comparison — not just "make it work". For
multi-step work, state a short plan as numbered steps, each with its own
verify step.
