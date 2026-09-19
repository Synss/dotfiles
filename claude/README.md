# claude

Global Claude Code config.

- `CLAUDE.md` is symlinked to `~/.claude/CLAUDE.md`.
- `hooks/` is symlinked to `~/.claude/hooks/`.
- `skills/<skill>` are symlinked to `~/.claude/skills/<skill>`.
- `settings.json` is merged into `~/.claude/settings.json` by `just
  sync-claude`, since Claude Code rewrites that file in place.

## Tests

`hooks/*.test.sh` test the hooks. `tests/skills/run.sh` runs one
suite per skill against fixtures in a scratch directory; see
[`tests/skills/README.md`](tests/skills/README.md) for the suite
layout and commands.

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
