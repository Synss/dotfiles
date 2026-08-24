# Global Instructions

## Repo mechanics

- When resolving relative file paths the user gives you, interpret them
  relative to the current working directory.
- Never push commits to a remote — via `git push`, `jj git push`,
  `gh pr create`, or any command with that effect — unless explicitly asked to
  in that message. Do not ask whether to push after making changes. When
  explicitly asked, push without further confirmation.

### Version control

Check for a `.jj` directory before assuming a repo's VCS is git. If one exists,
jj — not git — is the source of truth, even when `.git` is also present
(colocated).

- In a colocated repo, do not run mutating git commands (`add`, `rm`,
  `commit`, `checkout`, `reset`, `stash`). Use the jj equivalent instead.
- Read-only git commands (`status`, `diff`, `log`) are fine.

### Commit messages

A project convention overrides this one where it exists.

Subject: a capitalized imperative sentence answering "what", under ~50
characters, no trailing period.

Body: optional, answers "why". Before writing one, ask whether there is a
"why" beyond the subject. A purely mechanical or directly requested change
has none. Test each candidate sentence against the subject, the diff, and
the sentences before it. Cut it if any of those already state its fact. A
bug's root cause, a revert's rationale, and a performance claim's numbers
are the kind of fact this test keeps. No body is the default outcome, not
a fallback: don't add a sentence just to fill the field. Wrap at 72
columns.

No trailing metadata (no Co-Authored-By, no issue refs) unless the user asks.

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
next — wait for the user's go-ahead. A different flag, prompt, or wording for
the same hypothesis is not a new one.

Before the first exploratory read/search/command aimed at answering an open
question (not a routine read needed to carry out already-agreed work), say in
one line what question you're trying to answer, then stop and wait. The user
may already know the answer.

### Verification

- Before starting work, state what "done" looks like as a check — a test, a
  repro case, a before/after comparison — not just "make it work".
- For multi-step work, state the plan as numbered steps, each with its
  own verify step.

## Writing

One idea per sentence, one sentence per idea. Applies to everything you write
for the user — commit messages, code comments, documentation, and chat
responses.

## Code comments

Default to one line. A comment that only restates the code should be deleted
rather than shortened.

Comment what a future editor could break without knowing: a non-obvious
external constraint, an invariant, a footgun, a usage hint. How the code came
to be written this way is history. It belongs in the commit message, not the
comment.

Interface documentation is a separate category, exempt from the one-line
default. Docstrings and public API comments describe a contract in full.

Longer comments are warranted for: a subtle algorithm, a workaround for an
external bug, a warning against an obvious-looking edit.
