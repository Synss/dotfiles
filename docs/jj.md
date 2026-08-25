# JJ

## Aliases

- `l`: Shorthand for `jj log`.
- `la`: `jj log -r all()`, showing every visible commit instead of
  `revsets.log`'s filtered default.
- `ld`: `jj log -T d`, using the `d` template alias for
  `builtin_log_detailed`.
- `tug`: `jj bookmark advance`, moving the closest bookmark to
  `revsets.bookmark-advance-to` (`closest_pushable(@)`).

### See Also

- `jj log --help`


## Revset aliases

- `by(x)`: Commits authored by a substring of `x`. For example,
  `jj log -r by("Alice")`.
- `pending()`: The current user's bookmarked commits not yet merged to
  trunk.
- `submitted()`: `pending()` bookmarks whose tip matches the remote.
- `wip()`: The current user's commits not yet merged to trunk, not
  under a bookmark.

### See Also

`jj help -k revsets | glow`, especially the Functions section.
