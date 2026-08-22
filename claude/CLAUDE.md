# Global Instructions

## Repo mechanics

- When resolving relative file paths I give you, interpret them relative to
  the current working directory.
- Never push commits to a remote — via `git push`, `jj git push`,
  `gh pr create`, or any command with that effect — unless explicitly asked to
  in that message. Do not ask whether to push after making changes — treat
  pushing as out of scope unless requested. When explicitly asked, push
  without further confirmation.

### Version control

Check for a `.jj` directory before assuming a repo's VCS is git. If one exists,
jj is in use — even when `.git` is also present (colocated), jj is the source
of truth, not git.

- In a colocated repo, do not run mutating git commands (`add`, `rm`,
  `commit`, `checkout`, `reset`, `stash`) — use the jj equivalent.
- Read-only git commands (`status`, `diff`, `log`) are fine.

### Commit messages

A project convention overrides this one where it exists.

Subject: a capitalized imperative sentence answering "what", under ~50
characters, no trailing period.

Body: optional, answers "why". Test each sentence against the subject, the
diff, and the sentences before it. Drop it if any of those already state its
fact. A bug's root cause, a revert's rationale, and a performance claim's
numbers are the kind of fact this test keeps. When every sentence fails,
drop the body entirely. Wrap at 72 columns.

No trailing metadata (no Co-Authored-By, no issue refs) unless I ask.

## Working style

### Planning and implementation

When presenting or updating a plan, stop and wait for an explicit go-ahead
before implementing. A question or plan update is not a green light.

- If multiple interpretations of a request exist, present them instead of
  picking one silently.
- If a simpler approach exists than the one requested, say so before
  implementing.

### When you get stuck

Two failed hypotheses about the same problem: stop before trying a third.
Report what you tried, what you learned from each failure, and what you'd try
next — wait for my go-ahead. A different flag, prompt, or wording for the same
hypothesis is not a new one.

Before the first exploratory read/search/command aimed at answering an open
question (not a routine read needed to carry out already-agreed work), say in
one line what question you're trying to answer, then stop and wait — I may
already know the answer.

### Verification

- Before starting work, state what "done" looks like as a check — a test, a
  repro case, a before/after comparison — not just "make it work".
- For multi-step work, state a short plan as numbered steps, each with its
  own verify step.

## Writing

One idea per sentence, one sentence per idea. Applies to everything you write
for me — commit messages, code comments, documentation, and chat responses.

## Code comments

Default to one line. A comment that only restates the code should be deleted
rather than shortened.

Comment what a future editor could break without knowing: a non-obvious
external constraint, an invariant, a footgun, a usage hint. How the code came
to be written this way is history, and history goes in the commit message.

Interface documentation is a separate category, exempt from the one-line
default. Docstrings and public API comments describe a contract in full.

Longer comments are warranted for: a subtle algorithm, a workaround for an
external bug, a warning against an obvious-looking edit.
