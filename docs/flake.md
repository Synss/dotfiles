# Flake

Flakes provide `devShells` for multiple systems.

## Development environment

Set up default and `nix` dev shells with:

```nix
# flake.nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        # ...
      ];
    in
    {
      devShells = nixpkgs.lib.genAttrs systems (
        system: with nixpkgs.legacyPackages.${system}; {
          default = mkShell {
            packages = [
              ansible-lint
              # ...
            ];
          };

          nix = mkShell {
            packages = [
              nixfmt-tree
            ];
          };
        }
      );
    };
}
```

Auto-activate the default environment with `direnv`

```shell
# .envrc
use flake
```

and format `flake.nix` with `treefmt` inside the `nix` dev shell

```shell
$ nix develop .#nix --command treefmt flake.nix
```

Finally, optionally keep both configurations out of the VCS in `.gitignore` or
`.git/info/exclude`,

```shell
.envrc
flake.nix
```

## See Also

- `nix flake show` to list each dev shell.
