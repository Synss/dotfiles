# claude

Global Claude Code config. `CLAUDE.md` is symlinked to `~/.claude/CLAUDE.md`.
`settings.json` is merged into `~/.claude/settings.json` by `just
sync-claude`, since Claude Code rewrites that file in place.

## Notes

- Edits to `CLAUDE.md` (here or `.claude/CLAUDE.md` at the repo root) are
  checked against the [`review-claude-md`](../.claude/skills/review-claude-md/SKILL.md)
  skill before committing.
