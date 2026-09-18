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

Before the first exploratory read, search, or command aimed at answering an
open question, say in one line what question you're trying to answer, then
stop and wait. This doesn't apply to a routine read needed to carry out
already-agreed work. The user may already know the answer.

### Verification

- Before starting work, state what "done" looks like: a test, a repro case,
  a before/after comparison, not just "make it work".
- For multi-step work, state the plan as numbered steps, each with its
  own verify step.

## Prose

Write plain language in the sense of ISO 24495-1: the intended reader
can find what they need, understand it, and use it. Five defaults
follow, each with its exception. Judge an edit by whether it serves the
reader, not by whether the text matches a pattern.

**Relevance.** Start from who reads the text and what they will do with
it. Keep what serves that use, and put the most important part first.

**Structure.** One topic per paragraph. Parallel items go in a list. Detail
that most readers skip moves to its own section or gets cut.

**Sentences.** One idea per sentence, usually under 20 words, with a
concrete subject doing the verb. Prefer the active voice unless the
actor is unknown or irrelevant. A dash or semicolon often joins two
ideas in one sentence: split the sentence when it does, keep the
punctuation when it does not.

**Words.** Prefer the plain word over the formal one, and the verb over its
noun form ("decide", not "make a decision"). Keep terms the reader
already knows. Explain or drop the rest.

**Concision.** Be concise without being cryptic, actively remove redundancy,
qualifiers and unnecessary details. Prefer shorter, simpler wording, but
stop before the text becomes unclear or incomplete.

These defaults apply throughout, including commit messages, code
comments, and documentation. For an on-demand review of existing text,
see the `plain-review` skill. For a review of a document's Diataxis
mode, see the `diataxis-review` skill.

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

For an on-demand check of existing commits, see the
`check-commit-messages` skill.

### Code comments

Default is no comment. In particular, never add a comment that only restates
the code.

Comments are only warranted for

- a workaround for an external bug
- a non-obvious external constraint
- a warning against an obvious-looking edit
- a subtle algorithm
- an invariant

The default is one sentence in the allowed cases.

Interface documentation is a separate category, exempt from the previous
defaults. Docstrings and public API comments must describe a contract in full.

For an on-demand check of an existing diff, see the `check-comments` skill.

## Code style

Structure code as a functional core, imperative shell: keep the core logic
pure, and push I/O, printing, and other side effects to the entry point
that calls into it.

Prefer immutable data and avoid mutating shared state. For example, build
a new collection with a comprehension rather than mutating an accumulator.

These are defaults for code written from scratch, not license to rewrite,
restyle, or refactor existing code that wasn't part of the task.
