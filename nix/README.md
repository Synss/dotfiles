# nix

Nix flake + Home Manager (standalone) managing terminal tools and configs.

## Usage

```sh
just update        # flake update + build + switch (full upgrade)
just build         # nix flake check — evaluates all outputs without building
just switch        # home-manager switch
```

First run (before `just` is on `$PATH`):

```sh
nix run nixpkgs#just -- switch
```

## Layout

```
flake.nix     # inputs, machines registry, homeConfigurations, devShell
flake.lock    # pinned nixpkgs + home-manager
home.nix      # packages and config (all platforms)
dev.nix       # devShell for pre-commit and the CI
linux.nix     # platform-specific config
darwin.nix    # platform-specific config
```
