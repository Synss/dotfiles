# Global Instructions

## Repo mechanics

- Resolve relative file paths the user gives you against the current
  working directory.
- Never push commits to a remote (`git push`, `jj git push`, `gh pr create`,
  or any command with that effect) unless explicitly asked to in that
  message. Don't ask whether to push, and don't seek confirmation again
  once asked.

### Version control

Check for a `.jj` directory before assuming a repo's VCS is git. If one
exists, jj is the source of truth, not git, even when `.git` is also
present (colocated).

- In a colocated repo, do not run mutating git commands. Use the jj equivalent
  instead.
- Read-only git commands (`status`, `diff`, `log`) are fine.

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
next, then wait for the user's go-ahead. A different flag, prompt, or wording
for the same hypothesis is not a new one.

Before the first exploratory read/search/command aimed at answering an open
question (not a routine read needed to carry out already-agreed work), say in
one line what question you're trying to answer, then stop and wait. The user
may already know the answer.

### Verification

- Before starting work, state what "done" looks like: a test, a repro case,
  a before/after comparison, not just "make it work".
- For multi-step work, state the plan as numbered steps, each with its
  own verify step.

## Prose

One idea per sentence, and one topic per paragraph. Use short, direct
sentences. Prefer plain language over formal or legalistic phrasing:
avoid repetition, nested clauses, and em dashes or semicolons.

Terse means concise, not compressed: cut words by removing redundancy and
simplifying wording, not by packing more logic into each sentence.

These rules apply throughout, including commit messages, code comments,
and documentation.

### Commit messages

A project convention overrides this one where it exists.

Base the message, subject and body alike, on the full diff being
committed, not on the latest addition to the diff.

Subject: a capitalized imperative sentence answering "what", under ~50
characters, no trailing period.

Body: optional, answers "why". No body is the default, not a fallback:
skip it for a purely mechanical or directly requested change, and don't
add a sentence merely to fill the field. A commit bundling several
independent fixes from one review pass has no single external fact
either: don't summarize the set of fixes as if it were one.

The reason must be an external fact: a bug, a constraint, or an observed
behavior, not a rationale for how the diff was drafted or a summary of the
discussion. For example, "tries X instead of Y, to see whether Z holds"
describes the discussion, not the change. A bug's root cause, a revert's
rationale, and a performance claim's numbers qualify.

Test each candidate sentence against the subject, the diff, and the
sentences before it, and drop it if any already states its fact. Wrap at
72 columns.

No trailing metadata (no Co-Authored-By, no issue refs) unless the user asks.

### Code comments

Default is no comment. Never add a comment that only restates the code.
Full rules and an on-demand check: `check-comments` skill.

## Code style

Structure code as a functional core, imperative shell: keep the core logic
pure, and push I/O, printing, and other side effects to the entry point
that calls into it.

Prefer immutable data and avoid mutating shared state. For example, build
a new collection with a comprehension rather than mutating an accumulator.

These are defaults for code written from scratch, not license to rewrite,
restyle, or refactor existing code that wasn't part of the task.
