{
  pkgs,
  lib,
  config,
  stateVersion,
  username,
  homeDirectory,
  nix-index-database,
  dotfilesDir,
  ...
}:
let
  mkLink = path: { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}"; };
in
{
  imports = [
    nix-index-database.homeModules.nix-index
    ./modules/neovim.nix
    ./modules/git.nix
    ./modules/jujutsu.nix
  ];
  fonts.fontconfig.enable = true;
  home = {
    inherit stateVersion username homeDirectory;

    sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --hidden --exclude .venv";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      fastSyntaxHighlighting.enable = true;
      history = {
        path = "${config.home.homeDirectory}/.zsh_history";
        size = 50000;
        save = 50000;
        extended = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = false;
        append = true;
      };
      initContent =
        with lib;
        mkMerge [
          (mkBefore ''
            DOTFILES_ZSH="${dotfilesDir}/zsh"
          '')
          (mkOrder 550 ''
            fpath+=(${dotfilesDir}/zsh/completions)
          '')
          ''
            for f in ${dotfilesDir}/zsh/conf.d/*.zsh; do source "$f"; done
            () { for f; do source "$f"; done } ${dotfilesDir}/zsh/conf.d/*.local(N)
          ''
        ];
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index-database.comma.enable = true;

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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
