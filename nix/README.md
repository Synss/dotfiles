# nix

Nix flake + Home Manager, standalone. The flake is at the repository root; this
directory holds the modules it imports, `home.nix` plus one per platform.

Every target resolves the configuration from `hostname -s`, which must be a key
in `machines` (`../flake.nix`).

## Notes

- The repository must be cloned to `~/src/dotfiles.git`: `dotfilesDir` in
  `../flake.nix` hardcodes it.
- On a machine without Nix, `bootstrap` installs it and stops. Restart the
  shell and run it again.
- Configs are symlinked out of the store back into the repository, so edits
  apply without a rebuild. Exception: `~/.claude/settings.json` is copied, as
  Claude Code rewrites it in place — hence `sync-claude`.
- `packages/` holds derivations for what nixpkgs lacks. `update` bumps their
  version and hash against the npm registry, so no manual step is needed.
- `scripts/` are installed as git subcommands.
