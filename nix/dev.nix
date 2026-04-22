{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    deadnix
    just
    lua-language-server
    nixfmt-tree
    pre-commit
    shellcheck
    statix
  ];
}
