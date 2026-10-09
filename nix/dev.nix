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
  minitest-ci = pkgs.buildRubyGem {
    inherit (pkgs) ruby;
    gemName = "minitest-ci";
    version = "3.4.0";
    source.sha256 = "sha256-nTJTmMRshnTWxGVIxs7+q46/Bp6zvabd8ZnOjK0BF8U=";
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    bats
    deadnix
    jujutsu # for *.bats
    jq # for *.bats
    just
    lua-language-server
    nixfmt
    nixfmt-tree
    perl # for justfile
    ripgrep # for tests/doc.bats
    rubocop
    (ruby.withPackages (ps: [
      minitest-ci
      ps.minitest
    ]))
    shellcheck
    shfmt
    statix
  ];
  BATS_LIB_PATH = "${batsLibs}";
}
