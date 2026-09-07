{
  pkgs,
  config,
  stateVersion,
  username,
  homeDirectory,
  dotfilesDir,
  ...
}:
let
  mkLink = path: { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}"; };
in
{
  imports = [
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/jujutsu.nix
    ./modules/shell.nix
    ./modules/terminal.nix
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

    file = {
      ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
      ".claude/hooks" = mkLink "claude/hooks";
      ".claude/skills" = mkLink "claude/skills";
    };

  };
}
