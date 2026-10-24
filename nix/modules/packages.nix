{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nix tools
    home-manager

    # misc.
    colima # for docker
    docker
    docker-credential-helpers
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
    perl
    perlPackages.Carton
    pnpm
    ruby
    rustup
    uv
  ];
}
