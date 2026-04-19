{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    deadnix
    just
    nixfmt-tree
    pre-commit
    shellcheck
    statix
    stylua
  ];
}
