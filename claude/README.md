# claude

Global Claude Code config.

- `CLAUDE.md` is symlinked to `~/.claude/CLAUDE.md`.
- `hooks/` is symlinked to `~/.claude/hooks/`.
- `skills/` is symlinked to `~/.claude/skills/`.
- `settings.json` is merged into `~/.claude/settings.json` by `just
  sync-claude`, since Claude Code rewrites that file in place.

## Tests

`hooks/*.test.sh` test the hooks. `tests/skills/run.sh` tests the
`plain-review`, `check-commit-messages`, and `diataxis-review` skills
against fixtures in a scratch directory. `run.sh setup` prints the
slash commands to run by hand, `run.sh check` asserts the outcome, and
`run.sh run` does both through `claude -p`.

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
