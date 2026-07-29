# nix

Nix flake + Home Manager (standalone) managing terminal tools and configs.
The flake is at the repository root. This directory holds the modules it
imports, `home.nix` and one module per platform.

Every target resolves the configuration from `hostname -s`, which must be a key
in `machines` in `../flake.nix`.

## Notes

- The repository must be cloned to `~/src/dotfiles.git`. `dotfilesDir` in
  `../flake.nix` hardcodes it.
- `bootstrap` installs Nix if it is missing. Restart the shell and run it again.
- Configs are symlinked out of the store back into the repository, so edits
  apply without a rebuild. `~/.claude/settings.json` is copied instead, because
  Claude Code rewrites it in place. `sync-claude` copies it back.
- `packages/` holds derivations for packages that are not in nixpkgs. `update`
  bumps their version and hash against the npm registry.
- `scripts/` are installed as git subcommands.
