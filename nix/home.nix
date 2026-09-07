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
  ];
  fonts.fontconfig.enable = true;
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

      # fonts
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono

      # programming languages
      bazelisk
      nodejs
      pnpm
      rustup
      uv
    ];

    file = {
      ".config/dotfiles" = mkLink "shared";
      ".claude/CLAUDE.md" = mkLink "claude/CLAUDE.md";
      ".claude/hooks" = mkLink "claude/hooks";
      ".claude/skills" = mkLink "claude/skills";
    };

  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        terminal.shell = {
          program = "zsh";
          args = [ "-l" ];
        };
        font = {
          normal.family = "JetBrainsMono Nerd Font Mono";
          size = 12.0;
        };
      };
    };

    bat = {
      enable = true;
      config.style = "header-filename,header-filesize,rule";
    };

    tmux = {
      enable = true;
      prefix = "C-Space";
      mouse = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      escapeTime = 0;
      extraConfig = ''
        set -ga terminal-overrides ",*:Tc"
        bind C-Space send-prefix
      '';
      plugins = with pkgs.tmuxPlugins; [
        resurrect
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
      ];
    };

  };
}
