# nix

Nix flake + Home Manager (standalone) managing terminal tools and configs.

## Usage

```sh
just update        # flake update + build + switch (full upgrade)
just build         # build without activating — catches evaluation errors before switching
just switch        # home-manager switch (requires DOTFILES_DIR, set by just)
just update-vim    # update vim submodules
```

First run (before `just` is on `$PATH`):

```sh
nix run nixpkgs#just -- switch
```

## Layout

```
flake.nix          # inputs, homeConfigurations keyed by hostname, devShell
flake.lock         # pinned nixpkgs + home-manager
home/
  default.nix      # imports common + linux/darwin
  common.nix       # packages and config (all platforms)
  linux.nix        # platform-specific config
  darwin.nix       # platform-specific config
```

## Linting

Tools come from the devShell (`nix develop ./nix`), pinned to `flake.lock`.

```sh
treefmt --ci nix/          # format check (nixfmt via nixfmt-tree)
statix check nix/          # lint
deadnix --fail nix/        # dead code
```
