{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nix tools
    home-manager

    # misc.
    go-task
    graphviz
    jq
    just
    yq-go
    pre-commit
    prettier
    xxd
  ];
}
