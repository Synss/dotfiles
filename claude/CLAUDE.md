# Global Instructions

- When resolving relative file paths provided by the user, always interpret them relative to the current working directory first.
- Never run `git push` or any command that pushes to a remote repository.
  Do not ask about pushing. Do not suggest pushing. Treat pushing as out of
  scope entirely.

## Commit messages

Short imperative subject line only. No body unless strictly necessary for
non-obvious context. No trailing metadata (no Co-Authored-By, no issue refs) unless the user asks.

## Planning and implementation

When presenting or updating a plan, stop and wait for an explicit go-ahead
before implementing. A question or plan update is not a green light.
