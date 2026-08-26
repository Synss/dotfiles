# API project notes

## General conventions (assume this is the global convention)

Subject: capitalized, imperative, under 50 characters, no trailing
period.

Body: optional, answers "why", wrapped at 72 columns.

Interface documentation is exempt from the one-line comment default.
Docstrings describe their contract in full, including edge cases the
one-liner style can't capture.

## Commit messages

Keep pull request diffs small enough to review in one sitting, as
enforced by the diff-size linter in CI.

Database-migration commits require a body describing the rollback
plan, overriding the optional-body convention above. The body is
exempt from the 72-column wrap so the rollback SQL can be pasted
verbatim.

A subject like `I fixed the bug` is too vague. Use `Fix off-by-one in
retry counter` instead.

## Linting

- Format code with `black`.
- Also run `ruff` for linting.
- Also run `mypy` for type-checking.

Linting is run automatically on every commit through a pre-commit hook.

## Retry policy

Retries default to 3 attempts, with exponential backoff starting at
200ms.

This backoff timing was tuned against the payments API's rate limits,
not a general guideline.

Retries cap at 5s and log the endpoint and status code on every
attempt.

## Style constraints

<constraints>
Line length: 88 characters (black default).
Import order: stdlib, third-party, local (isort profile).
Docstring style: Google format.
</constraints>
