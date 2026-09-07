{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nix tools
    home-manager

    # misc.
    graphviz
    jq
    just
    yq-go
    pre-commit
    prettier
    xxd

    # programming languages
    bazelisk
    nodejs
    pnpm
    rustup
    uv
  ];
}
