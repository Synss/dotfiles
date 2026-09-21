{ pkgs, ... }:
let
  batsLibs = pkgs.linkFarm "bats-libs" {
    bats-assert = pkgs.fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-assert";
      rev = "v2.2.4";
      hash = "sha256-TmLCSYT9JyC09XxyfTa7Ls2aEFuwDkCiddwZxkg/8vc=";
    };
    bats-file = pkgs.fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-file";
      rev = "v0.4.0";
      hash = "sha256-NJzpu1fGAw8zxRKFU2awiFM2Z3Va5WONAD2Nusgrf4o=";
    };
    bats-support = pkgs.fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-support";
      rev = "v0.3.0";
      hash = "sha256-4N7XJS5XOKxMCXNC7ef9halhRpg79kUqDuRnKcrxoeo=";
    };
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    bats
    deadnix
    jujutsu # for deny-git-if-colocated.bats
    jq # for deny-git-if-colocated.bats
    just
    lua-language-server
    nixfmt-tree
    ripgrep # for tests/doc.bats
    shellcheck
    shfmt
    statix
  ];
  BATS_LIB_PATH = "${batsLibs}";
}
