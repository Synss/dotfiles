{
  pkgs,
  stateVersion,
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/jujutsu.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/claude.nix
  ];
  home = {
    inherit stateVersion username homeDirectory;

    packages = with pkgs; [
      # nix tools
      home-manager

      # terminal tools
      fd
      glow
      graphviz
      jq
      just
      yq-go
      pre-commit
      prettier
      ripgrep
      vivid
      xxd
      zsh

      # programming languages
      bazelisk
      nodejs
      pnpm
      rustup
      uv
    ];

  };
}
