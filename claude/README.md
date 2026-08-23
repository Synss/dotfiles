# claude

Global Claude Code config.

- `CLAUDE.md` is symlinked to `~/.claude/CLAUDE.md`.
- `hooks/` is symlinked to `~/.claude/hooks/`.
- `settings.json` is merged into `~/.claude/settings.json` by `just
  sync-claude`, since Claude Code rewrites that file in place.

## Plugins

Add [superpowers](https://claude.com/plugins/superpowers) from the official
plugins marketplace,
```
/plugin marketplace add git@github.com:anthropics/claude-plugins-official.git
/plugin install superpowers@claude-plugins-official
```
It self-activates via a `SessionStart` hook; re-trigger manually with
```
/using-superpowers
```

## Notes

- Edits to `CLAUDE.md` (here or `.claude/CLAUDE.md` at the repo root) are
  checked against the [`reviewing-claude-md`](../.claude/skills/reviewing-claude-md/SKILL.md)
  skill before committing.
